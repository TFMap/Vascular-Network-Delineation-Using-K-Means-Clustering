% Retinal vessel segmentation using  K-means combined with difference image using Gaussian and Mean Filter 
mkdir ('Single_Kmeans_Another');
img = imread('01_test.tif');
BW10 = imread('1BW.tif');
im = img(:,:,2);

ws=13;

  tm=0;
if (tm~=0 && tm~=1)
    error('tm must be 0 or 1.');
end


if tm==0
    mIM= imfilter(im,fspecial('gaussian',[ws ws],6));
    mIM2=imfilter(im,fspecial('average',ws),'replicate');
else
    mIM= imfilter(im,fspecial('average',ws),'replicate');
    mIM2=medfilt2(im,[ws ws]);
end
sIM=mIM-im;
sIM2=mIM2-im;
sIM3=sIM2 + sIM;

[mu,mask]=ki_mean(sIM,10);
[mu2,mask2]=ki_mean(sIM2,10);
mask = mat2gray(mask);
mask2 = mat2gray(mask2);
mask = mask - BW10;
mask2 = mask2 - BW10;
mask3 = mask2 + mask;
BW5 = bwareaopen(mask,25,8);
BW52 = bwareaopen(mask2,25,8);
BW5 = medfilt2(BW5, [2 2]);
BW52 = medfilt2(BW52, [2 2]);
BW5 = imfilter(BW5,fspecial('unsharp'),'replicate');
BW52 = imfilter(BW52,fspecial('unsharp'),'replicate');
BW5 = BW5 - BW10;
BW52 = BW52 - BW10;
BW55 = BW5 + BW52;
fi= 'Gs_Avg6_1_2.tif';
figure, imshow(mask3);  title('Segmentation Result');
imwrite(mask3,['Single_Kmeans_Another\' fi]);
