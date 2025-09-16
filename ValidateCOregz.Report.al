#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 56603 "Validate COregz"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate COregz.rdlc';

    dataset
    {
        dataitem(Coregzs;UnknownTable61532)
        {
            DataItemTableView = where("Year Of Study"=filter(0));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Coregzs.Validate(Stage);
                Coregzs.Modify;
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

