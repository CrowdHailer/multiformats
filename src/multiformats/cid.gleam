import gleam/dynamic.{type Dynamic}
import multiformats/hashes/digest.{type Digest}

pub type Cid

@external(javascript, "../multiformats_ffi.mjs", "cid_create_v1")
pub fn create_v1(codec: Int, multihash: Digest) -> Cid

@external(javascript, "../multiformats_ffi.mjs", "cid_to_string")
pub fn to_string(cid: Cid) -> String

@external(javascript, "../multiformats_ffi.mjs", "cid_decode")
pub fn decode(cid: Dynamic) -> Result(Cid, Nil)

@external(javascript, "../multiformats_ffi.mjs", "cid_parse")
pub fn parse(cid: String) -> Result(Cid, String)
