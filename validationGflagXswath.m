%% VALIDATION AVEC GFLAG ET XSWATH

%% Récupération des noms de sites
clear all
close all;
dayref_smos = datenum(2000,01,01) ;

src='/media/mialona/SMOS_DATA/Other/ISMN/WORLD_20100601_2020/';
a=dir(src);
for c=3:size(a,1)
    b=dir(strcat(src,a(c).name));
    site(c-2).name=a(c).name;
end
%% Récupérer le header pour connaitre les variables dispo
filename = '/home/mialona/Documents/Time_serie_tools/L2_bashTools/udpExportTool_V1/src/outputFile_AACES_2010';
delimiter = ',';
endRow = 1;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
head = [dataArray{1:end-1}]';
clearvars filename delimiter endRow formatSpec fileID dataArray ans;

%% Liste des sites
% 1:AACES               OK
% 2:AMMA-CATCH           OK
% 3:ARM                  OK
% 4:AWDN                 OK
% 5:BIEBRZA_S-1          OK
% 6:BNZ-LTER             OK
% 7:CALABRIA            OK
% 8:CAMPANIA            OK
% 9:COSMOS               OK
% 10:CTP_SMTMN           OK
% 11:DAHRA               OK
% 12:FLUXNET-AMERIFLUX   OK
% 13:FMI                  OK
% 14:FR_Aqui             OK
% 15:GROW                 OK
% 16:GTK                  OK
% 17:HOBE                 OK
% 18:HYDROL-NET_PERUGIA   OK
% 19:HiWATER_EHWSN        ok
% 20:ICN                  OK
% 21:IIT_KANPUR           OK
% 22:IMA_CAN1             OK
% 23:IPE                  OK
% 24:KHOREZM             OK
% 25:KIHS_CMC            OK
% 26:KIHS_SMC            OK
% 27:LAB-net            OK
% 28:MAQU               OK
% 29:METEROBS           OK
% 30:MOL-RAO            OK
% 31:MySMNet            OK
% 32:ORACLE             OK
% 33:OZNET              OK
% 34:PBO_H2O            > a extraire            XXXXXXXXXXXXXXXXXXXXXXXX
% 35:PTSMN              OK
% 36:REMEDHUS           OK
% 37:RISMA              OK
% 38:RSMN               OK
% 39:SCAN               OK
% 40:SKKU               OK
% 41:SMOSMANIA          OK
% 42:SNOTEL             OK
% 43:SOILSCAPE          -> a extraire            XXXXXXXXXXXXXXXXXXXXXXXX
% 44:SW-WHU             OK
% 45:SWEX_POLAND        OK
% 46:TERENO             OK
% 47:UDC_SMOS           OK
% 48:UMBRIA             OK
% 49:UMSUOL             OK
% 50:USCRN              OK
% 51:VAS                OK
% 52:VDS                OK
% 53:WEGENERNET         OK
% 54:WSMN               OK
% 55:iRON               OK


pays_site={'Australia','AO','USA','USA','Poland','Alaska','Italy','Italy','USA','China','Senegal','USA','Finland','France','UK',...
    'Finland','Denmark','Italy','China','USA','India','Italy','Spain','Uzbekistan','Korea','Korea','Chile','China','Italy','Germany','Malaysia',...
    'France','Australia','USA','NewZealand','Spain','Canada','Romania','USA','Korea','France','USA','USA','China','Poland','Germany','Germany',...
    'Italy','Italy','USA','Spain','Myanmar','Austria','UK','USA'};
%% Parametre de filtrage
filtre_temps_ech=1800;  %30 min entre mesure insitu et SMOS
filtre_profondeur_sonde=0.1;
filtre_RFI=0.1; %0.2
fid = fopen(strcat('/home/mialona/Documents/Time_serie_tools/scores_QFLAG',datestr(now,'DD_mm_YY')),'w');
fprintf(fid,'%s\n','Pays,Nom_Site,Sous_site,DGG,type,depth,RFI_seuil,nsampleON,RFI_removed,delay_acq,R,pval,RMSE,BIAS,ubRMSE');
%% Analyse du site
for gj=1:55
    %récupération des noms
    nom_sitez=site(gj).name
    nom_site=nom_sitez;
    nom_sitez=replace(nom_sitez,'-','_');
    nom_site=nom_sitez;
    %Chargement du Iprd correspondant
    load(strcat('/media/mialona/SMOS_DATA/Other/ISMN/Iprd_20100601_2020/Iprd_',nom_sitez,'.mat'));
         
    for ih=1:size(Iprd,2) %boucle sur tous les sou-sites de chaque sites
        clf;
        %Choix de la variable et de la profondeur
        mask_sensor_type=strcmpi(Iprd{1,ih}.sensor_type,{'sm'});
        mask_sensor_depthmax=(Iprd{1,ih}.depth(:,2)>=0)';
        mask_sensor_depthmin=(Iprd{1,ih}.depth(:,2)<=filtre_profondeur_sonde)';
        if sum(mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin)
            timesmos_total=[];
            dggid_total=[];
            smsmos_total=[];
            MAVA_O_total=[];
            rfi_x_total=[];
            rfi_y_total=[];
            
            temp_sm=(Iprd{1,ih}.par(:,mask_sensor_type & mask_sensor_depthmax & mask_sensor_depthmin));
            temp_time=Iprd{1,ih}.vd;
            temp_dggid=Iprd{1,ih}.PID(1);
            temp_qc1=Iprd{1,ih}.qc1(:,mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin);

            typesen=Iprd{1,ih}.sensor(mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin);
            depson=Iprd{1,ih}.depth(mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin,2);
            
            for annee=2010:2020
                filename = strcat('/home/mialona/Documents/Time_serie_tools/L2_bashTools/udpExportTool_V1/src/outputFile_',nom_site,'_',num2str(annee));
                delimiter = ',';
                startRow = 2;
                formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
                fileID = fopen(filename,'r');
                dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
                fclose(fileID);
                
                eval(strcat('outputFile',nom_site,num2str(annee),' = [dataArray{1:end-1}];'));
                clearvars filename delimiter startRow formatSpec fileID dataArray ans;
                eval(strcat('dggid=outputFile',nom_site,num2str(annee),'(:,1);'));
                eval(strcat('timesmos= (dayref_smos+outputFile',nom_site,num2str(annee),'(:,5))+(outputFile',nom_site,num2str(annee),'(:,6)* 1/86400)+((outputFile',nom_site,num2str(annee),'(:,7)*1e-6)* 1/86400);'));
                timesmos(timesmos==dayref_smos)=NaN;
                eval(strcat('smsmos=outputFile',nom_site,num2str(annee),'(:,8);'));
                eval(strcat('MAVA_O=outputFile',nom_site,num2str(annee),'(:,53);'));   
                eval(strcat('RFI_X=outputFile',nom_site,num2str(annee),'(:,113);'));                
                eval(strcat('RFI_Y=outputFile',nom_site,num2str(annee),'(:,114);'));                
                
                smsmos(smsmos<0)=NaN;
                [dggidlist,nn,bb]=unique(dggid);
                timesmos_total=cat(1,timesmos_total,timesmos);
                dggid_total=cat(1,dggid_total,dggid);
                smsmos_total=cat(1,smsmos_total,smsmos);
                rfi_x_total=cat(1,rfi_x_total,RFI_X);
                rfi_y_total=cat(1,rfi_y_total,RFI_Y); 
                MAVA_O_total=cat(1,MAVA_O_total,MAVA_O);
                eval(strcat('clear outputFile',nom_site,num2str(annee)));
            end
                       

            
            %% Echantillonnnage de l'insitu
            [toto,distance]=knnsearch(temp_time',timesmos_total(dggid_total==temp_dggid));
            sminsitu_reechantillon=temp_sm(toto,:);
            
            %% Filtre valeurs extremes
            sminsitu_reechantillon(sminsitu_reechantillon>0.8)=NaN;
            sminsitu_reechantillon(sminsitu_reechantillon<=0)=NaN;
            
            %% calcul des distances en secondes
            distance_ech=distance*86400;
            
            %% Echantillonne le SMOS correspondant au DGG
            sm_smosech=smsmos_total(dggid_total==temp_dggid);
            sminsitu_reechantillon(sm_smosech>0.8)=NaN;
            sminsitu_reechantillon(sm_smosech<=0)=NaN;
            
            %% Mask RFI
            rfi_total=(rfi_x_total(dggid_total==temp_dggid)+rfi_y_total(dggid_total==temp_dggid))./MAVA_O_total(dggid_total==temp_dggid);
            mask_rfi=(rfi_total<=filtre_RFI);
            
            %% Mask delay ech
            mask_t_ech=distance_ech<=filtre_temps_ech;
            
            %% Scatterplot

            %% Mask pour calcul score
            mask_nan_insitu=~isnan(sminsitu_reechantillon);
            mask_nan_smos=~isnan(sm_smosech);
            clear R P
            coco=colormap(lines(size(mask_nan_insitu,2)));
            
            %% Mask QFLAG
            mask_qflag=temp_qc1(toto,:)==1;

            for jk=1:size(mask_nan_insitu,2)
                sm_smos_corr=sm_smosech(mask_qflag(:,jk) & mask_rfi & mask_t_ech & mask_nan_insitu(:,jk) & mask_nan_smos ,:);
                sm_insitu_corr=sminsitu_reechantillon(mask_qflag(:,jk) & mask_rfi & mask_t_ech & mask_nan_insitu(:,jk) & mask_nan_smos,jk);
                if size(sm_smos_corr,1)>1
                    [R,P] = corr(sm_smos_corr,sm_insitu_corr);
                    d=sm_smos_corr-sm_insitu_corr;
                    mean_smos=mean(sm_smos_corr);
                    mean_insitu=mean(sm_insitu_corr);
                    bias=mean(d);
                    rmse = sqrt(sum(d.^2)./length(sm_insitu_corr));
                    urmse = sqrt(rmse.^2-bias.^2);
                    bias=mean(d);
                    std_insitu=std(sm_insitu_corr);
                    std_smos=std(sm_smos_corr);
                    std_dif=std(d);
                    text(0,0.5+jk/20,strcat('R=',num2str(R),'  p-value=',num2str(P),' RMSE=',num2str(rmse),'(',num2str(urmse),') BIAIS=',num2str(bias)),'color',coco(jk,:),'FontWeight','Bold');
                    fprintf(fid,'%s\n',strcat(cell2mat(pays_site(gj)),',',nom_site,',',Iprd{1,ih}.name,',',num2str(Iprd{1,ih}.PID(1)),',',cell2mat(typesen(jk)),...
                        ',',num2str(depson(jk)),',',num2str(filtre_RFI),...
                        ',',num2str(size(sm_smos_corr,1)),',',num2str((sum(~mask_rfi)/size(mask_rfi,1))*100),...
                        ',',num2str(filtre_temps_ech),',',num2str(R),...
                        ',',num2str(P),',',num2str(rmse),',',num2str(bias),',',num2str(urmse)));
                end
                hold on;
            end
        end
    end
end
                         
                fclose(fid)



figure(3);
                clf
                plot(temp_time,temp_qc1,'.');
                yticks(1:size(Iprd{1,ih}.qc1id,2));
                yticklabels(Iprd{1,ih}.qc1id);
                datetick;
                axis([datenum(2010,01,01) datenum(2021,01,01) 0 size(Iprd{1,ih}.qc1id,2)]);
                grid on;
                title('ISMN Quality')
                legend(strcat(typesen','  depth=',num2str(depson),'m'));