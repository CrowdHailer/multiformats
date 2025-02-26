import gleam/javascript/promise.{type Promise}
import multiformats/hashes/digest.{type Digest}

@external(javascript, "../../multiformats_ffi.mjs", "sha256BrowserDigest")
pub fn digest(bytes: BitArray) -> Promise(Digest)
