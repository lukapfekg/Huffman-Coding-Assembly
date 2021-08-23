.386
.model flat, stdcall

output PROTO,
			Node: PTR TreeNode,
			outStr: PTR BYTE,
			strLen: PTR DWORD,
			bit: BYTE

print PROTO, 
			Chr : BYTE,
			outStr: PTR BYTE,
			strLen: DWORD