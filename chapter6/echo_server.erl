-module(echo_server).
-export([start/0, print/1, stop/1, loop/0]).

start() ->
%%  process_flag(trap_exit, true),
  Pid = spawn_link(?MODULE, loop, []),
  register(echo_server, Pid),
  { ok, Pid }.

print(Term) ->
  echo_server ! { print, Term }.

stop(Pid) ->
%%  echo_server ! stop.
  exit(Pid).

loop() ->
  receive
    { print, Term } ->
      io:format("Only use here ~p variable~n", [Term]),
      loop()
%%    stop ->
%%      ok
  end.
