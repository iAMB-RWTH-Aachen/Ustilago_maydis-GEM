%% Script for the import and analysis of growth data from Synergy Mx spreadsheets

%% Define Variables for OD600 and OD550
SpacingOD600= [2 22 42 62 82 102 122 142 162 182 202 222 242 262 282 302 322 342 362 382 402 422 442 462 482];
SpacingOD550= [12 32 52 72 92 112 132 152 172 192 212 232 252 272 292 312 332 352 372 392 412 432 452 472 492];
PM2OutputOD600 = cell(8,12);
PM2OutputOD550 = cell(8,12);
PM1OutputOD600 = cell(8,12);
PM1OutputOD550 = cell(8,12);
PM1CSources={'Negative Control' 'L-Arabinose' 'N-Acetyl-D-Glucosamine' 'D-Saccharic Acid' 'Succinic Acid' 'D-Galactose' 'L-Aspartic Acid' 'L-Proline' 'D-Alanine' 'D-Trehalose' 'D-Mannose' 'Dulcitol'; 'D-Serine' 'D-Sorbitol' 'Glycerol' 'L-Fucose' 'D-Glucuronic Acid' 'D-Gluconic Acid' 'D,L-alpha-Glycerol-Phosphate' 'D-Xylose' 'L-Lactic Acid' 'Formic Acid' 'D-Mannitol' 'L-Glutamic Acid';'D-Glucose-6-Phosphate' 'D-Galactonic Acid-gamma-Lactone' 'D,L-Malic Acid' 'D-Ribose' 'Tween 20' 'L-Rhamnose' 'D-Fructose' 'Acetic Acid' 'alpha-D-Glucose' 'Maltose' 'D-Mellibiose' 'Thymidine'; 'L-Asparagine' 'D-Aspartic Acid' 'D-Glucosaminic Acid' '1,2-Propanediol' 'Tween 40' 'alpha-Keto-Glutaric Acid' 'alpha-Keto-Butyric Acid' 'alpha-Methyl-D-Galactoside' 'alpha-D-Lactose' 'Lactulose' 'Sucrose' 'Uridine'; 'L-Glutamine' 'M-Tartaric Acid' 'D-Glucose-1-Phosphate' 'D-Fructose-6-Phosphate' 'Tween 80' 'alpha-Hydroxy Glutaric Acid-gamma-Lactone' 'alpha-Hydroxy Butyric Acid' 'beta-Methyl-D-Glucoside' 'Adonitol' 'Maltotriose' '2-Deoxy Adenosine' 'Adenosine'; 'Glycyl-L-Aspartic Acid' 'Citric Acid' 'M-Inositol' 'D-Threonine' 'Fumaric Acid' 'Bromo Succinic Acid' 'Propionic Acid' 'Mucic Acid' 'Glycolic Acid' 'Glyoxylic Acid' 'D-Cellobiose' 'Inosine'; 'Glycyl-L-Glutamic Acid' 'Tricarballylic Acid' 'L-Serine' 'L-Threonine' 'L-Alanine' 'L-Alanyl-Glycine' 'Acetoacetic Acid' 'N-Acetyl-beta-D-Mannosamine' 'Mono Methyl Succinate' 'Methyl Pyruvate' 'D-Malic Acid' 'L-Malic Acid'; 'Glycyl-L-Proline' 'p-Hydroxy Phenyl Acetic Acid' 'm-Hydroxy Phenyl Acetic Acid' 'Tyramine' 'D-Psicose' 'L-Lyxose' 'Glucoronamide' 'Pyruvic Acid' 'L-Galactonic Acid-gamma-Lactone' 'D-Galacturonic Acid' 'Phenylethylamine' '2-Aminoethanol'};
PM2ACSources={'Negative Control' 'Chondroitin Sulfate C' 'alpha-Cyclodextrin' 'beta-Cyclodextrin' 'gamma-Cyclodextrin' 'Dextrin' 'Gelatin' 'Glycogen' 'Insulin' 'Lamarin' 'Mannan' 'Pectin'; 'N-Acetyl-D-Galactosamine' 'N-Acetyl-Neuraminic Acid' 'beta-D-Allose' 'Amygdalin' 'D-Arabinose' 'D-Arabitol' 'L-Arabitol' 'Arbutin' '2-Deoxy-D-Ribose' 'l-Erythritol' 'D-Fucose' '3-0-beta-D-Galactopyranosyl-D-Arabinose'; 'Gentiobiose' 'L-Glucose' 'Lacitol' 'D-Melezitose' 'Maltitol' 'alpha-Methy-D-Glucoside' 'beta-Methyl-D-Galactoside' '3-Methyl-D-Glucoronic Acid' 'beta-Methyl-D-Glucoronic Acid' 'alpha-Methyl-D-Mannoside' 'beta-Methyl-D-Xyloside' 'Palatinose'; 'D-Raffinose' 'Salicin' 'Sedoheptulosan' 'L-Sorbose' 'Stachyose' 'D-Tagatose' 'Turanose' 'Xylitol' 'N-Acetyl-D-Glucosaminitol' 'gamma-Amino Butyric Acid' 'delta-Amino Valeric Acid' 'Butyric Acid'; 'Capric Acid' 'Caproic Acid' 'Citraconic Acid' 'Citramalic Acid' 'D-Glucosamine' '2-Hydroxy Benzoic Acid' '4-Hydroxy Benzoic Acid' 'beta-Hydroxy Butyric Acid' 'gamma-Hydroxy Butyric Acid' 'alpha-Keto Valeric Acid' 'Itaconic Acid' '5-Keto-D-Gluconic Acid'; 'D-Lactic Acid Methyl Ester' 'Malonic Acid' 'Melibionic Acid' 'Oxalic Acid' 'Oxalomalic Acid' 'Quinic Acid' 'D-Ribono-1,4-Lactone' 'Sebacic Acid' 'Sorbic Acid' 'Succinamic Acid' 'D-Tartaric Acid' 'L-Tartaric Acid'; 'Acetamide' 'L-Alaninamide' 'N-Acetyl-L-Glutamic Acid' 'L-Arginine' 'Glycine' 'L-Histidine' 'L-Homoserine' 'Hydroxy-L-Proline' 'L-Isoleucine' 'L-Leucine' 'L-Lysine' 'L-Methionine'; 'L-Ornithine' 'L-Phenylalanine' 'L-Pyroglutamic Acid' 'L-Valine' 'D,L-Carnitine' 'Sec-Butylamine' 'D,L-Octopamine' 'Putrescine' 'Dihydroxy Acetone' '2,3-Butanediol' '2,3-Butanone' '3-Hydroxy 2-Butanone'};
TimePoints= [0 2 4 6 20.5 22.5 24.5 26.5 28.5 30.5 43.5 45.5 47.5 49.5 51.5 53.5 68.5 70.5 72.5 92.5 94.5 96.5 98.5 118.5 162];

%% PM2
%Read in the Excel Workbooks separately
WorkbookPM1=xlsread('C:\Users\Christian\Documents\Uni\Master\Gehörte Vorlesungen\2014 SS\Masterarbeit\Ergebnisse\COBRA\Growth Experiments Biolog\UMayFB1ChristianLievenMasterFile.xlsx','PM1');
WorkbookPM2=xlsread('C:\Users\Christian\Documents\Uni\Master\Gehörte Vorlesungen\2014 SS\Masterarbeit\Ergebnisse\COBRA\Growth Experiments Biolog\UMayFB1ChristianLievenMasterFile.xlsx','PM2');

%Reading out OD600 on PM2
%The readouts happen cell by cell with the Spacing described in the
%SpacingODXXX Variables.
for j = 0:7
    for i = 1:12
    raw = [];
    VerticalPosition=SpacingOD600+j;
        for x = 1: length(VerticalPosition)
        raw0_0 = WorkbookPM2(VerticalPosition(x),i);
        raw = [raw; raw0_0];
        end
    PM2OutputOD600{1+j,i} = raw;
    clearvars raw raw0_0;
    end
end

%Reading out OD500 on PM2
for j = 0:7
    for i = 1:12
    raw = [];
    VerticalPosition=SpacingOD550+j;
        for x = 1: length(VerticalPosition)
        raw0_0 = WorkbookPM2(VerticalPosition(x),i);
        raw = [raw; raw0_0];
        end
    PM2OutputOD550{1+j,i} = raw;
    clearvars raw raw0_0;
    end
end
%% PM1
%Reading out OD600 on PM1
for j = 0:7
    for i = 1:12
    raw = [];
    VerticalPosition=SpacingOD600+j;
        for x = 1: length(VerticalPosition)
        raw0_0 = WorkbookPM1(VerticalPosition(x),i);
        raw = [raw; raw0_0];
        end
    PM1OutputOD600{1+j,i} = raw;
    clearvars raw raw0_0;
    end
end

%Reading out OD550 on PM1
for j = 0:7
    for i = 1:12
    raw = [];
    VerticalPosition=SpacingOD550+j;
        for x = 1: length(VerticalPosition)
        raw0_0 = WorkbookPM1(VerticalPosition(x),i);
        raw = [raw; raw0_0];
        end
    PM1OutputOD550{1+j,i} = raw;
    clearvars raw raw0_0;
    end
end
%% Normalization

%PM1
for i=2:96 
PM1OutputOD600{i}=PM1OutputOD600{i}-PM1OutputOD600{1};
    for e=1:length(PM1OutputOD600{i})
        if PM1OutputOD600{i}(e)<0
           PM1OutputOD600{i}(e)=0;
        end
    end
end
PM1OutputOD600{1}=zeros(numel(PM1OutputOD600{1}),1);

for i=2:96 
PM1OutputOD550{i}=PM1OutputOD550{i}-PM1OutputOD550{1};
    for e=1:length(PM1OutputOD550{i})
        if PM1OutputOD550{i}(e)<0
           PM1OutputOD550{i}(e)=0;
        end
    end
end
PM1OutputOD550{1}=zeros(numel(PM1OutputOD550{1}),1);

%PM2
for i=2:96 
PM2OutputOD600{i}=PM2OutputOD600{i}-PM2OutputOD600{1};
    for e=1:length(PM1OutputOD600{i})
        if PM2OutputOD600{i}(e)<0
           PM2OutputOD600{i}(e)=0;
        end
    end
end
PM2OutputOD600{1}=zeros(numel(PM2OutputOD600{1}),1);

for i=2:96 
PM2OutputOD550{i}=PM2OutputOD550{i}-PM2OutputOD550{1};
    for e=1:length(PM2OutputOD550{i})
        if PM2OutputOD550{i}(e)<0
           PM2OutputOD550{i}(e)=0;
        end
    end
end
PM2OutputOD550{1}=zeros(numel(PM2OutputOD550{1}),1);

%% Growth rate approximation

% PM1
 GrowthRatePM1=zeros(8,12);
 for i=2:96
 % raw data smoothing    
 alpha = 0.50;
 exponentialMAPM1 = filter(alpha, [1 alpha-1],PM1OutputOD600{i});
 % ln of the smoothed data
 LnPM1OD600=log(exponentialMAPM1);
 % only includes data that supports growth larger than 0.3679
 if (-1 <= max(LnPM1OD600)) && (max(LnPM1OD600)<= 2) 
 TimePointsTrans=TimePoints.';
 IndexArray= [1; 2; 3];
 k=1;
 Slope=[];
    while IndexArray(3)<= length(LnPM1OD600)
        YV = LnPM1OD600(IndexArray);
        XV = TimePointsTrans(IndexArray);
        SlopeIntercept=polyfit(XV,YV,1);
        Slope(k)=SlopeIntercept(1);
        k=k+1;
        IndexArray=IndexArray+2;
        Slope(isnan(Slope))=0;
        Slope(~isfinite(Slope))=0;
    end
    for l=1:(length(Slope)-1)
        if (Slope(l) - (90/100*Slope(l)) <= Slope(l+1)) && (Slope(l+1) <= Slope(l) + (90/100*Slope(l)))
            if Slope(l) == max(Slope) || Slope(l+1) == max(Slope)
            GrowthRatePM1(i)=(mean([Slope(l) Slope(l+1)]));
            end
        end
    end
 else
     GrowthRatePM1(i)=0;
 end
 end

% PM2
 GrowthRatePM2=zeros(8,12);
 for i=2:96
 % raw data smoothing    
 alpha = 0.50;
 exponentialMAPM2 = filter(alpha, [1 alpha-1],PM2OutputOD600{i});
 % ln of the smoothed data
 LnPM2OD600=log(exponentialMAPM2);
 % only includes data that supports growth larger than 0.3679
 if (-1 <= max(LnPM2OD600)) && (max(LnPM2OD600)<= 2) 
 TimePointsTrans=TimePoints.';
 IndexArray= [1; 2; 3];
 k=1;
 Slope=[];
    while IndexArray(3)<= length(LnPM2OD600)
        YV = LnPM2OD600(IndexArray);
        XV = TimePointsTrans(IndexArray);
        SlopeIntercept=polyfit(XV,YV,1);
        Slope(k)=SlopeIntercept(1);
        k=k+1;
        IndexArray=IndexArray+2;
        Slope(isnan(Slope))=0;
        Slope(~isfinite(Slope))=0;
    end
    for l=1:(length(Slope)-1)
        if (Slope(l) - (90/100*Slope(l)) <= Slope(l+1)) && (Slope(l+1) <= Slope(l) + (90/100*Slope(l)))
            if Slope(l) == max(Slope) || Slope(l+1) == max(Slope)
            GrowthRatePM2(i)=(mean([Slope(l) Slope(l+1)]));
            end
        end
    end
 else
     GrowthRatePM2(i)=0;
 end
 end

% Reformatting for Excel export
PM1Vector=reshape(GrowthRatePM1,[96,1]);
PM1Vector2=reshape(PM1CSources,[96,1]);

PM2Vector=reshape(GrowthRatePM2,[96,1]);
PM2Vector2=reshape(PM2ACSources,[96,1]);
%% Plotting PM2
close all;

figure;
index = reshape(1:96, 12, 8).';
for i=1:96
s(i) = subplot(8, 12, index(i));
alpha = 0.50;
exponentialMAPM2 = filter(alpha, [1 alpha-1],PM2OutputOD600{i});
Cutoff=zeros(length(TimePoints.'))-1;
%plot(s(i),TimePoints,log(PM2OutputOD600{i}),TimePoints,log(PM2OutputOD550{i}),'g--');
plot(s(i),TimePoints,[log(PM2OutputOD600{i}) log(exponentialMAPM2) Cutoff]);
axis([0 162 -2 2]);
title(s(i),cellstr(PM2ACSources{i}))
xlabel(s(i),'Time(h)')
ylabel(s(i),'lnOD (600 nm)')
end

%% Plotting PM1

figure;
index = reshape(1:96, 12, 8).';
for i=1:96
s(i) = subplot(8, 12, index(i));
alpha = 0.50;
exponentialMAPM1 = filter(alpha, [1 alpha-1],PM1OutputOD600{i});
Cutoff=zeros(length(TimePoints.'))-1;
%plot(s(i),TimePoints,log(PM1OutputOD600{i}),TimePoints,log(PM1OutputOD550{i}),'g--');
plot(s(i),TimePoints,[log(PM1OutputOD600{i}) log(exponentialMAPM1) Cutoff]);
axis([0 162 -2 2]);
title(s(i),cellstr(PM1CSources{i}))
xlabel(s(i),'Time(h)')
ylabel(s(i),'ln OD600')
end


