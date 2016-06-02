function R = Rodrigues(w,dt)
% w should be column vector of size 3

th = norm(w)*dt;
wn = w/norm(w);		% normarized vector
w_wedge = [0 -wn(3) wn(2);wn(3) 0 -wn(1);-wn(2) wn(1) 0];
R = eye(3) + w_wedge * sin(th) + w_wedge^2 * (1-cos(th));

