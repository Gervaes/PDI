/*
2   Extração do contorno e suavização
    
  A abordagem de segmentação utilizada nessa seção é baseada sobre
limite local adaptativo usando tabelas de soma(?) implementadas 
através do conceito de imagens integrais. O paragrafo seguinte descreve
o método.

    2.1 Limite local adaptativo para segmentação utilizando tabelas
  de soma
  
      Dada uma imagem na qual a intensidade de um pixel está na posi
    ção (i,j). Na técnica de limite local adaptativo, o objetivo
    é calcular um limite T(i,j) para cada pixel, da seguinte maneira:
    
        se I(i,j) <= T(i,j)
            O(i,j) = 0 (PRETO)
        senão                                                      (1)
            O(i,j) = 255 (BRANCO)

    onde O(i,j) é a imagem de saída e I(i,j) é a imagem de entrada.
      
      A técnica de segmentação binária de Sauvola calcula o limite
    local T(i,j) de um pixel centrado numa janela WxW usando a média
    local m(i,j) e o desvio padrão local s(i,j). A expressão usada no 
    método de segmentação binária de Sauvola é da forma:
    
        T(i,j) = m(i,j)[1+k{(s(i,j)/R)-1}]                         (2)
        
    onde R é o valor máximo do desvio padrão e k é o parâmetro que toma
    valores positivos no intervalo [0.2,0.5].
      
      O uso de desvio padrão nessa fórmula tem como intuito adaptar o 
    limite ao valor do pixel na janela. Quando o contraste na regi
    ão é alto, s(i,j) é praticamente igual a R que fará com que os va
    lores em T(i,j) serão praticamente iguais a m(i,j). Caso contrário,
    na região uniforme o desvio padrão é baixo e o limite fica abai
    xo da média local, assim removendo com sucesso a região relativa
    mente escura do fundo.
    
      Calculando a equação (2) para uma imagem com dimensões NxN resulta
    numa complexidade computacional de O(W²N²)(EXPONENCIAL) o que faz 
    o método consumir muito tempo. Essa complexidade pode ser reduzida 
    para O(N²)(QUADRÁTICA) usando o conceito de imagem integral. Uma
    imagem integral é definida como a imagem na qual a intensidade de
    um pixel numa dada posição é igual à soma de todos os pixels acima
    e aqueles as esquerda da posição. A expressão da imagem integral é
    da forma:
    
        Is(i,j) = EE I(k,l)                                        (3)
                  ^^(Somatórios de k=0 até i e l=0 até j)

      A média local e a variância podem ser calculadas de maneira efi
    ciente para qualquer tamanho de janela usando uma soma e duas sub
    trações em vez de somar todos os pixels da dada janela. A média
    local m(i,j) é definida como segue:
    
        m(i,j) = Is(i+w/2,j+w/2) + Is(i-w/2,j-w/2)
               - Is(i+w/2,j-w/2) - Is(i-w/2,j+w/2)                 (4)

      O desvio padrão s(i,j) é definido como segue:
      
        s²(i,j) = 1/w² EE I²(k,l)-m²(i,j)                          (5)
                       ^^(Somatórios com k=i-w/2 até i+w/2 
                                         l=j-w/2 até j+w/2 )

      O resultado da segmentação binária das mamografias usando essa
    abordagem está presente na figura 1.
      
      Depois da segmentação, pontos ruidosos ao longo do contorno são
    removidos usando uma dilação seguida por uma erosão (1C). Essas du
    as operações são realizadas para evitar qualquer deslocamento da
    fronteira.
      
      A figura 2 mostra algumas mamografias contendo bastante ruído 
    de fundo. Após a segmentação binária, a fronteira da mama na mamo
    grafia não é totalmente recuperável com o método de limite global,
    enquanto que com o método de limite local permite recuperação total
    após operações morfológicas (erosão e dilatação) com uma estrutura
    7x7.
    
      Esses dois casos de mamografias representados na figura 2 são uma
    boa ilustração de que o método do limite local adaptativo usando
    imagens integrais pode extrair pixels de fronteira com sucesso quan
    do possuem muito ruído.
    
      O contorno extraído neste passo (1C por exemplo) é irregular e
    e pode apresentar alguns pixels trocados na borda devido a presen
    ça de ruído ao longo da fronteira. Obter uma aparência real do
    contorno do objeto requer algumas operações a mais. Isso pode ser
    feito suavizando o contorno extraído. A seção seguinte descreve 
    Descritores de Fourier em relação com suavização de contorno.
*/

//Leitura da imagem
mammogram = imread('C:\Users\Grrv\Desktop\PDI\artigo\mamografia.jpg');
mammogram = rgb2gray(mammogram);

//Dimensões da imagem
columns = 40;
rows = 40;

//Binarization of the input image
function [value]=Binarization(i,j)
    if mammogram(i,j)<= TH(i,j) then
        value = 0;
    else
        value = 255;
    end
endfunction

//for each pixel T(i,j) = m(i,j)[1+k{(s(i,j)/R)-1}]
function [value]=Threshold(i,j)
    value = LM(i,j)*(1+u*(SD(i,j)/R)-1);
endfunction

//local mean m(i,j) = Is(i+w/2,j+w/2) + Is(i-w/2,j-w/2)- Is(i+w/2,j-w/2) - Is(i-w/2,j+w/2)
function [value]=LocalMean(i,j)
    value = 0;
    //Tratamento pra não haver acesso em índice que não existe
    if i+w/2 < rows+1 & j+w/2 < columns+1 then value = value + IntegralImage(i+w/2,j+w/2); end
    if i-w/2 >= 1     & j-w/2 >= 1        then value = value + IntegralImage(i-w/2,j-w/2); end
    if i+w/2 < rows+1 & j-w/2 >= 1        then value = value + IntegralImage(i+w/2,j-w/2); end
    if i-w/2 >= 1     & j+w/2 < columns+1 then value = value + IntegralImage(i-w/2,j+w/2); end
    
    //Dividing by the number of items in the window to know the LocalMean
    value = value/(w*w);
endfunction

//standard deviation s²(i,j) = 1/w² EE I²(k,l)-m²(i,j) 
//                                  ^^(Somatórios com k=i-w/2 até i+w/2 
//                                                    l=j-w/2 até j+w/2 )
function [value]=StardardDeviation(i,j)
    value = 0;
    for k=i-w/2:i+w/2
        for l=j-w/2:j+w/2
            if k >= 1 & l >= 1 & k < rows+1 & l < columns+1
                value = value + ((mammogram(k,l)*mammogram(k,l)) -((LM(i,j)*LM(i,j)))) / (w*w);
            end
        end
    end
    
    //value = double(sqrt(value));
endfunction

//Integral image(i,j) = EE I(k,l)
//                      ^^(Somatórios de k=0 até i e l=0 até j)
function [value]=IntegralImage(i,j)
    value =0;
    for k=1:i
        for l=1:j
            value = value + mammogram(k,l);
        end
    end
endfunction

w = 3; //window
u = 0.5; //[0.2,0.5] starting with 0.2
//columns = 15;
//rows = 15;
R = 1;

//Teste de cada função separadamente
//mammogram = [10,20,30,40;
//             40,30,20,10;
//             20,40,10,30;
//             30,10,40,20]

//Input image
mprintf('\nInputImage:\n');
for k=1:rows
    for l=1:columns
        mprintf('%3i ',mammogram(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Calculating IntegralImage for the whole image and putting it on the II matrix
mprintf('\nIntegralImage:\n');
for k=1:rows
    for l=1:columns
        II(k,l) = IntegralImage(k,l);
        mprintf('%3i ',II(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Calculating LocalMean for the whole image with window size 3 and putting it on the LM matrix  
mprintf('\nLocalMean:\n');
for k=1:rows
    for l=1:columns
        LM(k,l) = LocalMean(k,l);
        mprintf('%3i ',LM(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Calculating StandardDeviation for the whole image
mprintf('\nStandartDeviation:\n');
for k=1:rows
    for l=1:columns
        SD(k,l) = StardardDeviation(k,l);
        mprintf('%3i ',SD(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Searching for the biggest value from SD matrix
for k=1:rows
    for l=1:columns
        if SD(k,l) >= R then
           R = SD(k,l); 
        end
    end
end

mprintf('\nR = %i\n',R);

//Calculating Threshold for the whole image
mprintf('\nThreshold:\n');
for k=1:rows
    for l=1:columns
        TH(k,l) = double(Threshold(k,l));
        mprintf('%3i ',TH(k,l));
    end
    mprintf('\n');
end




figure;
imshow(mammogram);

/*
num = IntegralImage(3,3);
mprintf('\nTESTE FUNÇÃO INTEGRALIMAGE\n');
mprintf('IntegralImage(%i,%i)=%i\n\n-------------------\n',3,3,num);

num = LocalMean(2,2);
mprintf('\nTESTE FUNÇÃO LOCALMEAN\n');
mprintf('(%i,%i)%i + (%i,%i)%i - (%i,%i)%i - (%i,%i)%i\n',x+w/2,z+w/2,IntegralImage(x+w/2,z+w/2),x-w/2,z-w/2,IntegralImage(x-w/2,z-w/2),x+w/2,z-w/2,IntegralImage(x+w/2,z-w/2),x-w/2,z+w/2,IntegralImage(x-w/2,z+w/2));
mprintf('LocalMean(%i,%i)=%i\n\n-------------------\n',50,50,num);

/*
mprintf('mammogram(%i,%i)=%i    ',x-1,z-1,mammogram(x-1,z-1));
mprintf('mammogram(%i,%i)=%i    ',x-1,z,mammogram(x-1,z));
mprintf('mammogram(%i,%i)=%i\n',x-1,z+1,mammogram(x-1,z+1));
mprintf('mammogram(%i,%i)=%i    ',x,z-1,mammogram(x,z-1));
mprintf('mammogram(%i,%i)=%i    ',x,z,mammogram(x,z));
mprintf('mammogram(%i,%i)=%i\n',x,z+1,mammogram(x,z+1));
mprintf('mammogram(%i,%i)=%i    ',x+1,z-1,mammogram(x+1,z-1));
mprintf('mammogram(%i,%i)=%i    ',x+1,z,mammogram(x+1,z));
mprintf('mammogram(%i,%i)=%i\n',x+1,z+1,mammogram(x+1,z+1));

num = IntegralImage(3,3);
mprintf('\nTESTE FUNÇÃO INTEGRALIMAGE\n');
mprintf('IntegralImage(%i,%i)=%i\n\n-------------------\n',3,3,num);

mprintf('Is(%i,%i)=%i    ',x-1,z-1,IntegralImage(x-1,z-1));
mprintf('Is(%i,%i)=%i    ',x-1,z,IntegralImage(x-1,z));
mprintf('Is(%i,%i)=%i\n',x-1,z+1,IntegralImage(x-1,z+1));
mprintf('Is(%i,%i)=%i    ',x,z-1,IntegralImage(x,z-1));
mprintf('Is(%i,%i)=%i    ',x,z,IntegralImage(x,z));
mprintf('Is(%i,%i)=%i\n',x,z+1,IntegralImage(x,z+1));
mprintf('Is(%i,%i)=%i    ',x+1,z-1,IntegralImage(x+1,z-1));
mprintf('Is(%i,%i)=%i    ',x+1,z,IntegralImage(x+1,z));
mprintf('Is(%i,%i)=%i\n',x+1,z+1,IntegralImage(x+1,z+1));

//Binarizando imagem
for i=1:rows
    for j=1:columns
        OutputImage(i,j) = Binarization(i,j);
    end
end

//Visualizando histograma
for k=1:256
    histograma(k) = 0;
end

for i=1:linhas
    for j=1:colunas
        //if teste(i,j) > 2 then 
            indice = double(teste(i,j) + 1);
            histograma(indice) = histograma(indice) + 1;
        //end 
    end
end

figure;
bar(histograma);

figure;
imshow(teste);


MÉDIA LOCAL ALTERNATIVA CASO PRECISE TRATAR ACESSO A INDICES INDISPONÍVEIS
function [value]=LocalMean(i,j)
    value = 0;
    //Tratamento pra não haver acesso em índice que não existe
    if i+w/2 <= rows & j+w/2 <= columns then value = value + IntegralImage(i+w/2,j+w/2); end
    if i-w/2 >= 0    & j-w/2 >= 0       then value = value + IntegralImage(i-w/2,j-w/2); end
    if i+w/2 <= rows & j-w/2 >= 0       then value = value + IntegralImage(i+w/2,j-w/2); end
    if i-w/2 >= 0    & j+w/2 <= columns then value = value + IntegralImage(i-w/2,j+w/2); end
endfunction

*/




