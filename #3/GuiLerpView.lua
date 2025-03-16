-- if true then return end

--[[
    Script: Visualizador de Interpolação (Pausa antes do Reset)
    Localização: StarterGui > ScreenGui > LocalScript
    Descrição:
        Este script demonstra diferentes métodos de interpolação de movimento:
          - Lerp Linear (movimento constante)
          - Lerp Ease-In (movimento que começa devagar e acelera)
          - Lerp Ease-Out (movimento que começa rápido e desacelera)
          - Approach (movimento que ajusta o valor de forma exponencial)
          - Lerp Ease-In-Out (começa devagar, acelera no meio e desacelera no final)
        Cada método é representado por um "ponto" que se move horizontalmente do lado esquerdo
        para o lado direito da tela. Após os pontos atingirem o destino, eles permanecem parados por 1 segundo,
        e então todas as posições são resetadas instantaneamente para o início.
        A interface utiliza um fundo que ocupa toda a tela com cantos arredondados e textos explicativos.
--]]

--------------------------------------------------------------------------------
-- Seção 1: Obtenção de Serviços e do Jogador
--------------------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer  -- Obtém o jogador local para acesso ao PlayerGui

--------------------------------------------------------------------------------
-- Seção 2: Criação da Interface Gráfica (Fundo Ocupando a Tela Inteira)
--------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")  -- Adiciona o ScreenGui ao PlayerGui

-- Cria um Frame de fundo que ocupa toda a tela
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)            -- 100% da largura e altura da tela
background.Position = UDim2.new(0, 0, 0, 0)        -- Inicia no topo à esquerda (0,0)
background.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Fundo cinza escuro para reduzir distrações
background.BorderSizePixel = 0                     -- Remove bordas para um visual limpo
background.Parent = screenGui                      -- Adiciona o fundo ao ScreenGui

-- Adiciona um UI Corner para deixar os cantos do fundo arredondados
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.05, 0)          -- Define um raio de 5% do tamanho do fundo
uiCorner.Parent = background

--------------------------------------------------------------------------------
-- Seção 3: Criação dos Textos Explicativos
--------------------------------------------------------------------------------
-- Função para criar um TextLabel com configurações padrão
local function createLabel(text, position, color, size, parent)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 300, 0, size)         -- Largura fixa de 300 pixels, altura definida por 'size'
	label.Position = position                      -- Posição do label
	label.BackgroundTransparency = 1               -- Fundo totalmente transparente
	label.Text = text                              -- Texto a ser exibido
	label.TextColor3 = color                       -- Cor do texto
	label.TextScaled = true                        -- Ajusta o texto automaticamente conforme o label
	label.Font = Enum.Font.SourceSansBold          -- Fonte em negrito para boa legibilidade
	label.Parent = parent                          -- Define o pai para organização
end

-- Cria um container para os textos dentro do fundo
local textContainer = Instance.new("Frame")
textContainer.Size = UDim2.new(1, 0, 1, 0)         -- Ocupa todo o fundo
textContainer.BackgroundTransparency = 1          -- Fundo transparente
textContainer.Parent = background

-- Define os títulos e descrições para cada método de interpolação.
-- Cada entrada: {Título, Descrição, Cor do Título, Posição Vertical (em escala)}
local titles = {
	{ "Lerp Linear (Vermelho)", "(Movimento constante, sem aceleração ou desaceleração)", Color3.fromRGB(255, 50, 50), 0.1 },
	{ "Lerp Ease-In (Verde)", "(Começa devagar e acelera até o final)", Color3.fromRGB(50, 255, 50), 0.3 },
	{ "Lerp Ease-Out (Azul)", "(Começa rápido e desacelera antes de chegar no destino)", Color3.fromRGB(50, 50, 255), 0.5 },
	{ "Approach (Amarelo)", "(Movimento contínuo, diminuindo velocidade ao se aproximar do alvo)", Color3.fromRGB(255, 255, 50), 0.7 },
	{ "Lerp Ease-In-Out (Laranja)", "(Começa devagar, acelera no meio e desacelera no final)", Color3.fromRGB(255, 165, 0), 0.9 }
}

-- Cria os labels para cada método, posicionando os títulos e descrições
for _, data in ipairs(titles) do
	createLabel(data[1], UDim2.new(0.05, 0, data[4], 0), data[3], 30, textContainer)  -- Título
	createLabel(data[2], UDim2.new(0.05, 0, data[4] + 0.05, 0), Color3.fromRGB(255, 255, 255), 20, textContainer)  -- Descrição logo abaixo
end

--------------------------------------------------------------------------------
-- Seção 4: Criação dos Objetos Visuais (Pontos)
--------------------------------------------------------------------------------
-- Função para criar um "dot" que representa cada método de interpolação.
local function createDot(color, position)
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 20, 0, 20)             -- Tamanho de 20x20 pixels
	dot.Position = position                      -- Posição inicial do ponto
	dot.BackgroundColor3 = color                 -- Define a cor do ponto
	dot.BorderSizePixel = 0                      -- Remove a borda para um visual limpo
	dot.Parent = background                      -- Adiciona o ponto ao fundo

	-- Adiciona UI Corner para deixar o ponto redondo (círculo)
	local dotCorner = Instance.new("UICorner")
	dotCorner.CornerRadius = UDim.new(1, 0)        -- Totalmente arredondado
	dotCorner.Parent = dot

	return dot
end

-- Cria os pontos para cada método de interpolação e os posiciona de forma que fiquem abaixo dos textos
local lerpLinearDot   = createDot(Color3.fromRGB(255, 50, 50), UDim2.new(0.05, 0, 0.2, 0))
local lerpEaseInDot   = createDot(Color3.fromRGB(50, 255, 50), UDim2.new(0.05, 0, 0.4, 0))
local lerpEaseOutDot  = createDot(Color3.fromRGB(50, 50, 255), UDim2.new(0.05, 0, 0.6, 0))
local approachDot     = createDot(Color3.fromRGB(255, 255, 50), UDim2.new(0.05, 0, 0.8, 0))
-- Para o Ease-In-Out, ajustamos a posição vertical para 0.9 para que não fique fora da tela
local easeInOutDot    = createDot(Color3.fromRGB(255, 165, 0), UDim2.new(0.05, 0, 0.9, 0))

--------------------------------------------------------------------------------
-- Seção 5: Configuração das Variáveis de Movimento
--------------------------------------------------------------------------------
-- Define a posição inicial e final na escala horizontal (de 0 a 1, relativo ao fundo)
local startX = 0.05   -- Representa 5% da largura do fundo (início)
local endX   = 0.95   -- Representa 95% da largura do fundo (final)

-- A variável 't' representa o progresso da interpolação:
-- 0 indica que os pontos estão no início; 1 indica que atingiram o destino.
local speed = 0.8     -- Velocidade com que 't' aumenta
local t = 0           -- Inicia com t = 0 (posição inicial)
local paused = false  -- Variável para pausar a animação durante o reset

--------------------------------------------------------------------------------
-- Seção 6: Loop de Animação com RunService.RenderStepped
--------------------------------------------------------------------------------
-- RenderStepped é utilizado para atualizar a animação a cada frame renderizado, garantindo suavidade.
-- DeltaTime é o tempo entre frames, permitindo que a animação seja independente da taxa de frames.
RunService.RenderStepped:Connect(function(deltaTime)
	if paused then
		return  -- Se a animação estiver pausada, não atualiza nada
	end

	-- Atualiza o progresso 't':
	-- t = t + deltaTime * speed aumenta 't' proporcionalmente ao tempo decorrido e à velocidade.
	t = t + deltaTime * speed
	--------------------------------------------------------------------------------
	-- CÁLCULO DAS POSIÇÕES DOS PONTOS:
	--------------------------------------------------------------------------------

	-- Lerp Linear:
	-- Fórmula: Posição = startX + (endX - startX) * t
	-- Isso faz com que, quando t = 0, a posição seja startX, e quando t = 1, a posição seja endX.
	lerpLinearDot.Position = UDim2.new(startX + (endX - startX) * t, 0, 0.2, 0)

	-- Lerp Ease-In:
	-- Utiliza t^2 para simular aceleração.
	-- Como t^2 é menor que t quando t é pequeno, o movimento inicia mais devagar e acelera conforme t aumenta.
	local easeInT = t * t
	lerpEaseInDot.Position = UDim2.new(startX + (endX - startX) * easeInT, 0, 0.4, 0)

	-- Lerp Ease-Out:
	-- Utiliza a fórmula 1 - (1-t)^2 para simular desaceleração.
	-- No início, (1-t) é próximo de 1, e o resultado é pequeno, mas conforme t se aproxima de 1, (1-t) diminui,
	-- fazendo com que o movimento desacelere.
	local easeOutT = 1 - (1 - t) * (1 - t) 
	lerpEaseOutDot.Position = UDim2.new(startX + (endX - startX) * easeOutT, 0, 0.6, 0)

	-- Lerp Ease-In-Out:
	-- Uma forma comum de calcular Ease-In-Out é usar: 0.5 * (1 - cos(pi * t)).
	-- Isso cria uma curva simétrica: o movimento começa devagar (ease-in), acelera no meio e desacelera no final (ease-out).
	local easeInOutT = 0.5 * (1 - math.cos(math.pi * t))
	easeInOutDot.Position = UDim2.new(startX + (endX - startX) * easeInOutT, 0, 0.9, 0)

	-- Approach:
	-- A função Approach aproxima o valor atual do alvo de forma exponencial.
	-- Fórmula: novo_valor = valor_atual + (alvo - valor_atual) * (1 - exp(-approachSpeed * deltaTime))
	-- Isso faz com que o movimento desacelere gradualmente à medida que o ponto se aproxima do destino.
	local approachSpeed = 3
	local currentApproach = approachDot.Position.X.Scale  -- Valor atual na escala horizontal
	local newApproach = currentApproach + (endX - currentApproach) * (1 - math.exp(-approachSpeed * deltaTime))
	approachDot.Position = UDim2.new(newApproach, 0, 0.8, 0)

	--------------------------------------------------------------------------------
	-- RESET DA ANIMAÇÃO COM PAUSA:
	--------------------------------------------------------------------------------
	-- Quando t atinge ou ultrapassa 1, os pontos chegaram ao destino final.
	-- Para melhor visualização, a animação pausa por 1 segundo antes de resetar todas as posições.
	if t >= 1 then
		paused = true  -- Pausa a animação
		task.delay(1, function()  -- Aguarda 1 segundo
			t = 0  -- Reseta o progresso para 0
			-- Reseta as posições de todos os pontos para o início
			lerpLinearDot.Position = UDim2.new(startX, 0, 0.2, 0)
			lerpEaseInDot.Position   = UDim2.new(startX, 0, 0.4, 0)
			lerpEaseOutDot.Position  = UDim2.new(startX, 0, 0.6, 0)
			easeInOutDot.Position    = UDim2.new(startX, 0, 0.9, 0)
			approachDot.Position     = UDim2.new(startX, 0, 0.8, 0)
			paused = false  -- Retoma a animação
		end)
	end
end)

-- Mensagem de confirmação para o console
print("Interface visual de interpolação carregada com sucesso!")