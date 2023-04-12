-module(day1).
-export([day1/1, day1_test/0]).

% prints out puzzle solutions
day1(Filepath) ->
    List = get_input(Filepath),
    io:format("Solution part 1: ~p~n", [part1(List)]),
    io:format("Solution part 2: ~p~n", [part2(List)]).

% reads the puzzle input and turns it into a string
get_input(Filepath) ->
    {ok, File} = file:read_file(Filepath),
    unicode:characters_to_list(File).

% solves part 1 of the puzzle 
part1(List) ->
    lists:max(process(List)).

% solves part 2 of the puzzle
part2(List) ->
    [H1, H2, H3|_T] = lists:reverse(lists:sort(process(List))),
    H1 + H2 + H3.

% parses the input and returns a list of backpack values
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

% parses a single backpack
backpack_parser([]) ->
    {[], []};
backpack_parser(List) ->
    case meal_parser(List) of
        % empty meal represents end of current backpack
        {[], T} -> {[], T};
        {Meal, T} -> case backpack_parser(T) of
                        {[], Rest} -> {[list_to_integer(Meal)], Rest};
                        {Meals, Rest} -> {[list_to_integer(Meal)|Meals], Rest}
        end
    end.

%% meal_parser : Liste -> {Parsed_Meal, T}
%% quasi split bei 10

% parses a single meal
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

% tests
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
    24000 = part1(Input),
    45000 = part2(Input),
    ok.