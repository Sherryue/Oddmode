clear; clc;

%%

% Names = ['P45_r1_00_L12k';'P45_r0_95_L12k';'P45_r0_90_L12k';'P45_r0_85_L12k';'P45_r0_75_L12k';'P45_r0_65_L12k';'P45_r0_55_L12k';'P45_r0_45_L12k';'P45_r0_35_L12k';'P45_r0_25_L12k'];
% Names = ['P45_r0_25_004k';'P45_r0_25_008k';...
%     'P45_r0_25_L16k';'P45_r0_25_L20k';'P45_r0_25_L24k';'P45_r0_25_L28k';...
%     'P45_r0_25_L32k';'P45_r0_25_L36k';'P45_r0_25_L40k';'P45_r0_25_L44k';'P45_r0_25_L48k';'P45_r0_25_L52k';'P45_r0_25_L56k';...
%     'P45_r0_25_L60k';'P45_r0_25_L64k';'P45_r0_25_L68k';'P45_r0_25_L72k';'P45_r0_25_L76k';...
%     'P45_r0_25_L08k';'P45_r0_25_L81k';'P45_r0_25_L82k';'P45_r0_25_L83k';'P45_r0_25_L84k';'P45_r0_25_L85k';'P45_r0_25_L86k';'P45_r0_25_L87k';'P45_r0_25_L88k';'P45_r0_25_L89k';'P45_r0_25_L09k';...
%     'P45_r0_25_L92k';'P45_r0_25_L94k';'P45_r0_25_L96k';'P45_r0_25_L98k';'P45_r0_25_L10k';...
%     'P45_r0_25_102k';'P45_r0_25_104k';'P45_r0_25_106k';'P45_r0_25_108k';'P45_r0_25_110k';...
%     'P45_r0_25_112k';'P45_r0_25_114k';'P45_r0_25_116k';'P45_r0_25_118k';'P45_r0_25_L12k'];
% Names = ['P500r1_00_L02k';'P500r1_00_L04k';'P500r1_00_L06k';'P500r1_00_L08k';'P500r1_00_L10k';'P500r1_00_L14k';'P500r1_00_L16k'];
Names = ['P700r1_00_L02k';'P1000r1_0_L02k';'P1700r1_0_L02k'];
[Num,~] = size(Names);
S_paramet = zeros((Num),4);
for ki = 1:Num
    S = sparameters([Names(ki,:),'.s2p']);
    S_paramet(ki,1) = S.Parameters(1,1);
    S_paramet(ki,2) = S.Parameters(1,2);
    S_paramet(ki,3) = S.Parameters(2,1);
    S_paramet(ki,4) = S.Parameters(2,2);
end

% Ratio = [1;0.95;0.9;0.85;0.75;0.65;0.55;0.45;0.35;0.25];
% Distance = [0.4;0.8;[1.6:0.4:7.6].';8;8.1;8.2;8.3;8.4;8.5;8.6;8.7;8.8;8.9;9;[9.2:0.2:12].'];   %kum
% Distance = [2;4;6;8;10;14;16];
PanelWid = [700;1000;1700];
figure; plot(PanelWid,10.*log(abs(S_paramet(:,3))),'o');
xlabel('Ratio of ground plane width');ylabel('|S_{21}| (dB)');
