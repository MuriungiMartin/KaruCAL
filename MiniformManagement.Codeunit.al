#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7702 "Miniform Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'The Node does not exist.';


    procedure ReceiveXML(xmlin: dotnet XmlDocument)
    var
        MiniFormHeader: Record "Miniform Header";
        XMLDOMMgt: Codeunit "XML DOM Management";
        ADCSCommunication: Codeunit "ADCS Communication";
        ADCSManagement: Codeunit "ADCS Management";
        DOMxmlin: dotnet XmlDocument;
        RootNode: dotnet XmlNode;
        ReturnedNode: dotnet XmlNode;
        TextValue: Text[250];
    begin
        DOMxmlin := xmlin;
        RootNode := DOMxmlin.DocumentElement;
        if XMLDOMMgt.FindNode(RootNode,'Header',ReturnedNode) then begin
          TextValue := ADCSCommunication.GetNodeAttribute(ReturnedNode,'UseCaseCode');
          if UpperCase(TextValue) = 'HELLO' then
            TextValue := ADCSCommunication.GetLoginFormCode;
          MiniFormHeader.Get(TextValue);
          MiniFormHeader.TestField("Handling Codeunit");
          MiniFormHeader.SaveXMLin(DOMxmlin);
          if not Codeunit.Run(MiniFormHeader."Handling Codeunit",MiniFormHeader) then
            ADCSManagement.SendError(GetLastErrorText);
        end else
          Error(Text001);
    end;


    procedure Initialize(var MiniformHeader: Record "Miniform Header";var Rec: Record "Miniform Header";var DOMxmlin: dotnet XmlDocument;var ReturnedNode: dotnet XmlNode;var RootNode: dotnet XmlNode;var XMLDOMMgt: Codeunit "XML DOM Management";var ADCSCommunication: Codeunit "ADCS Communication";var ADCSUserId: Text[250];var CurrentCode: Text[250];var StackCode: Text[250];var WhseEmpId: Text[250];var LocationFilter: Text[250])
    begin
        DOMxmlin := DOMxmlin.XmlDocument;

        MiniformHeader := Rec;
        MiniformHeader.LoadXMLin(DOMxmlin);
        RootNode := DOMxmlin.DocumentElement;
        XMLDOMMgt.FindNode(RootNode,'Header',ReturnedNode);
        CurrentCode := ADCSCommunication.GetNodeAttribute(ReturnedNode,'UseCaseCode');
        StackCode := ADCSCommunication.GetNodeAttribute(ReturnedNode,'StackCode');
        ADCSUserId := ADCSCommunication.GetNodeAttribute(ReturnedNode,'LoginID');
        ADCSCommunication.GetWhseEmployee(ADCSUserId,WhseEmpId,LocationFilter);
    end;
}

