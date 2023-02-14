
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Autor: Moacir Wendhausen
% Data: 08/08/2022
% Esta fun��o efetua a leitura da PC de apenas 1 canal e segmenta uma 
% determinada linha.
% Ela chama a fun��o fSegmentaPC para segmantar a linha.
% ***Aten��o*** 
% O LiDAR VLP-16 ou Puck LITE retorna os pacotes de dados dados a informa��o 
% dos 16 canais conforme a sequ�ncia que segue abaixo:
%  Posi��o    Canal    �ngulo(Eleva��o)
%    01        00          -15�
%    02        02          -13�
%    03        04          -11�
%    04        06          -9�
%    05        08          -7�
%    06        10          -5�
%    07        12          -3�
%    08        14          -1�
%    09        01           1�
%    10        03           3�
%    11        05           5�
%    12        07           7�
%    13        09           9�
%    14        11           11�
%    15        13           13�
%    16        15           15�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles= fSegmentaPCPorCanal(handles)
close all;

% Verifica se os valors dos par�metros de threshold est�o ok.
if (handles.valThresholdMinDistance >= handles.valThresholdMaxDistance)
    habSegmentaCanais= 0;
    msg= sprintf(' Valor de threshold min. deve ser maior threshold m�x. \n Verifique os valores!!!');
    msgbox(msg, 'Error');
end

% Verifica se os valors dos par�metros numero de pontos min e max est�o ok:
if (handles.valMinPoints >= handles.valMaxPoints)
    habSegmentaCanais= 0;
    msg= sprintf(' N�mero min. de pontos deve ser maior n�mero m�x. de pontos \n Verifique os valores!!!');
    msgbox(msg, 'Error');
end        

if iscell(handles.filesParaSegmentar)
   numCanaisToSegmentar= length(handles.filesParaSegmentar);
else
   numCanaisToSegmentar= 1;
end

% Zera o vetor de erros, que identifica erro de segmenta��o no canal:
handles.errorSegCn(1:numCanaisToSegmentar)= 0;
% Zera o contador de erro:
ctError= 0;

for (ctCn=1:numCanaisToSegmentar)
    % Define o nome da PC referente ao canal que ser� lido e segmentado:
    if iscell(handles.filesParaSegmentar)
        nameFile= handles.filesParaSegmentar{ctCn};
    else
        nameFile= handles.filesParaSegmentar;        
    end
        fullPathPcRead= fullfile(handles.pathFilesParaSegmentar, nameFile);        
    
    % Efetua a leitura da nuvem de pontos com do respectivo canal selecionado:
    pcCanalSeparado= pcread(fullPathPcRead);
    
    % Chama fun��o para detectar os dados do canal que est� sendo lido.
    % O arquivo da PC com o canal separado dever� ter o nome no formato
    % "cnxx.pcd", onde xx � um n�mero que varia de 01 a 16. Por exemplo,
    % "can07.pcd". Se n�o tiver neste formato a vari�vel "nameCanal" retornar�
    % zero, informando que n�o foi poss�vel detectar o canal.
    [nameCanal numCanalReal angle]= fDetectaCanal(handles, nameFile);
    
    if (strcmp(nameCanal,""))
        msg= sprintf(' O arquivo %s da PC est� fora de padr�o.\n Verificar o formato que deve ser "cnxx.pcd".\n Onde: xx=n� do canal.', nameFile);
        figMsg= msgbox(msg);
        uiwait(figMsg);
    end

    % Se "handles.habSegmentacaoNatMatlab" estiver habilitado ser� efetuada
    % a segmetna��o em duas etapas:
    % 1�) faz a segmenta��o considerando apenas a dist�ncia m�nima, usando 
    %     a fun��o "fPcFiltraDistancia";
    % 2�) Refina a segmenta��o usando a fun��o do matlaba "pcsegdist()".
    % A 2� etapa � opcional e executada e depende do desempenho da 1� etapa.

    % Se n�o retornar erro de segmenta��o o processo continua. Se a vari�vel 
    % "nameCanal" for zero, significa que o arquivo da pC est� fora de padr�o,
    % n�o sendo poss�vel segmentar o canal.
    if ~(handles.errorSegCn(ctCn)) && ~(strcmp(nameCanal,""))          
        if (handles.habSegmentacaoNatMatlab)
            % 1� Etapa:
            [pcCanalSegmentado01 handles]= fPcFiltraDistancia(pcCanalSeparado, handles, ctCn, pcCompleta); 

            % O par�metro "handles.valMinDistance" define a dist�ncia
            % m�nima que deve existir entre 2 ou mais cluster:
            % 2� Etapa: 
            [labels, handles.numClusters] = pcsegdist(pcCanalSegmentado01, handles.valMinDistance, 'NumClusterPoints', [handles.valMinPoints handles.valMaxPoints]);

            % Remove os pontos que n�o tem valor de label v�lido, ou seja =0.
            idxValidPoints = find(labels);

            % Guarda o cluster definidos na vari�vel "idxValidPoints" quem cont�m 
            % os endere�os com os pontos v�lidos:
            labelColorIndex = labels(idxValidPoints);

            % Gera um nuvem de pontos com os valores segmentados:
            pcCanalSegmentado = select(pcCanalSegmentado01, idxValidPoints);

        else
            % 1� Etapa:
            [pcCanalSegmentado handles]= fPcFiltraDistancia(pcCanalSeparado, handles, ctCn);           
        end

        % Sinaliza ao usu�rio se n�o for detectado cluster ou se o n�mero de clusters for maior que 1:
        if (handles.numClusters==0) || (handles.numClusters>1) 
            msg= sprintf(' Aten��o!! \n Foram detectados %d clusters.', handles.numClusters);                    
            figMsgBox= msgbox(msg, 'Warn', 'warn');
        else
            msg= sprintf(' Segmenta��o do canal -> %d com �ngulo= %d foi condlu�da. \n Ok para continuar.', numCanalReal, angle);                       
            figMsgBox= msgbox(msg);
        end
        % Aten��o!!!!
        % Neste caso onde deseja-se manipular a figura, n�o pode-se usar a
        % fun��o "questdlg()" para di�logo, pois ela tem o par�metro modal,
        % e isto trava todas as figuras. Ent�o deve-se usar a fun��o
        % "msgbox()" seguida da fun��o "uiwait()" que � modo "normal" e n�o
        % "modal", isto possibilita manipular a figura exibida, tal como
        % zoom, rota��o deslocamento, etc.
        uiwait(figMsgBox);
        
        % Exibe as PCs apenas se o par�metro "handles.habShowPC" estiver ativo:
        if (handles.habShowPC) && (handles.numClusters==1)
            if (handles.habSegmentacaoNatMatlab)
                fShowPcFiltradaPorDistancia(pcCanalSeparado, pcCanalSegmentado, pcCanalSegmentado01, handles, ctCn);
            else
                fShowPcFiltradaPorDistancia(pcCanalSeparado, pcCanalSegmentado, 0, handles, numCanalReal);
            end
        end

        % Salva apenas se "handles.habSavePCSeg" estiver habilitado: 
        if (handles.habSavePCSeg) && (handles.numClusters==1)
            % Gera o nome da PC a ser salva j� com o valor original do
            % canal conforme definido no handle "handles.lookUpTable":
            nameFile= sprintf('%s.%s', nameCanal, handles.extPC);
            fullPathToSave= fullfile(handles.pathBase, handles.folderToSaveSeg);

            % Verifica se o folder existe, se n�o existir eles ser�o criados:                     
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
        msg= sprintf(' Segmenta��o n�o foi conclu�da. \n Erro nos canais: [ %s ]', num2str(cnError));
    else
        if ((ctCn-ctError)==1)
            msg= sprintf(' Segmenta��o conclu�da.\n Foi segmentado %d canal. \n Erro nos canais: -> [ %s ]',...
                        ctCn-ctError, num2str(cnError));
        else
            msg= sprintf(' Segmenta��o conclu�da.\n Foram segmentados %d canais. \n Erro nos canais:: -> [ %s ]',...
                        ctCn-ctError, num2str(cnError));
        end
    end
else
    if (handles.numClusters==1)
        msg= sprintf('Segmenta��o conclu�da. \n Foram segmentados %d canais. \n Sem erros de segmenta��o.', ctCn);
    else
        msg= sprintf(' Cluster n�o detectado.\n Verifique os par�metros Threshold min. e max.');
    end
end

figMsg= msgbox(msg);
uiwait(figMsg);

handles.statusProgram= msg;
end
