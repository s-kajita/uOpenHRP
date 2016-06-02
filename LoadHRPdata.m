function uLINK0 = LoadHRPdata(fname, verbose)
%% parse OpenHRP data (VRML) and make uHRP data   s.kajita AIST
%% 2007 July 5  General algorithm for VRML  
%% 2016 June 2  Introduce GetLineWithoutComment() and GetCompleteVectorString()

if nargin == 1
    verbose = 0;
end

fid = fopen(fname);

nest_level = 0;
idx = 1;
idx_stack = 1;

jid_stack = [];
segments  = [];
jid2idx = 1;

FRAME.translation = [0 0 0]';
FRAME.rotation    = [0 0 1 0]';
FRAME.mother      = 0;
FRAME.jointId     = -1;
FRAME.name        = '';

if verbose
    fprintf('Nest level monitor:\n')
end

line_count = 0;
while 1
    tline = GetLineWithoutComment(fid);
    line_count = line_count + 1;
    
    if ~ischar(tline), break, end

    %% nest level of {}
    nc = NestLevelCount(tline);
    nest_level = nest_level + nc;   % nest level
    
    if nc > 0
        idx = idx+1;  % new FRAME
        FRAME(idx).translation = [0 0 0]';    % Default
        FRAME(idx).rotation    = [0 0 1 0]';  % Default
        FRAME(idx).mother      = idx_stack(nest_level);
        FRAME(idx).jointId     = -1;
        FRAME(idx).name        = '';
        idx_stack = [idx_stack(1:nest_level), idx];
    end
    
    if verbose
        fprintf('%d:',nest_level);
        if rem(line_count,30) == 0
            fprintf('\n');
        end
    end

    %% find joint definition
    [T1,rest] = strtok(tline);
    
    if strcmp(T1,'DEF')
        [T2,rest] = strtok(rest);
        [T3,rest] = strtok(rest);
        if strcmp(T3,'Joint')
            FRAME(idx).name = T2;
            FRAME(idx).jaxis = [0 0 1]';  % default joint axis
            if strcmp(T2,'WAIST')
                jid2idx(1) = idx;
            end
        elseif strcmp(T3,'Segment');
            FRAME(idx).name = T2;
            segments = [segments idx];
        end
    elseif strcmp(T1,'translation')
        FRAME(idx).translation = str2num(rest)';
    elseif strcmp(T1,'rotation')
        FRAME(idx).rotation = str2num(rest)';
    elseif strcmp(T1,'jointId')
        FRAME(idx).jointId = str2num(rest);
        jid2idx(str2num(rest)+2) = idx;
    elseif strcmp(T1,'jointAxis')
        if findstr('X',rest)
            FRAME(idx).jaxis = [1 0 0]';
        elseif findstr('Y',rest)
            FRAME(idx).jaxis = [0 1 0]';
        elseif findstr('Z',rest)
            FRAME(idx).jaxis = [0 0 1]';
        else
            FRAME(idx).jaxis = str2num(rest)';
        end
    elseif strcmp(T1,'jointType')
        rest = strrep(rest,'"','');   % remove double quote
        FRAME(idx).jtype = strrep(rest,' ','');   % remove space
    elseif strcmp(T1,'mass')
        FRAME(idx).m = str2num(rest);
    elseif strcmp(T1,'centerOfMass')
        FRAME(idx).c = str2num(rest)';
    elseif strcmp(T1,'momentsOfInertia')
        vector_str = GetCompleteVectorString(fid, rest);
        wk = str2num(vector_str);
        if isempty(wk)
            Iwk = zeros(3,3);
        else
            Iwk = reshape(wk,3,3);
            FRAME(idx).I = (Iwk + Iwk')/2;
        end
    elseif strcmp(T1,'gearRatio')
        FRAME(idx).gr = str2num(rest);
    elseif strcmp(T1,'rotorInertia')
        FRAME(idx).Ir = str2num(rest);
    elseif strcmp(T1,'llimit')
        FRAME(idx).llimit = str2num(rest);
    elseif strcmp(T1,'ulimit')
        FRAME(idx).ulimit = str2num(rest);
    elseif strcmp(T1,'lvlimit')
        FRAME(idx).lvlimit = str2num(rest);
    elseif strcmp(T1,'uvlimit')
        FRAME(idx).uvlimit = str2num(rest);
    end
end

fclose(fid);
if verbose 
    fprintf('\n')
end

if verbose
    fprintf('No : name          : mother :  jointId \n')   
    for n=1:length(FRAME)
        fprintf('%2d: %15s : %3d : jointId=%2d \n',n,FRAME(n).name,FRAME(n).mother,FRAME(n).jointId);
    end

    for n=1:length(jid2idx)
        fprintf('jid=%2d  idx=%2d \n',n,jid2idx(n));
    end
end

%fprintf('*** Segments ***\n');
for n=1:length(segments)
    idx = segments(n);

    mom_idx = FRAME(idx).mother;
    while ~strcmp(FRAME(mom_idx).name,'WAIST') && FRAME(mom_idx).jointId == -1 
        mom_idx = FRAME(mom_idx).mother;  % ascend tree to find a valid Joint node
    end
    jid = FRAME(mom_idx).jointId + 2;
    jid2segment(jid) = idx;
    
    %fprintf('%3d %15s :%15s m=%8.2f\n',idx,FRAME(idx).name,FRAME(mom_idx).name,FRAME(idx).m);
end

%%%%%%% FRAME => uLINK
global uLINK0

rsize = length(jid2idx);
uLINK0 = FRAME( jid2idx(1) );
uLINK0.mother = 0;
for n=2:rsize
    idx = jid2idx(n);
    if idx > 0
        uLINK0(n) = FRAME( idx );
        mom_idx = FRAME(idx).mother;
        while ~strcmp(FRAME(mom_idx).name,'WAIST') && FRAME(mom_idx).jointId == -1
            gmom_idx = FRAME(mom_idx).mother;  % ascend tree to find a valid Joint node
            if ~(gmom_idx > 0)
                fprintf('Subscript index error: mom_idx = %d, gmom_idx = %d\n',mom_idx, gmom_idx);
                return;
            else
                mom_idx = gmom_idx;
            end
        end
        uLINK0(n).mother = FRAME(mom_idx).jointId+2;
    end
end

%%%%%%%% Set physical property
for n=1:rsize
    idx = jid2segment(n);
    if idx > 0
        uLINK0(n).m = FRAME(idx).m;
        uLINK0(n).I = FRAME(idx).I;
        uLINK0(n).c = FRAME(idx).c;
        if verbose
            fprintf('%2d: %15s : %3d : jointId=%2d m=%6.2f \n',...
                n,uLINK0(n).name,uLINK0(n).mother,uLINK0(n).jointId,uLINK0(n).m);
        end
    end
end

%%%%%%% find child and sister %%%%%%
%% initialize
for n=1:rsize
    uLINK0(n).sister = 0;
    uLINK0(n).child  = 0;
    uLINK0(n).q      = 0;
    uLINK0(n).dq     = 0;
    uLINK0(n).ddq    = 0;
    uLINK0(n).vertex = [];
    uLINK0(n).Rs     = eye(3);
end

uLINK0(1).p = [0,0,0]';
uLINK0(1).R = eye(3);

%% who am i sequence
for n=1:rsize
    mom = uLINK0(n).mother;          % I know you are my mother.
    if mom ~= 0 
        if uLINK0(mom).child == 0
            uLINK0(mom).child = n;           % Mother, I'm your daughter !!
        else
            elder_sister = uLINK0(mom).child;    % I have elder sister!
            while(uLINK0(elder_sister).sister ~= 0)
                elder_sister = uLINK0(elder_sister).sister;  % I have another elder sister!
            end
            uLINK0(elder_sister).sister = n;   % I'm your younger sister!
        end
    end
end

for n=1:length(uLINK0)
    %fprintf('%2d %15s  %2d : \n',uLINK0(n).jointId,uLINK0(n).name,uLINK0(n).mother);
    eval([uLINK0(n).name,'=',num2str(n),';']);
    %disp(uLINK0(n).jaxis');
end

VRML2OpenHRP(1);

%%%%%%%%%%%%%%%%% convert VRML to OpenHRP %%%%%%%%%%%%%%%%%%%%%%%%%%
function VRML2OpenHRP(n)
global uLINK0

if n == 0, return, end;

mom = uLINK0(n).mother;
if mom == 0
    uLINK0(n).Rs = Rodrigues(uLINK0(n).rotation(1:3), uLINK0(n).rotation(4));
    uLINK0(n).a  = uLINK0(n).Rs * [0 0 1]';
    uLINK0(n).b  = uLINK0(n).translation;
else
    uLINK0(n).Rs = uLINK0(mom).Rs * Rodrigues(uLINK0(n).rotation(1:3), uLINK0(n).rotation(4));
    uLINK0(n).a  = uLINK0(n).Rs * uLINK0(n).jaxis;
    uLINK0(n).b  = uLINK0(mom).Rs * uLINK0(n).translation;
    
    uLINK0(n).p  = uLINK0(mom).R * uLINK0(n).b + uLINK0(mom).p;
    uLINK0(n).R  = uLINK0(mom).R * Rodrigues(uLINK0(n).a, uLINK0(n).q);
end

VRML2OpenHRP(uLINK0(n).child);
VRML2OpenHRP(uLINK0(n).sister);
