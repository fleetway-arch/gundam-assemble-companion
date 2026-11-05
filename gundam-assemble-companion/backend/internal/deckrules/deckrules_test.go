package deckrules

import (
	"fmt"
	"testing"
)

func testCard(id string, changes func(*Card)) Card {
	card := Card{ID: id, Name: id}
	if changes != nil {
		changes(&card)
	}
	return card
}

func neutralCards(count int) []Card {
	cards := make([]Card, count)
	for i := range cards {
		cards[i] = testCard(fmt.Sprintf("n%d", i), nil)
	}
	return cards
}

func TestValidate(t *testing.T) {
	tests := []struct {
		name      string
		cardIDs   []string
		cards     []Card
		units     []Unit
		wantCodes []string
	}{
		{
			name:    "legal deck",
			cardIDs: []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8"},
			cards:   neutralCards(9),
		},
		{
			name:      "eight cards",
			cardIDs:   []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7"},
			cards:     neutralCards(9),
			wantCodes: []string{"WRONG_COUNT"},
		},
		{
			name:      "ten cards",
			cardIDs:   []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8", "n9"},
			cards:     neutralCards(10),
			wantCodes: []string{"WRONG_COUNT"},
		},
		{
			name:      "duplicate card",
			cardIDs:   []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n0"},
			cards:     neutralCards(9),
			wantCodes: []string{"DUPLICATE"},
		},
		{
			name:      "unknown card",
			cardIDs:   []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "missing"},
			cards:     neutralCards(8),
			wantCodes: []string{"UNKNOWN_CARD"},
		},
		{
			name:    "signature card without unit",
			cardIDs: []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "sig"},
			cards: append(neutralCards(8), testCard("sig", func(card *Card) {
				card.SignatureTitle = "White Devil"
			})),
			wantCodes: []string{"MISSING_SIGNATURE_UNIT"},
		},
		{
			name:    "trait card without matching unit",
			cardIDs: []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "trait"},
			cards: append(neutralCards(8), testCard("trait", func(card *Card) {
				card.RequiredTrait = "Newtype"
			})),
			wantCodes: []string{"MISSING_TRAIT"},
		},
		{
			name:    "faction card without matching unit",
			cardIDs: []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "faction"},
			cards: append(neutralCards(8), testCard("faction", func(card *Card) {
				card.RequiredFaction = "Earth Federation"
			})),
			wantCodes: []string{"MISSING_FACTION"},
		},
		{
			name:    "neutral card is legal without units",
			cardIDs: []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "n8"},
			cards:   neutralCards(9),
		},
		{
			name:    "all requirements must pass",
			cardIDs: []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "multi"},
			cards: append(neutralCards(8), testCard("multi", func(card *Card) {
				card.RequiredTrait = "Newtype"
				card.RequiredFaction = "Earth Federation"
			})),
			units:     []Unit{{Traits: []Trait{{Label: "Faction", Value: "Zeon"}}}},
			wantCodes: []string{"MISSING_TRAIT", "MISSING_FACTION"},
		},
	}

	for _, test := range tests {
		t.Run(test.name, func(t *testing.T) {
			errors := Validate(test.cardIDs, test.cards, test.units)
			if len(errors) != len(test.wantCodes) {
				t.Fatalf("got %d errors, want %d: %#v", len(errors), len(test.wantCodes), errors)
			}
			for i, code := range test.wantCodes {
				if errors[i].Code != code {
					t.Errorf("error %d: got %q, want %q", i, errors[i].Code, code)
				}
			}
		})
	}
}

func TestValidateUsesFirstCardTagForSignature(t *testing.T) {
	cardIDs := []string{"n0", "n1", "n2", "n3", "n4", "n5", "n6", "n7", "sig"}
	cards := append(neutralCards(8), testCard("sig", func(card *Card) {
		card.SignatureTitle = "First Tag"
	}))
	units := []Unit{{SignatureTitle: "Old Title", CardTags: []string{"First Tag", "Pilot"}}}

	if errors := Validate(cardIDs, cards, units); len(errors) != 0 {
		t.Fatalf("expected legal deck, got %#v", errors)
	}
}
