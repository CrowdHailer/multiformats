//// This module only works on node
//// The *_browser module will work on node and browser using the WebCrypto API

import multiformats/hashes/digest.{type Digest}

@external(javascript, "../../multiformats_ffi.mjs", "sha256Digest")
pub fn digest(bytes: BitArray) -> Digest
