//Leitura da imagem

mammogram = imread('D:\github\PDI\artigo\mammogram.png');
mammogram = rgb2gray(mammogram);

//image size
[rows,columns] = size(mammogram);
w = 3; //window
u = 0.3; //k
R = 1;

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
    value = double(LM(i,j)*(1+(u*(double(SD(i,j)/(R))-1))));
endfunction

//local mean m(i,j) = Is(i+w/2,j+w/2) + Is(i-w/2,j-w/2)- Is(i+w/2,j-w/2) - Is(i-w/2,j+w/2)

function [value]=LocalMeanx(i,j)
    value = 0;
    value = double(value);
    if i > 1 then
    end
    m(i,j) = II(i+w/2,j+w/2) + II(i-w/2,j-w/2)- II(i+w/2,j-w/2) - II(i-w/2,j+w/2);
endfunction

function [value]=LocalMean(i,j)
    value = 0;
    count = 0;
    value = double(value);
    for k=ceil(i-w/2):i+w/2
        for l=ceil(j-w/2):j+w/2
            if k >=1 & k < rows+1 & l >= 1 & l < columns+1 then
                value = value + double(mammogram(k,l));
                count = count + 1;
            end
        end
    end
    
    value = double(value/(count));
endfunction

//standard deviation s²(i,j) = 1/w² EE I²(k,l) - m²(i,j) 
//                                  ^^(Somatórios com k=i-w/2 até i+w/2 
//                                                    l=j-w/2 até j+w/2 )
function [value]=StardardDeviation(i,j)
    value = 0;
    count = 0;
    value = double(value);
    for k=ceil(i-w/2):i+w/2
        for l=ceil(j-w/2):j+w/2
            if k >= 1 & l >= 1 & k < rows+1 & l < columns+1 then
                value = value + double(double(mammogram(k,l))*double(mammogram(k,l)));
                count = count + 1;
            end
        end
    end

    value = double(double(value)/double(count));
    value = value - double(floor(LM(i,j))*floor(LM(i,j)));
    if(value > 0) then sqrt(double(value));
    else value = 0; end
endfunction

//Integral image(i,j) = EE I(k,l)
//                      ^^(Somatórios de k=0 até i e l=0 até j)
function [value]=IntegralImage(i,j)
    value = 0;
    value = double(value);
    value = double(value + double(mammogram(k,l)));
    if k > 1 & l > 1 then
         value = double(value - double(II(k-1,l-1)));
    end
    if k > 1 then
        value = double(value + double(II(k-1,l)));
    end
    if l > 1 then
        value = double(value + double(II(k,l-1)));
    end
    value = double(value);
endfunction

//mammogram = [100,90,80
//             100,90,70
//              90,80,70]

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
for k=1:rows
    for l=1:columns
        II(k,l) = IntegralImage(k,l);
        mprintf('%7i ',II(k,l));
    end
    mprintf('\n');
end

//Calculating LocalMean for the whole image with window size 3 and putting it on the LM matrix  
mprintf('\nLocalMean:\n');
for k=1:rows
    for l=1:columns
        LM(k,l) = round(LocalMean(k,l));
        mprintf('%10.2f ',LM(k,l));
    end
    mprintf('\n');
end

//Calculating StandardDeviation for the whole image
mprintf('\nStandartDeviation:\n');
for k=1:rows
    for l=1:columns
        SD(k,l) = double(round(StardardDeviation(k,l)));
        mprintf('%10.2f ',SD(k,l));
    end
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
mprintf('\nR = %10.2f\n',R);

//Calculating Threshold for the whole image
mprintf('\nThreshold:\n');
for k=1:rows
    for l=1:columns
        TH(k,l) = double(round(Threshold(k,l)));
        mprintf('%10.2f ',TH(k,l));
    end
    mprintf('\n');
end

//Binarization
mprintf('\nBinarization:\n');
for k=1:rows
    for l=1:columns
        B(k,l) = Binarization(k,l);
        mprintf('%10i ',B(k,l));
    end
    mprintf('\n');
end

//figure;
//imshow(mammogram);
//figure;
//imshow(B);

//inicialização do processo de suavização de contorno usando morfologia matemática (operação fechamento: dilatação e depois erosão)
      
x = rows+6;
y = columns+6;

//criação de matriz extendida com borda de 3px, para aplicar o elemento estruturante
for i=1:x
    for j=1:y
        imgExt(i,j) = 0;
    end
end

for i=4:(x-3)
    for j=4:(y-3)
        imgExt(i,j) = B(i-3,j-3);
    end
end

//se a origem do elemento estruturante pertencer ao objeto, realiza a união entre objeto e elemento (dilatação)
for i=1:x
    for j=1:y
        imgExt2(i,j) = 0;
    end
end

for k=4:(x-3)
    for l=4:(y-3)
        if imgExt(k,l) == 255 then
            for m=(k-3):(k+3)
                for n=(l-3):(l+3)
                    imgExt2(m,n) = 255;
                end
            end
        end
    end
end

//Dilatada
//figure;
//imshow(imgExt2);

count = 0;

//erosão
for k=4:(x-3)
    for l=4:(y-3)
        if imgExt2(k,l) == 255 then
            for m=(k-3):(k+3)
                for n=(l-3):(l+3)
                    if imgExt2(m,n) == 255 then
                        count = count + 1;
                    end
                end
            end
         end
         if count == 49 then
             for m=(k-3):(k+3)
                for n=(l-3):(l+3)
                    if imgExt2(m,n) == imgExt2(k,l) then
                        imgExt3(m,n) = 255;
                    else
                        imgExt3(m,n) = 0;
                    end
                end
            end
        else
            for m=(k-3):(k+3)
                for n=(l-3):(l+3)
                    imgExt3(m,n) = 0;
                end
            end
        end
        count = 0;
    end
end

//Erodida
//figure;
//imshow(imgExt3);

//------------------------Processo de extração de borda---------------------------
for i=1:x
    for j=1:y
        imgExt4(i,j) = 0;
    end
end

count = 0;

//processo por dilatação ((A+B)-A)
for k=2:(x-1)
    for l=2:(y-1)
        if imgExt3(k,l) == 255 then
            for m=(k-1):(k+1)
                for n=(l-1):(l+1)
                    imgExt4(m,n) = 255;
                end
            end
        end
    end
end

//figure;
//imshow(imgExt4);

for i=1:x
    for j=1:y
        contorno(i,j) = imgExt4(i,j) - imgExt3(i,j);
    end
end

figure;
imshow(contorno);

//cálculo de DFT
count = 1;

printf("\nVetor de DFT: ");

//calcula os coeficientes para toda a matriz
dftVec = fft(contorno);

//cada ponto com valor 1 recebe seu valor correspondente em um vetor
for i=1:x
    for j=1:y
        if contorno(i,j) == 255 then
            v(count) = dftVec(i,j);
            printf("%d ", v(count));
            count = count + 1;
        end
    end
end

plot(v);

//for i=1:count
//    nComplex(i) = 0;
//end
//
//count = 0;
//
////calculando vetor de números complexos
//for i=1:x
//    for k=1:y
//        if contorno(i,j) == 255 then
//            nComplex(count) = complex(i,j);
//            count = count + 1;
//        end
//    end
//end
//
//dftVec = fft(contorno);
