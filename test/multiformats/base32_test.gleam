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
