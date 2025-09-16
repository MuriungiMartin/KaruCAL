#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51030 "Validate Journal Cust"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Validate Journal Cust.rdlc';

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.");
            RequestFilterFields = "Journal Template Name","Journal Batch Name",Field69032;
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
            column(Gen__Journal_Line_Journal_Batch_Name;"Journal Batch Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                  Cust.Reset;
                  Cust.SetRange(Cust.No,"Gen. Journal Line"."Account No.");
                  if Cust.Find('-') then begin
                  "Gen. Journal Line"."Account No.":=Cust.No2;
                  "Gen. Journal Line".Modify;
                  end;
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
        Cust: Record UnknownRecord61007;
        Gen__Journal_LineCaptionLbl: label 'Gen. Journal Line';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

