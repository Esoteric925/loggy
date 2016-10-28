%%%-------------------------------------------------------------------
%%% @author Amir
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 24. sep 2016 13:24
%%%-------------------------------------------------------------------
-module(logger).
-author("Amir").

%% API
-compile(export_all).

start(Nodes) ->
  spawn_link(fun() ->init(Nodes) end).

stop(Logger) ->
  Logger ! stop.

init(Nodes) ->
  Clock = time:clock(Nodes),
  loop(Clock, []).

loop(Clock, HoldBackQueue) ->
  receive
    {log, From, Time, Msg} ->

      MessageQueue = lists:keysort(3,MessageList = HoldBackQueue ++ [{log,From, Time, Msg}]),
       List = time:update(From, Time, Clock),
      case time:safe(Time, List) of
         true ->
          TempList = helpFunction(Time,MessageQueue), loop(List,TempList);
         false ->
           loop(List, MessageList)
      end;

    stop ->
          ok
    end.

log(From, Time, Msg) ->
  io:format("log: ~w ~w ~p~n", [Time, From, Msg]).

helpFunction(_, [])->
  [];
helpFunction(Time, [{log, From, MsgTime, Msg}|T])->
  if
    MsgTime =< Time -> log(From,MsgTime,Msg),
                        helpFunction(Time, T);
    true -> [{log,From,MsgTime,Msg}|T]
  end.