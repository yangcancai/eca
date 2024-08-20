%%%-------------------------------------------------------------------
%%% @author vv
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. 8月 2024 10:17
%%%-------------------------------------------------------------------
-module(eca_app).
-author("vv").
-export([start/2, stop/1]).
-behaviour(application).

start(_StartType, _StartArgs) ->
  eca:start(),
  eca_app_sup:start_link().

stop(_State) ->
  ok.