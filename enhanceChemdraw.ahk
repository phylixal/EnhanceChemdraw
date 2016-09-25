;;为 chemdraw 增加 cas 号和结构式的转换功能，后端为pubchem
; https://github.com/phylixal/EnhanceChemdraw/
; autohotkey_L 1.1.10.1
fileinstall, wget.exe, wget.exe, 1

SetTitleMatchMode RegEx 
#ifWinActive Chem.*Draw ahk_class CSWFrame
; detecte the Chemdraw or chemBioDraw window
; #ifWinActive ChemDraw Professional ahk_class CSWFrame

F2::    ;show the Analysis window
send !vss{enter}
return

F6::    ;structure to cas number, convert smiles to casrn using pubchem
;WinMenuSelectItem, A, ,2&, 9&, 1&   ;copy smiles
send ^!c
ClipWait
sleep, 100
;msgbox, %Clipboard%
clipboard := PubchemGetCas(clipboard)
send ^v
;send {Appskey}{Down 5}{Enter}
return

^F6::    ; casrn number or names to structure, only get the first one
send ^c
ClipWait
;clipboard := cactus(clipboard, "smiles")
clipboard := PubchemGetInchi(clipboard)
;;paste inchi
;send {Appskey}{Down 6}{Right}{Down 2}{Enter}
send !esi{enter}
sleep, 50
send, ^g
;WinMenuSelectItem, A, ,2&, 10&, 3&   
return

+F6::       ;names and casrn to structure, post all matched structure
send ^c
ClipWait
inchis := PubchemGetInchiAll(clipboard)
;msgbox, % inchis
loop, parse, inchis, `n, `r%A_Space%%A_Tab% 
{
	clipboard = %A_LoopField%
	;msgbox, %A_LoopField%
	;send {Appskey}{Down 6}{Right}{Down 2}{Enter}
	;WinMenuSelectItem, A, ,2&, 10&, 3&   ;paste inchi
	send !esi{enter}
	sleep, 50
	send, ^g
	sleep, 50
}
return




#ifWinActive 



;函数定义
;--------------PubChem------------
; 获取cid
;http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/smiles/OC(CC=C)C1=CC=CC=C1/cids/TXT
; 获取完整json
;http://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/2244/JSON

; 获取所有的名字
;http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/smiles/OC(CC=C)C1=CC=CC=C1/synonyms/TXT
; 转换为inchi
;http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/936-58-3/property/InChI/txt


PubchemGetInchi(name){
	url := "http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/" uriEncode(name) "/property/InChI/txt"
	Filedelete, tmp.txt
	cmd = wget `"%url%`"  -O tmp.txt  
	;msgbox, % cmd
	RunWait, %comspec% /c %cmd%, , min
	sleep, 30
	FileReadline, inchi, tmp.TXT, 1
	;msgbox % inchi
	;StringReplace, inchi, inchi, `n, , All
	;msgbox % inchi
	sleep, 30
	return inchi
}
PubchemGetCas(smiles){
	url := "http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/smiles/" uriEncode(smiles) "/synonyms/TXT"
;	msgbox, % url
	Filedelete, castmp.txt
	cmd = wget `"%url%`"  -O castmp.txt  
	RunWait, %comspec% /c %cmd%, , min
	FileRead, Synonyms, castmp.TXT
	;以上获取名字列表
	;msgbox % Synonyms 
	sleep, 30
	RegExMatch(Synonyms, "\d{2,7}-\d\d-\d", CasRNList) 
	;msgbox, % CasRNList
	return CasRNList
}
PubchemGetInchiAll(name){
	url := "http://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/" uriEncode(name) "/property/InChI/txt"
	Filedelete, tmp.txt
	cmd = wget `"%url%`"  -O tmp.txt  
	;msgbox, % cmd
	RunWait, %comspec% /c %cmd%, , min
	sleep, 30
	FileRead, inchis, tmp.TXT
	;可能返回多个，只使用第一行
	;msgbox % inchi
	;StringReplace, inchi, inchi, `n, , All
	;msgbox % inchi
	sleep, 30
	return inchis
}
uriEncode(str) {  
    StringReplace, str, str, `%, `%25, All  
	StringReplace, str, str, #, `%23, All  
	return, str
} 

/*
uriEncode(str) {  
   f = %A_FormatInteger%  
   SetFormat, Integer, Hex  
   If RegExMatch(str, "^\w+:/{0,2}", pr)  
      StringTrimLeft, str, str, StrLen(pr)  
   StringReplace, str, str, `%, `%25, All  
   Loop  
      If RegExMatch(str, "i)[^\w\.~%]", char)  
         StringReplace, str, str, %char%, % "%" . Asc(char), All  
      Else Break  
   SetFormat, Integer, %f%  
   Return, pr . str  
}  
uriDecode(str) {  
   Loop  
      If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)  
         StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All  
      Else Break  
   Return, str  
}    

*/
