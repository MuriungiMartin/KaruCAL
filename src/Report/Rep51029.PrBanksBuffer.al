#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51029 "Pr Banks Buffer"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            DataItemTableView = where("Period Month"=filter(10));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                                empSal.Reset;
                                empSal.SetRange(empSal."Employee Code","PRL-Salary Card"."Employee Code");
                                empSal.SetRange(empSal."Period Month",11);
                                if empSal.Find('-') then begin
                                  empSal."Basic Pay":="PRL-Salary Card"."Basic Pay";
                                  empSal.Modify;
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

    var
        empSal: Record UnknownRecord61105;
}

