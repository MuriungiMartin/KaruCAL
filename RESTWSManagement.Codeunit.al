#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60051 "REST WS Management"
{

    trigger OnRun()
    begin
    end;

    [TryFunction]

    procedure CallRESTWebService(BaseUrl: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage)
    var
        HttpClient: dotnet HttpClient;
        Uri: dotnet Uri;
        ServicePointManager: dotnet ServicePointManager;
        SecurityProtocalType: dotnet SecurityProtocolType;
    begin


        ServicePointManager.Expect100Continue := true;
        ServicePointManager.SecurityProtocol := SecurityProtocalType.Tls12;

        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl+Method);
        case RestMethod of
          'GET':    HttpResponseMessage := HttpClient.GetAsync(Method).Result;
          'POST':   HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
          'PUT':    HttpResponseMessage := HttpClient.PutAsync(Method,HttpContent).Result;
          'DELETE': HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        end;

        HttpResponseMessage.EnsureSuccessStatusCode(); // Throws an error when no success
    end;
}

