DATA	SEGMENT
A	    DB  	40H
B	    DB  	30H
C       DB      20H
D       DB      10H
S       DW      ?
DATA	ENDS
CODE	SEGMENT
	ASSUME	CS: CODE, DS: DATA
START:	MOV     AX, DATA
		MOV     DS, AX
        MOV     AL, A
	    MOV     BL, B
		IMUL    BL        ;AX里是A*B
		MOV     CX,AX     ;CX里是A*B

		MOV     AL, C
		CBW
		MOV     BX, AX
		MOV     AL, D
		CBW
		ADD     BX, AX    ;BX里是C+D

		MOV     AX, CX    ;AX里是A*B
		CWD               ;DXAX里是A*B
		IDIV    BX        ;AX是(A*B)/(C+D),DX里是余数
		MOV     CX, AX    ;CX是(A*B)/(C+D)

		MOV     AL, B
		CBW
		MOV     BX, AX
		MOV     AL, A
		CBW
		SUB     AX, BX    ;AX是A-B
		MOV     BX, 5
		IMUL    BX        ;DXAX是5(A-B)
		CWD
		MOV     BX, 2
		IDIV    BX        ;AX是5(A-B)/2
		ADD     CX, AX    ;CX是(A*B)/(C+D)+5(A-B)/2

		MOV     AL, C
		CBW
		MOV     BL, D
		IDIV    BL        ;AL里是C/D
		CBW
		ADD     AX, CX    ;AX里是S

		MOV  	AX, 4C00H
		INT  	21H
CODE	ENDS
	END	START
