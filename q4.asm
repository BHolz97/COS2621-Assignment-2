;
; Solution for assignment 02, 2017
;
	bits 16
	org 0x100 ; start offset at memory position 100
	jmp main ; jump to main program
;
; Data definitions
;
mess1: db 'Input any number (0 - 9)', 0dh,0ah,'$'
mess2: db 'The number is a multiple of 3',0dh,0ah,'$'
mess3: db 'The number is not a multiple of 3',0dh,0ah,'$'
errmess: db '**',0dh,0ah,'$'
crlf: db 0dh,0ah, '$'
;
; Display a string on the screen
; DX contains the address of the string
;
display:
	mov 	ah,09 
	int	21h 
	ret
;
; Set the cursor position
;
cursor:
	mov 	ah,02
	mov 	bh,0 ; screen number mov
		dh,0ah ; row
	mov 	dl,0 ; column
	int 	10h
	ret
;
; Display a user prompt
;
prompt:
	mov 	dx,mess1
	call 	display
	ret
;
; Read one character from the keyboard
;
input:
	mov 	ah,01
	int 	21h
	ret
;
; Clear screen and change screen colour
;
screen:
	mov 	ah,06 ; scroll up screen
	mov 	al,0 ; lines to scroll where 0 clear entire screen
	mov 	cx,0 ; starting row:column
	mov 	dl,80 ; ending row;column
	mov 	dh,80
	mov 	bh,17h ; change background color to white on blue
	int 	10h
	ret
;
; Carriage returnm and line feed
;
newline:
	mov 	dx,crlf
	call 	display
	ret
;
; Main program
;
main:
	call 	screen
	call 	cursor
next:
	call 	prompt
	call 	input
	cmp 	al,'0' ; character < 0?
	jl 	error ; yes, error message
	cmp 	al,'9' ; character > 9?
	jg 	error ; yes, error message
	sub 	al,30h ; convert from ASCII to numeric
	xor 	ah,ah ; clear AH
	mov 	bl,3
	idiv 	bl ; divide by 3
	cmp 	ah,0 ; remainder = n0?
	je 	isdiv ; yes: divisible by 3
	call 	newline
	mov 	dx,mess3 ; not divisible by 3
	call 	display
	jmp 	fin
isdiv:
	call 	newline
	mov 	dx,mess2
	call 	display ; divisible by 3
	fin: 	int 20h ; terminate program
;
; Display error message. Number out of range
;
error:
	mov 	dx,errmess
	call 	display
	jmp 	next