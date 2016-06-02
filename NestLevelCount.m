function c = NestLevelCount(tline)

len = length(tline);

c = 0;
for n=1:len
    if tline(n) == '{'
        c = c+1;
    elseif tline(n) == '}'
        c = c-1;
    end
end

%if c ~= 0, disp(tline), end
