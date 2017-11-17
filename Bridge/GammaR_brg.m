% Plot \Gamma_1D/\Gamma^prime for groupmt 20171115

clear; clc;
%%
% Xmon 1um gap0 = [50:100:350, 550, 750, 850];
% Tmon trace gap0 = [400, 500, 600:200:2000];
gap0 = [600:200:2000];
Oddind = [2:9];
Evenind = [1:8];
load('Teven_W8_D');
% Even_DbBrg = DbBrg_data;
ke_even = zeros(length(Oddind),1);
kpi = zeros(length(Oddind),1);
ke_odd = zeros(length(Oddind),1);
% Ratio = ke_even;
for ke = 1:length(Evenind)
    ke_even(ke) = fit_para(Evenind(ke),3);
    kpi(ke) = fit_para(Evenind(ke),1);
end
load('Todd_W8_D');
Odd_DbBrg = DbBrg_data;
for ki = 1:length(Oddind)
    ke_odd(ki) = fit_para(Oddind(ki),3)+fit_para(Oddind(ki),1);
end
Ratio = ke_even./(ke_odd);
% R_DbBrg = Even_DbBrg(3)./(Odd_DbBrg(1)+Odd_DbBrg(3));
R_DbBrg = ke_even(1)./(Odd_DbBrg(1)+Odd_DbBrg(3));

figure; plot(gap0, Ratio,'o--')
% hold on; plot(800, R_DbBrg,'d')


xlabel('Distance (\mum)');ylabel('\Gamma_{1D} / \Gamma^\prime')
