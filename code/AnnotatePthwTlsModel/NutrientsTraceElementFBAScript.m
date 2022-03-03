function [Model,FBASolution]=NutrientsTraceElementFBAScript(Model)
%% This script defines the necessary framework of exchange reactions and parameters for modeling to take place.
%% Initialize the Cobra Toolbox!
initCobraToolbox;

%% Set the lower bound to -25 if the reaction is reversible,
% else set it to 0:
 for i=1:length(Model.rxns)
   if Model.rev(i,1)==0
      Model.lb(i,1)=0;
      Model.ub(i,1)=25;
   else
       Model.lb(i,1)=-25;
       Model.ub(i,1)=25;
   end
 end    
%% Declare artificial reactions that are missing in the model due to missing
%evidence.
Model=addReaction(Model,'Biotin_Uptake','BIOTIN[e] -> BIOTIN[c]');
Model=addReaction(Model,'Pyridoxal_Uptake','PYRIDOXAL[e] -> PYRIDOXAL[c]');
Model=addReaction(Model,'Thiamin_Uptake','THIAMINE[e] -> THIAMINE[c]');
Model=addReaction(Model,'Pantothenate_Uptake','PANTOTHENATE[e] -> PANTOTHENATE[c]');


%% Declare formulas for the artificially created metabolites.
ind=find(ismember(Model.mets,'BIOTIN[e]'));
Model.metFormulas{ind}='C10H15N2O3S';
ind=find(ismember(Model.mets,'PYRIDOXAL[e]'));
Model.metFormulas{ind}='C8H9NO3';
ind=find(ismember(Model.mets,'THIAMINE[e]'));
Model.metFormulas{ind}='C12H17N4OS';
ind=find(ismember(Model.mets,'PANTOTHENATE[e]'));
Model.metFormulas{ind}='C9H16NO5';

%% Set the bounds of uptake reactions assuming best conditions
%and maximal rates.
%Substrate:
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__45__45__ALPHA__45__GLUCOSE__47____47__ALPHA__45__GLUCOSE__46__29__46__',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__45__45__ALPHA__45__GLUCOSE__47____47__ALPHA__45__GLUCOSE__46__29__46__',25,'u'); 

%Vitamins
Model = changeRxnBounds(Model,'Biotin_Uptake',-25,'l');
Model = changeRxnBounds(Model,'Biotin_Uptake',25,'u');
Model = changeRxnBounds(Model,'Pyridoxa_Uptake',-25,'l');
Model = changeRxnBounds(Model,'Pyridoxa_Uptake',25,'u');
Model = changeRxnBounds(Model,'Thiamin_Uptake',-25,'l');
Model = changeRxnBounds(Model,'Thiamin_Uptake',25,'u');
Model = changeRxnBounds(Model,'Pantothenate_Uptake',-25,'l');
Model = changeRxnBounds(Model,'Pantothenate_Uptake',25,'u');
%4-aminobenzoate
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__7__45__P__45__AMINO__45__BENZOATE__47____47__P__45__AMINO__45__BENZOATE__46__35__46__',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__7__45__P__45__AMINO__45__BENZOATE__47____47__P__45__AMINO__45__BENZOATE__46__35__46__',25,'u');
%Niacine
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__17',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__17',25,'u');
%Myo-Inositol
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__20',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__20',25,'u');

%Minerals:
%Ammonium
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__43__45__AMMONIUM__47____47__AMMONIUM__46__19__46__',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__43__45__AMMONIUM__47____47__AMMONIUM__46__19__46__',25,'u');
%Sulfate
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__59',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__59',25,'u');
%Chloride
Model = changeRxnBounds(Model,'TRANS__45__RXN__45__139',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXN__45__139',25,'u');
%Natrium
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__41',-25,'l');
Model = changeRxnBounds(Model,'TRANS__45__RXNTFS__45__41',25,'u');

%% Set the bounds of secretion/ internal reactions according to measured concentrations assuming best conditions and maximal rates.

% NGAM flux reported by David et al. 2008, Analysis of Aspergillus nidulans metabolism at the genome-scale, BMC Genomics, 9, 163-178. 
Model=changeRxnBounds(Model,'NGAM',1.8,'l');
Model=changeRxnBounds(Model,'NGAM',1.8,'u');

%% Define the Medium Composition:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MINIMAL MEDIUM%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Minerals
% model = addReaction(model,rxnName,metaboliteList,stoichCoeffList,revFlag,lowerBound,upperBound,objCoeff,subSystem,
% grRule,geneNameList,systNameList,checkDuplicate)
Model=addReaction(Model,'Oxygen_Medium','OXYGEN__45__MOLECULE[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Carbon_Dioxide_Medium','CARBON__45__DIOXIDE[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Ammonium_Medium','AMMONIUM[e] <=> ',[],[],[],[],[],'Medium')
Model=addReaction(Model,'Chloride_Medium','CL__45__[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Potassium_Medium','K__43__[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Phosphate_Medium','Pi[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Magnesium_Medium','MG__43__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Sulfate_Medium','SULFATE[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Demineralized_Water_Medium','WATER[e] <=> ',[],[],[],[],[],'Medium');

%Trace Elements
Model=addReaction(Model,'EDTA_Medium','EDTA[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Zinc_Medium','ZN__43__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Manganese_Medium','Mn__43__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Cobalt_Medium','CO__43__2_e[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Copper_Medium','CU__43__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Sodium_Medium','NA__43__[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Molybdenum_Medium','MoO4__45__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Calcium_Medium','CA__43__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Iron_Medium','FE__43__2[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Boric_Acid_Medium','BORICACID[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Iodide_Medium','I__45__[e] <=> ',[],[],[],[],[],'Medium');

%Vitamins
Model=addReaction(Model,'Biotin_Medium','BIOTIN[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Panthothenate_Medium','PANTOTHENATE[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Nicotinic_Acid_Medium','NIACINE[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Myo_Inositol_Medium','MYO__45__INOSITOL[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Thiamine_Medium','THIAMINE[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Pyridoxol_Medium','PYRIDOXAL[e] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Para_Aminobenzoic_Acid_Medium','P__45__AMINO__45__BENZOATE[e] <=> ',[],[],[],[],[],'Medium');

%Carbon Source
%Model=addReaction(Model,'Glucose_Medium','ALPHA__45__GLUCOSE[e] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Glycerol_Medium','GLYCEROL[e] <=> ',[],[],[],[],[],'Medium');

%Model=addReaction(Model,'Phenylalanine_Medium','PHE[e] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Malate_Medium','MAL[c] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Leucine_Medium','LEU[e] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Isoleucine_Medium','ILE[e] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'NAcetylDGlucosamine_Medium','N__45__acetyl__45__D__45__glucosamine[c] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Glutamine_Medium','GLN[e] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Gluconate_Medium','5__45__DEHYDROGLUCONATE[c] <=> ',[],[],[],[],[],'Medium');

%Model=addReaction(Model,'Glucosamine_Medium','CPD__45__13469[c] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Arabitol_Medium','L__45__ARABITOL[c] <=> ',[],[],[],[],[],'Medium');
%Model=addReaction(Model,'Ribopyranose_Medium','D__45__Ribopyranose[c] <=> ',[],[],[],[],[],'Medium');
Model=addReaction(Model,'Xylitol_Medium','XYLITOL[e] <=> ',[],[],[],[],[],'Medium');

%%
%Secretion Products, Demand and Sink RXNs
Model=addReaction(Model,'DM_BIOMASS_Demand','BIOMASS[c] -> ',[],[],[],[],[],'Biomass Demand');

%Carbonic Acids
Model=addReaction(Model,'DM_Malate_Demand','MAL[e] -> ',[],[],[],[],[],'Malate Demand');
Model=addReaction(Model,'DM_Succinate_Demand','SUC[e] -> ',[],[],[],[],[],'Succinate Demand');
Model=addReaction(Model,'DM_Fumarate_Demand','FUM[e] -> ',[],[],[],[],[],'Fumarate Demand');
Model=addReaction(Model,'DM_Itaconate_Demand','ITACONATE[e] -> ',[],[],[],[],[],'Itaconate Demand');

%Polyols
Model=addReaction(Model,'DM_Mannitol_Demand','MANNITOL[e] -> ',[],[],[],[],[],'Mannitol Demand');

%Aminoacids
Model=addReaction(Model,'DM_Alanine_Demand','L__45__ALPHA__45__ALANINE[e] -> ',[],[],[],[],[],'Alanine Demand');
Model=addReaction(Model,'DM_Arginine_Demand','ARG[e] -> ',[],[],[],[],[],'Arginine Demand');
Model=addReaction(Model,'DM_Asparagine_Demand','ASN[e] -> ',[],[],[],[],[],'Asparagine Demand');
Model=addReaction(Model,'DM_Aspartate_Demand','L__45__ASPARTATE[e] -> ',[],[],[],[],[],'Aspartate Demand');
Model=addReaction(Model,'DM_Cystein_Demand','CYS[e] -> ',[],[],[],[],[],'Cystein Demand');
Model=addReaction(Model,'DM_Glutamine_Demand','GLN[e] -> ',[],[],[],[],[],'Glutamine Demand');
Model=addReaction(Model,'DM_Glutamate_Demand','GLT[e] -> ',[],[],[],[],[],'Glutamate Demand');
Model=addReaction(Model,'DM_Glycine_Demand','GLY[e] -> ',[],[],[],[],[],'Glycine Demand');
Model=addReaction(Model,'DM_Histidine_Demand','HIS[e] -> ',[],[],[],[],[],'Histidine Demand');
Model=addReaction(Model,'DM_Isoleucine_Demand','ILE[e] -> ',[],[],[],[],[],'Isoleucine Demand');
Model=addReaction(Model,'DM_Leucine_Demand','LEU[e] -> ',[],[],[],[],[],'Leucine Demand');
Model=addReaction(Model,'DM_Lysine_Demand','LYS[e] -> ',[],[],[],[],[],'Lysine Demand');
Model=addReaction(Model,'DM_Methionine_Demand','MET[e] -> ',[],[],[],[],[],'Methionine Demand');
Model=addReaction(Model,'DM_Phenylalanine_Demand','PHE[e] -> ',[],[],[],[],[],'Phenylalanine Demand');
Model=addReaction(Model,'DM_Proline_Demand','PRO[e] -> ',[],[],[],[],[],'Proline Demand');
Model=addReaction(Model,'DM_Serine_Demand','SER[e] -> ',[],[],[],[],[],'Serine Demand');
Model=addReaction(Model,'DM_Threonine_Demand','THR[e] -> ',[],[],[],[],[],'Threonine Demand');
Model=addReaction(Model,'DM_Tryptophane_Demand','TRP[e] -> ',[],[],[],[],[],'Tryptophane Demand');
Model=addReaction(Model,'DM_Tyrosine_Demand','TYR[e] -> ',[],[],[],[],[],'Tyrosine Demand');
Model=addReaction(Model,'DM_Valine_Demand','VAL[e] -> ',[],[],[],[],[],'Valine Demand');

%% Set the objective function to a reaction that is supposed to me maximized.

% Un-comment the following line if the desired objective function is the
% production of pyruvate i.e. Glycolysis:
%Model= changeObjective(Model,'PEPDEPHOS__45__RXN');

%Un-comment the following line if the desired objective function is the
% production of Acetyl-COA:
%Model= changeObjective(Model,'PYRUVDEH__45__RXN');

% Un-comment the following line if the desired objective function is the
% production of malate i.e. TCA-Cycle:
%Model= changeObjective(Model,'FUMHYDR__45__RXN');

% Un-comment the following line if the desired objective function is the
% production of ribulose-5p i.e. Oxidative Branch of the Pentose Phosphate Pathway:
%Model= changeObjective(Model,'RXN__45__9952');

% Un-comment the following line if the desired objective function is Total Biomass Synthesis:
Model= changeObjective(Model,'DM_BIOMASS_Demand');


%% Run the Flux Balance Analysis
FBASolution=optimizeCbModel(Model);
end