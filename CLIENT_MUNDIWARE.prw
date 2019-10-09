#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.0.185:14815/WebServices/ClassicIntegration.asmx?WSDL
Gerado em        03/14/18 18:55:22
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _IJPVIFQ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSClassicIntegration
------------------------------------------------------------------------------- */

WSCLIENT WSClassicIntegration

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD InsertOrUpdateClient

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSclient                 AS ClassicIntegration_InsertUpdateClientData
	WSDATA   oWSInsertOrUpdateClientResult AS ClassicIntegration_ResponseMessage

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSClassicIntegration
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170918 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
If val(right(GetWSCVer(),8)) < 1.040504
	UserException("O Código-Fonte Client atual requer a versão de Lib para WebServices igual ou superior a ADVPL WSDL Client 1.040504. Atualize o repositório ou gere o Código-Fonte novamente utilizando o repositório atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSClassicIntegration
	::oWSclient          := ClassicIntegration_INSERTUPDATECLIENTDATA():New()
	::oWSInsertOrUpdateClientResult := ClassicIntegration_RESPONSEMESSAGE():New()
Return

WSMETHOD RESET WSCLIENT WSClassicIntegration
	::oWSclient          := NIL 
	::oWSInsertOrUpdateClientResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSClassicIntegration
Local oClone := WSClassicIntegration():New()
	oClone:_URL          := ::_URL 
	oClone:oWSclient     :=  IIF(::oWSclient = NIL , NIL ,::oWSclient:Clone() )
	oClone:oWSInsertOrUpdateClientResult :=  IIF(::oWSInsertOrUpdateClientResult = NIL , NIL ,::oWSInsertOrUpdateClientResult:Clone() )
Return oClone

// WSDL Method InsertOrUpdateClient of Service WSClassicIntegration

WSMETHOD InsertOrUpdateClient WSSEND oWSclient WSRECEIVE oWSInsertOrUpdateClientResult WSCLIENT WSClassicIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<InsertOrUpdateClient xmlns="http://cn.mundiware.com/">'
cSoap += WSSoapValue("client", ::oWSclient, oWSclient , "InsertUpdateClientData", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</InsertOrUpdateClient>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://cn.mundiware.com/InsertOrUpdateClient",; 
	"DOCUMENT","http://cn.mundiware.com/",,,; 
	"http://192.168.0.185:14815/WebServices/ClassicIntegration.asmx")

::Init()
::oWSInsertOrUpdateClientResult:SoapRecv( WSAdvValue( oXmlRet,"_INSERTORUPDATECLIENTRESPONSE:_INSERTORUPDATECLIENTRESULT","ResponseMessage",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure InsertUpdateClientData

WSSTRUCT ClassicIntegration_InsertUpdateClientData
	WSDATA   cisCompany                AS string OPTIONAL
	WSDATA   ccgc                      AS string OPTIONAL
	WSDATA   cname                     AS string OPTIONAL
	WSDATA   ccompanyName              AS string OPTIONAL
	WSDATA   caddress                  AS string OPTIONAL
	WSDATA   cneighbourhood            AS string OPTIONAL
	WSDATA   ccity                     AS string OPTIONAL
	WSDATA   cstate                    AS string OPTIONAL
	WSDATA   czipCode                  AS string OPTIONAL
	WSDATA   ctelephone                AS string OPTIONAL
	WSDATA   cfax                      AS string OPTIONAL
	WSDATA   cemail                    AS string OPTIONAL
	WSDATA   cisAgency                 AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ClassicIntegration_InsertUpdateClientData
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ClassicIntegration_InsertUpdateClientData
Return

WSMETHOD CLONE WSCLIENT ClassicIntegration_InsertUpdateClientData
	Local oClone := ClassicIntegration_InsertUpdateClientData():NEW()
	oClone:cisCompany           := ::cisCompany
	oClone:ccgc                 := ::ccgc
	oClone:cname                := ::cname
	oClone:ccompanyName         := ::ccompanyName
	oClone:caddress             := ::caddress
	oClone:cneighbourhood       := ::cneighbourhood
	oClone:ccity                := ::ccity
	oClone:cstate               := ::cstate
	oClone:czipCode             := ::czipCode
	oClone:ctelephone           := ::ctelephone
	oClone:cfax                 := ::cfax
	oClone:cemail               := ::cemail
	oClone:cisAgency            := ::cisAgency
Return oClone

WSMETHOD SOAPSEND WSCLIENT ClassicIntegration_InsertUpdateClientData
	Local cSoap := ""
	cSoap += WSSoapValue("isCompany", ::cisCompany, ::cisCompany , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("cgc", ::ccgc, ::ccgc , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("name", ::cname, ::cname , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("companyName", ::ccompanyName, ::ccompanyName , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("address", ::caddress, ::caddress , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("neighbourhood", ::cneighbourhood, ::cneighbourhood , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("city", ::ccity, ::ccity , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("state", ::cstate, ::cstate , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("zipCode", ::czipCode, ::czipCode , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("telephone", ::ctelephone, ::ctelephone , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("fax", ::cfax, ::cfax , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("email", ::cemail, ::cemail , "string", .F. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("isAgency", ::cisAgency, ::cisAgency , "string", .F. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ResponseMessage

WSSTRUCT ClassicIntegration_ResponseMessage
	WSDATA   cid                       AS string OPTIONAL
	WSDATA   oWScode                   AS ClassicIntegration_ResponseCode
	WSDATA   cmessage                  AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ClassicIntegration_ResponseMessage
	::Init()
Return Self

WSMETHOD INIT WSCLIENT ClassicIntegration_ResponseMessage
Return

WSMETHOD CLONE WSCLIENT ClassicIntegration_ResponseMessage
	Local oClone := ClassicIntegration_ResponseMessage():NEW()
	oClone:cid                  := ::cid
	oClone:oWScode              := IIF(::oWScode = NIL , NIL , ::oWScode:Clone() )
	oClone:cmessage             := ::cmessage
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ClassicIntegration_ResponseMessage
	Local oNode2
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cid                :=  WSAdvValue( oResponse,"_ID","string",NIL,NIL,NIL,"S",NIL,NIL) 
	oNode2 :=  WSAdvValue( oResponse,"_CODE","ResponseCode",NIL,"Property oWScode as tns:ResponseCode on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode2 != NIL
		::oWScode := ClassicIntegration_ResponseCode():New()
		::oWScode:SoapRecv(oNode2)
	EndIf
	::cmessage           :=  WSAdvValue( oResponse,"_MESSAGE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return

// WSDL Data Enumeration ResponseCode

WSSTRUCT ClassicIntegration_ResponseCode
	WSDATA   Value                     AS string
	WSDATA   cValueType                AS string
	WSDATA   aValueList                AS Array Of string
	WSMETHOD NEW
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT ClassicIntegration_ResponseCode
	::Value := NIL
	::cValueType := "string"
	::aValueList := {}
	aadd(::aValueList , "Unkown" )
	aadd(::aValueList , "Ok" )
	aadd(::aValueList , "Error" )
Return Self

WSMETHOD SOAPSEND WSCLIENT ClassicIntegration_ResponseCode
	Local cSoap := "" 
	cSoap += WSSoapValue("Value", ::Value, NIL , "string", .F. , .F., 3 , NIL, .F.,.F.) 
Return cSoap

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT ClassicIntegration_ResponseCode
	::Value := NIL
	If oResponse = NIL ; Return ; Endif 
	::Value :=  oResponse:TEXT
Return 

WSMETHOD CLONE WSCLIENT ClassicIntegration_ResponseCode
Local oClone := ClassicIntegration_ResponseCode():New()
	oClone:Value := ::Value
Return oClone


