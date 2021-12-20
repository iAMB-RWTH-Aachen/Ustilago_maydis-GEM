function [AmodelAddedKEGG]=CASNumberAnnotations(Amodel,TabDelimFile,Row,Hits,MetPos)
                %If you want to customize the type of annotation in this function, you have to
                %change the Regular Expression in the next line to a pattern of your desire.
                StrSearchCell=regexp(TabDelimFile(Row(Hits),:),'[0-9]+-[0-9]{2}-[0-9]{1}'); 
                StrSearchArray = ~cellfun(@isempty,StrSearchCell);
                TargetCellInRow= find(StrSearchArray);
                if  ~isempty(TargetCellInRow)
                    %Don't forget to alter or comment out the next line if
                    %you have customized the type of annotation you are
                    %looking for above.
                    FoundStr=regexp(TabDelimFile{Row(Hits),TargetCellInRow},'.*([0-9]+-[0-9]{2}-[0-9]{1}).*','match');
                    if iscell(FoundStr)
                        FoundStr=strjoin(FoundStr,', ');
                    end
                    %Remember to change the target cell array to match the 
                    %customized annotation (Amodel.MetCustomAnnotation) 
                    Amodel.metCASNumber{MetPos,1}=FoundStr;
                end
AmodelAddedKEGG=Amodel;
end