package deckrules

import "fmt"

const requiredDeckSize = 9

type Trait struct {
	Label string `json:"label"`
	Value string `json:"value"`
}

type Unit struct {
	ID             string   `json:"id"`
	CardTags       []string `json:"cardTags"`
	SignatureTitle string   `json:"signatureTitle"`
	Traits         []Trait  `json:"traits"`
}

type Card struct {
	ID              string `json:"id"`
	Name            string `json:"name"`
	RequiredTrait   string `json:"requiredTrait"`
	RequiredFaction string `json:"requiredFaction"`
	SignatureTitle  string `json:"signatureTitle"`
}

type Error struct {
	Code    string `json:"code"`
	CardID  string `json:"cardId,omitempty"`
	Message string `json:"message"`
}

func Validate(cardIDs []string, cards []Card, squadUnits []Unit) []Error {
	cardMap := make(map[string]Card, len(cards))
	for _, card := range cards {
		cardMap[card.ID] = card
	}

	requirements := buildRequirements(squadUnits)
	seen := make(map[string]struct{}, len(cardIDs))
	var errors []Error
	for _, cardID := range cardIDs {
		card, ok := cardMap[cardID]
		if !ok {
			errors = append(errors, Error{
				Code:    "UNKNOWN_CARD",
				CardID:  cardID,
				Message: fmt.Sprintf(`Unknown card "%s" in deck.`, cardID),
			})
			continue
		}
		if _, ok := seen[cardID]; ok {
			errors = append(errors, Error{
				Code:    "DUPLICATE",
				CardID:  cardID,
				Message: fmt.Sprintf(`Card "%s" appears more than once.`, cardName(card)),
			})
			continue
		}
		seen[cardID] = struct{}{}
		errors = append(errors, missingRequirements(card, requirements, cardID)...)
	}

	if len(cardIDs) != requiredDeckSize {
		errors = append(errors, Error{
			Code:    "WRONG_COUNT",
			Message: fmt.Sprintf("Deck has %d cards; requires exactly %d.", len(cardIDs), requiredDeckSize),
		})
	}
	return errors
}

func ValidateCardForUnit(card Card, unit Unit) []Error {
	return missingRequirements(card, buildRequirements([]Unit{unit}), card.ID)
}

func ValidateLinks(cardIDs []string, links map[string]string, squadUnits []Unit, cards []Card) []Error {
	cardSet := make(map[string]struct{}, len(cardIDs))
	for _, cardID := range cardIDs {
		cardSet[cardID] = struct{}{}
	}
	unitMap := make(map[string]Unit, len(squadUnits))
	for _, unit := range squadUnits {
		unitMap[unit.ID] = unit
	}
	cardMap := make(map[string]Card, len(cards))
	for _, card := range cards {
		cardMap[card.ID] = card
	}

	var errors []Error
	for cardID, unitID := range links {
		if _, ok := cardSet[cardID]; !ok {
			errors = append(errors, Error{
				Code:    "LINK_CARD_NOT_IN_DECK",
				CardID:  cardID,
				Message: "Linked card is not in the deck.",
			})
			continue
		}
		unit, ok := unitMap[unitID]
		if !ok {
			errors = append(errors, Error{
				Code:    "LINK_UNIT_NOT_IN_SQUAD",
				CardID:  cardID,
				Message: "Linked unit is not a member of this squad.",
			})
			continue
		}
		card, ok := cardMap[cardID]
		if !ok {
			continue
		}
		if requirementErrors := ValidateCardForUnit(card, unit); len(requirementErrors) > 0 {
			errors = append(errors, Error{
				Code:    "LINK_CARD_NOT_ASSOCIATED",
				CardID:  cardID,
				Message: "Linked card is not legally associated with the linked unit.",
			})
		}
	}
	return errors
}

type squadRequirements struct {
	traits          map[string]struct{}
	factions        map[string]struct{}
	signatureTitles map[string]struct{}
}

func buildRequirements(units []Unit) squadRequirements {
	requirements := squadRequirements{
		traits:          make(map[string]struct{}),
		factions:        make(map[string]struct{}),
		signatureTitles: make(map[string]struct{}),
	}
	for _, unit := range units {
		signatureTitle := unit.SignatureTitle
		if len(unit.CardTags) > 0 {
			signatureTitle = unit.CardTags[0]
		}
		if signatureTitle != "" {
			requirements.signatureTitles[signatureTitle] = struct{}{}
		}
		for _, trait := range unit.Traits {
			if trait.Value != "" {
				requirements.traits[trait.Value] = struct{}{}
			}
			if trait.Label == "Faction" || equalFold(trait.Label, "faction") {
				if trait.Value != "" {
					requirements.factions[trait.Value] = struct{}{}
				}
			}
		}
	}
	return requirements
}

func missingRequirements(card Card, requirements squadRequirements, cardID string) []Error {
	var errors []Error
	if card.SignatureTitle != "" {
		if _, ok := requirements.signatureTitles[card.SignatureTitle]; !ok {
			errors = append(errors, Error{
				Code:    "MISSING_SIGNATURE_UNIT",
				CardID:  cardID,
				Message: fmt.Sprintf(`Needs a unit with signature title "%s".`, card.SignatureTitle),
			})
		}
	}
	if card.RequiredTrait != "" {
		if _, ok := requirements.traits[card.RequiredTrait]; !ok {
			errors = append(errors, Error{
				Code:    "MISSING_TRAIT",
				CardID:  cardID,
				Message: fmt.Sprintf(`Needs a unit with trait "%s".`, card.RequiredTrait),
			})
		}
	}
	if card.RequiredFaction != "" {
		if _, ok := requirements.factions[card.RequiredFaction]; !ok {
			errors = append(errors, Error{
				Code:    "MISSING_FACTION",
				CardID:  cardID,
				Message: fmt.Sprintf(`Needs a unit with faction "%s".`, card.RequiredFaction),
			})
		}
	}
	return errors
}

func cardName(card Card) string {
	if card.Name != "" {
		return card.Name
	}
	return card.ID
}

func equalFold(left, right string) bool {
	if len(left) != len(right) {
		return false
	}
	for i := range left {
		a, b := left[i], right[i]
		if a >= 'A' && a <= 'Z' {
			a += 'a' - 'A'
		}
		if b >= 'A' && b <= 'Z' {
			b += 'a' - 'A'
		}
		if a != b {
			return false
		}
	}
	return true
}
