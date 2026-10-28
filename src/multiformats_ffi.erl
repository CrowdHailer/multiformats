-module(multiformats_ffi).

-export([
    decode32/1, try_decode32/1, encode32/1, identity/1
]).

decode32(Raw) ->
  base32:decode(Raw).

try_decode32(Raw) ->
  try base32:decode(Raw) of
    Decoded -> {ok, Decoded}
  catch
    _:_ -> {error, nil}
  end.

encode32(Raw) ->
  base32:encode(Raw, [lower, nopad]).

identity(In) ->
  In.