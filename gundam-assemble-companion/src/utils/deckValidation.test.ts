import { describe, it, expect } from 'vitest';
import { validateDeck } from '@/utils/deckValidation';
import { requiredDeckSize } from '@/types/tactics';
import type { SquadDeck, TacticsCard } from '@/types/tactics';
import type { Unit } from '@/types/units';

// --- Fixtures -----------------------------------------------------------------

function makeCard(id: string, overrides: Partial<TacticsCard> = {}): TacticsCard {
  return {
    id,
    name: id,
    type: 'attack',
    tlCost: 1,
    effectText: 'test',
    requiredFaction: null,
    signatureTitle: null,
    signatureUnitCardNumber: null,
    source: 'Seed',
    verified: false,
    ...overrides,
  };
}

function makeUnit(id: string, overrides: Partial<Unit> = {}): Unit {
  return {
    id,
    name: id,
    modelNumber: id,
    signatureTitle: '',
    unitCardNumber: id,
    startingTL: 1,
    hitPoints: 1,
    victoryPoints: 1,
    massProduced: false,
    traits: [],
    weapons: [],
    abilities: [],
    signatureTactics: '',
    verified: false,
    ...overrides,
  };
}

function makeDeck(cardIds: string[], phases = 2): SquadDeck {
  return { squadId: 'squad-1', phases, cardIds };
}

// A pool of 9 neutral cards to fill decks.
const neutralCards: TacticsCard[] = Array.from({ length: 9 }, (_, i) =>
  makeCard(`neu-${i}`, { name: `Neutral ${i}` }),
);

const gundamWhiteDevil = makeUnit('unit-gundam', {
  name: 'Gundam',
  signatureTitle: 'White Devil',
  unitCardNumber: 'GA-001',
  traits: [{ label: 'Faction', value: 'Earth Federation' }],
});

const gundamLegendaryHero = makeUnit('unit-gundam-2', {
  name: 'Gundam', // Same name, different title — signature matches on title
  signatureTitle: 'Legendary Hero',
  unitCardNumber: 'GA-099',
  traits: [{ label: 'Faction', value: 'Earth Federation' }],
});

const zakuZeon = makeUnit('unit-zaku', {
  name: "Char's Zaku II",
  signatureTitle: 'Red Comet',
  unitCardNumber: 'GA-002',
  traits: [{ label: 'Faction', value: 'Principality of Zeon' }],
});

// --- Tests --------------------------------------------------------------------

describe('requiredDeckSize', () => {
  it('is 9 for 2 phases', () => {
    expect(requiredDeckSize(2)).toBe(9);
  });
  it('stays 9 for 3 phases', () => {
    expect(requiredDeckSize(3)).toBe(9);
  });
  it('stays 9 for 4 phases', () => {
    expect(requiredDeckSize(4)).toBe(9);
  });
});

describe('validateDeck', () => {
  it('passes for exactly 9 valid neutral cards', () => {
    const deck = makeDeck(neutralCards.map((c) => c.id));
    const result = validateDeck(deck, neutralCards, []);
    expect(result.valid).toBe(true);
    expect(result.requiredSize).toBe(9);
    expect(result.errors).toHaveLength(0);
  });

  it('flags wrong count when fewer than 9', () => {
    const deck = makeDeck(neutralCards.slice(0, 6).map((c) => c.id));
    const result = validateDeck(deck, neutralCards, []);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'WRONG_COUNT')).toBe(true);
  });

  it('flags wrong count when more than 9', () => {
    const extra = makeCard('neu-extra');
    const deck = makeDeck([...neutralCards.map((c) => c.id), 'neu-extra']);
    const result = validateDeck(deck, [...neutralCards, extra], []);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'WRONG_COUNT')).toBe(true);
  });

  it('flags duplicate cards', () => {
    const ids = [...neutralCards.map((c) => c.id)];
    ids[8] = ids[0]; // duplicate
    const deck = makeDeck(ids);
    const result = validateDeck(deck, neutralCards, []);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'DUPLICATE')).toBe(true);
  });

  it('flags signature card when no matching unit title in squad', () => {
    const sigCard = makeCard('tc-sig', { signatureTitle: 'White Devil' });
    const cards = [...neutralCards.slice(0, 8), sigCard];
    const deck = makeDeck(cards.map((c) => c.id));
    // Squad has no unit with title "White Devil"
    const result = validateDeck(deck, cards, []);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'MISSING_SIGNATURE_UNIT')).toBe(true);
  });

  it('allows signature card when squad has matching title', () => {
    const sigCard = makeCard('tc-sig', { signatureTitle: 'White Devil' });
    const cards = [...neutralCards.slice(0, 8), sigCard];
    const deck = makeDeck(cards.map((c) => c.id));
    const result = validateDeck(deck, cards, [gundamWhiteDevil]);
    expect(result.valid).toBe(true);
  });

  it('signature title match is on title not unit name (two Gundams, different titles)', () => {
    // A signature card for "Legendary Hero" should NOT match a unit named "Gundam"
    // whose title is "White Devil", but SHOULD match a unit named "Gundam"
    // whose title is "Legendary Hero".
    const sigCard = makeCard('tc-sig', { signatureTitle: 'Legendary Hero' });
    const cards = [...neutralCards.slice(0, 8), sigCard];
    const deck = makeDeck(cards.map((c) => c.id));

    // Squad has Gundam with "White Devil" title only — should fail
    const resultWrong = validateDeck(deck, cards, [gundamWhiteDevil]);
    expect(resultWrong.valid).toBe(false);
    expect(
      resultWrong.errors.some((e) => e.code === 'MISSING_SIGNATURE_UNIT'),
    ).toBe(true);

    // Squad has Gundam with "Legendary Hero" title — should pass
    const resultRight = validateDeck(deck, cards, [gundamLegendaryHero]);
    expect(resultRight.valid).toBe(true);
  });

  it('flags faction card when no matching faction unit in squad', () => {
    const factionCard = makeCard('tc-fac', { requiredFaction: 'Earth Federation' });
    const cards = [...neutralCards.slice(0, 8), factionCard];
    const deck = makeDeck(cards.map((c) => c.id));
    // Empty squad
    const result = validateDeck(deck, cards, []);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'MISSING_FACTION')).toBe(true);
  });

  it('allows faction card when squad has matching faction', () => {
    const factionCard = makeCard('tc-fac', { requiredFaction: 'Earth Federation' });
    const cards = [...neutralCards.slice(0, 8), factionCard];
    const deck = makeDeck(cards.map((c) => c.id));
    const result = validateDeck(deck, cards, [gundamWhiteDevil]);
    expect(result.valid).toBe(true);
  });

  it('allows faction card when any unit matches (Zeon)', () => {
    const factionCard = makeCard('tc-fac', { requiredFaction: 'Principality of Zeon' });
    const cards = [...neutralCards.slice(0, 8), factionCard];
    const deck = makeDeck(cards.map((c) => c.id));
    const result = validateDeck(deck, cards, [zakuZeon]);
    expect(result.valid).toBe(true);
  });

  it('flags unknown card ids', () => {
    const deck = makeDeck([...neutralCards.slice(0, 8).map((c) => c.id), 'does-not-exist']);
    const result = validateDeck(deck, neutralCards, []);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'UNKNOWN_CARD')).toBe(true);
  });

  it('rejects a 12-card deck even in a 3-phase game', () => {
    const extraCards = Array.from({ length: 3 }, (_, i) => makeCard(`neu-extra-${i}`));
    const allCards = [...neutralCards, ...extraCards];
    const deck = makeDeck(allCards.map((c) => c.id), 3);
    const result = validateDeck(deck, allCards, []);
    expect(result.requiredSize).toBe(9);
    expect(result.valid).toBe(false);
    expect(result.errors.some((e) => e.code === 'WRONG_COUNT')).toBe(true);
  });

  it('allows a 9-card deck when phases is 3', () => {
    const deck = makeDeck(neutralCards.map((c) => c.id), 3);
    const result = validateDeck(deck, neutralCards, []);
    expect(result.valid).toBe(true);
    expect(result.requiredSize).toBe(9);
  });

  it('neutral cards have no requirement', () => {
    const deck = makeDeck(neutralCards.map((c) => c.id));
    // No squad units at all — should still be valid
    const result = validateDeck(deck, neutralCards, []);
    expect(result.valid).toBe(true);
  });

  it('uses the first card tag as the unit signature title', () => {
    const sigCard = makeCard('tc-sig', { signatureTitle: 'First Tag' });
    const cards = [...neutralCards.slice(0, 8), sigCard];
    const deck = makeDeck(cards.map((c) => c.id));
    const unit = makeUnit('tagged-unit', {
      signatureTitle: 'Stale Signature Title',
      cardTags: ['First Tag', 'Pilot', 'Faction'],
    });

    expect(validateDeck(deck, cards, [unit]).valid).toBe(true);
  });

  it('requires a matching trait value', () => {
    const traitCard = makeCard('tc-trait', { requiredTrait: 'Newtype' });
    const cards = [...neutralCards.slice(0, 8), traitCard];
    const deck = makeDeck(cards.map((c) => c.id));
    const unit = makeUnit('newtype-unit', {
      traits: [{ label: 'Ability', value: 'Newtype' }],
    });

    expect(validateDeck(deck, cards, [unit]).valid).toBe(true);
  });
});
