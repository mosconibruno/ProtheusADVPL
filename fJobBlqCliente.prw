#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"           
     
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fJobBlqCliente³                           ³ Data ³16/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA BLOQUEAR E DESBLOQUEAR OS CLIENTES.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TV COSTA NORTE	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fJobBlqCliente()
	
	Local cDescr    := "Rotina para Bloquear/Desbloquear Clientes." 
	
	Private	lIsJob	:= .T.
	
	If lIsJob
	
		_cEmpresa 	:= "01"
		_cFilial 	:= "0101"		
		
		RPCClearEnv()
		RpcSetType(3)
		
		CONOUT("======================== INICIO ========================")
		
		CONOUT("== "+cDescr+" ==")
		CONOUT("== Prepara Ambiente Empresa: "+_cEmpresa+" Filial: "+_cFilial+" ==")
		
		PREPARE ENVIRONMENT EMPRESA _cEmpresa FILIAL _cFilial MODULO "FAT"

		Conout(cDescr + " - Iniciado as " + Time())
			
			fProcBloq()
			
			fProcDesbl()
		
		Conout(cDescr + " - Finalizado as " + Time())
		
		RESET ENVIRONMENT
		
		CONOUT("======================== FIM ========================")
		
	EndIf
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fProcBloq ³                               ³ Data ³16/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA BLOQUEAR E DESBLOQUEAR OS CLIENTES.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TV COSTA NORTE	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fProcBloq()

	Local cQuery		:= ""
	Local dDT20CBDias	:= ctod("  /  /  ")
	Local nDias20CB		:= SuperGetMv("MV_NDCB20",,20)
	Local cClasseN		:= ""//SuperGetMv("MV_CLASSEN",,"A")
	
	DbSelectArea("SA1")
	
	// 20 DIAS CORRIDOS
    dDT20CBDias := dDataBase - nDias20CB 
	
	cQuery := " SELECT	DISTINCT SE1.E1_CLIENTE, SE1.E1_LOJA "
	cQuery += " FROM	" + RetSQLName("SE1") + "	SE1 (NOLOCK), "
	cQuery += " 		" + RetSQLName("SA1") + " 	SA1 (NOLOCK) "
	cQuery += " WHERE	SE1.E1_SALDO				> 0 "
	cQuery += " AND		SE1.E1_BAIXA				= '' "
	cQuery += " AND		SE1.E1_VENCORI				<= '" + DTOS(dDT20CBDias) + "' "
	cQuery += " AND		SE1.E1_TIPO					<> 'PR' "
	//cQuery += " AND		SE1.E1_NUMBCO				<> '' "
	cQuery += " AND		SE1.D_E_L_E_T_				= ' ' "
	cQuery += " AND		SA1.A1_FILIAL				= '" + xFilial("SA1") + "' "
	cQuery += " AND		SA1.A1_COD					= SE1.E1_CLIENTE "
	cQuery += " AND		SA1.A1_LOJA					= SE1.E1_LOJA "
	//cQuery += " AND		SA1.A1_RISCO				<> '" + cClasseN + "' "
	cQuery += " AND		SA1.A1_RISCO				NOT IN ('A','B') "
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
    
    	SA1->(DbSetOrder(1))
    	If SA1->(DbSeek(xFilial("SA1")+SQL->E1_CLIENTE+SQL->E1_LOJA))
    		RecLock("SA1", .F.)
				SA1->A1_MSBLQL := "1"
			SA1->(MsUnlock())
    	EndIf
    
    	SQL->(DbSkip())
		
	EndDo
		
	DbSelectArea("SQL")
	SQL->(DbCloseArea())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³fProcDesbl³                               ³ Data ³16/03/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ ROTINA PARA BLOQUEAR E DESBLOQUEAR OS CLIENTES.		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TV COSTA NORTE	                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fProcDesbl()

	Local cQuery		:= ""
	Local dDT20CBDias	:= ctod("  /  /  ")
	Local nDias20CB		:= SuperGetMv("MV_NDCB20",,20)
	Local cClasseN		:= SuperGetMv("MV_CLASSEN",,"A|B")
	
	DbSelectArea("SA1")
	
	// 20 DIAS CORRIDOS
    dDT20CBDias := dDataBase - nDias20CB 
    
    cQuery := " SELECT	SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, "
	cQuery += " 		TB_SE1.E1_NUM "
	cQuery += " FROM	" + RetSQLName("SA1") + "	SA1 (NOLOCK) "
	cQuery += " LEFT JOIN "
	cQuery += " ( "
	cQuery += " 	SELECT	* "
	cQuery += " 	FROM	" + RetSQLName("SE1") + " "
	cQuery += " 	WHERE	E1_SALDO	> 0 "
	cQuery += " 	AND		E1_BAIXA	= '' "
	cQuery += " 	AND		E1_VENCORI	<= '" + DTOS(dDT20CBDias) + "' "
	cQuery += " 	AND		E1_TIPO		<> 'PR' "
	//cQuery += " 	AND		E1_NUMBCO	<> '' "
	cQuery += " 	AND		D_E_L_E_T_	= '' "
	cQuery += " )TB_SE1 "
	cQuery += " ON TB_SE1.E1_CLIENTE = SA1.A1_COD AND TB_SE1.E1_LOJA = SA1.A1_LOJA "
	cQuery += " WHERE	SA1.A1_FILIAL		= '" + xFilial("SA1") + "' "
	cQuery += " AND		SA1.A1_MSBLQL		= '1' "
	//Ajuste no dia 23/07/2018
	cQuery += " AND		SA1.A1_RISCO		NOT IN ('E') "
	cQuery += " AND		SA1.D_E_L_E_T_		= '' "
	
	If SELECT("SQL") > 0 	
		dbSelectArea("SQL") 	
		dbCloseArea()		
	EndIf 
     
    cQuery := ChangeQuery(cQuery)                                                              
    dbUseArea(.T., 'TOPCONN', TCGENQRY(,,cQuery),"SQL", .F., .T.)   	
    dbSelectArea("SQL")
    
    SQL->(DbGoTop())
	While SQL->(!Eof())
    
    	If Empty(SQL->E1_NUM)
    	
	    	SA1->(DbSetOrder(1))
	    	If SA1->(DbSeek(xFilial("SA1")+SQL->A1_COD+SQL->A1_LOJA))
	    		RecLock("SA1", .F.)
					SA1->A1_MSBLQL := "2"
				SA1->(MsUnlock())
	    	EndIf
	    
	    EndIf	
    
    	SQL->(DbSkip())
		
	EndDo
		
	DbSelectArea("SQL")
	SQL->(DbCloseArea())

Return
