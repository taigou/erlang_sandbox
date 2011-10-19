-module(db).
-export([new/0,write/3,read/2,delete/2,destroy/1,convert/2]).
-export([code_upgrade/1]).
-vsn(1.1).

%%new() -> gb_trees:empty().
new() -> ets:new(table, [set, public, named_table]).

%%write(Key,Data,Db) -> gb_trees:insert(Key,Data,Db).
write(Key,Data,Db) -> ets:insert(Db, { Key, Data }).

%read(Key,Db) ->
%  case gb_trees:lookup(Key,Db) of
%    none -> { error, instance };
%    { value, Data } -> { ok, Data }
%  end.

read(Key,Db) ->
  case ets:lookup(Db,Key) of
    [] -> { error, instance };
    [{ _, D }] -> { ok, D }
  end.

%delete(Key,Db) -> gb_trees:delete(Key,Db).
delete(Key,Db) ->
  [D] = ets:lookup(Db,Key),
  ets:delete_object(Db, D).

%destroy(_Db) -> ok.
destroy(Db) -> ets:delete(Db).

convert(dict,Dict) -> dict(dict:fetch_keys(Dict),Dict,new());
convert(_,   Data) -> Data.

dict([Key|Tail], Dict, GbTree) ->
    Data = dict:fetch(Key, Dict),
    NewGbTree = gb_trees:insert(Key, Data, GbTree),
    dict(Tail, Dict, NewGbTree);
dict([], _, GbTree) -> GbTree.

%% L = [{ Key, Element }|T]
code_upgrade(L) -> to_ets(L, new()).

to_ets([], Ets) -> Ets;
to_ets([{ Key, Elem }|Tail], Ets) ->
%    to_ets(Tail, gb_trees:insert(Key, Elem, Ets)).
    to_ets(Tail, ets:insert(Ets, { Key, Elem })).
