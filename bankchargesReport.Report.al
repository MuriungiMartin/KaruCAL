#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51283 "bank charges Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/bank charges Report.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(GLAccountNo_GLEntry;"G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry;"G/L Entry"."Posting Date")
            {
            }
            column(DocumentType_GLEntry;"G/L Entry"."Document Type")
            {
            }
            column(DocumentNo_GLEntry;"G/L Entry"."Document No.")
            {
            }
            column(Description_GLEntry;"G/L Entry".Description)
            {
            }
            column(BalAccountNo_GLEntry;"G/L Entry"."Bal. Account No.")
            {
            }
            column(Amount_GLEntry;"G/L Entry".Amount)
            {
            }
            column(UserID_GLEntry;"G/L Entry"."User ID")
            {
            }

            trigger OnAfterGetRecord()
            begin

                SetRange("G/L Entry"."G/L Account No.",'19601');
                SetRange("G/L Entry".Description,'Bank Charges');
                //SETRANGE("G/L Entry"."Bal. Account Type":="G/L Entry"."Bal. Account Type"::Bank Account);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("G/L Entry"."G/L Account No.",'19601');
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

    trigger OnInitReport()
    begin
         //"G/L Entry".RESET;
    end;

    trigger OnPreReport()
    begin
        //"G/L Entry".RESET;
    end;

    var
        glentry: Record "G/L Entry";
}

