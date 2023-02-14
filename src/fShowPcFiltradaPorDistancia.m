function fShowPcFiltradaPorDistancia(pcCanalSeparado, pcSegmentada, pcSegmentada01, handles, canal)
    
% Cria um novo mapa de cores para os clusters
fig= figure;

% Exibe a nuvem de pontos original como o canal separado:
subplot(1,2,1);
pcshow(pcCanalSeparado.Location);
numPontos= length(pcCanalSeparado.Location); 
msg= sprintf('PC original - Canal %d com %d pontos', canal, numPontos);
title(msg);
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');

if (handles.habSegmentacaoNatMatlab)
    % Exibe a PC segemtada na segunda etapa:
    subplot(1,2,2);
    pcshow(pcSegmentada01.Location);
    numPontos= length(pcSegmentada01.Location); 
    msg= sprintf('PC Segmentada - Canal %d com %d pontos - Threshold: Min= %0.2fm e Max= %0.2fm', canal, numPontos, handles.valThresholdMinDistance, handles.valThresholdMaxDistance);
    title(msg);
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    fig.Position= [10, 40, 1600, 950];
    
    % Exibe a PC segemtada na segunda etapa:
    subplot(2,2,4);
    pcshow(pcSegmentada.Location);
    numPontos= length(pcSegmentada.Location); 
    msg= sprintf('PC Segmentada - Canal %d com %d pontos - Threshold: Min= %0.2fm e Max= %0.2fm', canal, numPontos, handles.valThresholdMinDistance, handles.valThresholdMaxDistance);
    title(msg);
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    fig.Position= [10, 40, 1600, 950];
else
    subplot(1,2,2);
    pcshow(pcSegmentada.Location);
    numPontos= length(pcSegmentada.Location); 
    msg= sprintf('PC Segmentada - Canal %d com %d pontos - Threshold: Min= %0.2fm e Max= %0.2fm', canal, numPontos, handles.valThresholdMinDistance, handles.valThresholdMaxDistance);
    title(msg);
    xlabel('X (m)');
    ylabel('Y (m)');
    zlabel('Z (m)');
    fig.Position= [10, 40, 1600, 950];
end

fig.WindowState='maximized'
end