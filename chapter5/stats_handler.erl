-module(stats_handler).
-export([init/1, terminate/1, handle_event/2]).

init(Count) -> Count.
terminate(Count) -> Count.

%% [{ { Type1, Desc1 }, 1 }, { { Type2, Desc2 }, 5 }, ....]
handle_event({ Type, _Id, Desc }, Count) ->
  case lists:keysearch({ Type, Desc }, 1, Count) of
    false ->
      [{ { Type, Desc }, 1 }|Count];
    { value, { { Type, Desc }, Data } } ->
      lists:keydelete({ Type, Desc }, 1, Count),
      [{ { Type, Desc }, Data+1 }|Count]
  end;
handle_event(_Event, Count) ->
 [{ { _, _ }, Data }|_] = Count,
 Data.