function MoveJoints(from, to, dq)
global uLINK
 
route = FindRoute(from, to);

for n=1:length(route)
    j = route(n);
    uLINK(j).q = uLINK(j).q + dq(n);
end
