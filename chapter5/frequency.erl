-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

start() ->
  register(frequency, spawn(frequency, init, [])).

init() ->
  Frequencies = { get_frequencies(), [] },
  loop(Frequencies).

get_frequencies() -> [10,11,12,13,14,15].

%% The client Functions
stop()           -> call(stop).
allocate()       -> call(allocate).
deallocate(Freq) -> call({ deallocate, Freq }).

call(Message) ->
  frequency ! { request, self(), Message },
  receive
    { reply, Reply } -> Reply
  end.

loop(Frequencies) ->
  receive
    { request, Pid, allocate } ->
      { NewFrequencies, Reply } = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    { request, Pid, { deallocate, Freq } } ->
      { NewFrequencies, Reply } = deallocate(Frequencies, Freq, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    { request, Pid, stop } ->
      { _Free, Allocated } = Frequencies,
      case Allocated of
        [] ->
          reply(Pid, ok);
        _ ->
          reply(Pid, not_stop_and_loop),
          loop(Frequencies)
      end
  end.

reply(Pid, Reply) ->
  Pid ! { reply, Reply }.

allocate({ [], Allocated }, _Pid) ->
  { { [], Allocated }, { error, no_frequency } };
allocate({ [Freq|Free], Allocated }, Pid) ->
  io:format("Allocate Freq:~p by ~p~n", [Freq, Pid]),
  case lists:takewhile(fun({ _, AllocatedPid }) -> AllocatedPid == Pid end, Allocated) of
    [_,_,_] ->
      { { [Freq|Free], Allocated }, not_allocated___ };
    _ ->
      { { Free, [{ Freq, Pid }|Allocated] }, { ok, Freq } }
  end.

%deallocate({ _Free, [] }, _, _) ->
%  { { _, [] }, { error, no_allocated_user } };
%deallocate({ Free, [{ Freq, Pid }|NewAllocated] }, Freq, Pid) ->
%  io:format("Deallocate Freq:~p by ~p~n", [Freq, Pid]),
%  { [Freq|Free], NewAllocated };
%deallocate({ Free, [_|Allocated] }, Freq, Pid) ->
%  deallocate({ Free, Allocated }, Freq, Pid).

%%deallocate({ Free, Allocated }, Freq, Pid) ->
%%  NewAllocated = lists:keydelete(Freq, 1, Allocated),
%%  { [Freq|Free], NewAllocated }.
%%  io:format("Free: ~p, Allocated: ~p, Freq: ~p~n", [Free, Allocated, Freq]),
%%  { NewFreePair, NewAllocated } = lists:partition(fun(A) -> { Freq, Pid } == A end, Allocated),
%%  [{ NewFree, _FreePid }] = NewFreePair,
%%  io:format("NewFree: ~p, Free: ~p~n", [NewFree, Free]),
%%  { lists:flatten([NewFree|Free]), NewAllocated }.
%%  { { [NewFree|Free], NewAllocated }, { ok, Freq } }.

deallocate({ Free, Allocated }, Freq, Pid) ->
  case lists:member({ Freq, Pid }, Allocated) of
    true ->
      NewAllocated = lists:keydelete(Freq, 1, Allocated),
      { { [Freq|Free], NewAllocated }, ok };
    _ ->
      { { Free, Allocated }, not_allocated_user_or_not_allocated_frequency____ }
  end.