clear; %clc;

abcd = abcdparameters('Odd_cfg3_bx2000y4000_ct10_w299.s2p');
d = 2000;    %micron

A_para =  rfparam(abcd,'A');
B_para =  rfparam(abcd,'B');
D_para =  rfparam(abcd,'D');

beta = acos((A_para+D_para)./2)./d;
Z = abs(B_para./(sqrt((A_para).^2-1)));

% figure; 
% plot(abcd.Frequencies./1e9,real(beta));    %imag of beta is small
% xlabel('Frequency (GHz)');ylabel('\beta (/um)');
% figure; 
% plot(abcd.Frequencies./1e9, Z);
% xlabel('Frequency (GHz)');ylabel('Z (\Omega)');
