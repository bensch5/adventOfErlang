-module(day1).
-export([day1/1, day1_test/0]).

get_input(Filepath) ->
    {ok, File} = file:read_file(Filepath),
    unicode:characters_to_list(File).
    
day1(Filepath) ->
    List = get_input(Filepath),
    lists:max(process(List)).

process([]) ->
    [];
process(List) ->
    {Backpack, T} = backpack_parser(List),
    [lists:sum(Backpack)|process(T)].

%% backpack_parser : Liste -> {Backpack = [Meal, Meal2, Meal3], T}
%% 
%% Fälle:
%%  Ende von Backpack: {[], T}
%%  noch kein Ende: {Meal, T}

backpack_parser([]) ->
    {[], []};
backpack_parser(List) ->
    case meal_parser(List) of
        {[], T} -> {[], T};
        {Meal, T} -> case backpack_parser(T) of
                        {[], Rest} -> {[list_to_integer(Meal)], Rest};
                        {Meals, Rest} -> {[list_to_integer(Meal)|Meals], Rest}
        end
    end.

%% meal_parser : Liste -> {Parsed_Meal, T}
%% quasi split bei 10

meal_parser([]) ->
    {[], []};
% skip carriage return if encountered
meal_parser([13|T]) ->
    meal_parser(T);
% new line found, marks the end of current meal
meal_parser([10|T]) ->
    {[], T};
meal_parser([H|T]) ->
    {Parsed, Rest} = meal_parser(T),
    {[H|Parsed], Rest}.

day1_test() ->
    Input = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000",
    24000 = day1(Input),
    ok.