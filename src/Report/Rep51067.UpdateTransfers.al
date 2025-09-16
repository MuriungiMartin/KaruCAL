#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51067 "Update Transfers"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            RequestFilterFields = Description;
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  "Cust. Ledger Entry".CalcFields("Cust. Ledger Entry".Amount);
                  Journal.Init;
                  Journal."Journal Template Name":='General';
                  Journal."Journal Batch Name":='Transfers';
                  Journal."Line No.":=Journal."Line No."+1;
                  Journal."Account Type":=Journal."account type"::Customer;
                  Journal."Account No.":="Cust. Ledger Entry"."Customer No.";
                  Journal."Posting Date":="Cust. Ledger Entry"."Posting Date";
                  Journal."Document No.":="Cust. Ledger Entry"."Document No.";
                  Journal.Description:="Cust. Ledger Entry".Description;
                  Journal."Bal. Account No.":="Cust. Ledger Entry"."Bal. Account No.";
                  Journal.Amount:="Cust. Ledger Entry".Amount*-1;
                  Journal.Insert;
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
        Journal: Record "Gen. Journal Line";
}

