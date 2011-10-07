-module(my_supervisor).
-export([start_link/2, stop/1]).
-export([init/1]).

%% my_supervisor:start_link(my_sup, [{ add_two,start,[],transient }]).
start_link(Name, ChildSpecList) ->
  Pid = spawn_link(?MODULE, init, [ChildSpecList]),
  register(Name, Pid),
  { ok, Name, Pid }.

init(ChildSpecList) ->
  process_flag(trap_exit, true),
  loop(start_children(ChildSpecList)).

start_children([]) -> [];
start_children([{ M,F,A,Type } | ChildSpecList]) ->
  case (catch apply(M,F,A)) of
    { ok, Pid } ->
      io:format("ChildPid -> ~p~n", [Pid]),
      [{ Pid, { M,F,A,Type,{} } } | start_children(ChildSpecList)];
    _ ->
      io:format("Not applied? ~p, ~p, ~p~n", [M,F,A]),
      start_children(ChildSpecList)
  end.

restart_child(Pid, ChildList, Reason) ->
  { value, { Pid, { M,F,A,Type,Restart } } } = lists:keysearch(Pid, 1, ChildList),
  {_,S,_} = now(),
  NewRestart = lists:filter(fun(T) -> (S-T)=<60 end, [S|Restart]),
  case lists:all(fun(X) -> X end, [Reason/=normal,length(NewRestart)=<5]) of
    true ->
      { ok, NewPid } = apply(M,F,A),
      [{ NewPid, { M,F,A,Type,NewRestart } } | lists:keydelete(Pid, 1, ChildList)];
    false ->
      lists:keydelete(Pid, 1, ChildList)
  end.

loop(ChildList) ->
  receive
    { 'EXIT', Pid, Reason } ->
      NewChildList = restart_child(Pid, ChildList, Reason),
      loop(NewChildList);
    { stop, From } ->
      From ! { reply, terminate(ChildList) }
  end.

stop(Name) ->
  Name ! { stop, self() },
  receive { reply, Reply } -> Reply end.

terminate([{ Pid, _ } | ChildList]) ->
  exit(Pid, kill),
  terminate(ChildList);
terminate(_ChildList) -> ok.

%%start_child(M, F, A) ->
%%  Identifier ! { start_child, self(), M, F, A },
%%  receive { reply, Reply } -> Reply end.

%%stop_child(Identifier,