#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9981 "Buy Subscription"
{
    Caption = 'Buy Subscription';
    Editable = false;

    layout
    {
        area(content)
        {
            usercontrol(WebPageViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = Basic,Suite;

                trigger ControlAddInReady(callbackUrl: Text)
                begin
                    CurrPage.WebPageViewer.Navigate(ForwardLinkMgt.GetLanguageSpecificUrl(BuySubscriptionForwardLinkTxt));
                end;

                trigger DocumentReady()
                begin
                end;

                trigger Callback(data: Text)
                begin
                end;

                trigger Refresh(callbackUrl: Text)
                begin
                    CurrPage.WebPageViewer.Navigate(ForwardLinkMgt.GetLanguageSpecificUrl(BuySubscriptionForwardLinkTxt));
                end;
            }
        }
    }

    actions
    {
    }

    var
        BuySubscriptionForwardLinkTxt: label 'https://go.microsoft.com/fwlink/?linkid=828659', Locked=true;
        ForwardLinkMgt: Codeunit "Forward Link Mgt.";
}

