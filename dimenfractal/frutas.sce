//img = imread('C:\Users\Grrv\MatLab\PDI\prova\frutas.jpg');
//img = rgb2gray(img);


// IMAGEM DO EXERCÍCIO
img=[22,22,22,95,167,234,234,234,
     22,22,22,95,167,234,234,234,
     22,22,22,95,167,234,234,234,
     22,22,22,95,167,234,234,234];


/*
img = [1,1,1,1,1,1,1,1,
       1,1,1,1,1,1,1,1,
       1,1,1,1,1,1,1,1,
       1,1,1,1,1,1,1,1,
       2,2,2,2,2,2,2,2,
       2,2,2,2,2,2,2,2,
       2,2,2,2,2,2,2,2,
       2,2,2,2,2,2,2,2];

*/

/*
// IMAGEM COM ENTROPIA MÁXIMA
count = 0;
for i=1:16
    for j=1:16
        img(i,j) = count;
        mprintf("%3i ",count);
        count = count + 1;
    end
    mprintf("\n");
end
*/

[rows,columns] = size(img);

//CALCULAR ENTROPIA DA IMAGEM

//Escolhendo L como MIN(rows,columns)
if rows > columns then
    L = columns;
else
    L = rows;
end

//Calculando entropia para certo L
function [H]=Entropia(L,x,y)
    //Zerando vetor histograma
    for k=1: 256
        qtdL(k) = 0;
    end
    
    //Preenchendo vetor histograma
    for i=(((x-1)*L)+1):x*L
        for j=(((y-1)*L)+1):y*L
            qtdL(double(double(img(i,j))+1)) = qtdL(double(double(img(i,j))+1)) + 1;
        end
    end
    
    //Preenchendo vetor Pi
    for k=1: 256
        Pi(k) = double(qtdL(k) / (L*L));
    end
    
    H=0;
    //Entropia
    for k=1: 256
        if Pi(k) <> 0 then
            H = H + (Pi(k)*log2(Pi(k)));
        end
    end
    
    //Multiplicando entropia por -1
    H = H*(-1);
endfunction

//Variando L e chamando função entropia
mprintf("\n\nValores de Janela (L) e Entropia (H) para a imagem associada\n\n");
while L > 1,
    H = 0;
    mprintf("para L = %i a entropia é H = ",L);
    x = floor(rows/L);
    y = floor(columns/L);
    for i=1:x
        for j=1:y
            H = H + Entropia(L,i,j);
        end
    end
    
    H = (H/(x*y));
    mprintf("%7.5f\n",H);

    L = floor(L/2);
end

//CALCULAR DIMENSÃO FRACTAL DA IMAGEM

//Escolhendo L como MIN(rows,columns,maior intensidade)

if rows > columns then
    L = columns;
else
    L = rows;
end

MI = 0;
for i=1:rows
    for j=1:columns
        if MI < img(i,j) then
            MI = img(i,j);
        end
    end
end

if L > MI then
    L = MI;
end

//Calculando total de  para certo L
function [BoxQtdd]=Contagem(L,x,y)
    MI = 0;
    //Achar maior intensidade na janela
    for i=(((x-1)*L)+1):x*L
        for j=(((y-1)*L)+1):y*L
            if MI < img(i,j) then
                MI = img(i,j);
            end
        end
    end
    
    mprintf(" %i/%i=",MI,L);
    //Calcular quantidade de caixas
    BoxQtdd = ceil(MI/L);
    mprintf("%i ",BoxQtdd);
endfunction

mprintf("\n\n Valores de Box (L) e número de caixas necessárias para a imagem associada\n\n");
while L > 1,
    BoxQtdd = 0;
    mprintf("para L = %i o número necessário de caixas é = ",L);
    x = floor(rows/L);
    y = floor(columns/L);
    mprintf("(%i/%i)=%i",rows,L,x);
    for i=1:x
        for j=1:y
            BoxQtdd = BoxQtdd + Contagem(L,i,j);
        end
    end
    
    mprintf("%i\n",BoxQtdd);

    L = floor(L/2);
end
//scatter(xplot,yplot);

//figure;
//imshow(img);

