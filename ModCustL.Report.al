#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51700 "Mod Cust L"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Mod Cust L.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where(Open=const(false),"Remaining Amt. (LCY)"=filter(<>0));
            RequestFilterFields = "Customer No.";
            column(ReportForNavId_8503; 8503)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Cust__Ledger_Entry__Entry_No__;"Entry No.")
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__;"Remaining Amt. (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_Type_;"Document Type")
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_;"Currency Code")
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(Cust__Ledger_EntryCaption;Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Entry_No__Caption;FieldCaption("Entry No."))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption;FieldCaption("Remaining Amt. (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption;FieldCaption("Document Type"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption;FieldCaption("Currency Code"))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Cust. Ledger Entry"."Closed by Entry No.":=0;
                "Cust. Ledger Entry"."Closed at Date":=0D;
                "Cust. Ledger Entry"."Closed by Amount":=0;
                "Cust. Ledger Entry"."Closed by Amount (LCY)":=0;
                "Cust. Ledger Entry"."Closed by Currency Code":='';
                "Cust. Ledger Entry"."Closed by Currency Amount":=0;
                "Cust. Ledger Entry".Open:=true;
                "Cust. Ledger Entry".Modify;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Entry No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Cust__Ledger_EntryCaptionLbl: label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

