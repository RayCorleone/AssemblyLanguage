_DATA   SEGMENT 'DATA'
Msg 	DB  	13, 10, "Please input a number: ", 13, 10, "$"
s1  	DB	    9, "Monday", 13, 10, '$'
s2  	DB	    9, "Tuesday", 13, 10, '$'
s3  	DB	    9, "Wednesday", 13, 10, '$'
s4  	DB	    9, "Thursday", 13, 10, '$'
s5  	DB	    9, "Friday", 13, 10, '$'
s6  	DB  	9, "Saturday", 13, 10, '$'
s7  	DB  	9, "Sunday", 13, 10, '$'
err 	DB  	9, "Error!", 13, 10, '$'
DayTab  DW  	D0, D1, D2, D3, D4, D5, D6, D7, Default
_DATA   ENDS
_TEXT   SEGMENT 'CODE'
	ASSUME 	CS: _TEXT, DS: _DATA
Start:  MOV 	AX, _DATA
	    MOV 	DS, AX
Again:  MOV 	AH, 9
	    MOV 	DX, Offset Msg
	    INT 	21H            ;输出提示
	    MOV 	AH, 1
	    INT 	21H            ;输入数字至AL
	    SUB 	AL, '0'        ;
	    JL  	Error          ;输入字符小于'0'的情况
	    CMP 	AL, 7
	    JLE 	Loc1           ;小于等于7(0 - 7)
Error:  MOV 	AL, 8
Loc1:   MOV 	AH, 0
	    ADD 	AX, AX
	    MOV 	BX, AX
	    JMP 	DayTab [BX]
Default:MOV 	DX, Offset err
     	JMP 	EndSwitch
D1:     MOV 	DX, Offset s1
	    JMP 	EndSwitch
D2:     MOV 	DX, Offset s2
	    JMP 	EndSwitch
D3:     MOV 	DX, Offset s3
	    JMP 	EndSwitch
D4:     MOV 	DX, Offset s4
	    JMP 	EndSwitch
D5:     MOV 	DX, Offset s5
	    JMP 	EndSwitch
D6:     MOV 	DX, Offset s6
	    JMP 	EndSwitch
D7:     MOV 	DX, Offset s7
	    JMP 	EndSwitch
D0:     MOV 	AX, 4C00h
	    INT 	21H
EndSwitch:  
        MOV     AH, 9
	    INT 	21H
	    JMP 	Again
_TEXT   ENDS
	END 	Start