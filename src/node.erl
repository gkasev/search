-module(node).
-compile(export_all).


loop() ->
  receive
    {search, Query, Ref} ->
      io:format("Bla~n"),
      %search for results
      Res1="www.site1.com",
      Res2="www.site2.com",
      Res3="www.site3.com",
      ResN="www.siten.com",

      Ref ! {results, [Res1, Res2, Res3, ResN]},
      loop();
    {shutdown, Server} ->
      Server ! {done}
  end.
