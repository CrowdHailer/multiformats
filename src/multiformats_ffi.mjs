import { Ok, Error } from "./gleam.mjs";
import { CID } from 'multiformats/cid'
import { sha256 } from 'multiformats/hashes/sha2'

export function code() {
  return dagJSON.code
}

export function sha256Digest(data) {
  return sha256.digest(data.buffer)
}

export function sha256BrowserDigest(data) {
  const result = sha256Digest(data)
  return result instanceof Promise ? result : new Promise((resolve) => resolve(result))
}

export function cid_create_v1(code, digest) {
  return CID.createV1(code, digest)
}

export function cid_to_string(cid) {
  return cid.toString()
}

export function cid_decode(raw) {
  if (raw instanceof CID) {
    return new Ok(raw)
  } else {
    return new Error()
  }
}

export function cid_parse(raw) {
  try {
    return new Ok(CID.parse(raw))
  } catch (error) {
    return new Error(`${error}`)
  }
}
