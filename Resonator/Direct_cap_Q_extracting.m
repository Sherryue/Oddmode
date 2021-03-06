clear; clc;

gap = [24,74,124].';
Num = length(gap);
Pref = 'Odd_eCap_W30_gp';
Sufx = num2str(gap);
Sufx(1,1) = '0';
Names = [repmat(Pref,Num,1),Sufx];
fit_para = zeros(Num, 4);  %kp_i, f_r, kp_e, fano, offset
Ci_para = zeros(Num, 6);   %confidence interval for the above three

%% fitting Mag
for ki = 1:Num
    S = sparameters([Pref,num2str(gap(ki)),'.s2p']);

    xdata = abs(S.Frequencies)./1e9;
    ydata1 = abs(permute(S.Parameters(2,1,:),[3,2,1]));
%     xdata = xdata(200:800);
%     ydata1 = ydata1(200:800);
    
    [Smin,ind_min] = min(ydata1);
    f_min = xdata(ind_min);
    
    
    fun1 = @(x, xdata) (Smin.^2.*((x(1)+x(3)).^2./(x(1).^2+4.*x(4).^2)).*(x(1).^2+4.*((xdata-x(2))-x(4)).^2)./((x(1)+x(3)).^2+4.*((xdata-x(2))).^2)).^(1);
    %x(1) kappa_i/2pi, x(2) f_0, x(3) kappa_e/2pi, x(4) Fano parameter, x(5) global offset;
    x0 = [1e-5, f_min, 0.012, 1e-4];    %need to be changed! weakercp[0, 7.972432, 2e-6]; gap200[0, 7.9606892, 3e-7]
    [x1,resnorm,residual,exitflag,output,lambda,J] = lsqcurvefit(fun1, x0, xdata, ydata1.^2);
    
    fit_para(ki,:) = abs(x1);
    
    alphaP = 0.01;
    ci = nlparci(x1,residual,'jacobian',J,'alpha',alphaP);
    Ci_para(ki,1:2) = ci(1,:);
    Ci_para(ki,3:4) = ci(2,:);
    Ci_para(ki,5:6) = ci(3,:);
    
    MAGS21_fit = sqrt(Smin.^2.*((x1(1)+x1(3)).^2./(x1(1).^2+4.*x1(4).^2)).*(x1(1).^2+4.*((xdata-x1(2))-x1(4)).^2)./((x1(1)+x1(3)).^2+4.*((xdata-x1(2))).^2));
    figure; %plot(xdata, 10.*log10(permute(S.Parameters(1,1,:),[3,2,1])))
    plot(xdata, 10.*log10(MAGS21_fit));
    hold on; plot(xdata, 10.*log10(ydata1), '--');
    xlabel('Frequency (GHz)')
    ylabel('Mag(S21) (dB)')
end

% figure; errorbar(gap, fit_para(:,2), fit_para(:,2)-Ci_para(:,3),fit_para(:,2)-Ci_para(:,4),'o--');
% figure; errorbar(gap, fit_para(:,1), fit_para(:,1)-Ci_para(:,1),fit_para(:,1)-Ci_para(:,2),'o--');
% figure; errorbar(gap, fit_para(:,3), fit_para(:,3)-Ci_para(:,5),fit_para(:,3)-Ci_para(:,6),'o--');

% figure (1);hold on; errorbar(gap, fit_para(:,2), fit_para(:,2)-Ci_para(:,3),fit_para(:,2)-Ci_para(:,4),'o--');
% figure(2);hold on; errorbar(gap, fit_para(:,1), fit_para(:,1)-Ci_para(:,1),fit_para(:,1)-Ci_para(:,2),'o--');
% figure(3);hold on; errorbar(gap, fit_para(:,3), fit_para(:,3)-Ci_para(:,5),fit_para(:,3)-Ci_para(:,6),'o--');

% figure (1);xlabel('Gap (\mum)');ylabel('Resonance frequency (GHz)');
% figure (2);xlabel('Gap (\mum)');ylabel('Intrinsic loss rate (GHz)');
% figure (3);xlabel('Gap (\mum)');ylabel('External coupling rate (GHz)');

% %% fitting angle
% ydata2 = angle(permute(S.Parameters(2,1,:),[3,2,1]));
% fun2 = @(x, xdata) (atan(2.*(xdata-x(2))./x(1))-atan(2.*(xdata-x(2))./(x(1)+x(3))))./pi.*180+x(4);
% %x(4) offset
% x0 = [x1,-20];
% x2 = lsqcurvefit(fun2, x0, xdata, ydata2);
% ANGS21_fit = (atan(2.*(xdata-x2(2))./x2(1))-atan(2.*(xdata-x2(2))./(x2(1)+x2(3))))./pi.*180+x2(4);
% figure; plot(xdata, ANGS21_fit);
% hold on; plot(xdata, ydata2, '--');