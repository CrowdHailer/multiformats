# multiformats

Bindings to the [js implementation](https://github.com/multiformats/js-multiformats) of multiformats.

[![Package Version](https://img.shields.io/hexpm/v/multiformats)](https://hex.pm/packages/multiformats)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/multiformats/)

Currently only the sha256 hasher is supported.

```sh
npm install --save multiformats@13
gleam add multiformats@1
```

```gleam
import dag_json
import multiformats/cid
import multiformats/hashes/sha256

pub fn main() {
  let data = // some json
  let bytes = dag_json.encode(data)
  let multihash = sha256.digest(bytes)
  cid.create_v1(dag_json.code(), multihash)
  |> cid.to_string
}
```

Further documentation can be found at <https://hexdocs.pm/multiformats>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Credit

Created for [EYG](https://eyg.run/), a new integration focused programming language.