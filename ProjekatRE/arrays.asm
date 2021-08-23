INCLUDE arrays.inc

ExitProcess proto, dwExitCode:dword

COMMENT !

U ovom asm fajlu su definisane funkcije koje obavljaju logicki najbitniji deo projekta


!

BUFSIZE = 5000
MAX_STR = 50

.data

.code


COMMENT !

Funkcija InsertInQueue formira red elemenata tipa TreeNode(sadrzi karakter, broj njegovih pojavljivanja
	kao i 2 pokazivaca(levi i desni) na njegovu "decu").Unutar ove funkcije, pozvana je i funkcija insert koja izvrsava dodavanje
	novog elementa tipa TreeNode u red, ili, ako vec postoji element sa istim karakterom, povecava broj njegovih ponavljanja

	!


	insertInQueue PROC USES eax ebx edx ecx esi edi,
	Array: PTR TreeNode,
	ArrLen : PTR DWORD,
	buffer : PTR BYTE,
	bytesRead : DWORD


	mov eax, 0
	mov ebx, 0
	mov edx, ArrLen
	mov ecx, buffer
	mov esi, Array
	mov edi, bytesRead

	.WHILE ebx <= edi
	mov al, BYTE PTR[ecx + ebx]

	INVOKE insert, Array, ArrLen, al

	add esi, TYPE TreeNode
	inc ebx
	.ENDW

	dec DWORD PTR[edx]
	ret
	insertInQueue ENDP

	insert PROC USES  esi ecx ebx edi,
	Array: PTR TreeNode,
	ArrLen : PTR DWORD,
	Chr : BYTE


	mov ecx, 0
	mov esi, Array
	mov edi, ArrLen

	.WHILE(ecx <= DWORD PTR[edi])
	mov bl, (TreeNode PTR[esi]).Chr

	.IF(ecx == DWORD PTR[edi])
	mov(TreeNode PTR[esi]).Chr, al
	mov(TreeNode PTR[esi]).val, 1
	inc DWORD PTR[edi]
	.BREAK
	.ENDIF

	.IF(al == bl)
	inc(TreeNode PTR[esi]).val
	.BREAK
	.ENDIF



	add esi, TYPE TreeNode
	inc ecx
	.ENDW


	ret
	insert ENDP

	COMMENT !

	Metoda sortQueue sortira red elemenata tipa TreeNode, prethodno formiranog u funkciji insertInQueue.
	Sortiranje se vrsi po broju pojavljivanja karaktera u datoteci(odnosno frekvenciji karaktera)
	tako sto prvo mesto zauzima onaj koji se najmanje pojavljivao(rastuci poredak).
	Za sortiranje koristi se bubble sort metod.

	!


	sortQueue PROC USES eax esi ecx,
	Array: PTR TreeNode,
	ArrLen : DWORD


	mov ecx, ArrLen
	dec ecx

	L1 :
push ecx
mov esi, Array
L2 :
mov eax, (TreeNode PTR[esi]).val
cmp(TreeNode PTR[esi + TYPE TreeNode]).val, eax
jg L3
xchg eax, (TreeNode PTR[esi + TYPE TreeNode]).val
mov(TreeNode PTR[esi]).val, eax
mov al, (TreeNode PTR[esi]).Chr
xchg al, (TreeNode PTR[esi + TYPE TreeNode]).Chr
mov(TreeNode PTR[esi]).Chr, al
L3 :
add esi, TYPE TreeNode
loop L2
pop ecx
loop L1

ret

sortQueue ENDP



COMMENT !

Metoda moveTwo uzima prva dva TreeNode - a(najmanji broj ponavljanja karaktera) i smesta ih u novi niz,
zatim pozivanjem metode shiftLeftTwo pomera red za 2 mesta ulevo, tako da je sada nekadasnji 3. element
na prvom mestu.Nakon toga od 2 TreeNode - a koji su smesteni u novi niz se formira jedan TreeNode tako sto se
sabira broj pojavljivanja ova 2 karaktera, za polje char se stavlja vrednost 0, a za njegove left i right child se
postavljaju upravo ta 2 TreeNode elementa od kojih je on sacinjen.Nakon toga taj novi TreeNode se dodaje u red
sa ostalim TreeNode elementima i red se ponovo sortira, ovo se obavlja metodom sortNode



!

moveTwo PROC USES esi edi edx ebx eax ecx,
InitArray: PTR TreeNode,
InitLen : PTR DWORD,
TreeArray : PTR TreeNode,
TreeLen : PTR DWORD




mov esi, InitArray
mov edi, TreeArray
mov edx, InitLen
mov ebx, TreeLen
mov eax, DWORD PTR[ebx]
mov ecx, TYPE TreeNode
mul ecx
add edi, eax

; premestanje prvog elementa reda u novi niz

mov al, (TreeNode PTR[esi]).Chr
mov(TreeNode PTR[edi]).Chr, al
mov eax, (TreeNode PTR[esi]).val
mov(TreeNode PTR[edi]).val, eax
mov eax, (TreeNode PTR[esi]).Left
mov(TreeNode PTR[edi]).Left, eax
mov eax, (TreeNode PTR[esi]).Right
mov(TreeNode PTR[edi]).Right, eax





add edi, TYPE TreeNode
add esi, TYPE TreeNode
mov eax, 0


; premestanje drugog elementa reda u novi niz


mov al, (TreeNode PTR[esi]).Chr
mov(TreeNode PTR[edi]).Chr, al
mov eax, (TreeNode PTR[esi]).val
mov(TreeNode PTR[edi]).val, eax
mov eax, (TreeNode PTR[esi]).Left
mov(TreeNode PTR[edi]).Left, eax
mov eax, (TreeNode PTR[esi]).Right
mov(TreeNode PTR[edi]).Right, eax



add DWORD PTR[ebx], 2

INVOKE shiftLeftTwo, InitArray, InitLen; pomera red za 2 mesta ulevo

; formiranje novog TreeNode - a i dodavanje tog elementa na kraj reda

mov esi, InitArray
mov ebx, InitLen
mov eax, DWORD PTR[ebx]
dec eax
mov ecx, TYPE TreeNode
mul ecx
mov ebx, (TreeNode PTR[edi]).val
sub edi, TYPE TreeNode
add ebx, (TreeNode PTR[edi]).val


mov(TreeNode PTR[esi + eax]).Chr, 0
mov(TreeNode PTR[esi + eax]).val, ebx
mov(TreeNode PTR[esi + eax]).Left, edi

add edi, TYPE TreeNode
mov(TreeNode PTR[esi + eax]).Right, edi

INVOKE sortNode, InitArray, InitLen

mov eax, InitLen
dec DWORD PTR[eax]

ret

moveTwo ENDP



COMMENT !

Metoda shiftLeftTwo radi tako sto je u ecx registar smestena duzina niza(ukljucujuci 2 prazna mesta),
dok je u ebx registar smestena vrednost 2. U edi je smestena adresa 3. elementa niza(koji treba da postane prvi),
dok je u esi smestena adresa prvog elementa, koji treba da se pregazi trecim.Kopiraju se sva polja iz treceg u prvi, a
zatim se polja treceg popunjavaju nulama jer ce ona svakako biti pregazena kasnije, na kraju se inkrementira ebx, a edi i esi
se pomeraju za jedno mesto unapred.Ovo se ponavlja sve dok ebx ne dostigne vrednost ecx registra.

!


shiftLeftTwo PROC USES edi,
Array: PTR TreeNode,
Len : PTR DWORD



mov esi, Array
mov edi, esi
add edi, TYPE TreeNode
add edi, TYPE TreeNode
mov edx, Len
mov ecx, DWORD PTR[edx]
mov ebx, 2

.WHILE(ebx < ecx)

	mov al, (TreeNode PTR[edi]).Chr
	mov(TreeNode PTR[esi]).Chr, al
	mov(TreeNode PTR[edi]).Chr, 0
	mov eax, (TreeNode PTR[edi]).val
	mov(TreeNode PTR[esi]).val, eax
	mov(TreeNode PTR[edi]).val, 0
	mov eax, (TreeNode PTR[edi]).Left
	mov(TreeNode PTR[esi]).Left, eax
	mov(TreeNode PTR[edi]).Left, 0
	mov eax, (TreeNode PTR[edi]).Right
	mov(TreeNode PTR[esi]).Right, eax
	mov(TreeNode PTR[edi]).Right, 0

	add edi, TYPE TreeNode
	add esi, TYPE TreeNode
	inc ebx
	.ENDW


	ret
	shiftLeftTWo ENDP

	COMMENT !

	Metoda sortNode funkcionise na sledeci nacin :
-esi registar pokazuje na novonapravljeni TreeNode, koji se nalazi na samom kraju reda
- vrednost novonastalog TreeNode - a se smesta u edx registar i od poslednjeg clana ka prvom se uporedjuje sa vrednostima ostalih elemenata reda
- U slucaju da je vrednost manja od od poslednje vrednosti, ta poslednja vrednost se premesta za jedno mesto desno, pozivanjem metode moveRight
a na njena sva polja se stavljaju nule
- Kada se nadje mesto gde novonastali element treba da se ubaci, nule ce se pregaziti njegovim vrednostima i red ce biti sortiran



!

sortNode PROC,
Array: PTR TreeNode,
Len : PTR DWORD

; postavljanje esi registra na poziciju novonastalog elementa, a edi na mesto poslednjeg elementa reda.

mov esi, Array
mov edx, Len
mov eax, DWORD PTR[edx]
dec eax
mov ecx, TYPE TreeNode
mul ecx
mov edx, Len
add esi, eax
mov edi, esi
sub edi, TYPE TreeNode
sub edi, TYPE TreeNode


mov ecx, DWORD PTR[edx]
sub ecx, 2
mov ebx, 0
mov edx, (TreeNode PTR[esi]).val
.WHILE(ebx < ecx)
	mov eax, (TreeNode PTR[edi]).val
	.IF(edx >= eax) && (eax != 0)
	.BREAK; u slucaju da je pozicija novonastalog elementa pronadjena
	.ELSE
	INVOKE moveRight, Array, edi; u slucaju da novonastali element ne treba da se postavi na dato mesto
	.ENDIF

	sub edi, TYPE TreeNode
	inc ebx
	.ENDW

	; postavljanje vrednosti novonastalog registra na mesto koje je pronadjeno(gazenje nula)

	add edi, TYPE TreeNode

	mov eax, (TreeNode PTR[esi]).val
	mov(TreeNode PTR[esi]).val, 0
	mov(TreeNode PTR[edi]).val, eax

	mov eax, (TreeNode PTR[esi]).Left
	mov(TreeNode PTR[esi]).Left, 0
	mov(TreeNode PTR[edi]).Left, eax

	mov eax, (TreeNode PTR[esi]).Right
	mov(TreeNode PTR[esi]).Right, 0
	mov(TreeNode PTR[edi]).Right, eax



	ret
	sortNode ENDP

	; pomera edi za jedno mesto u desno i na njegovu staru poziciju stavlja sve nule

	moveRight PROC USES esi edi eax,
	Array: PTR TreeNode,
	Pos : PTR DWORD



	mov edi, Pos
	mov esi, edi
	add esi, TYPE TreeNode
	mov eax, 0

	mov al, (TreeNode PTR[edi]).Chr
	mov(TreeNode PTR[edi]).Chr, 0
	mov(TreeNode PTR[esi]).Chr, al

	mov eax, (TreeNode PTR[edi]).val
	mov(TreeNode PTR[edi]).val, 0
	mov(TreeNode PTR[esi]).val, eax

	mov eax, (TreeNode PTR[edi]).Left
	mov(TreeNode PTR[edi]).Left, 0
	mov(TreeNode PTR[esi]).Left, eax

	mov eax, (TreeNode PTR[edi]).Right
	mov(TreeNode PTR[edi]).Right, 0
	mov(TreeNode PTR[esi]).Right, eax


	ret
	moveRight ENDP

	COMMENT !

	Metoda getRoot je ona koja pokrece sve manipulacije redom koji smo sortirali.
	Naime, ova metoda poziva metodu moveTwo, sve dok u nasem redu ne ostane samo jedan clan - Root.

	!




	getRoot PROC USES esi eax edi,
	Queue: PTR TreeNode,
	QueueLen : PTR DWORD,
	Tree : PTR TreeNode,
	TreeLen : PTR DWORD,
	Root : PTR TreeNode

	mov esi, QueueLen
	mov eax, DWORD PTR[esi]

	; pozivanje metode moveTwo sve dok ne ostane samo jedan element u redu

	.WHILE(eax > 1)
	INVOKE moveTwo, Queue, QueueLen, Tree, TreeLen
	mov esi, QueueLen
	mov eax, DWORD PTR[esi]
	.ENDW

	; postavljanje vrednosti Root - a kada nam u redu ostane samo jedan element

	mov esi, Root
	mov edi, Queue
	mov eax, 0

	mov al, (TreeNode PTR[edi]).Chr
	mov(TreeNode PTR[esi]).Chr, al

	mov eax, (TreeNode PTR[edi]).val
	mov(TreeNode PTR[esi]).val, eax


	mov eax, (TreeNode PTR[edi]).Left
	mov(TreeNode PTR[esi]).Left, eax

	mov eax, (TreeNode PTR[edi]).Right
	mov(TreeNode PTR[esi]).Right, eax

	ret
	getRoot ENDP




	END