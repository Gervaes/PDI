//1 -

//2 - 200x300cm² 
//    0.1mm no x e 0.2mm no y 
//    200/0.1 = 2000 e 300/0.2 = 1500 
//    portanto a imagem é de 2000x1500

//3 - 8192 cinzas = 2^13 cinzas 
//    13 bits para representar 8192 níveis de cinza
//    portanto a profundidade em bits é 13

//4 - 256 níveis de cinza = 2^8
//    8 bits pra representar cada pixel
//    1024x1024 = 1.048.576 pixels
//    1.048.576 x 10 (8 pixels de representação + 2 de inicio e fim) = 10.485.760 bits
//    10.485.760/9.600 = 1.092,26 segundos para enviar a foto toda

//5 - 

//6 - Amostragem = quantos pixels foram usados para representar a área desejada
//    Quantização = quantos bits foram usados pra representar a luminância em cada pixel

//7 - 

//Leitura das imagens
a = imread('a.jpg');
b = imread('b.jpg');
c = imread('c.jpg');
d = imread('d.jpg');
e = imread('e.jpg');

//Printando imagens
//figure; imshow(a);
//figure; imshow(b);
//figure; imshow(c);
//figure; imshow(d);
//figure; imshow(e);

//Printando taxa de amostragem das imagens (x * y)
[x,y] = size(a); 
printf("Taxa de amostragem imagem a: %d\n", x*y);
[x,y] = size(b); 
printf("Taxa de amostragem imagem b: %d\n", x*y);
[x,y] = size(c); 
printf("Taxa de amostragem imagem c: %d\n", x*y);
[x,y] = size(d); 
printf("Taxa de amostragem imagem d: %d\n", x*y);
[x,y] = size(e); 
printf("Taxa de amostragem imagem e: %d\n", x*y);

//Printando quantização NÃO SEI AINDA
B = [-1, -1, -1, -1, -1, -1, -1, -1];
aux = -1;
aux2 = 0;
count = 0;

for i=1:x
    for j=1:y
        if aux <> a(i,j) then 
            for k=1:8
                if a(i,j) == B(k) then continue;
                else
                    for l=1:8
                        if B(l) == -1 & aux2 <> 1 then
                            B(l) = a(i,j);
                            count=count+1;
                            aux2 = 1;
                        end
                    end
                end
            end
        end
        aux = a(i,j);
        aux2 = 0;
    end
end

printf("Taxa da quantização imagem a: %d\n", count);

B = [-1, -1, -1, -1, -1, -1, -1, -1];
aux = -1;
aux2 = 0;
count = 0;

for i=1:x
    for j=1:y
        if aux <> b(i,j) then 
            for k=1:8
                if b(i,j) == B(k) then break;
                else
                    for l=1:8
                        if B(l) == -1 & aux2 <> 1 then
                            B(l) = b(i,j);
                            count=count+1;
                            aux2 = 1;
                        end
                    end
                end
            end
        end
        aux = b(i,j);
        aux2 = 0;
    end
end

printf("Taxa da quantização imagem b: %d\n", count);

B = [-1, -1, -1, -1, -1, -1, -1, -1];
aux = -1;
aux2 = 0;
count = 0;

for i=1:x
    for j=1:y
        if aux <> c(i,j) then 
            for k=1:8
                if c(i,j) == B(k) then break;
                else
                    for l=1:8
                        if B(l) == -1 & aux2 <> 1 then
                            B(l) = c(i,j);
                            count=count+1;
                            aux2 = 1;
                        end
                    end
                end
            end
        end
        aux = c(i,j);
        aux2 = 0;
    end
end

printf("Taxa da quantização imagem c: %d\n", count);

B = [-1, -1, -1, -1, -1, -1, -1, -1];
aux = -1;
aux2 = 0;
count = 0;

for i=1:x
    for j=1:y
        if aux <> d(i,j) then 
            for k=1:8
                if d(i,j) == B(k) then break;
                else
                    for l=1:8
                        if B(l) == -1 & aux2 <> 1 then
                            B(l) = d(i,j);
                            count=count+1;
                            aux2 = 1;
                        end
                    end
                end
            end
        end
        aux = d(i,j);
        aux2 = 0;
    end
end

printf("Taxa da quantização imagem d: %d\n", count);

B = [-1, -1, -1, -1, -1, -1, -1, -1];
aux = -1;
aux2 = 0;
count = 0;

for i=1:x
    for j=1:y
        if aux <> e(i,j) then 
            for k=1:8
                if e(i,j) == B(k) then break;
                else
                    for l=1:8
                        if B(l) == -1 & aux2 <> 1 then
                            B(l) = e(i,j);
                            count=count+1;
                            aux2 = 1;
                        end
                    end
                end
            end
        end
        aux = e(i,j);
        aux2 = 0;
    end
end

printf("Taxa da quantização imagem e: %d\n", count);
B = [-1, -1, -1, -1, -1, -1, -1, -1];
aux = -1;
aux2 = 0;
count = 0;
