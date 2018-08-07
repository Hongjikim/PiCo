clear all
myText = input('\n ��ü ���� �� �ٷ� �Է��Ͻÿ�: \n', 's');
doubleText = double(myText);


letter_time =  0.6;   %0.15*4
period_time = 3; %3;
comma_time = 1.5; %1.5;
base_time = 0;

if doubleText(end) ~= 32
    doubleText= [doubleText 32];
end

space_loc = find(doubleText==32); % location of space ' '
comma_loc = find(doubleText==44);
ending_loc = find(doubleText==46);



space_loc = [0 space_loc];
my_length = length(space_loc)-1;

time_interval = randn(1,my_length)*.4; % *0.1

cal_duration = 0;  % 63, 93, 139

aa = find([0 space_loc] - [space_loc space_loc(end)] == -1) ; 
if  numel(aa) > 2
    fprintf('���ӵ� ��ĭ�� %d° �ܾ ������ Ȯ�� �ٶ�.', aa)
end


for j = 1:length(comma_loc)
    if sum(comma_loc(j) + 1 == space_loc) == 0
        disp('*** error in contents! ***')
        fprintf('��ǥ ��ġ: %s \n', myText(comma_loc(j)-2:comma_loc(j)))
        fprintf('%s \n', fname)
        sca
        break
    end
    for k = 1:length(ending_loc)
        if sum(ending_loc(k) + 1 == space_loc) == 0
            disp ('*** error in contents! ***')
            fprintf('��ħǥ ��ġ: %s', myText(ending_loc(k)-2:ending_loc(k)))
            fprintf('%s \n', fname)
            sca
            return
        end
    end
end

for i = 1:my_length
    
    % letter_num = space_loc(i+1) - space_loc(i);
    if sum(space_loc(i+1) - 1 == comma_loc) ~= 0
        out{i}.total_duration= letter_time + base_time + comma_time + abs(time_interval(i));
        out{i}.word_type = 'comma';
        out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
    elseif sum(space_loc(i+1) - 1 == ending_loc) ~= 0
        out{i}.total_duration= letter_time + base_time + period_time + abs(time_interval(i));
        out{i}.word_type = 'period';
        out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
    else
        out{i}.total_duration= letter_time + base_time + abs(time_interval(i));
        out{i}.word_type = 'words';
        out{i}.accumulated_duration = cal_duration + out{i}.total_duration;
    end
    
    cal_duration = cal_duration + out{i}.total_duration;
    out{i}.word_duration = letter_time + base_time + abs(time_interval(i));
    msg = doubleText(space_loc(i)+1:space_loc(i+1));
    msg(msg==32) = []; % deblank
    out{i}.msg = char(msg);
    out{i}.msg_double = msg;
end
disp('***************')
disp(['�ܾ��:  ', num2str(my_length), '�ܾ�']) 
disp(['�ð�:  ', num2str(cal_duration), '��'])
disp('***************')
