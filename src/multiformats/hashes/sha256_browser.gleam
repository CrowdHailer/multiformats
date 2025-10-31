import gleam/javascript/promise.{type Promise}
import multiformats/hashes

@external(javascript, "../../multiformats_ffi.mjs", "sha256BrowserDigest")
pub fn digest(_bytes: BitArray) -> Promise(hashes.Multihash) {
  panic as "sha256_browser.digest is only available in the browser"
}
