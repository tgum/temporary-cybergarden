@outcounter: 0
@incounter:  0
@number:     0
@numberstate:0
// allocated variables
0 0 0 0
0 0 0 0
0 0 0 0

  @printself
Psh 60 popV ; change to rjp
Psh usercode(1000)
@quineloop
Dup Lds
; checksum
Dup Psh 5 Lds Add Psh 5 Str
; print number and comma
Psh -100 Str
Psh 44 Psh -101 Str
Psh 1 Add
; jump to end if done printing
Dup Psh &outcounter(0) Lds
sUb iBz Not Psh 4 rcjQ
; restart
Psh %quineloop(-33) rjpE
; print newline and program length
Psh 10 Psh -101 Str Psh 999 sUb Psh -100 Str
Psh 10 Psh -101 Str Psh 5 Lds Psh -100 Str Hlt

  @init
// fix variables
Psh 1000 Dup Psh outcounter(0) Str Psh incounter(1) Str
Psh 0 Dup Psh number(2) Str Psh numberstate(3) Str

  @start
Psh &getchar(356) cllF
  @switchchar
Dup Psh &isnull(143) cllF Psh &jumpuser(388) Cjp
Dup Psh &isat(145) cllF Psh &parselabel(199) Cjp
Dup Psh &issemicolon(150) cllF Psh &parsecomment(228) Cjp
Dup Psh &isminus(155) cllF
Dup Psh &isdigit(160) cllF Add Psh &parsenumber(248) Cjp
Dup Psh &isupperletter(173) cllF Psh &parseopcode(317) Cjp
popV Psh %start(-46) rjpE

  @isnull
Not Ret
  @isat
Psh at(64) sUb Not Ret
  @issemicolon
Psh semicolon(59) sUb Not Ret
  @isminus
Psh minus(45) sUb Not Ret
  @isdigit
Dup
Psh digitzero(48) sUb iBz Not
sWp Psh digitzero+ten(58) sUb iBz
Mul
Ret
  @isupperletter
Dup
Psh uppera(65) sUb iBz Not
sWp Psh uppera+twentysix(91) sUb iBz
Mul
Ret
  @islowerletter
Dup
Psh lowera(97) sUb iBz Not
sWp Psh lowera+twentysix(123) sUb iBz
Mul
Ret

  @parselabel
Psh &getchar(356) cllF Dup
Psh &islowerletter(186) cllF Not Psh %endloop(7) rcjQ
Psh -101 Str
Psh %parselabel(-16) rjpE
@endloop
Psh outcounter(0) Lds Psh -100 Str
Psh &printnewline(369) cllF
Psh &switchchar(99) Jmp

  @parsecomment
popV
Psh &getchar(356) cllF
Dup
Psh &isnull(143) cllF
ovrK Psh 10 sUb Not
Add 
Psh &switchchar(99) Cjp
Psh %parsecomment(-18) rjpE

  @parsenumber
Dup Psh &isminus(155) cllF Dup Not Psh %storesign(6) rcjQ
; change minus to zero
sWp Psh 3 Add sWp
@storesign
Not Psh 2 Mul Psh 1 sUb ; conver bool to sign
Psh &numberstate(3) Str
@numberloop
Psh 48 sUb
Psh &number(2) Lds
Psh 10 Mul Add
Psh &number(2) Str
Psh &getchar(356) cllF
Dup Psh &isdigit(160) cllF Psh %numberloop(-22) rcjQ
; write number
Psh &number(2) Lds Psh &numberstate(3) Lds
Mul Psh &writeinstruction(375) cllF
Psh 0 Dup Psh &number(2) Str Psh &numberstate(3) Str
Psh &switchchar(99) Jmp

  @parseopcode
Psh uppera(65) sUb
Psh &opcodetable(330) Add Lds
Psh &writeinstruction(375) cllF
Psh &start(96) Jmp

  @opcodetable
add ibz cjp dup rjp cll rot hlt     jmp ovr lds mul
a09 b14 c16 d03 e17 f19 g06 h21 i-1 j15 k05 l07 m11

not nop psh rcj ret str     sub pop swp
n13 o00 p01 q18 r20 s08 t-1 u10 v02 w04 x-1 y-1 z-1

  @getchar
Psh incounter(1) Lds
Dup Lds
sWp
; increment by one
Psh 1 Add Psh incounter(1) Str
Ret

  @printnewline
Psh 10 Psh -101 Str Ret

  @writeinstruction
Psh outcounter(0) Lds sWp ovrK Str
Psh 1 Add Psh outcounter(0) Str
Ret

  @jumpuser
popV Psh usercode(1000) Jmp