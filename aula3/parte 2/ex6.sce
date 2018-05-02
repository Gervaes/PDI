//Gerar e apresentar histogramas, normais e equalizados

//leitura das imagens
a = imread('D:\github\PDI\aula4\teste.bmp');
b = imread('D:\github\PDI\aula4\2.bmp');
c = imread('D:\github\PDI\aula4\3.tif');
d = imread('D:\github\PDI\aula4\4.bmp');

//captura de dimensões da img
[x,y] = size(a);

//cálculo do número de pixels da img
t = int32(x*y);

//constante de escala de cinza
scale = 256;

//vetor de 256 para computar probabilidades
m(scale) = 0;
histogram(scale) = 0;

for i=1:scale
    m(i) = 0;
end

aux = 0;

//preenchendo o vetor com probabilidade de cada nível (1ª etapa)
while aux <= scale
    for i=1:x
        for j=1:y
            if aux == a(i,j) then
                m(aux) = m(aux)+1;
            end
        end
    end
    aux = aux+1;
end

histogram = m;

for i=1:scale
    m(i) = double(double(m(i))/double(t));
end

//cálculo de FDA (2ª etapa)
soma = 0;

for i=1:scale
    soma = soma + m(i);
    m(i) = soma;
end

//aproximação de níveis (3ª etapa)
for i=1:scale
    m(i) = round(m(i)*(scale-1));
end

//NÃO SEI PRINTAR 2 HISTOGRAMAS (tem que printar histogram e m)
bar(m);
