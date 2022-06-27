clear all;
% COMMENT Arno 2022 06 27

%-- 04/11/2021 11:46:41 --%
addpath('/home/mialona/Téléchargements/aux_data');
addpath('/home/mialona/Documents/Journal_de_bord/Semaine_46/m_map1.4/m_map/');
addpath('/media/mialona/SMOS_DATA/Tools/Matlab_Tools/Utils');
addpath('/media/mialona/SMOS_DATA/Tools/Matlab_Tools/DFFG/');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/L2/L2_MatlabTools/DFFG');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/Grid_SMOS/DFFG');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/Grid_SMOS/Working_Area/');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/L2/L2_MatlabTools/Geo');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/L2/L2_MatlabTools/DGG');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/Informatique/Matlab/Geoloc');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/L2/L2_MatlabTools/Utils/');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/BB/BB/WEF');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/BB/Etude_Surface_WA/Find_Nodes/SoilProperties');
addpath('/home/mialona/Téléchargements/xml_toolbox-3.1.2_matlab-6.5/xml_toolbox');
addpath('/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/BB/Utils');
m_proj('mercator','long',[-180 180],'lat',[-80 80]);
nameDFFFra=[];
nameLAI=[];
nameSoil_P=[];
%% -----------------------%
%    load DFFG FRA  %
%% -----------------------%
pathDFFFRa  = '/home/mialona/Téléchargements/aux_data/dffg_fractions/' ;
if isempty(nameDFFFra)
    nameDFFFra = 'SM_OPER_AUX_DFFFRA_20050101T000000_20500101T000000_001_007_3' ;
end
eeap_dffgfra_headers=load_dffg_data_eef_V2([pathDFFFRa,'/',nameDFFFra],[],[],[]) ;
%% -----------------------%
%    load DFFG LAI    %
%% -----------------------%
pathLAI = '/home/mialona/Téléchargements/aux_data/dffg_lai/' ;
if isempty(nameLAI)
    nameLAI = 'SM_OPER_AUX_DFFLAI_20150720T000000_20150730T014000_600_001_3' ;
    %   nameLAI = 'SM_OPER_AUX_DFFLMX_20050101T000000_20500101T000000_001_002_3' ;
end
eeap_dffglai_headers=load_dffg_data_eef_V2(fullfile(pathLAI,nameLAI),[],[],[]) ;
clear hdr hdr_ascii
%% -----------------------%
%   load JPL texture map %
%%------------------------------%
eeap_dffgjpltexture_headers=load_dffg_data_eef_V2('/home/mialona/Téléchargements/aux_data/dffg_soil_properties/SM_OPER_AUX_DFFSOI_20050101T000000_20500101T000000_001_003_9',[],[],[]) ;
%% ----------------------------%
%   Load Soil Properties  %
%% ----------------------------%
pathSoil_P = '/home/mialona/Téléchargements/aux_data/dffg_soil_properties/';
if isempty(nameSoil_P)
    nameSoil_P = 'SM_OPER_AUX_DFFSOI_20050101T000000_20500101T000000_001_003_9' ;
end
% Soil_P=load_soil_properties(fullfile(pathSoil_P,nameSoil_P));
Soil_P=load_dffg_data_eef_V2(fullfile(pathSoil_P,nameSoil_P),[],[],[]) ;
for izone = 1:74
    fno(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(1,:);
    ffo(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(3,:);
    fwl(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(5,:);
    fwp(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(7,:);
    fws(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(9,:);
    feb(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(11,:);
    fei(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(13,:);
    fts(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(17,:);
    ftm(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(18,:);
    feu(izone).data = eeap_dffgfra_headers(izone).data_section.aux_dfffra(15,:);
end % end loop on zone
for izone = 1:74
    lai(izone).data = eeap_dffglai_headers(izone).data_section.aux_dfflai.lai ;
    a = eeap_dffgjpltexture_headers(izone).data_section.aux_dffsoi ;
    sand(izone).data= double(a(1,:));
    clay(izone).data = double(a(2,:));
    bulk_density(izone).data = double(a(3,:));
end % end loop on zone
figure(1);
%% LAI
for gh=1:74
    maxlai(gh)=max(lai(gh).data);
    minlai(gh)=min(lai(gh).data);
    maxsand(gh)=max(double(sand(gh).data));
    minsand(gh)=min(double(sand(gh).data));
    maxclay(gh)=max(double(clay(gh).data));
    minclay(gh)=min(double(clay(gh).data));
    maxbd(gh)=max(double(bulk_density(gh).data));
    minbd(gh)=min(double(bulk_density(gh).data));
    maxwp(gh)=max(double(fwp(gh).data));
end

m_proj('mercator','long',[-180 180],'lat',[-80 80]);

for gh=[1:74]
    [lat,lon,cell_box]=all_dffg_to_latlon(eeap_dffgjpltexture_headers(gh));
    lon(lon>180)=lon(lon>180)-360;

    datsandr=(-6.3018e-05)*(double(sand(gh).data))+0.085;
    datf=-0.000525*double(fno(gh).data/2)+0.1213;
    datfff=0.00051*double(ffo(gh).data/2)+0.0704;
    datmm=0.00034*double(ftm(gh).data/2)+0.079;
    datms=0.0016*double(fts(gh).data/2)+0.081;
    datclaym=0.00064*(double(clay(gh).data))+0.07;
    datwm=0.000866*double(fws(gh).data)+0.081;
    datwp=0.00264*double(fwp(gh).data)+0.079;
    datbde=-0.083*double(bulk_density(gh).data)+0.13;


  %  temp=zeros(length(datee),1);
    temp=(datf+datfff+datms+datmm+datclaym+datsandr+datbde+datwp)/8;
    temp(double(fws(gh).data)>0)=nan;
    temp(double(feu(gh).data)>0)=nan;
    temp(double(fwp(gh).data)>95)=nan;
    m_scatter(lon,lat,0.8,temp,'.');hold on;
end

 load('/home/mialona/Documents/Journal_de_bord/Semaine_46/climatosnow.mat')
 toto=snow;
toto(toto<1200)=nan;
toto(toto==1200)=0;

hold on;
m_pcolor(lon_snow,-lat_snow,toto);
tt=colorbar;
t=hot;
t(256,:)=[0.5 0.5 0.5];
colormap(flipud(t));
caxis([0.055 0.1]);
ylabel(tt,'Expected ubRMSE (m^3.m^{-3})');
m_coast('color',[0 0 0],'LineWidth',0.5);
hold on;
m_grid('linestyle','none','box','fancy','tickdir','in');
title({'Committed areas for the ubRMSE score (mean range)','ubRMSE$=$f(FNO,FFO,FTS,FTM,SAND,CLAY,BulkD,FWP)','Trained on ISMN vs. SMOSL2 (t$\leq$30min, RFI$\leq$0.1, maxprobedepth$\leq$0.1m)'}, 'Interpreter', 'latex');
clear all;


%% MASKNEIGE
% 
% clear all;
% cd /home/mialona/Téléchargements/drive-download-20211117T154423Z-001/
% addpath('/home/mialona/Documents/Journal_de_bord/Semaine_46/m_map1.4/m_map/');
% m_proj('mercator','long',[-180 180],'lat',[-80 80]);
% snow=[];
% for tg=1:12
%     eval(strcat('temp=importdata(''myExportImageTask',num2str(tg),'.tif'');'));
%     temp(temp<10)=0;
%     temp(temp>=10)=1;
%     if tg==1
%         snow=temp;
%     else
%         snow=snow+temp;
%     end
% end
% lat_snow=linspace(-90,90,2004);
% lon_snow=linspace(-180,180,4008);
% % 
% % snow(snow<=3)=nan;
% % snow(snow>3)=1;
% % snow(snow==1)=1;
% % snow(snow>=1 & snow<3 )=;
% % snow(snow>=25 & snow<50 )=25;
% % snow(snow>=50 & snow<100 )=50;
% % snow(snow==100)=100;
% hold on;

% toto(toto>0)=nan;
% m_pcolor(lon_snow,-lat_snow,zeros(2004,4008),'alphadata',snow./12,'facealpha','flat','alphadatamapping','scaled');
% m_coast('color',[0 0 0],'LineWidth',0.5);
% m_grid('linestyle','none','box','fancy','tickdir','in');
% 
% exportgraphics(gcf,'CAubRMSENOURBAN.pdf','ContentType','vector','Resolution',600);


