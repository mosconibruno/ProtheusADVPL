#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MATA030  �Autor  � Alexandre Takaki   � Data � 13/04/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA PARA INCLUSAO E ALTERACAO DE UM CLIENTE	  ���
���		     � CHAMANDO WS DO MUNDIWARE.							 	  ���
�������������������������������������������������������������������������͹��
���Uso       � TV COSTA NORTE                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MATA030()
	
	Local aArea			:= GetArea()
	Local xRet 			:= .F.
	Local oWebCliente
	Local cSvcError 
	Local cSoapFCode
	Local cSoapFDescr
	
	If INCLUI
	
		//Integra��o com o MundiWare
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
					
			xRet := .T.	
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
		
	ElseIf ALTERA
		
		//Integra��o com o MundiWare
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
					
			xRet := .T.	
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
		
	EndIf
	
	RestArea(aArea)

Return xRet