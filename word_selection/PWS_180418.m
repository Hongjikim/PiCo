%% This is for word selection in PiCo (PWS)

%% Basic Settings

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize rec; % rating scale

Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);

basedir = '/Users/hongji/Dropbox/MATLAB_hongji/github_hongji/Pico_v0/word_selction';
cd(basedir); addpath(genpath(basedir));
subject_ID = input('Subject ID?:', 's');
subject_number = input('Subject number?:');    
    
%% Topic randomization, word input
topic = cell(1,5);
topic{1} = '�Դ� ���� Ȥ�� �����';
topic{2} = '��ü�� ��� Ȥ�� ����';
topic{3} = '���� Ȥ�� ����';
topic{4} = '��ȸ�� ����';
topic{5} = '�λ��� ��ǥ Ȥ�� �ǹ�';
topic_rand = randperm(5);

kor_order = [' ù', ' ��', ' ��', ' ��', '�ټ�', '����', '�ϰ�', '����', '��ȩ', ' ��'];
word = cell(5,10);
for i = 1:5
    list(i).topic = topic(topic_rand(i));
    fprintf('%d��° ������ < %s > �Դϴ�.\n', i, char(list(i).topic))
    for j = 1:10
        msg1 = sprintf('%s ��° �ܾ��?', kor_order(2*j-1 : 2*j));
        disp(msg1)
        word{i,j} = input(':', 's');
        list(i).word = word(i,:);
    end
end

%% save the data
% nowtime = clock;
% subjtime = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));
% 
% data.subject = subject_number;
% data.datafile = fullfile(savedir, [subjtime, '_', subject_ID, '_subj', sprintf('%.3d', subject_number), '.mat']);
% data.version = 'PICO_v0_04-16-2018_Cocoanlab';
% data.starttime = datestr(clock, 0);
% data.starttime_getsecs = GetSecs;
% data.trajectory = [xc yc];
% 
% save(data.datafile, 'data');