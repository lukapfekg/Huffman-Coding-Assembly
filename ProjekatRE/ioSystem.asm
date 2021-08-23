INCLUDE irvine32.inc
INCLUDE ioSystem.inc

ExitProcess proto, dwExitCode:dword


BUFSIZE = 5000
MAX_STR = 50

.data
filename BYTE MAX_STR + 1 DUP(? )
fileHandle DWORD ?
invalidFileOpen BYTE "The file was not opened successfully", 0
invalidFileClose BYTE "The file was not opened successfully", 0

.code

COMMENT !

Funkcija ioFunc se poziva iz main - a, kao paramentre prima adresu buffer - a u koji smesta naziv datoteke,
kao i adresu promenljive bytesRead u koju ce smestiti broj karaktera koje sadrzi datoteka.
Ova funkcija koristi nekoliko funkcija definisanih u biblioteci Irvine32 koje znatno olaksavaju rad sa fajlovima

!

ioFunc PROC USES eax ebx ecx edx esi,
buffer : PTR BYTE,
bytesRead : PTR DWORD


mov  edx, OFFSET filename
mov  ecx, MAX_STR
call ReadString; ucitava string unesen sa testature i smesta ga u edx registar

call OpenInputFile; otvara fajl cije se ime nalazi u edx registru, u slucaju da takav fajl ne postoji u eax vraca INVALID_HANDLE_VALUE

.IF(eax == INVALID_HANDLE_VALUE)
mov dl, invalidFileOpen
call writeString
.ENDIF

mov fileHandle, eax

mov  esi, bytesRead
mov  eax, fileHandle
mov  edx, buffer
mov  ecx, BUFSIZE

call ReadFromFile; cita sadrzaj fajla ciji je open file handle prosldjen u eax i taj sadrzaj smesta u buffer
; cija je maksimalna duzina definisana u ecx registru
; u slucaju da je citanje neuspesno set - uje se carry flag

jnc SuccessfulRead
jc UnsuccessfullRead

SuccessfulRead :
mov  DWORD PTR[esi], eax

UnsuccessfullRead :
call WriteWindowsMsg


mov  eax, fileHandle

call CloseFile; zatvara fajl, u slucaju da je fajl uspesno zatvoren u eax ce se upisati vrednost razlicita od 0
cmp eax, 0
jz UnsuccessfullClose
ret

UnsuccessfullClose :
mov dl, invalidFileClose
call writeString
ret






ioFunc ENDP

END