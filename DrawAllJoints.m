function DrawAllJoints(j,Cradius,Clen)
global uLINK

if nargin == 1
    % default joint cylinder
    Cradius    = 0.02;
    Clen       = 0.06;
end
joint_col = 0;

if j ~= 0  
    if ~isempty(uLINK(j).vertex)
        vert = uLINK(j).R * uLINK(j).vertex;
        for k = 1:3
            vert(k,:) = vert(k,:) + uLINK(j).p(k); % adding x,y,z to all vertex
        end
        DrawPolygon(vert, uLINK(j).face);
    end
    hold on
    
    i = uLINK(j).mother;
    if i ~= 0
        Connect3D(uLINK(i).p,uLINK(j).p,'k',2);
    end
    if strcmp(uLINK(j).jtype,'rotate')
        DrawCylinder(uLINK(j).p, uLINK(j).R * uLINK(j).a, Cradius,Clen, joint_col);
    end

    DrawAllJoints(uLINK(j).child, Cradius,Clen);
    DrawAllJoints(uLINK(j).sister,Cradius,Clen);
end
hold off