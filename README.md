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

## Use in the browser

This version exposes a promises based API that works in the browser and on node.
node has an implementation of the WebCrypto API.

The javascript package that this module binds to is indicated using the `browser` field of the `package.json` file. [more info](https://docs.npmjs.com/cli/v11/configuring-npm/package-json#browser).

If bundling you need to ensure that your bundler will use this field.
For example rollup using the [@rollup/plugin-node-resolve](https://www.npmjs.com/package/@rollup/plugin-node-resolve) plugin requires configuring as the [default behaviour](https://www.npmjs.com/package/@rollup/plugin-node-resolve#browser) is to ignore the browser field.

```gleam
import dag_json
import multiformats/cid
import multiformats/hashes/sha256_browser as sha256
import gleam/javascript/promise

pub fn main() {
  let data = // some json
  let bytes = dag_json.encode(data)
  use multihash <- promise.map(sha256.digest(bytes))
  cid.create_v1(dag_json.code(), multihash)
  |> cid.to_string
}
```


## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```

## Credit

Created for [EYG](https://eyg.run/), a new integration focused programming language.