#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7700 "ADCS Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        InboundDocument: dotnet XmlDocument;
        OutboundDocument: dotnet XmlDocument;


    procedure SendXMLReply(xmlout: dotnet XmlDocument)
    begin
        OutboundDocument := xmlout;
    end;


    procedure SendError(ErrorString: Text[250])
    var
        XMLDOMMgt: Codeunit "XML DOM Management";
        RootNode: dotnet XmlNode;
        Child: dotnet XmlNode;
        ReturnedNode: dotnet XmlNode;
    begin
        OutboundDocument := InboundDocument;

        // Error text
        Clear(XMLDOMMgt);
        RootNode := OutboundDocument.DocumentElement;

        if XMLDOMMgt.FindNode(RootNode,'Header',ReturnedNode) then begin
          if XMLDOMMgt.FindNode(RootNode,'Header/Input',Child) then
            ReturnedNode.RemoveChild(Child);
          if XMLDOMMgt.FindNode(RootNode,'Header/Comment',Child) then
            ReturnedNode.RemoveChild(Child);
          XMLDOMMgt.AddElement(ReturnedNode,'Comment',ErrorString,'',ReturnedNode);
        end;

        Clear(RootNode);
        Clear(Child);
    end;


    procedure ProcessDocument(Document: dotnet XmlDocument)
    var
        MiniformMgt: Codeunit "Miniform Management";
    begin
        InboundDocument := Document;
        MiniformMgt.ReceiveXML(InboundDocument);
    end;


    procedure GetOutboundDocument(var Document: dotnet XmlDocument)
    begin
        Document := OutboundDocument;
    end;
}

