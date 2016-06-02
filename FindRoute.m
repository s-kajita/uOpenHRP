function idx = FindRoute(from, to)
% return the list of joint number connecting 'from' to 'to'
global uLINK

i = uLINK(to).mother;
if i == 0
    idx = [];    % search failed
    fprintf('FindRoute: search failed\n');
elseif i == from 
    idx = [to];
else
    idx2 = FindRoute(from, i);
    if isempty(idx2) 
        idx = [];
    else
        idx = [idx2 to];
    end
end