-module(day1).
-compile(export_all).

% get_input(Filepath) ->
%     {ok, IoDevice} = os:open(Filepath, read),
%     IoDevice.

% read_lines(IoDevice) -> 
%     
% read_lines({ok, Data}) -> 

process([]) ->
    [];
process(List) ->
    {Backpack, T} = backpack_parser(List),
    BackpackVals = [lists:sum(Backpack)|process(T)],
    lists:max(BackpackVals).


%% backpack_parser : Liste -> {Backpack, T}
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
% return when non digit is found
meal_parser([H|T]) when (H < 48) or (H > 57) ->
    {[], T};
meal_parser([H|T]) ->
    {Parsed, Rest} = meal_parser(T),
    {[H|Parsed], Rest}.


%% [49 48 48 48 10 49]
%% [49 48 48 48 13 10 49]
%% 

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
    24000 = process(Input),
    ok.