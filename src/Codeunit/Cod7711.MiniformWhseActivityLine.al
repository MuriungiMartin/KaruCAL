#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7711 "Miniform Whse. Activity Line"
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
          ProcessInput;

        Clear(DOMxmlin);
    end;

    var
        MiniformHeader: Record "Miniform Header";
        XMLDOMMgt: Codeunit "XML DOM Management";
        ADCSCommunication: Codeunit "ADCS Communication";
        ADCSMgt: Codeunit "ADCS Management";
        RecRef: RecordRef;
        DOMxmlin: dotnet XmlDocument;
        ReturnedNode: dotnet XmlNode;
        RootNode: dotnet XmlNode;
        ADCSUserId: Text[250];
        Remark: Text[250];
        WhseEmpId: Text[250];
        LocationFilter: Text[250];
        Text000: label 'Function not Found.';
        Text004: label 'Invalid %1.';
        Text006: label 'No input Node found.';
        Text007: label 'Record not found.';
        Text008: label 'End of Document.';
        Text009: label 'Qty. does not match.';
        Text011: label 'Invalid Quantity.';
        CurrentCode: Text[250];
        StackCode: Text[250];
        ActiveInputField: Integer;
        Text012: label 'No Lines available.';

    local procedure ProcessInput()
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        FuncGroup: Record "Miniform Function Group";
        RecId: RecordID;
        TextValue: Text[250];
        TableNo: Integer;
        FldNo: Integer;
    begin
        if XMLDOMMgt.FindNode(RootNode,'Header/Input',ReturnedNode) then
          TextValue := ReturnedNode.InnerText
        else
          Error(Text006);

        Evaluate(TableNo,ADCSCommunication.GetNodeAttribute(ReturnedNode,'TableNo'));
        RecRef.Open(TableNo);
        Evaluate(RecId,ADCSCommunication.GetNodeAttribute(ReturnedNode,'RecordID'));
        if RecRef.Get(RecId) then begin
          RecRef.SetTable(WhseActivityLine);
          WhseActivityLine.SetCurrentkey("Activity Type","No.","Sorting Sequence No.");
          WhseActivityLine.SetRange("Activity Type",WhseActivityLine."Activity Type");
          WhseActivityLine.SetRange("No.",WhseActivityLine."No.");
          RecRef.GetTable(WhseActivityLine);
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
              Remark := Text008;
          FuncGroup.Keydef::LnUp:
            ADCSCommunication.FindRecRef(2,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::Last:
            ADCSCommunication.FindRecRef(3,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::PgDn:
            if not ADCSCommunication.FindRecRef(4,MiniformHeader."No. of Records in List") then
              Remark := Text008;
          FuncGroup.Keydef::PgUp:
            ADCSCommunication.FindRecRef(5,MiniformHeader."No. of Records in List");
          FuncGroup.Keydef::Reset:
            Reset(WhseActivityLine);
          FuncGroup.Keydef::Register:
            begin
              Register(WhseActivityLine);
              if Remark = '' then
                ADCSCommunication.RunPreviousMiniform(DOMxmlin)
              else
                SendForm(ActiveInputField);
            end;
          FuncGroup.Keydef::Input:
            begin
              Evaluate(FldNo,ADCSCommunication.GetNodeAttribute(ReturnedNode,'FieldID'));
              case FldNo of
                WhseActivityLine.FieldNo("Bin Code"):
                  CheckBinNo(WhseActivityLine,UpperCase(TextValue));
                WhseActivityLine.FieldNo("Item No."):
                  CheckItemNo(WhseActivityLine,UpperCase(TextValue));
                WhseActivityLine.FieldNo("Qty. to Handle"):
                  CheckQty(WhseActivityLine,TextValue);
                else begin
                  ADCSCommunication.FieldSetvalue(RecRef,FldNo,TextValue);
                  RecRef.SetTable(WhseActivityLine);
                end;
              end;

              WhseActivityLine.Modify;
              RecRef.GetTable(WhseActivityLine);
              ADCSCommunication.SetRecRef(RecRef);
              ActiveInputField := ADCSCommunication.GetActiveInputNo(CurrentCode,FldNo);
              if Remark = '' then
                if ADCSCommunication.LastEntryField(CurrentCode,FldNo) then begin
                  RecRef.GetTable(WhseActivityLine);
                  if not ADCSCommunication.FindRecRef(1,ActiveInputField) then begin
                    Remark := Text008;
                  end else
                    ActiveInputField := 1;
                end else
                  ActiveInputField += 1;
            end;
          else
            Error(Text000);
        end;

        if not (FuncGroup.KeyDef in [FuncGroup.Keydef::Esc,FuncGroup.Keydef::Register]) then
          SendForm(ActiveInputField);
    end;

    local procedure CheckBinNo(var WhseActLine: Record "Warehouse Activity Line";InputValue: Text[250])
    begin
        if InputValue = WhseActLine."Bin Code" then
          exit;

        Remark := StrSubstNo(Text004,WhseActLine.FieldCaption("Bin Code"));
    end;

    local procedure CheckItemNo(var WhseActLine: Record "Warehouse Activity Line";InputValue: Text[250])
    var
        ItemIdent: Record "Item Identifier";
    begin
        if InputValue = WhseActLine."Item No." then
          exit;

        if not ItemIdent.Get(InputValue) then
          Remark := StrSubstNo(Text004,ItemIdent.FieldCaption("Item No."));

        if ItemIdent."Item No." <> WhseActLine."Item No." then
          Remark := StrSubstNo(Text004,ItemIdent.FieldCaption("Item No."));

        if (ItemIdent."Variant Code" <> '') and (ItemIdent."Variant Code" <> WhseActLine."Variant Code") then
          Remark := StrSubstNo(Text004,ItemIdent.FieldCaption("Variant Code"));

        if (ItemIdent."Unit of Measure Code" <> '') and (ItemIdent."Unit of Measure Code" <> WhseActLine."Unit of Measure Code") then
          Remark := StrSubstNo(Text004,ItemIdent.FieldCaption("Unit of Measure Code"));
    end;

    local procedure CheckQty(var WhseActLine: Record "Warehouse Activity Line";InputValue: Text[250])
    var
        QtyToHandle: Decimal;
    begin
        if InputValue = '' then begin
          Remark := Text011;
          exit;
        end;

        with WhseActLine do begin
          Evaluate(QtyToHandle,InputValue);
          if QtyToHandle = Abs(QtyToHandle) then begin
            CheckItemNo(WhseActLine,"Item No.");
            if QtyToHandle <= "Qty. Outstanding" then
              Validate("Qty. to Handle",QtyToHandle)
            else
              Remark := Text011;
          end else
            Remark := Text011;
        end;
    end;

    local procedure Reset(var WhseActLine2: Record "Warehouse Activity Line")
    var
        WhseActLine: Record "Warehouse Activity Line";
    begin
        if not WhseActLine.Get(WhseActLine2."Activity Type",WhseActLine2."No.",WhseActLine2."Line No.") then
          Error(Text007);

        Remark := '';
        WhseActLine.Validate("Qty. to Handle",0);
        WhseActLine.Modify;

        RecRef.GetTable(WhseActLine);
        ADCSCommunication.SetRecRef(RecRef);
        ActiveInputField := 1;
    end;

    local procedure Register(WhseActLine2: Record "Warehouse Activity Line")
    var
        WhseActLine: Record "Warehouse Activity Line";
        WhseActivityRegister: Codeunit "Whse.-Activity-Register";
    begin
        if not WhseActLine.Get(WhseActLine2."Activity Type",WhseActLine2."No.",WhseActLine2."Line No.") then
          Error(Text007);
        if not BalanceQtyToHandle(WhseActLine) then
          Remark := Text009
        else begin
          WhseActivityRegister.ShowHideDialog(true);
          WhseActivityRegister.Run(WhseActLine);
        end;
    end;

    local procedure BalanceQtyToHandle(var WhseActivLine2: Record "Warehouse Activity Line"): Boolean
    var
        WhseActLine: Record "Warehouse Activity Line";
        QtyToPick: Decimal;
        QtyToPutAway: Decimal;
    begin
        WhseActLine.Copy(WhseActivLine2);
        with WhseActLine do begin
          SetCurrentkey("Activity Type","No.","Item No.","Variant Code","Action Type");
          SetRange("Activity Type","Activity Type");
          SetRange("No.","No.");
          SetRange("Action Type");

          if Find('-') then
            repeat
              SetRange("Item No.","Item No.");
              SetRange("Variant Code","Variant Code");
              SetRange("Serial No.","Serial No.");
              SetRange("Lot No.","Lot No.");

              if (WhseActivLine2."Action Type" = WhseActivLine2."action type"::Take) or
                 (WhseActivLine2.GetFilter("Action Type") = '')
              then begin
                SetRange("Action Type","action type"::Take);
                if Find('-') then
                  repeat
                    QtyToPick := QtyToPick + "Qty. to Handle (Base)";
                  until Next = 0;
              end;

              if (WhseActivLine2."Action Type" = WhseActivLine2."action type"::Place) or
                 (WhseActivLine2.GetFilter("Action Type") = '')
              then begin
                SetRange("Action Type","action type"::Place);
                if Find('-') then
                  repeat
                    QtyToPutAway := QtyToPutAway + "Qty. to Handle (Base)";
                  until Next = 0;
              end;

              if QtyToPick <> QtyToPutAway then
                exit(false);

              SetRange("Action Type");
              Find('+');
              SetRange("Item No.");
              SetRange("Variant Code");
              SetRange("Serial No.");
              SetRange("Lot No.");
              QtyToPick := 0;
              QtyToPutAway := 0;
            until Next = 0;
        end;
        exit(true);
    end;

    local procedure PrepareData()
    var
        WhseActivityLine: Record "Warehouse Activity Line";
        WhseActivityHeader: Record "Warehouse Activity Header";
        RecId: RecordID;
        TableNo: Integer;
    begin
        XMLDOMMgt.FindNode(RootNode,'Header/Input',ReturnedNode);

        Evaluate(TableNo,ADCSCommunication.GetNodeAttribute(ReturnedNode,'TableNo'));
        RecRef.Open(TableNo);
        Evaluate(RecId,ADCSCommunication.GetNodeAttribute(ReturnedNode,'RecordID'));
        if RecRef.Get(RecId) then begin
          RecRef.SetTable(WhseActivityHeader);
          WhseActivityLine.SetRange("Activity Type",WhseActivityHeader.Type);
          WhseActivityLine.SetRange("No.",WhseActivityHeader."No.");
          if not WhseActivityLine.FindFirst then begin
            ADCSMgt.SendError(Text012);
            exit;
          end;
          RecRef.GetTable(WhseActivityLine);
          ADCSCommunication.SetRecRef(RecRef);
          ActiveInputField := 1;
          SendForm(ActiveInputField);
        end else
          Error(Text007);
    end;

    local procedure SendForm(InputField: Integer)
    begin
        // Prepare Miniform
        ADCSCommunication.EncodeMiniForm(MiniformHeader,StackCode,DOMxmlin,InputField,Remark,ADCSUserId);
        ADCSCommunication.GetReturnXML(DOMxmlin);
        ADCSMgt.SendXMLReply(DOMxmlin);
    end;
}

