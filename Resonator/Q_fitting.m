clear; clc;
%save('Qubit_Test_beforeopt','ANGS11','ANGS12','ANGS21','ANGS22','MAGS11','MAGS12','MAGS21','MAGS22','FrequencyGHz');
Matname = 'Qubit_Test_gap200.mat';
load(Matname);

%%
ydata1 = (MAGS21.^2).^(0.01);
xdata = FrequencyGHz;
ydata2 = ANGS21;

%% fitting Magnitude
fun1 = @(x, xdata) ((x(1).^2+4.*((xdata-x(2))).^2)./((x(1)+x(3)).^2+4.*((xdata-x(2))).^2)).^(0.01);
%x(1) kappa_i/2pi, x(2) f_0, x(3) kappa_e/2pi;
x0 = [0, 7.9606892, 3e-7];    %need to be changed! weakercp[0, 7.972432, 2e-6]; gap200[0, 7.9606892, 3e-7]
[x1,resnorm,residual,exitflag,output,lambda,J] = lsqcurvefit(fun1, x0, xdata, ydata1);
alphaP = 0.01;
ci = nlparci(x1,residual,'jacobian',J,'alpha',alphaP);
MAGS21_fit = sqrt((x1(1).^2+4.*((xdata-x1(2))).^2)./((x1(1)+x1(3)).^2+4.*((xdata-x1(2))).^2));
figure; plot(xdata, 10.*log10(MAGS21_fit));
hold on; plot(xdata, 10.*log10(MAGS21), '--');
xlabel('Frequency (GHz)')
ylabel('Mag(S21) (dB)')

%% fitting angle
fun2 = @(x, xdata) (atan(2.*(xdata-x(2))./x(1))-atan(2.*(xdata-x(2))./(x(1)+x(3))))./pi.*180+x(4);
%x(4) offset
x0 = [x1,-20];
x2 = lsqcurvefit(fun2, x0, xdata, ydata2);
ANGS21_fit = (atan(2.*(xdata-x2(2))./x2(1))-atan(2.*(xdata-x2(2))./(x2(1)+x2(3))))./pi.*180+x2(4);
figure; plot(xdata, ANGS21_fit);
hold on; plot(xdata, ANGS21, '--');

%save(Matname,'ANGS11','ANGS12','ANGS21','ANGS22','MAGS11','MAGS12','MAGS21','MAGS22','FrequencyGHz','x1','x2');