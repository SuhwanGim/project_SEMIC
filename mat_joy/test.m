%[position, buttons] = mat_job(joystick_id);



%where:\n
%\n
%joystick_id - joystick identifier (0-15),\n
%position - list of joystick position in X, Y and Z axis,\n
%buttons - list of 16 joystick button states (missing buttons are always zeros)

buf_size = 1000;

buf = inf(buf_size,1);
figure;
i = 0;

while true
    [pos, but] = mat_joy(0);
    plot(1:buf_size, buf);
    axis([0 1000 -1 1]);
    buf = [buf(2:buf_size); pos(2)];
    i = i + 1;
    pause(0.01);
end

%%

buf_size = 1000;


%figure;
i=1;
sTime=GetSecs;
while true
    [pos, but] = mat_joy(0);
    dat.x(i,1)= pos(1);
    dat.y(i,1)=pos(2);
    disp(pos);
    i= i+1;
    if GetSecs -sTime > 5
        break;
    end
    clc;
    pause(0.01);
end
%%
plot(dat.x(:), dat.y(:));
axis([-1 1 -1 1]);

%%
ID = 1
joy=vrjoystick(ID);
