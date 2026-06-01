#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} nomeFunction
Tela em MVC Modelo 01
@type function
@author Diego Santana
@since 30/05/2026
@version 1.0
/*/
User Function MVC001()
	// Instancia a classe do Browse
	Local oBrowse := FWMBrowse():New()
	// Define a tabela principal e o título da janela
	oBrowse:SetAlias('SZ0')
	oBrowse:SetDescription('Carteira de Clientes')

	oBrowse:Activate() // Ativa a exibição da tela
Return

/*/{Protheus.doc} MenuDef
Define as operações da tela
@type function
@author Diego
@since 30/05/2026
/*/
// Static Function MenuDef()
// 	Local aRotina := {}

// 	// Adiciona as opções de menu (3 = Incluir, 4 = Alterar, 5 = Excluir)
// 	ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.MVC001' OPERATION 2 ACCESS 0
// 	ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.MVC001' OPERATION 3 ACCESS 0
// 	ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.MVC001' OPERATION 4 ACCESS 0
// 	ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.MVC001' OPERATION 5 ACCESS 0
// 	ADD OPTION aRotina TITLE 'Imprimir'     ACTION 'VIEWDEF.MVC001' OPERATION 8 ACCESS 0
// 	ADD OPTION aRotina TITLE 'Copiar'       ACTION 'VIEWDEF.MVC001' OPERATION 9 ACCESS 0
// Return aRotina

Static Function MenuDef()
Return FWMVCMenu("MVC001")

/*/{Protheus.doc} ModelDef
Monta a estrutura de dados
@type function
@author Diego
@since 30/05/2026
/*/

Static Function ModelDef()
	// Lê a estrutura da tabela SZ0 no Dicionário de Dados (1 = Model)
	Local oStruSZ0 := FWFormStruct(1, 'SZ0')
	// Cria o Modelo | Nome: alias+MODEL
	Local oModel   := MPFormModel():New('SZ0MODEL')

	// Adiciona a estrutura ao modelo
	// O nome MASTER (SZ0MASTER) indica que é a tabela principal
	// O parâmetro cOwner indica qual é a tabela PAI na relação das tabelas.
	oModel:AddFields('SZ0MASTER', /*cOwner*/, oStruSZ0)

	// Define descrições para logs e WebServices
	oModel:SetDescription('Modelo de dados da Carteira de clientes')
	oModel:GetModel('SZ0MASTER'):SetDescription('Carteira de clientes')

	// Retorno obrigatório do objeto Model
Return oModel

/*/{Protheus.doc} ViewDef
Define a interface
@type function
@author Diego
@since 30/05/2026
/*/
Static Function ViewDef()
	// Carrega o modelo de dados criado na ModelDef do próprio fonte
	// Aqui passamos o nome do PRW
	Local oModel   := FWLoadModel('MVC001')
	// Lê a estrutura da tabela SZ0 para interface visual (2 = View)
	Local oStruSZ0 := FWFormStruct(2, 'SZ0')
	Local oView    := FWFormView():New()

	// Associa a View ao Model
	oView:SetModel(oModel)

	// Adiciona a estrutura de dados na interface
	// Parâmetros: 'ID_DA_VIEW', Estrutura Visual, 'ID_DO_COMPONENTE_NO_MODEL'
	// No 'ID_DA_VIEW' utiliza-se o nome VIEW_ALIAS
	// 'ID_DO_COMPONENTE_NO_MODEL' deve ser a tabela principal (MASTER)
	oView:AddField('VIEW_SZ0', oStruSZ0, 'SZ0MASTER')

	// Cria uma caixa visual que ocupará 100% da tela
	oView:CreateHorizontalBox('TELA', 100)

	// Associa os campos criados à caixa visual
	oView:SetOwnerView('VIEW_SZ0', 'TELA')

	// Retorno obrigatório do objeto View
Return oView
