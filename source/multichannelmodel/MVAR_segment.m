% funcao para segmentacao de processos MVAR 
%   - input:   processo a ser segmentado
%   - nb_seg:  numero total de segmentos a considerar
%   - sz_seg:  tamanho dos segmentos

function output = MVAR_segment(input,nb_seg,sz_seg)

    m = size(input,1);
    y = reshape(input,m,sz_seg,[]);
    
    % faco uma permutacao aleatoria do total de segmentos 
    % e escolho apenas nb_seg deles
    aux = randperm(size(y,3));
    output = y(:,:,aux(1:nb_seg)); 
    
end