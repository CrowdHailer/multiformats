import multiformats/hashes/digest.{type Digest}

@external(javascript, "../../multiformats_ffi.mjs", "digest")
pub fn digest(bytes: BitArray) -> Digest
