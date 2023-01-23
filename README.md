# Introduzione 

Ai tempi di Simula e del primo Smalltalk, molto molto tempo prima di Python, 
Ruby, Perl e SLDJ, i programmatori Lisp gi`a producevano una pletora di 
linguaggi object oriented. Il vostro progetto consiste nella costruzione di 
un’estensione “object oriented” di Common Lisp, chiamata OOΛ, e di 
un’estensione “object oriented” di Prolog, chiamata OOΠ. 

# Primitive

## def_class

__SINTASSI:
def_class ’(’ <class-name> ’,’ <parents> ’,’ <slot-values> ’)’__

Definisce la struttura di una classe e la memorizza nella 
"base di conoscenza" di Prolog.

Carica inoltre eventuali metodi in <slot-values>

Utilizziamo un'altra variante di def_class/3 senza 
metodi dentro <slot-values>

## create

__SINTASSI:
create ’(’ <instance-name> ’,’
<class-name> ’,’
’[’ [ <slot-name> ’=’ <value>
[ ’,’ <slot-name> ’=’ <value> ]* ]*
’]’
’)’__

Crea un'istanza dato il nome dell'istanza e della classe

A seconda di che cosa è il primo argomento <instance-name>, 
il comportamento di create cambia.

Il primo argomento può assumere il valore di simbolo, 
variabile, oppure un termine che unifica con la nuova istanza 
appena creata

## is_class

__SINTASSI:
is_class ’(’ <class-name> ’)’__

Controlla se <class-name> è il nome di una classe

## is_instance

__SINTASSI:
is_instance ’(’ <value> ’)’
is_instance ’(’ <value> ’,’ <class-name> ’)’__

Controlla se l'istanza passata con il nome <class-name> 
è un'istanza

## inst

__SINTASSI:
inst ’(’ <instance-name> ’,’ <instance> ’)’__

Dato il nome di un'istanza, ritorna la vera e propria istanza

## slot

__SINTASSI:
slot ’(’ <instance> ’,’ <slot-name> ’,’ <result> ’)’__

Estrae da un'istanza con campo <slot-name> il suo valore 
<result>.

Può anche estrarre <result> da classi e parents.

## slotx

__SINTASSI:
slotx ’(’ <instance> ’,’ <slot-names> ’,’ <result> ’)’__

Estrae il valore da una classe percorrendo una catena di 
attributi.

# Funzioni


## create_method

__SINTASSI:
create_method(MethodName = method(Args, MethodBody), Class_name)__

Si occupa di creare e caricare il metodo


## get_data

__SINTASSI:
get_data(Instance, Slot_name, Result)__

Recupera il valore di <slot-name> data un'istanza.

Può essere utilizzato anche su classi.

## load_methods

__SINTASSI:
load_methods([Method | Rest], Class_name)__

Chiama create_method per ogni metodo presente nella lista


## get_parents

__SINTASSI:
get_parents(Class, Result)__

Data una classe restituisce tutti i suoi genitori e toglie i duplicati

## parents

__SINTASSI:
parents([Class | _], Result)__

Data una classe restituisce tutti i suoi genitori

# Predicati Utili

## remove_duplicates

Data in input una lista con duplicati, li rimuove dalla lista

## first

Data in input una lista, restituisce il primo elemento

## tail

Data in input una lista, restituisce la tail

## second

Data in input una lista, restituisce il secondo elemento

## fourth

Data in input una lista, restituisce il quarto elemento

## penultimo

Data in input una lista, restituisce il penultimo elemento

## one

Data in input una lista controlla se è composta da un solo elemento

## is_empty

Data in input una lista, restituisce true se è vuota

## replace_word

Data in input una stringa, una parola da sostituire e la nuova parola, 
restituisce la stringa con la parola sostituita

## replace_ennesima_parola

Data in input una stringa, l'occorrenza della parola, una parola da sostituire e la nuova parola, 
restituisce la stringa con la parola sostituita all'occorrenza specificata

# Alcuni Test Effettuati

def_class(person, [], [name = 'Eve', age = undefined]).
true.

def_class(student, [person], [name = 'Eva Lu Ator', university = 'Berkeley', talk = method([], (write('My name is '), slot(this, name, N), write(N), nl, write('My age is '), slot(this, age, A), write(A), nl))]).
true.

def_class(studente_bicocca, [student],[talk = method([],(write('Mi chiamo '),slot(this, name, N),write(N),nl,write('e studio alla Bicocca.'),nl)),to_string = method([ResultingString],(with_output_to(string(ResultingString),(slot(this, name, N),slot(this, university, U),format('#<~w Student ~w>',[U, N]))))), university = 'UNIMIB']).
true.

create(eve, person).
true.

create(adam, person, [name = 'Adam']).
true.

create(s1, student, [name = 'Eduardo De Filippo', age = 108]).
true.

create(s2, student).
true.

slot(eve, age, A).
A = undefined.

slot(s1, age, A).
A = 108.

slot(s2, name, N).
N = 'Eva Lu Ator'.

slot(eve, address, Address).
false.

talk(s1).
My name is Eduardo De Filippo
My age is 108
true.

talk(eve).
false.

create(ernesto, studente_bicocca, [name = 'Ernesto']).
true.

talk(ernesto).
Mi chiamo Ernesto
e studio alla Bicocca.
true.

create(test, studente_bicocca, [talk = method([], (write('Test metodo instanza, my name '), slot(this, name, N), write(N), nl, write('My age is '), slot(this, age, A), write(A), nl))]).
true.

talk(test).
Test metodo instanza, my name Eva Lu Ator
My age is undefined
true.

# Autori e Info

ENG: This is an italian project, Doc and comments in italian. Grade: 28/30

Made by Elio Gargiulo, Stefano Rigato for UNIMIB Linguaggi di Programmazione Course.
