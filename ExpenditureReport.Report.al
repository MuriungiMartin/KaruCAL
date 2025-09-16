#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51312 "Expenditure Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Expenditure Report.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            RequestFilterFields = "G/L Account No.","Posting Date";
            column(ReportForNavId_2731; 2731)
            {
            }
            column(Accont;"G/L Entry"."G/L Account No.")
            {
            }
            column(Name;"G/LEntry"."G/L Account Name")
            {
            }
            column(date;"G/L Entry"."Posting Date")
            {
            }
            column(Doc;"G/LEntry"."Document No.")
            {
            }
            column(Cheque;"G/LEntry"."External Document No.")
            {
            }
            column(Source;"G/LEntry".Descr)
            {
            }
            column(VendorName;"G/LEntry"."Source No.")
            {
            }
            column(Description;"G/LEntry".Description)
            {
            }
            column(Campus;"G/LEntry"."Global Dimension 1 Code")
            {
            }
            column(Dept;"G/LEntry"."Global Dimension 2 Code")
            {
            }
            column(amount;"G/LEntry".Amount)
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
        Balance: Decimal;
        Allocation: Decimal;
        Transfer: Decimal;
        Exp: Decimal;
        BudgetEntry: Record "G/L Budget Entry";
        "G/LEntry": Record "G/L Entry";
        Commitment: Decimal;
        GenSetup: Record "General Ledger Setup";
        ImprestDetails: Record UnknownRecord61126;
        Payments: Record UnknownRecord61134;
        CommRec: Record UnknownRecord61135;
        SRN: Record UnknownRecord61148;
        "SRN Line": Record UnknownRecord61149;
        LineNo: Integer;
        ExpBuffrer: Record UnknownRecord61184;
        "GL ACC": Record "G/L Account";
        VoteEntry: Boolean;
        Expenditure_ReportCaptionLbl: label 'Expenditure Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Total_AmountCaptionLbl: label 'Total Amount';


    procedure "Populate Buffer"()
    begin
    end;
}

