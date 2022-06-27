function dgg=rcupe_WA(DGGID,affich)
                        
%% extraire les propriété de la WA

load('DGGLATLON.mat');
for gh=1:size(latlonsonde,1)
    dggid(gh)=latlonsonde{gh,5};
end


[dgg] = compute_infoWA_LAIFRASoilP(DGGID,[],[],[]);

dgg.slat=cell2mat(latlonsonde(dggid==DGGID,3));
dgg.slon=cell2mat(latlonsonde(dggid==DGGID,4));


if affich
    figure('position',get(0,'screensize'));
    subplot(3,5,1)
    imagesc(dgg.lon,dgg.lat,dgg.fno*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FNO=',num2str(sum(sum(dgg.wef.*(dgg.fno)))/sum(sum(dgg.wef))/2),'%'));
    colormap(flipud(bone));
    colorbar ;
    axis square ;
    subplot(3,5,2)
    imagesc(dgg.lon,dgg.lat,dgg.ffo*0.5);axis xy;hold on;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FFO=',num2str(sum(sum(dgg.wef.*(dgg.ffo)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colorbar
    axis square ;
    subplot(3,5,3)
    imagesc(dgg.lon,dgg.lat,dgg.ftm*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FTM=',num2str(sum(sum(dgg.wef.*(dgg.ftm)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    colorbar
    axis square ;
    subplot(3,5,4)
    imagesc(dgg.lon,dgg.lat,dgg.fwp*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FWP=',num2str(sum(sum(dgg.wef.*(dgg.fwp)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    
    colorbar ;
    axis square ;
    subplot(3,5,5)
    imagesc(dgg.lon,dgg.lat,dgg.fws*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FWS=',num2str(sum(sum(dgg.wef.*(dgg.fws)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    
    colorbar
    axis square ;
    subplot(3,5,6)
    imagesc(dgg.lon,dgg.lat,dgg.feb*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FEB=',num2str(sum(sum(dgg.wef.*(dgg.feb)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    
    colorbar
    axis square ;
    subplot(3,5,7)
    imagesc(dgg.lon,dgg.lat,dgg.fei*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FEI=',num2str(sum(sum(dgg.wef.*(dgg.fei)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    
    colorbar
    axis square ;
    subplot(3,5,8)
    imagesc(dgg.lon,dgg.lat,dgg.feu*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FEU=',num2str(sum(sum(dgg.wef.*(dgg.feu)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    
    colorbar ;
    axis square ;
    subplot(3,5,9)
    imagesc(dgg.lon,dgg.lat,dgg.fts*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FTS=',num2str(sum(sum(dgg.wef.*(dgg.fts)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    colorbar
    axis square ;
    subplot(3,5,10)
    imagesc(dgg.lon,dgg.lat,dgg.ftm*0.5);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('FTM=',num2str(sum(sum(dgg.wef.*(dgg.ftm)))/sum(sum(dgg.wef))/2),'%'));colormap(flipud(bone));
    colormap(flipud(bone));
    
    colorbar
    axis square ;
    subplot(3,5,11)
    imagesc(dgg.lon,dgg.lat,dgg.lai);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title('LAI')
    colormap(gca,flipud(summer));
    
    colorbar
    axis square ;
    subplot(3,5,12)
    imagesc(dgg.lon,dgg.lat,dgg.sand);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('Sand=',num2str(sum(sum(dgg.sand))/(35*35)),'%'));colormap(flipud(bone));
    colormap(gca,flipud(copper));
    caxis([0 100]);
    colorbar
    axis square ;
    subplot(3,5,13)
    imagesc(dgg.lon,dgg.lat,dgg.clay);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title(strcat('Clay=',num2str(sum(sum(dgg.clay))/(35*35)),'%'));colormap(flipud(bone));
    colormap(gca,flipud(copper));
    caxis([0 100]);
    
    colorbar
    axis square ;
    subplot(3,5,14)
    imagesc(dgg.lon,dgg.lat,dgg.bc);axis xy;
    hold on;
    for gh=1:size(dgg.slat,1)
        plot(dgg.slon(gh),dgg.slat(gh),'rx','MarkerSize',15,'LineWidth',3);
        hold on;
    end
    plot(dgg.wacenter(2),dgg.wacenter(1),'b+','MarkerSize',10,'LineWidth',3);
    title('BulkDens')
    colormap(flipud(bone));
    colorbar
    axis square ;
end


