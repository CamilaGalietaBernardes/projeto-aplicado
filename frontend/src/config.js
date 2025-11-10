// src/config.js

let isDev = false;
try {

  isDev = Boolean(import.meta?.env?.DEV);
} catch {
  isDev = false;
}

const injectedApi =
  (typeof __API_URL__ !== "undefined" ? __API_URL__ : undefined) ||
  "http://localhost:5000";

export const API_URL = isDev ? "/api" : injectedApi;
