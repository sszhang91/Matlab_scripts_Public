function [xvect,yvect,M,x0,y0]=basic_read_gsf_ver4(pathdir)
    flag_vect=zeros(1,6); % for nx,ny,Lx,Ly,x0,y0
    
    fid=fopen(pathdir);
    flag_stop=0;
    lcount=0;
    while(flag_stop==0)
        lcount=lcount+1;
        str=fgetl(fid);
        rnan=find(str=='=');
        if(length(strfind(str,'XRes'))>0)
            nx=str2num(str(rnan(1)+1:end));
            flag_vect(1)=1;
        end
        if(length(strfind(str,'YRes'))>0)
            ny=str2num(str(rnan(1)+1:end));
            flag_vect(2)=1;
        end
        if(length(strfind(str,'XReal'))>0)
            Lx=str2num(str(rnan(1)+1:end));
            flag_vect(3)=1;
        end
        if(length(strfind(str,'YReal'))>0)
            Ly=str2num(str(rnan(1)+1:end));
            flag_vect(4)=1;
        end
        if(length(strfind(str,'XOffset'))>0)
            x0=str2num(str(rnan(1)+1:end));
            flag_vect(5)=1;
        end
        if(length(strfind(str,'YOffset'))>0)
            y0=str2num(str(rnan(1)+1:end));
            flag_vect(6)=1;
        end
        if((~isletter(str(1))))
            flag_stop=1;
        end
    end
    if(flag_vect(5)==0)
        x0=0;
        y0=0;
    end
    
    frewind(fid);
    for k=1:lcount-1
        fgetl(fid);
    end;
    
    count0=0;
    flag=0;
    while(flag==0)
        if(count0+1<=length(str))
            if(char(str(count0+1))==0)
                count0=count0+1;
            else
                flag=1;
            end
        else
            flag=1;
            count0=length(str);
        end
    end

    fread(fid,count0,'char');

    N=nx*ny;
    a=fread(fid,N,'float32');
    fclose(fid);

    xvect=linspace(-Lx/2,Lx/2,nx);
    yvect=linspace(-Ly/2,Ly/2,ny);

    M=reshape(a,nx,ny);
    M=M';
end