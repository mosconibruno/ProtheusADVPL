#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MALTCLI                               º Data ³ 22/02/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PONTO DE ENTRADA APOS A ALTERAÇÃO DO CLIENTE.			  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TV COSTA NORTE                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MALTCLI()

	Local aArea 		:= GetArea()
	Local oWebCliente
	Local cSvcError 
	Local cSoapFCode
	Local cSoapFDescr
	Local lRet			:= .F.
	
	//Integração com o MundiWare
	oWebCliente := WSClassicIntegration():New()
		
	oWebCliente:oWSclient:cisCompany		:= Iif( SA1->A1_PESSOA == "J", "true", "false" )
	oWebCliente:oWSclient:ccgc				:= Alltrim(SA1->A1_CGC)
	oWebCliente:oWSclient:cname             := Alltrim(SA1->A1_NOME)
	oWebCliente:oWSclient:ccompanyName      := Alltrim(SA1->A1_NREDUZ)
	oWebCliente:oWSclient:caddress          := Alltrim(SA1->A1_END)
	oWebCliente:oWSclient:cneighbourhood    := Alltrim(SA1->A1_BAIRRO)
	oWebCliente:oWSclient:ccity             := Alltrim(SA1->A1_MUN)
	oWebCliente:oWSclient:cstate            := Alltrim(SA1->A1_EST)
	oWebCliente:oWSclient:czipCode          := Alltrim(SA1->A1_CEP)
	oWebCliente:oWSclient:ctelephone        := Alltrim(SA1->A1_TEL)
	oWebCliente:oWSclient:cfax              := Alltrim(SA1->A1_FAX)
	oWebCliente:oWSclient:cemail            := Alltrim(SA1->A1_EMAIL)
	oWebCliente:oWSclient:cisAgency         := Iif( SA1->A1_TIPO == "R", "true", "false" )
	
	If oWebCliente:InsertOrUpdateClient()
				
		lRet := .T.	
		MsgStop(oWebCliente:oWSInsertOrUpdateClientResult:cmessage, "Info")							  
	
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
	
	RestArea(aArea)

Return(Nil)
