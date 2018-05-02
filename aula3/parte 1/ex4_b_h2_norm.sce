//CÁLCULO DE REALCE E AGUÇAMENTO: MÁSCARA h2 NORMALIZADA

//lendo imagens e capturando dimensões
img = imread("D:\github\PDI\aula3\teste.png");
[x,y] = size(img);

h2 = [-1, -1, -1;
      -1, 8, -1;
      -1, -1, -1];

maskGeradora = [0, 0, 0;
                0, 9, 0;
                0, 0, 0];

soma = 0;

printf("MATRIZ ORIGINAL:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img(i,j));
    end
    printf("\n");
end

//MÁSCARA 3x3 REALCE
img1 = img;

printf("\n");

//cálculo do detector de altas frequências (h2 normalizado)
for i=1:x
    for j=1:y
        if x-i >= 2 & y-j >= 2 then
            for m=i:i+2
                for n=j:j+2
                    soma = soma + double(img(m,n))*(h2(m-i+1,n-j+1));
                end
            end
            img1(i+1,j+1) = round((abs(soma))/9);
        end
        soma = 0;
    end
end

printf("MATRIZ H2 NORMALIZADA:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img1(i,j));
    end
    printf("\n");
end

//MÁSCARA 3x3 GERADORA
img2 = img;
soma = 0;

printf("\n");

//cálculo da geração de mesma imagem
for i=1:x
    for j=1:y
        if x-i >= 2 & y-j >= 2 then
            for m=i:i+2
                for n=j:j+2
                    soma = soma + double(img(m,n))*(maskGeradora(m-i+1,n-j+1));
                end
            end
            
            img2(i+1,j+1) = round((abs(soma))/9);
        end
        soma = 0;
    end
end

printf("MATRIZ GERADORA DE MESMA IMAGEM:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img2(i,j));
    end
    printf("\n");
end

//Soma dos dois filtros
img3 = img;

printf("MATRIZ DE AGUÇAMENTO:\n");
for i=1:x
    for j=1:y
        img3(i,j) = img1(i,j) + img2(i,j);
        printf("[%d] ", img3(i,j));
    end
    printf("\n");
end

img3 = rgb2gray(img3);

//Escritas de imagem em arquivo
imshow(img3);
