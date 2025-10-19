function [TECS,Lat1,Lon1,DLat,DLon,interval] = IONEX2TECS(filename)
%Program for reading Ionex file to extract tec values
%Saving for time and phi and lambda in an array indexed with these values
%Using Dlat Dlon and Dt intervals given in the file
fid=fopen(filename,'r');
tline=fgets(fid);
%First finding the epoch of the first map
while ~feof(fid)
    if(findstr(tline,'EPOCH OF FIRST MAP'))
            A1t=textscan(tline,'%s');
            FIRST_MAP_TIME=[str2double(A1t{1}{1}),str2double(A1t{1}{2}),str2double(A1t{1}{3}),str2double(A1t{1}{4}),str2double(A1t{1}{5}),str2double(A1t{1}{6})];    
            break;
    end
        tline=fgets(fid);
end
%Now Obtaining time interval for maps
while ~feof(fid)
    if(findstr(tline,'INTERVAL'))
            A1t=textscan(tline,'%s');
            interval=str2double(A1t{1}{1});
            break;
    end
        tline=fgets(fid);
end
%Obtaining range of Latitude
while length(tline)>5
    if(findstr(tline,'LAT1 / LAT2 / DLAT'))
            A1t=textscan(tline,'%s');
            Lat1=str2double(A1t{1}{1});
            DLat=str2double(A1t{1}{3});
            break;
    end
        tline=fgets(fid);
end
%Obtaining range of Longitude
while length(tline)>5
    if(findstr(tline,'LON1 / LON2 / DLON'))
            A1t=textscan(tline,'%s');
            Lon1=str2double(A1t{1}{1});
            DLon=str2double(A1t{1}{3});
            break;
    end
        tline=fgets(fid);
end
t0=FIRST_MAP_TIME(3)*24*3600+FIRST_MAP_TIME(4)*3600+FIRST_MAP_TIME(5)*60+FIRST_MAP_TIME(6);
%Starting To read each map data with finding the string START OF TEC MAP
while ~feof(fid)
    while findstr(tline,'START OF TEC MAP')
        %Obtaining map epoch from next line
        tline=fgets(fid);
        A1t=textscan(tline,'%s');
        t=str2double(A1t{1}{3})*24*3600+str2double(A1t{1}{4})*3600+str2double(A1t{1}{5})*60+str2double(A1t{1}{6});
        time_index=((t-t0)/interval)+1;
        %Skipping The Start Line
        tline=fgets(fid);
        %Obtaining Latitude of map
        while findstr(tline,'LAT/LON1/LON2/DLON/H')
            lat=str2double(tline(4:8));
            lat_index=((lat-Lat1)/DLat)+1;
            teccnt=0;
            %Skipping the lat/lon... line
            tline=fgets(fid);
            while (max(size(findstr(tline,'LAT/LON1/LON2/DLON/H')))==0) && (max(size(findstr(tline,'END OF TEC MAP')))==0) 
                TECS0=textscan(tline,'%f');
                for it=1:max(size(TECS0{1}))
                    lon=Lon1+teccnt*DLon;
                    lon_index=((lon-Lon1)/DLon)+1;
                    TECS(lat_index,lon_index,time_index)=TECS0{1}(it);
                    teccnt=teccnt+1;
                end
                tline=fgets(fid);
            end
        end
        tline=fgets(fid);
    end
    tline=fgets(fid);
end

                
            
            
            

fclose(fid);
end