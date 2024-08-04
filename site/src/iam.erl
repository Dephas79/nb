%% Copyright 2024 beta

-module(iam).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("nb.hrl").

main() ->
    #template{file="./site/templates/bare.html"}.
title() ->
    "I am...".

body() ->
    #panel{id=inner_body, body=inner_body()}.

inner_body() ->
    [
        #h1{ text="I am..." },
        associate_dropdown(),
        #button{id=toggle, postback=toggle, text="Toggle"}
].

format_iam(List) ->
    [format_name(X) || X <- List].

format_name(Associate) ->
    #associate{lname=LName, fname=FName, in=In} = Associate,
    Status = associates_db:format_in_status(In),
    Name = [Status, " ", LName, ",", FName],
    #option{text=Name, value=LName}.


%% Dropdown for associates

associate_dropdown() ->
    Associates = associates_db:get_associates(),
    #dropdown{
        id=associate,
        value="",
        options=format_iam(Associates)
}.

event(toggle) ->
    Associate = wf:q(associate),
    Record = associates_db:get_associate(Associate),
    wf:info("~w~n",[Record]),
    Record1 = toggle_status(Record),
    wf:info("~w~n", [Record1]),
    associates_db:put_associate(Record1),
    wf:redirect("/").

%%  Define toggle_status/1
toggle_status(Rec = #associate{in=Status}) ->
    Rec#associate{in = not(Status)}.

