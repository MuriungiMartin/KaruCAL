#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90006 "Call Service"
{

    trigger OnRun()
    begin
    end;


    procedure CallService()
    var
        url: Text[150];
        reqText: Text[150];
        webServReqMgt: Codeunit "SOAP Web Service Request Mgt.";
        reqBodyOutStream: OutStream;
        reqBodyInStream: InStream;
        respBodyInStream: InStream;
        responseXmlDoc: dotnet XmlDocument;
        tempBlob: Record TempBlob;
        "action": Text[50];
        password: Text[100];
        UserName: Text[100];
    begin
        url := 'http://www.dneonline.com/calculator.asmx';
        //set body content of soap envelope
        reqText := '<add><inta>1</inta><intb>2</intb></add>';
        action := 'http://tempuri.org/Add';

        // save request text in instream
        tempBlob."Primary Key" := 1;
        tempBlob.Blob.CreateOutstream(reqBodyOutStream);
        reqBodyOutStream.Write(reqText);
        tempBlob.Blob.CreateInstream(reqBodyInStream);

        // run the WebServReqMgt functions to send the request
        webServReqMgt.SetGlobals(reqBodyInStream,url,UserName,password);
        webServReqMgt.SetCustomGlobals(true,action,false,'','');
        webServReqMgt.DisableHttpsCheck;
        webServReqMgt.SetTraceMode(true); //to check the xml messages
        webServReqMgt.SendRequestToWebService;

        // get the response
        responseXmlDoc := responseXmlDoc.XmlDocument;
        responseXmlDoc.Load(respBodyInStream);
        Message(responseXmlDoc.InnerXml);
    end;
}

