//Lendo imagens
a = imread('a.jpg');
b = imread('b.jpg');
c = imread('c.jpg');
d = imread('d.jpg');
e = imread('e.jpg');

//Transformando imagem pra matriz de double
a=im2double(a);
b=im2double(b);
c=im2double(c);
d=im2double(d);
e=im2double(e);

a=matrix(a(:), size(a));
b=matrix(b(:), size(b));
c=matrix(c(:), size(c));
d=matrix(d(:), size(d));
e=matrix(e(:), size(e));

//Media e variância
media = 0;
variancia = 0.01;

//Aplicando ruído
old_rand_gen=rand('info');
rand('normal');
    
ag = a + sqrt(variancia)*rand(a) + media; 
rand(old_rand_gen);

bg = b + sqrt(variancia)*rand(b) + media; 
rand(old_rand_gen);

cg = c + sqrt(variancia)*rand(c) + media; 
rand(old_rand_gen);

dg = d + sqrt(variancia)*rand(d) + media; 
rand(old_rand_gen);

eg = e + sqrt(variancia)*rand(e) + media; 
rand(old_rand_gen);

//Criando histogramas das imagens com ruído

for k=1:256
    ah(k) = 0;
    bh(k) = 0;
    ch(k) = 0;
    dh(k) = 0;
    eh(k) = 0;
end

for i=1:256
    for j=1:256
        indice = double(asp(i,j)) + 1;
        ah(indice) = ah(indice) + 1;
        indice = double(bsp(i,j)) + 1;
        bh(indice) = bh(indice) + 1;
        indice = double(csp(i,j)) + 1;
        ch(indice) = ch(indice) + 1;
        indice = double(dsp(i,j)) + 1;
        dh(indice) = dh(indice) + 1;
        indice = double(esp(i,j)) + 1;
        eh(indice) = eh(indice) + 1;
    end
end

//Printando imagens
figure; imshow(a);
figure; imshow(ag);
figure; bar(ah);
figure; imshow(b);
figure; imshow(bg);
figure; bar(bh);
figure; imshow(c);
figure; imshow(cg);
figure; bar(ch);
figure; imshow(d);
figure; imshow(dg);
figure; bar(dh);
figure; imshow(e);    
figure; imshow(eg);
figure; bar(eh);
                

