-----------------------------------------
Ai tempi di Simula e del primo Smalltalk, molto molto tempo prima di Python, 
Ruby, Perl e SLDJ, i programmatori Lisp gi`a producevano una pletora di 
linguaggi object oriented. Il vostro progetto consiste nella costruzione di 
un’estensione “object oriented” di Common Lisp, chiamata OOΛ, e di 
un’estensione “object oriented” di Prolog, chiamata OOΠ. 
-----------------------------------------
		PRIMITIVE
-----------------------------------------

NOME:
def_class

SINTASSI:
def_class ’(’ <class-name> ’,’ <parents> ’,’ <slot-values> ’)’

PARTICOLARI:
Definisce la struttura di una classe e la memorizza nella 
"base di conoscenza" di Prolog.

Carica inoltre eventuali metodi in <slot-values>

Utilizziamo un'altra variante di def_class/3 senza 
metodi dentro <slot-values>
-----------------------------------------
NOME:
create

SINTASSI:
create ’(’ <instance-name> ’,’
<class-name> ’,’
’[’ [ <slot-name> ’=’ <value>
[ ’,’ <slot-name> ’=’ <value> ]* ]*
’]’
’)’

PARTICOLARI:
Crea un'istanza dato il nome dell'istanza e della classe

A seconda di che cosa è il primo argomento <instance-name>, 
il comportamento di create cambia.

Il primo argomento può assumere il valore di simbolo, 
variabile, oppure un termine che unifica con la nuova istanza 
appena creata
-----------------------------------------
NOME:
is_class

SINTASSI:
is_class ’(’ <class-name> ’)’

PARTICOLARI:
Controlla se <class-name> è il nome di una classe
-----------------------------------------
NOME:
is_instance

SINTASSI:
is_instance ’(’ <value> ’)’
is_instance ’(’ <value> ’,’ <class-name> ’)’

PARTICOLARI:
Controlla se l'istanza passata con il nome <class-name> 
è un'istanza
-----------------------------------------
NOME:
inst

SINTASSI:
inst ’(’ <instance-name> ’,’ <instance> ’)’

PARTICOLARI:
Dato il nome di un'istanza, ritorna la vera e propria istanza
-----------------------------------------
NOME:
slot

SINTASSI:
slot ’(’ <instance> ’,’ <slot-name> ’,’ <result> ’)’

PARTICOLARI:
Estrae da un'istanza con campo <slot-name> il suo valore 
<result>.

Può anche estrarre <result> da classi e parents.
-----------------------------------------
NOME:
slotx

SINTASSI:
slotx ’(’ <instance> ’,’ <slot-names> ’,’ <result> ’)’

PARTICOLARI:
Estrae il valore da una classe percorrendo una catena di 
attributi.
-----------------------------------------
		FUNZIONI
-----------------------------------------

NOME:
create_method

SINTASSI:
create_method(MethodName = method(Args, MethodBody), Class_name)

PARTICOLARI:
Si occupa di creare e caricare il metodo
-----------------------------------------
NOME:
get_data

SINTASSI:
get_data(Instance, Slot_name, Result)

PARTICOLARI:
Recupera il valore di <slot-name> data un'istanza.

Può essere utilizzato anche su classi.
-----------------------------------------
NOME:
load_methods

SINTASSI:
load_methods([Method | Rest], Class_name)

PARTICOLARI:
Chiama create_method per ogni metodo presente nella lista
-----------------------------------------
NOME:
get_parents

SINTASSI:
get_parents(Class, Result)

PARTICOLARI:
Data una classe restituisce tutti i suoi genitori e toglie i duplicati
-----------------------------------------
NOME:
parents

SINTASSI:
parents([Class | _], Result)

PARTICOLARI:
Data una classe restituisce tutti i suoi genitori
-----------------------------------------
	PREDICATI UTILI
-----------------------------------------

NOME:
remove_duplicates

PARTICOLARI:
Data in input una lista con duplicati, li rimuove dalla lista
-----------------------------------------
NOME:
first

PARTICOLARI:
Data in input una lista, restituisce il primo elemento
-----------------------------------------
NOME:
tail

PARTICOLARI:
Data in input una lista, restituisce la tail
-----------------------------------------
NOME:
second

PARTICOLARI:
Data in input una lista, restituisce il secondo elemento
-----------------------------------------
NOME:
fourth

PARTICOLARI:
Data in input una lista, restituisce il quarto elemento
-----------------------------------------
NOME:
penultimo

PARTICOLARI:
Data in input una lista, restituisce il penultimo elemento
-----------------------------------------
NOME:
one

PARTICOLARI:
Data in input una lista controlla se è composta da un solo elemento
-----------------------------------------
NOME:
is_empty

PARTICOLARI:
Data in input una lista, restituisce true se è vuota
-----------------------------------------
NOME:
replace_word

PARTICOLARI:
Data in input una stringa, una parola da sostituire e la nuova parola, 
restituisce la stringa con la parola sostituita
-----------------------------------------
NOME:
replace_ennesima_parola

PARTICOLARI:
Data in input una stringa, l'occorrenza della parola, una parola da sostituire e la nuova parola, 
restituisce la stringa con la parola sostituita all'occorrenza specificata
-----------------------------------------
	ALCUNI TEST EFFETTUATI
-----------------------------------------

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

-----------------------------------------

EOF