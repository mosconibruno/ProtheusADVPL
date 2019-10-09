#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ APRTITREC	  บAutor  ณ Alexandre Takaki   บ Data ณ 05/08/2018  บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ROTINA PARA ALTERAR E APROVAR OS TITULOS A RECEBER				บฑฑ
ฑฑบ          ณ 												      				บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TV COSTA NORTE	  		                                      	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function APRTITREC()

	Local aArea   := {}
	Local cFiltro := ""
	Local cKey    := ""
	Local cArq    := ""
	Local nIndex  := 0
	Local aSay    := {}
	Local aButton := {}
	Local nOpcao  := 0
	Local cDesc1  := "Este programa tem o objetivo de criar os tํtulos - SE1 atrav้s da integra็ใo"
	Local cDesc2  := "do Protheus X Mundiware, conforme parโmetros fornecido pelo usuแrio, sendo que o "
	Local cDesc3  := "mesmo serแ efetuado com a data base do sistema."
	Local aCpos   := {}
	Local aCampos := {}
	Local cMsg    := "" 
	Local nI := 0
	
	Private aRotina     := {}
	Private cMarca      := ""
	Private cCadastro   := OemToAnsi("Cria็ใo de Tํtulos")
	Private cPerg       := "TKMARK01"
	Private nTotal      := 0
	Private cArquivo    := ""
		
	//+----------------------------------------------------------------------------
	//| Monta tela de interacao com usuario
	//+----------------------------------------------------------------------------
	aAdd(aSay,cDesc1)
	aAdd(aSay,cDesc2)
	aAdd(aSay,cDesc3)
	
	aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
	aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})
	
	//FormBatch(<cTitulo>,<aMensagem>,<aBotoes>,<bValid>,nAltura,nLargura)
	FormBatch(cCadastro,aSay,aButton)
	
	//+----------------------------------------------------------------------------
	//| Se cancelar sair
	//+----------------------------------------------------------------------------
	If nOpcao <> 1
	   Return Nil
	Endif
		
	//+----------------------------------------------------------------------------
	//| Cria as perguntas em SX1
	//+----------------------------------------------------------------------------
	AjustaSx1(cPerg)
	Pergunte(cPerg,.T.)
	
	//+----------------------------------------------------------------------------
	//| Atribui as variaveis de funcionalidades
	//+----------------------------------------------------------------------------
	aAdd( aRotina ,{"Pesquisar" ,"AxPesqui()"   ,0,1})
	aAdd( aRotina ,{"Criar" 	,"u_TKCriarTit()",0,3})
	aAdd( aRotina ,{"Legenda"   ,"u_TKLegenda()"  ,0,5})
	aAdd( aRotina ,{"Alterar"   ,"u_TKAltera()",0,4})
	aAdd( aRotina ,{"Excluir"   ,"u_TKDeleta()",0,6})
	             
	//+----------------------------------------------------------------------------
	//| Atribui as variaveis os campos que aparecerao no mBrowse()
	//+----------------------------------------------------------------------------
	aCpos := {"Z2_OK","Z2_PREFIXO","Z2_NUM","Z2_PARCELA","Z2_TIPO","Z2_NATUREZ","Z2_CLIENTE","Z2_LOJA","Z2_NOMCLI","Z2_EMISSAO","Z2_VENCTO","Z2_VENCREA","Z2_VALOR","Z2_XCTMDW","Z2_XPIMDW","Z2_XPARCEL","Z2_CCUSTO"}
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len(aCpos)
	   dbSeek(aCpos[nI])
	   aAdd(aCampos,{X3_CAMPO,"",Iif(nI==1,"",Trim(X3_TITULO)),Trim(X3_PICTURE)})
	Next
	
	//+----------------------------------------------------------------------------
	//| Monta o filtro especifico para MarkBrow()
	//+----------------------------------------------------------------------------
	dbSelectArea("SZ2")
	aArea := GetArea()
	cKey  := IndexKey()
	cFiltro := "Z2_PREFIXO 			>= '" + MV_PAR01 + "' .And. "
	cFiltro += "Z2_PREFIXO 			<= '" + MV_PAR02 + "' .And. "
	cFiltro += "Z2_PARCELA 			>= '" + MV_PAR03 + "' .And. "
	cFiltro += "Z2_PARCELA 			<= '" + MV_PAR04 + "' .And. "
	cFiltro += "Z2_NATUREZ 			>= '" + MV_PAR05 + "' .And. "
	cFiltro += "Z2_NATUREZ 			<= '" + MV_PAR06 + "' .And. "
	cFiltro += "Z2_CLIENTE 			>= '" + MV_PAR07 + "' .And. "
	cFiltro += "Z2_LOJA 			>= '" + MV_PAR08 + "' .And. "
	cFiltro += "Z2_CLIENTE 			<= '" + MV_PAR09 + "' .And. "
	cFiltro += "Z2_LOJA 			<= '" + MV_PAR10 + "' .And. "
	cFiltro += "Dtos(Z2_EMISSAO) 	>= '" + Dtos(mv_par11) + "' .And. "
	cFiltro += "Dtos(Z2_EMISSAO) 	<= '" + Dtos(mv_par12) + "' .And. "
	cFiltro += "Dtos(Z2_VENCTO) 	>= '" + Dtos(mv_par13) + "' .And. "
	cFiltro += "Dtos(Z2_VENCTO) 	<= '" + Dtos(mv_par14) + "' "
	
	//Mostrar todos? 1=Sim;2=Nใo
	//Z2_STATUS = 0 -> Pendente
	//Z2_STATUS = 1 -> Criado SE1
	If mv_par15 == 2
	   cFiltro += ".And. Z2_STATUS <> '1' "
	Endif
	
	cArq := CriaTrab( Nil, .F. )
	IndRegua("SZ2",cArq,cKey,,cFiltro)
	nIndex := RetIndex("SZ2")
	nIndex := nIndex + 1
	dbSelectArea("SZ2")
	#IFNDEF TOP
	   dbSetIndex(cArq+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex)
	dbGoTop()
	
	//+----------------------------------------------------------------------------
	//| Apresenta o MarkBrowse para o usuario
	//+----------------------------------------------------------------------------
	cMarca := GetMark()
	MarkBrow("SZ2","Z2_OK","SZ2->Z2_STATUS",aCampos,,cMarca,,,,,"u_TKMarcaBox()")
	
	//+----------------------------------------------------------------------------
	//| Desfaz o indice e filtro temporario
	//+----------------------------------------------------------------------------
	dbSelectArea("SZ2")
	RetIndex("SZ2")
	Set Filter To
	cArq += OrdBagExt()
	FErase( cArq ) 
	
	RestArea( aArea ) 

Return Nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TKAltera บAutor  ณAlexandre Takaki    บ Data ณ 13/06/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COSTA NORTE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TKAltera()

	Local _oDlg  		:= Nil	
	Local dDataVenc   	:= SZ2->Z2_VENCTO //Ctod(Space(8))
	Local nValor 		:= SZ2->Z2_VALOR
	Local cVendedor		:= SZ2->Z2_VEND1
	Local nComissao		:= SZ2->Z2_COMIS1
	Local cHistorico	:= SZ2->Z2_HIST
	Local aRadio   		:= {}
	Local oRadio   		:= NIL
	Local nRadio   		:= 0
	Local cParcelas		:= Space(50)

	aAdd(aRadio,"Nใo")
	aAdd(aRadio,"Sim")
		
	//+----------------------------------------------------------------------------
	//| Defini็ใo da janela e seus conte๚dos
	//+----------------------------------------------------------------------------
	DEFINE MSDIALOG _oDlg TITLE "Alterar os Valores" FROM 0,0 TO 275,552 OF _oDlg PIXEL
	
	@ 06,06 TO 130,271 LABEL "Campos editแveis" OF _oDlg PIXEL
	
	@ 15, 15 SAY "Data Vencimento"		SIZE 70,8 PIXEL OF _oDlg
	@ 25, 15 MSGET dDataVenc 			PICTURE "99/99/99" SIZE 76,10 PIXEL OF _oDlg
	
	@ 15,100 SAY "Valor"  				SIZE 45,8 PIXEL OF _oDlg
	@ 25,100 MSGET nValor 				PICTURE "@E 99,999,999.99" SIZE 80,10 PIXEL OF _oDlg
	
	@ 40, 15 SAY "Vendedor" 			SIZE 45,8 PIXEL OF _oDlg
	@ 50, 15 MSGET cVendedor	 		PICTURE "@!" F3 "SA3" SIZE 80,10 PIXEL OF _oDlg
		
	@ 40,100 SAY "%Comissใo" 			SIZE 45,8 PIXEL OF _oDlg
	@ 50,100 MSGET nComissao			PICTURE "@E 999.99" SIZE 80,10 PIXEL OF _oDlg
	
	@ 65, 15 SAY "Historico" 			SIZE 45,8 PIXEL OF _oDlg
	@ 75, 15 MSGET cHistorico 			PICTURE "@!" SIZE 255,10 PIXEL OF _oDlg
	
	@ 90, 15 SAY "Replicar Parcelas - Exce็ใo Hist๓rico"	SIZE 150,8 PIXEL OF _oDlg
	@ 100,15 RADIO oRadio VAR nRadio ITEMS aRadio[1],aRadio[2] SIZE 060,009 PIXEL OF _oDlg ON CHANGE Detail(_oDlg,nRadio)
	
	@ 150, 15 SAY "Parcelas - separados por ponto e vํrgula( ; )"	SIZE 150,8 PIXEL OF _oDlg
	@ 160, 15 MSGET cParcelas 			PICTURE "@!" SIZE 255,10 PIXEL OF _oDlg
			
	//+----------------------------------------------------------------------------
	//| Botoes da MSDialog
	//+----------------------------------------------------------------------------
	@ 15,225 BUTTON "&Ok"       		SIZE 36,16 PIXEL ACTION {|| Processar(SZ2->Z2_PREFIXO,SZ2->Z2_NUM,SZ2->Z2_PARCELA,SZ2->Z2_TIPO,dDataVenc,nValor,cVendedor,nComissao,cHistorico,nRadio,cParcelas,SZ2->Z2_STATUS,SZ2->Z2_CCUSTO),_oDlg:End()}
	@ 40,225 BUTTON "&Cancelar" 		SIZE 36,16 PIXEL ACTION _oDlg:End()
		
	ACTIVATE MSDIALOG _oDlg CENTER

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTKMarcaBoxบAutor  ณAlexandre Takaki    บ Data ณ 13/06/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COSTA NORTE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TKMarcaBox()

	If IsMark("Z2_OK",cMarca )
	   RecLock("SZ2",.F.)
	   SZ2->Z2_OK := Space(2)
	   MsUnLock()
	Else
	   If Empty(SZ2->Z2_STATUS)
	      RecLock("SZ2",.F.)
	      SZ2->Z2_OK := cMarca
	      MsUnLock()
	   Endif
	Endif
	
Return .T. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTKLegenda บAutor  ณAlexandre Takaki    บ Data ณ 13/06/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ COSTA NORTE                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TKLegenda()

	Local aCor := {}
	
	aAdd(aCor,{"BR_VERDE"   ,"Tํtulo nใo Criado na SE1"})
	aAdd(aCor,{"BR_VERMELHO","Tํtulo Criado na SE1"    })
	
	BrwLegenda(cCadastro,OemToAnsi("Registros"),aCor)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ          	
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณAjustaSX1 ณ Autor ณ Alexandre Takaki	    ณ Data ณ13/06/2018ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria pergunta para o grupo			                      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ COSTA NORTE                                                ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AjustaSX1(cPerg)
	
	Local _sAlias := Alias()
	Local aRegs   := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	cPerg := PADR(cPerg,10)
	
	AADD(aRegs,{cPerg,"01","Prefixo De ?"		,"","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Prefixo At้ ?"		,"","","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	AADD(aRegs,{cPerg,"03","Parcela De ?"		,"","","mv_ch3","C",02,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"04","Parcela At้ ?"		,"","","mv_ch4","C",02,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	AADD(aRegs,{cPerg,"05","Natureza De ?"		,"","","mv_ch5","C",10,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})
	AADD(aRegs,{cPerg,"06","Natureza Ate ?"		,"","","mv_ch6","C",10,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SED","","",""})
	
	AADD(aRegs,{cPerg,"07","Cliente De ?"		,"","","mv_ch7","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""})
	AADD(aRegs,{cPerg,"08","Loja De ?"			,"","","mv_ch8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	AADD(aRegs,{cPerg,"09","Cliente Ate ?"		,"","","mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","",""})
	AADD(aRegs,{cPerg,"10","Loja Ate ?"			,"","","mv_chA","C",02,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
	
	AADD(aRegs,{cPerg,"11","Data Emissใo De ?"	,"","","mv_chB","D",08,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"12","Data Emissใo Ate ?"	,"","","mv_chC","D",08,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	AADD(aRegs,{cPerg,"13","Data Vencto De ?"	,"","","mv_chD","D",08,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"14","Data Vencto Ate ?"	,"","","mv_chE","D",08,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	AADD(aRegs,{cPerg,"15","Vis. Tit. Criados ?","","","mv_chF","C",01,0,0,"C","","MV_PAR15","Sim","","","","","Nใo","","","","","","","","","","","","","","","","","","","","","",""})
		
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	dbSelectArea(_sAlias)
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Processar	  บAutor  ณ Alexandre Takaki   บ Data ณ 13/05/2018  บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ ROTINA PARA ALTERAR OS DADOS DA TABELA SZ2.						บฑฑ
ฑฑบ          ณ 												      				บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TV COSTA NORTE	  		                                      	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Processar(cPrefixo,cNumero,cParcela,cTipo,dDataVenc,nValor,cVendedor,nComissao,cHistorico,nRadio,cParcelas,cStatus,cCentroCusto)

	Local cUpdate	:= ""
	Local aParc		:= {}
	Local nX		:= 0
	Local nErro		:= 0
	
	If cStatus <> "1"
	
		If !Empty(cParcelas)
			aParc := STRTOKARR(cParcelas,";")
		EndIf
		
		If nRadio == 1 .Or. nRadio == 0
			
			cUpdate := " UPDATE " + RetSQLName("SZ2")
			cUpdate += " SET	Z2_VENCTO 		= '" + DTOS(dDataVenc) + "', "
			cUpdate += "  		Z2_VENCREA 		= '" + DTOS(DiaUtil(dDataVenc,+1)) + "', "   
			cUpdate += "  		Z2_VALOR 		= '" + cValToChar(nValor) + "', "   
			cUpdate += "  		Z2_VLCRUZ 		= '" + cValToChar(nValor) + "', "   
			cUpdate += "  		Z2_VEND1 		= '" + cVendedor + "', "   
			cUpdate += "  		Z2_COMIS1 		= '" + cValToChar(nComissao) + "', "   
			cUpdate += "  		Z2_HIST 		= '" + Alltrim(cHistorico) + "' "   
			cUpdate += " WHERE 	Z2_FILIAL 		= '" + xFilial("SZ2") + "' "   
			cUpdate += " AND 	Z2_PREFIXO 		= '" + Alltrim(cPrefixo) + "' "   
			cUpdate += " AND 	Z2_NUM	 		= '" + Alltrim(cNumero) + "' "   
			cUpdate += " AND 	Z2_PARCELA 		= '" + Alltrim(cParcela) + "' "   
			cUpdate += " AND 	Z2_TIPO 		= '" + Alltrim(cTipo) + "' "   
			cUpdate += " AND 	D_E_L_E_T_ 		= '' "   
			nErro := TcSqlExec( cUpdate )
			If nErro <> 0
				Alert("Erro no Update")
			Else
				Alert("Registro alterado com Sucesso!")
			EndIf
		
		Else
		
			For nX := 1 To Len(aParc)
			
				If nX > 1
					cDtVencto 	:= DTOS( MonthSum( dDataVenc,0 ) )
				Else
					cDtVencto 	:= DTOS(dDataVenc)
				EndIf
				
				/* comentado por takaki no dia 21/06/2018
				cUpdate := " UPDATE " + RetSQLName("SZ2")
				cUpdate += " SET	Z2_VENCTO 		= '" + cDtVencto + "',"
				cUpdate += "  		Z2_VENCREA 		= '" + DTOS(DiaUtil(STOD(cDtVencto),+1)) + "',"   
				cUpdate += "  		Z2_VALOR 		= '" + cValToChar(nValor) + "', "   
				cUpdate += "  		Z2_VLCRUZ 		= '" + cValToChar(nValor) + "', "   
				cUpdate += "  		Z2_VEND1 		= '" + cVendedor + "',"   
				cUpdate += "  		Z2_COMIS1 		= '" + cValToChar(nComissao) + "' " 
				cUpdate += " WHERE 	Z2_FILIAL 		= '" + xFilial("SZ2") + "'"   
				cUpdate += " AND 	Z2_PREFIXO 		= '" + Alltrim(cPrefixo) + "'"   
				cUpdate += " AND 	Z2_NUM	 		= '" + Alltrim(cNumero) + "'"   
				cUpdate += " AND 	Z2_PARCELA 		= '" + Alltrim(aParc[nX]) + "'"   
				cUpdate += " AND 	Z2_TIPO 		= '" + Alltrim(cTipo) + "'"
				cUpdate += " AND 	D_E_L_E_T_ 		= '' "   
				TcSqlExec( cUpdate )
				*/
				
				cUpdate := " UPDATE " + RetSQLName("SZ2")
				cUpdate += " SET	Z2_VALOR 		= '" + cValToChar(nValor) + "', "   
				cUpdate += "  		Z2_VLCRUZ 		= '" + cValToChar(nValor) + "', "   
				cUpdate += "  		Z2_VEND1 		= '" + cVendedor + "',"   
				cUpdate += "  		Z2_COMIS1 		= '" + cValToChar(nComissao) + "' " 
				cUpdate += " WHERE 	Z2_FILIAL 		= '" + xFilial("SZ2") + "'"   
				cUpdate += " AND 	Z2_PREFIXO 		= '" + Alltrim(cPrefixo) + "'"   
				cUpdate += " AND 	Z2_NUM	 		= '" + Alltrim(cNumero) + "'"   
				cUpdate += " AND 	Z2_PARCELA 		= '" + Alltrim(aParc[nX]) + "'"   
				cUpdate += " AND 	Z2_TIPO 		= '" + Alltrim(cTipo) + "'"
				cUpdate += " AND 	D_E_L_E_T_ 		= '' "   
				TcSqlExec( cUpdate )
				
				If nX <> Len(aParc)
					dDataVenc := STOD(cDtVencto)
				EndIf
				
			Next nX
			
			Alert("Registro alterado com Sucesso!")
			
		EndIf
		
	Else
	
		Alert("Nใo ้ possํvel alterar um registro jแ criado na SE1!")
	
	EndIf	
		
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ DiaUtil  ณ Autor ณ Alexandre Takaki      ณ Data ณ08/03/2018ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ ROTINA PARA ENVIAR EMAIL PARA AVISO E COBRANวA - SE1.      ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ TAKAKI			                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TKCriarTit	  บAutor  ณ Alexandre Takaki   บ Data ณ 05/08/2018  บฑฑ
ฑฑฬออออออออออุออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNCAO PARA APROVAR UM REGISTRO OU VARIOS E CRIAR UM TITULO.		บฑฑ
ฑฑบ          ณ 												      				บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TV COSTA NORTE	  		                                      	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TKCriarTit()

	Local aDados		:= {}
	Local nX			:= 0
	Local aTitulo		:= {}
	
	//ALERT("APROVANDO E CRIANDO UM TITULO NO PROTHEUS")
	
	SZ2->( dbGotop() )
	Do While SZ2->( !Eof() )
		If SZ2->Z2_OK == cMarca
			aAdd(aDados, {	SZ2->Z2_FILIAL,; 
							SZ2->Z2_PREFIXO,;
							SZ2->Z2_NUM,;
							SZ2->Z2_PARCELA,;
							SZ2->Z2_TIPO,;
							SZ2->Z2_NATUREZ,;
							SZ2->Z2_CLIENTE,;
							SZ2->Z2_LOJA,;
							SZ2->Z2_EMISSAO,;
							SZ2->Z2_VENCTO,;
							SZ2->Z2_VENCREA,;
							SZ2->Z2_VALOR,;
							SZ2->Z2_VEND1,;
							SZ2->Z2_COMIS1,;
							SZ2->Z2_XCTMDW,;
							SZ2->Z2_XPIMDW,;
							SZ2->(Recno()),;
							SZ2->Z2_HIST,;
							SZ2->Z2_CCUSTO,;
							SZ2->Z2_VEND2,;
							SZ2->Z2_VEND3,;
							SZ2->Z2_COMIS2,;
							SZ2->Z2_COMIS3;
							} )
		EndIf
		SZ2->( dbSkip() )
	EndDo
	
	If Len(aDados) > 0
		
		For nX := 1 To Len(aDados)
			
			u_FCNGERARTI(	aDados[nX][2],;  //E1_PREFIXO
							aDados[nX][3],;	 //E1_NUM
							aDados[nX][5],;  //E1_TIPO
							aDados[nX][6],;  //E1_NATUREZ
							aDados[nX][7],;  //E1_CLIENTE
							aDados[nX][8],;  //E1_LOJA
							aDados[nX][9],;  //E1_EMISSAO
							aDados[nX][10],; //E1_VENCTO
							aDados[nX][11],; //E1_VENCREA
							aDados[nX][15],; //E1_XCTMDW
							aDados[nX][16],; //E1_XPIMDW
							aDados[nX][12],; //E1_VALOR
							aDados[nX][17],; //RECNOSZ2
							aDados[nX][18],; //E1_XHIST
							aDados[nX][19],; //E1_CCUSTO
							aDados[nX][4],;	 //E1_PARCELA
							aDados[nX][13],; //E1_VEND1
						    aDados[nX][20],; //E1_VEND2
						    aDados[nX][21],; //E1_VEND3
						    aDados[nX][14],; //E1_COMIS1
						    aDados[nX][22],; //E1_COMIS2
						    aDados[nX][23]) //E1_COMIS3
						  						
		Next nX

	Else
	
		MsgAlert("Por favor, selecione pelo menos 1 registro.","Aten็ใo")

	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetail    บAutor  ณAlexandre Takaki    บ Data ณ 12/05/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que expande ou nao o msdialog.					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TV COSTA NORTE                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Detail(oDlg,nRadio)

	oDlg:CoorsUpdate()
	If nRadio == 2
		oDlg:Move(oDlg:nTop,oDlg:nLeft,552,400)
	Else
		oDlg:Move(oDlg:nTop,oDlg:nLeft,552,300)
	Endif
	
Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetail    บAutor  ณWillian Carlos    บ Data ณ   22/09/2018  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que exclui titulos selecionados.					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TV COSTA NORTE                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TKDeleta()

	Local nX			:= 0
	Local aExcluir		:= {}
	Local cUpdate		:= ""

	SZ2->( dbGotop() )
	Do While SZ2->( !Eof() )
		//If SZ2->Z2_OK == cMarca
		If !Empty(SZ2->Z2_OK)
			aAdd(aExcluir, { SZ2->(Recno()) })
		EndIf
		SZ2->( dbSkip() )
	EndDo
	
	If Len(aExcluir) > 0
		
		For nX := 1 To Len(aExcluir)
			
			cUpdate := " UPDATE " + RetSqlName("SZ2") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE R_E_C_N_O_ = '" + cValToChar(aExcluir[nX][1]) + "' "
			nExecLog := TcSqlExec( cUpdate )
							
		Next nX

	Else
	
		MsgAlert("Por favor, selecione pelo menos 1 registro.","Aten็ใo")

	EndIf

Return 