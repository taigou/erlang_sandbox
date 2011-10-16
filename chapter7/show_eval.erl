-module(show_eval).
-export([show_eval_call/0]).

-ifdef(show).
    -define(SHOW_EVAL(Arg), io:format("~p = ~p~n", [??Arg, Arg])).
-else.
    -define(SHOW_EVAL(Arg), io:format("Result: ~p~n",[Arg])).
-endif.

-define(Sunday,    { day, 1 }).
-define(Monday,    { day, 2 }).
-define(Tuesday,   { day, 3 }).
-define(Wednesday, { day, 4 }).
-define(Thursday,  { day, 5 }).
-define(Friday,    { day, 6 }).
-define(Saturday,  { day, 7 }).

show_eval_call() -> ?SHOW_EVAL(length([1,2,3])).
