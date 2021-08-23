INCLUDE irvine32.inc
INCLUDE tree.inc
INCLUDE arrays.inc

ExitProcess proto, dwExitCode:dword


COMMENT !

U tree.asm fajlu nalaze se funkcije koje se koriste za ispis Huffman - ovog stabla

!


.data
carr	BYTE "carr rtn", 0
nl		BYTE "newln", 0
blanc	BYTE "' '", 0


.code


COMMENT !

Funkcija output prvo proverava da li je esi u kome je na pocetku smesten RootNode stigao
do kraja odnosno do LeafNode - a, u slucaju da nije njegovo levo i desno "dete" se smessta u
registre ebx i ecx i za njih se ponovo  poziva funkcija output.Promenljiva bit sluzi tome da
naglasi da li se radi o desnom ili levom detetu(1 za desno, 0 za levo dete).Tek kada se stigne
do LeafNode - a se ispisuje sadrzaj(pozivanjem metode print) njegovog outStr, koji predstavlja njegovu sekvencu 0 i 1,
odnosno predstavu ovog karaktera Huffman - ovim kodom

!


output PROC USES eax ebx ecx edx esi edi,
Node : PTR TreeNode,
outStr : PTR BYTE,
strLen : PTR DWORD,
bit : BYTE


mov esi, Node
mov al, (TreeNode PTR[esi]).Chr

; provera da li je u esi smesten LeafNode

mov dl, bit
.IF(dl > 0)
mov esi, outStr
mov edi, strLen
mov ebx, DWORD PTR[edi]
add esi, ebx
mov BYTE PTR[esi], dl
inc DWORD PTR[edi]
.ENDIF
; U slucaju da jeste LeafNode, al, gde je smesten karakter bice veci od 0 i tada pozivamo metodu print
.IF(al > 0)
INVOKE print, al, outStr, DWORD PTR[edi]
mov BYTE PTR[esi], 0
dec DWORD PTR[edi]
ret
.ENDIF
; u slucaju da nije bio leafNode, za "decu" ovog cvora se ponovo poziva metoda output
mov esi, Node
mov ebx, (TreeNode PTR[esi]).Left
mov ecx, (TreeNode PTR[esi]).Right

INVOKE output, ebx, outStr, strLen, 48
INVOKE output, ecx, outStr, strLen, 49

mov esi, outStr
mov edi, strLen
mov ebx, DWORD PTR[edi]
dec ebx
add esi, ebx
mov BYTE PTR[esi], 0
dec DWORD PTR[edi]

ret
output ENDP



print PROC USES esi ecx eax,
Chr: BYTE,
outStr : PTR BYTE,
strLen : DWORD

mov esi, outStr
mov ecx, strLen


mov al, Chr
.IF(al == 13)
mov edx, OFFSET carr
call WriteString
.ELSEIF(al == 10)
mov edx, OFFSET nl
call WriteString
.ELSEIF(al == 32)
mov edx, OFFSET blanc
call WriteString
.ELSE
call WriteChar
.ENDIF

mov al, 9
call WriteChar

loop1 :
mov al, BYTE PTR[esi]
call WriteChar
inc esi
loop loop1

mov al, 13
call WriteChar
mov al, 10
call WriteChar

ret
print ENDP







END