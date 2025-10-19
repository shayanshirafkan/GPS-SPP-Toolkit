function [neu] = read_anx_sat(f_anten,options)

[fid,errmsg] = fopen(f_anten);

if any(errmsg)
    errordlg('Antex file can not be opened.','Antex file error');
    error   ('Antex file error');
end
sn   = 105;
sat_neu = NaN(sn,3,2);
linenum = 0;
while ~feof(fid)
    tline = fgetl(fid);
    linenum = linenum + 1;
    tag   = strtrim(tline(61:end));
    if strcmp(tag,'START OF ANTENNA')
        tline = fgetl(fid);
        linenum = linenum + 1;
        tag   = strtrim(tline(61:end));
        if strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'G') && (options.system.gps == 1)
            sat_no = sscanf(tline(22:23),'%d');
            if sat_no>32
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag   = strtrim(tline(61:end));
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G01')
                    frq_no = 1; %L1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'G02')
                    frq_no = 2; %L2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                end
            end
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'R') && (options.system.glo == 1)
            sat_no = 32 + sscanf(tline(22:23),'%d');
            if sat_no>58 
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag   = strtrim(tline(61:end));
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R01')
                    frq_no = 1; %L1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'R02')
                    frq_no = 2; %L2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                end
            end
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'E') && (options.system.gal == 1)
            sat_no = 58 + sscanf(tline(22:23),'%d');
            if sat_no>88
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag   = strtrim(tline(61:end));
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E01')
                    frq_no = 1; %L1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'E05')
                    frq_no = 2; %L2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                end
            end
        elseif strcmp(tag,'TYPE / SERIAL NO') && strcmp(tline(21),'C') && (options.system.bds == 1)
            sat_no = 88 + sscanf(tline(22:23),'%d');
            if sat_no>105
                continue
            end
            while ~strcmp(tag,'END OF ANTENNA')
                tline = fgetl(fid);
                linenum = linenum + 1;
                tag   = strtrim(tline(61:end));
                if strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C01')
                    frq_no = 1; %L1
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                elseif strcmp(tag,'START OF FREQUENCY') && strcmp(tline(4:6),'C07')
                    frq_no = 2; %L2
                    tline = fgetl(fid);
                    linenum = linenum + 1;
                    tag   = strtrim(tline(61:end));
                    if strcmp(tag,'NORTH / EAST / UP')
                        sat_neu(sat_no,:,frq_no) = sscanf(tline,'%f',[1,3]);
                    end
                end
            end
        end
    else
        continue
    end
end
neu = sat_neu./1000;
fclose('all');
end