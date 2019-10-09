#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"  
#INCLUDE "APWEBSRV.CH"
#INCLUDE "APWEBEX.CH"
#INCLUDE "TOTVS.CH"
    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fJobAvsCob³ Autor ³ Alexandre Takaki      ³ Data ³02/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA ENVIAR EMAIL PARA AVISO E COBRANÇA - SE1.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TAKAKI			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fJobAvsCob()

	Local _cEmpresa := ""
	Local _cFilial 	:= ""
	Local cDescr    := "Rotina para Enviar e-mail de Aviso e Cobranca." 
	Local nX		:= 0
	
	Private	lIsJob	:= .T.
	Private aEmpFil	:= {}
	
	If lIsJob
		
		//Apenas para TESTE via Protheus
		//fProcessa()
		
		Aadd(aEmpFil,{"01","0101","60820750000131"})
		Aadd(aEmpFil,{"01","0201","03869745000180"})
		Aadd(aEmpFil,{"01","0301","68119635000146"})
		Aadd(aEmpFil,{"01","0401","03224294000123"})
		Aadd(aEmpFil,{"01","0501","21069859000127"})
		Aadd(aEmpFil,{"01","0601","04139932000170"})
		
		For nX := 1 To Len(aEmpFil)
			
			_cEmpresa 	:= Alltrim(aEmpFil[nX][1])
			_cFilial 	:= Alltrim(aEmpFil[nX][2])		
			
			RPCClearEnv()
			RpcSetType(3)
			
			CONOUT("======================== INICIO ========================")
			
			CONOUT("== "+cDescr+" ==")
			CONOUT("== Prepara Ambiente Empresa: "+_cEmpresa+" Filial: "+_cFilial+" ==")
			
			PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial MODULO "FAT"

			Conout(cDescr + " - Iniciado as " + Time())
			
				fProcessa()
			
			Conout(cDescr + " - Finalizado as " + Time())
			
			RESET ENVIRONMENT
			
			CONOUT("======================== FIM ========================")
			
		Next nX
		
	EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fProcessa ³ Autor ³ Alexandre Takaki      ³ Data ³02/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA ENVIAR EMAIL PARA AVISO E COBRANÇA - SE1.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TAKAKI			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fProcessa()

	Local cQuery		:= ""
	Local cAliasQry		:= GetNextAlias()
	Local nDias			:= 0
	Local cEmail		:= ""
	Local nHandle		:= 0
	Local nX        	:= 0
	Local aEmail    	:= {}
	Local cClasseN		:= SuperGetMv("MV_CLASSEN",,"A") //"A" //GetMv('MV_CLASSEN',.F.,'') //"A"
	
	Local dDT10AVDias	:= ctod("  /  /  ")
	Local nDias10AV		:= SuperGetMv("MV_NDAV10",,10)
	Local dDT03AVDias	:= ctod("  /  /  ")
	Local nDias03AV		:= SuperGetMv("MV_NDAV03",,3)
	Local dDT00AVDias	:= ctod("  /  /  ")
	Local nDias00AV		:= SuperGetMv("MV_NDAV00",,0)
	
	Local dDT03CBDias	:= ctod("  /  /  ")
	Local nDias03CB		:= SuperGetMv("MV_NDCB03",,3)
	Local dDT08CBDias	:= ctod("  /  /  ")
	Local nDias08CB		:= SuperGetMv("MV_NDCB08",,8)
	Local dDT15CBDias	:= ctod("  /  /  ")
	Local nDias15CB		:= SuperGetMv("MV_NDCB15",,15)
	Local dDT20CBDias	:= ctod("  /  /  ")
	Local nDias20CB		:= SuperGetMv("MV_NDCB20",,20)
	
	Local aTit10AV		:= {}
	Local aTit03AV		:= {}
	Local aTit00AV		:= {}
	
	Local aTit03CB		:= {}
	Local aTit08CB		:= {}
	Local aTit15CB		:= {}
	Local aTit20CB		:= {}
	
	Local cLinkNfe		:= ""
	
	Local cXbolSA1		:= ""
	
	Private cArquivo:= ''
	
	dDT10AVDias := dDataBase + nDias10AV 
    dDT03AVDias := dDataBase + nDias03AV 
    dDT00AVDias := dDataBase + nDias00AV 
    
    dDT03CBDias := DiaUtil(dDataBase,-nDias03CB)
    dDT08CBDias := DiaUtil(dDataBase,-nDias08CB)
    dDT15CBDias := DiaUtil(dDataBase,-nDias15CB)
    dDT20CBDias := DiaUtil(dDataBase,-nDias20CB)
	
	DbSelectArea('SE1')
	DbSelectArea('SA1')
			
	cQuery := " SELECT	SE1.E1_FILIAL, SE1.E1_NUM, SE1.E1_VENCREA, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.R_E_C_N_O_ NREG, "
	cQuery += " 		SE1.E1_EMISSAO, SE1.E1_VALOR, SE1.E1_IRRF, SE1.E1_PIS, SE1.E1_COFINS, SE1.E1_CSLL, "
	cQuery += " 		SE1.E1_PREFIXO, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_SALDO, SE1.E1_ARQBOL, "
	cQuery += " 		SE1.E1_DTAV10, SE1.E1_DTAV03, SE1.E1_DTAV00, SE1.E1_DTCB03, "
	cQuery += " 		SE1.E1_DTCB08, SE1.E1_DTCB15, SE1.E1_DTCB20, SE1.E1_XNUMDIG, SE1.E1_NFELETR, SE1.E1_XRPS, "
	cQuery += " 		CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),SE1.E1_XHIST)) HISTORICO, "
	cQuery += " 		SA1.A1_NOME, SA1.A1_EMAIL, "
	cQuery += " 		TB_SA3.A3_EMAIL "
	cQuery += " FROM	" + RetSQLName("SE1") + " 	SE1 (NOLOCK) "
	cQuery += " 		LEFT JOIN	"
	cQuery += " 		( "
	cQuery += " 			SELECT	A3_COD, A3_EMAIL "
	cQuery += " 			FROM	" + RetSQLName("SA3") + " "
	cQuery += " 			WHERE	A3_FILIAL	= '" + xFilial("SA3") + "' "
	cQuery += " 			AND		A3_MSBLQL	<> '1' "
	cQuery += " 			AND		D_E_L_E_T_	= '' "
	cQuery += " 		)TB_SA3 "
	cQuery += " 		ON TB_SA3.A3_COD = SE1.E1_VEND1, "
	cQuery += " 		" + RetSQLName("SA1") + " 	SA1 (NOLOCK) "
	cQuery += " WHERE	SE1.E1_FILIAL				= '" + xFilial("SE1") + "' "
	cQuery += " AND		SE1.E1_SALDO				> 0 "
	cQuery += " AND		SE1.E1_BAIXA				= '' "
	cQuery += " AND		SE1.E1_NUMBCO				<> '' "
	cQuery += " AND		SE1.E1_VENCREA				BETWEEN '" + DTOS(dDT20CBDias) + "' AND '" + DTOS(dDT10AVDias) + "' "
	cQuery += " AND		SE1.D_E_L_E_T_				= '' "
	cQuery += " AND		SA1.A1_FILIAL				= '" + xFilial("SA1") + "' "
	cQuery += " AND		SA1.A1_COD					= SE1.E1_CLIENTE "
	cQuery += " AND		SA1.A1_LOJA					= SE1.E1_LOJA "
	cQuery += " AND		SA1.A1_RISCO				<> '" + cClasseN + "' "
	cQuery += " AND		SA1.D_E_L_E_T_				= '' "
		
	If SELECT("SQL") > 0 	
		dbSelectArea("SQL") 	
		dbCloseArea()		
	EndIf 
     
    cQuery := ChangeQuery(cQuery)                                                              
    dbUseArea(.T., 'TOPCONN', TCGENQRY(,,cQuery),"SQL", .F., .T.)   	
    dbSelectArea("SQL")
    
	SQL->(DbGoTop())
	While SQL->(!Eof())
		
		cEmail := Alltrim(Lower(SQL->A1_EMAIL)) //"ttakaki6@gmail.com"//Alltrim(Lower(SQL->A1_EMAIL))
		
		/*-----------------------------------------------------------------
						AVISO DE VENCIMENTO - 10 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT10AVDias .And. Empty(SQL->E1_DTAV10)
			
			aadd(aTit10AV,{	"AV10"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf	
		
		/*-----------------------------------------------------------------
						AVISO DE VENCIMENTO - 3 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT03AVDias .And. Empty(SQL->E1_DTAV03)
			
			aadd(aTit03AV,{	"AV03"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf	
		
		/*-----------------------------------------------------------------
						AVISO DE VENCIMENTO - 0 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT00AVDias .And. Empty(SQL->E1_DTAV00)
			
			aadd(aTit00AV,{	"AV00"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf
		
		/*-----------------------------------------------------------------
						AVISO DE COBRANCA - 3 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT03CBDias .And. Empty(SQL->E1_DTCB03)
			
			aadd(aTit03CB,{	"CB03"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf	
		
		/*-----------------------------------------------------------------
						AVISO DE COBRANCA - 8 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT08CBDias .And. Empty(SQL->E1_DTCB08)
			
			aadd(aTit08CB,{	"CB08"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf
		
		/*-----------------------------------------------------------------
						AVISO DE COBRANCA - 15 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT15CBDias .And. Empty(SQL->E1_DTCB15)
			
			aadd(aTit15CB,{	"CB15"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf
		
		/*-----------------------------------------------------------------
						AVISO DE COBRANCA - 20 DIAS
		-----------------------------------------------------------------*/
		If STOD(SQL->E1_VENCREA) == dDT20CBDias .And. Empty(SQL->E1_DTCB20)
			
			aadd(aTit20CB,{	"FM20"					,;
							SQL->E1_NUM 			,;
							SQL->E1_EMISSAO	 		,;
							SQL->E1_VENCREA	 		,;
							SQL->E1_VALOR			,;
							SQL->E1_IRRF			,;
							SQL->E1_PIS 			,;
							SQL->E1_COFINS			,;
							SQL->E1_CSLL 			,;
							SQL->E1_SALDO			,;
							SQL->E1_PREFIXO			,;
							SQL->E1_PARCELA			,;
							SQL->E1_TIPO			,;
							SQL->NREG				,;
							SQL->E1_CLIENTE			,;
							SQL->E1_LOJA			,;
							AllTrim(SQL->A1_NOME)	,;
							cEmail					,;
							SQL->E1_XNUMDIG			,;
							FcnGerLink(SQL->E1_FILIAL,SQL->E1_XRPS,SQL->E1_NFELETR)	,;
							Alltrim(SQL->E1_ARQBOL)	,;
							Alltrim(SQL->HISTORICO)	,;
							Alltrim(Lower(SQL->A3_EMAIL))	;
						 	})
			
		EndIf
			
		SQL->(DbSkip())
		
	EndDo
		
	DbSelectArea("SQL")
	SQL->(DbCloseArea())
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR AVISO VENCIMENTO - 10 DIAS					  |
	-----------------------------------------------------------------------------*/
	If Len(aTit10AV) > 0 
		
	    For nX := 1 to len(aTit10AV)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit10AV[nX,15]+aTit10AV[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
				    
		    	If fEnvioMail(aTit10AV[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit10AV[nX,11] 	+;
										aTit10AV[nX,02] 	+;
										aTit10AV[nX,12] 	+;
										aTit10AV[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTAV10 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        
		    	EndIf
		    
		    EndIf	
	    	
	    Next nX
		        
	Endif
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR AVISO VENCIMENTO - 3 DIAS					  |
	-----------------------------------------------------------------------------*/
	If Len(aTit03AV) > 0 
		
	    For nX := 1 to len(aTit03AV)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit03AV[nX,15]+aTit03AV[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
	    
		    	If fEnvioMail(aTit03AV[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit03AV[nX,11] 	+;
										aTit03AV[nX,02] 	+;
										aTit03AV[nX,12] 	+;
										aTit03AV[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTAV03 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        
		    	EndIf
		
			EndIf
		    	
	    Next nX
		        
	Endif
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR AVISO VENCIMENTO - 0 DIA						  |
	-----------------------------------------------------------------------------*/
	If Len(aTit00AV) > 0 
		
	    For nX := 1 to len(aTit00AV)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit00AV[nX,15]+aTit00AV[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
	    
		    	If fEnvioMail(aTit00AV[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit00AV[nX,11] 	+;
										aTit00AV[nX,02] 	+;
										aTit00AV[nX,12] 	+;
										aTit00AV[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTAV00 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        
		    	EndIf
		    
		    EndIf
		    	
	    Next nX
		        
	Endif
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR COBRANCA - 3 DIAS							  |
	-----------------------------------------------------------------------------*/
	If Len(aTit03CB) > 0 
		
	    For nX := 1 to len(aTit03CB)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit03CB[nX,15]+aTit03CB[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
	    
		    	If fEnvioMail(aTit03CB[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit03CB[nX,11] 	+;
										aTit03CB[nX,02] 	+;
										aTit03CB[nX,12] 	+;
										aTit03CB[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTCB03 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        
		    	EndIf
	    	
			EndIf

	    Next nX
		        
	Endif
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR COBRANCA - 8 DIAS							  |
	-----------------------------------------------------------------------------*/
	If Len(aTit08CB) > 0 
		
	    For nX := 1 to len(aTit08CB)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit08CB[nX,15]+aTit08CB[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
	    
		    	If fEnvioMail(aTit08CB[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit08CB[nX,11] 	+;
										aTit08CB[nX,02] 	+;
										aTit08CB[nX,12] 	+;
										aTit08CB[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTCB08 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        
		    	EndIf
	    	
	    	EndIf
	    	
	    Next nX
		        
	Endif
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR COBRANCA - 15 DIAS							  |
	-----------------------------------------------------------------------------*/
	If Len(aTit15CB) > 0 
		
	    For nX := 1 to len(aTit15CB)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit15CB[nX,15]+aTit15CB[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
		    
		    	If fEnvioMail(aTit15CB[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit15CB[nX,11] 	+;
										aTit15CB[nX,02] 	+;
										aTit15CB[nX,12] 	+;
										aTit15CB[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTCB15 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        
		    	EndIf
	    	
	    	EndIf
	    	
	    Next nX
		        
	Endif
	
	/*-----------------------------------------------------------------------------
	|						ENVIAR COBRANCA - 20 DIAS							  |
	-----------------------------------------------------------------------------*/
	If Len(aTit20CB) > 0 
		
	    For nX := 1 to len(aTit20CB)
	    
	    	//Tratamento para olhar o campo A1_XBOLETO
	    	cXbolSA1 := Posicione('SA1',1,xFilial("SA1")+aTit20CB[nX,15]+aTit20CB[nX,16],'A1_XBOLETO')
	    
			If cXbolSA1 <> "2" //NAO
	    
		    	If fEnvioMail(aTit20CB[nX]) 
		    
					// chave: E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
					SE1->(dbSetOrder(1))
					If SE1->(dbSeek(	xFilial("SE1") 		+;
										aTit20CB[nX,11] 	+;
										aTit20CB[nX,02] 	+;
										aTit20CB[nX,12] 	+;
										aTit20CB[nX,13]) ) 
						RecLock("SE1", .F.)
							SE1->E1_DTCB20 := dDataBase
						SE1->(MsUnlock())
		        	EndIf
		        	
		    	EndIf
		    	
		    EndIf	
	    	
	    Next nX
		        
	Endif
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fEnvioMail³ Autor ³ Alexandre Takaki      ³ Data ³02/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA ENVIAR EMAIL PARA AVISO E COBRANÇA - SE1.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TAKAKI			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fEnvioMail(aDados)

	Local lRet		:= .F.
	Local cUser 	:= ""
	Local cPass 	:= ""
	Local cSendSrv 	:= ""
  	Local cMsg 		:= ""
  	Local nSendPort := 0
	Local nSendSec 	:= 2
	Local nTimeout 	:= 0
	Local cMailTo	:= ""
	Local cMailCC	:= ""
  	Local xRet
  	Local oServer
	Local oMessage
	
	Local cTitulo 	:= ""
	Local cTipo		:= ""
	Local cNome		:= ""
	Local cVencReal	:= ""
	Local cNumTit	:= ""
	Local cNumDig	:= ""
	Local nValor	:= 0
	
	Local cLinkNota	:= ""
	Local cAnexoAux	:= ""
	
	Local cParcela	:= ""
	Local cHistorico:= ""
	
	Local nSE1Recno	:= 0
	Local cVendMail	:= ""
	
	DbSelectArea("SE1")
		
	cUser 		:= GETMV("MV_XACNTO") 	//"contato@costanorte.com.br" //define the e-mail account username
  	cPass 		:= GETMV("MV_XPSW") 	//"costa123" //define the e-mail account password
  	cSendSrv 	:= GETMV("MV_XSMTP")	//"smtp.gmail.com" // define the send server
  	nTimeout 	:= GETMV("MV_XTIMEO") 	//120 // define the timout to 60 seconds
  	cMailTo 	:= "" // GETMV("MV_XTOEMAI")	//Define os E-mails que serão enviados no PARA      
  	cMailCC		:= Alltrim(GETMV("MV_XCCEMAI"))	//Define os E-mails que serão enviados no Cópia      
   	
	cMsg 		:= ""
	cTipo 		:= aDados[1]
	cNome		:= aDados[17]
	cVencReal	:= Substr(aDados[4],7,2)+"/"+Substr(aDados[4],5,2)+"/"+Substr(aDados[4],1,4)
	cMailTo		:= aDados[18]
	cNumTit		:= aDados[2]
	cNumDig		:= StrTran(StrTran(StrTran(aDados[19],".",""),"-","")," ","")
	nValor		:= aDados[5]
	cLinkNota	:= aDados[20]
	cAnexoAux	:= aDados[21]
	
	cParcela	:= aDados[12]
	cHistorico	:= aDados[22]
	
	nSE1Recno	:= aDados[14]
	
	cVendMail	:= aDados[23]
	
	If cTipo == "AV10"
		cTitulo := "Sistema Costa Norte - Aviso de Vencimento (10 Dias)"
	ElseIf cTipo == "AV03"
		cTitulo := "Sistema Costa Norte - Aviso de Vencimento (3 Dias)"	
	ElseIf cTipo == "AV00"
		cTitulo := "Sistema Costa Norte - Aviso de Vencimento (Hoje)"	
	ElseIf cTipo == "CB03"
		cTitulo := "Sistema Costa Norte - Aviso de Título em Atraso (3 Dias)"
	ElseIf cTipo == "CB08"
		cTitulo := "Sistema Costa Norte - Aviso de Título em Atraso (8 Dias)"				
	ElseIf cTipo == "CB15"
		cTitulo := "Sistema Costa Norte - Aviso de Título em Atraso (15 Dias)"	
	ElseIf cTipo == "FM20"
		cTitulo := "Sistema Costa Norte – Suspenção de Contrato (20 Dias)"	
	EndIf
	
	cMsg +=' <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"> '
	cMsg +=' <html> '
	cMsg +='     <head> '
	cMsg +='         <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"> '
	cMsg +='         <title>Aviso - Sistema Costa Norte de Comunicação</title> '
	cMsg +='         <style type="text/css"> '
	cMsg +='         a:hover {  text-decoration: underline} '
	cMsg +=' 	    a:link {  text-decoration: none} '
	cMsg +=' 	    a:active {  } '
	cMsg +='         .texto '
	cMsg +='         { '
	cMsg +='             COLOR: #636363; '
	cMsg +='             FONT-FAMILY: Verdana, Arial; '
	cMsg +='             FONT-SIZE: 12px; '
	cMsg +='             TEXT-DECORATION: none; '
	cMsg +='         } '
	cMsg +='         .titulo '
	cMsg +='         { '
	cMsg +='             COLOR: #636363; '
	cMsg +='             FONT-FAMILY: Verdana, Arial; '
	cMsg +='             FONT-SIZE: 14px; '
	cMsg +='             TEXT-DECORATION: none; '
	cMsg +='         } '
	cMsg +='         .texto_negrito '
	cMsg +='         { '
	cMsg +='             COLOR: #636363; '
	cMsg +='             FONT-FAMILY: Verdana, Arial; '
	cMsg +='             FONT-SIZE: 12px; '
	cMsg +='             TEXT-DECORATION: none; '
	cMsg +='             FONT-WEIGHT: Bold; '
	cMsg +='         } '
	cMsg +='         </style> '
	cMsg +='     </head> '
	cMsg +='     <body leftmargin="0" topmargin="0"> '
	cMsg +='         <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%"> '
	cMsg +='             <tr> '
	cMsg +='                 <td align="center"> '
	cMsg +='                     <table border="1" cellpadding="10" cellspacing="10" width="600" height="400"> '
	cMsg +=' 						<tr> '
	cMsg +=' 							<td align="center"> '
	cMsg +=' 								<table> '
	cMsg +=' 									<tr> '
	cMsg +=' 										<td><img src="http://d.costanorte.com.br/themes/JCN_0702/img/desktop/sistema-costa-norte-de-comunicacao.png"></td> '
	cMsg +=' 									</tr> '
	cMsg +=' 								</table> '
	cMsg +=' 							</td> '
	cMsg +=' 						</tr> '
	cMsg +=' 						<tr> '
	cMsg +='                             <td valign="top"> '
	cMsg +='                                 <fieldset> '
	cMsg +='                                     <legend class="titulo">Aviso de vencimento de título</legend> '
	cMsg +='                                     <table border="0" cellpadding="5" cellspacing="3"> '
	If Substr(cTipo,1,2) == "AV"
		cMsg +='                                         <tr> '
		cMsg +='                                             <td class="texto"> '
		cMsg +='												Lembrete de vencimento de boleto. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Prezado cliente '+cNome+', '
		cMsg +=' 												<br><br> '
		cMsg +=' 												CONTRATO/TITULO: '+cNumTit+ ' / Parcela: '+cParcela+ '.'
		cMsg +=' 												<br><br> '
		cMsg +=' 												Lembramos que seu boleto vence dia '+cVencReal+'*. '
		cMsg +=' 												<br><br> '
		
		If !Empty(cNumDig)
			cMsg +=' 												Para sua comodidade segue abaixo o código de barras de seu boleto: ' 
			cMsg +=' 												<br><br> '
			cMsg +=' 												Código de Barras: '+cNumDig+ ''
			cMsg +=' 												<br><br> '
		EndIf
		
		If !Empty(cLinkNota)
			cMsg +=' 												Para visualizar a Nota Fiscal acesse o link a seguir: ' 
			cMsg +=' 												<br><br> '
			cMsg +=' 												<a href="'+cLinkNota+'" target="blank">'+ cLinkNota +'</a> '
			cMsg +=' 												<br><br> '
		EndIf
		
		cMsg +=' 												Serviço referente a: '+cHistorico+ ''
		cMsg +=' 												<br><br> '
		cMsg +=' 												*Caso tenha efetuado o pagamento, por favor desconsiderar este e-mail. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Sistema Costa Norte de Comunicação '
		cMsg +=' 												<br><br> '
		cMsg +=' 												<a href="http://www.costanorte.com.br" target="blank">www.costanorte.com.br</a> '
		cMsg +=' 											</td> '
		cMsg +='                                         </tr> '
	ElseIf Substr(cTipo,1,2) == "CB"
		cMsg +='                                         <tr> '
		cMsg +='                                             <td class="texto"> '
		cMsg +='												Aviso de título em atraso. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Prezado cliente '+cNome+', '
		cMsg +=' 												<br><br> '
		cMsg +=' 												CONTRATO/TITULO: '+cNumTit+ ' / Parcela: '+cParcela+ '.'
		cMsg +=' 												<br><br> '
		cMsg +=' 												Não consta em nosso sistema o pagamento do título vencido em '+cVencReal+'*. '
		cMsg +=' 												<br><br> '
		
		If !Empty(cNumDig)
			cMsg +=' 												Para atualização de seu boleto utilize o código de barras no link abaixo: ' 
			cMsg +=' 												<br><br> '
			cMsg +=' 												Código de Barras: '+cNumDig+ ''
			cMsg +=' 												<br><br> '
			cMsg +=' 												<center><a href="https://www.itau.com.br/servicos/boletos/atualizar/" target="blank">www.itau.com.br/servicos/boletos/atualizar/</a></center> '
			cMsg +=' 												<br><br> '
		EndIf
		
		If !Empty(cLinkNota)
			cMsg +=' 												Para visualizar a Nota Fiscal acesse o link a seguir: ' 
			cMsg +=' 												<br><br> '
			cMsg +=' 												<a href="'+cLinkNota+'" target="blank">'+ cLinkNota +'</a> '
			cMsg +=' 												<br><br> '
		EndIf
		
		cMsg +=' 												Serviço referente a: '+cHistorico+ ''
		cMsg +=' 												<br><br> '
		cMsg +=' 												*Caso tenha efetuado o pagamento, por favor desconsiderar este e-mail. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												¹Lembramos que a partir do vigésimo dia de atraso os serviços serão suspensos. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												²Evite multas e juros, mantenha seus pagamentos em dia. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Sistema Costa Norte de Comunicação '
		cMsg +=' 												<br><br> '
		cMsg +=' 												<a href="http://www.costanorte.com.br" target="blank">www.costanorte.com.br</a> '
		cMsg +=' 											</td> '
		cMsg +='                                         </tr> '
	ElseIf Substr(cTipo,1,2) == "FM"
		cMsg +='                                         <tr> '
		cMsg +='                                             <td class="texto"> '
		cMsg +='												Aviso de suspensão de serviços. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Prezado cliente '+cNome+', '
		cMsg +=' 												<br><br> '
		cMsg +=' 												CONTRATO/TITULO: '+cNumTit+ ' / Parcela: '+cParcela+ '.'
		cMsg +=' 												<br><br> '
		cMsg +=' 												Não consta em nosso sistema o pagamento do título vencido em '+cVencReal+'*. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Em virtude do atraso no pagamento da parcela referente ao contrato firmado e da ausência de retorno sobre o assunto, estamos suspendendo os serviços temporariamente até a regularização do mesmo. ' 
		cMsg +=' 												<br><br> '
		
		If !Empty(cNumDig)
			cMsg +=' 												Para regularizar a situação de seu contrato basta fazer a atualização de seu boleto utilizando o código de barras no link abaixo: '
			cMsg +=' 												<br><br> '
			cMsg +=' 												Código de Barras: '+cNumDig+ ''
			cMsg +=' 												<br><br> '
			cMsg +=' 												<center><a href="https://www.itau.com.br/servicos/boletos/atualizar/" target="blank">www.itau.com.br/servicos/boletos/atualizar/</a></center> '
			cMsg +=' 												<br><br> '
		EndIf	
		
		If !Empty(cLinkNota)
			cMsg +=' 												Para visualizar a Nota Fiscal acesse o link a seguir: ' 
			cMsg +=' 												<br><br> '
			cMsg +=' 												<a href="'+cLinkNota+'" target="blank">'+ cLinkNota +'</a> '
			cMsg +=' 												<br><br> '
		EndIf
		
		cMsg +=' 												Serviço referente a: '+cHistorico+ ''
		cMsg +=' 												<br><br> '	
		cMsg +=' 												*Caso tenha efetuado o pagamento, por favor desconsiderar este e-mail. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												¹Evite multas e juros, mantenha seus pagamentos em dia. '
		cMsg +=' 												<br><br> '
		cMsg +=' 												Sistema Costa Norte de Comunicação '
		cMsg +=' 												<br><br> '
		cMsg +=' 												<a href="http://www.costanorte.com.br" target="blank">www.costanorte.com.br</a> '
		cMsg +=' 											</td> '
		cMsg +='                                         </tr> '	
	EndIf
	cMsg +='                                     </table> '
	cMsg +='                                 </fieldset> '               
	cMsg +='                             </td> '
	cMsg +='                         </tr> '
	cMsg +='                     </table> '
	cMsg +='                 </td> '
	cMsg +='             </tr> '
	cMsg +='         </table> '
	cMsg +='     </body> '
	cMsg +=' </html> '
	
	oServer := TMailManager():New()
 
  	oServer:SetUseSSL( .F. )
  	oServer:SetUseTLS( .F. )
	
	If nSendSec == 0
   	 	nSendPort := 25 //default port for SMTP protocol
  	ElseIf nSendSec == 1
    	nSendPort := 465 //default port for SMTP protocol with SSL
    	oServer:SetUseSSL( .T. )
  	Else
    	nSendPort := 587 //default port for SMTPS protocol with TLS
    	oServer:SetUseTLS( .T. )
  	EndIf	
	
	xRet := oServer:Init( "", cSendSrv, cUser, cPass, , nSendPort )
  	If xRet != 0
	  	cMsg := "Não foi possível inicializar o servidor SMTP: " + oServer:GetErrorString( xRet )
	  	conout( cMsg )
  		return
  	EndIf
  	
  	xRet := oServer:SetSMTPTimeout( nTimeout )
  	If xRet != 0
    	cMsg := "Não foi possível setar: " + cProtocol + " TimeOut: " + cValToChar( nTimeout )
    	conout( cMsg )
  	EndIf
	
	xRet := oServer:SMTPConnect()
  	If xRet <> 0
    	cMsg := "Não foi possível conectar com o servidor SMTP: " + oServer:GetErrorString( xRet )
    	conout( cMsg )
    	return
  	EndIf
  	
  	xRet := oServer:SmtpAuth( cUser, cPass )
  	If xRet <> 0
    	cMsg := "Não foi possível autenticar com o servidor SMTP: " + oServer:GetErrorString( xRet )
    	conout( cMsg )
    	oServer:SMTPDisconnect()
    	return
  	EndIf
	
	oMessage := TMailMessage():New()
  	oMessage:Clear()
  	
  	oMessage:cDate 		:= cValToChar( Date() )
  	oMessage:cFrom 		:= cUser
  	oMessage:cTo 		:= cMailTo
  	oMessage:cCc      	:= cMailCC + iif( Substr(cTipo,1,2) <> "AV", iif( !Empty(cVendMail),";"+cVendMail,"" ) ,"" )
  	oMessage:cBCC 		:= "ttakaki6@gmail.com"
  	oMessage:cSubject 	:= cTitulo
  	oMessage:cBody 		:= cMsg
   	
   	//Anexar o boleto caso o mesmo tenha sido gerada pela rotina "Boleto Enviar Email"
   	If !Empty(cAnexoAux)
	   	xRet := oMessage:AttachFile( cAnexoAux )
	  	If xRet < 0
		    cMsg := "Não foi possível anexar o arquivo: " + cAnexoAux
		    conout( cMsg )
		Else
		    SE1->(DbGoTo(nSE1Recno))
		    RecLock("SE1",.F.)
		    	SE1->E1_STATBOL := "2"
		    SE1->(MsUnLock())
	  	Endif
   	EndIf
   	
   	
  	xRet := oMessage:Send( oServer )
  	if xRet <> 0
    	cMsg := "Não foi possível enviar o e-mail: " + oServer:GetErrorString( xRet )
    	conout( cMsg )
  	Else
  		conout( "E-mail enviado com Sucesso" ) 
  		lRet := .T. 
  	endif
	  
  	xRet := oServer:SMTPDisconnect()
  	If xRet <> 0
    	cMsg := "Não foi possível desconectar do servidor SMTP: " + oServer:GetErrorString( xRet )
    	conout( cMsg )
  	EndIf	
   	
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ DiaUtil  ³ Autor ³ Alexandre Takaki      ³ Data ³08/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA ENVIAR EMAIL PARA AVISO E COBRANÇA - SE1.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TAKAKI			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DiaUtil(_dData, _nDias)
	
	Local nI 			:= 0
	Local _dData2 		:= _dData   
	Local _dData2Ant	:= _dData
	
	For nI := 1 to Abs(_nDias)
	
		_dData2 := DataValida(_dData2 + iif(_nDias > 0, +1, -1) ) 
	
		nD := 0
		
		While _dData2 == _dData2Ant
			_dData2 := DataValida(_dData2 - ++nD ) 
		EndDo	
		     
		_dData2Ant := _dData2
	
	Next nI

Return _dData2

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FcnGerLink³ Autor ³ Alexandre Takaki      ³ Data ³13/04/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA GERAR O LINK DA NOTA.			      		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TAKAKI			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FcnGerLink(_cFilial,_cDocumento,_cNfeletr)

	Local cRet 		:= ""
	Local cQry		:= ""
	Local _CGC		:= SM0->M0_CGC
	Local nX		:= 0
	
	If !Empty(_cDocumento)
		
		cQry := " SELECT 	DISTINCT SF2.F2_CODNFE "
		cQry += " FROM 		" + RetSQLName("SF2") + " 	SF2 (NOLOCK) "
		cQry += " WHERE		SF2.F2_FILIAL				= '" + _cFilial + "' "
		cQry += " AND 		SF2.F2_DOC 					= '" + _cDocumento + "' "
		cQry += " AND		SF2.D_E_L_E_T_				= '' "
	
		If SELECT("XQL") > 0 	
			dbSelectArea("XQL") 	
			dbCloseArea()		
		EndIf 
	     
	    cQry := ChangeQuery(cQry)                                                              
	    dbUseArea(.T., 'TOPCONN', TCGENQRY(,,cQry),"XQL", .F., .T.)   	
	    dbSelectArea("XQL")
	    
		XQL->(DbGoTop())
		If XQL->(!Eof())
		
			cRet := "http://visualizar.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao="+Alltrim(XQL->F2_CODNFE)+"&numNota="+Alltrim(_cNfeletr)+"&cnpjPrestador="+Alltrim(_CGC)
		
		EndIf
	
	EndIf	

Return(cRet)