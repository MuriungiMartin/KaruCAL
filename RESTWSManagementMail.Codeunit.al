#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90002 "REST WS Management Mail"
{

    trigger OnRun()
    begin
    end;

    [TryFunction]

    procedure CallRESTWebService(BaseUrl: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage)
    var
        HttpClient: dotnet HttpClient;
        Uri: dotnet Uri;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl);

        case RestMethod of
          'GET':    HttpResponseMessage := HttpClient.GetAsync(Method).Result;
          'POST':   HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
          'PUT':    HttpResponseMessage := HttpClient.PutAsync(Method,HttpContent).Result;
          'DELETE': HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        end;

        HttpResponseMessage.EnsureSuccessStatusCode(); // Throws an error when no success
    end;
}

