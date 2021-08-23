.386
.model flat, stdcall
.stack 4096

INCLUDE irvine32.inc
INCLUDE ioSystem.inc
INCLUDE arrays.inc
INCLUDE tree.inc

ExitProcess proto, dwExitCode:dword


BUFSIZE = 5000
MAX_Queue_SIZE = 100

.data?
bytesRead DWORD ?


.data
buffer BYTE BUFSIZE DUP(0)

QueueLen DWORD 0
Queue TreeNode MAX_Queue_SIZE DUP(<>)
Tree TreeNode MAX_Queue_SIZE DUP(<>)
TreeLen DWORD 0
TreeRoot TreeNode <0, 0, 0, 0>


crr BYTE "crr rtn", 0
nl BYTE "00001111", 0
node BYTE "node", 0

outStr BYTE 50 DUP(0)
strLen DWORD 0

.code
main proc

INVOKE ioFunc, ADDR buffer, ADDR bytesRead

INVOKE insertInQueue, ADDR Queue, ADDR QueueLen, ADDR buffer, bytesRead

INVOKE sortQueue, ADDR Queue, QueueLen

INVOKE getRoot, ADDR Queue, ADDR QueueLen, ADDR Tree, ADDR TreeLen, ADDR TreeRoot

INVOKE output, ADDR TreeRoot, ADDR outStr, ADDR strLen, 0



main endp

end main