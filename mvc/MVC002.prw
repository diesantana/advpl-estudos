#include 'totvs.ch'
#include 'fwmvcdef.ch'

/*/{Protheus.doc} MVC002
Tela MVC Modelo 3
@type function
@author Diego Santana
@since 01/06/2026
/*/
User Function MVC002()
	// Definindo o Browse
	Local oBrowse := FwMBrowse():New()

	oBrowse:setAlias('SZ0') // Alias da tabela pai
	oBrowse:setDescription('Carteira de Clientes')
	oBrowse:Activate()
Return

/*/{Protheus.doc} ModelDef
    Define as regras de negócio e o modelo de dados
    @type Function
    @author Diego Santana
    @since 01/06/2026
/*/
Static Function ModelDef()
	// 1. Carrega as duas estruturas (1 = Model)
	Local oStruPai   := FWFormStruct(1, 'SZ0') // SZ0 - Carteira de clientes
	Local oStruFilho := FWFormStruct(1, 'SZ1') // SZ1 itens da carteira
	Local aRelation := {} // Relacionamento entre as tabelas

	// O ID do model deve ser um nome único no RPO.
	// uma recomendação é definir o nome do PRW seguido do "M"
	// Ex: MV001.prw ID DO MODEL = MVC001M
	Local oModel     := MPFormModel():New('MVC002M')

	// 2. Adiciona a estrutura pai (Master) ao modelo
	oModel:AddFields('SZ0MASTER', /*cOwner*/, oStruPai)

	// 3. Adiciona o Grid do Filho (Detail), indicando quem é o seu "Owner" (Pai)
	oModel:AddGrid('SZ1DETAIL', 'SZ0MASTER', oStruFilho)

	// 4. Define o relacionamento
	aAdd(aRelation, {'Z1_FILIAL', 'xFilial("SZ1")'})
	// Lemos: O campo Z1_CODIGO do filho recebe o valor do Z0_CODIGO do Pai
	aAdd(aRelation, {'Z1_CODIGO', 'Z0_CODIGO'})
	// O terceiro parâmetro define apenas o índice de ordenação dos itens na grid.
	oModel:SetRelation('SZ1DETAIL', aRelation, SZ1->(IndexKey(1)))

	// Descrição do modelo de dados
	oModel:SetDescription('Carteira de Clientes')
	// Impede a duplicidade de itens por código do cliente + loja.
	oModel:GetModel('SZ1DETAIL'):SetUniqueLine({"Z1_CODCLI", "Z1_LOJACLI"})
	oModel:GetModel('SZ1DETAIL'):SetOptional(.T.) // Permite criar registro sem os itens.
Return oModel


/*/{Protheus.doc} ViewDef
    Define a exibição do modelo de dados
    @type Function
    @author Diego Santana
    @since 01/06/2026
/*/
Static Function ViewDef()
	// FWLoadModel() recebe o nome do fonte que vai carregar o modelo de dados.
	Local oModel     := FWLoadModel('MVC002')
	// 1. Carrega as estruturas visuais (2 = View)
	Local oStruPai   := FWFormStruct(2, 'SZ0')
	Local oStruFilho := FWFormStruct(2, 'SZ1')
	Local oView      := FWFormView():New()

	// Associa o modelo de dados a view.
	oView:SetModel(oModel)

	// 2. Cria as interfaces amarrando com os IDs do Model
	// Uma boa prátive é definir o nome do id como "VIEW_alas"
	// Ex: VIEW_ZA1 e VIEW_ZA2
	oView:AddField('VIEW_SZ0', oStruPai, 'SZ0MASTER')
	oView:AddGrid('VIEW_SZ1', oStruFilho, 'SZ1DETAIL')

	// 3. Divide a tela em duas caixas horizontais (ex: 30% e 70%)
	oView:CreateHorizontalBox('CABEC', 30)
	oView:CreateHorizontalBox('ITENS', 70)

	// Insere um componente visual de pesquisa na view
	oView:SetViewProperty('VIEW_SZ1', 'GRIDSEEK', {.T.})

    // Transforma o Grid dizendo que 60% do espaço 
    // dele será usado para editar a linha em formato de formulário
    // oView:SetViewProperty('VIEW_SZ1', "ENABLEDGRIDDETAIL", { 60 })    

	// 4. Coloca cada componente visual dentro da sua respectiva caixa
	oView:SetOwnerView('VIEW_SZ0', 'CABEC')
	oView:SetOwnerView('VIEW_SZ1', 'ITENS')

	// Desativa o campo Z1_CODIGO
	oStruFilho:RemoveField('Z1_CODIGO')

Return oView

/*/{Protheus.doc} MenuDef
Define as operações da tela
@type function
@author Diego
@since 01/06/2026
/*/
Static Function MenuDef()

	Local aRotina := {}
	// Adiciona as opções de menu (3 = Incluir, 4 = Alterar, 5 = Excluir)
	ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.MVC002' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.MVC002' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.MVC002' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.MVC002' OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'     ACTION 'VIEWDEF.MVC002' OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE 'Copiar'       ACTION 'VIEWDEF.MVC002' OPERATION 9 ACCESS 0

Return aRotina
