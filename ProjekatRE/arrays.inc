.386
.model flat, stdcall

TreeNode STRUCT
	Chr		BYTE 0
	val		DWORD 0
	Left	DWORD 0
	Right	DWORD 0
TreeNode ENDS



sortQueue PROTO,
			Array: PTR TreeNode,
			ArrLen:  DWORD

insertInQueue PROTO,
			Array: PTR TreeNode,
			ArrLen: PTR DWORD,
			buffer: PTR BYTE,
			bytesRead: DWORD



insert PROTO,
			Array: PTR TreeNode,
			ArrLen: PTR DWORD,
			Chr: BYTE


moveTwo PROTO,
			InitArray: PTR TreeNode,
			InitLen: PTR DWORD,
			TreeArray: PTR TreeNode,
			TreeLen: PTR DWORD

shiftLeftTwo PROTO,
			Array: PTR TreeNode,
			Len: PTR DWORD



sortNode PROTO,
			Array: PTR TreeNode,
			Len: PTR DWORD

moveRight PROTO,
			Array: PTR TreeNode,
			Pos: PTR DWORD


getRoot PROTO,
			Queue: PTR TreeNode,
			QueueLen: PTR DWORD,
			Tree: PTR TreeNode,
			TreeLen: PTR DWORD,
			Root: PTR TreeNode