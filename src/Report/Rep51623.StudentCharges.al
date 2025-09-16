#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51623 "Student Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Charges.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = sorting(Description);
            RequestFilterFields = Description;
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
            column(G_L_Entry_Description;Description)
            {
            }
            column(G_L_Entry__G_L_Account_No__;"G/L Account No.")
            {
            }
            column(G_L_Entry_Description_Control1102760014;Description)
            {
            }
            column(G_L_Entry_Amount;Amount)
            {
            }
            column(TotalFor___FIELDCAPTION_Description_;TotalFor + FieldCaption(Description))
            {
            }
            column(G_L_Entry_Amount_Control1102760020;Amount)
            {
            }
            column(G_L_EntryCaption;G_L_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Entry__G_L_Account_No__Caption;FieldCaption("G/L Account No."))
            {
            }
            column(G_L_Entry_Description_Control1102760014Caption;FieldCaption(Description))
            {
            }
            column(G_L_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(G_L_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(G_L_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Description);
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
        G_L_EntryCaptionLbl: label 'G/L Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

