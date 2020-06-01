clear all;
close all;
clc;%先清空已有图像

pc0 = pcread('1577430571.313388824.pcd');%pcd文件读入
pcshow(pc0)
xlabel('x');
ylabel('y');
zlabel('z');

% roi = [-10 10 -10 10 -10 10]
roi =  [2 4 -1 1 -1.2 0];%选取区域,选取的是放大的部分
indices = findPointsInROI(pc0,roi);
pc = select(pc0,indices);

figure;
pcshow(pc);  %图中读出initial points 
title('ptCloud');
xlabel('x');
ylabel('y');
zlabel('z');

maxDistance = 0.03 ;%拟合时允许的最大距离
[model1,inlierIndices,outlierIndices] = pcfitplane(pc,maxDistance);
plane1 = select(pc,inlierIndices);
remainPtCloud = select(pc,outlierIndices);
% figure('name','平面1');
% pcshow(plane1);
% %xlim([-2 0]);%设置范围和标注
% xlabel('x');
% %ylim([-4 7]);
% ylabel('y');
% %zlim([-2 2]);
% zlabel('z');
% title('plane1');%标注结束，缩小范围便于观察
% hold on
% plot(model1)

[model2,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud,maxDistance);
plane2 = select(remainPtCloud,inlierIndices);%对left points再找一个平面
remainPtCloud2 = select(remainPtCloud,outlierIndices);
% figure('name','平面2');
% pcshow(plane2);
% %xlim([-1.8 1.4]);%设置范围和标注
% xlabel('x');
% %ylim([-1.5 1]);
% ylabel('y');
% %zlim([-0.7 0.5]);
% zlabel('z');
% title('plane2');
% hold on
% plot(model2);

[model3,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud2,maxDistance);
plane3 = select(remainPtCloud2,inlierIndices);%对left points再找一个平面
remainPtCloud3 = select(remainPtCloud2,outlierIndices);
% figure('name','平面3');
% pcshow(plane3);
% %xlim([-1.8 1.4]);%设置范围和标注
% xlabel('x');
% %ylim([-1.5 1]);
% ylabel('y');
% %zlim([-0.7 0.5]);
% zlabel('z');
% title('plane3');
% hold on
% plot(model3);

% [model4,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud3,maxDistance);
% plane4 = select(remainPtCloud3,inlierIndices);%对left points再找一个平面
% remainPtCloud4 = select(remainPtCloud3,outlierIndices);
% figure('name','平面4');
% pcshow(plane4);
% %xlim([-1.8 1.4]);%设置范围和标注
% xlabel('x');
% %ylim([-1.5 1]);
% ylabel('y');
% %zlim([-0.7 0.5]);
% zlabel('z');
% title('plane4');
% hold on
% plot(model4);

% [model5,inlierIndices,outlierIndices] = pcfitplane(remainPtCloud4,maxDistance);
% plane5 = select(remainPtCloud4,inlierIndices);%对left points再找一个平面
% remainPtCloud5 = select(remainPtCloud4,outlierIndices);
% % figure('name','平面5');
% % pcshow(plane5);
% % xlabel('x');
% % ylabel('y');
% % zlabel('z');
% % title('plane5');
% % hold on
% % plot(model5,'Color','green');

figure;
pcshow(pc);  
title('final');
xlabel('x');
ylabel('y');
zlabel('z');
hold on
plot(model1,'Color','yellow');
plot(model2,'Color','red');
plot(model3,'Color','green');
% plot(model4,'Color','c');
% plot(model5,'Color','m');
figure;
%pcshow(remainPtCloud3);
%title('others');
b = [-model1.Parameters(1,4);-model2.Parameters(1,4);-model3.Parameters(1,4)];
A = [model1.Normal;model2.Normal;model3.Normal];
x = A\b 
roi1= roi';
n1 = model1.Normal; %规定三平面的法向量
n2 = model2.Normal;
n3 = model3.Normal;
d1 = model1.Parameters(1,4); %三个平面的ax+by+cz+d=0的d
d2 = model2.Parameters(1,4);
d3 = model3.Parameters(1,4);

