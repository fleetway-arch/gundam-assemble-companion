import type { DeckError, DeckValidation, SquadDeck, TacticsCard } from '@/types/tactics';
import { requiredDeckSize } from '@/types/tactics';
import type { Unit } from '@/types/units';

// Pure deck validation — no side effects, no framework imports.
// Can be mirrored in Go later.
//
// Rules enforced:
// 1. A deck has EXACTLY 9 cards.
// 2. Only one copy of each card per deck.
// 3. Signature cards require a squad unit with matching signatureTitle.
// 4. Trait cards require at least one squad unit with the required trait.
// 5. Faction cards require at least one squad unit with matching faction trait.
// 6. Unknown card ids in the deck are flagged.

function unitSignatureTitle(unit: Unit): string {
  return unit.cardTags?.[0] ?? unit.signatureTitle;
}

function squadRequirements(squadUnits: Unit[]) {
  const traits = new Set<string>();
  const factions = new Set<string>();
  const signatureTitles = new Set<string>();

  for (const unit of squadUnits) {
    const signatureTitle = unitSignatureTitle(unit);
    if (signatureTitle) signatureTitles.add(signatureTitle);
    for (const trait of unit.traits) {
      if (trait.value) traits.add(trait.value);
      if (trait.label.toLowerCase() === 'faction' && trait.value) factions.add(trait.value);
    }
  }

  return { traits, factions, signatureTitles };
}

export function validateDeck(
  deck: SquadDeck,
  cards: TacticsCard[],
  squadUnits: Unit[],
): DeckValidation {
  const reqSize = requiredDeckSize(deck.phases);
  const errors: DeckError[] = [];
  const cardMap = new Map<string, TacticsCard>();
  for (const c of cards) cardMap.set(c.id, c);

  const { traits, factions, signatureTitles } = squadRequirements(squadUnits);

  // Check duplicates and unknown cards first.
  const seen = new Set<string>();
  for (const cardId of deck.cardIds) {
    if (!cardMap.has(cardId)) {
      errors.push({
        code: 'UNKNOWN_CARD',
        cardId,
        message: `Unknown card "${cardId}" in deck.`,
      });
      continue;
    }
    if (seen.has(cardId)) {
      errors.push({
        code: 'DUPLICATE',
        cardId,
        message: `Card "${cardMap.get(cardId)?.name ?? cardId}" appears more than once.`,
      });
      // Don't re-check requirements for the duplicate
      continue;
    }
    seen.add(cardId);

    // Requirement checks for known, non-duplicate cards.
    const card = cardMap.get(cardId)!;
    if (card.signatureTitle && !signatureTitles.has(card.signatureTitle)) {
      errors.push({
        code: 'MISSING_SIGNATURE_UNIT',
        cardId,
        message: `Needs a unit with signature title "${card.signatureTitle}".`,
      });
    }
    if (card.requiredTrait && !traits.has(card.requiredTrait)) {
      errors.push({
        code: 'MISSING_TRAIT',
        cardId,
        message: `Needs a unit with trait "${card.requiredTrait}".`,
      });
    }
    if (card.requiredFaction && !factions.has(card.requiredFaction)) {
      errors.push({
        code: 'MISSING_FACTION',
        cardId,
        message: `Needs a unit with faction "${card.requiredFaction}".`,
      });
    }
  }

  // Check count.
  if (deck.cardIds.length !== reqSize) {
    errors.push({
      code: 'WRONG_COUNT',
      message: `Deck has ${deck.cardIds.length} cards; requires exactly ${reqSize}.`,
    });
  }

  return {
    valid: errors.length === 0,
    requiredSize: reqSize,
    errors,
  };
}

// Eligibility check for a single card given the squad — used to grey out
// ineligible cards in the picker. Returns null if eligible, or a reason string.
export function cardEligibilityReason(
  card: TacticsCard,
  squadUnits: Unit[],
): string | null {
  const { traits, factions, signatureTitles } = squadRequirements(squadUnits);

  if (card.signatureTitle && !signatureTitles.has(card.signatureTitle)) {
    return `Needs a unit with title ${card.signatureTitle}`;
  }
  if (card.requiredTrait && !traits.has(card.requiredTrait)) {
    return `Needs a unit with trait ${card.requiredTrait}`;
  }
  if (card.requiredFaction && !factions.has(card.requiredFaction)) {
    return `Needs a unit with faction ${card.requiredFaction}`;
  }
  return null;
}

// Find the signature Tactics card for a unit, if one exists in the card pool.
export function findSignatureCard(
  unit: Unit,
  cards: TacticsCard[],
): TacticsCard | null {
  return (
    cards.find(
      (c) =>
        c.signatureTitle === unit.signatureTitle &&
        (!c.signatureUnitCardNumber ||
          c.signatureUnitCardNumber === unit.unitCardNumber),
    ) ?? null
  );
}
