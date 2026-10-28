import gleam/bit_array
import gleam/result

/// Decode base32 text and panic if it is not valid.
pub fn decode(encoded: String) -> BitArray {
  let assert Ok(decoded) = try_decode(encoded)
  decoded
}

/// Decode base32 text, with or without padding.
@external(erlang, "multiformats_ffi", "try_decode32")
pub fn try_decode(encoded: String) -> Result(BitArray, Nil) {
  do_decode(bit_array.from_string(encoded))
}

fn do_decode(encoded) {
  case encoded {
    <<>> -> Ok(<<>>)
    <<a, b>> | <<a, b, "======">> -> {
      use a <- result.try(num(a))
      use b <- result.try(num(b))
      let assert <<out:bytes-size(1), _>> = <<a:5, b:5, 0:6>>
      Ok(out)
    }
    <<a, b, c, d>> | <<a, b, c, d, "====">> -> {
      use a <- result.try(num(a))
      use b <- result.try(num(b))
      use c <- result.try(num(c))
      use d <- result.try(num(d))
      let assert <<out:bytes-size(2), _>> = <<a:5, b:5, c:5, d:5, 0:4>>
      Ok(out)
    }
    <<a, b, c, d, e>> | <<a, b, c, d, e, "===">> -> {
      use a <- result.try(num(a))
      use b <- result.try(num(b))
      use c <- result.try(num(c))
      use d <- result.try(num(d))
      use e <- result.try(num(e))
      let assert <<out:bytes-size(3), _>> = <<a:5, b:5, c:5, d:5, e:5, 0:7>>
      Ok(out)
    }
    <<a, b, c, d, e, f, g>> | <<a, b, c, d, e, f, g, "=">> -> {
      use a <- result.try(num(a))
      use b <- result.try(num(b))
      use c <- result.try(num(c))
      use d <- result.try(num(d))
      use e <- result.try(num(e))
      use f <- result.try(num(f))
      use g <- result.try(num(g))
      let assert <<out:bytes-size(4), _>> = <<
        a:5,
        b:5,
        c:5,
        d:5,
        e:5,
        f:5,
        g:5,
        0:5,
      >>
      Ok(out)
    }
    <<a, b, c, d, e, f, g, h, rest:bytes>> -> {
      use a <- result.try(num(a))
      use b <- result.try(num(b))
      use c <- result.try(num(c))
      use d <- result.try(num(d))
      use e <- result.try(num(e))
      use f <- result.try(num(f))
      use g <- result.try(num(g))
      use h <- result.try(num(h))
      use rest <- result.try(do_decode(rest))
      Ok(<<a:5, b:5, c:5, d:5, e:5, f:5, g:5, h:5, rest:bits>>)
    }
    _ -> Error(Nil)
  }
}

fn num(a) {
  case a {
    a if a >= 65 && a <= 90 -> Ok(a - 65)
    a if a >= 97 && a <= 122 -> Ok(a - 97)
    a if a >= 50 && a <= 55 -> Ok(a - 24)
    _ -> Error(Nil)
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
