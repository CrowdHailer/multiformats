-module(multiformats_ffi).

-export([
    decode32/1, encode32/1, identity/1
]).

decode32(Raw) ->
  base32:decode(Raw).

encode32(Raw) ->
  base32:encode(Raw, [lower, nopad]).

identity(In) ->
  In.