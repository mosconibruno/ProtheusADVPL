#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FCNGERARTIT    ºAutor  ³ Alexandre Takaki   º Data ³ 11/06/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ FUNCAO PARA GERAR TITULO NO PROTHEUS.	  						º±±
±±º          ³          	                                                  	º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TV COSTA NORTE	  		                                      	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FCNGERARTI(_cPrefixo,_cNumero,_cTipo,_cNatureza,_cCliente,_cLoja,_cEmissao,_cVencto,_cVencReal,_cContraMDW,_cPiMDW,_nValor,_nRecnoSZ2,_cHist,_cCusto,_cParcela,_cVend1,_cVend2,_cVend3,_cComis1,_cComis2,_cComis3)

	Local aArea     := GetArea()
	Local aAuto		:= {}
	Local aSE1		:= {}
	Local lRet		:= .T.
	Local nY		:= 0
	Local cPrefixo	:= _cPrefixo
	Local cNumero	:= _cNumero
	Local cErro		:= ""
			
	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .T.
	
	/*
	aSE1 := SE1->(GetArea())    
		
	DbSelectArea('SE1')  
	SE1->(DbSetOrder(1))
	
	While .T.
		cNumero := SE1->( GetSXENum("SE1","E1_NUM") )
		
		If SE1->( !DbSeek(xFilial('SE1') + Padr(cPrefixo,3) + cNumero) )
			Conout('Numero titulo: ' + cNumero )	
			Exit				
		Else
			Conout('Nr.Titulo ja existente : ' + cNumero +' ,pesquisando novo numero.')
			SE1->( ConfirmSX8() )									
		EndIf   
	EndDo    				
	                       
	RestArea( aSE1 )
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Prepara array para chamar MsExecAuto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAuto := {}
	
	//aAdd( aAuto, {"E1_FILIAL"	, xFilial("SE1")			, Nil })
	aAdd( aAuto, {"E1_PREFIXO"	, cPrefixo					, Nil })
	aAdd( aAuto, {"E1_NUM"		, cNumero					, Nil })
	aAdd( aAuto, {"E1_PARCELA"	, StrZero(Val(_cParcela),2)	, Nil })
	aAdd( aAuto, {"E1_TIPO"		, _cTipo					, Nil })
	aAdd( aAuto, {"E1_NATUREZ"	, _cNatureza				, Nil })
	aAdd( aAuto, {"E1_CLIENTE"	, _cCliente					, Nil })
	aAdd( aAuto, {"E1_LOJA"		, _cLoja					, Nil })
	aAdd( aAuto, {"E1_EMISSAO"	, _cEmissao					, Nil })
	aAdd( aAuto, {"E1_VENCTO"	, _cVencto					, Nil })
	aAdd( aAuto, {"E1_VENCREA"	, _cVencReal				, Nil })
	aAdd( aAuto, {"E1_XCTMDW"	, _cContraMDW				, Nil })
	aAdd( aAuto, {"E1_XPIMDW"	, _cPiMDW					, Nil })
	aAdd( aAuto, {"E1_VALOR"	, _nValor					, Nil })
	aAdd( aAuto, {"E1_RCNOSZ2"	, _nRecnoSZ2				, Nil })
	aAdd( aAuto, {"E1_HIST"		, Alltrim(_cHist)			, Nil })
	aAdd( aAuto, {"E1_XHIST"	, Alltrim(_cHist)			, Nil })
	aAdd( aAuto, {"E1_XMNOTA"	, Alltrim(_cHist)			, Nil })
	aAdd( aAuto, {"E1_CCUSTO"	, Alltrim(_cCusto)			, Nil })
	aAdd( aAuto, {"E1_XOPFAT"	, "1"						, Nil })
	aAdd( aAuto, {"E1_VEND1"	, Alltrim(_cVend1)		    , Nil })
	aAdd( aAuto, {"E1_VEND2"	, Alltrim(_cVend2)	    	, Nil })
	aAdd( aAuto, {"E1_VEND3"	, Alltrim(_cVend3)   		, Nil })
	aAdd( aAuto, {"E1_COMIS1"	, _cComis1           		, Nil })
	aAdd( aAuto, {"E1_COMIS2"	, _cComis2           		, Nil })
	aAdd( aAuto, {"E1_COMIS3"	, _cComis3           		, Nil })
		
	
	/* PARA TESTE
	aAdd( aAuto, {"E1_PREFIXO"	, cPrefixo					, Nil })
	aAdd( aAuto, {"E1_NUM"		, cNumero					, Nil })
	aAdd( aAuto, {"E1_PARCELA"	, '01'						, Nil })
	aAdd( aAuto, {"E1_TIPO"		, "NF"					, Nil })
	aAdd( aAuto, {"E1_NATUREZ"	, "113"				, Nil })
	aAdd( aAuto, {"E1_CLIENTE"	, "000060"					, Nil })
	aAdd( aAuto, {"E1_LOJA"		, "01"					, Nil })
	aAdd( aAuto, {"E1_EMISSAO"	, STOD("20180620")					, Nil })
	aAdd( aAuto, {"E1_VENCTO"	, STOD("20180620")					, Nil })
	aAdd( aAuto, {"E1_VENCREA"	, STOD("20180620")				, Nil })
	aAdd( aAuto, {"E1_XCTMDW"	, "contra070707"				, Nil })
	aAdd( aAuto, {"E1_XPIMDW"	, "PI07"					, Nil })
	aAdd( aAuto, {"E1_VALOR"	, 100					, Nil })
	aAdd( aAuto, {"E1_RCNOSZ2"	, 70707				, Nil })
	*/
	
	//Inclusao do titulo a receber
	MSExecAuto({|x,y| FINA040(x,y)},aAuto,3) //Inclui
	
	If lMsErroAuto
		lRet := .F.
		SE1->( RollbackSX8() )
		aErro := GetAutoGRLog()
		MostraErro()
		cErro := ""
		/*
		For nY := 1 to Len ( aErro )
					
			If SubStr( aErro[nY], 1, 4 ) == 'HELP'
				cErro += AllTrim(aErro[nY]) + " | "
				cErro := StrTran ( cErro, Entra , " " , 1 , )
				
			EndIf
			If '< -- INVALIDO' $  aErro[nY] .or. '< -- Invalido' $  aErro[nY]
				cErro += AllTrim(aErro[nY]) + " | "
				cErro := StrTran ( cErro, Entra , " " , 1 , )
			EndIf
			
		Next nY
		*/
		ConOut(cErro)
	Else
		
		lRet := .T.
		SE1->( ConfirmSX8() )
		//alert("Titulo Gerado com Sucesso")
		SZ2->(DbGoTo(_nRecnoSZ2))
		RecLock("SZ2",.F.)
			SZ2->Z2_STATUS := "1"
		SZ2->(MsUnLock())
		
	EndIf
	
	RestArea(aArea)
		
Return(lRet)