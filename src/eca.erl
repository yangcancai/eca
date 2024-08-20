%%%-------------------------------------------------------------------
%%% @author vv
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 8月 2024 10:14
%%%-------------------------------------------------------------------
-module(eca).
-author("vv").

%% API
-export([start/0, get_cert_pem/1, list_ca_file/0]).
-include("cargo.hrl").
start() ->
  Dir = code:priv_dir(eca),
  maybe_gen_ca(Dir).

maybe_gen_ca(Dir) ->
  CacertFile = filename:join(Dir, "cacert.pem"),
  CaKeyFile = filename:join(Dir, "cakey.pem"),
  maybe_gen_ca(Dir,
    filelib:is_file(CacertFile),
    filelib:is_file(CaKeyFile),
    erlang:list_to_binary(CacertFile),
    erlang:list_to_binary(CaKeyFile)).

maybe_gen_ca(_Dir, true, true, CacertFile, CaKeyFile) ->
  {ok, Ref} = ca:new(CacertFile, CaKeyFile),
  persistent_term:put(ca_resource, Ref),
  ok;
maybe_gen_ca(Dir, _, _, CacertFile, CaKeyFile) ->
  ok = ca:gen_ca(#ca_info{output = erlang:list_to_binary(Dir)}),
  {ok, Ref} = ca:new(CacertFile, CaKeyFile),
  persistent_term:put(ca_resource, Ref),
  ok.

get_cert_pem(Host) when is_binary(Host) ->
  Ref = persistent_term:get(ca_resource),
  ca:gen_cert_pem(Ref, Host).

list_ca_file() ->
  ca:list_ca_file(
    persistent_term:get(ca_resource)).
