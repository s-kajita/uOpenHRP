function J = CalcJacobian(from, to)
% Jacobian matrix of current configration in World frame
global uLINK

idx = FindRoute(from, to);
if isempty(idx) return; end

jsize = length(idx);
J = zeros(6,jsize);
target = uLINK(to).p;   % absolute target position

for n=1:jsize
    j = idx(n);
    a = uLINK(j).R * uLINK(j).a;  % joint axis vector in world frame
    J(:,n) = [cross(a, target - uLINK(j).p) ; a ];
end

