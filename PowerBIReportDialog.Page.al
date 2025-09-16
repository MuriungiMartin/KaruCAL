#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6305 "Power BI Report Dialog"
{
    Caption = 'Power BI Report Dialog';
    Editable = false;
    LinksAllowed = false;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            usercontrol(WebPageViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    CurrPage.WebPageViewer.Navigate(EmbedUrl);
                end;

                trigger DocumentReady()
                begin
                    CurrPage.WebPageViewer.PostMessage(PostMessage,'*',false);
                    CurrPage.Update;
                end;

                trigger Callback(data: Text)
                begin
                end;

                trigger Refresh(callbackUrl: Text)
                begin
                end;
            }
        }
    }

    actions
    {
    }

    var
        EmbedUrl: Text;
        PostMessage: Text;


    procedure SetUrl(Url: Text;Message: Text)
    begin
        EmbedUrl := Url;
        PostMessage := Message;
    end;
}

