#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51624 "Redirect Student Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Redirect Student Charges.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "G/L Account No.",Description;
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
            column(G_L_Entry__Entry_No__;"Entry No.")
            {
            }
            column(G_L_Entry__G_L_Account_No__;"G/L Account No.")
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
            column(G_L_Entry__Bal__Account_No__;"Bal. Account No.")
            {
            }
            column(G_L_Entry_Amount;Amount)
            {
            }
            column(G_L_EntryCaption;G_L_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(G_L_Entry__Entry_No__Caption;FieldCaption("Entry No."))
            {
            }
            column(G_L_Entry__G_L_Account_No__Caption;FieldCaption("G/L Account No."))
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
            column(G_L_Entry__Bal__Account_No__Caption;FieldCaption("Bal. Account No."))
            {
            }
            column(G_L_Entry_AmountCaption;FieldCaption(Amount))
            {
            }

            trigger OnAfterGetRecord()
            begin
                GenJnl.Init;
                GenJnl."Line No." := GenJnl."Line No." + 10000;
                GenJnl."Posting Date":="G/L Entry"."Posting Date";
                GenJnl."Document No.":="G/L Entry"."Document No.";
                GenJnl.Validate(GenJnl."Document No.");
                GenJnl."Journal Template Name":='SALES';
                GenJnl."Journal Batch Name":='STUD TR';
                GenJnl."Account Type":=GenJnl."account type"::"G/L Account";
                GenJnl."Account No.":="G/L Entry"."G/L Account No.";
                GenJnl.Amount:=-"G/L Entry".Amount;
                GenJnl.Validate(GenJnl."Account No.");
                GenJnl.Validate(GenJnl.Amount);
                GenJnl.Description:="G/L Entry"."Source No." + ' - ' + "G/L Entry".Description;
                GenJnl."Bal. Account Type":=GenJnl."bal. account type"::"G/L Account";
                GenJnl."Bal. Account No.":='300004';
                GenJnl.Validate(GenJnl."Bal. Account No.");
                GenJnl."Shortcut Dimension 1 Code":="G/L Entry"."Global Dimension 1 Code";
                GenJnl."Shortcut Dimension 2 Code":="G/L Entry"."Global Dimension 2 Code";
                GenJnl.Validate(GenJnl."Shortcut Dimension 1 Code");
                GenJnl.Validate(GenJnl."Shortcut Dimension 2 Code");
                GenJnl.Insert;
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
        GenJnl: Record "Gen. Journal Line";
        G_L_EntryCaptionLbl: label 'G/L Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

