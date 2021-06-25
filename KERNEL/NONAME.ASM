	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "noname.c"
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E96B997619086E6F6E616D652E63
_BSS	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 2
_main	proc	near
	push	si
;	?debug	L 4
	mov	si,offset DGROUP:s@
;	?debug	L 5
	push	si
	mov	ax,1
	push	ax
	call	near ptr _envia
	pop	cx
	pop	cx
@1:
;	?debug	L 6
	pop	si
	ret	
_main	endp
;	?debug	L 7
_envia	proc	near
	push	bp
	mov	bp,sp
	sub	sp,2
;	?debug	L 10
	mov	ax,word ptr [bp+4]
	mov	word ptr [bp-2],ax
;	?debug	L 11
	mov	dx,word ptr [bp+6]
@2:
;	?debug	L 12
	mov	sp,bp
	pop	bp
	ret	
_envia	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
	db	83
	db	69
	db	32
	db	73
	db	78
	db	73
	db	67
	db	73
	db	65
	db	32
	db	67
	db	79
	db	77
	db	85
	db	78
	db	73
	db	67
	db	65
	db	67
	db	73
	db	79
	db	78
	db	0
_DATA	ends
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_main
	public	_envia
	end
