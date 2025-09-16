#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 186 "Update Finance Charge Text"
{
    Caption = 'Update Finance Charge Text';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Finance Charge Memo Header";"Finance Charge Memo Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_8733; 8733)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FinChrgMemoHeader.UpdateLines("Finance Charge Memo Header");
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
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
}

