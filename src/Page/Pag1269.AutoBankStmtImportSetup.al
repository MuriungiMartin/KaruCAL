#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1269 "Auto. Bank Stmt. Import Setup"
{
    Caption = 'Automatic Bank Statement Import Setup';
    PageType = StandardDialog;
    SourceTable = "Bank Account";

    layout
    {
        area(content)
        {
            field("Transaction Import Timespan";"Transaction Import Timespan")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Number of Days Included';
                ToolTip = 'Specifies how far back in time to get new bank transactions for.';
            }
            field("Automatic Stmt. Import Enabled";"Automatic Stmt. Import Enabled")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Enabled';
                ToolTip = 'Specifies that the service is enabled.';
            }
        }
    }

    actions
    {
    }
}

