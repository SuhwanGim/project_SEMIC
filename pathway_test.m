function pathway_test(ip, port)
%%
% This fucntion is only for stimulating 50 thermal degree before
% participants experiece thermal pain. It needs two inputs, 1) IP adress
% and 2) port.
%
% See this, ---------------------------------------------------------
% Matlab: Program name : Program code (parameter, 8bit)
% ---------------------------------------------------------
%   25  : Pulse 49     :   00011001
%
% writen by Suhwan Gim
%%
clc;
    txt=input('���ݺ��� �Ǻ� �׽�Ʈ�� �����ϰڽ��ϴ�. �غ� �Ǽ����� �ƹ� Ű�� �Է����ּ���','s');
    if ~isempty(txt)
        disp('��ø� ��ٷ��ּ���');
        WaitSecs(0.5);
        main(ip, port, 1, 24);
    end
end
