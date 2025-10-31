import gleb128

// always unsigned
pub fn decode(buffer) {
  case gleb128.decode_unsigned(buffer) {
    Ok(#(value, consumed)) -> {
      let assert <<_:bytes-size(consumed), rest:bytes>> = buffer
      Ok(#(value, rest))
    }
    _ -> Error(Nil)
  }
}

pub fn encode(int) {
  gleb128.encode_unsigned(int)
}
