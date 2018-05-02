function SEMIC_Senddata(subj_name, type)
%
% Copyright 1984-2016 The MathWorks, Inc.
% This function requires Java.

%% SETTING: MAIL ACCOUNT
% This mail account created only for this function because this fucntion 
% should include both address and password of account as variables
mail = 'cocoan.matlab@gmail.com';
password = 'public20170302';
% mail address of receiver
rec_mail = 'roseno.9@daum.net'; %Suhwan Gim @Cocoanlab

%% SETTING: SMTP protocol (gmail)
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
% 
props = java.lang.System.getProperties;
clc;
disp('This function requires Java');
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%% SETTING: Attachments, title and message 
% :you can freely modify what you want do depends on your aim.
% In my(SEMIC) case, find the specific participant's data files.
sbj=subj_name; %SEM000~

new_SID = erase(sbj,'SEM'); % For limitation of file name

edf_filename = new_SID; % 'M_003_2' <-['M_' new_SID '_' num2str(runNbr)]


switch type
    case 'Calibration'
        data_dir ={[pwd '/Cali_Semic_data/' 'Calib_' sbj '.mat']};
        
        %modify message        
        msg_title = ['Calibration_' sbj '_' datestr(now)];
        msg_text = ['Calibration' 'Subject Name:' sbj '      ' 'Time:' datestr(now) '      ' 'data_files'];
        
        
    case 'mri'
        data_dir ={[pwd '/LEARN_SEMIC_data/' 'Learning_' sbj '.mat'],...
            [pwd '/REST_SEMIC_data/' 'Rest_' sbj '.mat'],...
            [pwd '/Main_SEMIC_data/' 'Main_' sbj '.mat'],...
            [pwd '/Motor_Semic_data/' 'Motor_' sbj '.mat'],...
            [pwd '/M_' edf_filename '_1.edf']...
            [pwd '/M_' edf_filename '_2.edf']...
            [pwd '/M_' edf_filename '_3.edf']...
            [pwd '/M_' edf_filename '_4.edf']...
            [pwd '/M_' edf_filename '_5.edf']...
            [pwd '/M_' edf_filename '_6.edf']...
            [pwd '/L_' edf_filename '_1.edf']...
            [pwd '/O_' edf_filename '_1.edf']...
            [pwd '/O_' edf_filename '_2.edf']
            };
        
        
        %modify message
        msg_title = ['MRI_experiment_' sbj '_' datestr(now)];
        msg_text = ['MRI_experiment' 'Subject Name:' sbj '      ' 'Time:' datestr(now) '      ' 'data_files'];
end

% Attachment files
attachment = CheFiles(data_dir);

%% Send data to selected gmail
    % Send mail (mail address, title of mail, contents, attachments files )
    % e.g, sendmail(rec_mail,[sbj datestr(now)],[sbj datestr(now)
    % 'data_files'], {Cali_dir, Learn_dir, Main_dir, Mot_dir });

sendmail(rec_mail, msg_title, msg_text, attachment);

%final_msg = strcat('Send total files\n',num2str(numel(attachment)),'see detatis:''\n',attachment, '\n:::'); 
clc;
fprintf('=======================Send total %d files================================\n',numel(attachment));
fprintf('DETAILS:\n');
fprintf(['Subject name:' sbj '\n']);
fprintf(string(attachment));
fprintf('\n');


end

function attachment = CheFiles(data_dir)
ii=1;
for i=1:length(data_dir)
    if exist(data_dir{1,i},'file')
        attachment{1, ii} = data_dir{1,i};
        ii=ii+1;
    end
end
end
