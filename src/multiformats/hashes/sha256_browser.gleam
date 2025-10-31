import gleam/javascript/promise.{type Promise}
import multiformats/hashes

@external(javascript, "../../multiformats_ffi.mjs", "sha256BrowserDigest")
fn do_digest(_bytes: BitArray) -> Promise(BitArray) {
  panic as "sha256_browser.digest is only available in the browser"
}

pub fn digest(bytes) {
  use digest <- promise.map(do_digest(bytes))
  hashes.Multihash(hashes.Sha256, digest)
}
