title Stringbit

.model small 
.data
	message db "Input number from 0 - 65535: ", "$"
	output db "The binary form is: ", "$"
	input dw ? ;user's single digit input
	input2 dw ? ;collection of the combined user's input
.stack 100h
.code
	main proc
	
		mov ax, @data
		mov ds,ax
	
		call getInput ;call get input function
	
		mov ax, 4c00h
		int 21h
	
	main endp
	
	getInput proc
		lea dx, message ;prints message
		mov ah, 09h
		int 21h
		
		mov cl, 0 ;initialize counter for loop1
		mov input2, 0 ;initialize variable
		
		;loop that gets up to 5 user input
		loop1:
			mov ah, 01h
			int 21h
			
			mov ah, 0 ;clear ah
			
			cmp al, 13 ;if enter is pressed jump to endloop
			je endloop
			
			sub al, 48 ;convert to value
			mov input, ax ;move the user input to input variable
			
			mov ax, input2 ;multiply previous input by 10 and add the new input
			mov bx, 10
			mul bx
			add ax, input
			
			mov input2, ax ;final value now stored
			
			inc cl ;increment counter
			xor ax, ax ;clear ax
			
		cmp cl, 4 ;stops after getting 5 inputs
		jle loop1
		
		xor bx,bx ;clear bx
		xor ax,ax;clear ax
		
		endloop:
			clc ;clear carry flag
			mov cl, 0 ;clear counter
			mov bl, 4 ;set bl to 4 (used in printing in nibbles)
			
			mov dl,0ah ;print new line
			mov ah, 02h
			int 21h
			
			lea dx, output ;prints output message
			mov ah, 09h
			int 21h
			
			loop2:
				cmp cl, bl ;if counter is not equal to bl (which inital value is 3) jump to no space 
				jne nospace
				
				;else if we need spaces do not jump to nospace and print this
				
				mov dl, ' ' ;print spaces
				mov ah, 02h
				int 21h
				
				add bl, 4 ;add 4 to bl since we print binary digit by fours
				
				nospace: 
				
					shl input2, 1 ;bit shift left to put the most significant bit to carriage flag
				
					jc else_block ;jc becomes true if cf = 1
						mov dl, '0' ;if jc is false (did not jump to else block) print 0
						mov ah, 02h
						int 21h
						jmp cont ;end if condition
					else_block: ;if jc is true of cf = 1
						mov dl, '1' ;print 1
						mov ah, 02h
						int 21h
				
				
				cont:
				clc ;clear carry flag
		
			inc cl ;increase counter
			cmp cl, 15 ;after 16 loops end the loop
			jle loop2
	ret
	getInput endp ;end function
	
	end main