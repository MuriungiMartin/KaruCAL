#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51051 PopulateSageOrger
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            column(ReportForNavId_1; 1)
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                column(ReportForNavId_2; 2)
                {
                }

                trigger OnAfterGetRecord()
                begin
                          seq:=seq+1;
                          "ACA-Programme Stages".Order:=seq;
                          "ACA-Programme Stages".Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                  Clear(seq);
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

    var
        seq: Integer;
}

