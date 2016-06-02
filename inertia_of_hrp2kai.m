% hrp2kai_inertia.m

more off
close all
clear

ToRad = pi/180;

global uLINK
%verbose = 1;
verbose = 0;

uLINK = LoadHRPdata('/usr/local/share/OpenHRP-3.1/robot/HRP2KAI/model/HRP2KAImain.wrl');
SetJointID_Constant;

%%%%%%%%%%%% 
ForwardKinematics(1);
SoleHeight = uLINK(RLEG_JOINT5).p(3);
uLINK(WAIST).p(3) = uLINK(WAIST).p(3)-SoleHeight;
ForwardKinematics(1);
figure

Cradius    = 0.018;
Clen       = 0.08;
DrawAllJoints(1,Cradius,Clen);
view(3);axis equal;
grid on

totalMass = TotalMass(1);
CoM = calcCoM();
fprintf('Total mass=%g\n',totalMass);
DrawSphere(CoM,0.03,'g');

disp('CoM position')
disp(CoM)

TotalInertia0 = calcInertiaTensor(1);
disp('Total inertia around Origin')
disp(TotalInertia0)

TotalInertia = TotalInertia0 - Inertia3D(totalMass,CoM);
disp('Total inertia around CoM')
disp(TotalInertia)
