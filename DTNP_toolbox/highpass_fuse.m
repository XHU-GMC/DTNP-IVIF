function [cp,map]=highpass_fuse(matrixA,matrixB)
% ---------
map = abs(matrixA) >= abs(matrixB);
%%
cp=map.*matrixA+~map.*matrixB;