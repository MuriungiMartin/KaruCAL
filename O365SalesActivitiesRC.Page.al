#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9029 "O365 Sales Activities RC"
{
    Caption = 'O365 Sales Activities RC';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control2;"O365 Sales Activities")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control3;"O365 Sales Document List")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Invoices';
            }
            part(Control4;"O365 Sales Item List")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Item List';
                SubPageView = where(Blocked=const(false));
            }
            part(Control5;"O365 Customer Activity Page")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customer List';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Email Settings")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Email Settings';
                Image = Setup;
                RunObject = Page "O365 Email Settings";
                ToolTip = 'Manage your email settings';
            }
            action("Export Invoices")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export Invoices';
                Image = SendEmailPDF;
                RunObject = Page "O365 Export Invoices";
                ToolTip = 'Export and send invoices.';
            }
        }
    }
}

