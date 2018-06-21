function [H]=Entropia(imagem,L,x,y)
    //Zerando vetor histograma
    for k=1: 256
        qtdL(k) = 0;
    end
    
    //Preenchendo vetor histograma
    for i=(((x-1)*L)+1):x*L
        for j=(((y-1)*L)+1):y*L
            qtdL(double(double(imagem(i,j))+1)) = qtdL(double(double(imagem(i,j))+1)) + 1;
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

function [H]=EntropiaFinal(imagem)
    [linhas,colunas] = size(imagem);
    imagem = imagem*255;
    
    //Entropia
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
                    H = H + Entropia(imagem,L,i,j);
                end
            end
            
            H = (H/(x*y));
        
            cont = cont + 1;
            
            entropias(cont,1) = double(L);
            entropias(cont,2) = double(H);
        
            mprintf("\nL: %i, H: %f",entropias(cont,1),entropias(cont,2));
        
            L = floor(L/2);
        end
        
        //Visualizando entropias
        //figure, plot(entropias(:,1),entropias(:,2));
        
        for i=1:cont
            entropias(cont,1) = double(log2(double(entropias(cont,1))));
            entropias(cont,2) = double(log2(double(entropias(cont,2))));
            //mprintf("\nL: %i, H: %f",entropias(cont,1),entropias(cont,2));
        end
        
        //Visualizando entropias após regressão
        //figure; plot(entropias(:,1),entropias(:,2));

        //
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
    limiar = 0.1;
    
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
             if count == 9 then
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
endfunction

function [imagem_seg]=FiltroMorfologico(imagem_seg, corObj, corFun)
    [linhas,colunas] = size(imagem_seg);
    
    x = linhas + 2;     //dimensões da matriz extendida
    y = colunas + 2;    //dimensões da matriz extendida
    elemEs = 1;         //distância entre ponto central e borda do elemento estruturante
    inicio = 2;         //inicío das informações da matriz extendida
    fim = 1;            //fim das informações da matriz extendida
    
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
    
    //Aplicando abertura
    imgErodida = Erosao(imgExt,corObj,corFun,x,y,elemEs,inicio,fim);
    imgDilatada = Dilatacao(imgErodida,corObj,corFun,x,y,elemEs,inicio,fim);
    
    [linhas,colunas] = size(imgDilatada);
    
    for i=inicio:(x-fim)
        for j=inicio:(y-fim)
            imagem_seg(i-elemEs,j-elemEs) = imgDilatada(i,j);
        end
    end
endfunction

function [dimensaofractal]=DimensaoFractal(imagem)
    //Gerv
endfunction

function [caracteristicas]=ConstruirVetor(imagem_seg_1,imagem_seg_2,I,caracteristicas,i)
    
    //Calculando entropias para as 3 imagens
    caracteristicas(i,1) = EntropiaFinal(imagem_seg_1);
    caracteristicas(i,4) = EntropiaFinal(imagem_seg_2);
    caracteristicas(i,7) = EntropiaFinal(I);
    
    caracteristicas(i,2) = DimensaoFractal(imagem_seg_1);
    caracteristicas(i,5) = DimensaoFractal(imagem_seg_2);
    caracteristicas(i,8) = DimensaoFractal(I);
    
    caracteristicas(i,3) = OperadorMorfologico(imagem_seg_1, 1, 0);
    caracteristicas(i,6) = OperadorMorfologico(imagem_seg_2, 0, 1);
    caracteristicas(i,9) = OperadorMorfologico(I, 0, 1);
        
endfunction

function [nElementos]=OperadorMorfologico(img, corObj, corFun)
    [linhas,colunas] = size(img);
    pxBranco = 0;
    nElementos = 0;
    
    //cálculo de pixels brancos na imagem
    for i=1:linhas
        for j=1:colunas
            if img(i,j) == corObj then
                pxBranco = pxBranco + 1;
            end
        end
    end
    
    //cálculo de total de pixels na imagem
    pxTotal = linhas*colunas;
    
    //cálculo de probabilidade de pixels brancos
    prob = double(pxBranco/pxTotal);
    
    elemEst = 256;
    i = 1;
    j = 1;
    
    //elemento estruturante: matriz 8x8
    while i+15 < linhas,
        x = i+15;
        y = j+15;
        brParcial = 0;
        probParcial = 0;
        
        for k=i:x;
            for l=j:y;
                if img(k,l) == corObj then
                    brParcial = brParcial + 1;
                end
            end
        end
        
        probParcial = double(brParcial/elemEst);
        
        if probParcial >= prob then
            nElementos = nElementos + 1;
        end
        
        if y == colunas then
            j = 1;
            i = x+1;
        else
            j = y+1;
        end
        
    end
endfunction

//Classes de imagens
classeA = ["C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\ytma49_072303_benign2_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_A_hist_mama_benigna\ytma49_111003_benign1_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_A_hist_mama_benigna\ytma49_111003_benign2_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_A_hist_mama_benigna\ytma49_111003_benign3_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_A_hist_mama_benigna\ytma49_111303_benign1_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_A_hist_mama_benigna\ytma49_111303_benign2_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_A_hist_mama_benigna\ytma49_111303_benign3_ccd.TIF"];

classeB = ["C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_072303_malignant2_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_111003_malignant1_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_111003_malignant2_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_111003_malignant3_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_111303_malignant1_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_111303_malignant2_ccd.TIF",
           "C:\Users\marco\OneDrive\Documentos\GitHub\PDI\prova\Dupla6\Classe_B_hist_mama_maligna\ytma49_111303_malignant3_ccd.TIF"];


//Vetores de características
caracteristicas = zeros(14,9);
imagem = imread(classeB(7));
//figure; imshow(imagem); title("Imagem original RGB","fontsize",5);

//Etapa 0 - Conversão para HSI
HSI = zeros(size(imagem));
HSI = ConversaoHSI(imagem);
//figure; imshow(HSI(:,:,3)); title("ETAPA 0 - Canal I imagem HSI","fontsize",5);

//Etapa 1 - Equalização do canal I
I = EqualizacaoI(HSI);
figure; imshow(I); title("ETAPA 1 - Canal I equalizado","fontsize",5);

//Etapa 2 - Segmentação da imagem do canal I
[imagem_seg_1,imagem_seg_2] = Segmentacao(I);
//figure; imshow(imagem_seg_1); title("ETAPA 2 - imagem_seg_1","fontsize",5);
//figure; imshow(imagem_seg_2); title("ETAPA 2 - imagem_seg_2","fontsize",5);

//Etapa 3 - Aplicar filtro morfológico nas duas imagens imagem_seg
imagem_seg_1 = FiltroMorfologico(imagem_seg_1, 1, 0);
imagem_seg_2 = FiltroMorfologico(imagem_seg_2, 0, 1);
figure; imshow(imagem_seg_1); title("ETAPA 3 - imagem_seg_2 após filtro","fontsize",5);
figure; imshow(imagem_seg_2); title("ETAPA 3 - imagem_seg_2 após filtro","fontsize",5);

//Etapa 4 - Compor vetor de características (Entropia, Dimensão Fractal e )
caracteristicas = ConstruirVetor(imagem_seg_1,imagem_seg_2,I,caracteristicas,1);

