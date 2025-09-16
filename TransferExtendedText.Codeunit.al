#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 378 "Transfer Extended Text"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'There is not enough space to insert extended text lines.';
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Res: Record Resource;
        TmpExtTextLine: Record "Extended Text Line" temporary;
        NextLineNo: Integer;
        LineSpacing: Integer;
        MakeUpdateRequired: Boolean;
        AutoText: Boolean;


    procedure SalesCheckIfAnyExtText(var SalesLine: Record "Sales Line";Unconditionally: Boolean): Boolean
    var
        SalesHeader: Record "Sales Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(SalesLine."Line No.",SalesLine."No.",SalesLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteSalesLines(SalesLine);

        AutoText := false;

        if Unconditionally then
          AutoText := true
        else
          case SalesLine.Type of
            SalesLine.Type::" ":
              AutoText := true;
            SalesLine.Type::"G/L Account":
              begin
                if GLAcc.Get(SalesLine."No.") then
                  AutoText := GLAcc."Automatic Ext. Texts";
              end;
            SalesLine.Type::Item:
              begin
                if Item.Get(SalesLine."No.") then
                  AutoText := Item."Automatic Ext. Texts";
              end;
            SalesLine.Type::Resource:
              begin
                if Res.Get(SalesLine."No.") then
                  AutoText := Res."Automatic Ext. Texts";
              end;
          end;

        if AutoText then begin
          SalesLine.TestField("Document No.");
          SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");
          ExtTextHeader.SetRange("Table Name",SalesLine.Type);
          ExtTextHeader.SetRange("No.",SalesLine."No.");
          case SalesLine."Document Type" of
            SalesLine."document type"::Quote:
              ExtTextHeader.SetRange("Sales Quote",true);
            SalesLine."document type"::"Blanket Order":
              ExtTextHeader.SetRange("Sales Blanket Order",true);
            SalesLine."document type"::Order:
              ExtTextHeader.SetRange("Sales Order",true);
            SalesLine."document type"::Invoice:
              ExtTextHeader.SetRange("Sales Invoice",true);
            SalesLine."document type"::"Return Order":
              ExtTextHeader.SetRange("Sales Return Order",true);
            SalesLine."document type"::"Credit Memo":
              ExtTextHeader.SetRange("Sales Credit Memo",true);
          end;
          exit(ReadLines(ExtTextHeader,SalesHeader."Document Date",SalesHeader."Language Code"));
        end;
    end;


    procedure ReminderCheckIfAnyExtText(var ReminderLine: Record "Reminder Line";Unconditionally: Boolean): Boolean
    var
        ReminderHeader: Record "Reminder Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(ReminderLine."Line No.",ReminderLine."No.",ReminderLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteReminderLines(ReminderLine);

        if Unconditionally then
          AutoText := true
        else
          case ReminderLine.Type of
            ReminderLine.Type::" ":
              AutoText := true;
            ReminderLine.Type::"G/L Account":
              if GLAcc.Get(ReminderLine."No.") then
                AutoText := GLAcc."Automatic Ext. Texts";
          end;

        if AutoText then begin
          ReminderLine.TestField("Reminder No.");
          ReminderHeader.Get(ReminderLine."Reminder No.");
          ExtTextHeader.SetRange("Table Name",ReminderLine.Type);
          ExtTextHeader.SetRange("No.",ReminderLine."No.");
          ExtTextHeader.SetRange(Reminder,true);
          exit(ReadLines(ExtTextHeader,ReminderHeader."Document Date",ReminderHeader."Language Code"));
        end;
    end;


    procedure FinChrgMemoCheckIfAnyExtText(var FinChrgMemoLine: Record "Finance Charge Memo Line";Unconditionally: Boolean): Boolean
    var
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(FinChrgMemoLine."Line No.",FinChrgMemoLine."No.",FinChrgMemoLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteFinChrgMemoLines(FinChrgMemoLine);

        if Unconditionally then
          AutoText := true
        else
          case FinChrgMemoLine.Type of
            FinChrgMemoLine.Type::" ":
              AutoText := true;
            FinChrgMemoLine.Type::"G/L Account":
              if GLAcc.Get(FinChrgMemoLine."No.") then
                AutoText := GLAcc."Automatic Ext. Texts";
          end;

        if AutoText then begin
          FinChrgMemoLine.TestField("Finance Charge Memo No.");
          FinChrgMemoHeader.Get(FinChrgMemoLine."Finance Charge Memo No.");
          ExtTextHeader.SetRange("Table Name",FinChrgMemoLine.Type);
          ExtTextHeader.SetRange("No.",FinChrgMemoLine."No.");
          ExtTextHeader.SetRange("Finance Charge Memo",true);
          exit(ReadLines(ExtTextHeader,FinChrgMemoHeader."Document Date",FinChrgMemoHeader."Language Code"));
        end;
    end;


    procedure PurchCheckIfAnyExtText(var PurchLine: Record "Purchase Line";Unconditionally: Boolean): Boolean
    var
        PurchHeader: Record "Purchase Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(PurchLine."Line No.",PurchLine."No.",PurchLine."Attached to Line No.") then
          MakeUpdateRequired := DeletePurchLines(PurchLine);

        AutoText := false;

        if Unconditionally then
          AutoText := true
        else
          case PurchLine.Type of
            PurchLine.Type::" ":
              AutoText := true;
            PurchLine.Type::"G/L Account":
              begin
                if GLAcc.Get(PurchLine."No.") then
                  AutoText := GLAcc."Automatic Ext. Texts";
              end;
            PurchLine.Type::Item:
              begin
                if Item.Get(PurchLine."No.") then
                  AutoText := Item."Automatic Ext. Texts";
              end;
          end;

        if AutoText then begin
          PurchLine.TestField("Document No.");
          PurchHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
          ExtTextHeader.SetRange("Table Name",PurchLine.Type);
          ExtTextHeader.SetRange("No.",PurchLine."No.");
          case PurchLine."Document Type" of
            PurchLine."document type"::Quote:
              ExtTextHeader.SetRange("Purchase Quote",true);
            PurchLine."document type"::"Blanket Order":
              ExtTextHeader.SetRange("Purchase Blanket Order",true);
            PurchLine."document type"::Order:
              ExtTextHeader.SetRange("Purchase Order",true);
            PurchLine."document type"::Invoice:
              ExtTextHeader.SetRange("Purchase Invoice",true);
            PurchLine."document type"::"Return Order":
              ExtTextHeader.SetRange("Purchase Return Order",true);
            PurchLine."document type"::"Credit Memo":
              ExtTextHeader.SetRange("Purchase Credit Memo",true);
          end;
          exit(ReadLines(ExtTextHeader,PurchHeader."Document Date",PurchHeader."Language Code"));
        end;
    end;


    procedure PrepmtGetAnyExtText(GLAccNo: Code[20];TabNo: Integer;DocumentDate: Date;LanguageCode: Code[10];var ExtTextLine: Record "Extended Text Line" temporary)
    var
        GLAcc: Record "G/L Account";
        ExtTextHeader: Record "Extended Text Header";
    begin
        ExtTextLine.DeleteAll;

        GLAcc.Get(GLAccNo);
        if not GLAcc."Automatic Ext. Texts" then
          exit;

        ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"G/L Account");
        ExtTextHeader.SetRange("No.",GLAccNo);
        case TabNo of
          Database::"Sales Invoice Line":
            ExtTextHeader.SetRange("Prepmt. Sales Invoice",true);
          Database::"Sales Cr.Memo Line":
            ExtTextHeader.SetRange("Prepmt. Sales Credit Memo",true);
          Database::"Purch. Inv. Line":
            ExtTextHeader.SetRange("Prepmt. Purchase Invoice",true);
          Database::"Purch. Cr. Memo Line":
            ExtTextHeader.SetRange("Prepmt. Purchase Credit Memo",true);
        end;
        if ReadLines(ExtTextHeader,DocumentDate,LanguageCode) then begin
          TmpExtTextLine.Find('-');
          repeat
            ExtTextLine := TmpExtTextLine;
            ExtTextLine.Insert;
          until TmpExtTextLine.Next = 0;
        end;
    end;


    procedure InsertSalesExtText(var SalesLine: Record "Sales Line")
    var
        ToSalesLine: Record "Sales Line";
    begin
        ToSalesLine.Reset;
        ToSalesLine.SetRange("Document Type",SalesLine."Document Type");
        ToSalesLine.SetRange("Document No.",SalesLine."Document No.");
        ToSalesLine := SalesLine;
        if ToSalesLine.Find('>') then begin
          LineSpacing :=
            (ToSalesLine."Line No." - SalesLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := SalesLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToSalesLine.Init;
            ToSalesLine."Document Type" := SalesLine."Document Type";
            ToSalesLine."Document No." := SalesLine."Document No.";
            ToSalesLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToSalesLine.Description := TmpExtTextLine.Text;
            ToSalesLine."Attached to Line No." := SalesLine."Line No.";
            ToSalesLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;


    procedure InsertReminderExtText(var ReminderLine: Record "Reminder Line")
    var
        ToReminderLine: Record "Reminder Line";
    begin
        Commit;
        ToReminderLine.Reset;
        ToReminderLine.SetRange("Reminder No.",ReminderLine."Reminder No.");
        ToReminderLine := ReminderLine;
        if ToReminderLine.Find('>') then begin
          LineSpacing :=
            (ToReminderLine."Line No." - ReminderLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := ReminderLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToReminderLine.Init;
            ToReminderLine."Reminder No." := ReminderLine."Reminder No.";
            ToReminderLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToReminderLine.Description := TmpExtTextLine.Text;
            ToReminderLine."Attached to Line No." := ReminderLine."Line No.";
            ToReminderLine."Line Type" := ReminderLine."Line Type";
            ToReminderLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;


    procedure InsertFinChrgMemoExtText(var FinChrgMemoLine: Record "Finance Charge Memo Line")
    var
        ToFinChrgMemoLine: Record "Finance Charge Memo Line";
    begin
        Commit;
        ToFinChrgMemoLine.Reset;
        ToFinChrgMemoLine.SetRange("Finance Charge Memo No.",FinChrgMemoLine."Finance Charge Memo No.");
        ToFinChrgMemoLine := FinChrgMemoLine;
        if ToFinChrgMemoLine.Find('>') then begin
          LineSpacing :=
            (ToFinChrgMemoLine."Line No." - FinChrgMemoLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := FinChrgMemoLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToFinChrgMemoLine.Init;
            ToFinChrgMemoLine."Finance Charge Memo No." := FinChrgMemoLine."Finance Charge Memo No.";
            ToFinChrgMemoLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToFinChrgMemoLine.Description := TmpExtTextLine.Text;
            ToFinChrgMemoLine."Attached to Line No." := FinChrgMemoLine."Line No.";
            ToFinChrgMemoLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;


    procedure InsertPurchExtText(var PurchLine: Record "Purchase Line")
    var
        ToPurchLine: Record "Purchase Line";
    begin
        Commit;
        ToPurchLine.Reset;
        ToPurchLine.SetRange("Document Type",PurchLine."Document Type");
        ToPurchLine.SetRange("Document No.",PurchLine."Document No.");
        ToPurchLine := PurchLine;
        if ToPurchLine.Find('>') then begin
          LineSpacing :=
            (ToPurchLine."Line No." - PurchLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := PurchLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToPurchLine.Init;
            ToPurchLine."Document Type" := PurchLine."Document Type";
            ToPurchLine."Document No." := PurchLine."Document No.";
            ToPurchLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToPurchLine.Description := TmpExtTextLine.Text;
            ToPurchLine."Attached to Line No." := PurchLine."Line No.";
            ToPurchLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;

    local procedure DeleteSalesLines(var SalesLine: Record "Sales Line"): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        SalesLine2.SetRange("Document Type",SalesLine."Document Type");
        SalesLine2.SetRange("Document No.",SalesLine."Document No.");
        SalesLine2.SetRange("Attached to Line No.",SalesLine."Line No.");
        SalesLine2 := SalesLine;
        if SalesLine2.Find('>') then begin
          repeat
            SalesLine2.Delete(true);
          until SalesLine2.Next = 0;
          exit(true);
        end;
    end;

    local procedure DeleteReminderLines(var ReminderLine: Record "Reminder Line"): Boolean
    var
        ReminderLine2: Record "Reminder Line";
    begin
        ReminderLine2.SetRange("Reminder No.",ReminderLine."Reminder No.");
        ReminderLine2.SetRange("Attached to Line No.",ReminderLine."Line No.");
        ReminderLine2 := ReminderLine;
        if ReminderLine2.Find('>') then begin
          repeat
            ReminderLine2.Delete;
          until ReminderLine2.Next = 0;
          exit(true);
        end;
    end;

    local procedure DeleteFinChrgMemoLines(var FinChrgMemoLine: Record "Finance Charge Memo Line"): Boolean
    var
        FinChrgMemoLine2: Record "Finance Charge Memo Line";
    begin
        FinChrgMemoLine2.SetRange("Finance Charge Memo No.",FinChrgMemoLine."Finance Charge Memo No.");
        FinChrgMemoLine2.SetRange("Attached to Line No.",FinChrgMemoLine."Line No.");
        FinChrgMemoLine2 := FinChrgMemoLine;
        if FinChrgMemoLine2.Find('>') then begin
          repeat
            FinChrgMemoLine2.Delete;
          until FinChrgMemoLine2.Next = 0;
          exit(true);
        end;
    end;

    local procedure DeletePurchLines(var PurchLine: Record "Purchase Line"): Boolean
    var
        PurchLine2: Record "Purchase Line";
    begin
        PurchLine2.SetRange("Document Type",PurchLine."Document Type");
        PurchLine2.SetRange("Document No.",PurchLine."Document No.");
        PurchLine2.SetRange("Attached to Line No.",PurchLine."Line No.");
        PurchLine2 := PurchLine;
        if PurchLine2.Find('>') then begin
          repeat
            PurchLine2.Delete(true);
          until PurchLine2.Next = 0;
          exit(true);
        end;
    end;


    procedure MakeUpdate(): Boolean
    begin
        exit(MakeUpdateRequired);
    end;

    local procedure ReadLines(var ExtTextHeader: Record "Extended Text Header";DocDate: Date;LanguageCode: Code[10]): Boolean
    var
        ExtTextLine: Record "Extended Text Line";
    begin
        ExtTextHeader.SetCurrentkey(
          "Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
        ExtTextHeader.SetRange("Starting Date",0D,DocDate);
        ExtTextHeader.SetFilter("Ending Date",'%1..|%2',DocDate,0D);
        if LanguageCode = '' then begin
          ExtTextHeader.SetRange("Language Code",'');
          if not ExtTextHeader.Find('+') then
            exit;
        end else begin
          ExtTextHeader.SetRange("Language Code",LanguageCode);
          if not ExtTextHeader.Find('+') then begin
            ExtTextHeader.SetRange("All Language Codes",true);
            ExtTextHeader.SetRange("Language Code",'');
            if not ExtTextHeader.Find('+') then
              exit;
          end;
        end;

        ExtTextLine.SetRange("Table Name",ExtTextHeader."Table Name");
        ExtTextLine.SetRange("No.",ExtTextHeader."No.");
        ExtTextLine.SetRange("Language Code",ExtTextHeader."Language Code");
        ExtTextLine.SetRange("Text No.",ExtTextHeader."Text No.");
        if ExtTextLine.Find('-') then begin
          TmpExtTextLine.DeleteAll;
          repeat
            TmpExtTextLine := ExtTextLine;
            TmpExtTextLine.Insert;
          until ExtTextLine.Next = 0;
          exit(true);
        end;
    end;


    procedure ServCheckIfAnyExtText(var ServiceLine: Record "Service Line";Unconditionally: Boolean): Boolean
    var
        ServHeader: Record "Service Header";
        ExtTextHeader: Record "Extended Text Header";
        ServCost: Record "Service Cost";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(ServiceLine."Line No.",ServiceLine."No.",ServiceLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteServiceLines(ServiceLine);

        AutoText := false;
        if Unconditionally then
          AutoText := true
        else
          case ServiceLine.Type of
            ServiceLine.Type::" ":
              AutoText := true;
            ServiceLine.Type::Cost:
              begin
                if ServCost.Get(ServiceLine."No.") then
                  if GLAcc.Get(ServCost."Account No.") then
                    AutoText := GLAcc."Automatic Ext. Texts";
              end;
            ServiceLine.Type::Item:
              begin
                if Item.Get(ServiceLine."No.") then
                  AutoText := Item."Automatic Ext. Texts";
              end;
            ServiceLine.Type::Resource:
              begin
                if Res.Get(ServiceLine."No.") then
                  AutoText := Res."Automatic Ext. Texts";
              end;
            ServiceLine.Type::"G/L Account":
              begin
                if GLAcc.Get(ServiceLine."No.") then
                  AutoText := GLAcc."Automatic Ext. Texts";
              end;
          end;
        if AutoText then begin
          case ServiceLine.Type of
            ServiceLine.Type::" ":
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"Standard Text");
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
            ServiceLine.Type::Item:
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::Item);
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
            ServiceLine.Type::Resource:
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::Resource);
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
            ServiceLine.Type::Cost:
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"G/L Account");
                ServCost.Get(ServiceLine."No.");
                ExtTextHeader.SetRange("No.",ServCost."Account No.");
              end;
            ServiceLine.Type::"G/L Account":
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"G/L Account");
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
          end;

          case ServiceLine."Document Type" of
            ServiceLine."document type"::Quote:
              ExtTextHeader.SetRange("Service Quote",true);
            ServiceLine."document type"::Order:
              ExtTextHeader.SetRange("Service Order",true);
            ServiceLine."document type"::Invoice:
              ExtTextHeader.SetRange("Service Invoice",true);
            ServiceLine."document type"::"Credit Memo":
              ExtTextHeader.SetRange("Service Credit Memo",true);
          end;

          ServHeader.Get(ServiceLine."Document Type",ServiceLine."Document No.");
          exit(ReadLines(ExtTextHeader,ServHeader."Order Date",ServHeader."Language Code"));
        end;
    end;

    local procedure DeleteServiceLines(var ServiceLine: Record "Service Line"): Boolean
    var
        ServiceLine2: Record "Service Line";
    begin
        ServiceLine2.SetRange("Document Type",ServiceLine."Document Type");
        ServiceLine2.SetRange("Document No.",ServiceLine."Document No.");
        ServiceLine2.SetRange("Attached to Line No.",ServiceLine."Line No.");
        ServiceLine2 := ServiceLine;
        if ServiceLine2.Find('>') then begin
          repeat
            ServiceLine2.Delete;
          until ServiceLine2.Next = 0;
          exit(true);
        end;
    end;


    procedure InsertServExtText(var ServiceLine: Record "Service Line")
    var
        ToServiceLine: Record "Service Line";
    begin
        Commit;
        ToServiceLine.Reset;
        ToServiceLine.SetRange("Document Type",ServiceLine."Document Type");
        ToServiceLine.SetRange("Document No.",ServiceLine."Document No.");
        ToServiceLine := ServiceLine;
        if ToServiceLine.Find('>') then begin
          LineSpacing :=
            (ToServiceLine."Line No." - ServiceLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := ServiceLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToServiceLine.Init;
            ToServiceLine."Document Type" := ServiceLine."Document Type";
            ToServiceLine."Document No." := ServiceLine."Document No.";
            ToServiceLine."Service Item Line No." := ServiceLine."Service Item Line No.";
            ToServiceLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToServiceLine.Description := TmpExtTextLine.Text;
            ToServiceLine."Attached to Line No." := ServiceLine."Line No.";
            ToServiceLine."Service Item No." := ServiceLine."Service Item No.";
            ToServiceLine.Insert(true);
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;

    local procedure IsDeleteAttachedLines(LineNo: Integer;No: Code[20];AttachedToLineNo: Integer): Boolean
    begin
        exit((LineNo <> 0) and (AttachedToLineNo = 0) and (No <> ''));
    end;

    local procedure xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx()
    begin
    end;


    procedure SalesCheckIfAnyExtText2(var SalesLine: Record UnknownRecord60312;Unconditionally: Boolean): Boolean
    var
        SalesHeader: Record UnknownRecord60301;
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(SalesLine."Line No.",SalesLine."No.",SalesLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteSalesLines2(SalesLine);

        AutoText := false;

        if Unconditionally then
          AutoText := true
        else
          case SalesLine.Type of
            SalesLine.Type::" ":
              AutoText := true;
            SalesLine.Type::"G/L Account":
              begin
                if GLAcc.Get(SalesLine."No.") then
                  AutoText := GLAcc."Automatic Ext. Texts";
              end;
            SalesLine.Type::Item:
              begin
                if Item.Get(SalesLine."No.") then
                  AutoText := Item."Automatic Ext. Texts";
              end;
            SalesLine.Type::Resource:
              begin
                if Res.Get(SalesLine."No.") then
                  AutoText := Res."Automatic Ext. Texts";
              end;
          end;

        if AutoText then begin
          SalesLine.TestField("Document No.");
          SalesHeader.Get(SalesLine."Document Type",SalesLine."Document No.");
          ExtTextHeader.SetRange("Table Name",SalesLine.Type);
          ExtTextHeader.SetRange("No.",SalesLine."No.");
          case SalesLine."Document Type" of
            SalesLine."document type"::Quote:
              ExtTextHeader.SetRange("Sales Quote",true);
            SalesLine."document type"::"Blanket Order":
              ExtTextHeader.SetRange("Sales Blanket Order",true);
            SalesLine."document type"::Order:
              ExtTextHeader.SetRange("Sales Order",true);
            SalesLine."document type"::Invoice:
              ExtTextHeader.SetRange("Sales Invoice",true);
            SalesLine."document type"::"Return Order":
              ExtTextHeader.SetRange("Sales Return Order",true);
            SalesLine."document type"::"Credit Memo":
              ExtTextHeader.SetRange("Sales Credit Memo",true);
          end;
          exit(ReadLines(ExtTextHeader,SalesHeader."Document Date",SalesHeader."Language Code"));
        end;
    end;


    procedure ReminderCheckIfAnyExtText2(var ReminderLine: Record "Reminder Line";Unconditionally: Boolean): Boolean
    var
        ReminderHeader: Record "Reminder Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(ReminderLine."Line No.",ReminderLine."No.",ReminderLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteReminderLines(ReminderLine);

        if Unconditionally then
          AutoText := true
        else
          case ReminderLine.Type of
            ReminderLine.Type::" ":
              AutoText := true;
            ReminderLine.Type::"G/L Account":
              if GLAcc.Get(ReminderLine."No.") then
                AutoText := GLAcc."Automatic Ext. Texts";
          end;

        if AutoText then begin
          ReminderLine.TestField("Reminder No.");
          ReminderHeader.Get(ReminderLine."Reminder No.");
          ExtTextHeader.SetRange("Table Name",ReminderLine.Type);
          ExtTextHeader.SetRange("No.",ReminderLine."No.");
          ExtTextHeader.SetRange(Reminder,true);
          exit(ReadLines(ExtTextHeader,ReminderHeader."Document Date",ReminderHeader."Language Code"));
        end;
    end;


    procedure FinChrgMemoCheckIfAnyExtText2(var FinChrgMemoLine: Record "Finance Charge Memo Line";Unconditionally: Boolean): Boolean
    var
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(FinChrgMemoLine."Line No.",FinChrgMemoLine."No.",FinChrgMemoLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteFinChrgMemoLines(FinChrgMemoLine);

        if Unconditionally then
          AutoText := true
        else
          case FinChrgMemoLine.Type of
            FinChrgMemoLine.Type::" ":
              AutoText := true;
            FinChrgMemoLine.Type::"G/L Account":
              if GLAcc.Get(FinChrgMemoLine."No.") then
                AutoText := GLAcc."Automatic Ext. Texts";
          end;

        if AutoText then begin
          FinChrgMemoLine.TestField("Finance Charge Memo No.");
          FinChrgMemoHeader.Get(FinChrgMemoLine."Finance Charge Memo No.");
          ExtTextHeader.SetRange("Table Name",FinChrgMemoLine.Type);
          ExtTextHeader.SetRange("No.",FinChrgMemoLine."No.");
          ExtTextHeader.SetRange("Finance Charge Memo",true);
          exit(ReadLines(ExtTextHeader,FinChrgMemoHeader."Document Date",FinChrgMemoHeader."Language Code"));
        end;
    end;


    procedure PurchCheckIfAnyExtText2(var PurchLine: Record "Purchase Line";Unconditionally: Boolean): Boolean
    var
        PurchHeader: Record "Purchase Header";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(PurchLine."Line No.",PurchLine."No.",PurchLine."Attached to Line No.") then
          MakeUpdateRequired := DeletePurchLines(PurchLine);

        AutoText := false;

        if Unconditionally then
          AutoText := true
        else
          case PurchLine.Type of
            PurchLine.Type::" ":
              AutoText := true;
            PurchLine.Type::"G/L Account":
              begin
                if GLAcc.Get(PurchLine."No.") then
                  AutoText := GLAcc."Automatic Ext. Texts";
              end;
            PurchLine.Type::Item:
              begin
                if Item.Get(PurchLine."No.") then
                  AutoText := Item."Automatic Ext. Texts";
              end;
          end;

        if AutoText then begin
          PurchLine.TestField("Document No.");
          PurchHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
          ExtTextHeader.SetRange("Table Name",PurchLine.Type);
          ExtTextHeader.SetRange("No.",PurchLine."No.");
          case PurchLine."Document Type" of
            PurchLine."document type"::Quote:
              ExtTextHeader.SetRange("Purchase Quote",true);
            PurchLine."document type"::"Blanket Order":
              ExtTextHeader.SetRange("Purchase Blanket Order",true);
            PurchLine."document type"::Order:
              ExtTextHeader.SetRange("Purchase Order",true);
            PurchLine."document type"::Invoice:
              ExtTextHeader.SetRange("Purchase Invoice",true);
            PurchLine."document type"::"Return Order":
              ExtTextHeader.SetRange("Purchase Return Order",true);
            PurchLine."document type"::"Credit Memo":
              ExtTextHeader.SetRange("Purchase Credit Memo",true);
          end;
          exit(ReadLines(ExtTextHeader,PurchHeader."Document Date",PurchHeader."Language Code"));
        end;
    end;


    procedure PrepmtGetAnyExtText2(GLAccNo: Code[20];TabNo: Integer;DocumentDate: Date;LanguageCode: Code[10];var ExtTextLine: Record "Extended Text Line" temporary)
    var
        GLAcc: Record "G/L Account";
        ExtTextHeader: Record "Extended Text Header";
    begin
        ExtTextLine.DeleteAll;

        GLAcc.Get(GLAccNo);
        if not GLAcc."Automatic Ext. Texts" then
          exit;

        ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"G/L Account");
        ExtTextHeader.SetRange("No.",GLAccNo);
        case TabNo of
          Database::"Sales Invoice Line":
            ExtTextHeader.SetRange("Prepmt. Sales Invoice",true);
          Database::"Sales Cr.Memo Line":
            ExtTextHeader.SetRange("Prepmt. Sales Credit Memo",true);
          Database::"Purch. Inv. Line":
            ExtTextHeader.SetRange("Prepmt. Purchase Invoice",true);
          Database::"Purch. Cr. Memo Line":
            ExtTextHeader.SetRange("Prepmt. Purchase Credit Memo",true);
        end;
        if ReadLines(ExtTextHeader,DocumentDate,LanguageCode) then begin
          TmpExtTextLine.Find('-');
          repeat
            ExtTextLine := TmpExtTextLine;
            ExtTextLine.Insert;
          until TmpExtTextLine.Next = 0;
        end;
    end;


    procedure InsertSalesExtText2(var SalesLine: Record UnknownRecord60312)
    var
        ToSalesLine: Record UnknownRecord60312;
    begin
        ToSalesLine.Reset;
        ToSalesLine.SetRange("Document Type",SalesLine."Document Type");
        ToSalesLine.SetRange("Document No.",SalesLine."Document No.");
        ToSalesLine := SalesLine;
        if ToSalesLine.Find('>') then begin
          LineSpacing :=
            (ToSalesLine."Line No." - SalesLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := SalesLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToSalesLine.Init;
            ToSalesLine."Document Type" := SalesLine."Document Type";
            ToSalesLine."Document No." := SalesLine."Document No.";
            ToSalesLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToSalesLine.Description := TmpExtTextLine.Text;
            ToSalesLine."Attached to Line No." := SalesLine."Line No.";
            ToSalesLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;


    procedure InsertReminderExtText2(var ReminderLine: Record "Reminder Line")
    var
        ToReminderLine: Record "Reminder Line";
    begin
        Commit;
        ToReminderLine.Reset;
        ToReminderLine.SetRange("Reminder No.",ReminderLine."Reminder No.");
        ToReminderLine := ReminderLine;
        if ToReminderLine.Find('>') then begin
          LineSpacing :=
            (ToReminderLine."Line No." - ReminderLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := ReminderLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToReminderLine.Init;
            ToReminderLine."Reminder No." := ReminderLine."Reminder No.";
            ToReminderLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToReminderLine.Description := TmpExtTextLine.Text;
            ToReminderLine."Attached to Line No." := ReminderLine."Line No.";
            ToReminderLine."Line Type" := ReminderLine."Line Type";
            ToReminderLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;


    procedure InsertFinChrgMemoExtText2(var FinChrgMemoLine: Record "Finance Charge Memo Line")
    var
        ToFinChrgMemoLine: Record "Finance Charge Memo Line";
    begin
        Commit;
        ToFinChrgMemoLine.Reset;
        ToFinChrgMemoLine.SetRange("Finance Charge Memo No.",FinChrgMemoLine."Finance Charge Memo No.");
        ToFinChrgMemoLine := FinChrgMemoLine;
        if ToFinChrgMemoLine.Find('>') then begin
          LineSpacing :=
            (ToFinChrgMemoLine."Line No." - FinChrgMemoLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := FinChrgMemoLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToFinChrgMemoLine.Init;
            ToFinChrgMemoLine."Finance Charge Memo No." := FinChrgMemoLine."Finance Charge Memo No.";
            ToFinChrgMemoLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToFinChrgMemoLine.Description := TmpExtTextLine.Text;
            ToFinChrgMemoLine."Attached to Line No." := FinChrgMemoLine."Line No.";
            ToFinChrgMemoLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;


    procedure InsertPurchExtText2(var PurchLine: Record "Purchase Line")
    var
        ToPurchLine: Record "Purchase Line";
    begin
        Commit;
        ToPurchLine.Reset;
        ToPurchLine.SetRange("Document Type",PurchLine."Document Type");
        ToPurchLine.SetRange("Document No.",PurchLine."Document No.");
        ToPurchLine := PurchLine;
        if ToPurchLine.Find('>') then begin
          LineSpacing :=
            (ToPurchLine."Line No." - PurchLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := PurchLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToPurchLine.Init;
            ToPurchLine."Document Type" := PurchLine."Document Type";
            ToPurchLine."Document No." := PurchLine."Document No.";
            ToPurchLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToPurchLine.Description := TmpExtTextLine.Text;
            ToPurchLine."Attached to Line No." := PurchLine."Line No.";
            ToPurchLine.Insert;
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;

    local procedure DeleteSalesLines2(var SalesLine: Record UnknownRecord60312): Boolean
    var
        SalesLine2: Record UnknownRecord60312;
    begin
        SalesLine2.SetRange("Document Type",SalesLine."Document Type");
        SalesLine2.SetRange("Document No.",SalesLine."Document No.");
        SalesLine2.SetRange("Attached to Line No.",SalesLine."Line No.");
        SalesLine2 := SalesLine;
        if SalesLine2.Find('>') then begin
          repeat
            SalesLine2.Delete(true);
          until SalesLine2.Next = 0;
          exit(true);
        end;
    end;

    local procedure DeleteReminderLines2(var ReminderLine: Record "Reminder Line"): Boolean
    var
        ReminderLine2: Record "Reminder Line";
    begin
        ReminderLine2.SetRange("Reminder No.",ReminderLine."Reminder No.");
        ReminderLine2.SetRange("Attached to Line No.",ReminderLine."Line No.");
        ReminderLine2 := ReminderLine;
        if ReminderLine2.Find('>') then begin
          repeat
            ReminderLine2.Delete;
          until ReminderLine2.Next = 0;
          exit(true);
        end;
    end;

    local procedure DeleteFinChrgMemoLines2(var FinChrgMemoLine: Record "Finance Charge Memo Line"): Boolean
    var
        FinChrgMemoLine2: Record "Finance Charge Memo Line";
    begin
        FinChrgMemoLine2.SetRange("Finance Charge Memo No.",FinChrgMemoLine."Finance Charge Memo No.");
        FinChrgMemoLine2.SetRange("Attached to Line No.",FinChrgMemoLine."Line No.");
        FinChrgMemoLine2 := FinChrgMemoLine;
        if FinChrgMemoLine2.Find('>') then begin
          repeat
            FinChrgMemoLine2.Delete;
          until FinChrgMemoLine2.Next = 0;
          exit(true);
        end;
    end;

    local procedure DeletePurchLines2(var PurchLine: Record "Purchase Line"): Boolean
    var
        PurchLine2: Record "Purchase Line";
    begin
        PurchLine2.SetRange("Document Type",PurchLine."Document Type");
        PurchLine2.SetRange("Document No.",PurchLine."Document No.");
        PurchLine2.SetRange("Attached to Line No.",PurchLine."Line No.");
        PurchLine2 := PurchLine;
        if PurchLine2.Find('>') then begin
          repeat
            PurchLine2.Delete(true);
          until PurchLine2.Next = 0;
          exit(true);
        end;
    end;


    procedure MakeUpdate2(): Boolean
    begin
        exit(MakeUpdateRequired);
    end;

    local procedure ReadLines2(var ExtTextHeader: Record "Extended Text Header";DocDate: Date;LanguageCode: Code[10]): Boolean
    var
        ExtTextLine: Record "Extended Text Line";
    begin
        ExtTextHeader.SetCurrentkey(
          "Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
        ExtTextHeader.SetRange("Starting Date",0D,DocDate);
        ExtTextHeader.SetFilter("Ending Date",'%1..|%2',DocDate,0D);
        if LanguageCode = '' then begin
          ExtTextHeader.SetRange("Language Code",'');
          if not ExtTextHeader.Find('+') then
            exit;
        end else begin
          ExtTextHeader.SetRange("Language Code",LanguageCode);
          if not ExtTextHeader.Find('+') then begin
            ExtTextHeader.SetRange("All Language Codes",true);
            ExtTextHeader.SetRange("Language Code",'');
            if not ExtTextHeader.Find('+') then
              exit;
          end;
        end;

        ExtTextLine.SetRange("Table Name",ExtTextHeader."Table Name");
        ExtTextLine.SetRange("No.",ExtTextHeader."No.");
        ExtTextLine.SetRange("Language Code",ExtTextHeader."Language Code");
        ExtTextLine.SetRange("Text No.",ExtTextHeader."Text No.");
        if ExtTextLine.Find('-') then begin
          TmpExtTextLine.DeleteAll;
          repeat
            TmpExtTextLine := ExtTextLine;
            TmpExtTextLine.Insert;
          until ExtTextLine.Next = 0;
          exit(true);
        end;
    end;


    procedure ServCheckIfAnyExtText2(var ServiceLine: Record "Service Line";Unconditionally: Boolean): Boolean
    var
        ServHeader: Record "Service Header";
        ExtTextHeader: Record "Extended Text Header";
        ServCost: Record "Service Cost";
    begin
        MakeUpdateRequired := false;
        if IsDeleteAttachedLines(ServiceLine."Line No.",ServiceLine."No.",ServiceLine."Attached to Line No.") then
          MakeUpdateRequired := DeleteServiceLines(ServiceLine);

        AutoText := false;
        if Unconditionally then
          AutoText := true
        else
          case ServiceLine.Type of
            ServiceLine.Type::" ":
              AutoText := true;
            ServiceLine.Type::Cost:
              begin
                if ServCost.Get(ServiceLine."No.") then
                  if GLAcc.Get(ServCost."Account No.") then
                    AutoText := GLAcc."Automatic Ext. Texts";
              end;
            ServiceLine.Type::Item:
              begin
                if Item.Get(ServiceLine."No.") then
                  AutoText := Item."Automatic Ext. Texts";
              end;
            ServiceLine.Type::Resource:
              begin
                if Res.Get(ServiceLine."No.") then
                  AutoText := Res."Automatic Ext. Texts";
              end;
            ServiceLine.Type::"G/L Account":
              begin
                if GLAcc.Get(ServiceLine."No.") then
                  AutoText := GLAcc."Automatic Ext. Texts";
              end;
          end;
        if AutoText then begin
          case ServiceLine.Type of
            ServiceLine.Type::" ":
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"Standard Text");
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
            ServiceLine.Type::Item:
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::Item);
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
            ServiceLine.Type::Resource:
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::Resource);
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
            ServiceLine.Type::Cost:
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"G/L Account");
                ServCost.Get(ServiceLine."No.");
                ExtTextHeader.SetRange("No.",ServCost."Account No.");
              end;
            ServiceLine.Type::"G/L Account":
              begin
                ExtTextHeader.SetRange("Table Name",ExtTextHeader."table name"::"G/L Account");
                ExtTextHeader.SetRange("No.",ServiceLine."No.");
              end;
          end;

          case ServiceLine."Document Type" of
            ServiceLine."document type"::Quote:
              ExtTextHeader.SetRange("Service Quote",true);
            ServiceLine."document type"::Order:
              ExtTextHeader.SetRange("Service Order",true);
            ServiceLine."document type"::Invoice:
              ExtTextHeader.SetRange("Service Invoice",true);
            ServiceLine."document type"::"Credit Memo":
              ExtTextHeader.SetRange("Service Credit Memo",true);
          end;

          ServHeader.Get(ServiceLine."Document Type",ServiceLine."Document No.");
          exit(ReadLines(ExtTextHeader,ServHeader."Order Date",ServHeader."Language Code"));
        end;
    end;

    local procedure DeleteServiceLines2(var ServiceLine: Record "Service Line"): Boolean
    var
        ServiceLine2: Record "Service Line";
    begin
        ServiceLine2.SetRange("Document Type",ServiceLine."Document Type");
        ServiceLine2.SetRange("Document No.",ServiceLine."Document No.");
        ServiceLine2.SetRange("Attached to Line No.",ServiceLine."Line No.");
        ServiceLine2 := ServiceLine;
        if ServiceLine2.Find('>') then begin
          repeat
            ServiceLine2.Delete;
          until ServiceLine2.Next = 0;
          exit(true);
        end;
    end;


    procedure InsertServExtText2(var ServiceLine: Record "Service Line")
    var
        ToServiceLine: Record "Service Line";
    begin
        Commit;
        ToServiceLine.Reset;
        ToServiceLine.SetRange("Document Type",ServiceLine."Document Type");
        ToServiceLine.SetRange("Document No.",ServiceLine."Document No.");
        ToServiceLine := ServiceLine;
        if ToServiceLine.Find('>') then begin
          LineSpacing :=
            (ToServiceLine."Line No." - ServiceLine."Line No.") DIV
            (1 + TmpExtTextLine.Count);
          if LineSpacing = 0 then
            Error(Text000);
        end else
          LineSpacing := 10000;

        NextLineNo := ServiceLine."Line No." + LineSpacing;

        TmpExtTextLine.Reset;
        if TmpExtTextLine.Find('-') then begin
          repeat
            ToServiceLine.Init;
            ToServiceLine."Document Type" := ServiceLine."Document Type";
            ToServiceLine."Document No." := ServiceLine."Document No.";
            ToServiceLine."Service Item Line No." := ServiceLine."Service Item Line No.";
            ToServiceLine."Line No." := NextLineNo;
            NextLineNo := NextLineNo + LineSpacing;
            ToServiceLine.Description := TmpExtTextLine.Text;
            ToServiceLine."Attached to Line No." := ServiceLine."Line No.";
            ToServiceLine."Service Item No." := ServiceLine."Service Item No.";
            ToServiceLine.Insert(true);
          until TmpExtTextLine.Next = 0;
          MakeUpdateRequired := true;
        end;
        TmpExtTextLine.DeleteAll;
    end;

    local procedure IsDeleteAttachedLines2(LineNo: Integer;No: Code[20];AttachedToLineNo: Integer): Boolean
    begin
        exit((LineNo <> 0) and (AttachedToLineNo = 0) and (No <> ''));
    end;
}

