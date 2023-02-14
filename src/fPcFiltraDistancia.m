%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Moacir Wendhausen
% Data: 08/12/2022
% Filtra nuvem de pontos considerando a distância euclidiana entre o LiDAR
% e ponto medido, ou seja, a norma do ponto XYZ.
% Os parâmetros de entrada, Threshold, são distância mínima e máxima do LiDAR
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pcThresholded handles]= fPcFiltraDistancia(pc, handles, ctCanal)

close all;
ct= 0;

% Define o nº de pontos da PC:
numPontosPC= length(pc.Location); 

% Efetua a varredura em toda a nuvem de pontos:
for (i=1:numPontosPC)
    
    % Calcula a distância euclidiana de cada ponto:
    distEuclidiana= norm(pc.Location(i,:));
    
    % Efetua uma segmetnação, filtragem em função da distância Euclidiana,
    % A região a ser segmenta está definida entre os valores, range, definidos nos
    % parâmetros: "handles.valThresholdMinDistance" e
    % "handles.valThresholdMaxDistance".
    % Qualquer ponto que tiver uma dist. Euclidoana maior ou menor que este
    % range range será eliminado
    if (distEuclidiana> handles.valThresholdMinDistance) && ...
                           (distEuclidiana< handles.valThresholdMaxDistance)
        ct= ct+1;
        % Guarda o ponto segmentado:
        location(ct,:)= pc.Location(i,:);
        
        % Guarda a intensidade do ponto segmentado:
        intensity(ct,:)= pc.Intensity(i,:);
    end    
end

% Testa se foi detectado algum ponto segmentado, caso contrário informar
% que não foi possível segmentar o canal. Se ao final da iteração acima
% ct=0, significa qua não ocorreu segmentação, nenhum ponto correspondeu
% aos parãmetros de segmentação.
if (ct>0)
    pcThresholded= pointCloud(location, 'Intensity', intensity);
    msg=sprintf('Segmetnando canal-> %d', ctCanal);
    handles.staticShowStatusSegmenta.String= msg;
    handles.numClusters= 1;
else
    pcThresholded= 0;
    handles.errorSegCn(ctCanal)= 1;
    handles.numClusters= 0;
end
