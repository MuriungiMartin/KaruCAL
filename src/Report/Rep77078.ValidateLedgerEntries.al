#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77078 "Validate Ledger Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Ledger Entries.rdlc';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CustLedgerEntry.Reset;
                CustLedgerEntry.SetRange(CustLedgerEntry."Entry No.","Detailed Cust. Ledg. Entry"."Cust. Ledger Entry No.");
                if CustLedgerEntry.Find('-') then begin
                  CustLedgerEntry."Detailed Ledger Entry No":="Detailed Cust. Ledg. Entry"."Entry No.";
                  CustLedgerEntry.Modify;
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
        CustLedgerEntry: Record "Cust. Ledger Entry";
}

