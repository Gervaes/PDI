function [H]=Entropia(I,L,x,y)
    //Zerando vetor histograma
    for k=1: 256
        qtdL(k) = 0;
    end
    
    //Preenchendo vetor histograma
    for i=(((x-1)*L)+1):x*L
        for j=(((y-1)*L)+1):y*L
            qtdL(I(i,j)+1) = qtdL(I(i,j)+1) + 1;
        end
    end
    
    //Preenchendo vetor Pi
    for k=1: 256
        Pi(k) = double(qtdL(k) / (L*L));
    end
    
    H=0;
    //Entropia
    for k=1: 256
        if Pi(k) <> 0 then
            H = H + (Pi(k)*log2(Pi(k)));
        end
    end
    
    //Multiplicando entropia por -1
    H = H*(-1);
endfunction

function [HSI]=ConversaoHSI(imagem)
    [linhas,colunas] = size(imagem);
    
    //normalizando valores entre 0 e 1
    RGB = double(imagem)/255;
    
    //Separando canais da imagem RGB
    R = RGB(:,:,1);
    G = RGB(:,:,2);
    B = RGB(:,:,3);
    
    //Conversão para HSI
    for i=1:linhas
        for j=1:colunas
            //Matiz (H)
                //Calculando theta
                numerador = 0.5*(R(i,j) - G(i,j) + (R(i,j) - B(i,j)));
                denominador = sqrt((R(i,j) - G(i,j))^2 + (R(i,j) - B(i,j))*(G(i,j) - B(i,j)));
                theta = acos(numerador/(denominador + 0.000001)); //adiçãopra evitar divisão por 0
            
                //Calculando matiz (H)
                if B(i,j) <= G(i,j) then
                    HSI(i,j,1) = theta;
                else
                    HSI(i,j,1) = 360 - theta;
                end
    
                //Normalizando H de 0 a 1
                HSI(i,j,1) = HSI(i,j,1)/360;

            //Saturação (S)
                numerador = (min(R(i,j), G(i,j), B(i,j)))*3;
                denominador = R(i,j) + G(i,j) + B(i,j);
                HSI(i,j,2) = 1 - (numerador/(denominador + 0.000001));  
                
            //Intesidade (I)
                HSI(i,j,3) = denominador/3;
        end
    end
endfunction

function [I]=EqualizacaoI(HSI)
    [linhas,colunas] = size(HSI);
    total = double(linhas*colunas);
    maior = 0;
    escala = 256;
    
    for i=1:linhas
        for j=1:colunas
            HSI(i,j,3) = round(double(HSI(i,j,3)*255));
        end
    end
    
   //Zerando vetores probabilidade e histograma
    for i=1:escala
        probabilidade(i) = double(0);
        histograma(i) = double(0);
    end

    //Preenchendo vetor histograma
    for i=1:linhas
        for j=1:colunas
            indice = double(HSI(i,j,3)+1);
            histograma(indice) = histograma(indice) + 1;
            
            if HSI(i,j,3) > maior then
                maior = HSI(i,j,3);
            end
        end
    end
    
    //Preenchendo vetor probabilidade
    for i=1:escala
        probabilidade(i) = double(histograma(i)/total);
    end
    
    //Calculo da FDA
    FDA(1) = probabilidade(1);
    for i=2:escala
        FDA(i) = double(double(FDA(i-1))+double(probabilidade(i)));
    end
    
    //Aproximação dos níveis
    for i=1:escala
        equalizado(i) = round(double(double(FDA(i))*double(maior)));
    end
    
    //Normalizando canal I
    for i=1:linhas
        for j=1:colunas
            HSI(i,j,3) = double(equalizado(HSI(i,j,3)+1));
        end
    end
    
    //Zerando vetores probabilidade e histograma
    for i=1:escala
        probabilidade(i) = double(0);
        histograma(i) = double(0);
    end

    //Retornando canal I equalizado
    I = HSI(:,:,3)/255;
endfunction

function [imagem_seg_1,imagem_seg_2]=Segmentacao(I)
    limiar = imgraythresh(I);
    
    [linhas,colunas] = size(I);
    
    //imagem_seg_1 = zeros(size(I)); //Imagem abaixo/igual do limiar
    //imagem_seg_2 = zeros(size(I)); //Imagem acima do limiar
    
    for i=1:linhas
        for j=1:colunas
            if I(i,j) <= limiar
                imagem_seg_1(i,j) = 1;
            else
                imagem_seg_2(i,j) = 1;
            end
        end
    end
endfunction

function [ent,df,opmf]=ConstruirVetor(imagem_seg_1,imagem_seg_2,I)
    [linhas,colunas] = size(I);
    
    ent = 0;
    df = 0;
    opmf = 0;
    
    //Entropia (feita com I)
        //Escolhendo L máximo
        if linhas > colunas then
            L = colunas;
        else
            L = linhas;
        end
        
        //Calculando entropias para cada valor de L
        cont = 0; 
        while L > 1
            H = 0;
            
            x = floor(linhas/L);
            y = floor(colunas/L);
            for i=1:x
                for j=1:y
                    H = H + Entropia(I,L,i,j);
                end
            end
            
            H = (H/(x*y));
        
            cont = cont + 1;
            
            entropias(cont,1) = L;
            entropias(cont,2) = H;
        
            L = floor(L/2);
        end
        
        //Visualizando entropias
        figure, plot(entropias(:,1),entropias(:,2));
        
        for i=1:cont
            mprintf("\nL: %i, H: %f",entropias(cont,1),entropias(cont,2));
            entropias(cont,1) = log10(entropias(cont,1));
            entropias(cont,2) = log10(entropias(cont,2));
        end
        
        //Visualizando entropias após regressão
        figure; plot(entropias(:,1),entropias(:,2));

        //
endfunction

function [imgDilatada]=Dilatacao(img, corObj, corFun, x, y, elemEs, inicio, fim)
    for i=1:x
        for j=1:y
            imgDilatada(i,j) = corFun;
        end
    end
    
    for k=inicio:(x-fim)
        for l=inicio:(y-fim)
            if img(k,l) == corObj then
                for m=(k-elemEs):(k+elemEs)
                    for n=(l-elemEs):(l+elemEs)
                        imgDilatada(m,n) = corObj;
                    end
                end
            end
        end
    end
    
    figure; imshow(imgDilatada);
endfunction

function [imgErodida]=Erosao(img, corObj, corFun, x, y, elemEs, inicio, fim)
    for i=1:x
        for j=1:y
            imgErodida(i,j) = corFun;
        end
    end
    
    count = 0;

    for k=inicio:(x-fim)
        for l=inicio:(y-fim)
            if img(k,l) == corObj then
                for m=(k-elemEs):(k+elemEs)
                    for n=(l-elemEs):(l+elemEs)
                        if img(m,n) == corObj then
                            count = count + 1;
                        end
                    end
                end
             end
             if count == 49 then
                 for m=(k-elemEs):(k+elemEs)
                    for n=(l-elemEs):(l+elemEs)
                        if img(m,n) == img(k,l) then
                            imgErodida(m,n) = corObj;
                        else
                            imgErodida(m,n) = corFun;
                        end
                    end
                end
            else
                for m=(k-elemEs):(k+elemEs)
                    for n=(l-elemEs):(l+elemEs)
                        imgErodida(m,n) = corFun;
                    end
                end
            end
            count = 0;
        end
    end
    
    figure; imshow(imgErodida);
endfunction

function [imagem_seg]=FiltroMorfologico(imagem_seg, corObj, corFun)
    [linhas,colunas] = size(imagem_seg);
    
    x = linhas + 6;     //dimensões da matriz extendida
    y = colunas + 6;    //dimensões da matriz extendida
    elemEs = 3;         //distância entre ponto central e borda do elemento estruturante
    inicio = 4;         //inicío das informações da matriz extendida
    fim = 3;            //fim das informações da matriz extendida
    
    //Criando matriz extendida para aplicar elemento estruturante
    for i=1:x
        for j=1:y
            imgExt(i,j) = corFun;
        end
    end
    
    for i=inicio:(x-fim)
        for j=inicio:(y-fim)
            imgExt(i,j) = imagem_seg(i-elemEs,j-elemEs);
        end
    end
    
    imgErodida = Erosao(imgExt,corObj,corFun,x,y,elemEs,inicio,fim);
    
    imgDilatada = Dilatacao(imgErodida,corObj,corFun,x,y,elemEs,inicio,fim);
    
    imgDilatada = Dilatacao(imgDilatada,corObj,corFun,x,y,elemEs,inicio,fim);
    
    imgErodida = Erosao(imgDilatada,corObj,corFun,x,y,elemEs,inicio,fim);
    
    figure; imshow(imgErodida);
endfunction

function OperadorMorfologico(imagem_seg, corObj)
    [linhas,colunas] = size(imagem_seg);
    cont = 0;
    
    for i=1:linhas
        for j=1:colunas
            if imagem_seg(i,j) == corObj then
                count = cont + 1;
            end
        end
    end
    
    prob = round(cont/(linhas*colunas));
endfunction

//Classes de imagens
classeA = ["ytma49_072303_benign2_ccd.TIF",
           "ytma49_111003_benign1_ccd.TIF",
           "ytma49_111003_benign2_ccd.TIF",
           "ytma49_111003_benign3_ccd.TIF",
           "ytma49_111303_benign1_ccd.TIF",
           "ytma49_111303_benign2_ccd.TIF",
           "ytma49_111303_benign3_ccd.TIF"];

classeB = ["ytma49_072303_malignant2_ccd.TIF",
           "ytma49_111003_malignant1_ccd.TIF",
           "ytma49_111003_malignant2_ccd.TIF",
           "ytma49_111003_malignant3_ccd.TIF",
           "ytma49_111303_malignant1_ccd.TIF",
           "ytma49_111303_malignant2_ccd.TIF",
           "ytma49_111303_malignant3_ccd.TIF"];

//Vetores de características
caracteristicas = zeros(14,3);
imagem = imread("C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\ytma49_072303_benign2_ccd.TIF");
//figure; imshow(imagem);

//Etapa 0 - Conversão para HSI
HSI = zeros(size(imagem));
HSI = ConversaoHSI(imagem);
figure; imshow(HSI(:,:,3));

////Etapa 1 - Equalização do canal I
I = EqualizacaoI(HSI);
figure; imshow(I);
//
////Etapa 2 - Segmentação da imagem do canal I
[imagem_seg_1,imagem_seg_2] = Segmentacao(I);
//
figure; imshow(imagem_seg_1);
figure; imshow(imagem_seg_2);
//
////Etapa 3 - Aplicar filtro morfológico nas duas imagens imagem_seg
imagem_seg_2 = FiltroMorfologico(imagem_seg_2, 0, 1);
//figure; imshow(imagem_seg_1);
//imagem_seg_2 = FiltroMorfologico(imagem_seg_2, 0, 1);
//figure; imshow(imagem_seg_2);

//Etapa 4 - Aplicação de quantificadores Entropia, DF e Operador Morfológico
//OperadorMorfologico(imagem_seg_1,1);
//
////Etapa 4 - Compor vetor de características (Entropia, Dimensão Fractal e )
////[ent,df,opmf] = ConstruirVetor(imagem_seg_1,imagem_seg_2,I);
