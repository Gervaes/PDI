//lendo imagens e capturando dimensões
img = imread("C:\Users\Grrv\Desktop\PDI\aula3\parte 1\teste.png");
img = rgb2gray(img);
[rows,columns] = size(img);

function []=PrintMatrix(rows,columns,image)
    for i=1:rows
        for j=1:columns
            printf("[%d] ", image(i,j));
        end
        printf("\n");
    end
endfunction

function [image]=Smoothing(w)
    soma = 0;
    image = img;
    
    for i=1:rows
        for j=1:columns
            if rows-i >= w-1 & columns-j >= w-1 then
                for m=i:i+w-1
                    for n=j:j+w-1
                        soma = double(soma + double(img(m,n)));
                    end
                end
                media = round(soma/(w*w));
                image(i+floor(w/2),j+floor(w/2)) = media;
                soma = 0;
            end
        end
    end
endfunction

//MATRIZ ORIGINAL
printf("MATRIZ ORIGINAL:\n");
PrintMatrix(rows,columns,img);

//MÁSCARA 3x3
img3x3 = Smoothing(3);
printf("MATRIZ COM MÁSCARA 3x3:\n");
PrintMatrix(rows,columns,img3x3);

//MÁSCARA 5x5
img5x5 = Smoothing(5);
printf("MATRIZ COM MÁSCARA 5x5:\n");
PrintMatrix(rows,columns,img5x5);

//MÁSCARA 7x7
img7x7 = Smoothing(7);
printf("MATRIZ COM MÁSCARA 7x7:\n");
PrintMatrix(rows,columns,img7x7);

figure; imshow(img);
figure; imshow(img3x3);
figure; imshow(img5x5);
figure; imshow(img7x7);
