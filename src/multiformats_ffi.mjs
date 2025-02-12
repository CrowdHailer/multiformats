import { CID } from 'multiformats/cid'
import { sha256 } from 'multiformats/hashes/sha2'

export function code() {
  return dagJSON.code
}

export function digest(data) {
  return sha256.digest(data.buffer)
}

export function cid_create_v1(code, digest) {
  return CID.createV1(code, digest)
}

export function cid_to_string(cid) {
  return cid.toString()
}