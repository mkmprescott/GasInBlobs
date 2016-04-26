%Arthur Cox
%importing data for use in Lya.m


function [A] = importdata(color,size,angle,line);
name = 'fail'
tb = strcmp(color,'blue')
tr = strcmp(color,'red')
tv = strcmp(size,'velo')
tvb = strcmp(size,'velobin')
tw = strcmp(size,'wide')
val=517;
if tv == 1

    if tb == 1
        name = '.skyvelocombo.'
    elseif tr == 1
        name = '.skyvelo.'
    end
elseif tvb == 1
    if tb == 1
        name = '.skyvelobincombo.'
    elseif tr == 1
        name = '.skyvelobin.'
    end
elseif tw == 1
    if tb == 1
        name = '.skywidecombo.'
    elseif tr == 1
        name = '.skywide.'
    end
end
    
testfiledir = char(strcat('~/Desktop/lablobs/datafiles/', color,'/',size,'/casdPRG1_',angle,name,line,'.nohead.dat'))
fid=fopen(testfiledir)
[A count] = fscanf(fid,'%c')
%A=A(val:end)
A=str2num(A);
% rows2remove=[1 2];
% A(rows2remove,:)=[];