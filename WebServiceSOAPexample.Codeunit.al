#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90055 "Web Service SOAP example"
{

    trigger OnRun()
    var
        CallService: Codeunit "Call Service";
    begin
        /*
        xml := '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body>'+
                 '<GetHolidaysForYear xmlns="http://www.holidaywebservice.com/HolidayService_v2/">'+
                   '<countryCode>UnitedStates</countryCode>'+
                   '<year>2019</year>'+
                 '</GetHolidaysForYear>'+
               '</soap:Body></soap:Envelope>';
        
        url := 'http://www.holidaywebservice.com/HolidayService_v2/HolidayService2.asmx';
        uriObj := uriObj.Uri(url);
        Request := Request.CreateDefault(uriObj);
        Request.Method := 'POST';
        Request.ContentType := 'text/xml';
        soapAction := '"http://www.holidaywebservice.com/HolidayService_v2/GetHolidaysForYear"';
        Request.Headers.Add('SOAPAction', soapAction);
        Request.Timeout := 120000;
        
        // Send the request to the webservice
        stream := stream.StreamWriter(Request.GetRequestStream(), ascii.UTF8);
        stream.Write(xml);
        stream.Close();
        
        // Get the response
        Response := Request.GetResponse();
        reader := reader.XmlTextReader(Response.GetResponseStream());
        
        // Save the response to a XML
        document := document.XmlDocument();
        document.Load(reader);
        FileSrv := FileMgt.ServerTempFileName('xml');
        document.Save(FileSrv);
        
        // Get from the server
        ToFile := FileMgt.ClientTempFileName('xml');
        FileMgt.DownloadToFile(FileSrv, ToFile);
        
        // Show the response XML
        HYPERLINK(ToFile);
        */
        CallService.CallService();

    end;

    var
        uriObj: dotnet Uri;
        Request: dotnet HttpWebRequest;
        stream: dotnet StreamWriter;
        Response: dotnet HttpWebResponse;
        reader: dotnet XmlTextReader0;
        document: dotnet XmlDocument;
        ascii: dotnet Encoding;
        FileMgt: Codeunit "File Management";
        FileSrv: Text;
        ToFile: Text;
        xml: Text;
        url: Text;
        soapAction: Text;
}

