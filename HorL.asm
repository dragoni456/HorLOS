org 0x7C00
start:

;;set screen mode
xor ax, ax
mov ds, ax

mov ax, 0x0003 
int 10h 

;; save first card number and clear score
 mov dh, 1
 xor cl, cl
 
 ;; game loop
 game_loop:
 
 ;;print card
 mov al, dh
 cbw
 aam ;;gets the tens and ones of al into ah and al
 xchg al, ah
 or ax, 0x3030 ;;converts to ascii
 push ax
 mov ah, 0x0E
 int 0x10 ;;prints al
 pop ax
 mov al, ah
 mov ah, 0x0E
 int 0x10
 call newline
 
 ;;get new card
 ;; get random card ;;get random card
get_random_card:

    xor ax, ax
	spin_loop:

    inc al   
    mov bh, al
    mov ah, 0x01       
    int 0x16 ;;bios interupt for key pressed
    jz spin_loop       
	mov dl, al;stores key press in dl to save from being clobbered
	
	mov ah, 0x00
    int 0x16        ; consume
  
	
    xor ah, ah   
    mov al, bh       
    mov bl, 13          
    div bl     
    mov al, ah          
    inc al ;; gives a number between one and thiteen via moldolo
    
;;compare hands
 compare:
	cmp al, dh
	je evensteven
	ja ifhigher
	
;; if lower
iflower:

cmp dl, "l"
jne gameover
inc cl 
mov dh, al
jmp game_loop


evensteven:
 inc cl 
 mov dh, al
 jmp game_loop
 
ifhigher:
 cmp dl, "h"
jne gameover
inc cl 
mov dh, al
jmp game_loop

gameover:

mov si, gg_message
mov ah, 0x0E

print_gg:
	lodsb ;;loads si into al and inc
	or al, al
	jz printscore
	int 0x10
	jmp print_gg
	
printscore:
	mov al, cl
	cmp al, 10
	jb onedigit
	mov al, "1"
	int 0x10
	mov al, cl
	sub al, 10
	
onedigit:
	add al, "0"
	int 0x10
	call newline
	
	xor cl,cl
	jmp game_loop
	
gg_message: db "Ur hi score was ",00

newline:
    mov al, 0x0D       
    int 0x10
    mov al, 0x0A      
    int 0x10
    ret

;;reset 
times 510 - ($ - $$) db 0
dw 0xAA55
