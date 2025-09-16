#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1820 "Video link Part"
{
    Caption = 'Video link Part';
    Editable = false;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            usercontrol(WebPageViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = Basic,Suite;

                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    CurrPage.WebPageViewer.Navigate(URL);
                end;

                trigger DocumentReady()
                begin
                end;

                trigger Callback(data: Text)
                begin
                    CurrPage.Close;
                end;
            }
        }
    }

    actions
    {
    }

    var
        URL: Text;


    procedure SetURL(NavigateToURL: Text)
    begin
        URL := NavigateToURL;
    end;


    procedure Navigate(NavigateToUrl: Text)
    begin
        URL := NavigateToUrl;
        CurrPage.WebPageViewer.Navigate(URL);
    end;
}

