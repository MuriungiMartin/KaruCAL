#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51002 "Update recon. lines"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update recon. lines.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
        {
            RequestFilterFields = "Bank Account No.","Statement No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(no;"Bank Account Ledger Entry"."Bank Account No.")
            {
            }
            column(accname;"Bank Account Ledger Entry"."Statement No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Bank Account Ledger Entry".TestField("Bank Account No.");
                "Bank Account Ledger Entry".TestField("Statement No.");
                "Bank Account Ledger Entry".Reset;
                "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Bank Account No.","Bank Account Ledger Entry"."Bank Account No.");
                "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Statement No.","Bank Account Ledger Entry"."Statement No.");
                "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Statement Status","Bank Account Ledger Entry"."statement status"::"Bank Acc. Entry Applied");
                if "Bank Account Ledger Entry".FindFirst then begin
                //"Bank Account Ledger Entry"."Remaining Amount":="Bank Account Ledger Entry".Amount;
                //"Bank Account Ledger Entry".Open:=TRUE;
                "Bank Account Ledger Entry"."Statement Status":="Bank Account Ledger Entry"."statement status"::Open;
                "Bank Account Ledger Entry"."Statement No.":='';
                "Bank Account Ledger Entry"."Statement Line No.":=0;

                "Bank Account Ledger Entry".Modify;
                  end;
            end;

            trigger OnPostDataItem()
            begin
                Message('Done');
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
        bankledger: Record "Bank Account Ledger Entry";
}

