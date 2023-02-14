
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Moacir Wendhausen
% Data: 08/08/2022
% Esta função efetua a leitura da PC de apenas 1 canal e segmenta uma 
% determinada linha.
% Ela chama a função fSegmentaPC para segmantar a linha.
% ***Atenção*** 
% O LiDAR VLP-16 ou Puck LITE retorna os pacotes de dados dados a informação 
% dos 16 canais conforme a sequência que segue abaixo:
%  Posição    Canal    Ângulo(Elevação)
%    01        00          -15º
%    02        02          -13º
%    03        04          -11º
%    04        06          -9º
%    05        08          -7º
%    06        10          -5º
%    07        12          -3º
%    08        14          -1º
%    09        01           1º
%    10        03           3º
%    11        05           5º
%    12        07           7º
%    13        09           9º
%    14        11           11º
%    15        13           13º
%    16        15           15º
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles= fSegmentaPCPorCanal(handles)
close all;

% Verifica se os valors dos parãmetros de threshold estão ok.
if (handles.valThresholdMinDistance >= handles.valThresholdMaxDistance)
    habSegmentaCanais= 0;
    msg= sprintf(' Valor de threshold min. deve ser maior threshold máx. \n Verifique os valores!!!');
    msgbox(msg, 'Error');
end

% Verifica se os valors dos parãmetros numero de pontos min e max estão ok:
if (handles.valMinPoints >= handles.valMaxPoints)
    habSegmentaCanais= 0;
    msg= sprintf(' Número min. de pontos deve ser maior número máx. de pontos \n Verifique os valores!!!');
    msgbox(msg, 'Error');
end        

if iscell(handles.filesParaSegmentar)
   numCanaisToSegmentar= length(handles.filesParaSegmentar);
else
   numCanaisToSegmentar= 1;
end

% Zera o vetor de erros, que identifica erro de segmentação no canal:
handles.errorSegCn(1:numCanaisToSegmentar)= 0;
% Zera o contador de erro:
ctError= 0;

for (ctCn=1:numCanaisToSegmentar)
    % Define o nome da PC referente ao canal que será lido e segmentado:
    if iscell(handles.filesParaSegmentar)
        nameFile= handles.filesParaSegmentar{ctCn};
    else
        nameFile= handles.filesParaSegmentar;        
    end
        fullPathPcRead= fullfile(handles.pathFilesParaSegmentar, nameFile);        
    
    % Efetua a leitura da nuvem de pontos com do respectivo canal selecionado:
    pcCanalSeparado= pcread(fullPathPcRead);
    
    % Chama função para detectar os dados do canal que está sendo lido.
    % O arquivo da PC com o canal separado deverá ter o nome no formato
    % "cnxx.pcd", onde xx é um número que varia de 01 a 16. Por exemplo,
    % "can07.pcd". Se não tiver neste formato a variável "nameCanal" retornará
    % zero, informando que não foi possível detectar o canal.
    [nameCanal numCanalReal angle]= fDetectaCanal(handles, nameFile);
    
    if (strcmp(nameCanal,""))
        msg= sprintf(' O arquivo %s da PC está fora de padrão.\n Verificar o formato que deve ser "cnxx.pcd".\n Onde: xx=nº do canal.', nameFile);
        figMsg= msgbox(msg);
        uiwait(figMsg);
    end

    % Se "handles.habSegmentacaoNatMatlab" estiver habilitado será efetuada
    % a segmetnação em duas etapas:
    % 1ª) faz a segmentação considerando apenas a distância mínima, usando 
    %     a função "fPcFiltraDistancia";
    % 2ª) Refina a segmentação usando a função do matlaba "pcsegdist()".
    % A 2ª etapa é opcional e executada e depende do desempenho da 1ª etapa.

    % Se não retornar erro de segmentação o processo continua. Se a variável 
    % "nameCanal" for zero, significa que o arquivo da pC está fora de padrão,
    % não sendo possível segmentar o canal.
    if ~(handles.errorSegCn(ctCn)) && ~(strcmp(nameCanal,""))          
        if (handles.habSegmentacaoNatMatlab)
            % 1ª Etapa:
            [pcCanalSegmentado01 handles]= fPcFiltraDistancia(pcCanalSeparado, handles, ctCn, pcCompleta); 

            % O parâmetro "handles.valMinDistance" define a distância
            % mínima que deve existir entre 2 ou mais cluster:
            % 2ª Etapa: 
            [labels, handles.numClusters] = pcsegdist(pcCanalSegmentado01, handles.valMinDistance, 'NumClusterPoints', [handles.valMinPoints handles.valMaxPoints]);

            % Remove os pontos que não tem valor de label válido, ou seja =0.
            idxValidPoints = find(labels);

            % Guarda o cluster definidos na variável "idxValidPoints" quem contém 
            % os endereços com os pontos válidos:
            labelColorIndex = labels(idxValidPoints);

            % Gera um nuvem de pontos com os valores segmentados:
            pcCanalSegmentado = select(pcCanalSegmentado01, idxValidPoints);

        else
            % 1ª Etapa:
            [pcCanalSegmentado handles]= fPcFiltraDistancia(pcCanalSeparado, handles, ctCn);           
        end

        % Sinaliza ao usuário se não for detectado cluster ou se o número de clusters for maior que 1:
        if (handles.numClusters==0) || (handles.numClusters>1) 
            msg= sprintf(' Atenção!! \n Foram detectados %d clusters.', handles.numClusters);                    
            figMsgBox= msgbox(msg, 'Warn', 'warn');
        else
            msg= sprintf(' Segmentação do canal -> %d com ângulo= %d foi condluída. \n Ok para continuar.', numCanalReal, angle);                       
            figMsgBox= msgbox(msg);
        end
        % Atenção!!!!
        % Neste caso onde deseja-se manipular a figura, não pode-se usar a
        % função "questdlg()" para diálogo, pois ela tem o parãmetro modal,
        % e isto trava todas as figuras. Então deve-se usar a função
        % "msgbox()" seguida da função "uiwait()" que é modo "normal" e não
        % "modal", isto possibilita manipular a figura exibida, tal como
        % zoom, rotação deslocamento, etc.
        uiwait(figMsgBox);
        
        % Exibe as PCs apenas se o parâmetro "handles.habShowPC" estiver ativo:
        if (handles.habShowPC) && (handles.numClusters==1)
            if (handles.habSegmentacaoNatMatlab)
                fShowPcFiltradaPorDistancia(pcCanalSeparado, pcCanalSegmentado, pcCanalSegmentado01, handles, ctCn);
            else
                fShowPcFiltradaPorDistancia(pcCanalSeparado, pcCanalSegmentado, 0, handles, numCanalReal);
            end
        end

        % Salva apenas se "handles.habSavePCSeg" estiver habilitado: 
        if (handles.habSavePCSeg) && (handles.numClusters==1)
            % Gera o nome da PC a ser salva já com o valor original do
            % canal conforme definido no handle "handles.lookUpTable":
            nameFile= sprintf('%s.%s', nameCanal, handles.extPC);
            fullPathToSave= fullfile(handles.pathBase, handles.folderToSaveSeg);

            % Verifica se o folder existe, se não existir eles serão criados:                     
            if ~isfolder(fullPathToSave)
                mkdir(fullPathToSave);
            end

            fullPathPcSave= fullfile(fullPathToSave, nameFile);
            
            % Salva a PC segmentada:
            pcwrite(pcCanalSegmentado, fullPathPcSave);
        end          
    else
        % Incrementador e identificador de canal com erro:
        ctError= ctError+1;
        cnError(ctError)= handles.cnSegmenta(ctCn);            
    end
end

% Define mensagem final a ser exibida:
if ctError>0
    if (ctError==1) && (ctCn==1)
        msg= sprintf(' Segmentação não foi concluída. \n Erro nos canais: [ %s ]', num2str(cnError));
    else
        if ((ctCn-ctError)==1)
            msg= sprintf(' Segmentação concluída.\n Foi segmentado %d canal. \n Erro nos canais: -> [ %s ]',...
                        ctCn-ctError, num2str(cnError));
        else
            msg= sprintf(' Segmentação concluída.\n Foram segmentados %d canais. \n Erro nos canais:: -> [ %s ]',...
                        ctCn-ctError, num2str(cnError));
        end
    end
else
    if (handles.numClusters==1)
        msg= sprintf('Segmentação concluída. \n Foram segmentados %d canais. \n Sem erros de segmentação.', ctCn);
    else
        msg= sprintf(' Cluster não detectado.\n Verifique os parâmetros Threshold min. e max.');
    end
end

figMsg= msgbox(msg);
uiwait(figMsg);

handles.statusProgram= msg;
end
