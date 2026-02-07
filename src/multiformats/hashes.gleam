import gleam/bit_array
import gleam/result.{try}
import multiformats/leb128

pub type Multihash {
  Multihash(algorithm: Algorithm, digest: BitArray)
}

pub type Algorithm {
  Sha256
}

pub fn name(algorithm) {
  case algorithm {
    Sha256 -> "sha2-256"
  }
}

pub fn code(algorithm) {
  case algorithm {
    Sha256 -> 0x12
  }
}

pub fn from_code(code) {
  case code {
    0x12 -> Ok(Sha256)
    _ -> Error(Nil)
  }
}

pub fn decode(buffer) {
  use #(code, buffer) <- try(leb128.decode(buffer))
  use algorithm <- try(from_code(code))
  use #(length, buffer) <- try(leb128.decode(buffer))
  case buffer {
    <<digest:bytes-size(length), rest:bytes>> ->
      Ok(#(Multihash(algorithm:, digest:), rest))
    _ -> Error(Nil)
  }
}

pub fn encode(hash) {
  let Multihash(algorithm:, digest:) = hash
  let code = code(algorithm)
  // code is alway positive
  let assert Ok(code) = leb128.encode(code)
  // length is always positive
  let assert Ok(length) = leb128.encode(bit_array.byte_size(digest))
  <<code:bits, length:bits, digest:bits>>
}
