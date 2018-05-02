//lendo imagens e capturando dimensões
img = imread("D:\github\PDI\aula3\teste.png");
[x,y] = size(img);

maskAltaFreq = [-1, -1, -1;
                -1, 8, -1;
                -1, -1, -1];
                

//acumulador da soma da janela
soma = 0;
soma2 = 0;

printf("MATRIZ ORIGINAL:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img(i,j));
    end
    printf("\n");
end

//MÁSCARA 3x3
img1 = img;

printf("\n");

//cálculo da média
for i=1:x
    for j=1:y
        if x-i >= 2 & y-j >= 2 then
            for m=i:i+2
                for n=j:j+2
                    soma2 = soma;
                    soma = soma + double(img(m,n))*(maskAltaFreq(m-i+1,n-j+1));
                    printf("%d + %d  = %d\n", soma2, double(img(m,n))*(maskAltaFreq(m-i+1,n-j+1)), soma);
                end
            end
            
            img1(i+1,j+1) = abs(soma);
            printf("\n");
        end
        soma = 0;
    end
end

for i=1:x
    for j=1:y
        printf("[%d] ", img1(i,j));
    end
    printf("\n");
end

//Escritas de imagem em arquivo
imshow(img1);
