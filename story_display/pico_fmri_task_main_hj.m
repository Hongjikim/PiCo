function pico_fmri_task_main(ts, varargin)



% data�� run, text file name ���� (file name error, duration�ʿ�)
% story text �̸� �־������ run number�� �ĵ� ���� �� �ְ�
% SETUP: time

% data save
basedir = '/Users/hongji/Dropbox/PiCo_git/story_display';
cd(basedir); addpath(genpath(basedir));

subject_ID = input('Subject ID? (P001_KJH):', 's');
% %subject_ID = trim(subject_ID);
% %subject_number = input('Subject number?:', 's');
run_number = input('run number?:');
%subject_ID = 'test_OJW';
%run_number = 4;
savedir = fullfile(basedir, 'Data_PSD');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjdate = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = subject_ID;
data.datafile = fullfile(savedir, [subjdate, '_PICO_', subject_ID, '_run', sprintf('%.2d', run_number), '.mat']);
data.version = 'PICO_v0_05-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

if exist(data.datafile, 'file')
    fprintf('\n ** EXSITING FILE: %s %s **', data.subject, subjdate);
    cont_or_not = input(['\nYou type the run number that is inconsistent with the data previously saved.', ...
        '\nWill you go on with your run number that typed just before?', ...
        '\n1: Yes, continue with typed run number.  ,   2: No, it`s a mistake. I`ll break.\n:  ']);
    if cont_or_not == 2
        error('Breaked.')
    elseif cont_or_not == 1
        save(data.datafile, 'data');
    end
else
    save(data.datafile, 'data');
end

%Filename = {'story_10_PKH.txt', 'story_11_KJH.txt'} ;
Filename = {'sample_1.txt', 'sample_2.txt'} ;
% Filename = input('***** Write the exact file name(Ex. pico_story.txt):', 's');

% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect % lb tb recsize barsize rec; % rating scale
global letter_time period_time comma_time base_time text_color % window_ratio

% display time
letter_time =  0.15*4;   %0.15*4
period_time = 3;
comma_time = 1.5;
base_time = 0;

% Screen setting
bgcolor = 100;
% window_ratio = 1;

text_color = 255;
fontsize = 42; %38?
%fontsize = 24; %30

screens = Screen('Screens');
window_num = screens(end);
Screen('Preference', 'SkipSyncTests', 1);
window_info = Screen('Resolution', window_num);
window_rect = [0 0 window_info.width window_info.height]; %for mac, [0 0 2560 1600];

W = window_rect(3); %width of screen
H = window_rect(4); %height of screen
textH = H/2.3;

white = 255;
red = [189 0 38];
blue = [0 85 169];
orange = [255 164 0];


for s_num = 1:2
    [duration, doubleText, my_length, space_loc, comma_loc, ending_loc, time_interval, data] ...
        = text_duration(Filename, s_num, data);
end
data.text_file_name{1} = Filename{1};
data.text_file_name{2} = Filename{2};

% are you ready?
ready = input(['Check the time. Ready to start with full screen? \n', ...
    '\n1: Yes, continue  ,   2: No,  I`ll break.\n:  ']);
if ready == 2
    error('Breaked.')
end

% %Screen('Preference', 'SkipSyncTests', 1);
% theWindow = Screen('OpenWindow', window_num, bgcolor, window_rect); % start the screen(FULL)

%Screen(theWindow, 'FillRect', bgcolor, window_rect);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], window_rect);%[0 0 2560/2 1440/2]
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font = 'AppleGothic';
Screen('TextFont', theWindow, font);
Screen('TextSize', theWindow, fontsize);
% HideCursor;

% TEXT file - check if it's formatted

% load Text file
for s_num = 1:2
    [duration, doubleText, my_length, space_loc, comma_loc, ending_loc, time_interval, data] ...
        = text_duration(Filename, s_num, data);
    data.total_time{s_num} = sum(duration(:,2));
    
    
    if s_num == 1
        % WAITING FOR INPUT FROM THE SCANNER
        while (1)
            [~,~,keyCode] = KbCheck;
            
            if keyCode(KbName('s'))==1
                break
            elseif keyCode(KbName('q'))==1
                abort_experiment('manual');
            end
            Screen(theWindow, 'FillRect', bgcolor, window_rect);
            ready_prompt = double('�����ڰ� �غ�Ǿ�����, \n �̹�¡�� �����մϴ� (s).');
            DrawFormattedText(theWindow, ready_prompt,'center', 'center', white); %'center', 'textH'
            Screen('Flip', theWindow);
            
        end
        
        % FOR DISDAQ 10 SECONDS
        
        % gap between 's' key push and the first stimuli (disdaqs: data.disdaq_sec)
        % 4 seconds: "�����մϴ�..."
        data.runscan_starttime = GetSecs; % run start timestamp
        Screen(theWindow, 'FillRect', bgcolor, window_rect);
        DrawFormattedText(theWindow, double('�����մϴ�...'), 'center', 'center', white, [], [], [], 1.2);
        Screen('Flip', theWindow);
        sTime_3 = GetSecs;
        while GetSecs - sTime_3 < 10, end % wait 10 seconds for disdaq
        % Blank
        Screen(theWindow,'FillRect',bgcolor, window_rect);
        Screen('Flip', theWindow);
        
        % Start first display
        start_msg = double('ù ��° �̾߱⸦ �����ϰڽ��ϴ�. \n\n ȭ���� �߾ӿ� �ܾ ��Ÿ�� �����̴� ȭ�鿡 �������ּ���. \n\n ���� ���뿡 �ִ��� �������ּ���. ') ;
        DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        sTime_2 = GetSecs;
        while GetSecs - sTime_2 < 5, end % when the story is starting, wait for 5 seconds.
        
    else
        % Start second display
        start_msg = double('�� ��° �̾߱⸦ �����ϰڽ��ϴ�. \n\n ȭ���� �߾ӿ� �ܾ ��Ÿ�� �����̴� ȭ�鿡 �������ּ���. \n\n ���� ���뿡 �ִ��� �������ּ���. ') ;
        DrawFormattedText(theWindow, start_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        sTime_2 = GetSecs;
        while GetSecs - sTime_2 < 5 % when the story is starting, wait for 5 seconds.
        end
    end
    %
    %     data.loop_start_time{s_num} = GetSecs;
    %
    %     for i = 1:my_length
    %         sTime = GetSecs;
    %         data.dat{s_num}{i}.text_start_time = sTime;
    %         msg = doubleText(space_loc(i)+1:space_loc(i+1));
    %         data.dat{s_num}{i}.msg = char(msg);
    %         data.dat{s_num}{i}.duration = duration(i,2);
    %         letter_num = space_loc(i+1) - space_loc(i);
    %         DrawFormattedText(theWindow, msg, 'center', 'center', text_color);
    %         Screen('Flip', theWindow);
    %         while GetSecs - sTime < letter_time + base_time + abs(time_interval(i)) %0.31 %duration(i,2)
    %         end
    %         data.dat{s_num}{i}.text_end_time = GetSecs;
    %         if duration(i,1) > 1
    %             DrawFormattedText(theWindow, ' ', 'center', 'center', text_color);
    %             Screen('Flip', theWindow);
    %             while GetSecs - sTime < duration(i,2)
    %                 %waitsec_fromstarttime(data.loop_start_time{s_num}, 4);
    %             end
    %             data.dat{s_num}{i}.blank_end_time = GetSecs;
    %         end
    %         data.dat{s_num}{i}.text_end_time = GetSecs;
    %         if rem(i,5) == 0
    %             save(data.datafile, 'data', '-append');
    %         end
    %     end
    %
    %     data.loop_end_time{s_num} = GetSecs;
    %     save(data.datafile, 'data', '-append');
    %
    while GetSecs - sTime < 5
        % when the story is done, wait for 5 seconds. (in Blank)
    end
    
    rest_dur = 20;
    [data] = story_resting(rest_dur, data, s_num);
    
    save(data.datafile, 'data', '-append');
end

data.endtime_getsecs = GetSecs;
save(data.datafile, 'data', '-append');

KbStrokeWait;
sca;

%% story_free_thinking

    function [data] = story_resting(rest_dur, data, s_num)
        
        % SETUP: global
        global theWindow W H; % window property
        global white red orange blue bgcolor ; % color
        global fontsize window_rect text_color% lb tb recsize barsize rec; % rating scale
        global letter_time period_time comma_time base_time %window_ratio
        
        resting_msg = double('�̾߱��� ���Դϴ�.\n ���ݺ��ʹ� �߾��� ���� ǥ�ø� �ٶ󺸽ø� \n �����Ӱ� ������ �Ͻø� �˴ϴ�. \n �߰��߰� ������ ��Ÿ�� �����Դϴ�.') ;
        DrawFormattedText(theWindow, resting_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        
        sTime = GetSecs;
        while GetSecs - sTime < 10
            % when the story is done, wait for 5 seconds. (in Blank)
        end
        
        fixation_point = double('+') ;
        DrawFormattedText(theWindow, fixation_point, 'center', 'center', text_color);
        Screen('Flip', theWindow);
        
        sTime = GetSecs;
        data.resting_start_time{s_num} = GetSecs;
        while GetSecs - sTime < rest_dur
            % when the story is done, wait for 5 seconds. (in Blank)
        end
        data.resting_end_time{s_num} = GetSecs;
        
        end_msg = double('���Դϴ�.') ;
        DrawFormattedText(theWindow, end_msg, 'center', 'center', text_color);
        Screen('Flip', theWindow);
    end


