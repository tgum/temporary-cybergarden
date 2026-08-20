@outcounter:   0
@incounter:    0
@number:       0
@numberstate:  0

@labeltable:   0
@labelindex:   0
@pointertable: 0
@pointerindex: 0
; allocated variables
0 0 0 0
0 0 0 0

  @printself ; prints everything after address 1000
; it only uses relative addresses so its completely relocateable
Psh 60 popV ; change to rjp(17)
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
; fix variables
Psh 1000 Dup Psh outcounter(0) Str Psh incounter(1) Str
Psh 0 Dup Psh number(2) Str Psh numberstate(3) Str
; find end of program
@tableloop
Psh 1000
Dup Lds
Not
Psh %endtableloop(-) rcjQ
Psh 1 Add
Psh %tableloop(-) Jmp
@endtableloop
Psh 1 Add
Dup Dup
Psh &labeltable(-) Str Psh &labelindex(-)
Psh 1000 Add ; 500 labels
Psh &pointertable(-) Str Psh &pointerindex(-)

  @start
Psh &getchar(-) cllF
  @switchchar
Dup Psh &isnull(-) cllF Psh &jumpuser(-) Cjp
Dup Psh &isat(-) cllF Psh &parselabel(243) Cjp
Dup Psh &isampersand(-) cllF Psh &parsepointer(-) Cjp
Dup Psh &issemicolon(-) cllF Psh &parsecomment(283) Cjp
Dup Psh &isminus(-) cllF Psh &parsenumber(307) Cjp
Dup Psh &isdigit(-) cllF Psh &parsenumber(307) Cjp
Dup Psh &isupperletter(-) cllF Psh &parseopcode(380) Cjp
popV Psh %start(-52) rjpE

  @isnull
Not Ret
  @isat
Psh at(64) sUb Not Ret
  @isampersand
Psh ampersand(38) sUb Not Ret
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
popV Psh 0
@labelloop
Psh &getchar(-) cllF Dup
Psh &islowerletter(-) cllF Not Psh %endlblloop(12) rcjQ
Psh lowera(97) Sub
sWp Psh 26 Mul Add
Psh %lblloop(-21) rjpE
@endlblloop
sWp
Psh &labelindex(5) Lds Str
Psh &labelindex(5) Lds Psh 1 Add
Psh &outcounter(0) Lds
Psh 1000 Sub
ovrK Str
Psh 1 Add Psh &labelindex(5) Str
Psh &switchchar(-) Jmp

  @parsepointer
popV Psh 0
@ptrloop
Psh &getchar(-) cllF Dup
Psh &islowerletter(-) cllF Not Psh %endptrloop(12) rcjQ
Psh lowera(97) Sub
sWp Psh 26 Mul Add
Psh %ptrloop(-21) rjpE
@endptrloop
sWp
Psh &pointerindex(7) Lds Str
Psh &pointerindex(7) Lds Psh 1 Add
Psh &outcounter(0) Lds ovrK Str
Psh 1 Add Psh &pointerindex(7) Str
Psh &switchchar(-) Jmp

  @parsecomment
popV
Psh &getchar(-) cllF
Dup
Psh &isnull(-) cllF
ovrK Psh 10 sUb Not
Add
Psh &switchchar(-) Cjp
Psh %parsecomment(-19) rjpE

  @parsenumber
Dup Psh &isminus(-) cllF Dup Not Psh %storesign(6) rcjQ
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
Psh &getchar(-) cllF
Dup Psh &isdigit(-) cllF Psh %numberloop(-22) rcjQ
; write number
Psh &number(2) Lds Psh &numberstate(3) Lds
Mul Psh &writeinstruction(-) cllF
Psh 0 Dup Psh &number(2) Str Psh &numberstate(3) Str
Psh &switchchar(-) Jmp

  @parseopcode
Psh uppera(65) sUb
Psh &opcodetable(-) Add Lds
Psh &writeinstruction(-) cllF
Psh &start({) Jmp

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
