function SP3_Satellie_Position = SP3_File_Read(fid)

tline=fgetl(fid);a={};EOH=0;
k=1;
while ischar(tline)
   a(k,1)=cellstr(tline);
   EOH=findstr(tline,'CLK:CMB');
 if EOH>1
    eoh=k;
 end
   tline=fgetl(fid);
   k=k+1;
end
 nos=eoh+1;
 
 t=1;
 while nos < size(a,1)
     Day = str2num(a{nos}(4:13));
     time=str2num(a{nos}(15:31));
%      time=3600*time(1)+60*time(2)+time(3);
     Date = [Day time];
     for i=1:32
        num_s{t}(i,1)=str2num(a{nos+i,1}(3:4));
        x{t}(i,1)=str2num(a{nos+i,1}(6:18))*1000;
        y{t}(i,1)=str2num(a{nos+i,1}(20:32))*1000;
        z{t}(i,1)=str2num(a{nos+i,1}(34:46))*1000;   
        errort{t}(i,1)=str2num(a{nos+i,1}(48:60));
        SP3_Satellie_Position{i}(t,:)=[Date , x{t}(i,1) y{t}(i,1) z{t}(i,1) errort{t}(i,1) time];
        if errort{t}(i,1)==999999.999999;
        errort{t}(i,1)=0;
        end
     end
     nos=nos+33;
     t=t+1;
 end
