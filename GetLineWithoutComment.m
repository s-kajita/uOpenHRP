function tline = GetLineWithoutComment(fid)

tline = fgetl(fid);

if findstr('#',tline)
   tline = tline(1:findstr('#',tline)-1);      % cut comments
end
