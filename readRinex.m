function [nav,ION_ALPHA, ION_BETA] = readRinex(navfile)


nav = [];


% Try to open the navfile
fid = fopen(navfile);

ION_ALPHA = 0;
ION_BETA = 0;
% Now skip rest of header
stillhead = 1;
space(1:80) = ' ';
while stillhead
    line = fgetl(fid);
    line2 = [line, space];
    label = strtrim(line2(60:72));
    if strcmpi(label, 'ION ALPHA')
        line = strrep(line,'D','E');
        ION_ALPHA(1,1) = str2double(line(4:15));
        ION_ALPHA(2,1) = str2double(line(16:27));
        ION_ALPHA(3,1) = str2double(line(28:40));
        ION_ALPHA(4,1) = str2double(line(40:52));
    
    elseif strcmpi(label, 'ION BETA')
        line = strrep(line,'D','E');
        ION_BETA(1,1) = str2double(line(4:15));
        ION_BETA(2,1) = str2double(line(16:27));
        ION_BETA(3,1) = str2double(line(28:40));
        ION_BETA(4,1) = str2double(line(40:52));
    end
    ind = findstr(line,'END OF HEADER');
    if ind > 0
        stillhead = 0;
    end
end

% Now we are ready to read the file
OK = 1 ;  % Set OK true; when EOF reach set to false.
while OK
    line = getnavl(fid); % Reads and fixes line.
    if ~ischar(line)
        OK = 0;  % Return was empty and so EOF reached
    else
        vals = sscanf(line,'%f');
        % Save values;
        % sat_num yy mm dd hh mm sec     af0          af1          af2
        sat_num = vals(1);
        date = vals(2:7); % Year mon day hr min sec
        if date(1) < 50
            date(1) = 2000+date(1);
        else
            date(1) = 1900+date(1);
        end
        a0a1a2 = vals(8:10);
        % OK we are done with prn and date line, read the next block of lines
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % iode               crs         dn           M0
        iode = vals(1); crs = vals(2); dn = vals(3); M0 = vals(4);
        % Next line
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % cuc                e         cus          sqrt_a
        cuc = vals(1); e = vals(2); cus = vals(3); sqrt_a = vals(4);
        
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % toe                cic         omega0          cis
        toe = vals(1); cic = vals(2); omega0 = vals(3); cis = vals(4);
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % i0                 crc         w            omega_dot
        i0 = vals(1); crc = vals(2); w = vals(3); omega_dot = vals(4);
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % i_dot                l2      gps_week       L2_P_code
        i_dot = vals(1); L2 = vals(2); gps_week = vals(3); L2_P_code = vals(4);
        
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % svaccuracy         svhealth    tgd          iodc
        svacc = vals(1); svhealth = vals(2); tgd = vals(3); iodc = vals(4);
        line = getnavl(fid);
        vals = sscanf(line,'%f');
        % t_transmit           spare       spare        spare
        t_transmit = vals(1);
        % Now construct the structure
        str = struct('sat_num',sat_num,'date',date,'a0_a1_a2',a0a1a2, ...
            'iode',iode,'crs',crs,'dn',dn,'M0',M0, ...
            'cuc',cuc,'e',e,'cus',cus,'sqrt_a',sqrt_a, ...
            'toe',toe,'cic',cic','omega0',omega0,'cis',cis, ...
            'i0',i0,'crc',crc,'w',w,'omega_dot',omega_dot, ...
            'i_dot',i_dot,'L2',L2,'gps_week',gps_week,'L2_P_code',L2_P_code, ...
            'svacc',svacc,'svhealth',svhealth,'tgd',tgd,'iodc',iodc, ...
            't_transmit',t_transmit);
        % Now add to nav array
        nav = [nav str];
    end
end


