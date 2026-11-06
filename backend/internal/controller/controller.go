package controller

import (
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/mail"
	"strings"
	"time"

	"gundam-assemble-companion/backend/internal/auth"
	"gundam-assemble-companion/backend/internal/deckrules"
	"gundam-assemble-companion/backend/internal/model"
	"gundam-assemble-companion/backend/internal/repository"
)

type Controller struct {
	repo repository.Repository
}

type authRequest struct {
	Username string `json:"username"`
	Email    string `json:"email"`
	Login    string `json:"login"`
	Password string `json:"password"`
}

type authResponse struct {
	Token     string     `json:"token"`
	ExpiresAt time.Time  `json:"expiresAt"`
	User      model.User `json:"user"`
}

func (c *Controller) Signup(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		methodNotAllowed(w)
		return
	}
	var request authRequest
	if err := decodeJSON(r, &request); err != nil {
		writeErrorStatus(w, http.StatusBadRequest, err)
		return
	}
	request.Username = strings.ToLower(strings.TrimSpace(request.Username))
	request.Email = strings.ToLower(strings.TrimSpace(request.Email))
	if err := validateSignup(request); err != nil {
		writeErrorStatus(w, http.StatusBadRequest, err)
		return
	}
	passwordHash, err := auth.HashPassword(request.Password)
	if err != nil {
		writeError(w, err)
		return
	}
	userID, err := newID()
	if err != nil {
		writeError(w, err)
		return
	}
	user := model.User{ID: userID, Username: request.Username, Email: request.Email}
	if err := c.repo.CreateUser(r.Context(), user, passwordHash); err != nil {
		if errors.Is(err, repository.ErrUserExists) {
			writeErrorStatus(w, http.StatusConflict, errors.New("username or email is already registered"))
			return
		}
		writeError(w, err)
		return
	}
	response, err := c.createSession(r, user)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusCreated, response)
}

func (c *Controller) Login(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		methodNotAllowed(w)
		return
	}

	var request authRequest
	if err := decodeJSON(r, &request); err != nil {
		writeErrorStatus(w, http.StatusBadRequest, err)
		return
	}
	login := strings.TrimSpace(request.Login)
	if login == "" {
		login = request.Username
	}
	if login == "" {
		login = request.Email
	}
	login = strings.ToLower(login)
	if login == "" || request.Password == "" {
		writeErrorStatus(w, http.StatusBadRequest, errors.New("login and password are required"))
		return
	}
	user, passwordHash, err := c.repo.FindUserByLogin(r.Context(), login)
	if err != nil {
		writeErrorStatus(w, http.StatusUnauthorized, errors.New("invalid login or password"))
		return
	}
	valid, err := auth.VerifyPassword(passwordHash, request.Password)
	if err != nil {
		writeError(w, err)
		return
	}
	if !valid {
		writeErrorStatus(w, http.StatusUnauthorized, errors.New("invalid login or password"))
		return
	}
	response, err := c.createSession(r, user)
	if err != nil {
		writeError(w, err)
		return
	}
	writeJSON(w, http.StatusOK, response)
}

func (c *Controller) requireUser(w http.ResponseWriter, r *http.Request) (model.User, bool) {
	const prefix = "Bearer "
	header := r.Header.Get("Authorization")
	if !strings.HasPrefix(header, prefix) || strings.TrimSpace(strings.TrimPrefix(header, prefix)) == "" {
		writeErrorStatus(w, http.StatusUnauthorized, errors.New("authentication required"))
		return model.User{}, false
	}
	user, err := c.repo.FindUserBySession(r.Context(), strings.TrimSpace(strings.TrimPrefix(header, prefix)))
	if err != nil {
		writeErrorStatus(w, http.StatusUnauthorized, errors.New("authentication required"))
		return model.User{}, false
	}
	return user, true
}

func (c *Controller) createSession(r *http.Request, user model.User) (authResponse, error) {
	tokenBytes := make([]byte, 32)
	if _, err := rand.Read(tokenBytes); err != nil {
		return authResponse{}, err
	}
	token := hex.EncodeToString(tokenBytes)
	expiresAt := time.Now().UTC().Add(30 * 24 * time.Hour)
	if err := c.repo.CreateSession(r.Context(), token, user.ID, expiresAt); err != nil {
		return authResponse{}, err
	}
	return authResponse{Token: token, ExpiresAt: expiresAt, User: user}, nil
}

func newID() (string, error) {
	var bytes [16]byte
	if _, err := rand.Read(bytes[:]); err != nil {
		return "", fmt.Errorf("generate user id: %w", err)
	}
	return hex.EncodeToString(bytes[:]), nil
}

func validateSignup(request authRequest) error {
	if len(request.Username) < 3 || len(request.Username) > 32 {
		return errors.New("username must be between 3 and 32 characters")
	}
	for _, character := range request.Username {
		if (character < 'a' || character > 'z') &&
			(character < '0' || character > '9') &&
			character != '_' && character != '-' {
			return errors.New("username may contain only letters, numbers, underscores, and hyphens")
		}
	}
	parsedEmail, err := mail.ParseAddress(request.Email)
	if err != nil || parsedEmail.Address != request.Email || len(request.Email) > 254 {
		return errors.New("email must be valid")
	}
	if len(request.Password) < 8 || len(request.Password) > 128 {
		return errors.New("password must be between 8 and 128 characters")
	}
	return nil
}

func New(repo repository.Repository) *Controller {
	return &Controller{repo: repo}
}

func (c *Controller) Health(w http.ResponseWriter, _ *http.Request) {
	writeJSON(w, http.StatusOK, map[string]string{"status": "ok"})
}

func (c *Controller) Units(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		methodNotAllowed(w)
		return
	}
	rows, err := c.repo.ListUnits(r.Context())
	if err != nil {
		writeError(w, err)
		return
	}
	units := make([]map[string]any, 0, len(rows))
	for _, row := range rows {
		var unit map[string]any
		if err := json.Unmarshal(row.Unit, &unit); err != nil {
			writeError(w, err)
			return
		}
		unit["id"] = row.ID
		units = append(units, unit)
	}
	writeJSON(w, http.StatusOK, units)
}

func (c *Controller) TacticsCards(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		methodNotAllowed(w)
		return
	}
	rows, err := c.repo.ListTacticsCards(r.Context())
	if err != nil {
		writeError(w, err)
		return
	}
	cards := make([]map[string]any, 0, len(rows))
	for _, row := range rows {
		var card map[string]any
		if err := json.Unmarshal(row.Card, &card); err != nil {
			writeError(w, err)
			return
		}
		card["id"] = row.ID
		cards = append(cards, card)
	}
	writeJSON(w, http.StatusOK, cards)
}

func (c *Controller) Squads(w http.ResponseWriter, r *http.Request) {
	user, ok := c.requireUser(w, r)
	if !ok {
		return
	}
	switch r.Method {
	case http.MethodGet:
		squads, err := c.repo.ListSquads(r.Context(), user.ID)
		if err != nil {
			writeError(w, err)
			return
		}
		writeJSON(w, http.StatusOK, squads)
	case http.MethodPost, http.MethodPut:
		var squad model.Squad
		if err := decodeJSON(r, &squad); err != nil {
			writeErrorStatus(w, http.StatusBadRequest, err)
			return
		}
		if err := validateSquad(squad); err != nil {
			writeErrorStatus(w, http.StatusBadRequest, err)
			return
		}
		saved, err := c.repo.UpsertSquad(r.Context(), squad, user.ID)
		if err != nil {
			writeError(w, err)
			return
		}
		writeJSON(w, http.StatusOK, saved)
	default:
		methodNotAllowed(w)
	}
}

func (c *Controller) Squad(w http.ResponseWriter, r *http.Request) {
	user, ok := c.requireUser(w, r)
	if !ok {
		return
	}
	if strings.HasSuffix(r.URL.Path, "/deck") {
		c.squadDeck(w, r, user.ID)
		return
	}
	if r.Method != http.MethodDelete {
		methodNotAllowed(w)
		return
	}
	err := c.repo.DeleteSquad(r.Context(), strings.TrimPrefix(r.URL.Path, "/api/squads/"), user.ID)
	if err != nil {
		writeErrorStatus(w, http.StatusNotFound, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

func (c *Controller) SquadDeck(w http.ResponseWriter, r *http.Request) {
	user, ok := c.requireUser(w, r)
	if !ok {
		return
	}
	c.squadDeck(w, r, user.ID)
}

func (c *Controller) squadDeck(w http.ResponseWriter, r *http.Request, userID string) {
	squadID := strings.TrimSuffix(strings.TrimPrefix(r.URL.Path, "/api/squads/"), "/deck")
	if err := validateID(squadID); err != nil {
		writeErrorStatus(w, http.StatusBadRequest, err)
		return
	}

	switch r.Method {
	case http.MethodGet:
		deck, err := c.repo.GetSquadDeck(r.Context(), squadID, userID)
		if err != nil {
			writeError(w, err)
			return
		}
		writeJSON(w, http.StatusOK, deck)
	case http.MethodPut, http.MethodPost:
		var deck model.SquadDeck
		if err := decodeJSON(r, &deck); err != nil {
			writeErrorStatus(w, http.StatusBadRequest, err)
			return
		}
		deck.SquadID = squadID
		if err := validateSquadDeck(deck); err != nil {
			writeErrorStatus(w, http.StatusBadRequest, err)
			return
		}
		squad, err := c.repo.GetSquad(r.Context(), squadID, userID)
		if err != nil {
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal_server_error"})
			return
		}
		if squad == nil {
			writeJSON(w, http.StatusNotFound, map[string]string{"error": "squad_not_found"})
			return
		}
		units, cards, err := c.loadDeckData(r, squad)
		if err != nil {
			var missingUnit *missingUnitError
			if errors.As(err, &missingUnit) {
				writeJSON(w, http.StatusBadRequest, map[string]any{
					"error": "deck_invalid",
					"details": []model.DeckValidationError{{
						Code:    "SQUAD_UNIT_NOT_FOUND",
						Message: "Every unit in the squad must exist in the units data.",
					}},
				})
				return
			}
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal_server_error"})
			return
		}
		if errors := deckrules.Validate(deck.CardIDs, cards, units); len(errors) > 0 {
			writeJSON(w, http.StatusBadRequest, map[string]any{
				"error":   "deck_invalid",
				"details": errors,
			})
			return
		}
		if errors := deckrules.ValidateLinks(deck.CardIDs, deck.CardUnitLinks, units, cards); len(errors) > 0 {
			writeJSON(w, http.StatusBadRequest, map[string]any{
				"error":   "deck_invalid",
				"details": errors,
			})
			return
		}
		saved, err := c.repo.UpsertSquadDeck(r.Context(), deck, userID)
		if err != nil {
			writeJSON(w, http.StatusInternalServerError, map[string]string{"error": "internal_server_error"})
			return
		}
		writeJSON(w, http.StatusOK, saved)
	default:
		methodNotAllowed(w)
	}
}

func (c *Controller) loadDeckData(r *http.Request, squad *model.Squad) ([]deckrules.Unit, []deckrules.Card, error) {
	unitRows, err := c.repo.ListUnits(r.Context())
	if err != nil {
		return nil, nil, err
	}
	cardRows, err := c.repo.ListTacticsCards(r.Context())
	if err != nil {
		return nil, nil, err
	}
	unitMap := make(map[string]deckrules.Unit, len(unitRows))
	for _, row := range unitRows {
		var unit deckrules.Unit
		if err := json.Unmarshal(row.Unit, &unit); err != nil {
			return nil, nil, err
		}
		unit.ID = row.ID
		unitMap[row.ID] = unit
	}
	units := make([]deckrules.Unit, 0, len(squad.Members))
	for _, unitID := range squad.Members {
		unit, ok := unitMap[unitID]
		if !ok {
			return nil, nil, &missingUnitError{unitID: unitID}
		}
		units = append(units, unit)
	}
	cards := make([]deckrules.Card, 0, len(cardRows))
	for _, row := range cardRows {
		var card deckrules.Card
		if err := json.Unmarshal(row.Card, &card); err != nil {
			return nil, nil, err
		}
		card.ID = row.ID
		cards = append(cards, card)
	}
	return units, cards, nil
}

type missingUnitError struct {
	unitID string
}

func (e *missingUnitError) Error() string {
	return "missing squad unit: " + e.unitID
}

func decodeJSON(r *http.Request, destination any) error {
	decoder := json.NewDecoder(io.LimitReader(r.Body, 2<<20))
	decoder.DisallowUnknownFields()
	return decoder.Decode(destination)
}

func validateID(id string) error {
	if strings.TrimSpace(id) == "" {
		return errors.New("id is required")
	}
	return nil
}

func validateSquad(squad model.Squad) error {
	if err := validateID(squad.ID); err != nil {
		return err
	}
	if name := strings.TrimSpace(squad.Name); name == "" || len(name) > 40 {
		return errors.New("name must be between 1 and 40 characters")
	}
	if squad.TargetSize != 3 && squad.TargetSize != 5 {
		return errors.New("targetSize must be 3 or 5")
	}
	if squad.Members == nil {
		return errors.New("members must be an array")
	}
	return nil
}

func validateSquadDeck(deck model.SquadDeck) error {
	if err := validateID(deck.SquadID); err != nil {
		return err
	}
	if deck.Phases < 2 || deck.Phases > 4 {
		return errors.New("phases must be between 2 and 4")
	}
	if deck.CardIDs == nil {
		return errors.New("cardIds must be an array")
	}
	if deck.CardUnitLinks == nil {
		return errors.New("cardUnitLinks must be an object")
	}
	for _, cardID := range deck.CardIDs {
		if err := validateID(cardID); err != nil {
			return errors.New("cardIds must contain valid ids")
		}
	}
	for _, unitID := range deck.CardUnitLinks {
		if err := validateID(unitID); err != nil {
			return errors.New("cardUnitLinks must contain valid unit ids")
		}
	}
	return nil
}

func writeJSON(w http.ResponseWriter, status int, value any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(value)
}

func writeError(w http.ResponseWriter, err error) {
	writeErrorStatus(w, http.StatusInternalServerError, err)
}

func writeErrorStatus(w http.ResponseWriter, status int, err error) {
	writeJSON(w, status, map[string]string{"error": err.Error()})
}

func methodNotAllowed(w http.ResponseWriter) {
	w.Header().Set("Allow", "GET, POST, PUT, DELETE")
	w.WriteHeader(http.StatusMethodNotAllowed)
}
