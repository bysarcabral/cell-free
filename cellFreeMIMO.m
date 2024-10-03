% ARQUIVOS DAS MATRIZES
% distances_ue_ap = matriz tridimensional
% x_aps = posição x das antenas
% y_aps = posição y das antenas
% x_ues = posição x dos usuários
% y_ues = posição y dos usuários

% PARÂMETROS GERAIS
% N° de Antenas: M = 100
% N° de Usuários: K = 40
% Área: 1000m x 1000m

% CANAL
% pot_downlink = 100mW
% pot_uplink = 100mW

% ESTIMAÇÃO DE CANAL:
% Banda Larga: bw= 20mHz
% Tempo de Coerência: Tc = 196
% Uplink Pilots(estimação de usuários | cada usuário vai receber um piloto) Tp = min(k,Tc)
% Ruído: rd = 9dB

%__________________________________________________

% Geração do canal real

beta = (1/distances_ue_ap.^3.8)
%beta(1,1,1)
%beta(2,1,1)
