function convert_BNAtlas_cat12

% format for the spm/VBM cat12 template
% #1: ROIid;ROIabbr;ROIname;ROIbaseid;ROIbasename;Voxel;Volume;XYZ
% by NM Zuo, Feb. 20, 2018
% nmzuo@nlpr.ia.ac.cn
% Institute of Automation, Chinese Academy of Sciences

% CAUTION:
% This file is only for generating the main body of the CSV/XML file,
% so please manually copy the other contents from the existing template
% e.g., ibsr.csv, labels_dartel_ibsr.xml .
% April 12, 2018


BN=load_nii('BN_Atlas_246_1.5mm_SPM.nii');
nROI=length(unique(BN.img(:))) -1; % remove 0
BN=BN.img;

mycoord=load('BN_Atlas_246_coord.txt');
myname=readtable('subregion_name.txt', 'delimiter', ' ');

if 1 % generate CSV file
    outfile='BN_Atlas_246_1.5mm_SPM.csv';
    fid=fopen(outfile, 'w');
    VOL=1.5^3/1000;
    for i=1:nROI
        Vox = length(find(BN==i));
        Vol = Vox*VOL;
        fprintf(fid, '%d;%s;%s;[ %d ];%s;%d;%0.2f;%d,%d,%d\n',   ...
            i, myname.Var3{i}, myname.Var3{i},  ...
            i, myname.Var3{i}, Vox, Vol,  ...
            mycoord(i,1), mycoord(i,2), mycoord(i,3) );
    end

    fclose(fid);

end

if 1 % generate XML file
    outfile='labels_dartel_BNAtlas.xml';
    fid=fopen(outfile, 'w');
    VOL=1.5^3/1000;
    for i=1:nROI
        Vox = length(find(BN==i));
        Vol = Vox*VOL;
        fprintf(fid, '<label><index>%d', i);
        fprintf(fid, '</index><short_name>%s', myname.Var3{i});
        fprintf(fid, '</short_name><name>%s</name><RGBA></RGBA><XYZmm>', myname.Var3{i});
        fprintf(fid, '%d,%d,%d</XYZmm></label>\n', mycoord(i,1), mycoord(i,2), mycoord(i,3));
    end

    fclose(fid);
end

end
