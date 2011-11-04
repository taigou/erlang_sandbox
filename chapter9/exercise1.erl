-module(exercise1).
-export([int_nums1/1, lt1/2, even1/1]).
-export([int_nums2/1, lt2/2, even2/1]).
-export([concat1/1, concat2/1, concat3/1, concat4/1]).
-export([sum/1]).
-export([rem3/0, int_from_multi_type_list/1, intersection/2, exclusiveor/2]).
-export([zip/2, zipWith/3]).

int_nums1(N) -> lists:map(fun(X) -> X end, lists:seq(1,N)).
int_nums2(N) -> [X || X <- lists:seq(1,N)].

lt1(L,N) -> lists:filter(fun(X) -> X =< N end, L).
lt2(L,N) -> [X || X <- L, X =< N].

even1(N) -> lists:filter(fun(X) -> X rem 2 == 0 end, lists:seq(1,N)).
even2(N) -> [X || X <- lists:seq(1,N), X rem 2 == 0].

concat1(L) -> lists:flatten(lists:foldl(fun(Sum, X) -> [X|Sum] end, [], L)).
concat2(L) -> lists:foldl(fun(Sum, X) -> X ++ Sum end, [], L).
concat3(L) -> lists:flatten(L).
concat4(L) -> lists:append(L). % append(Xss) -> [X || Xs <- Xss, X <- Xs].

sum(L) -> lists:foldl(fun(Sum, X) -> X + Sum end, 0, L).

rem3() -> [X || X <- lists:seq(1,10), X rem 3 == 0].

% 多「相」的？なリスト
% http://ja.wikipedia.org/wiki/%E7%9B%B8
int_from_multi_type_list(L) -> [X || X <- L, is_integer(X)].

% A ∩ B := { x | x ∈ A and x ∈ B }
intersection(L1, L2) -> [X || X <- L1, lists:member(X, L2)].

%exclusiveor(L1, L2) -> [ [ X || X <- L1, X /= Y] || Y <- L2].
exclusiveor(L1, L2) -> [X || X <- L1, not lists:member(X, L2)] ++ [X || X <- L2, not lists:member(X, L1)].

zip([], _) -> [];
zip(_, []) -> [];
zip([H1|T1], [H2|T2]) -> [{ H1, H2 } | zip(T1, T2)].
zipWith(Fun, L1, L2) -> lists:map(fun({X, Y}) -> Fun(X,Y) end, zip(L1, L2)).
