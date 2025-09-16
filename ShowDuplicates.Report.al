#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51618 "Show Duplicates"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Show Duplicates.rdlc';

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.");
            RequestFilterFields = "Journal Template Name","Journal Batch Name";
            column(ReportForNavId_7024; 7024)
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
            column(Gen__Journal_Line__Account_No__;"Account No.")
            {
            }
            column(Gen__Journal_Line__Posting_Date_;"Posting Date")
            {
            }
            column(Gen__Journal_Line__Document_No__;"Document No.")
            {
            }
            column(Gen__Journal_Line_Description;Description)
            {
            }
            column(Gen__Journal_Line__Bal__Account_No__;"Bal. Account No.")
            {
            }
            column(Gen__Journal_Line__Amount__LCY__;"Amount (LCY)")
            {
            }
            column(Gen__Journal_Line__Applies_to_Doc__No__;"Applies-to Doc. No.")
            {
            }
            column(Gen__Journal_LineCaption;Gen__Journal_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Gen__Journal_Line__Account_No__Caption;FieldCaption("Account No."))
            {
            }
            column(Gen__Journal_Line__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Gen__Journal_Line__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Gen__Journal_Line_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Gen__Journal_Line__Bal__Account_No__Caption;FieldCaption("Bal. Account No."))
            {
            }
            column(Gen__Journal_Line__Amount__LCY__Caption;FieldCaption("Amount (LCY)"))
            {
            }
            column(Gen__Journal_Line__Applies_to_Doc__No__Caption;FieldCaption("Applies-to Doc. No."))
            {
            }
            column(Gen__Journal_Line_Journal_Template_Name;"Journal Template Name")
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name;"Journal Batch Name")
            {
            }
            column(Gen__Journal_Line_Line_No_;"Line No.")
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
        LastAppNo: Code[60];
        Gen__Journal_LineCaptionLbl: label 'Gen. Journal Line';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

