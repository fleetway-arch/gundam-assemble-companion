const configuredApiUrl = import.meta.env.VITE_API_URL?.trim();

export const API_BASE = configuredApiUrl
  ? `${configuredApiUrl.replace(/\/+$/, '')}/api`.replace(/\/api\/api$/, '/api')
  : '/api';
