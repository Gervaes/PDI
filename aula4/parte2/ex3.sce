//lendo imagens
img1 = imread('D:\github\PDI\aula4\parte2\img1.bmp');
img2 = imread('D:\github\PDI\aula4\parte2\img2.bmp');
img3 = imread('D:\github\PDI\aula4\parte2\img3.bmp');

[x,y] = size(img1);

//conversão de RGB para HSI
imgAux = img1;
scale = 256;

for i=1:x
    for j=1:y
        aux = double(double(imgAux(i,j))/double(scale));
        imgAux(i,j) = aux;
        printf("%.5f", imgAux(i,j));
    end
    printf("\n");
end
