import gleam/list
import gleam/string
import multiformats/base32

pub fn decode_test() {
  // RFC4648 test vectors
  // https://datatracker.ietf.org/doc/html/rfc4648#section-6
  let vectors = [
    #(<<"">>, ""),
    #(<<"f">>, "MY======"),
    #(<<"fo">>, "MZXQ===="),
    #(<<"foo">>, "MZXW6==="),
    #(<<"foob">>, "MZXW6YQ="),
    #(<<"fooba">>, "MZXW6YTB"),
    #(<<"foobar">>, "MZXW6YTBOI======"),
  ]

  list.each(vectors, fn(vector) {
    let #(bytes, encoded) = vector
    assert base32.decode(encoded) == bytes
    assert base32.decode(string.lowercase(encoded)) == bytes
    assert base32.decode(string.replace(encoded, "=", "")) == bytes
    assert base32.encode(bytes) == encoded
  })
}

pub fn invalid_text_is_an_error_test() {
  // Characters outside the alphabet.
  assert base32.try_decode("MY0=====") == Error(Nil)
  assert base32.try_decode("my!") == Error(Nil)
  // Lengths that do not encode whole bytes.
  assert base32.try_decode("M") == Error(Nil)
  assert base32.try_decode("MZX") == Error(Nil)
  assert base32.try_decode("MZXW6Y") == Error(Nil)
  assert base32.try_decode("MZXW6YTBM") == Error(Nil)
  assert base32.try_decode("MZXW6YTB") == Ok(<<"fooba">>)
}
