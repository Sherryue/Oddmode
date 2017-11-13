% Plot \Gamma_1D/\Gamma^prime for groupmt 20171115

clear; clc;
%%
Width = 10:10:10;
gp = 6:10:26;
Ratio = zeros(length(gp),length(Width));

figure; hold on;

for kw = 1:length(Width)    
    load(['Teven_W',num2str(Width(kw)),'_gp']);
    ke_even = fit_para(:,3);
    ki = fit_para(:,1);
    load(['tOdd_W',num2str(Width(kw)),'_gp']);
    ke_odd = fit_para(:,3);
    Ratio(:,kw) = ke_even./(ki+ke_odd);
    plot(gp, Ratio(:,kw),'o--')
end

xlabel('Gap (\mum)');ylabel('\Gamma_{1D} / \Gamma^\prime')
