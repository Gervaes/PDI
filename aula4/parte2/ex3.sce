//lendo imagens
imgTeste = imread('D:\github\PDI\aula4\parte2\teste.png');
//img1 = imread('D:\github\PDI\aula4\parte2\img1.bmp');
//img2 = imread('D:\github\PDI\aula4\parte2\img2.bmp');
//img3 = imread('D:\github\PDI\aula4\parte2\img3.bmp');

[x,y] = size(imgTeste);

//conversão de RGB para HSI
imgAux = imgTeste;
scale = 256;

for i=1:x
    for j=1:y
        aux2(i,j) = double(double(imgTeste(i,j))/double(scale));
    end
end

printf("Valor teste (posição 1x1): %.5f\n", aux2(1,1));
