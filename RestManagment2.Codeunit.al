#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60054 "Rest Managment 2"
{

    trigger OnRun()
    begin
        dhbAuthText[1] := 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJqaEZNalpDTkRkRk1UY3dRamMwTURBeE5EZ3pOelkxT0RjMU5ERkdSVVUzT0RKRU56TXhPUSJ9.';
        dhbAuthText[2] := 'eyJpc3MiOiJodHRwczovL2FwcHMtcmFpbGNhcnJ4LmF1dGgwLmNvbS8iLCJzdWIiOiJXSkZoNW93NWdKT1U3MmgxYVFDN3BVa000OXlyRmVNQ0BjbGllbnRzIiwiYXVk';
        dhbAuthText[3] := 'IjoiaHR0cHM6Ly9yc20tYXBpLnJhaWxjYXJyeHFhLmNvbSIsImlhdCI6MTUzNTA5NjIyNywiZXhwIjoxNTM1MTgyNjI3LCJhenAiOiJXSkZoNW93NWdKT1U3MmgxYVFD';
        dhbAuthText[4] := 'N3BVa000OXlyRmVNQyIsImd0eSI6ImNsaWVudC1jcmVkZW50aWFscyJ9.JGBfaZBb7mjTrNj_HPL1DXPPfAEqbw0XlBHqDz_Dl8lmztnuprZRkb5BXn50XS-KSyToVyE';
        dhbAuthText[5] := 'JTmOlpmpT-jRCSs5WNNQtxJJ5XxGVdVND4HDcWRRAoiyJcaLmK-puJvpjNUk-2s5MKGmEakI0YxjwwVYsX-5ZHM3xfHRgGc73-ekfFW2PJz0sBuK4ftQpH9oV1TmiSou';
        dhbAuthText[6] := 'wCPZGTNDZcz9eEWpo1m2OQdwHswcy5L6QnSMhHswiGPx_bYB_VzVVWOAWo0SbTDSL9tOhsceZnZTtxCq8eg1AYCS8OVJqVRr-kmAMjtf67muvMozSrfSGBOGW_iBEnGRC3c6VJ-STLWwz0w';


        StartJson;
        if dhbItem.FindFirst then begin
          repeat
            dhbItem.CalcFields(Inventory);
            AddToJson('CustomerKey','a2285a4f-a80c-455f-8839-f3fa74ca5f7d');
            AddToJson('PartCode',dhbItem."No.");
            AddToJson('Description',dhbItem.Description);
            AddToJson('AlternateDescription',dhbItem."Description 2");
            AddToJson('UnitOfMeasure',dhbItem."Base Unit of Measure");
            AddToJson('EffectiveDate','nall');
            AddToJson('ExpiryDate','nall');
            AddToJson('ThresholdQuantity',dhbItem.Inventory);
            AddToJson('Location','nall');
            AddToJson('Active','true');
            AddToJson('Certified','false');
            AddToJson('Taxable','false');
          until dhbItem.Next = 0;
        end;
         EndJson;
         Json := Json.Copy(StringBuilder.ToString);
         UploadJson('https://xa3js8hmu3.execute-api.us-east-1.amazonaws.com/dev/parts',Json);
    end;

    var
        StringBuilder: dotnet StringBuilder;
        StringWriter: dotnet StringWriter;
        StringReader: dotnet StringReader;
        Json: dotnet String;
        JsonTextWriter: dotnet JsonTextWriter;
        JsonTextReader: dotnet JsonTextReader;
        Encoding: dotnet Encoding;
        NAVWebRequest: dotnet NAVWebRequest;
        HttpWebException: dotnet WebException;
        HttpWebRequestError: Text;
        HttpRequestHeader: dotnet HttpRequestHeader;
        dhbAuthText: array [6] of Text;
        dhbItem: Record Item;


    procedure Initialize()
    var
        Formatting: dotnet Formatting;
    begin
        StringBuilder := StringBuilder.StringBuilder;
        StringWriter := StringWriter.StringWriter(StringBuilder);
        JsonTextWriter := JsonTextWriter.JsonTextWriter(StringWriter);
        JsonTextWriter.Formatting := Formatting.Indented;
    end;


    procedure StartJson()
    begin
        Initialize;
        JsonTextWriter.WriteStartObject;
    end;


    procedure AddToJson(VariableName: Text;Variable: Variant)
    begin
        JsonTextWriter.WritePropertyName(VariableName);
        JsonTextWriter.WriteValue(Format(Variable,0,9));
    end;


    procedure EndJson()
    begin
        JsonTextWriter.WriteEndObject;
    end;


    procedure GetJson()
    begin
        Json := StringBuilder.ToString;
        Initialize;
    end;


    procedure UploadJson(WebServiceURL: Text;String: dotnet String)
    var
        HttpWebRequest: dotnet HttpWebRequest;
        HttpWebResponse: dotnet HttpWebResponse;
    begin
        CreateWebRequest(HttpWebRequest,WebServiceURL,'POST');
        SetRequestStream(HttpWebRequest,String);
        DoWebRequest(HttpWebRequest,HttpWebResponse,'');
        GetResponseStream(HttpWebResponse,String);
    end;


    procedure CreateWebRequest(var HttpWebRequest: dotnet HttpWebRequest;WebServiceURL: Text;Method: Text)
    begin
        HttpWebRequest := HttpWebRequest.Create(WebServiceURL);
        HttpWebRequest.Timeout := 300000;
        HttpWebRequest.Method := Method;
        HttpWebRequest.Accept := 'application/json';
        HttpWebRequest.ContentType := 'application/json';

        HttpWebRequest.Headers.Add('Authorization', dhbAuthText[1]+dhbAuthText[2]+dhbAuthText[3]+dhbAuthText[4]+dhbAuthText[5]+dhbAuthText[6]);
        HttpWebRequest.Headers.Add('x-api-key','LViHg8iYYa6VPZqhyemO92swvuo8RiZbage4Y4en');
    end;


    procedure SetRequestStream(var HttpWebRequest: dotnet HttpWebRequest;var String: dotnet String)
    var
        StreamWriter: dotnet StreamWriter;
    begin
        StreamWriter := StreamWriter.StreamWriter(HttpWebRequest.GetRequestStream,Encoding.GetEncoding('iso8859-1'));
        StreamWriter.Write(String);
        StreamWriter.Close;
    end;


    procedure GetResponseStream(var HTTPWebResponse: dotnet HttpWebResponse;var String: dotnet String)
    var
        StreamReader: dotnet StreamReader;
    begin
        StreamReader := StreamReader.StreamReader(HTTPWebResponse.GetResponseStream);
        String := StreamReader.ReadToEnd;
    end;


    procedure DoWebRequest(var HttpWebRequest: dotnet HttpWebRequest;var HTTPWebResponse: dotnet HttpWebResponse;IgnoreCode: Code[10])
    var
        NAVWebRequest: dotnet NAVWebRequest;
        HttpWebException: dotnet WebException;
    begin
        NAVWebRequest := NAVWebRequest.NAVWebRequest;
        if not NAVWebRequest.doRequest(HttpWebRequest,HttpWebException,HTTPWebResponse) then
          if (IgnoreCode = '') or (StrPos(HttpWebException.Message,IgnoreCode) = 0) then
            Error(HttpWebRequestError,HttpWebException.Status.ToString,HttpWebException.Message);
    end;
}

