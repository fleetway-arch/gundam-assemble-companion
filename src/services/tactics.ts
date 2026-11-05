import type { TacticsCard } from '@/types/tactics';
import { API_BASE } from './api';

export interface TacticsRepository {
  listCards(): Promise<TacticsCard[]>;
}

export class ApiTacticsRepository implements TacticsRepository {
  async listCards(): Promise<TacticsCard[]> {
    const response = await fetch(`${API_BASE}/tactics-cards`);
    if (!response.ok) throw new Error(`Could not load tactics cards (${response.status}).`);
    return response.json() as Promise<TacticsCard[]>;
  }
}
