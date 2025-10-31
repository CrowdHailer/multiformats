import { BitArray } from "./gleam.mjs";

export async function sha256BrowserDigest(data) {
  const name = "SHA-256"
  const bytes = new Uint8Array(await crypto.subtle.digest(name, data.rawBuffer))
  return new BitArray(bytes)
}
