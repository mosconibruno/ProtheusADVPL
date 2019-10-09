#Include 'Protheus.ch'
#Include 'topconn.ch'
#Include 'rwMake.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M030INC ³                             ³ Data ³ 23/02/2018  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ PE para complementar a inclusão no cadastro do Cliente     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TV COSTA NORTE                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M030INC()// Atualização de arquivos ou campos do usuário após a inclusão do Cliente

	Local aArea 		:= GetArea()
	Local oWebCliente
	Local cSvcError 
	Local cSoapFCode
	Local cSoapFDescr
	Local lRet			:= .F.
	
	If INCLUI
	
		//Integração com o MundiWare
		oWebCliente := WSClassicIntegration():New()
			
		oWebCliente:oWSclient:cisCompany		:= Iif( M->A1_PESSOA == "J", "true", "false" )
		oWebCliente:oWSclient:ccgc				:= Alltrim(M->A1_CGC)
		oWebCliente:oWSclient:cname             := Alltrim(M->A1_NOME)
		oWebCliente:oWSclient:ccompanyName      := Alltrim(M->A1_NREDUZ)
		oWebCliente:oWSclient:caddress          := Alltrim(M->A1_END)
		oWebCliente:oWSclient:cneighbourhood    := Alltrim(M->A1_BAIRRO)
		oWebCliente:oWSclient:ccity             := Alltrim(M->A1_MUN)
		oWebCliente:oWSclient:cstate            := Alltrim(M->A1_EST)
		oWebCliente:oWSclient:czipCode          := Alltrim(M->A1_CEP)
		oWebCliente:oWSclient:ctelephone        := Alltrim(M->A1_TEL)
		oWebCliente:oWSclient:cfax              := Alltrim(M->A1_FAX)
		oWebCliente:oWSclient:cemail            := Alltrim(M->A1_EMAIL)
		oWebCliente:oWSclient:cisAgency         := Iif( M->A1_TIPO == "R", "true", "false" )
		
		If oWebCliente:InsertOrUpdateClient()
					
			lRet := .T.	
			If oWebCliente:oWSInsertOrUpdateClientResult:cmessage <> Nil 
				MsgStop(oWebCliente:oWSInsertOrUpdateClientResult:cmessage, "Info")							  
			EndIf
			
		Else								  
			
			MsgStop(oWebCliente:oWSInsertOrUpdateClientResult:cmessage, "Info")	
			cSvcError := GetWSCError()
			
			If Left(cSvcError,9) == "WSCERR048"
				
				cSoapFCode  := Alltrim(Substr(GetWSCError(3),1,At(":",GetWSCError(3))-1))
				cSoapFDescr := Alltrim(Substr(GetWSCError(3),At(":",GetWSCError(3))+1,Len(GetWSCError(3))))
				
				MsgStop(cSoapFDescr, "Error " + cSoapFCode)
			Else
				MsgStop(GetWSCError(), "FALHA INTERNA") 
			EndIf
		
		Endif
		
	EndIf		
	
	RestArea(aArea)

Return(Nil)
