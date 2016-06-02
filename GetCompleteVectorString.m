function vector_str = GetCompleteVectorString(fid, init_str)
% Handle such :
%  momentsOfInertia [ 0.00080386 -0.00000112 -0.00020408
%		     -0.00000112  0.00120641 -0.00000342
%		     -0.00020408 -0.00000342  0.00071428]
% as well as the one line format:
%  momentsOfInertia [0.00122098 0.00028119 0.00009407 0.00028119 0.00172216 0.00012041 0.00009407 0.00012041 0.00161319]

vector_str = init_str;

while isempty(findstr(vector_str, ']'))   
  add_line   = GetLineWithoutComment(fid);
  vector_str = [vector_str, add_line];
end
