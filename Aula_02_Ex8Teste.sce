//Escreva um programa capaz de fornecer o histograma de uma imagem
//dada como entrada. Em seguida, considere as imagens obtidas a partir
//do exercício 7 e aplique sobre cada uma os ruídos aditivos: sal e
//pimenta; uniforme, gaussiano e poisson (pesquisar sobre o
//comportamento deste ruído). As distribuições devem ser fornecidas
//pelo usuário. Após este processo, verifique o resultado obtido em cada
//imagem verificando possíveis alterações dos histogramas. Indique quais
//os tipos de dispositivos que podem inserir nas imagens os ruídos
//estudados.

//Lendo nome da imagem de teste
//name = input('Nome da imagem (ex: balao.png):','s');

imagem = imread('teste.png');

//Lendo número de linhas e colunas da imagem teste
linhas = 465;//input('Número de linhas da imagem  :','s');
colunas = 620;//input('Número de colunas da imagem:','s');

//Transformando a imagem teste para níveis de cinza para criação do histograma
imagem_cinza = rgb2gray(imagem);

//Criando histograma
for k=1:256
    histograma(k) = 0;
end

for i=1:linhas
    for j=1:colunas
        indice = double(imagem_cinza(i,j)) + 1;
        histograma(indice) = histograma(indice) + 1;
    end
end


//Printando imagens e histograma
figure; imshow(imagem);
figure; imshow(imagem_cinza);
figure; bar(histograma);
