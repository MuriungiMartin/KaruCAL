#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1239 "XML Buffer Reader"
{

    trigger OnRun()
    begin
    end;

    var
        DefaultNamespace: Text;

    [TryFunction]

    procedure SaveToFile(FilePath: Text;var XMLBuffer: Record "XML Buffer")
    var
        TempXMLBuffer: Record "XML Buffer" temporary;
        TempAttributeXMLBuffer: Record "XML Buffer" temporary;
        XMLDOMManagement: Codeunit "XML DOM Management";
        XmlDocument: dotnet XmlDocument;
        RootElement: dotnet XmlNode;
        Header: Text;
    begin
        TempXMLBuffer.CopyImportFrom(XMLBuffer);
        TempXMLBuffer := XMLBuffer;
        TempXMLBuffer.SetCurrentkey("Parent Entry No.",Type,"Node Number");
        Header := '<?xml version="1.0" encoding="UTF-8"?>' +
          '<' + TempXMLBuffer.GetElementName + ' ';

        DefaultNamespace := TempXMLBuffer.GetAttributeValue('xmlns');
        if TempXMLBuffer.FindAttributes(TempAttributeXMLBuffer) then
          repeat
            Header += TempAttributeXMLBuffer.Name + '="' + TempAttributeXMLBuffer.Value + '" ';
          until TempAttributeXMLBuffer.Next = 0;
        Header += '/>';

        XMLDOMManagement.LoadXMLDocumentFromText(Header,XmlDocument);
        RootElement := XmlDocument.DocumentElement;

        SaveChildElements(TempXMLBuffer,RootElement,XmlDocument);

        XmlDocument.Save(FilePath);
    end;

    local procedure SaveChildElements(var TempParentElementXMLBuffer: Record "XML Buffer" temporary;XMLCurrElement: dotnet XmlNode;XmlDocument: dotnet XmlDocument)
    var
        TempElementXMLBuffer: Record "XML Buffer" temporary;
        ChildElement: dotnet XmlNode;
        Namespace: Text;
    begin
        if TempParentElementXMLBuffer.FindChildElements(TempElementXMLBuffer) then
          repeat
            if TempElementXMLBuffer.Namespace = '' then
              Namespace := DefaultNamespace
            else
              Namespace := TempElementXMLBuffer.Namespace;
            ChildElement := XmlDocument.CreateNode('element',TempElementXMLBuffer.GetElementName,Namespace);
            if TempElementXMLBuffer.Value <> '' then
              ChildElement.InnerText := TempElementXMLBuffer.Value;
            XMLCurrElement.AppendChild(ChildElement);
            SaveAttributes(TempElementXMLBuffer,ChildElement,XmlDocument);
            SaveChildElements(TempElementXMLBuffer,ChildElement,XmlDocument);
          until TempElementXMLBuffer.Next = 0;
    end;

    local procedure SaveAttributes(var TempParentElementXMLBuffer: Record "XML Buffer" temporary;XMLCurrElement: dotnet XmlNode;XmlDocument: dotnet XmlDocument)
    var
        TempAttributeXMLBuffer: Record "XML Buffer" temporary;
        Attribute: dotnet XmlAttribute;
    begin
        if TempParentElementXMLBuffer.FindAttributes(TempAttributeXMLBuffer) then
          repeat
            Attribute := XmlDocument.CreateAttribute(TempAttributeXMLBuffer.Name);
            Attribute.InnerText := TempAttributeXMLBuffer.Value;
            XMLCurrElement.Attributes.SetNamedItem(Attribute);
          until TempAttributeXMLBuffer.Next = 0;
    end;
}

