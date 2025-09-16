#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7712 "Miniform Phys. Journal List"
{
    TableNo = "Miniform Header";

    trigger OnRun()
    var
        MiniformMgmt: Codeunit "Miniform Management";
    begin
        MiniformMgmt.Initialize(
          MiniformHeader,Rec,DOMxmlin,ReturnedNode,
          RootNode,XMLDOMMgt,ADCSCommunication,ADCSUserId,
          CurrentCode,StackCode,WhseEmpId,LocationFilter);

        if Code <> CurrentCode then
          PrepareData
        else
          ProcessSelection;

        Clear(DOMxmlin);
    end;

    var
        MiniformHeader: Record "Miniform Header";
        MiniformHeader2: Record "Miniform Header";
        WhseJournalBatch: Record "Warehouse Journal Batch";
        XMLDOMMgt: Codeunit "XML DOM Management";
        ADCSCommunication: Codeunit "ADCS Communication";
        ADCSMgt: Codeunit "ADCS Management";
        RecRef: RecordRef;
        ReturnedNode: dotnet XmlNode;
        DOMxmlin: dotnet XmlDocument;
        RootNode: dotnet XmlNode;
        Text000: label 'Function not Found.';
        Text006: label 'No input Node found.';
        TextValue: Text[250];
        ADCSUserId: Text[250];
        WhseEmpId: Text[250];
        LocationFilter: Text[250];
        CurrentCode: Text[250];
        PreviousCode: Text[250];
        StackCode: Text[250];
        Remark: Text[250];
        ActiveInputField: Integer;
        Text009: label 'No Documents found.';

    local procedure ProcessSelection()
    var
        FuncGroup: Record "Miniform Function Group";
        RecId: RecordID;
        TableNo: Integer;
    begin
        if XMLDOMMgt.FindNode(RootNode,'Header/Input',ReturnedNode) then
          TextValue := ReturnedNode.InnerText
        else
          Error(Text006);

        Evaluate(TableNo,ADCSCommunication.GetNodeAttribute(ReturnedNode,'TableNo'));
        RecRef.Open(TableNo);
        Evaluate(RecId,ADCSCommunication.GetNodeAttribute(ReturnedNode,'RecordID'));
        if RecRef.Get(RecId) then begin
          RecRef.SetTable(WhseJournalBatch);
          WhseJournalBatch.SetRange("Journal Template Name",WhseJournalBatch."Journal Template Name");
          WhseJournalBatch.SetFilter("Location Code",LocationFilter);
          WhseJournalBatch.SetRange("Assigned User ID",WhseEmpId);
          RecRef.GetTable(WhseJournalBatch);
          ADCSCommunication.SetRecRef(RecRef);
        end else begin
          ADCSCommunication.RunPreviousMiniform(DOMxmlin);
          exit;
        end;

        FuncGroup.KeyDef := ADCSCommunication.GetFunctionKey(MiniformHeader.Code,TextValue);
        ActiveInputField := 1;

        case FuncGroup.KeyDef of
          FuncGroup.Keydef::Esc:
            ADCSCommunication.RunPreviousMiniform(DOMxmlin);
          FuncGroup.Keydef::First:
            ADCSCommunication.FindRecRef(0,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::LnDn:
            if not ADCSCommunication.FindRecRef(1,MiniformHeader."No. of Records in List") then
              Remark := Text009;
          FuncGroup.Keydef::LnUp:
            ADCSCommunication.FindRecRef(2,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::Last:
            ADCSCommunication.FindRecRef(3,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::PgDn:
            if not ADCSCommunication.FindRecRef(4,MiniformHeader."No. of Records in List") then
              Remark := Text009;
          FuncGroup.Keydef::PgUp:
            ADCSCommunication.FindRecRef(5,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::Input:
            begin
              ADCSCommunication.IncreaseStack(DOMxmlin,MiniformHeader.Code);
              ADCSCommunication.GetNextMiniForm(MiniformHeader,MiniformHeader2);
              MiniformHeader2.SaveXMLin(DOMxmlin);
              Codeunit.Run(MiniformHeader2."Handling Codeunit",MiniformHeader2);
            end;
          else
            Error(Text000);
        end;

        if not (FuncGroup.KeyDef in [FuncGroup.Keydef::Esc,FuncGroup.Keydef::Input]) then
          SendForm(ActiveInputField);
    end;

    local procedure PrepareData()
    begin
        with WhseJournalBatch do begin
          Reset;
          SetCurrentkey("Location Code","Assigned User ID");
          if WhseEmpId <> '' then begin
            SetRange("Assigned User ID",WhseEmpId);
            SetFilter("Location Code",LocationFilter);
          end;
          if not FindFirst then begin
            if ADCSCommunication.GetNodeAttribute(ReturnedNode,'RunReturn') = '0' then begin
              ADCSMgt.SendError(Text009);
              exit;
            end;
            ADCSCommunication.DecreaseStack(DOMxmlin,PreviousCode);
            MiniformHeader2.Get(PreviousCode);
            MiniformHeader2.SaveXMLin(DOMxmlin);
            Codeunit.Run(MiniformHeader2."Handling Codeunit",MiniformHeader2);
          end else begin
            RecRef.GetTable(WhseJournalBatch);
            ADCSCommunication.SetRecRef(RecRef);
            ActiveInputField := 1;
            SendForm(ActiveInputField);
          end;
        end;
    end;

    local procedure SendForm(InputField: Integer)
    begin
        ADCSCommunication.EncodeMiniForm(MiniformHeader,StackCode,DOMxmlin,InputField,Remark,ADCSUserId);
        ADCSCommunication.GetReturnXML(DOMxmlin);
        ADCSMgt.SendXMLReply(DOMxmlin);
    end;
}

