function [AmodelAddedSMILES]=SMILESAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos)
%If you want to customize the type of annotation in this function, you have to
%change the Regular Expression in the next line to a pattern of your desire.
StrSearchCell=regexp(TabDelimFile(Row(Hits),:),'C(C+|\(\w*\)|\[\w*\]|=\w)'); 
StrSearchArray = ~cellfun(@isempty,StrSearchCell);
TargetCellInRow= find(StrSearchArray);
    if  ~isempty(TargetCellInRow)
        %Don't forget to alter or comment out the next line if
        %you have customized the type of annotation you are
        %looking for above.
        FoundStr=TabDelimFile{Row(Hits),TargetCellInRow};
        %Remember to change the target cell array to match the 
        %customized annotation (Amodel.MetCustomAnnotation) 
        Amodel.metSMILES(MetPos,1)=cellstr(FoundStr);
    end
AmodelAddedSMILES=Amodel;
end