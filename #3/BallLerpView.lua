-- if true then return end

--[[
    Script: Elevador de Bolas com Diferentes Métodos de Interpolação
    Localização: ServerScriptService
    Descrição:
        Este script controla 5 bolas (Workspace.Bola, Bola2, Bola3, Bola4, Bola5), onde cada bola representa
        um método de interpolação:
          1. Lerp Linear (Bola)
          2. Lerp Ease-In (Bola2)
          3. Lerp Ease-Out (Bola3)
          4. Lerp Ease-In-Out (Bola4)
          5. Approach (Bola5) – simulado com EasingStyle.Exponential
        Cada bola se move como um elevador: sobe do ponto inicial para 20 studs acima e desce de volta.
        Ao chegar no topo, a bola espera 3 segundos; ao chegar embaixo, espera 3 segundos; e repete o ciclo.
        Utiliza o TweenService para criar transições suaves com diferentes estilos de easing.
--]]

--------------------------------------------------------------------------------
-- Seção 1: Obtenção de Serviços e Referências das Bolas
--------------------------------------------------------------------------------
local TweenService = game:GetService("TweenService")
local Workspace = game.Workspace

-- Obtém as 5 bolas do Workspace (elas devem existir com esses nomes)
-- É NECESSÁRIO CRIAR AS BOLAS NO WORKSPACE COM OS NOMES ABAIXO!!!

local ballLinear    = Workspace:WaitForChild("Bola")      -- Lerp Linear
local ballEaseIn    = Workspace:WaitForChild("Bola2")     -- Lerp Ease-In
local ballEaseOut   = Workspace:WaitForChild("Bola3")     -- Lerp Ease-Out
local ballEaseInOut = Workspace:WaitForChild("Bola4")     -- Lerp Ease-In-Out
local ballApproach  = Workspace:WaitForChild("Bola5")     -- Approach (Exponential)

--------------------------------------------------------------------------------
-- Seção 2: Configurações Comuns para o Movimento (Elevador)
--------------------------------------------------------------------------------
-- Para cada bola, definimos duas posições:
-- bottomPos: a posição inicial da bola (ponto de baixo).
-- topPos: 20 studs acima da posição inicial (ponto de cima).
local moveOffset = 20  -- Distância vertical para o movimento

--------------------------------------------------------------------------------
-- Seção 3: Função de Animação do Elevador
--------------------------------------------------------------------------------
-- Função que anima uma bola para subir e descer continuamente.
-- Ela recebe o objeto 'part' (a bola) e dois TweenInfos: um para subir e outro para descer.
local function animateElevator(part, tweenInfoUp, tweenInfoDown)
	-- Garante que a bola esteja ancorada para que a física não interfira
	part.Anchored = true

	-- Captura a posição inicial da bola e define a posição de topo como 20 studs acima.
	local bottomPos = part.CFrame
	local topPos = bottomPos * CFrame.new(0, moveOffset, 0)

	-- Função para mover a bola para cima (subida)
	local function moveUp()
		local tweenUp = TweenService:Create(part, tweenInfoUp, {CFrame = topPos})
		tweenUp:Play()
		tweenUp.Completed:Wait()  -- Aguarda a conclusão da subida
		wait(3)  -- Pausa 3 segundos no topo
	end

	-- Função para mover a bola para baixo (descida)
	local function moveDown()
		local tweenDown = TweenService:Create(part, tweenInfoDown, {CFrame = bottomPos})
		tweenDown:Play()
		tweenDown.Completed:Wait()  -- Aguarda a conclusão da descida
		wait(3)  -- Pausa 3 segundos na base
	end

	-- Loop infinito: repete continuamente a sequência de subir e descer
	while true do
		moveUp()
		moveDown()
	end
end

--------------------------------------------------------------------------------
-- Seção 4: Definição dos TweenInfos para Cada Método de Interpolação
--------------------------------------------------------------------------------
local duration = 2  -- Duração de 2 segundos para cada movimento (subida e descida)

-- Lerp Linear: Movimento constante com EasingStyle.Linear
local tweenInfoLinearUp = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local tweenInfoLinearDown = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

-- Lerp Ease-In: Movimento que começa devagar e acelera com EasingStyle.Quad In
local tweenInfoEaseInUp = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local tweenInfoEaseInDown = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

-- Lerp Ease-Out: Movimento que começa rápido e desacelera com EasingStyle.Quad Out
local tweenInfoEaseOutUp = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoEaseOutDown = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Lerp Ease-In-Out: Movimento que começa devagar, acelera no meio e desacelera no final, com EasingStyle.Quad InOut
local tweenInfoEaseInOutUp = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local tweenInfoEaseInOutDown = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

-- Approach: Movimento exponencial simulado com EasingStyle.Exponential Out
local tweenInfoApproachUp = TweenInfo.new(duration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local tweenInfoApproachDown = TweenInfo.new(duration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

--------------------------------------------------------------------------------
-- Seção 5: Iniciando as Animações para Cada Bola
--------------------------------------------------------------------------------
-- Usamos spawn para iniciar cada animação em uma thread separada, permitindo que todas as bolas se movam simultaneamente.
spawn(function()
	animateElevator(ballLinear, tweenInfoLinearUp, tweenInfoLinearDown)
end)

spawn(function()
	animateElevator(ballEaseIn, tweenInfoEaseInUp, tweenInfoEaseInDown)
end)

spawn(function()
	animateElevator(ballEaseOut, tweenInfoEaseOutUp, tweenInfoEaseOutDown)
end)

spawn(function()
	animateElevator(ballEaseInOut, tweenInfoEaseInOutUp, tweenInfoEaseInOutDown)
end)

spawn(function()
	animateElevator(ballApproach, tweenInfoApproachUp, tweenInfoApproachDown)
end)

-- Mensagem de confirmação para o console
print("Elevador de bolas animado com sucesso!")