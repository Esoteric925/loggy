%%%-------------------------------------------------------------------
%%% @author Amir
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. sep 2016 17:18
%%%-------------------------------------------------------------------
-module(time).
-author("Amir").

%% API
-compile(export_all).

zero()->
  0.

inc(Name,T)->
  T+1.

merge(Ti,Tj)->
  if
    Ti < Tj -> Tj ;
    true -> Ti
  end.

leq(Ti,Tj)->
  if
    Ti =< Tj -> true ;
    true -> false
  end.

clock([])->
  [];
clock([H|T])->
  [{H,0}|clock(T)].

update(Node, Time, Clock)->

  List = lists:keyreplace(Node, 1, Clock, {Node,Time}),
  List.

safe(_, [])->
  true;
safe(Time, [{_, MsgTime}|T])->
  if
    Time =< MsgTime -> safe(Time, T) ;
    true -> false
  end.






