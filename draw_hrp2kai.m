% draw_hrp2kai.m

more off
close all
clear

ToRad = pi/180;

global uLINK

uLINK = LoadHRPdata('/usr/local/share/OpenHRP-3.1/robot/HRP2KAI/model/HRP2KAImain.wrl');
SetJointID_Constant;


% Make shoulder shape
CHEST_CENTER = length(uLINK) + 1;   % new joint
uLINK(CHEST_CENTER) = uLINK(WAIST);  % copy structure of free link

uLINK(CHEST_CENTER).name = 'CHEST_CENTER';
uLINK(CHEST_CENTER).mother = CHEST_JOINT1;
uLINK(CHEST_CENTER).a = uLINK(RARM_JOINT0).a;
uLINK(CHEST_CENTER).b = (uLINK(RARM_JOINT0).b + uLINK(LARM_JOINT0).b)/2;
uLINK(CHEST_CENTER).c = [0 0 0]';

child_org  = uLINK(CHEST_JOINT1).child;
sister_org = uLINK(child_org).sister;
uLINK(CHEST_CENTER).child = child_org;
uLINK(CHEST_JOINT1).child = CHEST_CENTER;

uLINK(child_org).mother = CHEST_CENTER;
uLINK(child_org).b = uLINK(child_org).b - uLINK(CHEST_CENTER).b;

while sister_org ~= 0
    fprintf('Name: %s\n',uLINK(sister_org).name);
    uLINK(sister_org).mother = CHEST_CENTER;
    uLINK(sister_org).b = uLINK(sister_org).b - uLINK(CHEST_CENTER).b;
    sister_org = uLINK(sister_org).sister;
end

% simplify hand mechanism
uLINK(RARM_JOINT7).child = 0
uLINK(RARM_JOINT7).sister = 0
uLINK(LARM_JOINT7).child = 0
uLINK(LARM_JOINT7).sister = 0


% sole
ANKLE_Z = 0.105;  % ankle height of HRP2

R_SOLE = length(uLINK) + 1;
L_SOLE = R_SOLE + 1;
uLINK(R_SOLE) = uLINK(WAIST);
uLINK(L_SOLE) = uLINK(WAIST);

uLINK(RLEG_JOINT5).child = R_SOLE;
uLINK(R_SOLE).name = 'R_SOLE';
uLINK(R_SOLE).mother = RLEG_JOINT5;
uLINK(R_SOLE).child = 0;
uLINK(R_SOLE).sister = 0;
uLINK(R_SOLE).b = [0 0 -ANKLE_Z]';

uLINK(LLEG_JOINT5).child = L_SOLE;
uLINK(L_SOLE).name = 'L_SOLE';
uLINK(L_SOLE).mother = LLEG_JOINT5;
uLINK(L_SOLE).child = 0;
uLINK(L_SOLE).sister = 0;
uLINK(L_SOLE).b = [0 0 -ANKLE_Z]';

% right foot shape data(x,y) vertex in clockwise direction
footx = [ 0.13  -0.1   -0.1     0.13   0.13 ];
footy=  [-0.075  -0.075 0.055   0.055  -0.075];  
% footx = [ -0.053 0.115 0.180  0.180  0.158  0.100 -0.053 -0.065 -0.053];  
% footy = [  0.028 0.050 0.031 -0.004 -0.037 -0.054 -0.028  0.0    0.028];
footz = zeros(1,length(footx));
vert = [footx;footy;footz];
face = [1:length(footx)]';
uLINK(R_SOLE).vertex = vert;
uLINK(R_SOLE).face = face;

% left foot shape data(x,y) vertex in clockwise direction
vert = [footx;-footy;footz];
face = [1:length(footx)]';
uLINK(L_SOLE).vertex = vert;
uLINK(L_SOLE).face = face;


%%%%%%%%%%%% Draw robot
uLINK(WAIST).p = [0 0 0.8]';
ForwardKinematics(1);
figure
DrawAllJoints(1);
view(3);axis equal;

% %%%%%%%%%%%% ä÷êﬂäpìxÇÃê›íË
% uLINK(RLEG_JOINT2).q =  30.0*ToRad;
% uLINK(RLEG_JOINT3).q =  30.0*ToRad;
% uLINK(LLEG_JOINT2).q = -30.0*ToRad;
% uLINK(LLEG_JOINT3).q =  30.0*ToRad;
% 
% % ÉçÉ{ÉbÉgÇÃï`âÊ
% ForwardKinematics(1);
% figure
% DrawAllJoints(1);
% view(3);axis equal;
% 
% %%%%%%%%%%%%%%% ãtâ^ìÆäw
% Target.p = uLINK(LLEG_JOINT5).p + [0 0 0.1]';  % âEë´Ç0.1mè„è∏
% %Target.R = eye(3); 
% Target.R = Rodrigues([1 1 0],-ToRad*30.0);
% InverseKinematics(WAIST, LLEG_JOINT5, Target); 
% 
% figure
% DrawAllJoints(1);
% view(3);axis equal;
