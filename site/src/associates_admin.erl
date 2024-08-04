%% Copyright 2024 beta
%% 
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%% 
%%     https://www.apache.org/licenses/LICENSE-2.0
%% 
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(associates_admin).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").
-include("nb.hrl").

main() -> #template { file="./site/templates/bare.html"}.
title() -> "Associates Admin".

body() ->
    wf:wire(save, lname, #validate{validators=
    #is_required{text="Last Name Required"}    
}),
[
    #h1{ text="Associates Directory" },
    #h3{ text="Enter directory listing"},
    #flash{},
    #label{text="Last Name"},
    #br{},
    #textbox{ id=lname, next=fname},

    #br{},

    #label{text="First Name"},
    #br{},
    #textbox{id=fname, next=ext},

    #br{},

    #label{text="Extension"},
    #br{},
    #textbox{id=ext},
    #br{},
    #button{id=save, postback=save, text="Save"},
    #link{url="/", text="Cancel"}
].

%% function to clear the form
clear_form() ->
    wf:set(lname, ""),
    wf:set(fname, ""),
    wf:set(ext, "").

%% Event functions

event(save) ->
    wf:wire(#confirm{text="Save?", postback=confirm_ok});

event(confirm_ok) ->
    [LName, FName, Extension] =  wf:mq([lname, fname, ext]),
    Record = #associate{lname=LName, fname=FName, ext=Extension},
    associates_db:put_associate(Record),
    clear_form(),
    wf:flash("Saved").

