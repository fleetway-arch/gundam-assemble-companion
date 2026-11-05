package model

import "encoding/json"

type Unit struct {
	ID   string          `json:"id"`
	Unit json.RawMessage `json:"unit"`
}

type TacticsCard struct {
	ID   string          `json:"id"`
	Card json.RawMessage `json:"card"`
}

type Squad struct {
	ID         string   `json:"id"`
	Name       string   `json:"name"`
	TargetSize int      `json:"targetSize"`
	Members    []string `json:"members"`
}

type DeckValidationError struct {
	Code    string `json:"code"`
	CardID  string `json:"cardId,omitempty"`
	Message string `json:"message"`
}

type SquadDeck struct {
	SquadID       string            `json:"squadId"`
	Phases        int               `json:"phases"`
	CardIDs       []string          `json:"cardIds"`
	CardUnitLinks map[string]string `json:"cardUnitLinks"`
}
