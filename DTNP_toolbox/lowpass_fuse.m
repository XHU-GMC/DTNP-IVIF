function [cp,map]=lowpass_fuse(matrixA,matrixB)
%%
DTNP_A=DTNP((abs(matrixA)),110);
DTNP_B=DTNP((abs(matrixB)),110);
%%
map=(DTNP_A>=DTNP_B);
%%
cp=map.*matrixA+~map.*matrixB;