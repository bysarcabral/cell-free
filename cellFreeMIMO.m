% Alunos: ALÍCIA DE ALMEIDA MAIA, GEOVANE DE LIMA DUARTE, 
% JEAN MARLISON AZEVEDO DA SILVA E SARAH DE OLIVEIRA CABRAL
% Disciplina: TÓPICOS ESPECIAIS EM REDES DE COMUNICAÇÃO DE DADOS
% Atividade: SIMULAÇÃO DA REDE CELL FREE
% Professor: DIOGO LOBATO ACATAUASSU NUNES
% Data: 10-10-2004

% ------------------------------------------------------------
% DESCRIÇÃO DO CÓDIGO:
% Este código é a primeira versão da simulação de uma rede Cell Free. É simulado
% a estimação de canal em um sistema de comunicação sem fio,
% onde há várias antenas (APs) e usuários (UEs). A potência do canal é calculada
% considerando as distâncias entre as antenas e os usuários, assim como a potência
% de uplink e downlink. O código também considera o ruído térmico no canal.
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
