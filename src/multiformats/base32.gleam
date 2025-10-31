import gleam/bit_array

@external(erlang, "multiformats_ffi", "decode32")
pub fn decode(encoded: String) -> BitArray {
  do_decode(bit_array.from_string(encoded))
}

fn do_decode(encoded) {
  case encoded {
    <<>> -> <<>>
    <<a, b>> | <<a, b, "======">> -> {
      let assert <<out:bytes-size(1), _>> = <<
        num(a):5,
        num(b):5,
        0:6,
      >>
      out
    }
    <<a, b, c, d>> | <<a, b, c, d, "====">> -> {
      let assert <<out:bytes-size(2), _>> = <<
        num(a):5,
        num(b):5,
        num(c):5,
        num(d):5,
        0:4,
      >>
      out
    }
    <<a, b, c, d, e>> | <<a, b, c, d, e, "===">> -> {
      let assert <<out:bytes-size(3), _>> = <<
        num(a):5,
        num(b):5,
        num(c):5,
        num(d):5,
        num(e):5,
        0:7,
      >>
      out
    }
    <<a, b, c, d, e, f, g>> | <<a, b, c, d, e, f, g, "=">> -> {
      let assert <<out:bytes-size(4), _>> = <<
        num(a):5,
        num(b):5,
        num(c):5,
        num(d):5,
        num(e):5,
        num(f):5,
        num(g):5,
        0:5,
      >>
      out
    }
    <<a, b, c, d, e, f, g, h, rest:bytes>> -> <<
      num(a):5,
      num(b):5,
      num(c):5,
      num(d):5,
      num(e):5,
      num(f):5,
      num(g):5,
      num(h):5,
      do_decode(rest):bits,
    >>
    _ -> panic as "Invalid base32 string"
  }
}

fn num(a) {
  case a {
    a if a >= 65 && a <= 90 -> a - 65
    a if a >= 97 && a <= 122 -> a - 97
    a if a >= 50 && a <= 55 -> a - 24
    _ -> panic as "Invalid base32 charachter"
  }
}

@external(erlang, "multiformats_ffi", "encode32")
pub fn encode(input: BitArray) -> String {
  let assert Ok(out) = bit_array.to_string(do_encode(input))
  out
}

fn char(n) {
  case n {
    n if n >= 0 && n <= 25 -> n + 65
    n if n >= 26 && n <= 31 -> n + 24
    _ -> panic
  }
}

fn do_encode(input) {
  case input {
    <<>> -> <<>>
    <<a:5, b:3>> -> <<char(a), char(b * 4), "======">>
    <<a:5, b:5, c:5, d:1>> -> <<
      char(a),
      char(b),
      char(c),
      char(d * 16),
      "====",
    >>
    <<a:5, b:5, c:5, d:5, e:4>> -> <<
      char(a),
      char(b),
      char(c),
      char(d),
      char(e * 2),
      "===",
    >>
    <<a:5, b:5, c:5, d:5, e:5, f:5, g:2>> -> <<
      char(a),
      char(b),
      char(c),
      char(d),
      char(e),
      char(f),
      char(g * 8),
      "=",
    >>
    <<a:5, b:5, c:5, d:5, e:5, f:5, g:5, h:5, rest:bits>> -> <<
      char(a),
      char(b),
      char(c),
      char(d),
      char(e),
      char(f),
      char(g),
      char(h),
      do_encode(rest):bits,
    >>
    _ -> panic
  }
}
