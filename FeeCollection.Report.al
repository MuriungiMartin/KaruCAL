#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51370 "Fee Collection"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fee Collection.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Customer No.",Description,"Settlement Type","Date Filter","Credit Amount (LCY)";
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
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
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
            column(Cust__Ledger_Entry__Document_No___Control1102760020;"Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Sname;Sname)
            {
            }
            column(Cust__Ledger_Entry__Credit_Amount__LCY__;"Credit Amount (LCY)")
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(TotalFor___FIELDCAPTION__Document_No___;TotalFor + FieldCaption("Document No."))
            {
            }
            column(Totals;Totals)
            {
            }
            column(Fee_Collection_ReportCaption;Fee_Collection_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
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
            column(Cust__Ledger_Entry__Document_No___Control1102760020Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Amount_PaidCaption;Amount_PaidCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Totals:=Totals+"Cust. Ledger Entry"."Credit Amount";
                Cust.Reset;

                Sname:='';
                Cust.SetRange(Cust."No.","Cust. Ledger Entry"."Customer No.");
                  if Cust.Find('-') then begin
                    Sname:=Cust.Name;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Document No.");
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
        TotalFor: label 'Total for ';
        Totals: Decimal;
        Sname: Text[150];
        Cust: Record Customer;
        Fee_Collection_ReportCaptionLbl: label 'Fee Collection Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Amount_PaidCaptionLbl: label 'Amount Paid';
        NameCaptionLbl: label 'Name';
}

