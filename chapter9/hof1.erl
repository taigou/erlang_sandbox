-module(hof1).
-export([doubleAll/1,plains/1,foreach/2,times/1,double/1]).
-export([next/1]).

times(X) -> fun(Y) -> X*Y end.

%map(_,[]) -> [];
%map(F,[X|Xs]) -> [F(X) | map(F,Xs)].
map(F,Xs) -> [ F(X) || X <- Xs ].
filter(P,Xs) -> [ X || X <- Xs, P(X) ].
append(Xss) ->  [ X || Xs <- Xss, X <- Xs ].

perms([]) -> [[]];
perms([X|Xs]) -> [insert(X,As,Bs) || Ps <- perms(Xs), { As, Bs } <- splits(Ps)].

splits([]) -> [{ [], [] }];
splits([X|Xs]=Ys) -> [{ [], Ys } | [{ [X|As], Bs } || { As, Bs } <- splits(Xs)]].

insert(X,As,Bs) -> lists:append([As,[X],Bs]).

%filter(_,[]) -> [];
%filter(P,[X|Xs]) ->
%  case P(X) of
%    true -> [X|filter(P,Xs)];
%    _    -> filter(P,Xs)
%  end.

foreach(_,[])     -> ok;
foreach(F,[X|Xs]) -> F(X), foreach(F,Xs).

doubleAll(Xs) -> map(fun(X) -> X*2 end, Xs).
plains(Xs)    -> filter(fun(X) -> X == lists:reverse(X) end, Xs).

double(Xs) -> map(times(2), Xs).

next(Seq) -> fun() -> [Seq|next(Seq+1)] end.
