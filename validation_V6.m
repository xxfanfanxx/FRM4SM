%% Programme de validation globale pour:
% - observation des series temporelles de l'ISMN et du DGG correspondant
% - observation des données auxiliaires types flag, dqx,...
% - calcul des scores correspondant

clear all
close all;
dayref_smos = datenum(2000,01,01);

%% Récupération des noms de sites
src='/media/mialona/SMOS_DATA/Other/ISMN/WORLD_20100601_2020/';
a=dir(src);
for c=3:size(a,1)
    b=dir(strcat(src,a(c).name));
    site(c-2).name=a(c).name;
end

%% Récupérer le header pour connaitre les variables SMOS L2 dispo
filename = '/home/mialona/Documents/Time_serie_tools/L2_bashTools/udpExportTool_V1/src/outputFile_AACES_2010';
delimiter = ',';
endRow = 1;
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, endRow, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
head = [dataArray{1:end-1}]';
clearvars filename delimiter endRow formatSpec fileID dataArray ans;

figure('Position',[80 896 2285 430]);
axes_h = gca;

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
% 34:PBO_H2O            OK
% 35:PTSMN              OK
% 36:REMEDHUS           OK
% 37:RISMA              OK
% 38:RSMN               OK
% 39:SCAN               OK
% 40:SKKU               OK
% 41:SMOSMANIA          OK
% 42:SNOTEL             OK
% 43:SOILSCAPE          OK
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

%% Parametre de filtrage
filtre_temps_ech=1800;  %30 min entre mesure insitu et SMOS
filtre_profondeur_sonde=1; % ex: 1m
filtre_RFI=0.1; %0.2

%% Parametre d'affichage
opt=1; %analyse qualite et STREE
wa=0; % analyse WA
pausee=1;

%% OPTION FLAG+STREE
stree={'1 All open water','2 Heterogeneous OW','3 Strong topo pollution','4 Soft topo pollution','5 All wet snow','6 All mixed snow',...
    '7 Wet snow pollution','8 Mixed snow pollution','9 All frost','10 Frost pollution','11 Forest cover','12 Soil cover1','13 All wetlands',...
    '14 All barren','15 All ice','16 All urban','17 Heterogeneous'};

%% Analyse du site
for gj=1:52 % indice du site

    %récupération des noms
    nom_sitez=site(gj).name;
    nom_site=nom_sitez;
    nom_sitez=replace(nom_sitez,'-','_');
    nom_site=nom_sitez;

    %Chargement du Iprd correspondant
    load(strcat('/media/mialona/SMOS_DATA/Other/ISMN/Iprd_20100601_2020/Iprd_',nom_sitez,'.mat'));

    for ih=1:size(Iprd,2) %boucle sur tous les sou-sites de chaque sites
%     for ih=14:18 %boucle sur tous les sou-sites de chaque sites
        clf;
        %Choix de la variable et de la profondeur
        mask_sensor_type=strcmpi(Iprd{1,ih}.sensor_type,{'sm'}); % selectionne uniquement les données de SM
        mask_sensor_depthmax=(Iprd{1,ih}.depth(:,2)>=0)';
        mask_sensor_depthmin=(Iprd{1,ih}.depth(:,2)<=filtre_profondeur_sonde)'; % limite de profondeur
        if sum(mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin) % Sélection de la serie temporelle correspondante

            % Recuperation des donnees insitu
            temp_sm=(Iprd{1,ih}.par(:,mask_sensor_type & mask_sensor_depthmax & mask_sensor_depthmin));
            temp_time=Iprd{1,ih}.vd;
            temp_dggid=Iprd{1,ih}.PID(1);
            temp_qc1=Iprd{1,ih}.qc1(:,mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin);
            typesen=Iprd{1,ih}.sensor(mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin);
            depson=Iprd{1,ih}.depth(mask_sensor_type  & mask_sensor_depthmax & mask_sensor_depthmin,2);
            
            % prepraration des champs pour les L2SMOS
            timesmos_total=[];
            dggid_total=[];
            smsmos_total=[];
            MAVA_O_total=[];
            rfi_x_total=[];
            rfi_y_total=[];
            Scienceflag_total=[];
            Stree1_total=[];
            Stree2_total=[];
            chi2_total=[];

            subplot(1,4,[1 2 3]);
            plot(temp_time,temp_sm);
            hold on;
            
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
                eval(strcat('Scienceflag=outputFile',nom_site,num2str(annee),'(:,69:98);'));
                eval(strcat('Stree1=outputFile',nom_site,num2str(annee),'(:,104);'));
                eval(strcat('Stree2=outputFile',nom_site,num2str(annee),'(:,105);'));
                eval(strcat('chi2=outputFile',nom_site,num2str(annee),'(:,50);'));
                smsmos(smsmos<0)=NaN;
                [dggidlist,nn,bb]=unique(dggid);
                timesmos_total=cat(1,timesmos_total,timesmos);
                dggid_total=cat(1,dggid_total,dggid);
                smsmos_total=cat(1,smsmos_total,smsmos);
                rfi_x_total=cat(1,rfi_x_total,RFI_X);
                rfi_y_total=cat(1,rfi_y_total,RFI_Y);
                MAVA_O_total=cat(1,MAVA_O_total,MAVA_O);
                Scienceflag_total=cat(1,Scienceflag_total,Scienceflag);
                Stree1_total=cat(1,Stree1_total,Stree1);
                Stree2_total=cat(1,Stree2_total,Stree2);
                chi2_total=cat(1,chi2_total,chi2);
                
                eval(strcat('clear outputFile',nom_site,num2str(annee)));
            end
            
            if sum(dggidlist==temp_dggid)
                plot(timesmos_total(dggid_total==temp_dggid),smsmos_total(dggid_total==temp_dggid),'.k');
                hold on;
            end
            axis([datenum(2010,01,01) datenum(2021,01,01) 0 1]);
            datetick;
            grid on;
            
            ylabel('Soil Moisture m^3.m^{-3}');
            legend([strcat(typesen','  depth=',num2str(depson),'m');'SMOSl2v700']);
            title([strcat(nom_sitez,'-',Iprd{1,ih}.name),num2str(Iprd{1,ih}.PID(1))]);
            
            
            
            %% Echantillonnnage de l'insitu
            [toto,distance]=knnsearch(temp_time',timesmos_total(dggid_total==temp_dggid));
            sminsitu_reechantillon=temp_sm(toto,:);
            %calcul des distances en secondes
            distance_ech=distance*86400;
            
            %% Echantillonne le SMOS correspondant au DGG
            sm_smosech=smsmos_total(dggid_total==temp_dggid);
            
            %% Mask RFI
            rfi_total=(rfi_x_total(dggid_total==temp_dggid)+rfi_y_total(dggid_total==temp_dggid))./MAVA_O_total(dggid_total==temp_dggid);
            mask_rfi=(rfi_total<=filtre_RFI);
            
            %% Mask delay ech
            mask_t_ech=distance_ech<=filtre_temps_ech;
            
            %% Scatterplot
            subplot(1,4,4);
            plot(sminsitu_reechantillon(mask_t_ech & mask_rfi,:),sm_smosech(mask_t_ech & mask_rfi),'.');
            xlabel('in-situ Soil Moisture');
            ylabel('SMOS Soil Moisture');
            title(strcat('Filtre acq: ',num2str(filtre_temps_ech),' s.  Filtre RFI= ',num2str(filtre_RFI),' (removed=',num2str((sum(~mask_rfi)/size(mask_rfi,1))*100),'%)'));
            line([0 1],[0 1],'Color','k');
            grid on;
            axis([0 1 0 1]);
            axis(gca,'square');
            
            %% Mask pour calcul score
            mask_nan_insitu=~isnan(sminsitu_reechantillon);
            mask_nan_smos=~isnan(sm_smosech);
            clear R P
            coco=colormap(lines(size(mask_nan_insitu,2)));
            
            for jk=1:size(mask_nan_insitu,2)
                sm_smos_corr=sm_smosech(mask_rfi & mask_t_ech & mask_nan_insitu(:,jk) & mask_nan_smos ,:);
                sm_insitu_corr=sminsitu_reechantillon(mask_rfi & mask_t_ech & mask_nan_insitu(:,jk) & mask_nan_smos,jk);
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
                end
                hold on;
            end
            if opt
                
                figure(2);
                clf
                subplot(121);
                
                pcolor(timesmos_total(dggid_total==temp_dggid),1:30,Scienceflag_total(dggid_total==temp_dggid,:)');
                shading flat
                set(gca,'XTickLabel',timesmos_total(dggid_total==temp_dggid));
                datetick
                yticks(1:30);
                yticklabels(head(69:98));
                colormap(flipud(bone));
                axis([datenum(2010,01,01) datenum(2021,01,01) 1 31]);
                grid on;
                title(gca,'SMOS Science Flag');
                subplot(122);
                
                plot(timesmos_total(dggid_total==temp_dggid),Stree1_total(dggid_total==temp_dggid),'k.');
                datetick
                yticks(1:12);
                yticklabels(stree);
                axis([datenum(2010,01,01) datenum(2021,01,01) 1 12]);
                grid on;
                title(gca,'SMOS Stree1');
                %                 subplot(223);
                %                 title('SMOS RFI');
                %                plot(timesmos_total(dggid_total==temp_dggid),rfi_total,'k.');
                %                 datetick
                %                 axis([datenum(2010,01,01) datenum(2021,01,01) 0 max(rfi_total)]);
                %                 grid on;
                %                 subplot(224);
                %                 title('SMOS CHI2');
                %                plot(timesmos_total(dggid_total==temp_dggid),chi2_total(dggid_total==temp_dggid),'k.');
                %                 datetick
                %                 axis([datenum(2010,01,01) datenum(2021,01,01) 0 max(chi2_total(dggid_total==temp_dggid))]);
                %                 grid on;
                %
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
                
            end
            if pausee
                pause;
            else
                pause;
                figure('Position',[80 896 2285 430]);
            end
            if wa
                rcupe_wa(temp_dggid,1);
                pause;
            end
        end
    end
    
end


