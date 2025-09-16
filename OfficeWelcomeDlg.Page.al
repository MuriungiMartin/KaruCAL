#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1609 "Office Welcome Dlg"
{
    Caption = 'Welcome!';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Caption = '';
                Editable = false;
                Enabled = false;
                label("Welcome to your business inbox in Outlook.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Welcome to your business inbox in Outlook.';
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ShowCaption = true;
                }
                label(Control4)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Your business inbox in Outlook shows business data based on your contacts. Open one of the two evaluation email messages that we sent to your inbox, and then open the add-in again.';
                    Editable = false;
                    Enabled = false;
                    HideValue = true;
                    ShowCaption = true;
                }
            }
        }
    }

    actions
    {
    }
}

