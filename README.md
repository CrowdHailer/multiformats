# multiformats

Multiformats for IPFS content identifier (CID). Includes base32 helpers.

[![Package Version](https://img.shields.io/hexpm/v/multiformats)](https://hex.pm/packages/multiformats)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/multiformats/)

Currently only the sha256 hasher is supported.

```sh
gleam add multiformats@1
```

```gleam
import dag_json
import multiformats/cid
import multiformats/hashes.{Multihash, Sha256}

pub fn main() {
  let data = // some json
  let bytes = dag_json.encode(data)
  let hashed = todo as "sha256 digest"
  let multihash = Multihash(Sha256,hashed)
  cid.create_v1(dag_json.code(), multihash)
  |> cid.to_string
}
```

Further documentation can be found at <https://hexdocs.pm/multiformats>.

## Explore CID's

https://cid.ipfs.tech/

## Hashing

The actual hashing process depends on the platform you are running on.
If running in the browser, `plinth` is recommended.
For both node and erlang, `gleam_crypto` is recommended.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Credit

Created for [EYG](https://eyg.run/), a new integration focused programming language.