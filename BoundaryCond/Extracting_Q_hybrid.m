clear; clc;

% % Specify the name of s2p first
% Names = ['Even_bx1500y5000_gp06';'Even_bx1500y5000_gp16';'Even_bx1500y5000_gp26';'Even_bx1500y5000_gp36';'Even_bx1500y5000_gp46';'Even_bx1500y5000_gp50'];
% [Num,~] = size(Names);
% % S = sparameters([Names(1,:),'.s2p']);
% % Leng = length(S.Frequencies);
% % S11 = zeros(Leng, Num);
% % S12 = zeros(Leng, Num);
% % S21 = zeros(Leng, Num);
% % S22 = zeros(Leng, Num);
% gap = str2num(Names(:,20:21));  %need to be changed with different file names

gap = [98:2:112].'; %50,124,150:100:350,550:100:850 %even 50,150:100:550,750, 850
% Toddn 600, 1000:200:1600,2000:200:2200
% Xeven05u 50:100:150, 350:100:550, 750, 850
Num = length(gap);
Pref = 'Xmon_fullysym_VariL';
Sufx = num2str(gap);
Sufx(1,1) = '0';
Names = [repmat(Pref,Num,1),Sufx];
fit_para = zeros(Num, 5,3);  %kp_i, f_r, kp_e, fano, offset
Ci_para = zeros(Num, 6,3);   %confidence interval for the above three
Base_trans = zeros(Num,1);

%% fitting Mag
for ki = 1:Num
    S = sparameters([Pref,num2str(gap(ki)),'.s2p']);
    %     S = sparameters(['test2','.s2p']);
    % fitting Magnitude
    %     S11(:,ki) = (permute(S.Parameters(1,1,:),[3,2,1]));
    %     S12(:,ki) = (permute(S.Parameters(1,2,:),[3,2,1]));
    %     S21(:,ki) = (permute(S.Parameters(2,1,:),[3,2,1]));
    %     S22(:,ki) = (permute(S.Parameters(2,2,:),[3,2,1]));
    xdata0 = abs(S.Frequencies)./1e9;
    ydata0 = abs(permute(S.Parameters(2,1,:),[3,2,1]));
    %     xdata_1h = xdata(1:903);
    %     xdata_2h = xdata(904:1250);
    %     xdata_3h = xdata(1251:length(S.Frequencies));
    %     ydata_1h = ydata1(1:903);
    %     ydata_2h = ydata1(904:1250);
    %     ydata_3h = ydata1(1251:length(S.Frequencies));
    Point = [0, 903, 1250, length(S.Frequencies)];
    
    for kh = 1:3
        
        xdata = xdata0((Point(kh)+1):Point(kh+1));
        ydata1 = ydata0((Point(kh)+1):Point(kh+1));
        Base_trans(ki) = ydata1(1);
        t_est = ydata1(1);
        %     xdata = xdata(200:800);
        %     ydata1 = ydata1(200:800);
        
        [~,ind_min] = min(ydata1);
        f_min = xdata(ind_min);
        
        %     fun1 = @(x, xdata) (x(5).*(x(1).^2+4.*((xdata-x(2))-x(4)).^2)./((x(1)+x(3)).^2+4.*((xdata-x(2))).^2)).^(1);
        %     %x(1) kappa_i/2pi, x(2) f_0, x(3) kappa_e/2pi, x(4) Fano parameter, x(5) global offset;
        %     x0 = [3.68e-5, f_min, 1.27e-4, 0, 1];    %need to be changed! weakercp[0, 7.972432, 2e-6]; gap200[0, 7.9606892, 3e-7]
        
        fun1 = @(x, xdata) ((x(4).*(x(1)+x(3))-2.*x(5).*(xdata-x(2))-x(3)).^2+(2.*x(4).*(xdata-x(2))+x(5).*(x(1)+x(3))).^2)./...
            ((x(1)+x(3)).^2+4.*(xdata-x(2)).^2);
        % x(1) kappa_i/2pi, x(2) f_0, x(3) kappa_e/2pi, x(4) Real(t), x(5)
        % Imag(t)
        x0 = [3.68e-5, f_min, 1e-4, real(t_est), imag(t_est)]; % ke 1.27e-4
        
        %     z0 = 34.7;
        %     fun1 = @(x, xdata) (1./(1+(1./xdata./x(4)).^2)).*((x(1)-z0.*(xdata-x(2))./xdata./x(4)).^2+(-z0.*x(1)./(xdata.*x(4))+2.*(xdata-x(2))).^2)./...
        %         ((x(1)+x(3)-z0.*(xdata-x(2))./xdata./x(4)).^2+(-z0.*x(1)./xdata./x(4)+2.*(xdata-x(2))).^2);
        %     x0 = [3.68e-5, f_min, 2e-4,1e9];%1./(2*pi*8e9*sqrt(1./abs(t_est).^2-1))
        
        [x1,resnorm,residual,exitflag,output,lambda,J] = lsqcurvefit(fun1, x0, xdata, ydata1.^2);
        
        fit_para(ki,:,kh) = abs(x1);
        
        alphaP = 0.01;
        ci = nlparci(x1,residual,'jacobian',J,'alpha',alphaP);
        Ci_para(ki,1:2,kh) = ci(1,:);
        Ci_para(ki,3:4,kh) = ci(2,:);
        Ci_para(ki,5:6,kh) = ci(3,:);
        
        %     MAGS21_fit = sqrt(x1(5).*(x1(1).^2+4.*((xdata-x1(2))-x1(4)).^2)./((x1(1)+x1(3)).^2+4.*((xdata-x1(2))).^2));
        MAGS21_fit = sqrt(((x1(4).*(x1(1)+x1(3))-2.*x1(5).*(xdata-x1(2))-x1(3)).^2+(2.*x1(4).*(xdata-x1(2))+x1(5).*(x1(1)+x1(3))).^2)./...
            ((x1(1)+x1(3)).^2+4.*(xdata-x1(2)).^2));
        %     MAGS21_fit = sqrt((1./(1+(1./xdata./x1(4)).^2)).*((x1(1)-z0.*(xdata-x1(2))./xdata./x1(4)).^2+(-z0.*x1(1)./(xdata.*x1(4))+2.*(xdata-x1(2))).^2)./...
        %         ((x1(1)+x1(3)-z0.*(xdata-x1(2))./xdata./x1(4)).^2+(-z0.*x1(1)./xdata./x1(4)+2.*(xdata-x1(2))).^2));
        %         figure; %plot(xdata, 10.*log10(permute(S.Parameters(1,1,:),[3,2,1])))
        %         plot(xdata, 20.*log10(MAGS21_fit));
        %         hold on; plot(xdata, 20.*log10(ydata1), '--');
        %         xlabel('Frequency (GHz)')
        %         ylabel('Mag(S21) (dB)')
    end
end
for kh = 1:3
    figure (1);hold on; errorbar(gap, fit_para(:,2,kh), fit_para(:,2,kh)-Ci_para(:,3,kh),fit_para(:,2,kh)-Ci_para(:,4,kh),'d');
    figure(2);hold on; errorbar(gap, fit_para(:,1,kh), fit_para(:,1,kh)-Ci_para(:,1,kh),fit_para(:,1,kh)-Ci_para(:,2,kh),'d');
    figure(3);hold on; errorbar(gap, fit_para(:,3,kh), fit_para(:,3,kh)-Ci_para(:,5,kh),fit_para(:,3,kh)-Ci_para(:,6,kh),'d');
end

% DbBrg_data = fit_para;
% load('Todd_W8_D')
% save('Todd_W8_D', 'fit_para', 'gap','DbBrg_data');

% figure; plot(gap,20.*log10(Base_trans),'o');

% figure; errorbar(gap, fit_para(:,2), fit_para(:,2)-Ci_para(:,3),fit_para(:,2)-Ci_para(:,4),'o--');
% figure; errorbar(gap, fit_para(:,1), fit_para(:,1)-Ci_para(:,1),fit_para(:,1)-Ci_para(:,2),'o--');
% figure; errorbar(gap, fit_para(:,3), fit_para(:,3)-Ci_para(:,5),fit_para(:,3)-Ci_para(:,6),'o--');

% gap = 350;
% figure (1);hold on; errorbar(gap, fit_para(:,2), fit_para(:,2)-Ci_para(:,3),fit_para(:,2)-Ci_para(:,4),'d');
% figure(2);hold on; errorbar(gap, fit_para(:,1), fit_para(:,1)-Ci_para(:,1),fit_para(:,1)-Ci_para(:,2),'d');
% figure(3);hold on; errorbar(gap, fit_para(:,3), fit_para(:,3)-Ci_para(:,5),fit_para(:,3)-Ci_para(:,6),'d');

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