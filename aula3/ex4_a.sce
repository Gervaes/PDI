//lendo imagens e capturando dimensões
img = imread("D:\github\PDI\aula3\teste.png");
[x,y] = size(img);

//acumulador da soma da janela
soma = 0;

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
                    soma = int32(soma + img1(m,n));
                end
            end
            media = round(soma/9);
            img1(i+1,j+1) = media;
            soma = 0;
        end
    end
end

printf("MATRIZ COM MÁSCARA 3x3:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img1(i,j));
    end
    printf("\n");
end

soma = 0;

//MÁSCARA 5x5
img2 = img;

printf("\n");

//cálculo da média
for i=1:x
    for j=1:y
        if x-i >= 4 & y-j >= 4 then
            for m=i:i+4
                for n=j:j+4
                    soma = int32(soma + img2(m,n));
                end
            end
            media = round(soma/25);
            img2(i+2,j+2) = media;
            soma = 0;
        end
    end
end
soma = 0;

printf("MATRIZ COM MÁSCARA 5x5:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img2(i,j));
    end
    printf("\n");
end

//MÁSCARA 7x7
img3 = img;

printf("\n");

//cálculo da média
for i=1:x
    for j=1:y
        if x-i >= 6 & y-j >= 6 then
            for m=i:i+6
                for n=j:j+6
                    soma = int32(soma + img3(m,n));
                end
            end
            media = round(soma/49);
            img3(i+3,j+3) = media;
            soma = 0;
        end
    end
end

printf("MATRIZ COM MÁSCARA 7x7:\n");
for i=1:x
    for j=1:y
        printf("[%d] ", img3(i,j));
    end
    printf("\n");
end

