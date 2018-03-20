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
figure;imshow(a);
figure;imshow(b);
figure;imshow(c);
figure;imshow(d);
figure;imshow(e);

//Printando taxa de amostragem das imagens (x * y)
[x,y,z] = size(a); disp(x*y,'Taxa de amostragem imagem a:');
[x,y,z] = size(b); disp(x*y,'Taxa de amostragem imagem b:');
[x,y,z] = size(c); disp(x*y,'Taxa de amostragem imagem c:');
[x,y,z] = size(d); disp(x*y,'Taxa de amostragem imagem d:');
[x,y,z] = size(e); disp(x*y,'Taxa de amostragem imagem e:');

//Printando quantização NÃO SEI AINDA

