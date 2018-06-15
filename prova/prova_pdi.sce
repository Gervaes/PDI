imgInput = imread("teste.png");

//--------------------------------------------- Conversão RGB >> HSI ---------------------------------------------

rgb = double(imgInput)/255;

//dividindo os canais
r = rgb(:, :, 1);
g = rgb(:, :, 2);
b = rgb(:, :, 3);

//cálculo de theta (padrão)
n = 0.5*((r - g) + (r - b));
d = sqrt((r - g)^2 + (r - b)*(g - b));
theta = acos(n/d + 0.000001); //essa adição é feita para evitar divisão por 0

//cálculo de H (matiz)
//H = theta se b <= g
//H = 360 - theta se b > g
if b <= g then
    H = theta;
else
    H = 360 - theta;
end

//normalizando entre 0~1
H = H/360;

//cálculo de S (saturação)
//S = 1 - ((3 / (r + g + b)) * min(r,g,b))
n = (min(r,g,b))*3;
d = r + g + b;
S = 1 - (n/d + 0.000001);

//cálculo de I (intensidade)
//I = 1/3 * (r + g + b)
I = d/3;

hsi = zeros(size(rgb));
hsi = cat(3, H, S, I);

figure;
imshow(rgb);

figure;
imshow(hsi);

//--------------------------------------------- Equalização de canal I ---------------------------------------------
