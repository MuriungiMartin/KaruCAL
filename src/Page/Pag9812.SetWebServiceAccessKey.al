#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9812 "Set Web Service Access Key"
{
    Caption = 'Set Web Service Access Key';
    DataCaptionExpression = "Full Name";
    InstructionalText = 'Set Web Service Access Key';
    PageType = StandardDialog;
    SourceTable = User;

    layout
    {
        area(content)
        {
            group(somegroup)
            {
                Caption = 'Setting a new Web Service key makes the old key not valid.';
            }
            field(NeverExpires;NeverExpires)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Key Never Expires';
                ToolTip = 'Specifies that the web service access key cannot expire.';
            }
            field(ExpirationDate;ExpirationDate)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Key Expiration Date';
                Editable = not NeverExpires;
                ToolTip = 'Specifies when the web service access key expires.';
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then begin
          if NeverExpires then
            IdentityManagement.CreateWebServicesKeyNoExpiry("User Security ID")
          else
            IdentityManagement.CreateWebServicesKey("User Security ID",ExpirationDate);
        end;
    end;

    var
        IdentityManagement: Codeunit "Identity Management";
        ExpirationDate: DateTime;
        NeverExpires: Boolean;
}

