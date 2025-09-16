#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7707 "Miniform Mainmenu"
{
    TableNo = "Miniform Header";

    trigger OnRun()
    var
        MiniformMgt: Codeunit "Miniform Management";
    begin
        MiniformMgt.Initialize(
          MiniformHeader,Rec,DOMxmlin,ReturnedNode,
          RootNode,XMLDOMMgt,ADCSCommunication,ADCSUserId,
          CurrentCode,StackCode,WhseEmpId,LocationFilter);

        if Code <> CurrentCode then
          SendForm(1)
        else
          Process;

        Clear(DOMxmlin);
    end;

    var
        MiniformHeader: Record "Miniform Header";
        MiniformHeader2: Record "Miniform Header";
        XMLDOMMgt: Codeunit "XML DOM Management";
        ADCSCommunication: Codeunit "ADCS Communication";
        ADCSMgt: Codeunit "ADCS Management";
        ReturnedNode: dotnet XmlNode;
        RootNode: dotnet XmlNode;
        DOMxmlin: dotnet XmlDocument;
        TextValue: Text[250];
        ADCSUserId: Text[250];
        WhseEmpId: Text[250];
        LocationFilter: Text[250];
        CurrentCode: Text[250];
        StackCode: Text[250];
        Text005: label 'No input Node found.';

    local procedure Process()
    begin
        if XMLDOMMgt.FindNode(RootNode,'Header/Input',ReturnedNode) then
          TextValue := ReturnedNode.InnerText
        else
          Error(Text005);

        ADCSCommunication.GetCallMiniForm(MiniformHeader.Code,MiniformHeader2,TextValue);
        ADCSCommunication.IncreaseStack(DOMxmlin,MiniformHeader.Code);
        MiniformHeader2.SaveXMLin(DOMxmlin);
        Codeunit.Run(MiniformHeader2."Handling Codeunit",MiniformHeader2);
    end;

    local procedure SendForm(ActiveInputField: Integer)
    begin
        ADCSCommunication.EncodeMiniForm(MiniformHeader,'',DOMxmlin,ActiveInputField,'',ADCSUserId);
        ADCSCommunication.GetReturnXML(DOMxmlin);
        ADCSMgt.SendXMLReply(DOMxmlin);
    end;
}

