#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99000 "test Res"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/test Res.rdlc';

    dataset
    {
        dataitem(UnknownTable61548;UnknownTable61548)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Prog;"ACA-Exam Results".Programme)
            {
            }
            column(UnitCode;"ACA-Exam Results".Unit)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ((StrLen("ACA-Exam Results".Unit)<7) or (StrLen("ACA-Exam Results".Unit)>7)) then CurrReport.Skip;
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

