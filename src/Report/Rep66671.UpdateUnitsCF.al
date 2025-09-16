#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66671 "Update Units CF"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Subjs;UnknownTable61517)
        {
            DataItemTableView = where("Credit Hours"=filter(0));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Subjs."Credit Hours":=Subjs."No. Units";
                Subjs.Modify;
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
}

