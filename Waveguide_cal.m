% clear; clc;
Matname = 'Odd_cfg3w300_z21_73';
Tbl = csvread([Matname,'.csv'],8,0);
d = 1000;    %micron
Z_0 = 50.48;

S11 = Tbl(:,2).*cos(Tbl(:,3)./180.*pi)+1i.*Tbl(:,2).*sin(Tbl(:,3)./180.*pi);
S12 = Tbl(:,4).*cos(Tbl(:,5)./180.*pi)+1i.*Tbl(:,4).*sin(Tbl(:,5)./180.*pi);
S21 = Tbl(:,6).*cos(Tbl(:,7)./180.*pi)+1i.*Tbl(:,6).*sin(Tbl(:,7)./180.*pi);
S22 = Tbl(:,8).*cos(Tbl(:,9)./180.*pi)+1i.*Tbl(:,8).*sin(Tbl(:,9)./180.*pi);

S_para = zeros(length(S11),2,2);
S_para(:,:,1) = [S11, S12];
S_para(:,:,2) = [S21, S22];
S_para1 = permute(S_para,[3,2,1]);
ABCD = s2abcd(S_para1, 50);
ABCD_1 = permute(ABCD,[3,2,1]);
A_para = ABCD_1(:,1,1);
D_para = ABCD_1(:,2,2);
B_para = ABCD_1(:,2,1);
C_para = ABCD_1(:,1,2);

beta = acos((A_para+D_para)./2)./d;
Z = abs(B_para./(sqrt((A_para).^2-1)));
% figure; plot(Tbl(:,1),real(beta)./Tbl(:,1));    %imag of beta is small
% xlabel('Frequency (GHz)');ylabel('\beta (/um)');
% figure; plot(Tbl(:,1), Z);