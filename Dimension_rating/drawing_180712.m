%%
% 1) �� �ֱ� (�߶�
% 2) �� �ѱ��
% 3) instructoin �ֱ�
% 4) ��ġ screen size�� ���߱� (fast����)
% 5) instruction �� ���缭 axis����
%%
% SETUP: global
global theWindow W H; % window property
global white red orange blue bgcolor ; % color
global fontsize window_rect lb tb recsize barsize; % rating scale

Screen('Preference', 'SkipSyncTests', 1);
[theWindow,rect]=Screen('OpenWindow',0, [128 128 128], [0 0 2560/2 1440/2]); %screen0 is macbook when connectd to BENQ (hongji) and [0 0 2560/2 1440/2] is for testing
Screen('Preference','TextEncodingLocale','ko_KR.UTF-8');
font ='NanumBarunGothic';
Screen('TextFont', theWindow, font);
% Screen('TextSize', windowPtr, fontsize);
% HideCursor;

basedir = '/Users/hongji/Dropbox/PiCo_git/Dimension_rating'; 
cd(basedir); addpath(genpath(basedir));
subject_ID = input('Subject ID?:', 's');
subject_number = input('Subject number?:');

%the_text = input('***** Write the exact file name(Ex. pico_story.txt):', 's'); %Copy_of_pico_story_kor_ANSI.txt
the_text = 'Copy_of_pico_story_kor_ANSI.txt';
% [k, double_text] = make_text_PDR(the_text);
%
sTime = GetSecs;
ready2=0;
rec=1;
rec2=1;

SetMouse(70, 200); % set mouse at the starting point
x=70; y=200;
xc = x;
yc = y;
xc_1 = x;
yc_1 = y;
x_save = x;
y_save = y;

t = GetSecs;
text = double('���� ����� ���õ� ������ ���ø��� ���� ���� ġ���� ��������. �ֳ��ϸ� �ֱٿ� ���� ���ʹ� ������ ���ø���, ġ������ ���� �Ű�ġ�ᰡ �������� �����̴�. �� �� �幮�幮 �������� ��ū�Ÿ��� �ܾ�� ������ ������ ���� ����ǰ�, ���������� ������. ��ø� �����ϸ� ������ ǥ���� ���׷�����, ġ�Ḧ ���� �� ������ ���� ���ؼ� ������ �������� ���� ������ ����� �����ϰ� ����'); %�ֳ��ϸ� ġ�� ġ�Ḧ � ������ ...');

while ~ready2
    
    
    draw_axis_PDR([200 550]);
    
    DrawFormattedText(theWindow, text, 85, 75, 255, 65, 0, 0, 14); % 10 = 14.5
    
    [x,y,button] = GetMouse(theWindow);
    
    
    t(2) = t(1);
    t(1) = GetSecs;
    intv = round(-diff(t)*2000); %2000
    
    if xc(rec) ~= x
        vec_x = (xc(rec):((x-xc(rec))/intv):x)';
    else
        vec_x = repmat(x, intv+1,1);
    end
    
    if yc(rec) ~= y
        vec_y = yc(rec):((y-yc(rec))/intv):y;
    else
        vec_y = repmat(y, intv+1,1);
    end
    
    xc((rec+1):(rec+intv),:)=vec_x(2:end);
    xc_1((rec+1):(rec+intv),:)=vec_x(2:end);
    yc((rec+1):(rec+intv),:)=vec_y(2:end);
    yc_1((rec+1):(rec+intv),:)=vec_y(2:end);
    rec = rec + intv;
    
    %     if rec2 ~= 0
    if x_save(rec2) ~= x || y_save(rec2) ~= y
        rec2 = rec2 + 1;
        x_save(rec2,:)=x;
        y_save(rec2,:)=y;
    else
        
    end
    %     end
    %
    
    
    %         xc(rec,:)=x;
    %         yc(rec,:)=y;
    
    % if the point goes further than the box, move the point to
    % the closest point
    
    disp([x,y]); %display the coordinates
    Screen('DrawDots', theWindow, [x y]', 20, [255 164 0 130], [0 0], 1);  % big orange dot
    Screen('DrawDots', theWindow, [xc_1 yc_1]', 5, [255 0 0], [0 0], 1);  %red line
    %Screen(theWindow,'DrawLines', [xc yc]', 5, 255);
    Screen('Flip',theWindow);
    
    if y < 100
        y = 100; SetMouse(x,y);
    elseif x > 1220 && y < 350
        x = 70; y = 553; WaitSecs(0.5); SetMouse(x,y);
        clear xc_1 yc_1
    elseif x < 70
        x = 70; SetMouse(x,y);
    elseif y > 660;
        y = 660; SetMouse(x,y);
    elseif x > 1220 && y > 500
        break
    end
    
    if button(1)
        %draw_scale('overall_avoidance_semicircular');
        Screen('DrawDots', theWindow, [x y]', 18, red, [0 0], 1);  % Feedback
        Screen('Flip',theWindow);
        WaitSecs(0.5);
        ready3=0;
        while ~ready3 %GetSecs - sTime> 5
            msg = double(' '); % ������ ������ ��
            DrawFormattedText(theWindow, msg, 'center', 250, white, [], [], [], 1.2);
            Screen('Flip',theWindow);
            if  GetSecs - sTime > 5
                break
            end
        end
        
        break;
        
    elseif GetSecs - sTime > 20
        ready2=1;
        break;
    else
        %do nothing
    end
    % sca;
    
end
%


savedir = fullfile(basedir, 'Data_PDR');
if ~exist(savedir, 'dir')
    mkdir(savedir);
end

nowtime = clock;
subjtime = sprintf('%.2d%.2d%.2d', nowtime(1), nowtime(2), nowtime(3));

data.subject = subject_number;
data.datafile = fullfile(savedir, [subjtime, '_', subject_ID, '_subj', sprintf('%.3d', subject_number), '.mat']);
data.version = 'PICO_v0_04-16-2018_Cocoanlab';
data.starttime = datestr(clock, 0);
data.starttime_getsecs = GetSecs;

data.trajectory_full = [xc yc];
data.trajectory_save = [x_save y_save];

% subplot(1,2,1)
% plot(data.trajectory_full(:,1), -data.trajectory_full(:,2))
% subplot(1,2,2)
% plot(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% 
% scatter(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% scatter(data.trajectory_save(:,1), -data.trajectory_save(:,2))
% scatterplot(data.trajectory_save)
% scatterplot(data.trajectory_save)

save(data.datafile, 'data');

sca;
Screen('CloseAll');