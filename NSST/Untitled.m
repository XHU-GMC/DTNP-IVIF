clc;
close all;
clear all;
path(path,'FusionEvaluation/')
A=imread('v1.jpg');
B=imread('i1.jpg');
A=rgb2gray(A);
B=rgb2gray(B);
A=mat2gray(A);
B=mat2gray(B);
m=size(A,1);
n1=size(A,2);
%A=double(ori_A);
%B=double(ori_B;
%% Parameters for NSST
pfilt = '9-7';
shear_parameters.dcomp=[3 3 4 5];
shear_parameters.dsize=[32 32 16 16];
%% Parameters for PCNN
Para1.iterTimes=100;
Para1.link_arrange=3;
Para1.alpha_L=1;
Para1.alpha_Theta=0.8;
Para1.beta=zeros(m,n1);
%Para1.beta=3;
Para1.vL=1.0;
Para1.vTheta=20;
Para.iterTimes=100;
Para.link_arrange=3;
Para.alpha_L=1;
Para.alpha_Theta=0.8;
Para.beta=zeros(m,n1);
%Para.beta=3;
Para.vL=1.0;
Para.vTheta=20;
%% NSCT分解 
disp('Decompose the image via nsst ...')
[yA,shear_f1]=nsst_dec1(A,shear_parameters,pfilt)
[yB,shear_f2]=nsst_dec1(B,shear_parameters,pfilt)
n = length(yA);
Fused=yA;
%% 低频融合
disp('Process in Lowpass subband...')
%E1=[-1 2 -1;-1 2 -1;-1 2 -1];
%E2=[-1 0 -1;0 4 0;-1 0 -1];
%E3=[-1 -1 -1;2 2 2;-1 -1 -1];
W=[1 2 1;2 4 2;1 2 1];
VarA=zeros(m,n);
VarB=VarA;
VAL=VarB;
VBL=VAL;
S1=VBL;
S2=S1;
F1=S2;
F2=F1;
W1=F1;
W2=W1;
sfa=W2;
sfb=sfa; 
ALow=yA{1};
BLow=yB{1};
%ALow=abs(ALow);
%BLow=abs(BLow);
AL=quyu(ALow);
BL=quyu(BLow);
sfa=SF(ALow);
sfb=SF(BLow);
%Var1=var(ALow(:));
%Var2=var(BLow(:));
%Para.beta=sfa;
%Para1.beta=sfb;
for i=1:m
    for j=1:n1
        AL1=AL{i,j};
        BL1=BL{i,j};
        %W1(i,j)=sum(sum((W.*AL1).^2));
        %W2(i,j)=sum(sum((W.*BL1).^2));
        %F1(i,j)=var(AL1(:))/Var1;
        %F2(i,j)=var(BL1(:))/Var2;
        %sfa(i,j)=SF(AL1);
        %sfb(i,j)=SF(BL1);
        [Ua,Sa,Va]=svd(AL1);
        [Ub,Sb,Vb]=svd(BL1);
        S1=sum(Sa(:))/3;
        S2=sum(Sb(:))/3;
        %S1=1./(1+exp(-S1));
        %S2=1./(1+exp(-S2));
        Para.beta(i,j)=S1;
        Para1.beta(i,j)=S2;        
    end
end
%W1=1./(1+exp(-W1));
%W2=1./(1+exp(-W2));
        %Para.beta=W1;
        %Para1.beta=W2;
[xx,w]=fusion_NSCT_PCNN(sfa,sfb,Para,Para1);
Fused{1}=w.*ALow+~w.*BLow;
disp('Low frequecy field process is ended')
%% 高频融合
disp('Process in bandpass subband...')
for l = 2:n
    for d = 1:length(yA{l}(1,1,:))
       Ahigh = yA{l}(:,:,d);
       Bhigh = yB{l}(:,:,d);
       Ah=quyu(Ahigh);
       Bh=quyu(Bhigh);
       SFA=SF(Ahigh);
       SFB=SF(Bhigh);
       for i=1:m
            for j=1:n1
        Ah1=Ah{i,j};
        Bh1=Bh{i,j};
        [Ua,Sa,Va]=svd(Ah1);
        [Ub,Sb,Vb]=svd(Bh1);
        S1=sum(Sa(:))/3;
        S2=sum(Sb(:))/3;
        %S1=1./(1+exp(-S1));
        %S2=1./(1+exp(-S2));
        Para.beta(i,j)=S1;
        Para1.beta(i,j)=S2;
                %Ah2=Ah1{i,j};
                %Bh2=Bh1{i,j}; 
            %Para.beta(i,j)=var(Ah2(:));
            %Para1.beta(i,j)=var(Bh2(:));
            end
       end
        switch 'PCNN'
            case 'PCNN'
                %Fused{l}(:,:,d)=fusion_NSCT_PCNN(Ahigh,Bhigh,Para,Para1);
                [xxh,wh]=fusion_NSCT_PCNN(SFA,SFB,Para,Para1);
                Fused{l}(:,:,d)=wh.*Ahigh+~wh.*Bhigh;
            case 'ML-PCNN'
                Fused{l}{d}=fusion_NSCT_SF_PCNN(Ahigh,Bhigh,Para);
                
        end
    end
end
disp('High frequecy field process is ended')
disp('Reconstruct the image via nsct ...')
F=nsst_rec1(Fused,pfilt);
disp('Reconstruct is ended...')
%%
F=F*255;
F(F<0)=0;
disp('F>255')
F(F>255)=255;
F=round(F);
figure,imshow(F,[])
imwrite(uint8(F), 'NSST-PCNN.bmp')