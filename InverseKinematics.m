function InverseKinematics(from, to, Target)
global uLINK

ForwardKinematics(from);

for n = 1:10
  J   = CalcJacobian(from,to);
  err = CalcVWerr(Target, uLINK(to));
  fprintf('Error(%d): %f \n',n,norm(err));

  dq = J^-1 * err;
  MoveJoints(from, to, 0.5*dq);
  ForwardKinematics(from);
end
