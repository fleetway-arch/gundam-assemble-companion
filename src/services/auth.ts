import { API_BASE } from './api';

export interface AuthUser {
  id: string;
  username: string;
  email: string;
}

interface AuthResponse {
  token: string;
  expiresAt: string;
  user: AuthUser;
}

const SESSION_KEY = 'assemble-auth-session';

export function getAuthToken(): string | null {
  return readSession()?.token ?? null;
}

export function getCurrentUser(): AuthUser | null {
  return readSession()?.user ?? null;
}

export function clearAuthSession() {
  window.localStorage.removeItem(SESSION_KEY);
}

export async function signup(username: string, email: string, password: string): Promise<AuthUser> {
  return authenticate('/auth/signup', { username, email, password });
}

export async function login(loginValue: string, password: string): Promise<AuthUser> {
  return authenticate('/auth/login', { login: loginValue, password });
}

async function authenticate(path: string, body: Record<string, string>): Promise<AuthUser> {
  const response = await fetch(`${API_BASE}${path}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });
  if (!response.ok) {
    throw new Error(await readError(response));
  }
  const result = (await response.json()) as AuthResponse;
  window.localStorage.setItem(SESSION_KEY, JSON.stringify({
    token: result.token,
    expiresAt: result.expiresAt,
    user: result.user,
  }));
  return result.user;
}

function readSession(): { token: string; expiresAt: string; user: AuthUser } | null {
  const stored = window.localStorage.getItem(SESSION_KEY);
  if (!stored) return null;
  try {
    const session = JSON.parse(stored) as { token?: string; expiresAt?: string; user?: AuthUser };
    if (!session.token || !session.expiresAt || !session.user || new Date(session.expiresAt) <= new Date()) {
      clearAuthSession();
      return null;
    }
    return session as { token: string; expiresAt: string; user: AuthUser };
  } catch {
    clearAuthSession();
    return null;
  }
}

async function readError(response: Response): Promise<string> {
  try {
    const body = (await response.json()) as { error?: string };
    if (body.error) return body.error;
  } catch {
    // Keep the HTTP status when the server did not return JSON.
  }
  return `Request failed (${response.status}).`;
}
