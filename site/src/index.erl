%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.

title() -> "Welcome to Nitrogen".

body() ->
  Visitors = visitors_db:get_visitors(date()),
  Associates = associates_db:get_associates(),
  [
    #h1{ text="WELCOME!" },
    #list{numbered=false,
    body = format_visitors(Visitors)},
    
  #hr{},
  #h4{text="Associates Directory"},
  #hr{},
  #list{numbered=false, body=format_associates(Associates)}
].

format_associates(List) ->
  [format_associate(X) || X <- List].

format_associate(Associate) ->
  Name = associates_db:format_name(Associate),
  #listitem{text=Name, class="associates"}.

format_visitors(List) ->
  [format_visitor(X) || X <- List].

format_visitor(Visitor) ->
  Name = visitors_db:format_name(Visitor),
  #listitem{text=Name, class="visitors"}.

