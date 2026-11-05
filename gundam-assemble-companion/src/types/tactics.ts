// Tactics card and deck types for the Tactics Deck feature.
// Framework-agnostic — mirrored in Go later.

export type TacticsCardType = 'attack' | 'command' | 'response';

export interface TacticsCard {
  id: string;
  cardNumber?: string;
  set?: string;
  name: string;
  type: TacticsCardType;
  tlCost: number | null;
  effectText: string;
  requiredTrait?: string | null;
  requiredFaction: string | null;
  signatureTitle: string | null;
  signatureUnitCardNumber: string | null;
  source: string;
  verified: boolean;
}

export interface SquadDeck {
  squadId: string;
  phases: number; // default 2
  cardIds: string[];
  cardUnitLinks?: Record<string, string>;
}

export type DeckErrorCode =
  | 'WRONG_COUNT'
  | 'DUPLICATE'
  | 'MISSING_SIGNATURE_UNIT'
  | 'MISSING_TRAIT'
  | 'MISSING_FACTION'
  | 'UNKNOWN_CARD';

export interface DeckError {
  code: DeckErrorCode;
  cardId?: string;
  message: string;
}

export interface DeckValidation {
  valid: boolean;
  requiredSize: number;
  errors: DeckError[];
}

// Tactics decks always contain exactly nine cards.
export function requiredDeckSize(phases: number): number {
  return 9;
}
