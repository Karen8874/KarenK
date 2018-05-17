/* Pasar a SWI-PROLOG*/

/*Analizador de Lenguaje Natural basado en Maquina de Estados*/
domains
frase = string

database
palabra(symbol, symbol)
/*tipo, palabra*/
estado(symbol) /*estado actual de la frase*/
predicates
siguiente_palabra(frase,frase, symbol)
encontrar_delim(frase, integer, integer)
analizar(frase)
quitar_espacios(frase, frase)
procesar(symbol, symbol)
purgar.
start.
goal:-
/*cargar un pequeño vocabulario*/
    assert(palabra(nombre, puerta)),
    assert(palabra(nombre, ventana)),
    assert(palabra(nombre, casa)),
    assert(palabra(nombre, "niño")),
    assert(palabra(verbo, tiene)),
    assert(palabra(verbo, corre)),
    assert(palabra(verbo, juega)),
    assert(palabra(adjetivo, alto)),
    assert(palabra(adjetivo, alta)),
    assert(palabra(adverbio, rápidamente)),
    assert(palabra(artículo, el)),
    assert(palabra(artículo, la)),
    assert(palabra(artículo, un)),
    assert(palabra(preposición, hacia)).
clauses

/*analizar la frase*/
start:-
    write("Introduzca frase: "),
    readln(S),
    analizar(S),!,
    write("Frase OK"),nl.
start:-
    write("Error en la frase"),nl.

analizar(S):-
    predicado_nominal(S, S2, NP),
    write("el predicado nominal es ", NP),nl,
    predicado_verbal(S2,S3,VP),
    write("el predicado verbal es ",VP),nl,
    terminador(S3).

/*obtener cada pieza*/
predicado_nominal(S,S2,NP):- /*no adjetivo*/
    siguiente_palabra(S,S1,W),
    palabra(articulo,W),
    añadir(W,[],T),
    siguiente_palabra(S1,S2,W2),
    palabra(nombre,W2),
    juntar(T,[W2],NP).
predicado_nominal(S,S3,NP):- /*sin adjetivo*/
    siguiente_palabra(S,S1,W),
    palabra(articulo,W),
    añadir(W,[],T),
    siguiente_palabra(S1,S2,W2),
    palabra(adjetivo,W2),
    juntar(T,[W2],T2),
    siguiente_palabra(S2,S3,W3),
    palabra(nombre,W3),
    juntar(T2,[W3],NP).
predicado_nominal(S,S2,NP):- /*frases preposicionales*/
    siguiente_palabra(S,S1,W),
    palabra(preposicion,W),
    predicado_nominal(S1,S2,T),
    juntar([W],T,NP).
predicado_verbal(S,S3,VP):- /*verbo + adverbio + PN*/
    siguiente_palabra(S,S1,W),
    palabra(verbo,W),
    siguiente_palabra(S1,S2,A),
    palabra(adverbio,A),
    predicado_nominal(S2,S3,T),
    juntar([A],T,T2),
    juntar([W],T2,VP).
predicado_verbal(S,S2,VP):- /*verbo + PN*/
    siguiente_palabra(S,S1,W),
    palabra(verbo,W),
    predicado_nominal(S1,S2,T),
    juntar([W],T,VP).
predicado_verbal(S,S2,VP):- /*solo verbo + adverbio*/
    siguiente_palabra(S,S1,W),
    palabra(verbo,W),
    siguiente_palabra(S1,S2,A),
    palabra(adverbio,A),
    añadir(W,[],T),
    juntar(T,[A],VP).
predicado_verbal(S,S2,VP):- /*solo verbo*/
    siguiente_palabra(S,S2,W),
    palabra(verbo,W),
    añadir(W,[],VP).

/*encontrar punto*/
terminador(S):-
    frontchar(S,CH,_),
CH='.'.

/*encontrar espacio con un punto*/
encontrar_delim(S,Count,C):-
    frontchar(S,CH,S2),
    CH<>' ', CH<>'.',
    C2=C+1,
    encontrar_delim(S2,Count,C2).
encontrar_delim(_,Count,Count).

/*obtener una palabra cada vez*/
siguiente_palabra(S,S2,W):-
    encontrar_delim(S,Count,0),!,
    Count>0,
    frontstr(Count,S,W,S3),
    quitar_espacios(S3,S2).
quitar_espacios(S,S2):-
    frontchar(S,Ch,S2),
    Ch=' '.
quitar_espacios(S,S).

/*añadir un symbol a una lista*/
añadir(X,L,[X|L]).

juntar([],List,List).
juntar([X|L1],List2,[X|L3]):-
    juntar(L1,List2,L3).










