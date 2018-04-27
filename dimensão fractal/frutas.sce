img = imread('C:\Users\Grrv\Desktop\frutas.jpg');
img = rgb2gray(img);

/*
img=[22,22,22,95,167,234,234,234,
    22,22,22,95,167,234,234,234,
    22,22,22,95,167,234,234,234,
    22,22,22,95,167,234,234,234];
*/
[rows,columns] = size(img);

if rows > columns then
    L = columns;
else
    L = rows;
end

function []=Entropia(L)
    //Zerando vetor histograma
    for k=1: 256
        qtdL(k) = 0;
    end
    
    //Preenchendo vetor histograma
    for i=1: L
        for j=1: L
            qtdL(img(i,j)+1) = qtdL(img(i,j)+1) + 1;
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

while L > 1,
    x = floor(rows/L);
    y = floor(columns/L);
    for i=1:x
        for j=1:y
            Entropia(L,x,y);
        end
    end
    
    mprintf("H=%7.5f",H);
    
    L = (L/2);
end

figure;
bar(qtdL);

figure;
imshow(img);

