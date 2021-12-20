function [AmodelAddedKEGG]=NCIIDAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos)
                %If you want to customize the type of annotation in this function, you have to
                %change the Regular Expression in the next line to a pattern of your desire.
                StrSearchCell=regexp(TabDelimFile(Row(Hits),:),'NCI "([0-9]+)"'); 
                StrSearchArray = ~cellfun(@isempty,StrSearchCell);
                TargetCellInRow= find(StrSearchArray);
                if  ~isempty(TargetCellInRow)
                    %Don't forget to alter or comment out the next line if
                    %you have customized the type of annotation you are
                    %looking for above.
                    FoundStr=regexprep(TabDelimFile{Row(Hits),TargetCellInRow},'.*NCI "([0-9]+)".*','$1');
                    %Remember to change the target cell array to match the 
                    %customized annotation (Amodel.MetCustomAnnotation) 
                    Amodel.metNCIID(MetPos,1)=cellstr(FoundStr);
                end
AmodelAddedKEGG=Amodel;
end