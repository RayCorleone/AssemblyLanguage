EXTRN   DISPBX: FAR
MYDATA  SEGMENT
DATA  	DW      1234H,5678H,9D4CH,0D7H,0,-1,7D2AH,8A0EH,10F5H,645DH
N   	EQU     $-DATA
MYDATA  ENDS
CODE    SEGMENT
        ASSUME  CS:CODE, DS:MYDATA
MAIN    PROC    FAR
        PUSH    DS
        MOV     AX,0
        PUSH    AX
        MOV     AX,MYDATA
        MOV     DS,AX
        MOV     CL,N
        SHR     CL,1                    ;装填CL循环次数
        MOV     BX,OFFSET DATA
        SUB     BX,2
        MOV     AX,7FFEH
AGAIN:  ADD     BX,2
        TEST    WORD PTR [BX],0001H
        JNZ     NEXT
        CMP     AX,[BX]
        JLE     NEXT
        MOV     AX,[BX]
NEXT:   LOOP    AGAIN                   ;计数循环寻找最小值
        MOV     BX,AX                   ;找到的最小数放入BX
        CALL    DISPBX
        RET
MAIN    ENDP

CODE    ENDS
       	END	MAIN