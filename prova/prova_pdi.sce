imgInput = imread("teste.png");

//--------------------------------------------- Conversão RGB >> HSI ---------------------------------------------

//normalizando imagem entre 0~1
rgb = double(imgInput)/255;

//captura das dimensões da imagem
[x,y] = size(imgInput);

//dividindo os canais
r = rgb(:, :, 1); //matriz r
g = rgb(:, :, 2); //matriz g
b = rgb(:, :, 3); //matriz b

//cálculo das matrizes H, S e I
for i=1:x
    for j=1:y
        //cálculo de theta (padrão)
        n = 0.5*(r(i,j) - g(i,j) + (r(i,j) - b(i,j)));
        d = sqrt((r(i,j) - g(i,j))^2 + (r(i,j) - b(i,j))*(g(i,j) - b(i,j)));
        theta = acos(n/(d + 0.000001)); //essa adição é feita para evitar divisão por 0
        
        //cálculo de H (matiz)
        //H = theta se b <= g
        //H = 360 - theta se b > g
        if b(i,j) <= g(i,j) then
            H(i,j) = theta;
        else
            H(i,j) = 360 - theta;
        end
        
        //normalizando entre 0~1
        H(i,j) = H(i,j)/360;
        
        //cálculo de S (saturação)
        //S = 1 - ((3 / (r + g + b)) * min(r,g,b))
        n = (min(r(i,j), g(i,j), b(i,j))) * 3;
        d = r(i,j) + g(i,j) + b(i,j);
        S(i,j) = 1 - (n/(d + 0.000001));
        
        //cálculo de I (intensidade)
        //I = 1/3 * (r + g + b)
        I(i,j) = d/3;
    end
end

//concatenação de canais
hsi = cat(3, H, S, I);

//figure;
//imshow(hsi);

//--------------------------------------------- Equalização de canal I ---------------------------------------------

//cálculo do número de pixels da img
t = double(x*y);

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
for i=1:x
    for j=1:y
        index = double(double(I(i,j)) + 1);
        hist(index) = double(hist(index) + 1);
        if I(i,j) > maior then
            maior = I(i,j);
        end
    end
end

//2a etapa = cálculo de FDA
mprintf("\nFDA\n");
for i=1:scale
    if i > 1 then
        FDA(i) = double(FDA(i-1) + double(prob(i)));
    else
        FDA(i) = double(prob(i));
    end
end

//aproximação de níveis (3ª etapa)
for i=1:scale
    equal(i) = round(double(double(FDA(i))*double(maior)));
end

//exibindo histogramas
figure; bar(hist);
figure; bar(equal);

