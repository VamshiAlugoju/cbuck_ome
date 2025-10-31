type StreamAuthorizationResult = {
  allowed: boolean; // Whether the request is authorized
  new_url?: string; // Possibly rewritten URL (e.g. for routing or CDN)
  lifetime?: number; // How long the authorization is valid, in milliseconds
  reason?: string;
};

export function omeAccessResponseBuilder(
  allowed: boolean,
  restParameters: Partial<Exclude<StreamAuthorizationResult, 'allowed'>> = {},
): StreamAuthorizationResult {
  return {
    allowed,
    ...restParameters,
  };
}
