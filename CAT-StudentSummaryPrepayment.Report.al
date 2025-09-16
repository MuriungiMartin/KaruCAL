#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51816 "CAT-Student Summary Prepayment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Student Summary Prepayment.rdlc';

    dataset
    {
        dataitem(UnknownTable61176;UnknownTable61176)
        {
            RequestFilterFields = "Customer No";
            column(ReportForNavId_1; 1)
            {
            }
            column(EntryNo_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger"."Entry No")
            {
            }
            column(CustomerNo_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger"."Customer No")
            {
            }
            column(EntryType_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger"."Entry Type")
            {
            }
            column(Date_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger".Date)
            {
            }
            column(Description_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger".Description)
            {
            }
            column(Amount_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger".Amount*(-1))
            {
            }
            column(UserID_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger"."User ID")
            {
            }
            column(Reversed_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger".Reversed)
            {
            }
            column(ReversedOn_CateringPrepaymentLedger;"CAT-Catering Prepayment Ledger"."Reversed On")
            {
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

    var
        info: Record "Company Information";
        Address: Text[250];
        Tel: Code[100];
        Fax: Code[20];
        PIN: Code[20];
        Email: Text[50];
        VAT: Code[20];
        DetTotal: Decimal;
        totals: Decimal;
        change: Decimal;
        Amounts: Decimal;
        creditEmp: Code[150];
        "Cafeteria Receipts Line": Record UnknownRecord61173;
}

