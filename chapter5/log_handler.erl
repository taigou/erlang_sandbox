-module(log_handler).
-export([init/1, terminate/1, handle_event/2]).

init(File) ->
  { ok, Fd } = file:open(File, write), Fd.

terminate(Fd) -> file:close(Fd).

handle_event({ Action, Id, Event }, Fd) ->
%%  { MegaSec, Sec, MicroSec } = now(),
%%  io:format(Fd, "~w, ~w, ~w, ~w, ~w, ~p~n",
%%           [MegaSec, Sec, MicroSec, Action, Id, Event]),
  print(Action, Id, Event, Fd),
  Fd;
handle_event(_, Fd) -> Fd.

print(Type, Id, Event, Fd) ->
  Date = fmt(date()), Time = fmt(time()),
  io:format(Fd, "#~s, ~s, ~w, ~w, ~p~n",
            [Date, Time, Type, Id, Event]).

fmt({ AInt, BInt, CInt }) ->
  AStr = pad([integer_to_list(AInt)]),
  BStr = pad([integer_to_list(BInt)]),
  CStr = pad([integer_to_list(CInt)]),
  [AStr, $:, BStr, $:, CStr].

pad([M1]) -> [$0,M1];
pad(other) -> other.