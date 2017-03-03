-module(test).
-compile(export_all).


send_query(Query, Ref, Nodes) ->
  [X ! {search, Query, Ref} || X <- Nodes].

reduce_loop(Client) ->
  receive
    {results, Results} ->
      %reduce results
      io:format("Got some results.~n"),
      Client ! Results
  end.

search(Query, Client, Nodes) ->
  Pid = spawn(?MODULE, reduce_loop, [Client]),
  send_query(Query, Pid, Nodes).
