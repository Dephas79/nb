-module(associates_db).
-export([
	put_associate/1,
	get_associate/1,
	get_associates/0,
	format_name/1,
	format_in_status/1]).

-include("nb.hrl").

%%-------------------------------------------------------------
%%Associates: Exported functions
%%-------------------------------------------------------------

open_associates_db() ->
	File = associates,
	{ok, associates} = dets:open_file(File,
					 [{keypos,#associate.lname}, {type,set}]).

close_associates_db() ->
	ok = dets:close(associates).

%%--------------------------------------------------------------
%%Put and Get functions

put_associate(Record) ->
	open_associates_db(),
	ok = dets:insert(associates, Record),
	close_associates_db().

get_associate(LName) ->
	open_associates_db(),
	[Record] = dets:lookup(associates, LName),
	close_associates_db(),
	Record.

%%-------------------------------------------------------------
%% List all associates
get_associates() ->
	open_associates_db(),
	List = lists:sort(dets:match_object(associates, '_')),
	close_associates_db(),
	List.

%%------------------------------------------------------------
format_name(#associate{lname=LName, fname=FName, ext=Ext, in=In}) ->
	Status = format_in_status(In),
	format_name(LName, FName, Ext, Status).

format_name(LName, FName, [], Status) ->
	[Status, LName, ",", FName];

format_name(LName, FName, Ext, Status) ->
	Fullname = [LName, ",", FName],
	[Status, Fullname, "- ext: ", Ext].

format_in_status(true) -> "IN: ";
format_in_status(false) -> "OUT: ".

