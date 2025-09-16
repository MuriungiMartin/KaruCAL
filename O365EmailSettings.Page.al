#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2128 "O365 Email Settings"
{
    Caption = 'Email for all new invoices';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "O365 Email Setup";

    layout
    {
        area(content)
        {
            part("CC List";"O365 Email CC Listpart")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'CC List';
                ToolTip = 'List of CC recipients on all new invoices';
            }
            part("BCC List";"O365 Email BCC Listpart")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'BCC List';
                ToolTip = 'List of BCC recipients on all new invoices';
            }
        }
    }

    actions
    {
    }
}

