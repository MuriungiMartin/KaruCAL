#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5084 "Content Preview"
{
    Caption = 'Content Preview';

    layout
    {
        area(content)
        {
            group(EmailBody)
            {
                Caption = 'Email Body';
                usercontrol(BodyHTMLMessage;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
                {
                    ApplicationArea = RelationshipMgmt;
                }
            }
        }
    }

    actions
    {
    }

    var
        HTMLContent: Text;


    procedure SetContent(InHTMLContent: Text)
    begin
        HTMLContent := InHTMLContent;
    end;
}

