#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 130404 "CAL Test Project Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        FileMgt: Codeunit "File Management";
        FileDialogFilterTxt: label 'Test Project file (*.xml)|*.xml|All Files (*.*)|*.*', Locked=true;
        XMLDOMMgt: Codeunit "XML DOM Management";


    procedure Export(CALTestSuiteName: Code[10]): Boolean
    var
        CALTestSuite: Record "CAL Test Suite";
        CALTestLine: Record "CAL Test Line";
        ProjectXML: dotnet XmlDocument;
        DocumentElement: dotnet XmlNode;
        TestNode: dotnet XmlNode;
        XMLDataFile: Text;
        FileFilter: Text;
        ToFile: Text;
    begin
        XMLDOMMgt.LoadXMLDocumentFromText(
          StrSubstNo(
            '<?xml version="1.0" encoding="UTF-16" standalone="yes"?><%1></%1>','CALTests'),
          ProjectXML);

        CALTestSuite.Get(CALTestSuiteName);
        DocumentElement := ProjectXML.DocumentElement;
        XMLDOMMgt.AddAttribute(DocumentElement,CALTestSuite.FieldName(Name),CALTestSuite.Name);
        XMLDOMMgt.AddAttribute(DocumentElement,CALTestSuite.FieldName(Description),CALTestSuite.Description);

        CALTestLine.SetRange("Test Suite",CALTestSuite.Name);
        CALTestLine.SetRange("Line Type",CALTestLine."line type"::Codeunit);
        if CALTestLine.FindSet then
          repeat
            TestNode := ProjectXML.CreateElement('Codeunit');
            XMLDOMMgt.AddAttribute(TestNode,'ID',Format(CALTestLine."Test Codeunit"));
            DocumentElement.AppendChild(TestNode);
          until CALTestLine.Next = 0;

        XMLDataFile := FileMgt.ServerTempFileName('');
        FileFilter := GetFileDialogFilter;
        ToFile := 'PROJECT.xml';
        ProjectXML.Save(XMLDataFile);

        FileMgt.DownloadHandler(XMLDataFile,'Download','',FileFilter,ToFile);

        exit(true);
    end;


    procedure Import()
    var
        CALTestSuite: Record "CAL Test Suite";
        AllObjWithCaption: Record AllObjWithCaption;
        CALTestManagement: Codeunit "CAL Test Management";
        ProjectXML: dotnet XmlDocument;
        DocumentElement: dotnet XmlNode;
        TestNode: dotnet XmlNode;
        TestNodes: dotnet XmlNodeList;
        ServerFileName: Text;
        NodeCount: Integer;
        TestID: Integer;
    begin
        ServerFileName := FileMgt.ServerTempFileName('.xml');
        if UploadXMLPackage(ServerFileName) then begin
          XMLDOMMgt.LoadXMLDocumentFromFile(ServerFileName,ProjectXML);
          DocumentElement := ProjectXML.DocumentElement;

          CALTestSuite.Name :=
            CopyStr(
              GetAttribute(GetElementName(CALTestSuite.FieldName(Name)),DocumentElement),1,
              MaxStrLen(CALTestSuite.Name));
          CALTestSuite.Description :=
            CopyStr(
              GetAttribute(GetElementName(CALTestSuite.FieldName(Description)),DocumentElement),1,
              MaxStrLen(CALTestSuite.Description));
          if not CALTestSuite.Get(CALTestSuite.Name) then
            CALTestSuite.Insert;

          TestNodes := DocumentElement.ChildNodes;
          for NodeCount := 0 to (TestNodes.Count - 1) do begin
            TestNode := TestNodes.Item(NodeCount);
            if Evaluate(TestID,Format(GetAttribute('ID',TestNode))) then begin
              AllObjWithCaption.SetRange("Object Type",AllObjWithCaption."object type"::Codeunit);
              AllObjWithCaption.SetRange("Object ID",TestID);
              CALTestManagement.AddTestCodeunits(CALTestSuite,AllObjWithCaption);
            end;
          end;
        end;
    end;

    local procedure GetAttribute(AttributeName: Text;var XMLNode: dotnet XmlNode): Text
    var
        XMLAttributes: dotnet XmlNamedNodeMap;
        XMLAttributeNode: dotnet XmlNode;
    begin
        XMLAttributes := XMLNode.Attributes;
        XMLAttributeNode := XMLAttributes.GetNamedItem(AttributeName);
        if IsNull(XMLAttributeNode) then
          exit('');
        exit(Format(XMLAttributeNode.InnerText));
    end;

    local procedure GetElementName(NameIn: Text): Text
    begin
        NameIn := DelChr(NameIn,'=','“»''`');
        NameIn := DelChr(ConvertStr(NameIn,'<>,./\+-&()%:','             '),'=',' ');
        NameIn := DelChr(NameIn,'=',' ');
        if NameIn[1] in ['0','1','2','3','4','5','6','7','8','9'] then
          NameIn := '_' + NameIn;
        exit(NameIn);
    end;

    local procedure GetFileDialogFilter(): Text
    begin
        exit(FileDialogFilterTxt);
    end;

    local procedure UploadXMLPackage(ServerFileName: Text): Boolean
    begin
        exit(Upload('Import project','',GetFileDialogFilter,'',ServerFileName));
    end;
}

