//// This module only works on node and erlang
//// The *_browser module will work on node and browser using the WebCrypto API

import gleam/crypto
import multiformats/hashes

pub fn digest(bytes: BitArray) {
  hashes.Multihash(hashes.Sha256, crypto.hash(crypto.Sha256, bytes))
}
