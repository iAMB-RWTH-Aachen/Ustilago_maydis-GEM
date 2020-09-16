function [AnnotatedAmodel]=AnnotatePthwTlsModel(Amodel)
% AnnotatePthwTlsModel parses a tab-delimited file or an SMBL File for annotations. For each
% entry in Amodel.rxnNames and Amodel.metNames it looks for additional info like ECNumbers 
% or InChiStrings and transfers the info from the tab-delimited file into the     
% corresponding vector in Amodel.
%
% 
%INPUTS
% Amodel without correct annotations
%
%OUTPUTS
% Amodel corrected with annotations
  
%Prompt the user to specify either a tab-delimited file he would like to be
%checked for annotations or an SMBL File that was exported by Pathway Tools. 
%(This should be the same one that was used to create the COBRA Model in the first place).
%The tab-delimited file has to have the same amount of tabs per
%line otherwise MatLab will throw an error!
[fileName,pathName] = uigetfile({'*.xml';'*.dat'},'Please select a tab-delimited, or an SBML file you would like to have parsed for annotations.') ;
FileType=regexprep(fileName,'(.*)\.(\w*)','$2');
switch FileType
        case 'xml'
            FileType = 'SBML';
            InputSBML = TranslateSBML([pathName fileName]);
            AnnotatedAmodel=SBMLAnnotationParser(InputSBML,Amodel);
            AnnotatedAmodel=ASCIISyntaxCleaner(AnnotatedAmodel);
        case 'dat'
            FileType = 'Tab-delimited';
            TabDelimFile = readtable([pathName fileName],'Delimiter','tab','HeaderLines',0);
            Amodel=ASCIISyntaxCleaner(Amodel);
            AnnotatedAmodel=TabDelimAnnotationParser(TabDelimFile,Amodel);
        otherwise
            error('Cannot process this file type. Make sure it is either an .xml or .dat!');
end
end
function [SMBLAnnotatedAmodel]=SBMLAnnotationParser(InputSBML,Amodel)
%Parses Annotations from the >Notes< Field of an SMBL File.
 disp('Starting to parse metabolite annotations from specified SBML File');
    counter=0;
    Wait=waitbar(0,'Please wait, while annotations are being parsed.');
    tic;
    for MetPos=1:length(InputSBML.species)
        %In the following section from each entry in metID the compartment
        %suffix is cleaved.
        if ~isempty(InputSBML.species(MetPos).notes)
        % Credit for the InChI-Sting Regexp goes to Lorenz Lo Sauer
        % (https://gist.github.com/lsauer)
            [Temp,~]=regexp(InputSBML.species(MetPos).notes,'<p>INCHI: (.*)</p>','match','dotexceptnewline');
                if ~isempty(Temp)
                Temp=regexprep(Temp,'<p>INCHI: ','');
                Amodel.metInChIString(MetPos,1)=regexprep(Temp,'</p>','');
                end
            [Temp,~]=regexp(InputSBML.species(MetPos).notes,'<p>KEGG: (.*)</p>','match','dotexceptnewline');
                if ~isempty(Temp)
                Temp=regexprep(Temp,'<p>KEGG: ','');
                Amodel.metKEGGID(MetPos,1)=regexprep(Temp,'</p>','');
                end
            [Temp,~]=regexp(InputSBML.species(MetPos).notes,'<p>PUBCHEM: (.*)</p>','match','dotexceptnewline');
                if ~isempty(Temp)
                Temp=regexprep(Temp,'<p>PUBCHEM: ','');
                Amodel.metPubChemID(MetPos,1)=regexprep(Temp,'</p>','');
                end
            [Temp,~]=regexp(InputSBML.species(MetPos).notes,'<p>CHEBI: (.*)</p>','match','dotexceptnewline');
                if ~isempty(Temp)
                Temp=regexprep(Temp,'<p>CHEBI: ','');
                Amodel.metChEBIID(MetPos,1)=regexprep(Temp,'</p>','');
                end
        end
        %Counter%
        TimePerCalculation= toc;
        Percentage=counter/length(Amodel.mets);
        TimeRemaining=TimePerCalculation/Percentage-TimePerCalculation;
        Hour=floor(TimeRemaining/3600);
        Minutes=floor((TimeRemaining-Hour*3600)/60);
        waitbar(Percentage,Wait,[sprintf('%0.1f',Percentage*100) '%, '...
        sprintf('%02.0f',Hour) ':'...
        sprintf('%02.0f',Minutes) ':'...
        sprintf('%02.0f',rem(TimeRemaining,60)) 'remaining']);
        counter=counter+1;
        end
        
    close(Wait)
    Coverage=(counter/length(Amodel.mets))*100;
    Message=['A total of ',num2str(counter),' metabolites were parsed'];
    disp(Message);
    SMBLAnnotatedAmodel=Amodel;
end
function [TabAnnotatedAmodel]=TabDelimAnnotationParser(TabDelimFile,Amodel)
%Transform "TabDelimFile" into an array of cells in order to iterate
%through it in order to find a list of specified annotations.
TabDelimFile=table2cell(TabDelimFile);
TabDelimFile(cellfun(@(x) any(isnan(x)),TabDelimFile))={''};
%[x,y]=find(cellfun(@isnumeric, TabDelimFile));
%TabDelimFile=cell2str(TabDelimFile(x,y));

%If the temporary variables "Metabolites" and "Reactions" are not empty
%parse each of the cells of "TabDelimFile" for an exact match. Then check
%the other cells of "TabDelimFile" in the same row for annotations of interest like EC#,
%Charge, KEGGID, SEEDID, Formula, InChiString, PubChemID.

    disp('Starting to parse metabolite annotations from specified Tab-Delimited File');
    counter=0;
    Wait=waitbar(0,'Please wait, while annotations are being parsed.');
    tic;
    %In the following section from each entry in metID the compartment
    %suffix is cleaved.
    for MetPos=1:length(Amodel.mets)
        SearchStr=regexprep(Amodel.mets{MetPos},'\[\w\]','');
        %Since the metabolites in TabDelimFile might have dashes aswell as
        %underscores, the following command replaces each - or _ in metID
        %with the regular expression that accepts either.
        SearchStr=regexprep(SearchStr,'(-|_)','\(-\|_\)');
        TargetStrCell=regexpi(TabDelimFile,SearchStr);
        %The next command replaces empty cells output by "regexpi" with
        %zeros and converts the cellarray into a proper matrix. This is
        %required for "find" to work.
        TargetStrArray=~cellfun(@isempty,TargetStrCell);
        %"find" outputs the Rows and Columns which are not zero, i.e. contain
        %a match for SearchStr in TabDelimFile.
        [Row,Column]=find(TargetStrArray);
        if  ~isempty(Row)&&~isempty(Column)
            %Since there can be several matches within TabDelimFile, Row
            %and Column may be vectors, with several entries. The following loop indexes through
            %TabDelimFile using each of the values (Hits) in the Row vector
            %to address speficially all those rows that had a metabolite
            %match previously.
            for Hits=1:length(Row)
                %Call the subfunctions that specify which annotations you want to have
                %added between the lines:
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Amodel=BIGGIDAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=BRENDAAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=CASNumberAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                Amodel=ChEBIIDAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=ChemSpiderAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=DrugbankIDAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=HumanMetabolomeDBAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                Amodel=InChIAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=KEGGGlycanAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                Amodel=KEGGIDAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=LipidMapsAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=NCIIDAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                Amodel=PubchemAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);
                %Amodel=SMILESAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos);              
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end            
        end
        TimePerCalculation= toc;
        Percentage=counter/length(Amodel.mets);
        TimeRemaining=TimePerCalculation/Percentage-TimePerCalculation;
        Hour=floor(TimeRemaining/3600);
        Minutes=floor((TimeRemaining-Hour*3600)/60);
        waitbar(Percentage,Wait,[sprintf('%0.1f',Percentage*100) '%, '...
        sprintf('%02.0f',Hour) ':'...
        sprintf('%02.0f',Minutes) ':'...
        sprintf('%02.0f',rem(TimeRemaining,60)) 'remaining']);
        counter=counter+1;
    end
    close(Wait)
    Coverage=(counter/length(Amodel.mets))*100;
    Message=['A total of ',num2str(counter),' metabolites were parsed'];
    disp(Message);
    TabAnnotatedAmodel=Amodel;
 end
function [CleanAmodel]=ASCIISyntaxCleaner(Amodel)
%Clear out ASCII syntax in Amodel originally generated by the Pathway Tools export
%(Code kindly provided by Jörg Büscher from BRAIN GmbH)
disp('Clean up Pathway Tools export syntax');
for ir = 1:length(Amodel.rxns)
     Amodel.rxns{ir} = strrep(Amodel.rxns{ir},'__45__', char(45)) ;
     Amodel.rxns{ir} = strrep(Amodel.rxns{ir},'__46__', char(46)) ;
     Amodel.rxns{ir} = strrep(Amodel.rxns{ir},'__43__', char(43)) ;
     Amodel.rxns{ir} = strrep(Amodel.rxns{ir}, '-rxn','') ;
     Amodel.rxnNames{ir} = strrep(Amodel.rxnNames{ir}, '-RXN','') ;
     if isfield(Amodel,'rxnID')
     Amodel.rxnID{ir} = strrep(Amodel.rxnID{ir},'__45__', char(45)) ;
     Amodel.rxnID{ir} = strrep(Amodel.rxnID{ir},'__46__', char(46)) ;
     Amodel.rxnID{ir} = strrep(Amodel.rxnID{ir},'__43__', char(43)) ;
     Amodel.rxnID{ir} = strrep(Amodel.rxnID{ir}, '-rxn','') ;
     end
end
for im = 1:length(Amodel.mets)
     Amodel.mets{im} = strrep(Amodel.mets{im},'__45__', '_' ) ;
     Amodel.mets{im} = strrep(Amodel.mets{im},'__43__', char(43) ) ;
     Amodel.mets{im} = strrep(Amodel.mets{im},'__46__', char(46)) ;
    if isfield(Amodel,'metID')
     Amodel.metID{im} = strrep(Amodel.metID{im},'__45__', '_' ) ;
     Amodel.metID{im} = strrep(Amodel.metID{im},'__43__', char(43) );
     Amodel.metID{im} = strrep(Amodel.metID{im},'__46__', char(46)) ;
    end
end
CleanAmodel=Amodel;
end