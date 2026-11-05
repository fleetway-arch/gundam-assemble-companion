import { ApiTacticsRepository } from './tactics';
import { ApiDeckRepository } from './decks';

// --- Active repository exports ------------------------------------------------
// Switching to an HttpRepository later is a one-line change here.
// Components and hooks import from this module — never from the implementation
// classes directly.

export const tacticsRepository = new ApiTacticsRepository();
export const deckRepository = new ApiDeckRepository();

// --- ID helper ----------------------------------------------------------------

export function genTacticsId(): string {
  if (typeof crypto !== 'undefined' && 'randomUUID' in crypto) {
    return crypto.randomUUID();
  }
  return 'tc-' + Math.random().toString(36).slice(2) + Date.now().toString(36);
}
