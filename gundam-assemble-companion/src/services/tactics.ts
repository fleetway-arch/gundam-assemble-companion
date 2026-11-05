import type { TacticsCard } from '@/types/tactics';

export interface TacticsRepository {
  listCards(): Promise<TacticsCard[]>;
}

const API_BASE = (import.meta.env.VITE_API_URL ?? '/api').replace(/\/$/, '');

export class ApiTacticsRepository implements TacticsRepository {
  async listCards(): Promise<TacticsCard[]> {
    const response = await fetch(`${API_BASE}/tactics-cards`);
    if (!response.ok) throw new Error(`Could not load tactics cards (${response.status}).`);
    return response.json() as Promise<TacticsCard[]>;
  }
}
