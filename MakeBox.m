function [vert,face] = MakeBox(dim,org)
% dim: dimension [x y z], org: origin [x0 y0 z0]

vert = [
   0      0      0;
   0      dim(2) 0;
   dim(1) dim(2) 0;
   dim(1) 0      0;
   0      0      dim(3);
   0      dim(2) dim(3);
   dim(1) dim(2) dim(3);
   dim(1) 0      dim(3);
]';

%Å@å¥ì_à⁄ìÆ
vert(1,:) = vert(1,:) - org(1);
vert(2,:) = vert(2,:) - org(2);
vert(3,:) = vert(3,:) - org(3);

face = [
   1 2 3 4;  % bottom
   2 6 7 3;
   4 3 7 8;
   1 4 8 5;
   1 5 6 2;
   5 8 7 6;  % top
]';
