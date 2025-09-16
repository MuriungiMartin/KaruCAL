#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51474 "PrCorrect Transaction Balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PrCorrect Transaction Balances.rdlc';

    dataset
    {
        dataitem(UnknownTable61004;UnknownTable61004)
        {
            column(ReportForNavId_1; 1)
            {
            }
            dataitem(UnknownTable61091;UnknownTable61091)
            {
                DataItemLink = "Employee Code"=field("Emp. No"),"Transaction Code"=field("Trans Code"),"Period Month"=field("Period Month"),"Period Year"=field("Period Year");
                RequestFilterFields = "Period Month";
                column(ReportForNavId_2; 2)
                {
                }

                trigger OnAfterGetRecord()
                begin
                       "PRL-Employee Transactions".Balance:="PRL-Loan Balances".Balance;
                       "PRL-Employee Transactions".Modify;
                end;
            }
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

