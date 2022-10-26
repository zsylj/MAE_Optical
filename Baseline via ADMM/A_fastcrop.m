close all;
clear;clc;

temp_list=["1011CarNew","1011RunningNew","1012CatNew","1012DophinNew","1012Pica","1012WindmillNew"];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
patch_list=[8,12,14,16,24,32];
crop_mat=[0,0,432,288;0,0,456,288;0,0,448,280;0,0,448,272;0,0,456,288;0,0,448,288];

for i = 1:6
    mkdir(strcat("Data\",temp_list(i)));
    for j = 1:6
        mkdir(strcat("Data",temp_list(i),"\",num2str(patch_list(j))));
        path=strcat('E:\BaiduNetdiskDownload\20221023_1530MaskAndPic\',temp_list(i),'\',num2str(patch_list(j)));%%%%%%%%%%%%%%%%%%%%%%%%%
        file_list = dir(path);
        file_list = file_list(3:end);

        img_list=strings([length(file_list),1]);
        for k=1:length(file_list)
            folder=convertCharsToStrings(file_list(k).name);
            img_list(k) = folder;
        end

        for k=1:length(file_list)
            orig_img=imread(path+"\"+img_list(k));
            cropped_img=imcrop(orig_img,crop_mat(j,:));
            imwrite(cropped_img,strcat("Data\",temp_list(i),"\",num2str(patch_list(j)),"\",img_list(k)));
        end
    end
end