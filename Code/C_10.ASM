DATA	SEGMENT
LET     DB  ?
NUM     DB  ?
OTH     DB  ?
OLET    DB  'Letters:$'
ONUM    DB  'Numbers:$'
OOTH    DB  'Others:$'
STR     DB  0DH, 0AH, '$'
DATA	ENDS

CODE	SEGMENT
	    ASSUME	CS: CODE, DS: DATA
START:  MOV AX, DATA
	    MOV	DS, AX
	    MOV LET, 0
	    MOV NUM, 0
	    MOV OTH, 0

JUDGE:  MOV AH, 1
        INT 21H
		CMP AL, 0DH
		JE EXIT
		CLC
		CMP AL, 30H
		JC OTHER
		CLC
		CMP AL, 3AH
		JC NUMBER
		CLC
		CMP AL, 41H
		JC OTHER
		CLC
		CMP AL, 5BH
		JC LETTER
		CLC
		CMP AL, 61H
		JC OTHER
		CLC
		CMP AL, 7BH
		JC LETTER
		JMP OTHER

LETTER: ADD LET, 1
        JMP JUDGE
NUMBER: ADD NUM, 1
        JMP JUDGE
OTHER:  ADD OTH, 1
        JMP JUDGE

EXIT:   LEA DX, OLET
        MOV AH, 9
		INT 21H

        ;MOV AL, LET
		;MOV BL, AL
		;MOV CL, 4
		;SHR AL, CL
		;CMP AL, 0AH
		;JL ADD_10
		;ADD AL, 7
;ADD_10: ADD AL, 30H
        ;MOV DL, AL
        ;MOV AH, 2
		;INT 21H
		;AND BL, 0FH
		;CMP BL, 0AH
		;JL ADD_11
	    ;ADD BL, 7
;ADD_11: ADD BL, 30H
        ;MOV DL, BL
		;MOV AH, 2
		;INT 21H

		MOV CX, 3
		MOV BL, 0AH
		MOV AL, LET
ONE:    MOV AH, 0
        DIV BL
		PUSH AX
		LOOP ONE
		MOV CX, 3
TWO:    POP DX
        XCHG DH, DL
		OR DL, 30H
		MOV AH,2
		INT 21H
		LOOP TWO

		LEA DX, STR
        MOV AH, 9
		INT 21H

		LEA DX, ONUM
        MOV AH, 9
		INT 21H
		MOV AL, NUM
		MOV BL, AL
		MOV CL, 4
		SHR AL, CL
		CMP AL, 0AH
		JL ADD_20
		ADD AL, 7
ADD_20: ADD AL, 30H
        MOV DL, AL
        MOV AH, 2
		INT 21H
		AND BL, 0FH
		CMP BL, 0AH
		JL ADD_21
	    ADD BL, 7
ADD_21: ADD BL, 30H
        MOV DL, BL
		MOV AH, 2
		INT 21H
		LEA DX, STR
        MOV AH, 9
		INT 21H

		LEA DX, OOTH
        MOV AH, 9
		INT 21H
		MOV AL, OTH
		MOV BL, AL
		MOV CL, 4
		SHR AL, CL
		CMP AL, 0AH
		JL ADD_30
		ADD AL, 7
ADD_30: ADD AL, 30H
        MOV DL, AL
        MOV AH, 2
		INT 21H
		AND BL, 0FH
		CMP BL, 0AH
		JL ADD_31
	    ADD BL, 7
ADD_31: ADD BL, 30H
        MOV DL, BL
		MOV AH, 2
		INT 21H
		LEA DX, STR
        MOV AH, 9
		INT 21H

        MOV	AX, 4C00H
	    INT  	21H
CODE	ENDS
	END	START
