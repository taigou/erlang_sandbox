-module(my_db).
-export([start/0, write/2, stop/0, init/0, read/1, delete/1, match/1, loop/1]).

start() ->
  register(my_db, spawn(?MODULE, init, [])), ok.

init() ->
  Db = [],
  loop(Db).

%% The Client Functions
stop()              -> call(stop).
write(Key, Element) -> call({ write, Key, Element }).
read(Key)           -> call({ read, Key }).
delete(Key)         -> call({ delete, Key }).
match(Element)      -> call({ match, Element }).

call(Message) ->
  my_db ! { request, self(), Message },
  receive
    { reply, Reply } -> Reply
  end.

reply(Pid, Reply) -> Pid ! { reply, Reply }.

loop(Db) ->
  receive
    { request, Pid, { write, Key, Element }} ->
      io:format("Write: ~p in ~p~n", [{Key, Element}, self()]),
      NewDb = db:write(Key, Element, Db),
      reply(Pid, ok),
      loop(NewDb);
    { request, Pid, { read, Key }} ->
      io:format("Read : ~p in ~p~n", [Key, self()]),
      reply(Pid, db:read(Key, Db)),
      loop(Db);
    { request, Pid, { match, Element}} ->
      io:format("Match: ~p in ~p~n", [Element, self()]),
      reply(Pid, db:match(Element, Db)),
      loop(Db);
    { request, Pid, { delete, Key }} ->
      io:format("Delete: ~p in ~p~n", [Key, self()]),
      NewDb = db:delete(key, Db),
      reply(Pid, ok),
      loop(NewDb);
    { request, Pid, stop } ->
      io:format("Stop: in ~p~n", [self()]),
      reply(Pid, ok)
  end.