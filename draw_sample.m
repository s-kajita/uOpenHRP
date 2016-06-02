% draw_sample.m

more off
close all
clear

ToRad = pi/180;

global uLINK

uLINK = LoadHRPdata('sample.wrl');
SetJointID_Constant;


%% Foot shape
SetBoxObject(RLEG_ANKLE_R, [0.23 0.13 0.02], [0.1 0.075 0.1015], 0);
SetBoxObject(LLEG_ANKLE_R, [0.23 0.13 0.02], [0.1 0.055 0.1015], 0);

%%%%%%%%%%%% Draw robot
ForwardKinematics(1);
figure
DrawAllJoints(1);
view(3);axis equal;

%%%%%%%%%%%% Joint angles
uLINK(RLEG_HIP_P).q  =  30.0*ToRad;
uLINK(RLEG_KNEE).q   =  30.0*ToRad;
uLINK(LLEG_HIP_P).q  = -30.0*ToRad;
uLINK(LLEG_KNEE).q   =  30.0*ToRad;

ForwardKinematics(1);
figure
DrawAllJoints(1);
view(3);axis equal;

%%%%%%%%%%%%%%% Inverse kinematics
Target.p = uLINK(LLEG_ANKLE_R).p + [0 0 0.1]';  % Lift left foot 0.1m 
%Target.R = eye(3); 
Target.R = Rodrigues([1 1 0],-ToRad*30.0);
InverseKinematics(WAIST, LLEG_ANKLE_R, Target); 

figure
DrawAllJoints(1);
view(3);axis equal;
