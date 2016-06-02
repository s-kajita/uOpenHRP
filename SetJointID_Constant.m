% SetJointID_Constant.m

%%% Set ID number to variables whose name are the LINK name
for n=1:length(uLINK)
    eval([uLINK(n).name,'=',num2str(n),';']);
    %fprintf('%2d %s\n',uLINK(n).jointId,uLINK(n).name);
end

