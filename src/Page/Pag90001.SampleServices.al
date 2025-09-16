#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90001 "Sample Services"
{
    PageType = Card;
    SourceTable = UnknownTable61511;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Mails;mails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Mail';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(TestMails)
            {
                ApplicationArea = Basic;
                Caption = 'Test Mail';
                Image = Aging;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Post',true) = false then Error('Cancelled!');
                    VerifyEmailAddressWS.ValidateEmailAddress(mails);
                end;
            }
        }
    }

    var
        mails: Text[150];
        VerifyEmailAddressWS: Codeunit "Verify Email Address WS";

    local procedure CALLRestWebService(BaseURL: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage)
    var
        HttpClient: dotnet HttpClient;
        Uri: dotnet ;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseURL);

        case RestMethod of
        'GET':
        HttpResponseMessage := HttpClient.GetAsync(Method).Result;
        'POST':
        HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
        'PUT':
        HttpResponseMessage := HttpClient.PutAsync(Method,HttpContent).Result;
        'DELETE':
        HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        end;

        HttpResponseMessage.EnsureSuccessStatusCode(); // Throws an error when no success
    end;
}

