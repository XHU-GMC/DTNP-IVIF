function  Result = analysis_Reference(image_f,image_ir,image_vis)
disp("Qabf MI FMI MS_SSIM EN")
[s1,s2] = size(image_ir);
imgSeq = zeros(s1, s2, 2);
imgSeq(:, :, 1) = image_ir;
imgSeq(:, :, 2) = image_vis;
image1 = im2double(image_ir);
image2 = im2double(image_vis);
image_fused = im2double(image_f);
Result=zeros(1,5);
%Qabf
Result(1,1) = analysis_Qabf(image1,image2,image_fused);
%MI
Result(1,2) = analysis_MI(image_ir,image_vis,image_f);
%FMI
Result(1,3) = analysis_fmi(image1,image2,image_fused);
%[MS_SSIM,t1,t2]= analysis_ms_ssim(imgSeq, image_f);
Result(1,4) = analysis_ms_ssim(imgSeq, image_f);
%EN
Result(1,5)= entropy(image_fused);
end







