#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51620 "Open Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Open Entries.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.","Posting Date","Currency Code") where(Open=const(true),"Remaining Amount"=filter(<0));
            RequestFilterFields = "Customer No.","Document No.","Posting Date";
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
            column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_;"Remaining Amount")
            {
            }
            column(Cust__Ledger_Entry_Open;Open)
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
            column(Cust__Ledger_Entry__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_Caption;FieldCaption("Remaining Amount"))
            {
            }
            column(Cust__Ledger_Entry_OpenCaption;FieldCaption(Open))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Customer No.");
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

