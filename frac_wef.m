%% extraire les aux pour un lat/lon donné
% clear all
close all
% load('/home/mialona/Documents/Journal_de_bord/Semaine_34/matlab3.mat');
tic
for idx=1:5675
    if (idx==1) ||  (DGGID~=DGG(idx))
        DGGID=DGG(idx);
        dgg=rcupe_wa(DGGID,0)    
    end

sonde_sand(idx)=dgg.sand(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)));
sonde_clay(idx)=dgg.clay(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)));
sonde_fno(idx)=dgg.fno(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_ffo(idx)=dgg.ffo(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_fwl(idx)=dgg.fwl(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_fwp(idx)=dgg.fwp(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_fws(idx)=dgg.fws(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_feb(idx)=dgg.feb(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_fei(idx)=dgg.fei(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_feu(idx)=dgg.feu(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_fts(idx)=dgg.fts(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_ftm(idx)=dgg.ftm(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)))/2;
sonde_lai(idx)=dgg.lai(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)));
sonde_bc(idx)=dgg.bc(knnsearch(dgg.lat,lat_sonde(idx)),knnsearch(dgg.lon',lon_sonde(idx)));

DGG_sand(idx)=sum(sum(dgg.sand))/(35*35);
DGG_clay(idx)=sum(sum(dgg.clay))/(35*35);
DGG_fno(idx)=sum(sum(dgg.fno/2))/(35*35);
DGG_ffo(idx)=sum(sum(dgg.ffo/2))/(35*35);
DGG_fwl(idx)=sum(sum(dgg.fwl/2))/(35*35);
DGG_fwp(idx)=sum(sum(dgg.fwp/2))/(35*35);
DGG_fws(idx)=sum(sum(dgg.fws/2))/(35*35);
DGG_feb(idx)=sum(sum(dgg.feb/2))/(35*35);
DGG_fei(idx)=sum(sum(dgg.fei/2))/(35*35);
DGG_feu(idx)=sum(sum(dgg.feu/2))/(35*35);
DGG_fts(idx)=sum(sum(dgg.fts/2))/(35*35);
DGG_ftm(idx)=sum(sum(dgg.ftm/2))/(35*35);
DGG_lai(idx)=sum(sum(dgg.lai))/(35*35);
DGG_bc(idx)=sum(sum(dgg.bc))/(35*35);

DGG_sand_wef(idx)=sum(sum(dgg.wef.*dgg.sand))/sum(sum(dgg.wef));
DGG_clay_wef(idx)=sum(sum(dgg.wef.*dgg.clay))/sum(sum(dgg.wef));
DGG_fno_wef(idx)=sum(sum(dgg.wef.*(dgg.fno/2)))/sum(sum(dgg.wef));
DGG_ffo_wef(idx)=sum(sum(dgg.wef.*(dgg.ffo/2)))/sum(sum(dgg.wef));
DGG_fwl_wef(idx)=sum(sum(dgg.wef.*(dgg.fwl/2)))/sum(sum(dgg.wef));
DGG_fwp_wef(idx)=sum(sum(dgg.wef.*(dgg.fwp/2)))/sum(sum(dgg.wef));
DGG_fws_wef(idx)=sum(sum(dgg.wef.*(dgg.fws/2)))/sum(sum(dgg.wef));
DGG_feb_wef(idx)=sum(sum(dgg.wef.*(dgg.feb/2)))/sum(sum(dgg.wef));
DGG_fei_wef(idx)=sum(sum(dgg.wef.*(dgg.fei/2)))/sum(sum(dgg.wef));
DGG_feu_wef(idx)=sum(sum(dgg.wef.*(dgg.feu/2)))/sum(sum(dgg.wef));
DGG_fts_wef(idx)=sum(sum(dgg.wef.*(dgg.fts/2)))/sum(sum(dgg.wef));
DGG_ftm_wef(idx)=sum(sum(dgg.wef.*(dgg.ftm/2)))/sum(sum(dgg.wef));
DGG_lai_wef(idx)=sum(sum(dgg.wef.*(dgg.lai)))/sum(sum(dgg.wef));
DGG_bc_wef(idx)=sum(sum(dgg.wef.*(dgg.bc)))/sum(sum(dgg.wef));
idx
end
toc