%% -*- mode: nitrogen -*-
-module (index).
-compile(export_all).
-include_lib("nitrogen_core/include/wf.hrl").

main() -> #template { file="./site/templates/bare.html" }.
title() -> "Welcome to Nitrogen".

body() ->
  [
    #h1{ text="WELCOME!" },
    #h2{text="Joe Strongman" },
    #h2{text="Rusty Klophaus"}
].