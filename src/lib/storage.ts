import type { Unit, Squad } from '@/types/units';
import { API_BASE } from '@/services/api';
import { clearAuthSession, getAuthToken } from '@/services/auth';

export type BackendMode = 'api';

interface Repo {
  mode: BackendMode;
  loadUnits(): Promise<Unit[]>;
  loadSquads(): Promise<Squad[]>;
  saveSquad(squad: Squad): Promise<Squad>;
  deleteSquad(id: string): Promise<void>;
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const token = getAuthToken();
  const response = await fetch(`${API_BASE}${path}`, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...init?.headers,
    },
  });
  if (response.status === 401) clearAuthSession();
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

const apiRepo: Repo = {
  mode: 'api',
  loadUnits() {
    return request<Unit[]>('/units');
  },
  loadSquads() {
    return request<Squad[]>('/squads');
  },
  saveSquad(squad) {
    return request<Squad>('/squads', {
      method: 'PUT',
      body: JSON.stringify(squad),
    });
  },
  deleteSquad(id) {
    return request<void>(`/squads/${encodeURIComponent(id)}`, { method: 'DELETE' });
  },
};

export function getBackendMode(): BackendMode {
  return apiRepo.mode;
}

export async function probeBackend(): Promise<BackendMode> {
  await request<{ status: string }>('/health');
  return apiRepo.mode;
}

export const storage = apiRepo;

export function genId(): string {
  if (typeof crypto !== 'undefined' && 'randomUUID' in crypto) {
    return crypto.randomUUID();
  }
  return 'id-' + Math.random().toString(36).slice(2) + Date.now().toString(36);
}
