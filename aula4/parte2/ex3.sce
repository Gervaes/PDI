//ler imagem, converter para HSI (hue, saturation, intensity) e aplicar equalização de histograma

//lendo imagens
imgTeste = imread('D:\github\PDI\aula4\parte2\teste.png');
//img1 = imread('D:\github\PDI\aula4\parte2\img1.bmp');
//img2 = imread('D:\github\PDI\aula4\parte2\img2.bmp');
//img3 = imread('D:\github\PDI\aula4\parte2\img3.bmp');

[x,y] = size(imgTeste);

//conversão de RGB para HSI
imgAux = imgTeste;
scale = 256;

//1) RGB entre 0~1
for i=1:x
    for j=1:y
        aux2(i,j) = double(double(imgTeste(i,j))/double(scale));
    end
end

printf("Valor teste (posição 1x1): %.5f\n", aux2(1,1));

//2) Máximo e mínimo de RGB
maior = 0;
menor = 256;

for i=1:x
    for j=1:y
        if aux2(i,j) > maior then
            maior = aux2(i,j);
        elseif aux2(i,j) < menor then
            menor = aux2(i,j);
        end
    end
end

printf("maior: %.5f\n", maior);
printf("menor: %.5f\n", menor);

//3) Cálculo de luminância
L = double(double(maior + menor)/double(2));
printf("L = %.3f\n", L);

//4) Sim, todas as imagens possuem saturação (são coloridas)

//5)Cálculo de saturação
//If Luminance is smaller then 0.5, then Saturation = (max-min)/(max+min)
//If Luminance is bigger then 0.5. then Saturation = ( max-min)/(2.0-max-min)

if L < 0.5 then
    S = double(double(maior-menor)/double(maior+menor));
else
    S = double(double(maior-menor)/double(2-maior+menor));
end

printf("S = %.3f\n", S);

//6) Cálculo de hue

