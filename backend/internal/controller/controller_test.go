package controller_test

import (
	"bytes"
	"crypto/sha256"
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"testing"

	"gundam-assemble-companion/backend/internal/controller"
	"gundam-assemble-companion/backend/internal/model"
	"gundam-assemble-companion/backend/internal/repository"
	"gundam-assemble-companion/backend/internal/router"
	_ "modernc.org/sqlite"
)

func setupControllerTest(t *testing.T) (*controller.Controller, *repository.SQLite) {
	t.Helper()
	path := filepath.Join(t.TempDir(), "test.db")
	repo, err := repository.NewSQLite(path)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = repo.Close() })

	db, err := sql.Open("sqlite", path)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { _ = db.Close() })
	_, err = db.Exec(`
		INSERT OR REPLACE INTO users (id, username, email, password_hash) VALUES
		('test-user', 'test-user', 'test@example.com', 'unused');
		INSERT OR REPLACE INTO sessions (token_hash, user_id, expires_at) VALUES
		(?, 'test-user', '2099-01-01T00:00:00Z');
		INSERT OR REPLACE INTO units (id, unit) VALUES
		('unit-in', '{"cardTags":["White Devil"],"signatureTitle":"Old Title","traits":[{"label":"Faction","value":"Earth Federation"}]}'),
		('unit-out', '{"cardTags":["Outside"],"signatureTitle":"Outside","traits":[]}');
		INSERT OR REPLACE INTO squads (id, user_id, name, target_size, members) VALUES
		('squad-test', 'test-user', 'Test Squad', 3, '["unit-in"]');
	`, fmt.Sprintf("%x", sha256.Sum256([]byte("test-token"))))
	if err != nil {
		t.Fatal(err)
	}
	for i := 0; i < 10; i++ {
		_, err = db.Exec(
			`INSERT OR REPLACE INTO tactics_cards (id, card) VALUES (?, ?)`,
			cardID(i), `{"id":"`+cardID(i)+`","name":"Card","requiredFaction":null,"requiredTrait":null,"signatureTitle":null}`,
		)
		if err != nil {
			t.Fatal(err)
		}
	}
	return controller.New(repo), repo
}

func cardID(i int) string {
	return "test-card-" + string(rune('0'+i))
}

func deckRequest(t *testing.T, deck model.SquadDeck) *http.Request {
	t.Helper()
	body, err := json.Marshal(deck)
	if err != nil {
		t.Fatal(err)
	}
	request := httptest.NewRequest(http.MethodPut, "/api/squads/squad-test/deck", bytes.NewReader(body))
	request.Header.Set("Authorization", "Bearer test-token")
	return request
}

func TestSquadDeckHandlerValidDeckSaves(t *testing.T) {
	controller, repo := setupControllerTest(t)
	deck := model.SquadDeck{Phases: 2, CardIDs: []string{
		"test-card-0", "test-card-1", "test-card-2", "test-card-3", "test-card-4",
		"test-card-5", "test-card-6", "test-card-7", "test-card-8",
	}, CardUnitLinks: map[string]string{}}
	response := httptest.NewRecorder()
	router.New(controller).ServeHTTP(response, deckRequest(t, deck))

	if response.Code != http.StatusOK {
		t.Fatalf("got status %d, body %s", response.Code, response.Body.String())
	}
	saved, err := repo.GetSquadDeck(t.Context(), "squad-test", "test-user")
	if err != nil {
		t.Fatal(err)
	}
	if saved == nil || len(saved.CardIDs) != 9 {
		t.Fatalf("expected saved nine-card deck, got %#v", saved)
	}
}

func TestSquadDeckHandlerInvalidDeckDoesNotSave(t *testing.T) {
	controller, repo := setupControllerTest(t)
	initial := model.SquadDeck{Phases: 2, CardIDs: []string{
		"test-card-0", "test-card-1", "test-card-2", "test-card-3", "test-card-4",
		"test-card-5", "test-card-6", "test-card-7", "test-card-8",
	}, CardUnitLinks: map[string]string{}}
	initialResponse := httptest.NewRecorder()
	router.New(controller).ServeHTTP(initialResponse, deckRequest(t, initial))
	if initialResponse.Code != http.StatusOK {
		t.Fatalf("initial save failed: %d", initialResponse.Code)
	}

	invalid := initial
	invalid.CardIDs = append([]string(nil), initial.CardIDs...)
	invalid.CardIDs[8] = "unknown"
	response := httptest.NewRecorder()
	router.New(controller).ServeHTTP(response, deckRequest(t, invalid))
	if response.Code != http.StatusBadRequest {
		t.Fatalf("got status %d, body %s", response.Code, response.Body.String())
	}
	saved, err := repo.GetSquadDeck(t.Context(), "squad-test", "test-user")
	if err != nil {
		t.Fatal(err)
	}
	if saved == nil || saved.CardIDs[8] != "test-card-8" {
		t.Fatalf("invalid request changed saved deck: %#v", saved)
	}
}

func TestSquadDeckHandlerRejectsUnitOutsideSquad(t *testing.T) {
	controller, _ := setupControllerTest(t)
	deck := model.SquadDeck{Phases: 2, CardIDs: []string{
		"test-card-0", "test-card-1", "test-card-2", "test-card-3", "test-card-4",
		"test-card-5", "test-card-6", "test-card-7", "test-card-8",
	}, CardUnitLinks: map[string]string{"test-card-0": "unit-out"}}
	response := httptest.NewRecorder()
	router.New(controller).ServeHTTP(response, deckRequest(t, deck))

	if response.Code != http.StatusBadRequest {
		t.Fatalf("got status %d, body %s", response.Code, response.Body.String())
	}
	if !bytes.Contains(response.Body.Bytes(), []byte("LINK_UNIT_NOT_IN_SQUAD")) {
		t.Fatalf("response does not identify link failure: %s", response.Body.String())
	}
}

func TestAuthSignupAndLogin(t *testing.T) {
	controller, _ := setupControllerTest(t)

	signup := httptest.NewRequest(http.MethodPost, "/api/auth/signup",
		bytes.NewBufferString(`{"username":"pilot-one","email":"pilot@example.com","password":"correct horse"}`))
	signupResponse := httptest.NewRecorder()
	router.New(controller).ServeHTTP(signupResponse, signup)
	if signupResponse.Code != http.StatusCreated {
		t.Fatalf("signup status %d, body %s", signupResponse.Code, signupResponse.Body.String())
	}
	var created struct {
		Token string `json:"token"`
		User  struct {
			Username string `json:"username"`
			Email    string `json:"email"`
		} `json:"user"`
	}
	if err := json.NewDecoder(signupResponse.Body).Decode(&created); err != nil {
		t.Fatal(err)
	}
	if created.Token == "" || created.User.Username != "pilot-one" || created.User.Email != "pilot@example.com" {
		t.Fatalf("unexpected signup response: %#v", created)
	}

	login := httptest.NewRequest(http.MethodPost, "/api/auth/login",
		bytes.NewBufferString(`{"login":"pilot@example.com","password":"correct horse"}`))
	loginResponse := httptest.NewRecorder()
	router.New(controller).ServeHTTP(loginResponse, login)
	if loginResponse.Code != http.StatusOK {
		t.Fatalf("login status %d, body %s", loginResponse.Code, loginResponse.Body.String())
	}

	wrongPassword := httptest.NewRequest(http.MethodPost, "/api/auth/login",
		bytes.NewBufferString(`{"login":"pilot-one","password":"wrong password"}`))
	wrongResponse := httptest.NewRecorder()
	router.New(controller).ServeHTTP(wrongResponse, wrongPassword)
	if wrongResponse.Code != http.StatusUnauthorized {
		t.Fatalf("wrong password status %d, body %s", wrongResponse.Code, wrongResponse.Body.String())
	}
}

func TestAuthSignupRejectsDuplicateIdentity(t *testing.T) {
	controller, _ := setupControllerTest(t)
	body := `{"username":"pilot-one","email":"pilot@example.com","password":"correct horse"}`
	first := httptest.NewRecorder()
	router.New(controller).ServeHTTP(first, httptest.NewRequest(http.MethodPost, "/api/auth/signup", bytes.NewBufferString(body)))
	second := httptest.NewRecorder()
	router.New(controller).ServeHTTP(second, httptest.NewRequest(http.MethodPost, "/api/auth/signup", bytes.NewBufferString(body)))
	if first.Code != http.StatusCreated || second.Code != http.StatusConflict {
		t.Fatalf("signup statuses: first=%d second=%d", first.Code, second.Code)
	}
}
