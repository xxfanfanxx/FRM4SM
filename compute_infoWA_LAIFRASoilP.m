function [dggo] = compute_infoWA_LAIFRASoilP(coord,nameDFFFra,nameLAI,nameSoil_P)

% Matlab fct compute_infoWA_LAIFRASoilP[lat lon])
% find A WA for a Node
% => computes its Fraction, LAI, and Soil Properties (sand, clay and rho)
%
%

% INPUTS
% coord : DGG coordinates
%         either
%         2 x n matrix => latitude and longitude of each nodes
%         or
%         1 x n vector => DGG id
% nameDFFFra : string of char => file name of DFFG Fraction file, L2 ADF
%              if empty a default file is used (delivered with the SML2pp)
% nameLAI : string of char => file name of DFFG LAI file, L2 ADF
%          if empty a default file is used but not the last one in time
%
% OUTPUTS
% DGG : structure
%       containing information about Working Area of DGG nodes
%       fields :
%       .dgg : substructure with
%              .pidx, .zidx, .id, .dist, .lat, .lon, .alt, .xyz, .lsf
%       .LAI : substructure with info about LAI
%              .histcount, .mean, .std
%       .Fraction : 1 X 12 vector of decimal => fraction (Mean Wef)
%       .Texture_MeanSand: Mean % of Sand in the Working Area (Mean WEF)
%       .Texture_MeanClay:           Clay
%       .Texture_MeanRho :           Bulk density
%       .Texture_stdSand : std deviation of sand %
%       .Texture_stdClay :                  clay %
%       .Texture_stdRho  :                  Bulk density

% add 2 path
% /home/mialon/Documents/BB/WEF/
% /home/mialon/Documents/Informatique/Matlab/
% /home/mialon/Documents/SMOS/L2
%
addpath('/home/mialona/Téléchargements/aux_data');
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


option_figure = 0  ; % for debug and check

%waitbar(0,['Nodes to be processed : ',num2str(length(coord))]) ;
if nargin== 0 || isempty(coord)
    % SMOSREX coordinates
    lon = 1.325 ;
    lat = 43.415   ;
end
p =pwd ;
if size(coord,1) == 1 && size(coord,2) == 1
    % inputs coord are DGG Id
    cd /media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/Grid_SMOS/DGG ;
    [coord] = find_latlon_DGG(coord) ;
    lat = coord(:,2) ;
    lon = coord(:,3) ;
elseif size(coord,1) == 2
    lat = coord(1,:)' ;
    lon = coord(2,:)' ;
elseif  size(coord,2) == 2
    lat = coord(:,1) ;
    lon = coord(:,2) ;
end
cd(p) ;
% % Find index of Fraction of Interest
% fmtext={'FNO','FFO','FWL','FWP','FWS','FEB','FEI','FEU','FTS','FTM'} ;
%
% idx_Fraction = strcmp(fmtext,FractionOfInterest) ;
% if ~isempty(idx_Fraction)
%    idx_Fraction = find(idx_Fraction==1) ;
% end

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
%% -------------------------------------------%
%    LOAD DFFG Working Area info   %
%% --------------------------------------------%
load ('/home/mialona/Téléchargements/aux_data/tab_isea4h9-dem-landsea.mat') ;
%[dgg] = find_WA_DFFG(lat,lon,eeap_dffgfra_headers,tab_isea4h9) ;

dgg = struct('dgg_id',{},'dgg_lat',{},'dgg_lon',{},'wa_center',{},'wa_lat',{},'wa_lon',{},...
    'mean_wef',{},'fraction',{}) ;
for k = 1:length(lat)
    dgginfo = find_WA_DFFG(lat(k),lon(k),eeap_dffgfra_headers,tab_isea4h9) ;
    wa_info = dgginfo.wa_info ;
    mw = meanwef_wa_dffg(wa_info) ;
    dgg(k).dgg_id=dgginfo.dgg_info.id ;
    dgg(k).dgg_lat=dgginfo.dgg_info.lat ;
    dgg(k).dgg_lon=dgginfo.dgg_info.lon ;
    dgg(k).wa_center=[dgginfo.wa_info.latc dgginfo.wa_info.lonc] ;
    dgg(k).wa_lat=dgginfo.wa_info.lat ;
    dgg(k).wa_lon=dgginfo.wa_info.lon ;
    dgg(k).mean_wef=mw ;
    
    zone = unique(wa_info.eeapzidx) ;
    % fraction = zeros(10,size(mw,1),size(mw,2)) ;
    fraction = zeros(18,size(mw,1),size(mw,2)) ;
    % fno, ffo, fwl, fwp, fws, feb, fei, feu, fts, ftm
    %
    % codefraction = zeros(10,size(mw,1),size(mw,2)) ;
    lai = zeros(size(mw,1),size(mw,2)) ;
    texture = zeros(8,size(mw,1),size(mw,2)) ;
    zone(isinf(zone)) =[] ;
    for izone = zone'
        idx_zone = izone + 1 ;
        % cells of the WA (in 35*35) belonging to the Zone
        idx_cell_in_WA = find(wa_info.eeapzidx==izone) ;
        % p index in the dffg grid of the previous cells
        idx_cellWA_inZone = wa_info.pidx(idx_cell_in_WA) + 1 ;
        
        % Fraction
        % uniquement fraction
        % fraction(:,idx_cell_in_WA) = eeap_dffgfra_headers(idx_zone).data_section.aux_dfffra([1,3,5,7,9,11,13,15,17,18],idx_cellWA_inZone) ;
        % fraction + code ecoclimap de la fraction la plus représentée
        fraction(:,idx_cell_in_WA) = eeap_dffgfra_headers(idx_zone).data_section.aux_dfffra(:,idx_cellWA_inZone) ;
        % LAI
        lai(idx_cell_in_WA) = eeap_dffglai_headers(idx_zone).data_section.aux_dfflai.lai(idx_cellWA_inZone) ;
        % texture
        a = eeap_dffgjpltexture_headers(idx_zone).data_section.aux_dffsoi(:,idx_cellWA_inZone) ;
        %        <Offset_SBD>000.000000</Offset_SBD>
        %       <Scaling_Factor_SBD>0.0000610350</Scaling_Factor_SBD>
        %       <Offset_W0>000.000000</Offset_W0>
        %       <Scaling_Factor_W0>0.0000610350</Scaling_Factor_W0>
        %       <Offset_BW0>000.000000</Offset_BW0>
        %       <Scaling_Factor_BW0>0.0000610350</Scaling_Factor_BW0>
        %       <Offset_XMVT>000.000000</Offset_XMVT>
        %       <Scaling_Factor_XMVT>0.0000610350</Scaling_Factor_XMVT>
        %       <Offset_FC>000.000000</Offset_FC>
        %       <Scaling_Factor_FC>0.0000610350</Scaling_Factor_FC>
        %       <Offset_RSOM>000.000000</Offset_RSOM>
        %       <Scaling_Factor_RSOM>0.0000610350</Scaling_Factor_RSOM>
        
        % FNO	Nominal
        % FFO	Forest
        % FWL	Wetland
        % FWP	Open Fresh Water
        % FWS	Open Saline Water
        % FEB	Barren
        % FEI	Ice
        % FEU	Urban
        % FTS	Strong topo
        % FTM	Moderate Topo
        
        sand(idx_cell_in_WA)= double(a(1,:));
        clay(idx_cell_in_WA) = double(a(2,:));
        bulk_density(idx_cell_in_WA) = double(a(3,:));
        
    end % end loop on zone
 disp(strcat(num2str(dgginfo.wa_info.ll_window(1)),',',num2str(dgginfo.wa_info.ll_window(3))))
 disp(strcat(num2str(dgginfo.wa_info.ll_window(1)),',',num2str(dgginfo.wa_info.ll_window(4))))
 disp(strcat(num2str(dgginfo.wa_info.ll_window(2)),',',num2str(dgginfo.wa_info.ll_window(3))))
 disp(strcat(num2str(dgginfo.wa_info.ll_window(2)),',',num2str(dgginfo.wa_info.ll_window(4))))
    fraction = permute(fraction,[2 3 1]) ;
    dgg(k).fraction=fraction ;
    
    cd '/media/mialona/6be020c1-ed6c-486f-8b28-e4efd7cde5c7/mialona/Documents/SMOS/BB/Etude_Surface_WA/Find_Nodes/SoilProperties' ;
    %     dgg_texture = compute_Texture_in_WA(lat(k),lon(k),Soil_P) ;
    
    
    
    
    %-----------------------------------------%
    % FIGURE => display for debug and check
    
    if option_figure == 1
        figure;
        subplot(3,5,1)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,1)));axis xy;
        title('FNO')
        colorbar ;
        axis square ;
        subplot(3,5,2)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,2)));axis xy;
        title('FFO')
        colorbar
        axis square ;
        subplot(3,5,3)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,3)));axis xy;
        title('FWL')
        colorbar
        axis square ;
        subplot(3,5,4)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,4)));axis xy;
        title('FWP')
        colorbar ;
        axis square ;
        subplot(3,5,5)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,5)));axis xy;
        title('FWS')
        colorbar
        axis square ;
        subplot(3,5,6)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,6)));axis xy;
        title('FEB')
        colorbar
        axis square ;
        subplot(3,5,7)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,7)));axis xy;
        title('FEI')
        colorbar
        axis square ;
        subplot(3,5,8)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,8)));axis xy;
        title('FEU')
        colorbar ;
        axis square ;
        subplot(3,5,9)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,9)));axis xy;
        title('FTS')
        colorbar
        axis square ;
        subplot(3,5,10)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),squeeze(fraction(:,:,10)));axis xy;
        title('FTM')
        colorbar
        axis square ;
        subplot(3,5,11)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),lai);axis xy;
        title('LAI')
        colorbar
        axis square ;
        subplot(3,5,12)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),reshape(sand,35,35));axis xy;
        title('Sand')
        colorbar
        axis square ;
        subplot(3,5,13)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),reshape(clay,35,35));axis xy;
        title('Clay')
        colorbar
        axis square ;
        subplot(3,5,14)
        imagesc(dgg.wa_lon(:,1),dgg.wa_lat(:,1),reshape(bulk_density,35,35));axis xy;
        title('BC')
        colorbar
        axis square ;
    end
            % FNO	Nominal
        % FFO	Forest
        % FWL	Wetland
        % FWP	Open Fresh Water
        % FWS	Open Saline Water
        % FEB	Barren
        % FEI	Ice
        % FEU	Urban
        % FTS	Strong topo
        % FTM	Moderate Topo
    dggo.fno=squeeze(fraction(:,:,1));
    dggo.ffo=squeeze(fraction(:,:,3));
    dggo.fwl=squeeze(fraction(:,:,5));
    dggo.fwp=squeeze(fraction(:,:,7));
    dggo.fws=squeeze(fraction(:,:,9));
    dggo.feb=squeeze(fraction(:,:,11));
    dggo.fei=squeeze(fraction(:,:,13));
    dggo.feu=squeeze(fraction(:,:,15));
    dggo.fts=squeeze(fraction(:,:,17));
    dggo.ftm=squeeze(fraction(:,:,18));
    dggo.lai=lai;
    dggo.sand=reshape(sand,35,35);
    dggo.clay=reshape(clay,35,35);
    dggo.bc=reshape(bulk_density,35,35);
    dggo.lat=dgg.wa_lat(:,1);
    dggo.lon=dgg.wa_lon(1,:);
    dggo.id=dgginfo.dgg_info.id;
    dggo.wacenter=[dgginfo.wa_info.latc dgginfo.wa_info.lonc];
    dggo.wef=mw;    
end






