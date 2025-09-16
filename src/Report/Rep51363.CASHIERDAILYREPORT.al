#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51363 "CASHIER DAILY REPORT"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CASHIER DAILY REPORT.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Reversed=const(false),Amount=filter(>0));
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_7069; 7069)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(G_L_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(G_L_Entry__Document_Type_;"Document Type")
            {
            }
            column(G_L_Entry__Document_No__;"Document No.")
            {
            }
            column(G_L_Entry_Description;Description)
            {
            }
            column(G_L_Entry_Amount;Amount)
            {
            }
            column(G_L_Entry__User_ID_;"User ID")
            {
            }
            column(G_L_Entry_Amount_Control1000000003;Amount)
            {
            }
            column(KISUMU_HOTELCaption;KISUMU_HOTELCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ACCOMODATION_INCOMECaption;ACCOMODATION_INCOMECaptionLbl)
            {
            }
            column(G_L_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(G_L_Entry__Document_Type_Caption;FieldCaption("Document Type"))
            {
            }
            column(G_L_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(G_L_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(G_L_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(G_L_Entry__User_ID_Caption;FieldCaption("User ID"))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(G_L_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin

                  "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Bank Account No.",'2003');
                  "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry".Reversed,false);
            end;

            trigger OnPreDataItem()
            begin
                  "Bank Account Ledger Entry".SetRange("Bank Account Ledger Entry"."Bank Account No.",'2003');
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
        KISUMU_HOTELCaptionLbl: label 'KARATINA UNIVERSITY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ACCOMODATION_INCOMECaptionLbl: label 'INCOME';
        TotalCaptionLbl: label 'Total';
}

