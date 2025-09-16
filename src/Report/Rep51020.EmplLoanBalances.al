#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51020 "Empl. Loan Balances"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Empl. Loan Balances.rdlc';

    dataset
    {
        dataitem(UnknownTable61003;UnknownTable61003)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Employee;"HRM-Empl. Loan Balances"."Emp. Code")
            {
            }
            column(Transaction_Code;"HRM-Empl. Loan Balances"."Trans Code")
            {
            }
            column(Totals;"HRM-Empl. Loan Balances"."Total Balance")
            {
            }

            trigger OnAfterGetRecord()
            begin
                    prpayperio.Reset;
                    prpayperio.SetRange(prpayperio."Period Month",11);
                    prpayperio.SetRange(prpayperio."Period Year",2015);
                    if  prpayperio.Find('-') then begin
                    end;

                    empTrans.Reset;
                    empTrans.SetRange(empTrans."Employee Code","HRM-Empl. Loan Balances"."Emp. Code");
                    empTrans.SetRange(empTrans."Transaction Code","HRM-Empl. Loan Balances"."Trans Code");
                    empTrans.SetRange(empTrans.Amount,"HRM-Empl. Loan Balances"."Deduction Amount");
                    empTrans.SetRange(empTrans."Period Month",11);
                    empTrans.SetRange(empTrans."Period Year",2015);
                    if empTrans.Find('-') then begin
                      empTrans.Balance:="HRM-Empl. Loan Balances"."Total Balance";
                      empTrans.Amount:="HRM-Empl. Loan Balances"."Deduction Amount";
                      empTrans.Balance:="HRM-Empl. Loan Balances"."Total Balance";
                     // empTrans."Reference No":="Empl. Loan Balances"."Reference No";

                      empTrans.Modify;
                    end else begin
                      empTrans.Init();
                      empTrans."Employee Code":="HRM-Empl. Loan Balances"."Emp. Code";
                      empTrans."Transaction Code":="HRM-Empl. Loan Balances"."Trans Code";
                      empTrans."Period Month":=11;
                      empTrans."Period Year":=2015;
                      empTrans."Payroll Period":=prpayperio."Date Opened";
                      empTrans.Amount:="HRM-Empl. Loan Balances"."Deduction Amount";
                      empTrans.Balance:="HRM-Empl. Loan Balances"."Total Balance";
                      empTrans."Reference No":="HRM-Empl. Loan Balances"."Reference No";
                      empTrans."Transaction Name":="HRM-Empl. Loan Balances"."trans Name";
                      empTrans.Insert(true);
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
        empTrans: Record UnknownRecord61091;
        prpayperio: Record UnknownRecord61081;
}

