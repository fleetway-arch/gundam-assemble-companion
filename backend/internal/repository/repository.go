package repository

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"io/fs"
	"sort"

	"gundam-assemble-companion/backend/internal/model"
	"gundam-assemble-companion/backend/migrations"
	_ "modernc.org/sqlite"
)

type Repository interface {
	Close() error
	ListUnits(context.Context) ([]model.Unit, error)
	ListTacticsCards(context.Context) ([]model.TacticsCard, error)
	ListSquads(context.Context) ([]model.Squad, error)
	GetSquad(context.Context, string) (*model.Squad, error)
	UpsertSquad(context.Context, model.Squad) (model.Squad, error)
	DeleteSquad(context.Context, string) error
	GetSquadDeck(context.Context, string) (*model.SquadDeck, error)
	UpsertSquadDeck(context.Context, model.SquadDeck) (model.SquadDeck, error)
}

type SQLite struct {
	db *sql.DB
}

func NewSQLite(path string) (*SQLite, error) {
	db, err := sql.Open("sqlite", path)
	if err != nil {
		return nil, err
	}
	repo := &SQLite{db: db}
	if err := repo.migrate(); err != nil {
		db.Close()
		return nil, err
	}
	return repo, nil
}

func (r *SQLite) Close() error {
	return r.db.Close()
}

func (r *SQLite) migrate() error {
	files, err := migrations.SQLFiles()
	if err != nil {
		return err
	}
	sort.Strings(files)
	for _, name := range files {
		sqlText, err := fs.ReadFile(migrations.Files, name)
		if err != nil {
			return fmt.Errorf("read migration %s: %w", name, err)
		}
		if _, err := r.db.Exec(string(sqlText)); err != nil {
			return fmt.Errorf("apply migration %s: %w", name, err)
		}
	}
	return nil
}

func (r *SQLite) ListUnits(ctx context.Context) ([]model.Unit, error) {
	rows, err := r.db.QueryContext(ctx, `SELECT id, unit FROM units ORDER BY created_at, id`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	units := []model.Unit{}
	for rows.Next() {
		var unit model.Unit
		var rawUnit string
		if err := rows.Scan(&unit.ID, &rawUnit); err != nil {
			return nil, err
		}
		unit.Unit = json.RawMessage(rawUnit)
		units = append(units, unit)
	}
	return units, rows.Err()
}

func (r *SQLite) ListTacticsCards(ctx context.Context) ([]model.TacticsCard, error) {
	rows, err := r.db.QueryContext(ctx, `SELECT id, card FROM tactics_cards ORDER BY id`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	cards := []model.TacticsCard{}
	for rows.Next() {
		var card model.TacticsCard
		var rawCard string
		if err := rows.Scan(&card.ID, &rawCard); err != nil {
			return nil, err
		}
		card.Card = json.RawMessage(rawCard)
		cards = append(cards, card)
	}
	return cards, rows.Err()
}

func (r *SQLite) ListSquads(ctx context.Context) ([]model.Squad, error) {
	rows, err := r.db.QueryContext(ctx, `SELECT id, name, target_size, members FROM squads ORDER BY created_at, id`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	squads := []model.Squad{}
	for rows.Next() {
		var squad model.Squad
		var members string
		if err := rows.Scan(&squad.ID, &squad.Name, &squad.TargetSize, &members); err != nil {
			return nil, err
		}
		if err := json.Unmarshal([]byte(members), &squad.Members); err != nil {
			return nil, err
		}
		squads = append(squads, squad)
	}
	return squads, rows.Err()
}

func (r *SQLite) GetSquad(ctx context.Context, id string) (*model.Squad, error) {
	var squad model.Squad
	var members string
	err := r.db.QueryRowContext(ctx,
		`SELECT id, name, target_size, members FROM squads WHERE id = ?`, id,
	).Scan(&squad.ID, &squad.Name, &squad.TargetSize, &members)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if err := json.Unmarshal([]byte(members), &squad.Members); err != nil {
		return nil, err
	}
	return &squad, nil
}

func (r *SQLite) UpsertSquad(ctx context.Context, squad model.Squad) (model.Squad, error) {
	members, err := json.Marshal(squad.Members)
	if err != nil {
		return model.Squad{}, err
	}
	_, err = r.db.ExecContext(ctx, `
		INSERT INTO squads (id, name, target_size, members) VALUES (?, ?, ?, ?)
		ON CONFLICT(id) DO UPDATE SET
			name = excluded.name,
			target_size = excluded.target_size,
			members = excluded.members,
			updated_at = CURRENT_TIMESTAMP`,
		squad.ID, squad.Name, squad.TargetSize, members)
	return squad, err
}

func (r *SQLite) DeleteSquad(ctx context.Context, id string) error {
	if _, err := r.db.ExecContext(ctx, `DELETE FROM squad_decks WHERE squad_id = ?`, id); err != nil {
		return err
	}
	result, err := r.db.ExecContext(ctx, `DELETE FROM squads WHERE id = ?`, id)
	if err != nil {
		return err
	}
	return requireAffected(result)
}

func (r *SQLite) GetSquadDeck(ctx context.Context, squadID string) (*model.SquadDeck, error) {
	var deck model.SquadDeck
	var cardIDs, cardUnitLinks string
	err := r.db.QueryRowContext(ctx,
		`SELECT phases, card_ids, card_unit_links FROM squad_decks WHERE squad_id = ?`, squadID,
	).Scan(&deck.Phases, &cardIDs, &cardUnitLinks)
	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	if err := json.Unmarshal([]byte(cardIDs), &deck.CardIDs); err != nil {
		return nil, err
	}
	if err := json.Unmarshal([]byte(cardUnitLinks), &deck.CardUnitLinks); err != nil {
		return nil, err
	}
	deck.SquadID = squadID
	return &deck, nil
}

func (r *SQLite) UpsertSquadDeck(ctx context.Context, deck model.SquadDeck) (model.SquadDeck, error) {
	cardIDs, err := json.Marshal(deck.CardIDs)
	if err != nil {
		return model.SquadDeck{}, err
	}
	cardUnitLinks, err := json.Marshal(deck.CardUnitLinks)
	if err != nil {
		return model.SquadDeck{}, err
	}
	_, err = r.db.ExecContext(ctx, `
		INSERT INTO squad_decks (squad_id, phases, card_ids, card_unit_links)
		VALUES (?, ?, ?, ?)
		ON CONFLICT(squad_id) DO UPDATE SET
			phases = excluded.phases,
			card_ids = excluded.card_ids,
			card_unit_links = excluded.card_unit_links,
			updated_at = CURRENT_TIMESTAMP`,
		deck.SquadID, deck.Phases, cardIDs, cardUnitLinks)
	return deck, err
}

func requireAffected(result sql.Result) error {
	affected, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if affected == 0 {
		return fmt.Errorf("record not found")
	}
	return nil
}
