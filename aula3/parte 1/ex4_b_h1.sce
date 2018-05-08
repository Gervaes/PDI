//CÁLCULO DE REALCE E AGUÇAMENTO: MÁSCARA h1 NÃO-NORMALIZADA

//lendo imagens e capturando dimensões
img = imread("C:\Users\Grrv\Desktop\PDI\aula3\parte 1\teste.jpg");
img = rgb2gray(img);
[rows,columns] = size(img);

h1 = [0, -1, 0;
      -1, 8, -1;
      0, -1, 0];

maskGeradora = [0, 0, 0;
                0, 9, 0;
                0, 0, 0];

function []=PrintMatrix(rows,columns,image)
    for i=1:rows
        for j=1:columns
            printf("[%d] ", image(i,j));
        end
        printf("\n");
    end
endfunction

function [image]=Agucamento()
    for i=1:rows
        for j=1:rows
            image(i,j) = detector(i,j) + geradora(i,j);
        end
    end
endfunction

function [image]=MascaraGeradora(w)
    soma = 0;
    image = img;
    
    for i=1:rows
        for j=1:columns
            if rows-i >= w-1 & columns-j >= w-1 then
                for m=i:i+w-1
                    for n=j:j+w-1
                        soma = double(soma + double(img(m,n))*(maskGeradora(m-i+1,n-j+1)));
                    end
                end
                image(i+floor(w/2),j+floor(w/2)) = abs(soma);
                soma = 0;
            end
        end
    end
endfunction

//cálculo do detector de altas frequências (h1 não-normalizado)
function [image]=Detector(w)
    soma = 0;
    image = img;
    
    for i=1:rows
        for j=1:columns
            if rows-i >= w-1 & columns-j >= w-1 then
                for m=i:i+w-1
                    for n=j:j+w-1
                        soma = double(soma + double(img(m,n))*(h1(m-i+1,n-j+1)));
                    end
                end
                image(i+floor(w/2),j+floor(w/2)) = abs(soma);
                soma = 0;
            end
        end
    end
endfunction

printf("MATRIZ ORIGINAL:\n");
PrintMatrix(rows,columns,img);

//detector
printf("MATRIZ H1 NÃO-NORMALIZADA:\n");
detector = Detector(3);
PrintMatrix(rows,columns,detector);

//geradora
printf("MATRIZ GERADORA DE MESMA IMAGEM:\n");
geradora = MascaraGeradora(3);
PrintMatrix(rows,columns,geradora);

//Soma dos dois filtros
printf("MATRIZ DE AGUÇAMENTO:\n");
final = Agucamento();
PrintMatrix(rows,columns,final);

//Escritas de imagem em arquivo
figure; imshow(img);
figure; imshow(detector);
figure; imshow(geradora);
figure; imshow(final);
