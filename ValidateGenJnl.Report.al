#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51640 "Validate Gen Jnl"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Gen Jnl.rdlc';

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
            column(Gen__Journal_Line__Journal_Template_Name_;"Journal Template Name")
            {
            }
            column(Gen__Journal_Line__Line_No__;"Line No.")
            {
            }
            column(Gen__Journal_Line__Account_Type_;"Account Type")
            {
            }
            column(Gen__Journal_Line__Account_No__;"Account No.")
            {
            }
            column(Gen__Journal_Line__Posting_Date_;"Posting Date")
            {
            }
            column(Gen__Journal_Line__Document_Type_;"Document Type")
            {
            }
            column(Gen__Journal_Line__Document_No__;"Document No.")
            {
            }
            column(Gen__Journal_Line_Description;Description)
            {
            }
            column(Gen__Journal_LineCaption;Gen__Journal_LineCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Gen__Journal_Line__Journal_Template_Name_Caption;FieldCaption("Journal Template Name"))
            {
            }
            column(Gen__Journal_Line__Line_No__Caption;FieldCaption("Line No."))
            {
            }
            column(Gen__Journal_Line__Account_Type_Caption;FieldCaption("Account Type"))
            {
            }
            column(Gen__Journal_Line__Account_No__Caption;FieldCaption("Account No."))
            {
            }
            column(Gen__Journal_Line__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Gen__Journal_Line__Document_Type_Caption;FieldCaption("Document Type"))
            {
            }
            column(Gen__Journal_Line__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Gen__Journal_Line_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name;"Journal Batch Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //"Gen. Journal Line"."Account No.":='11254';
                "Gen. Journal Line".Validate("Gen. Journal Line"."Document No.");
                "Gen. Journal Line".Validate("Gen. Journal Line"."Account No.");
                "Gen. Journal Line".Validate("Gen. Journal Line"."Posting Date");
                "Gen. Journal Line".Validate("Gen. Journal Line".Amount);
                "Gen. Journal Line".Validate("Gen. Journal Line"."Bal. Account No.");
                "Gen. Journal Line".Validate("Gen. Journal Line"."Shortcut Dimension 1 Code");
                "Gen. Journal Line".Modify;
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
        Gen__Journal_LineCaptionLbl: label 'Gen. Journal Line';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

