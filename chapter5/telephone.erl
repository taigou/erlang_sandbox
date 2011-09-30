-module(telephone).
-export([start/0, init/0, stop/0]).

start() ->
  register(telephone, spawn(?MODULE, init, [])).

init() ->
  event_manager:start(charge, [{log_handler, "TeleLog"}]),
  idle().

stop() ->
 event_manager:stop(charge),
 ok.

idle() ->
  receive
    { Number, incoming } ->
      start_ringing(),
      ringing(Number);
    off_hook ->
      start_tone(),
      dial()
  end.

ringing(Number) ->
  receive
    { Number, other_on_hook } ->
      stop_ringing(),
      idle();
    { Number, off_hook } ->
      start_connecting(rcv),
      connected(Number)
  end.

dial() ->
  receive
    { _Number, on_hook } ->
      stop_ringing(),
      idle();
    { Number, _ } ->
      start_connecting(call_),
      connected(Number)
  end.

connected(Number) ->
  receive
    { Number, on_hook } ->
      stop_connecting(),
      idle()
  end.

start_ringing() -> io:format("Start Ringing").
start_tone() -> io:format("Start Tone").
stop_ringing() -> io:format("Stop Ringing").
start_connecting(RcvOrCall) ->
  event_manager:send_event(charge, { RcvOrCall, self(), start_connectiong }).
stop_connecting() ->
  event_manager:send_event(charge, { stop, self(), stop_connectiong }).