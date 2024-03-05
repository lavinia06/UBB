
%a. Write a predicate to determine the difference of two sets.
%b. Write a predicate to add value 1 after every even element from a list.

nrOcc([], _, 0).
nrOcc([H|T], E, P):-
    H=:=E,
    nrOcc(T, E, P1),
    P is P1+1.
nrOcc([H|T], E, P):-
    H=\=E,
    nrOcc(T, E, P).

dif([], [], []).
dif([_], [],[_]).
dif([H1|T1], L, R):-
    nrOcc(L, H1, RR),
    RR>0,
    dif(T1, L, R).
dif([H1|T1], L, [H1|R]):-
    nrOcc(L, H1, RR),
    RR<1,
    dif(T1, L, R).


%B

insert1([], []).
insert1([H|T], [H,1|R]):-
    H mod 2 =:= 0,
    insert(T, R).
insert1([H|T], [H|R]):-
    H mod 2 =\= 0,
    insert1(T, R).


