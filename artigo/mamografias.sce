//Leitura da imagem

mammogram = imread('C:\Users\Grrv\Desktop\PDI\artigo\teste.png');
mammogram = rgb2gray(mammogram);

//Dimensões da imagem
columns = 15;
rows = 15;

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
    value = double(double(LM(i,j))*(1+(u*((double(SD(i,j))/(double(R)))-1))));
endfunction

//local mean m(i,j) = Is(i+w/2,j+w/2) + Is(i-w/2,j-w/2)- Is(i+w/2,j-w/2) - Is(i-w/2,j+w/2)
function [value]=LocalMean(i,j)
    value = 0;
    value = double(value);
    //Tratamento pra não haver acesso em índice que não existe
    if i+w/2 < rows+1 & j+w/2 < columns+1 then value = value + II(i+w/2,j+w/2); end
    if i-w/2 >= 1     & j-w/2 >= 1        then value = value + II(i-w/2,j-w/2); end
    if i+w/2 < rows+1 & j-w/2 >= 1        then value = value - II(i+w/2,j-w/2); end
    if i-w/2 >= 1     & j+w/2 < columns+1 then value = value - II(i-w/2,j+w/2); end
    
    //Dividing by the number of items in the window to know the LocalMean
    value = double(value/(w*w));
endfunction

//standard deviation s²(i,j) = 1/w² EE I²(k,l)-m²(i,j) 
//                                  ^^(Somatórios com k=i-w/2 até i+w/2 
//                                                    l=j-w/2 até j+w/2 )
function [value]=StardardDeviation(i,j)
    value = 0;
    value = double(value);
    for k=i-w/2:i+w/2
        for l=j-w/2:j+w/2
            if k >= 1 & l >= 1 & k < rows+1 & l < columns+1
                value = value + double(double(mammogram(k,l))*double(mammogram(k,l)));
            end
        end
    end

    value = double(double(value)/double(w*w));
    value = value - double(double(LM(i,j))*double(LM(i,j)));
endfunction

//Integral image(i,j) = EE I(k,l)
//                      ^^(Somatórios de k=0 até i e l=0 até j)
function [value]=IntegralImage(i,j)
    value =0;
    value = double(value);
    for k=1:i
        for l=1:j
            value = value + double(mammogram(k,l));
        end
    end
    value = double(value);
endfunction

w = 3; //window
u = 0.2; //[0.2,0.5] starting with 0.2
R = 1;

//Teste de cada função separadamente
//mammogram = [10,20,30,40;
//             40,30,20,10;
//             20,40,10,30;
//             30,10,40,20]

//Displaying Input image
mprintf('\nInputImage:\n');
for k=1:rows
    for l=1:columns
        mprintf('%7i ',mammogram(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Calculating IntegralImage for the whole image and putting it on the II matrix
mprintf('\nIntegralImage:\n');
II = double(II);
for k=1:rows
    for l=1:columns
        II(k,l) = IntegralImage(k,l);
        mprintf('%7i ',II(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Calculating LocalMean for the whole image with window size 3 and putting it on the LM matrix  
mprintf('\nLocalMean:\n');
for k=1:rows
    for l=1:columns
        LM(k,l) = LocalMean(k,l);
        mprintf('%7i ',LM(k,l));
    end
    //mprintf('(%i,%i)\n',k,l);
    mprintf('\n');
end

//Calculating StandardDeviation for the whole image
mprintf('\nStandartDeviation:\n');
SD = double(SD);
for k=1:rows
    for l=1:columns
        SD(k,l) = StardardDeviation(k,l);
        mprintf('%7i ',SD(k,l));
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
TH = double(TH);
for k=1:rows
    for l=1:columns
        TH(k,l) = double(Threshold(k,l));
        mprintf('%5i ',TH(k,l));
    end
    mprintf('\n');
end

//Binarization
mprintf('\nBinarization:\n');
for k=1:rows
    for l=1:columns
        B(k,l) = double(Binarization(k,l));
        mprintf('%5i ',B(k,l));
    end
    mprintf('\n');
end

figure;
imshow(mammogram);
figure;
imshow(B);

/*
//Visualizando histograma
for k=1:256
    histograma(k) = 0;
end

for i=1:rows
    for j=1:columns
        //if teste(i,j) > 2 then 
            indice = double(mammogram(i,j) + 1);
            histograma(indice) = histograma(indice) + 1;
        //end 
    end
end

figure;
bar(histograma);

figure;
imshow(mammogram);
*/




