import gleam/int
import gleam/result.{try}
import gleam/string
import multiformats/base32
import multiformats/hashes
import multiformats/leb128

pub type Cid {
  Cid(content_type: Int, content: hashes.Multihash)
}

/// Convert a decoded CID to it's binary representation
pub fn to_bytes(cid) {
  let Cid(content_type, content) = cid
  let assert Ok(cid_version) = leb128.encode(1)
  // content types should be positive.
  // This table shows the latest declared values https://github.com/multiformats/multicodec/blob/master/table.csv
  let assert Ok(content_type) = leb128.encode(int.max(content_type, 0))
  let content = hashes.encode(content)
  <<cid_version:bits, content_type:bits, content:bits>>
}

/// Convert a decoded CID to it's string representation
pub fn to_string(cid) {
  let bytes = to_bytes(cid)
  let encoded =
    base32.encode(bytes) |> string.lowercase |> string.replace("=", "")
  "b" <> encoded
}

pub fn from_bytes(cid) {
  case cid {
    <<12, 20, _:bytes-size(32)>> -> Error("V0 cid")
    buffer -> {
      use #(version, buffer) <- try(
        leb128.decode(buffer)
        |> result.replace_error("Failed to decode CID version"),
      )
      use Nil <- try(case version == 1 {
        True -> Ok(Nil)
        False -> Error("not a version 1 CID")
      })
      use #(content_type, buffer) <- try(
        leb128.decode(buffer)
        |> result.replace_error("Failed to decode content-type"),
      )

      use #(multihash, buffer) <- try(
        hashes.decode(buffer)
        |> result.replace_error("Failed to decoded content hash"),
      )
      Ok(#(Cid(content_type, multihash), buffer))
    }
  }
}

pub fn from_string(cid) {
  use decoded <- try(case cid {
    "Qm" <> _rest ->
      case string.byte_size(cid) == 46 {
        True -> Error(" Decode V0 cid as base58btc and continue to step 2.")
        False -> Error("not v0 but also not a known encoding")
      }

    "b" <> rest -> Ok(base32.decode(rest))
    _ -> Error("unsuppoted multibase encoding")
  })
  from_bytes(decoded)
}
