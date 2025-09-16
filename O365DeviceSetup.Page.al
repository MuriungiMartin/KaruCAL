#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1308 "O365 Device Setup"
{
    ApplicationArea = Basic;
    Caption = 'Get the App';
    PageType = StandardDialog;
    SourceTable = "O365 Device Setup Instructions";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Get the app on your smartphone")
            {
                Caption = 'Get the app on your smartphone';
                group("1. INSTALL THE APP")
                {
                    Caption = '1. INSTALL THE APP';
                    InstructionalText = 'To install the app, point your smartphone browser to this URL or scan the QR code';
                    field("Setup URL";"Setup URL")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Open in browser';
                        Editable = false;
                    }
                    field(QR;"QR Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'or QR Code';
                        Editable = false;
                    }
                }
                group("2. IN APP")
                {
                    Caption = '2. IN APP';
                    InstructionalText = 'Enter your user name and password that you created during sign-up for Dynamics 365 for Financials and follow the instructions on the screen.';
                }
            }
        }
    }

    actions
    {
    }
}

