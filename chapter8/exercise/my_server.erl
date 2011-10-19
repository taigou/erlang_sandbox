-module(my_server).
-export([start/0,stop/0,upgrade/1,code_upgrade/0]).
-export([write/2,read/1,delete/1]).
-export([init/0,loop/1]).
-vsn(1.0).

start() -> register(db_server, spawn(?MODULE,init,[])).
stop()          -> db_server ! stop.
upgrade(Dict)   -> db_server ! { upgrade, Dict }.
code_upgrade()  -> db_server ! { code_upgrade }.
write(Key,Data) -> db_server ! { write, Key, Data}.
read(Key)       -> db_server ! { read, self(), Key }, receive Reply -> Reply end.
delete(Key)     -> db_server ! { delete, Key }.

init() -> loop(db:new()).
loop(Db) ->
    receive
        { write, Key, Data } -> my_server:loop(db:write(Key, Data, Db));
        { read, Pid, Key }   -> Pid ! db:read(Key, Db), my_server:loop(Db);
        { delete, Key }      -> my_server:loop(db:delete(Key,Db));
        { upgrade, Dict }    -> my_server:loop(db:convert(Dict,Db));
        { code_upgrade }     ->
             code:add_patha("./patches"),
             code:load_file(db),
             my_server:loop(db:code_upgrade(Db));
        stop                 -> db:destroy(Db)
    end.
