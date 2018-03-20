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

//Distribuição padrão 10%
dist = 0.10;

old_rand_gen=rand('info');
rand('uniform');

//Aplicando ruído pra imagem a
prob=rand(a);
rand(old_rand_gen);
    
asp=a;
asp(prob < dist/2) = 0;
asp(prob >=dist/2 & prob < dist) = 1;

//Aplicando ruído pra imagem b
prob=rand(b);
rand(old_rand_gen);
    
bsp=b;
bsp(prob < dist/2) = 0;
bsp(prob >=dist/2 & prob < dist) = 1;

//Aplicando ruído pra imagem c
prob=rand(c);
rand(old_rand_gen);
    
csp=c;
csp(prob < dist/2) = 0;
csp(prob >=dist/2 & prob < dist) = 1;

//Aplicando ruído pra imagem d
prob=rand(d);
rand(old_rand_gen);
    
dsp=d;
dsp(prob < dist/2) = 0;
dsp(prob >=dist/2 & prob < dist) = 1;

//Aplicando ruído pra imagem e
prob=rand(e);
rand(old_rand_gen);
    
esp=e;
esp(prob < dist/2) = 0;
esp(prob >=dist/2 & prob < dist) = 1;

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
figure; imshow(asp);
figure; bar(ah);
figure; imshow(b);
figure; imshow(bsp);
figure; bar(bh);
figure; imshow(c);
figure; imshow(csp);
figure; bar(ch);
figure; imshow(d);
figure; imshow(dsp);
figure; bar(dh);
figure; imshow(e);    
figure; imshow(esp);
figure; bar(eh);
                
