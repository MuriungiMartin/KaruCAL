#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51300 "VAT Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VAT Report.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = sorting("G/L Account No.","Posting Date") where("G/L Account No."=const('200011'));
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_7069; 7069)
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
            column(G_L_Entry__G_L_Account_No__;"G/L Account No.")
            {
            }
            column(G_L_Entry__G_L_Account_No___Control1102760011;"G/L Account No.")
            {
            }
            column(G_L_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(G_L_Entry__Document_No__;"Document No.")
            {
            }
            column(G_L_Entry__Debit_Amount_;"Debit Amount")
            {
            }
            column(G_L_Entry__Credit_Amount_;"Credit Amount")
            {
            }
            column(vendorname;vendorname)
            {
            }
            column(TotalFor___FIELDCAPTION__G_L_Account_No___;TotalFor + FieldCaption("G/L Account No."))
            {
            }
            column(G_L_Entry__Debit_Amount__Control1102760029;"Debit Amount")
            {
            }
            column(G_L_Entry__Credit_Amount__Control1102760030;"Credit Amount")
            {
            }
            column(G_L_EntryCaption;G_L_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Entry__G_L_Account_No___Control1102760011Caption;FieldCaption("G/L Account No."))
            {
            }
            column(G_L_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(G_L_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(G_L_Entry__Debit_Amount_Caption;FieldCaption("Debit Amount"))
            {
            }
            column(G_L_Entry__Credit_Amount_Caption;FieldCaption("Credit Amount"))
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(G_L_Entry__G_L_Account_No__Caption;FieldCaption("G/L Account No."))
            {
            }
            column(G_L_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                vendorled.Reset;
                  vendorname:='';

                vendorled.SetRange(vendorled."Document No.","G/L Entry"."Document No.");
                if vendorled.Find('-') then begin
                  vendorrec.Reset;
                  vendorrec.SetRange(vendorrec."No.",vendorled."Vendor No.");
                  if vendorrec.Find('-') then begin
                    vendorname:=vendorrec.Name;
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("G/L Account No.");
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
        vendorled: Record "Vendor Ledger Entry";
        vendorrec: Record Vendor;
        vendorname: Text[100];
        G_L_EntryCaptionLbl: label 'G/L Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DescriptionCaptionLbl: label 'Description';
}

