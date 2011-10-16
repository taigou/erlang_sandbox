-module(btree).
-export([start/0, add/1, sum/0, max/0, is_orderd/0, stop/0]).
-export([init/0]).

-record(btree, { data, left=[], right=[] }).

start() -> register(btree, spawn(?MODULE, init, [])), ok.

init() -> Root = #btree{ data=1 }, loop(Root).

add(NewData) -> call({ add, NewData }).
sum()        -> call(sum).
max()        -> call(max).
is_orderd()  -> call(is_orderd).
stop()       -> call(stop).

call(Msg) ->
    btree ! { request, self, Msg },
    receive { reply, Reply } -> Reply end.

reply(Pid, Msg) -> Pid ! { reply, Msg }.

loop(Root) ->
    receive
        { request, Pid, { add, NewData } } ->
            add(NewData, Root),
            reply(Pid, ok),
            loop(Root);
        { request, Pid, sum } ->
            sum(Root),
            reply(Pid, ok),
            loop(Root);
        { request, Pid, max } ->
            max(Root),
            reply(Pid, ok),
            loop(Root);
        { request, Pid, is_orderd } ->
            is_orderd(Root),
            reply(Pid, ok),
            loop(Root);
        { request, Pid, stop } ->
            reply(Pid, ok)
    end.

add(NewData, []) -> #btree{ data=NewData };
add(NewData, #btree{ data=D,  left=L,  right=_R }=B) when NewData < D -> B#btree{ left =add(NewData,L) };
add(NewData, #btree{ data=_D, left=_L, right=R  }=B)                  -> B#btree{ right=add(NewData,R) }.

sum([]) -> 0;
sum(#btree{ data=D, left=L, right=R }) -> D + sum(L) + sum(R).

max([]) -> [];
max(#btree{ data=D, left=L, right=R }) -> lists:max([D, max(L), max(R)]).

is_orderd([]) -> true;
is_orderd(#btree{ data=D, left=L, right=R }) -> false.
