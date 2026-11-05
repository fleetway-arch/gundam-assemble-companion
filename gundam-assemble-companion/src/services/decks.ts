import type { SquadDeck } from '@/types/tactics';

// --- Deck repository ---------------------------------------------------------
// All deck data access goes through this interface. A Go REST API will replace
// the implementation later, so every method is async and the shapes match:
//   GET /api/squads/:id/deck -> getDeck(squadId)
//   PUT /api/squads/:id/deck -> saveDeck(squadId, { phases, cardIds })

export interface DeckRepository {
  getDeck(squadId: string): Promise<SquadDeck | null>;
  saveDeck(
    squadId: string,
    deck: Pick<SquadDeck, 'phases' | 'cardIds' | 'cardUnitLinks'>,
  ): Promise<SquadDeck>;
}

// --- API implementation ------------------------------------------------------

const API_BASE = (import.meta.env.VITE_API_URL ?? '/api').replace(/\/$/, '');

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const response = await fetch(`${API_BASE}${path}`, {
    headers: { 'Content-Type': 'application/json' },
    ...init,
  });
  if (!response.ok) {
    let message = `Request failed (${response.status}).`;
    try {
      const body = (await response.json()) as { error?: string };
      if (body.error) message = body.error;
    } catch {
      // Keep the HTTP status when the server did not return JSON.
    }
    throw new Error(message);
  }
  if (response.status === 204) return undefined as T;
  return response.json() as Promise<T>;
}

export class ApiDeckRepository implements DeckRepository {
  async getDeck(squadId: string): Promise<SquadDeck | null> {
    return request<SquadDeck | null>(`/squads/${encodeURIComponent(squadId)}/deck`);
  }

  async saveDeck(
    squadId: string,
    deck: Pick<SquadDeck, 'phases' | 'cardIds' | 'cardUnitLinks'>,
  ): Promise<SquadDeck> {
    return request<SquadDeck>(`/squads/${encodeURIComponent(squadId)}/deck`, {
      method: 'PUT',
      body: JSON.stringify(deck),
    });
  }
}

export const deckRepository = new ApiDeckRepository();
