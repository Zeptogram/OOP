%%%% Voto: 28
 
%%% PREDICATI PRINCIPALI

%%% Predicati dinamici (per evitare warnings)
:- dynamic class/1.
:- dynamic inst/1.

%%% def_class/3: definisce una classe, caricando eventuali metodi
def_class(Class_name, Parents, Slot_values) :- 
    atom(Class_name),
    is_list(Parents),
    is_list(Slot_values),
    %% controllo se i parents esistiono
    maplist(is_class, Parents),
    %% controllo esistenza dei methods
    check_method(Slot_values, _),
    assert(class([Class_name, Parents, Slot_values])),
    %% ottengo la lista dei metodi
    bagof(Method, check_method(Slot_values, Method), Methods),
    load_methods(Methods, Class_name), !.

%%% def_class/3: variante senza metodi presenti in slot_values
def_class(Class_name, Parents, Slot_values) :- 
    atom(Class_name),
    is_list(Parents),
    %% controllo se i parents esistiono
    maplist(is_class, Parents),
    is_list(Slot_values),
    assert(class([Class_name, Parents, Slot_values])),!.

%%% is_class/1: controlla se class_name è il nome di una classe
is_class(Class_name) :- 
    atom(Class_name),
    current_predicate(class/1), !,
    class([Class_name, _, _]).

%%% create/2: creo un'istanza dato il nome della instanza e la classe
create(Instance_name, Class_name) :- 
    atom(Instance_name),
    atom(Class_name),
    is_class(Class_name),
    assert(inst([Instance_name, Class_name])), !.

%%% create/2: creo un'istanza dato il nome della instanza come Var e la classe
create(Instance_name, Class_name) :- 
    var(Instance_name),
    atom(Class_name),
    is_class(Class_name),
    assert(inst([Instance_name, Class_name])),
    Instance_name = inst([Instance_name, Class_name]), !.

%%% create/2: creo un'istanza dato il nome della instanza come term e la classe
create(Instance_name, Class_name) :- 
    atom(Class_name),
    is_class(Class_name),
    Instance_name =.. Instance,
    second(Instance, X),
    is_instance(X), !.

%%% class/3: variante che accetta la presenza di slot_values/metodi
create(Instance_name, Class_name, Slot_values) :-
    atom(Instance_name),
    atom(Class_name),
    is_list(Slot_values),
    is_class(Class_name),
    check_method(Slot_values, _),
    get_slot_names(Slot_values, Slot_names),
    check_slot(Slot_names, Class_name),
    assert(inst([Instance_name, Class_name, Slot_values])),
    bagof(Method, check_method(Slot_values, Method), Methods),
    load_methods(Methods, Instance_name), !.

%%% class/3: variante che accetta la presenza di slot_values
create(Instance_name, Class_name, Slot_values) :-
    atom(Instance_name),
    atom(Class_name),
    is_list(Slot_values),
    is_class(Class_name),
    get_slot_names(Slot_values, Slot_names),
    check_slot(Slot_names, Class_name),
    assert(inst([Instance_name, Class_name, Slot_values])), !.

%%% class/3: variante (con Var) che accetta la presenza di slot_values/methods
create(Instance_name, Class_name, Slot_values) :-
    var(Instance_name),
    atom(Class_name),
    is_list(Slot_values),
    is_class(Class_name),
    check_method(Slot_values, _),
    get_slot_names(Slot_values, Slot_names),
    check_slot(Slot_names, Class_name),
    assert(inst([Instance_name, Class_name, Slot_values])),
    Instance_name = inst([Instance_name, Class_name, Slot_values]),
    bagof(Method, check_method(Slot_values, Method), Methods),
    load_methods(Methods, Instance_name), !.

%%% class/3: variante (con Var) che accetta la presenza di slot_values
create(Instance_name, Class_name, Slot_values) :-
    var(Instance_name),
    atom(Class_name),
    is_list(Slot_values),
    is_class(Class_name),
    get_slot_names(Slot_values, Slot_names),
    check_slot(Slot_names, Class_name),
    assert(inst([Instance_name, Class_name, Slot_values])),
    Instance_name = inst([Instance_name, Class_name, Slot_values]), !.

%%% class/3: variante (con term) che accetta la presenza di slot_values
create(Instance_name, Class_name, Slot_values) :-
    atom(Class_name),
    is_list(Slot_values),
    is_class(Class_name),
    Instance_name =.. Instance,
    second(Instance, X),
    is_instance(X), !.

%%% inst/2: dato il nome di un'istanza, ritorna la vera e propria instanza
inst(Instance_name, [Instance_name | Instance]) :-
    atom(Instance_name), 
    current_predicate(inst/1), !,
    inst([Instance_name | Instance]), !.

%%% get_slot_names/2: ricava i nomi dei campi slot
get_slot_names([Slot | Rest], [SlotName | Slots]) :-
    term_to_atom(Slot, AtomSlot),
    atomic_list_concat(SlotList, =, AtomSlot),
    first(SlotList, SlotName),
    get_slot_names(Rest, Slots), !.
%%% Caso base
get_slot_names([], []).

%%% check_slot/2: controlla se Slot esiste nella classe passata
check_slot([Slot | Rest], Class_name) :-
    slot(Class_name, Slot, _),
    check_slot(Rest, Class_name), !.
%%% Caso base
check_slot([], _).

%%% get_class/2: dato il nome di una classe, ritorna la vera e propria classe
get_class(Class_name, [Class_name | Rest]) :- 
    current_predicate(class/1),
    class([Class_name | Rest]), !.

%%% is_instance/1: controlla se l'instanza passata con il nome è una instanza
is_instance(Value) :- 
    inst(Value, I),
    current_predicate(inst/1),
    inst(I), !.

%%% is_instance/1: accetta come value inst (struttura della instanza)
is_instance(Value) :- 
    current_predicate(inst/1), 
    inst(Value), !.

%%% is_instance/2: variante che controlla se è un'instanza di class_name
is_instance(Value, Class_name) :- 
    atom(Class_name),
    inst(Value, I),
    first(I, Instance_name),
    get_slots(I, Slot_values),
    inst([Instance_name, Class | Slot_values]),
    get_parents(Class, Classes),
    member(Class_name, Classes), !.

%%% is_instance/2: accetta come value inst (struttura della instanza)
is_instance(Value, Class_name) :- 
    atom(Class_name),
    first(Value, Instance_name),
    get_slots(Value, Slot_values),
    inst([Instance_name, Class | Slot_values]),
    get_parents(Class, Classes),
    member(Class_name, Classes), !.

%%% check_method/2: estrae dagli slot_values i methods presenti
check_method(Slot_values, Method) :- 
    first(Slot_values, Method),
    term_to_atom(Method, MethodAtom),
    atomic_list_concat(Slots, '=', MethodAtom),
    second(Slots, Body),
    sub_atom(Body, 0, 6, _, Method_flag),
    Method_flag = method. 
%%% Caso ricorsivo    
check_method([_ | Slots], X) :- check_method(Slots, X).

%%% slot/3: estrae da un'instanza con campo slot il suo valore (result)
slot(Instance, Slot_name, Result) :-
    atom(Slot_name),
    current_predicate(inst/1), 
    is_instance(Instance),
    %% Mi appoggio su get-data
    get_data(Instance, Slot_name, Result), !.

%%% slot/3: variante che permette di ereditare  da eventuali classi parents
slot(Instance, Slot_name, Result) :-
    atom(Slot_name),
    current_predicate(inst/1),
    is_instance(Instance),
    inst([Instance, Classname | _]),
    %% Mi appoggio su slot_parent
    slot_parent([Classname], Slot_name, Result), !.

%%% slot/3: variante che permette di funzionare anche con classi
slot(Instance, Slot_name, Result) :-
    atom(Slot_name),
    current_predicate(class/1),
    is_class(Instance),
    class([Instance, _, _]),
    slot_parent([Instance], Slot_name, Result), !.

%%% slot_parent/3: recupera il valore di slot dalla class che lo ha disponibile
slot_parent([Class | _], Slot_name, Result) :-
    class([Class, _, _]),
    get_data(Class, Slot_name, Result).

%%% Caso ricorsivo
slot_parent([Class | Parents], Slot_name, Result) :-
    class([Class, App_parents, _]),
    append(App_parents, Parents, Parents_list),
    slot_parent(Parents_list, Slot_name, Result).

%%% get_data/3: recupera data un'istanza il valore di slot_name
get_data(Instance, Slot_name, Result) :-
    inst(Instance, I),
    get_data(I, Slot_name, Result), !.

%%% get_data/3: permette l'utilizzo di get_data anche su classi
get_data(Instance, Slot_name, Result) :-
    get_class(Instance, Class),
    get_data(Class, Slot_name, Result), !.

%%% get_data/3: vera e proprio predicato che si occupa dell'estrazione
get_data(Instance, Slot_name, Result) :- 
    atom(Slot_name),
    get_slots(Instance, Slot_values),
    first(Slot_values, Values),
    first(Values, Term),
    term_to_atom(Term, Atom),
    atom_string(Atom, String),
    %% divido per l'=, con stringhe
    split_string(String, "=", "", Slots),
    first(Slots, Slot_name_string),
    atom_string(Slot_name, Slot_name_string),
    second(Slots, Result_string),
    atom_string(Result_atom, Result_string),
    term_to_atom(Result, Result_atom), !.

%%% Caso ricorsivo    
get_data([_, _, [_ | Slots]], Slot_name, Result) :- 
    get_data([_, _, Slots], Slot_name, Result).

%%% slotx/3: estrae il valore da una classe percorrendo una catena di attributi  
slotx(Instance, [Slot], Result) :-
    atom(Slot),
    slot(Instance, Slot, Result), !.

%%% Chiamata ricorsiva
slotx(Instance, [SlotHead | SlotTail], Result) :-
    atom(SlotHead),
    slot(Instance, SlotHead, R1),
    is_instance(R1),
    slotx(R1, SlotTail, Result), !.

%%% create_method/2: si occupa di creare e caricare il metodo
create_method(MethodName = method(Args, MethodBody), Class_name) :-
    append([this], Args, MethodArgs), 
    append([MethodName], MethodArgs, Head),
    %% Utilizzo univ per la "testa" del metodo
    Term =.. Head,
    %% Costruisco il body, con i controlli opportuni
    term_to_atom(MethodName, Name),
    term_to_atom(Term, MethodHead),
    term_to_atom(MethodBody, BodyNoCheck),
    term_to_atom(Class_name, Class),
    atom_concat('slot(this, ', Name, CheckName),
    atom_concat(CheckName, ', MC1),', SlotThis),
    atom_concat(SlotThis, 'slot(', App1SlotClass),
    atom_concat(App1SlotClass, Class, App2SlotClass),
    atom_concat(App2SlotClass, ', ', App3SlotClass),
    atom_concat(App3SlotClass, Name, App4SlotClass),
    atom_concat(App4SlotClass, ', MC2),', SlotClass),
    atom_concat(SlotClass, 'MC1 = MC2', Checker),
    atom_concat(Checker, ',', ToAppend),
    atom_concat(ToAppend, BodyNoCheck, Body),
    atom_concat(MethodHead, ' :- ', MethodNoBody),
    atom_concat(MethodNoBody, Body, MethodNoThisNoEnd),
    atom_concat(MethodNoThisNoEnd, ', !.', MethodNoThis),
    atom_string(MethodNoThis, MethodNoThisString),
    %% Sostituisco il this con una variabile logica (This)
    replace_word(MethodNoThisString, "this", "This", MethodAtom),
    term_to_atom(Method, MethodAtom),
    %% Carico il metodo in cima per priorità
    assert(Method).

%%% load_methods/2: chiama create_method per ogni metodo presente nella lista    
load_methods([Method | Rest], Class_name) :-
    create_method(Method, Class_name),
    load_methods(Rest, Class_name).
%%% Caso base
load_methods([], _).    

%%% get_parents/2: data una classe restituisce tutti i suoi genitori, no dupl
get_parents(Class, Result) :- 
    %% Mi appoggio su parent/2
    bagof(X, parent([Class], X), Bag),
    remove_duplicates(Bag, Result).

%%% parent/2: data una classe (lista), ritorna i genitori
parent([Class | _], Result) :-
    class([Class, _, _]),
    Result = Class.
%%% Chiamata ricorsiva   
parent([Class | Parents], Result) :-
    class([Class, App_parents, _]),
    append(App_parents, Parents, Parents_list),
    parent(Parents_list, Result).

%%% PREDICATI UTILI
%%% Recupera il primo elemento di una lista.
first([H | _], H).    
%%% Recupera la tail di una lista.                
tail([_ | T], T).      
%%% Recupera il secondo elemento di una lista.
second([_, H | _], H).
%%% Recupera il quarto elemento di una lista.
fourth([_, _, _, H | _], H).
%%% Recupera la lista degli slots.
get_slots([_, _ | T], T).
%%% Recupera il penultimo elemento di una lista.
penultimo(X, [X, _]).
penultimo(X, [_ | Z]) :- penultimo(X, Z), !.
%%% True se la lista è di un elemento.
one([_]).
%%% True se la lista è vuota.
is_empty(List):- not(member(_, List)).
%%% Rimpiazza una stringa con un'altra passata in input.
replace_word(Parola, Vecchia, Nuova, X) :-
    replace_ennesima_parola(Parola, 1, Vecchia, Nuova, Result),
    replace_word(Result, Vecchia, Nuova, X), !.
replace_word(Parola, _, _, Parola).
%%% Funzione di appoggio per replace_word.
replace_ennesima_parola(Parola, Ennesima, Vecchia, Nuova, Result) :-
    call_nth(sub_atom(Parola, Before, _Len, After, Vecchia), Ennesima),
    sub_atom(Parola, 0, Before, _, Left), 
    sub_atom(Parola, _, After, 0, Right), 
    atomic_list_concat([Left, Nuova, Right], Result).
%%% Funzione che data in input una lista con duplicati, li rimuove.
remove_duplicates([], []).
remove_duplicates([H | T], Result) :-
    member(H, T), !,
    remove_duplicates(T, Result).
remove_duplicates([H | T], [H | Result]) :-
    remove_duplicates(T, Result).