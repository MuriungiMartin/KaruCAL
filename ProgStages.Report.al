#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51047 ProgStages
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                        buff.Reset;
                        if buff.Find('-') then begin
                          repeat
                            begin
                             Progstages.Init;
                             Progstages."Programme Code":="ACA-Programme".Code;
                             Progstages.Code:=buff.Code;
                             Progstages.Description:=buff.Desc;
                             Progstages.Insert();
                            end;
                          until buff.Next=0;
                        end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
          Progstages.Reset;
          if Progstages.Find('-') then begin
            Progstages.DeleteAll;
          end;
    end;

    var
        buff: Record UnknownRecord61009;
        Progstages: Record UnknownRecord61516;
}

