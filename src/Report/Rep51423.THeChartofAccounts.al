#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51423 "THe Chart of Accounts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/THe Chart of Accounts.rdlc';

    dataset
    {
        dataitem("G/L Account";"G/L Account")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6710; 6710)
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
            column(G_L_Account__No__;"No.")
            {
            }
            column(G_L_Account_Name;Name)
            {
            }
            column(G_L_Account__Income_Balance_;"Income/Balance")
            {
            }
            column(G_L_Account_Totaling;Totaling)
            {
            }
            column(G_L_Account__Account_Type_;"Account Type")
            {
            }
            column(The_Chart_Of_Accounts_ListCaption;The_Chart_Of_Accounts_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Account__No__Caption;FieldCaption("No."))
            {
            }
            column(G_L_Account_NameCaption;FieldCaption(Name))
            {
            }
            column(G_L_Account__Income_Balance_Caption;FieldCaption("Income/Balance"))
            {
            }
            column(G_L_Account_TotalingCaption;FieldCaption(Totaling))
            {
            }
            column(G_L_Account__Account_Type_Caption;FieldCaption("Account Type"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        The_Chart_Of_Accounts_ListCaptionLbl: label 'The Chart Of Accounts List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

