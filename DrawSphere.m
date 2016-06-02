function h = DrawSphere(pos, radius, col)
% draw closed cylinder
%
%********** make shpere

% col = [0 0.5 0];  % cylinder color

a = 10;    % number of side faces

[x,y,z] = sphere(a);
cc = col*ones(size(x));

%************* draw
% side faces
hold on
h = surf(radius*x+pos(1),radius*y+pos(2),radius*z+pos(3),cc);
