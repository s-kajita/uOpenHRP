function inr = calcInertiaTensor(j)
global uLINK

if j == 0
    inr = zeros(3);
else
  disp(uLINK(j).name);
    r   = uLINK(j).p + uLINK(j).R * uLINK(j).c;
    inr = Inertia3D(uLINK(j).m,r) + uLINK(j).R * uLINK(j).I * uLINK(j).R';
    inr = inr + calcInertiaTensor(uLINK(j).sister) + calcInertiaTensor(uLINK(j).child);
end
