% Alunos: ALÍCIA DE ALMEIDA MAIA, GEOVANE DE LIMA DUARTE E SARAH DE OLIVEIRA CABRAL
% Disciplina: TÓPICOS ESPECIAIS EM REDES DE COMUNICAÇÃO DE DADOS
% Atividade: SIMULAÇÃO DA REDE CELL FREE
% Professor: DIOGO LOBATO ACATAUASSU NUNES
% Data: 10-10-2004

% ------------------------------------------------------------
% DESCRIÇÃO DO CÓDIGO:
% Este código simula uma rede Cell-Free, que consiste em um sistema de comunicação
% sem fio onde várias antenas distribuídas (APs) cooperam para atender múltiplos usuários (UEs).
% A simulação inclui a estimação de canal baseada no método MMSE (Minimum Mean Squared Error),
% que leva em consideração a potência de uplink e downlink, as distâncias entre APs e UEs,
% e o ruído térmico no canal. O cálculo da potência do canal envolve a perda de caminho
% modelada pela distância elevada a um fator de 3.8. A potência normalizada é então usada para 
% estimar o canal e a distribuição de potência no downlink.
% ------------------------------------------------------------

clc;        % Limpa a janela de comando
clear all;  % Limpa todas as variáveis
close all;  % Fecha todas as janelas de figura
load positions_distances.mat;  % Carrega o arquivo com as posições e distâncias

% ------------------------------------------------------------
% MATRIZES DE DADOS:
% distances_ue_ap = matriz tridimensional com as distâncias entre as antenas (APs) e os usuários (UEs)
% x_aps = vetor com as posições x das antenas
% y_aps = vetor com as posições y das antenas
% x_ues = vetor com as posições x dos usuários
% y_ues = vetor com as posições y dos usuários
% ------------------------------------------------------------

% ------------------------------------------------------------
% PARÂMETROS GERAIS:
% ------------------------------------------------------------
% Número de Antenas (APs): 
m = 100;

% Número de Usuários (UEs): 
k = 40;

% Área de cobertura: 1000m x 1000m

% ------------------------------------------------------------
% PARÂMETROS DO CANAL (em mW):
% ------------------------------------------------------------
% Potência de downlink: 100mW -> 100*10^-3 W
pot_downlink = 100 * 10.^-3;

% Potência de uplink: 100mW -> 100*10^-3 W
pot_uplink = 100 * 10.^-3;

% ------------------------------------------------------------
% ESTIMAÇÃO DE CANAL:
% ------------------------------------------------------------
% Largura de Banda (MHz):
bw = 20;

% Tempo de Bloco de Coerência:
tc = 196;

% Pilotos de Uplink (para estimação de usuários, cada usuário recebe um piloto):
tp = min(k, tc);  % Usa o mínimo entre o número de usuários e o tempo de bloco de coerência

% Ruído (em dB):
rd = 9;

% ------------------------------------------------------------
% GERAÇÃO DO CANAL REAL:
% ------------------------------------------------------------
% A atenuação de caminho (beta) é gerada com base nas distâncias entre os APs e UEs.
% A fórmula usada para modelar o canal inclui um fator de perda de caminho elevado a 3.8.
beta = (1 ./ distances_ue_ap.^3.8);

% Visualização de um valor de referência de beta (exemplo):
% beta(1,1,1) % Valor referência -> 2.6098e-06

% ------------------------------------------------------------
% CÁLCULO DA POTÊNCIA DO RUÍDO (térmico):
% ------------------------------------------------------------
% A potência do ruído é calculada com base na fórmula do ruído térmico:
% pot_ruido = k * T * B, onde k é a constante de Boltzmann, T é a temperatura e B é a banda.
pot_ruido = (20 * 1e6) * (1.381 * 1e-23) * (290 * 10^(rd/10));
disp(pot_ruido);  % Exibe o valor da potência do ruído (referência: 6.36e-13)

% ------------------------------------------------------------
% CÁLCULO DA POTÊNCIA NORMALIZADA:
% ------------------------------------------------------------
% A potência normalizada é a razão entre a potência de uplink e a potência do ruído.
pot_normalizada = (pot_uplink / pot_ruido);
disp(pot_normalizada);  % Exibe a potência normalizada (referência: 1.5717e11)

% ------------------------------------------------------------
% ESTIMAÇÃO DO CANAL UTILIZANDO MMSE (Minimum Mean Squared Error):
% ------------------------------------------------------------
% A estimação de canal é feita utilizando o estimador MMSE, onde:
% gama é a estimação de canal e depende da potência normalizada e das distâncias (via beta).
gama = (tp * pot_normalizada * (beta.^2)) ./ (tp * pot_normalizada * beta + 1);

% Exibição de um valor de gama para referência:
disp(gama(5,4,10));  % Exemplo de valor: gama(5,4,10) -> 1.2982e-9

% ------------------------------------------------------------
% COEFICIENTE ESTIMADO DE POTÊNCIA DOWNLINK (ETA):
% ------------------------------------------------------------
% O coeficiente eta é o inverso da soma de todas as estimativas gama para um determinado AP (linha).
% Isto modela a distribuição de potência no downlink.
eta = 1 / sum(gama());  % Calcula eta como o inverso da soma das estimativas gama.

% Exibe os valores de eta para dois UEs (exemplos):
disp(eta(:,1,1));  % Valor estimado de eta para o primeiro UE
disp(eta(:,2,1));  % Valor estimado de eta para o segundo UE

% ------------------------------------------------------------
% CÁLCULO FINAL DA POTÊNCIA ESTIMADA:
% ------------------------------------------------------------
% O valor de referência da potência estimada (ref) é obtido multiplicando gama por eta.
ref = gama .* eta;  % Potência estimada multiplicando gama e eta

% Extração de uma linha de referência para análise:
var = ref(:,1,1);  % Valores de uma linha de referência da matriz ref
disp(var);  % Exibe o vetor var com os valores da linha

% Soma dos valores da potência normalizada para estimativa total:
x = sum(var);  % Calcula a soma dos valores de potência normalizada
disp(x);  % Exibe o resultado da soma
