DATA    SEGMENT
TOTAL   DB      ?					;总人数
ACT     DB      0					;实际人数
ABS     DB      ?					;缺考人数
MAX     DB      0					;最高成绩
MIN     DB      100					;最低成绩
AFNUM   DB      0,0,0,0,0			;5个分数段人数
SUM		DW		0					;总成绩
B10		DB		10					;进制转换中间数（字节）
W10		DW  	10					;进制转换中间数（字）
B100	DB		100					;小数转换中间数
TEMP	DB		4, ?, 4 DUP(?)		;暂存数据
STR		DB		0DH, 0AH, '$'		;回车换行（单独）
STR0	DB		'.', '$'			;小数点
STR1    DB      'Please input the total number of students in the class:', 0DH, 0AH, '$'
STR1_E	DB		0DH, 0AH, '!!! Error1: the number should be within [10,60]',0DH, 0AH, '$'
STR2_0	DB      0DH, 0AH, '*****************************************************************', 0DH, 0AH, '$'
STR2_1	DB      '*Please input marks one by one (Press Enter when you finish one)*', 0DH, 0AH, '$'
STR2_2	DB      '*P.S. If you have input all the marks, type 255 to stop.        *', 0DH, 0AH, '$'
STR2_3	DB		'*e.g. 82(Press Enter)                                           *', 0DH, 0AH, '$'
STR2_4	DB      '*****************************************************************', '$'
STR2_A	DB		20H, 'student(s) left:', '$'
STR2_E	DB      0DH, 0AH, '!!! Error2: the number should be within [0,100]', '$'
STR3_0	DB      '*****************************************************************', '$'
STR3_1	DB		0DH, 0AH, 'Total: ', '$'
STR3_2	DB		20H, 20H, 20H, 20H, 'Attend: ', '$'
STR3_3	DB		20H, 20H, 20H, 20H, 'Absent: ', '$'
STR3_4	DB		0DH, 0AH, 'Highest: ', '$'
STR3_5	DB		20H, 20H, 20H, 20H, 'Lowest: ', '$'
STR3_6	DB		0DH, 0AH, '[90 -100]: ', '$'
STR3_7	DB		0DH, 0AH, '[80 - 89]: ', '$'
STR3_8	DB		0DH, 0AH, '[70 - 79]: ', '$'
STR3_9	DB		0DH, 0AH, '[60 - 69]: ', '$'
STR3_10	DB		0DH, 0AH, '[ 0 - 59]: ', '$'
STR4_1	DB		'Average: ', '$'
STR4_2	DB		0DH, 0AH, '[90 -100] Rate: ', '$'
STR4_3	DB		'%', 0DH, 0AH, '[80 - 89] Rate: ', '$'
STR4_4	DB		'%', 0DH, 0AH, '[70 - 79] Rate: ', '$'
STR4_5	DB		'%', 0DH, 0AH, '[60 - 69] Rate: ', '$'
STR4_6	DB		'%', 0DH, 0AH, '[ 0 - 59] Rate: ', '$'
STR4_7	DB		'%', 0DH, 0AH, '* Program runs successfully!', 0DH, 0AH, '$'
STAB	DW		S1, S2, S3, S4, S5, S6, S7, S8, S9, S10
DATA    ENDS
;##################################################################################
CODE    SEGMENT
        ASSUME  CS:CODE,DS:DATA
START:  MOV     AX,DATA
        MOV     DS,AX
        CALL    INNUM			;输入班级人数
        CALL	INMARK			;输入学生分数(处理整数数据)
		CALL	NOUT			;输出整数数据
		CALL	SOUT			;输出小数数据(处理小数数据)
        MOV     AH,4CH
        INT     21H
;########################################################################
;主子程序INNUM
;功能：输入班级总人数，储存在数据段TOTAL中
;入口参数：键盘输入
;出口参数：TOTAL，在数据段中
INNUM	PROC    NEAR
AGAIN:  LEA     DX,	STR1		;班级人数输入提示
        MOV     AH,	9H
        INT     21H
        LEA		DX, TEMP		;输入班级人数
		MOV		AH, 0AH
		INT		21H
		CALL	TRANSDB			;转化10进制数
		CMP		AL, 0AH			;判断数据范围
		JB		ERROR1
		CMP		AL, 3CH
		JNA		OUTIT
ERROR1:	LEA		DX,	STR1_E		;有误，重新输入
		MOV		AH,9H
		INT		21H
		JMP		AGAIN
OUTIT:	MOV		TOTAL, AL		;无误，存储入TOTAL
		MOV		ABS, AL
        RET
INNUM   ENDP
;########################################################################
;主子程序INMARK
;功能：输入个学生分数，并做数值统计
;入口参数：键盘输入、TOTAL（数据段）
;出口参数：SUM, MAX, MIN, ABS, ACT,均在数据段中
INMARK	PROC	NEAR
		LEA     DX,	STR2_0		;分数输入总提示
        MOV     AH,	9H
        INT     21H
		LEA     DX,	STR2_1
        MOV     AH,	9H
        INT     21H
		LEA     DX,	STR2_2
        MOV     AH,	9H
        INT     21H
		LEA     DX,	STR2_3
        MOV     AH,	9H
        INT     21H
		LEA     DX,	STR2_4
        MOV     AH,	9H
        INT     21H
		MOV		CL, TOTAL
		MOV		CH, 0
TYPEIN: LEA     DX,	STR			;剩余人数提示
        MOV     AH,	9H
        INT     21H
		MOV		AL, CL
		CALL	TRANSBD
		LEA     DX,	STR2_A
        MOV     AH,	9H
        INT     21H
		LEA		DX, TEMP		;输入个人分数
		MOV		AH, 0AH
		INT		21H
		CALL	TRANSDB			;转化10进制数
		CMP		AL, 64H			;判断数据范围
		JNA		CON
		CMP		AL,	0FFH		;判断是否终止
		JZ		ISTOP
		LEA		DX,	STR2_E		;有误，重新输入
		MOV		AH,9H
		INT		21H
		JMP		TYPEIN	
CON:	MOV		AH, 0			;无误，进行操作
		ADD		SUM, AX
		INC		ACT
		DEC		ABS
		CALL	JUDGE
		CALL	SORT
		LOOP	TYPEIN
ISTOP:	MOV		CX, 0
		RET
INMARK	ENDP
;########################################################################
;主子程序NOUT
;功能：输出整数数据
NOUT	PROC	NEAR
		LEA     DX,	STR			;总体输出提示
        MOV     AH,	9H
        INT     21H
		LEA     DX,	STR3_0
        MOV     AH,	9H
        INT     21H
		MOV		CX, 0AH			;循环输出STAB地址表中内容
		MOV     BX, 0
		SUB		BX, 2
OUT1:	ADD		BX, 2
		JMP		STAB [BX]
BACK:   MOV     AH,	9H
        INT     21H
		CALL	TRANSBD
		LOOP	OUT1
		RET

S1:		LEA     DX,	STR3_1		;地址表
		MOV		AL, TOTAL
		JMP		BACK
S2:		LEA     DX,	STR3_2
		MOV		AL, TOTAL + 1
		JMP		BACK
S3:		LEA     DX,	STR3_3
		MOV		AL, TOTAL + 2
		JMP		BACK
S4:		LEA     DX,	STR3_4
		MOV		AL, TOTAL + 3
		JMP		BACK
S5:		LEA     DX,	STR3_5
		MOV		AL, TOTAL + 4
		JMP		BACK
S6:		LEA     DX,	STR3_6
		MOV		AL, TOTAL + 5
		JMP		BACK
S7:		LEA     DX,	STR3_7
		MOV		AL, TOTAL + 6
		JMP		BACK
S8:		LEA     DX,	STR3_8
		MOV		AL, TOTAL + 7
		JMP		BACK
S9:		LEA     DX,	STR3_9
		MOV		AL, TOTAL + 8
		JMP		BACK
S10:	LEA     DX,	STR3_10
		MOV		AL, TOTAL + 9
		JMP		BACK
NOUT	ENDP
;########################################################################
;主子程序SOUT
;功能：计算小数数据，并输出小数数据
SOUT	PROC	NEAR
		MOV		BL, ACT
		MOV		BH, 0
		LEA		DX, STR2_0
		MOV		AH, 9H
		INT		21H
		LEA		DX, STR4_1		;计算并输出平均分
		MOV		AH, 9H
		INT		21H
		MOV		AX, SUM
		MOV		BL, ACT
		MOV		BH, 0
		CALL	PNUM
		CALL	TRANSF
		LEA		DX, STR4_2		;计算[90-100]分数段比率
		MOV		AH, 9H
		INT		21H
		MOV		AL, AFNUM
		MUL		B100
		CALL	PNUM
		CALL	TRANSF
		LEA		DX, STR4_3		;计算[80-89]分数段比率
		MOV		AH, 9H
		INT		21H
		MOV		AL, AFNUM + 1
		MUL		B100
		CALL	PNUM
		CALL	TRANSF
		LEA		DX, STR4_4		;计算[70-79]分数段比率
		MOV		AH, 9H
		INT		21H
		MOV		AL, AFNUM + 2
		MUL		B100
		CALL	PNUM
		CALL	TRANSF
		LEA		DX, STR4_5		;计算[60-69]分数段比率
		MOV		AH, 9H
		INT		21H
		MOV		AL, AFNUM + 3
		MUL		B100
		CALL	PNUM
		CALL	TRANSF
		LEA		DX, STR4_6		;计算[00-59]分数段比率
		MOV		AH, 9H
		INT		21H
		MOV		AL, AFNUM + 4
		MUL		B100
		CALL	PNUM
		CALL	TRANSF
		LEA		DX, STR4_7		;程序终止提示语
		MOV		AH, 9H
		INT		21H
		RET
SOUT	ENDP
;########################################################################
;副子程序PNUM
;功能：处理小数数据，计算四舍五入小数
;方法：被除数扩大十倍，再相除，比较余数的二倍与除数，决定是否进位
;入口参数：AX-存放被除数，BX-存放被除数
;出口参数：AX-四舍五入后的数字
PNUM	PROC	NEAR
		PUSH	CX
		PUSH	DX
		MUL		W10				;被除数扩大十倍
		MOV		DX, 0
		DIV		BX
		ADD		DX, DX			;余数扩大2倍
		CMP		DX,	BX
		JB		RET1
		INC		AX				;5入加1
RET1:	POP		DX
		POP		CX
		RET
PNUM	ENDP
;########################################################################
;副子程序JUDGE
;功能：判断最大、最小数
;入口参数：AL，储存当前数据
JUDGE	PROC	NEAR
		CMP		AL, MAX
		JNA		NEXT
		MOV		MAX, AL
NEXT:	CMP		AL, MIN
		JNB		RET2
		MOV		MIN, AL
RET2:	RET
JUDGE	ENDP
;########################################################################
;副子程序SORT
;功能：对各个成绩分段计数
;入口参数：AL，储存当前数据
SORT	PROC	NEAR
		CMP		AL, 3CH
		JB		GATF
		CMP		AL, 46H
		JB		GATD
		CMP		AL, 50H
		JB		GATC
		CMP		AL, 5AH
		JB		GATB
		INC		AFNUM
		RET
GATB:	INC		AFNUM + 1
		RET
GATC:	INC		AFNUM + 2
		RET
GATD:	INC		AFNUM + 3
		RET
GATF:	INC		AFNUM + 4
		RET
SORT	ENDP
;########################################################################
;副子程序TRANSDB
;功能：将输入10进制数转换为2进制数（同时可以识别非法字符）
;出口参数：AL，转化后的2进制数
TRANSDB	PROC	NEAR
		PUSH	DX
		PUSH	CX
		PUSH	BX
		MOV		AL, 0
		MOV		CL, TEMP + 1
		MOV		CH, 0
		LEA		BX, TEMP + 2
ONE1:	MUL		W10
		MOV		DL, [BX]
		CMP		DL,	30H
		JNB		RIGHT1
		MOV		AL, 80H
		JMP		RET3
RIGHT1:	CMP		DL,	39H
		JNA		RIGHT2
		MOV		AL, 80H
		JMP		RET3
RIGHT2:	AND		DL, 0FH	
		ADD		AL, DL
		INC		BX
		LOOP	ONE1
RET3:	POP		BX
		POP		CX
		POP		DX
		RET
TRANSDB	ENDP
;########################################################################
;副子程序TRANSBD
;功能：将2进制数转换为10进制数输出（同时可以屏蔽开头的 0）
;入口参数：AL，存放待输出的数据
TRANSBD PROC	NEAR
		PUSH	BX
		PUSH	CX
		PUSH	DX
		MOV		CX, 3
		MOV		BH, 0
ONE2:   MOV		AH, 0
        DIV		B10
		PUSH	AX
		LOOP	ONE2
		MOV		CX, 3
TWO:    POP		DX
        XCHG	DH, DL
		OR		DL, 30H
		CMP		DX, 30H
		JNZ		NORMAL
		CMP		CX, 1
		JZ		NORMAL
		CMP		BH, 0
		JNZ		NORMAL
		LOOP	TWO
NORMAL: INC		BH
		MOV		AH, 2
		INT		21H
		LOOP	TWO
		POP		DX
		POP		CX
		POP		BX
		RET
TRANSBD	ENDP
;########################################################################
;副子程序TRANSF
;功能：将2进制数转换为10进制数，输出小数（同时可以屏蔽开头的 0）
;入口参数：AX，存放待输出的数据
TRANSF  PROC	NEAR
		PUSH	BX
		PUSH	CX
		PUSH	DX
		MOV		CX, 4
		MOV		BH, 0
ONE3:   MOV		DX, 0
		DIV		W10
		PUSH	DX
		LOOP	ONE3
		MOV		CX, 4
TWO2:   POP		DX
		OR		DX, 30H
		CMP		DX, 30H
		JNZ		NOR
		CMP		CX, 2
		JZ		NOR
		CMP		BH, 0
		JNZ		NOR
		LOOP	TWO2
NOR:	INC		BH
		MOV		AH, 2
		INT		21H
		CMP		CX, 2
		JNZ		NORM
		LEA		DX, STR0
		MOV		AH, 9H
		INT		21H
NORM:	LOOP	TWO2
		POP		DX
		POP		CX
		POP		BX
		RET
TRANSF	ENDP
;########################################################################
CODE    ENDS
       	END		START