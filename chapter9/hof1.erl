-module(hof1).
-export([doubleAll/1,plains/1,foreach/2,times/1]).

times(X) -> fun(Y) -> X*Y end.

map(_,[]) -> [];
map(F,[X|Xs]) -> [F(X) | map(F,Xs)].

filter(_,[]) -> [];
filter(P,[X|Xs]) ->
  case P(X) of
    true -> [X|filter(P,Xs)];
    _    -> filter(P,Xs)
  end.

foreach(_,[])     -> ok;
foreach(F,[X|Xs]) -> F(X), foreach(F,Xs).

doubleAll(Xs) -> map(fun(X) -> X*2 end, Xs).
plains(Xs)    -> filter(fun(X) -> X == lists:reverse(X) end, Xs).
