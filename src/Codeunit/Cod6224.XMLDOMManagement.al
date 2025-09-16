#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6224 "XML DOM Management"
{

    trigger OnRun()
    begin
    end;

    var
        EmptyPrefixErr: label 'Retrieval of an XML element cannot be done with an empty prefix.';


    procedure AddElement(var XMLNode: dotnet XmlNode;NodeName: Text;NodeText: Text;NameSpace: Text;var CreatedXMLNode: dotnet XmlNode): Integer
    var
        NewChildNode: dotnet XmlNode;
    begin
        NewChildNode := XMLNode.OwnerDocument.CreateNode('element',NodeName,NameSpace);
        exit(AddElementToNode(XMLNode,NewChildNode,NodeText,CreatedXMLNode));
    end;


    procedure AddRootElement(var XMLDoc: dotnet XmlDocument;NodeName: Text;var CreatedXMLNode: dotnet XmlNode)
    begin
        CreatedXMLNode := XMLDoc.CreateElement(NodeName);
        XMLDoc.AppendChild(CreatedXMLNode);
    end;


    procedure AddRootElementWithPrefix(var XMLDoc: dotnet XmlDocument;NodeName: Text;Prefix: Text;NameSpace: Text;var CreatedXMLNode: dotnet XmlNode)
    begin
        CreatedXMLNode := XMLDoc.CreateElement(Prefix,NodeName,NameSpace);
        XMLDoc.AppendChild(CreatedXMLNode);
    end;


    procedure AddElementWithPrefix(var XMLNode: dotnet XmlNode;NodeName: Text;NodeText: Text;Prefix: Text;NameSpace: Text;var CreatedXMLNode: dotnet XmlNode): Integer
    var
        NewChildNode: dotnet XmlNode;
    begin
        NewChildNode := XMLNode.OwnerDocument.CreateElement(Prefix,NodeName,NameSpace);
        exit(AddElementToNode(XMLNode,NewChildNode,NodeText,CreatedXMLNode));
    end;

    local procedure AddElementToNode(var XMLNode: dotnet XmlNode;var NewChildNode: dotnet XmlNode;NodeText: Text;var CreatedXMLNode: dotnet XmlNode) ExitStatus: Integer
    begin
        if IsNull(NewChildNode) then begin
          ExitStatus := 50;
          exit;
        end;

        if NodeText <> '' then
          NewChildNode.InnerText := NodeText;

        XMLNode.AppendChild(NewChildNode);
        CreatedXMLNode := NewChildNode;

        ExitStatus := 0;
    end;


    procedure AddAttribute(var XMLNode: dotnet XmlNode;Name: Text;NodeValue: Text): Integer
    var
        XMLNewAttributeNode: dotnet XmlNode;
    begin
        XMLNewAttributeNode := XMLNode.OwnerDocument.CreateAttribute(Name);
        exit(AddAttributeToNode(XMLNode,XMLNewAttributeNode,NodeValue));
    end;


    procedure AddAttributeWithPrefix(var XMLNode: dotnet XmlNode;Name: Text;Prefix: Text;NameSpace: Text;NodeValue: Text): Integer
    var
        XMLNewAttributeNode: dotnet XmlNode;
    begin
        XMLNewAttributeNode := XMLNode.OwnerDocument.CreateAttribute(Prefix,Name,NameSpace);
        exit(AddAttributeToNode(XMLNode,XMLNewAttributeNode,NodeValue));
    end;

    local procedure AddAttributeToNode(var XMLNode: dotnet XmlNode;var XMLNewAttributeNode: dotnet XmlNode;NodeValue: Text) ExitStatus: Integer
    begin
        if IsNull(XMLNewAttributeNode) then begin
          ExitStatus := 60;
          exit(ExitStatus)
        end;

        if NodeValue <> '' then
          XMLNewAttributeNode.Value := NodeValue;

        XMLNode.Attributes.SetNamedItem(XMLNewAttributeNode);
    end;


    procedure FindNode(XMLRootNode: dotnet XmlNode;NodePath: Text;var FoundXMLNode: dotnet XmlNode): Boolean
    begin
        if IsNull(XMLRootNode) then
          exit(false);

        FoundXMLNode := XMLRootNode.SelectSingleNode(NodePath);

        if IsNull(FoundXMLNode) then
          exit(false);

        exit(true);
    end;


    procedure FindNodeWithNamespace(XMLRootNode: dotnet XmlNode;NodePath: Text;Prefix: Text;NameSpace: Text;var FoundXMLNode: dotnet XmlNode): Boolean
    var
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        if IsNull(XMLRootNode) then
          exit(false);

        XMLNamespaceMgr := XMLNamespaceMgr.XmlNamespaceManager(XMLRootNode.OwnerDocument.NameTable);
        XMLNamespaceMgr.AddNamespace(Prefix,NameSpace);
        FoundXMLNode := XMLRootNode.SelectSingleNode(NodePath,XMLNamespaceMgr);

        if IsNull(FoundXMLNode) then
          exit(false);

        exit(true);
    end;


    procedure FindNodesWithNamespace(XMLRootNode: dotnet XmlNode;XPath: Text;Prefix: Text;NameSpace: Text;var FoundXMLNodeList: dotnet XmlNodeList): Boolean
    var
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        XMLNamespaceMgr := XMLNamespaceMgr.XmlNamespaceManager(XMLRootNode.OwnerDocument.NameTable);
        XMLNamespaceMgr.AddNamespace(Prefix,NameSpace);
        exit(FindNodesWithNamespaceManager(XMLRootNode,XPath,XMLNamespaceMgr,FoundXMLNodeList));
    end;


    procedure FindNodesWithNamespaceManager(XMLRootNode: dotnet XmlNode;XPath: Text;XMLNamespaceMgr: dotnet XmlNamespaceManager;var FoundXMLNodeList: dotnet XmlNodeList): Boolean
    begin
        if IsNull(XMLRootNode) then
          exit(false);

        FoundXMLNodeList := XMLRootNode.SelectNodes(XPath,XMLNamespaceMgr);

        if IsNull(FoundXMLNodeList) then
          exit(false);

        if FoundXMLNodeList.Count = 0 then
          exit(false);

        exit(true);
    end;


    procedure FindNodeXML(XMLRootNode: dotnet XmlNode;NodePath: Text): Text
    var
        FoundXMLNode: dotnet XmlNode;
    begin
        if IsNull(XMLRootNode) then
          exit('');

        FoundXMLNode := XMLRootNode.SelectSingleNode(NodePath);

        if IsNull(FoundXMLNode) then
          exit('');

        exit(FoundXMLNode.InnerXml);
    end;


    procedure FindNodeText(XMLRootNode: dotnet XmlNode;NodePath: Text): Text
    var
        FoundXMLNode: dotnet XmlNode;
    begin
        if IsNull(XMLRootNode) then
          exit('');

        FoundXMLNode := XMLRootNode.SelectSingleNode(NodePath);

        if IsNull(FoundXMLNode) then
          exit('');

        exit(FoundXMLNode.InnerText);
    end;


    procedure FindNodeTextWithNamespace(XMLRootNode: dotnet XmlNode;NodePath: Text;Prefix: Text;NameSpace: Text): Text
    var
        XMLNamespaceMgr: dotnet XmlNamespaceManager;
    begin
        if Prefix = '' then
          Error(EmptyPrefixErr);

        if IsNull(XMLRootNode) then
          exit('');

        XMLNamespaceMgr := XMLNamespaceMgr.XmlNamespaceManager(XMLRootNode.OwnerDocument.NameTable);
        XMLNamespaceMgr.AddNamespace(Prefix,NameSpace);

        exit(FindNodeTextNs(XMLRootNode,NodePath,XMLNamespaceMgr));
    end;


    procedure FindNodeTextNs(XMLRootNode: dotnet XmlNode;NodePath: Text;XmlNsMgr: dotnet XmlNamespaceManager): Text
    var
        FoundXMLNode: dotnet XmlNode;
    begin
        FoundXMLNode := XMLRootNode.SelectSingleNode(NodePath,XmlNsMgr);

        if IsNull(FoundXMLNode) then
          exit('');

        exit(FoundXMLNode.InnerText);
    end;


    procedure FindNodes(XMLRootNode: dotnet XmlNode;NodePath: Text;var ReturnedXMLNodeList: dotnet XmlNodeList): Boolean
    begin
        ReturnedXMLNodeList := XMLRootNode.SelectNodes(NodePath);

        if IsNull(ReturnedXMLNodeList) then
          exit(false);

        if ReturnedXMLNodeList.Count = 0 then
          exit(false);

        exit(true);
    end;


    procedure FindAttribute(var XmlNode: dotnet XmlNode;var XmlAttribute: dotnet XmlAttribute;AttributeName: Text): Boolean
    begin
        XmlAttribute := XmlNode.Attributes.GetNamedItem(AttributeName);
        exit(not IsNull(XmlAttribute));
    end;


    procedure GetAttributeValue(xmlNode: dotnet XmlNode;attributeName: Text): Text
    var
        xmlAttribute: dotnet XmlAttribute;
    begin
        xmlAttribute := xmlNode.Attributes.GetNamedItem(attributeName);
        if IsNull(xmlAttribute) then
          exit('');

        exit(xmlAttribute.Value)
    end;


    procedure AddDeclaration(var XMLDoc: dotnet XmlDocument;Version: Text;Encoding: Text;Standalone: Text)
    var
        XMLDeclaration: dotnet XmlDeclaration;
    begin
        XMLDeclaration := XMLDoc.CreateXmlDeclaration(Version,Encoding,Standalone);
        XMLDoc.InsertBefore(XMLDeclaration,XMLDoc.DocumentElement);
    end;


    procedure AddGroupNode(var XMLNode: dotnet XmlNode;NodeName: Text)
    var
        XMLNewChild: dotnet XmlDocument;
    begin
        AddElement(XMLNode,NodeName,'','',XMLNewChild);
        XMLNode := XMLNewChild;
    end;


    procedure AddNode(var XMLNode: dotnet XmlNode;NodeName: Text;NodeText: Text)
    var
        XMLNewChild: dotnet XmlNode;
    begin
        AddElement(XMLNode,NodeName,NodeText,'',XMLNewChild);
    end;


    procedure AddLastNode(var XMLNode: dotnet XmlNode;NodeName: Text;NodeText: Text)
    var
        XMLNewChild: dotnet XmlNode;
    begin
        AddElement(XMLNode,NodeName,NodeText,'',XMLNewChild);
        XMLNode := XMLNode.ParentNode;
    end;


    procedure AddNamespaces(var XmlNamespaceManager: dotnet XmlNamespaceManager;XmlDocument: dotnet XmlDocument)
    var
        XmlAttributeCollection: dotnet XmlAttributeCollection;
        XmlAttribute: dotnet XmlAttribute;
    begin
        XmlNamespaceManager := XmlNamespaceManager.XmlNamespaceManager(XmlDocument.NameTable);
        XmlAttributeCollection := XmlDocument.DocumentElement.Attributes;

        if XmlDocument.DocumentElement.NamespaceURI <> '' then
          XmlNamespaceManager.AddNamespace('',XmlDocument.DocumentElement.NamespaceURI);

        foreach XmlAttribute in XmlAttributeCollection do
          if StrPos(XmlAttribute.Name,'xmlns:') = 1 then
            XmlNamespaceManager.AddNamespace(DelStr(XmlAttribute.Name,1,6),XmlAttribute.Value);
    end;


    procedure XMLEscape(Text: Text): Text
    var
        XMLDocument: dotnet XmlDocument;
        XMLNode: dotnet XmlNode;
    begin
        XMLDocument := XMLDocument.XmlDocument;
        XMLNode := XMLDocument.CreateElement('XMLEscape');

        XMLNode.InnerText(Text);
        exit(XMLNode.InnerXml);
    end;

    [TryFunction]

    procedure LoadXMLDocumentFromText(XmlText: Text;var XmlDocument: dotnet XmlDocument)
    var
        XmlReaderSettings: dotnet XmlReaderSettings;
    begin
        LoadXmlDocFromText(XmlText,XmlDocument,XmlReaderSettings.XmlReaderSettings);
    end;


    procedure LoadXMLNodeFromText(XmlText: Text;var XmlNode: dotnet XmlNode)
    var
        XmlDocument: dotnet XmlDocument;
        XmlReaderSettings: dotnet XmlReaderSettings;
    begin
        LoadXmlDocFromText(XmlText,XmlDocument,XmlReaderSettings.XmlReaderSettings);
        XmlNode := XmlDocument.DocumentElement;
    end;

    [TryFunction]

    procedure LoadXMLDocumentFromInStream(InStream: InStream;var XmlDocument: dotnet XmlDocument)
    begin
        XmlDocument := XmlDocument.XmlDocument;
        XmlDocument.Load(InStream);
    end;

    [TryFunction]

    procedure LoadXMLNodeFromInStream(InStream: InStream;var XmlNode: dotnet XmlNode)
    var
        XmlDocument: dotnet XmlDocument;
    begin
        LoadXMLDocumentFromInStream(InStream,XmlDocument);
        XmlNode := XmlDocument.DocumentElement;
    end;


    procedure LoadXMLDocumentFromOutStream(OutStream: OutStream;var XmlDocument: dotnet XmlDocument)
    begin
        XmlDocument := XmlDocument.XmlDocument;
        XmlDocument.Load(OutStream);
    end;


    procedure LoadXMLDocumentFromFile(FileName: Text;var XmlDocument: dotnet XmlDocument)
    var
        File: dotnet File;
    begin
        LoadXMLDocumentFromText(File.ReadAllText(FileName),XmlDocument);
    end;


    procedure LoadXMLDocumentFromFileWithXmlReaderSettings(FileName: Text;var XmlDocument: dotnet XmlDocument;XmlReaderSettings: dotnet XmlReaderSettings)
    var
        File: dotnet File;
    begin
        LoadXmlDocFromText(File.ReadAllText(FileName),XmlDocument,XmlReaderSettings);
    end;

    local procedure LoadXmlDocFromText(XmlText: Text;var XmlDocument: dotnet XmlDocument;XmlReaderSettings: dotnet XmlReaderSettings)
    var
        StringReader: dotnet StringReader;
        XmlTextReader: dotnet XmlTextReader0;
    begin
        ClearUTF8BOMSymbols(XmlText);
        StringReader := StringReader.StringReader(XmlText);
        XmlTextReader := XmlTextReader.Create(StringReader,XmlReaderSettings);
        XmlDocument := XmlDocument.XmlDocument;
        XmlDocument.Load(XmlTextReader);
        XmlTextReader.Close;
        StringReader.Close;
    end;

    local procedure ClearUTF8BOMSymbols(var XmlText: Text)
    var
        UTF8Encoding: dotnet UTF8Encoding;
        ByteOrderMarkUtf8: Text;
    begin
        UTF8Encoding := UTF8Encoding.UTF8Encoding;
        ByteOrderMarkUtf8 := UTF8Encoding.GetString(UTF8Encoding.GetPreamble);
        if StrPos(XmlText,ByteOrderMarkUtf8) = 1 then
          XmlText := DelStr(XmlText,1,StrLen(ByteOrderMarkUtf8));
    end;

    [TryFunction]

    procedure SaveXMLDocumentToOutStream(var OutStream: OutStream;XMLRootNode: dotnet XmlNode)
    begin
        XMLRootNode.OwnerDocument.Save(OutStream);
    end;
}

