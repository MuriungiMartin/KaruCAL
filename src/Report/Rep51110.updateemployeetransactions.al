#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51110 "update employee transactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/update employee transactions.rdlc';

    dataset
    {
        dataitem(UnknownTable61117;UnknownTable61117)
        {
            column(ReportForNavId_8174; 8174)
            {
            }

            trigger OnAfterGetRecord()
            begin
                    prEmpTrans.Init;
                    prEmpTrans."Employee Code":="PRL-Employee Trans IMP BAL"."Employee Code";
                    prEmpTrans."Transaction Code":="PRL-Employee Trans IMP BAL"."Transaction Code";
                    prEmpTrans.Validate("Transaction Code");
                    prEmpTrans."Period Month":=1;
                    prEmpTrans."Period Year":=2011;
                    prEmpTrans."Payroll Period":=20110101D;
                    //prEmpTrans.Amount:="prEmployee Trans IMP BAL".Amount;
                    prEmpTrans."Amortized Loan Total Repay Amt":="PRL-Employee Trans IMP BAL".Amount;
                    prEmpTrans.Balance:="PRL-Employee Trans IMP BAL".Balance;
                    prEmpTrans.Insert;
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
        prEmpTrans: Record UnknownRecord61091;
}

