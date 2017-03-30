-module(node).
-export([start/1, stop/1, init/2, loop/1, search/2]).

start(Url) ->
  spawn(?MODULE, init, [self(), Url]).

stop(Pid) ->
  Pid ! {shutdown, self()}.

init(Server, Url) ->
  % get the fingerptint for this url
  {inbox, 'boilerpipe@localhost'} ! {url, Url, self()},
  % start the node
  receive
    {fingerprint, ContentFingerprint} ->
      % node is ready for querying
      Server ! {ready, self()},
      loop(ContentFingerprint)
  end.

search(Pid, Query) ->
  Pid ! {search, Query}.

loop(ContentFingerprint) ->
  receive
    {search, Query} ->
      {inbox, 'boilerpipe@localhost'} ! {search_query, Query, self()},
      loop(ContentFingerprint);
    {fingerprint, QueryFingerprint} ->
      io:format("~p~n", [cosine_similarity(ContentFingerprint, QueryFingerprint)]),
      loop(ContentFingerprint);
    {shutdown, Server} ->
      Server ! {done}
  end.

cosine_similarity(A, B) ->
  Intersection=sets:intersection(sets:from_list(A), sets:from_list(B)),
  length(sets:to_list(Intersection))/(math:sqrt(length(A))*math:sqrt(length(B))).
