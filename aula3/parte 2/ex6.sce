//Gerar e apresentar histogramas, normais e equalizados

//leitura das imagens
a = imread('C:\Users\Grrv\Desktop\PDI\aula3\parte 1\1.bmp');
b = imread('C:\Users\Grrv\Desktop\PDI\aula3\parte 2\2.bmp');
c = imread('C:\Users\Grrv\Desktop\PDI\aula3\parte 2\3.tif');
d = imread('C:\Users\Grrv\Desktop\PDI\aula3\parte 2\4.bmp');

//captura de dimensões da img
[rows,columns] = size(a);

//cálculo do número de pixels da img
t = double(rows*columns);

//definição inicial do maior valor como 0
maior = 0;

//constante de escala de cinza
scale = 256;

//zerando vetores histograma e probabilidade
for i=1:scale
    prob(i) = double(0);
end

for i=1:scale
    hist(i) = double(0);
end

//1a etapa = calculando histograma (e maior nivel) e probabilidade
for i=1:rows
    for j=1:columns
        //mprintf("(%i,%i)=%i\n",i,j,a(i,j));
        index = double(double(a(i,j)) + 1);
        hist(index) = double(hist(index) + 1);
        if a(i,j) > maior then
            maior = a(i,j);
        end
    end
end

mprintf("\nMAIOR=%i\n",maior);

for i=1:scale
    prob(i) = double(double(hist(i))/double(t));
end
    
//2a etapa = cálculo de FDA
mprintf("\nFDA\n");
for i=1:scale
    if i > 1 then
        FDA(i) = double(FDA(i-1) + double(prob(i)));
    else
        FDA(i) = double(prob(i));
    end
    mprintf("%7.5f\n",FDA(i));
end

//aproximação de níveis (3ª etapa)
for i=1:scale
    equal(i) = round(double(double(FDA(i))*double(maior)));
end

//exibindo histogramas

figure; imshow(a);
figure; bar(hist);
figure; bar(equal);
