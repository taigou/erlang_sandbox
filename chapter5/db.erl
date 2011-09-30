-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, match/2]).

new() -> [].
destroy(_Db) -> ok.

write(Key, Element, Db) ->
  [{Key, Element} | delete(Key,Db)].

delete(_Key, []) -> [];
delete(Key, [{Key,_}|T]) ->
  delete(Key,T);
delete(Key, [H|T]) ->
  [H|delete(Key, T)].

read(_Key, []) ->
  {error, instance};
read(Key, [{Key, Elem}|_]) ->
  {ok, Elem};
read(Key, [_|T]) ->
  read(Key, T).

match(_Element, []) ->
  [];
match(Element, [{Key,Element}|T]) ->
  [Key | match(Element, T)];
match(Element, [_|T]) ->
  match(Element, T).
