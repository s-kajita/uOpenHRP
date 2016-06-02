function w = rot2omega(R)

alpha = (trace(R)-1)/2;

if abs(alpha-1) < eps
    w = [0 0 0]';
    return;
end

th = acos(alpha);
w = 0.5*th/sin(th)*[R(3,2)-R(2,3), R(1,3)-R(3,1), R(2,1)-R(1,2)]';
