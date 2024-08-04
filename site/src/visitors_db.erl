%% functions that enable us to create and retreive visitor records

-module(visitors_db).
-include("nb.hrl").
-compile(export_all).

open_visitors_db() ->
    File = visitors,
        {ok, visitors} = dets:open_file(File,
        [{keypos,#visitor.date}, {type,bag}]).

close_visitors_db() -> ok = dets:close(visitors).

%% putting the put functions
put_visitor(Record) ->
    open_visitors_db(),
    ok = dets:insert(visitors, Record),
    close_visitors_db().

%% @doc Enter VIP visiting today and store in database
put_vip(Name, Company) ->
    {Date, Time} = calendar:local_time(),
    Record = #visitor{date=Date, time=Time, name=Name, company=Company},
    put_visitor(Record).

%% putting the get functions
get_visitors(Date) ->
    open_visitors_db(),
    List = dets:lookup(visitors, Date),
    close_visitors_db(),
    List1 = lists:sort(List),
    List1.

%%vip visitors
%%get_vip(Date) ->
    %%open_visitors_db(),
    %%List = dets:lookup(vip, Date),
    %%close_visitors_db(),
    %%List1 = listst:sort(List),
    %%List1.

%% the utility function 
%% @doc dump the db; handy for debugging
dump_visitors() ->
    open_visitors_db(),
    List = dets:match_object(visitors, '_'),
    close_visitors_db(),
    List.

%%dump_visitors() ->
  %%  open_visitors_db(),
    %%List = det:match_object(vip, '_'),
    %%close_visitors_db(),
    %%List.

%% @doc Pretty print visitor by name, company, or both
format_name(#visitor{name=Name, company=""}) -> Name;
format_name(#visitor{name="", company=Company}) -> Company;
format_name(#visitor{name=Name, company=Company}) -> [Name, " --* ", Company].

