function SetBoxObject(j, wdh , origin_xyz, specific_gravity)
% Setup box object to uLINK 
% wdh : [width depth height] (size in xyz)
global uLINK

mass = wdh(1) * wdh(2) * wdh(3) * specific_gravity;
uLINK(j).m = mass;
uLINK(j).c = wdh/2 - origin_xyz;  % Center of mass
uLINK(j).I = [1/12*(wdh(2)^2 + wdh(3)^2) 0 0;...
              0 1/12*(wdh(1)^2 + wdh(3)^2)  0;...
              0 0 1/12*(wdh(2)^2 + wdh(3)^2)] * mass; % äµê´ÉeÉìÉ\Éã

[uLINK(j).vertex,uLINK(j).face]   = MakeBox(wdh  ,origin_xyz); % size [x y z], origin [x0 y0 z0]

