clear; clc;

S = sparameters(['171027_mm_squiggleX_Res5G_12_OddmatchedZ0','.s2p']);

xdata = abs(S.Frequencies)./1e9;
ydata1 = abs(permute(S.Parameters(2,1,:),[3,2,1]));
ydata2 = abs(permute(S.Parameters(1,1,:),[3,2,1]));

figure; plot(xdata, 20.*log10(ydata1));
hold on; plot(xdata, 20.*log10(ydata2));