#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5051 SegManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label '%1 for Segment No. %2 already exists.';
        Text001: label 'Segment %1 is empty.';
        Text002: label 'Follow-up on segment %1';
        InteractionTmplSetup: Record "Interaction Template Setup";
        Text003: label 'Interaction Template %1 has assigned Interaction Template Language %2.\It is not allowed to have languages assigned to templates used for system document logging.';
        Text004: label 'Interactions';


    procedure LogSegment(SegHeader: Record "Segment Header";Deliver: Boolean;Followup: Boolean)
    var
        SegLine: Record "Segment Line";
        LoggedSeg: Record "Logged Segment";
        InteractLogEntry: Record "Interaction Log Entry";
        CampaignEntry: Record "Campaign Entry";
        Attachment: Record Attachment;
        InteractTemplate: Record "Interaction Template";
        DeliverySorterTemp: Record "Delivery Sorter" temporary;
        AttachmentManagement: Codeunit AttachmentManagement;
        SegmentNo: Code[20];
        CampaignNo: Code[20];
        NextRegisterNo: Integer;
        NextCampaignEntryNo: Integer;
        NextInteractLogEntryNo: Integer;
    begin
        LoggedSeg.LockTable;
        LoggedSeg.SetCurrentkey("Segment No.");
        LoggedSeg.SetRange("Segment No.",SegHeader."No.");
        if not LoggedSeg.IsEmpty then
          Error(Text000,LoggedSeg.TableCaption,SegHeader."No.");

        SegHeader.TestField(Description);

        LoggedSeg.Reset;
        if LoggedSeg.FindLast then
          NextRegisterNo := LoggedSeg."Entry No." + 1
        else
          NextRegisterNo := 1;

        LoggedSeg.Init;
        LoggedSeg."Entry No." := NextRegisterNo;
        LoggedSeg."Segment No." := SegHeader."No.";
        LoggedSeg.Description := SegHeader.Description;
        LoggedSeg."Creation Date" := Today;
        LoggedSeg."User ID" := UserId;
        LoggedSeg.Insert;

        SegLine.LockTable;
        SegLine.SetCurrentkey("Segment No.","Campaign No.",Date);
        SegLine.SetRange("Segment No.",SegHeader."No.");
        SegLine.SetFilter("Campaign No.",'<>%1','');
        SegLine.SetFilter("Contact No.",'<>%1','');
        if SegLine.FindSet then begin
          CampaignEntry.LockTable;
          repeat
            CampaignEntry.SetCurrentkey("Campaign No.",Date,"Document Type");
            CampaignEntry.SetRange("Document Type",SegLine."Document Type");
            CampaignEntry.SetRange("Campaign No.",SegLine."Campaign No.");
            CampaignEntry.SetFilter("Segment No.",'=%1',SegLine."Segment No.");
            if CampaignEntry.FindFirst then begin
              SegLine."Campaign Entry No." := CampaignEntry."Entry No.";
              SegLine.Modify;
            end else begin
              CampaignEntry.Reset;
              if CampaignEntry.FindLast then
                NextCampaignEntryNo := CampaignEntry."Entry No." + 1
              else
                NextCampaignEntryNo := 1;
              CampaignEntry.Init;
              CampaignEntry."Entry No." := NextCampaignEntryNo;
              CampaignEntry."Register No." := LoggedSeg."Entry No.";
              CopyFieldsToCampaignEntry(CampaignEntry,SegLine);
              CampaignEntry.Insert;
              SegLine."Campaign Entry No." := CampaignEntry."Entry No.";
              SegLine.Modify;
            end;
          until SegLine.Next = 0;
        end;

        SegLine.Reset;
        SegLine.SetRange("Segment No.",SegHeader."No.");
        SegLine.SetFilter("Contact No.",'<>%1','');

        if SegLine.FindSet then begin
          if InteractTemplate.Get(SegHeader."Interaction Template Code") then;
          InteractLogEntry.LockTable;
          if InteractLogEntry.FindLast then
            NextInteractLogEntryNo := InteractLogEntry."Entry No.";
          repeat
            NextInteractLogEntryNo := NextInteractLogEntryNo + 1;
            TestFields(SegLine);
            InteractLogEntry.Init;
            InteractLogEntry."Entry No." := NextInteractLogEntryNo;
            InteractLogEntry."Logged Segment Entry No." := LoggedSeg."Entry No.";
            CopyFieldsToInteractLogEntry(InteractLogEntry,SegLine);
            if Deliver and ((SegLine."Correspondence Type" <> 0) or (InteractTemplate."Correspondence Type (Default)" <> 0)) then begin
              InteractLogEntry."Delivery Status" := InteractLogEntry."delivery status"::"In Progress";
              SegLine.TestField("Attachment No.");
              DeliverySorterTemp."No." := InteractLogEntry."Entry No.";
              DeliverySorterTemp."Attachment No." := InteractLogEntry."Attachment No.";
              DeliverySorterTemp."Correspondence Type" := InteractLogEntry."Correspondence Type";
              DeliverySorterTemp.Subject := InteractLogEntry.Subject;
              DeliverySorterTemp."Send Word Docs. as Attmt." := InteractLogEntry."Send Word Docs. as Attmt.";
              DeliverySorterTemp."Language Code" := SegLine."Language Code";
              DeliverySorterTemp.Insert;
            end;
            InteractLogEntry.Insert;
            Attachment.LockTable;
            if Attachment.Get(SegLine."Attachment No.") and (not Attachment."Read Only") then begin
              Attachment."Read Only" := true;
              Attachment.Modify(true);
            end;
          until SegLine.Next = 0;
        end else
          Error(Text001,SegHeader."No.");

        SegmentNo := SegHeader."No.";
        CampaignNo := SegHeader."Campaign No.";
        SegHeader.Delete(true);

        if Followup then begin
          Clear(SegHeader);
          SegHeader."Campaign No." := CampaignNo;
          SegHeader.Description := CopyStr(StrSubstNo(Text002,SegmentNo),1,50);
          SegHeader.Insert(true);
          SegHeader.ReuseLogged(LoggedSeg."Entry No.");
        end;

        if Deliver then
          AttachmentManagement.Send(DeliverySorterTemp);
    end;


    procedure LogInteraction(SegLine: Record "Segment Line";var AttachmentTemp: Record Attachment;var InterLogEntryCommentLineTmp: Record "Inter. Log Entry Comment Line";Deliver: Boolean;Postponed: Boolean) NextInteractLogEntryNo: Integer
    var
        CampaignEntry: Record "Campaign Entry";
        InteractLogEntry: Record "Interaction Log Entry";
        Attachment: Record Attachment;
        MarketingSetup: Record "Marketing Setup";
        DeliverySorterTemp: Record "Delivery Sorter" temporary;
        InterLogEntryCommentLine: Record "Inter. Log Entry Comment Line";
        AttachmentManagement: Codeunit AttachmentManagement;
        NextCampaignEntryNo: Integer;
        FileName: Text;
    begin
        if not Postponed then
          TestFields(SegLine);
        if (SegLine."Campaign No." <> '') and (not Postponed) then begin
          CampaignEntry.LockTable;
          CampaignEntry.SetCurrentkey("Campaign No.",Date,"Document Type");
          CampaignEntry.SetRange("Document Type",SegLine."Document Type");
          CampaignEntry.SetRange("Campaign No.",SegLine."Campaign No.");
          CampaignEntry.SetRange("Segment No.",SegLine."Segment No.");
          if CampaignEntry.FindFirst then
            SegLine."Campaign Entry No." := CampaignEntry."Entry No."
          else begin
            CampaignEntry.Reset;
            if CampaignEntry.FindLast then
              NextCampaignEntryNo := CampaignEntry."Entry No." + 1
            else
              NextCampaignEntryNo := 1;
            CampaignEntry.Init;
            CampaignEntry."Entry No." := NextCampaignEntryNo;
            CopyFieldsToCampaignEntry(CampaignEntry,SegLine);
            CampaignEntry.Insert;
            SegLine."Campaign Entry No." := CampaignEntry."Entry No.";
          end;
        end;

        if AttachmentTemp."Attachment File".Hasvalue then begin
          with Attachment do begin
            LockTable;
            if (SegLine."Line No." <> 0) and Get(SegLine."Attachment No.") then begin
              RemoveAttachment(false);
              AttachmentTemp."No." := SegLine."Attachment No.";
            end;

            Copy(AttachmentTemp);
            "Read Only" := true;
            WizSaveAttachment;
            Insert(true);
          end;

          MarketingSetup.Get;
          if MarketingSetup."Attachment Storage Type" = MarketingSetup."attachment storage type"::"Disk File" then
            if Attachment."No." <> 0 then begin
              FileName := Attachment.ConstDiskFileName;
              if FileName <> '' then
                AttachmentTemp.ExportAttachmentToServerFile(FileName);
            end;
          SegLine."Attachment No." := Attachment."No.";
        end;

        if SegLine."Line No." = 0 then begin
          InteractLogEntry.Reset;
          InteractLogEntry.LockTable;
          if InteractLogEntry.FindLast then
            NextInteractLogEntryNo := InteractLogEntry."Entry No." + 1
          else
            NextInteractLogEntryNo := 1;

          InteractLogEntry.Init;
          InteractLogEntry."Entry No." := NextInteractLogEntryNo;
          CopyFieldsToInteractLogEntry(InteractLogEntry,SegLine);
          InteractLogEntry.Postponed := Postponed;
          InteractLogEntry.Insert
        end else begin
          InteractLogEntry.Get(SegLine."Line No.");
          CopyFieldsToInteractLogEntry(InteractLogEntry,SegLine);
          InteractLogEntry.Postponed := Postponed;
          InteractLogEntry.Modify;
          InterLogEntryCommentLine.SetRange("Entry No.",InteractLogEntry."Entry No.");
          InterLogEntryCommentLine.DeleteAll;
        end;

        if InterLogEntryCommentLineTmp.FindSet then
          repeat
            InterLogEntryCommentLine.Init;
            InterLogEntryCommentLine := InterLogEntryCommentLineTmp;
            InterLogEntryCommentLine."Entry No." := InteractLogEntry."Entry No.";
            InterLogEntryCommentLine.Insert;
          until InterLogEntryCommentLineTmp.Next = 0;

        if Deliver and (SegLine."Correspondence Type" <> 0) and (not Postponed) then begin
          InteractLogEntry."Delivery Status" := InteractLogEntry."delivery status"::"In Progress";
          DeliverySorterTemp."No." := InteractLogEntry."Entry No.";
          DeliverySorterTemp."Attachment No." := Attachment."No.";
          DeliverySorterTemp."Correspondence Type" := InteractLogEntry."Correspondence Type";
          DeliverySorterTemp.Subject := InteractLogEntry.Subject;
          DeliverySorterTemp."Send Word Docs. as Attmt." := false;
          DeliverySorterTemp."Language Code" := SegLine."Language Code";
          DeliverySorterTemp.Insert;
          AttachmentManagement.Send(DeliverySorterTemp);
        end;
    end;


    procedure LogDocument(DocumentType: Integer;DocumentNo: Code[20];DocNoOccurrence: Integer;VersionNo: Integer;AccountTableNo: Integer;AccountNo: Code[20];SalespersonCode: Code[10];CampaignNo: Code[20];Description: Text[50];OpportunityNo: Code[20])
    var
        InteractTmpl: Record "Interaction Template";
        SegLine: Record "Segment Line" temporary;
        ContBusRel: Record "Contact Business Relation";
        Attachment: Record Attachment;
        Cont: Record Contact;
        InteractTmplLanguage: Record "Interaction Tmpl. Language";
        InterLogEntryCommentLine: Record "Inter. Log Entry Comment Line" temporary;
        InteractTmplCode: Code[10];
        ContNo: Code[20];
    begin
        InteractTmplCode := FindInteractTmplCode(DocumentType);
        if InteractTmplCode = '' then
          exit;

        InteractTmpl.Get(InteractTmplCode);

        InteractTmplLanguage.SetRange("Interaction Template Code",InteractTmplCode);
        if InteractTmplLanguage.FindFirst then
          Error(Text003,InteractTmplCode,InteractTmplLanguage."Language Code");

        if Description = '' then
          Description := InteractTmpl.Description;

        case AccountTableNo of
          Database::Customer:
            with ContBusRel do begin
              SetCurrentkey("Link to Table","No.");
              SetRange("Link to Table","link to table"::Customer);
              SetRange("No.",AccountNo);
              if not FindFirst then
                exit;
              ContNo := "Contact No.";
            end;
          Database::Vendor:
            with ContBusRel do begin
              SetCurrentkey("Link to Table","No.");
              SetRange("Link to Table","link to table"::Vendor);
              SetRange("No.",AccountNo);
              if not FindFirst then
                exit;
              ContNo := "Contact No.";
            end;
          Database::Contact:
            begin
              if not Cont.Get(AccountNo) then
                exit;
              if SalespersonCode = '' then
                SalespersonCode := Cont."Salesperson Code";
              ContNo := AccountNo;
            end;
        end;

        SegLine.Init;
        SegLine."Document Type" := DocumentType;
        SegLine."Document No." := DocumentNo;
        SegLine."Doc. No. Occurrence" := DocNoOccurrence;
        SegLine."Version No." := VersionNo;
        SegLine.Validate("Contact No.",ContNo);
        SegLine.Date := Today;
        SegLine."Time of Interaction" := Time;
        SegLine.Description := Description;
        SegLine."Salesperson Code" := SalespersonCode;
        SegLine."Opportunity No." := OpportunityNo;
        SegLine.Insert;
        SegLine.Validate("Interaction Template Code",InteractTmpl.Code);
        if CampaignNo <> '' then
          SegLine."Campaign No." := CampaignNo;
        SegLine.Modify;

        LogInteraction(SegLine,Attachment,InterLogEntryCommentLine,false,false);
    end;


    procedure FindInteractTmplCode(DocumentType: Integer) InteractTmplCode: Code[10]
    begin
        if InteractionTmplSetup.Get then
          case DocumentType of
            1:
              InteractTmplCode := InteractionTmplSetup."Sales Quotes";
            2:
              InteractTmplCode := InteractionTmplSetup."Sales Blnkt. Ord";
            3:
              InteractTmplCode := InteractionTmplSetup."Sales Ord. Cnfrmn.";
            4:
              InteractTmplCode := InteractionTmplSetup."Sales Invoices";
            5:
              InteractTmplCode := InteractionTmplSetup."Sales Shpt. Note";
            6:
              InteractTmplCode := InteractionTmplSetup."Sales Cr. Memo";
            7:
              InteractTmplCode := InteractionTmplSetup."Sales Statement";
            8:
              InteractTmplCode := InteractionTmplSetup."Sales Rmdr.";
            9:
              InteractTmplCode := InteractionTmplSetup."Serv Ord Create";
            10:
              InteractTmplCode := InteractionTmplSetup."Serv Ord Post";
            11:
              InteractTmplCode := InteractionTmplSetup."Purch. Quotes";
            12:
              InteractTmplCode := InteractionTmplSetup."Purch Blnkt Ord";
            13:
              InteractTmplCode := InteractionTmplSetup."Purch. Orders";
            14:
              InteractTmplCode := InteractionTmplSetup."Purch Invoices";
            15:
              InteractTmplCode := InteractionTmplSetup."Purch. Rcpt.";
            16:
              InteractTmplCode := InteractionTmplSetup."Purch Cr Memos";
            17:
              InteractTmplCode := InteractionTmplSetup."Cover Sheets";
            18:
              InteractTmplCode := InteractionTmplSetup."Sales Return Order";
            19:
              InteractTmplCode := InteractionTmplSetup."Sales Finance Charge Memo";
            20:
              InteractTmplCode := InteractionTmplSetup."Sales Return Receipt";
            21:
              InteractTmplCode := InteractionTmplSetup."Purch. Return Shipment";
            22:
              InteractTmplCode := InteractionTmplSetup."Purch. Return Ord. Cnfrmn.";
            23:
              InteractTmplCode := InteractionTmplSetup."Service Contract";
            24:
              InteractTmplCode := InteractionTmplSetup."Service Contract Quote";
            25:
              InteractTmplCode := InteractionTmplSetup."Service Quote";
          end;
        exit(InteractTmplCode);
    end;

    local procedure TestFields(var SegLine: Record "Segment Line")
    var
        Cont: Record Contact;
        Salesperson: Record "Salesperson/Purchaser";
        Campaign: Record Campaign;
        InteractTmpl: Record "Interaction Template";
        ContAltAddr: Record "Contact Alt. Address";
    begin
        with SegLine do begin
          TestField(Date);
          TestField("Contact No.");
          Cont.Get("Contact No.");
          if "Document Type" = "document type"::" " then begin
            TestField("Salesperson Code");
            Salesperson.Get("Salesperson Code");
          end;
          TestField("Interaction Template Code");
          InteractTmpl.Get("Interaction Template Code");
          if "Campaign No." <> '' then
            Campaign.Get("Campaign No.");
          case "Correspondence Type" of
            "correspondence type"::Email:
              if "Contact Alt. Address Code" <> '' then begin
                ContAltAddr.Get("Contact No.","Contact Alt. Address Code");
                if ContAltAddr."E-Mail" = '' then
                  Cont.TestField("E-Mail");
              end else
                Cont.TestField("E-Mail");
            "correspondence type"::Fax:
              if "Contact Alt. Address Code" <> '' then begin
                ContAltAddr.Get("Contact No.","Contact Alt. Address Code");
                if ContAltAddr."Fax No." = '' then
                  Cont.TestField("Fax No.");
              end else
                Cont.TestField("Fax No.");
          end;
        end;
    end;


    procedure CopyFieldsToInteractLogEntry(var InteractLogEntry: Record "Interaction Log Entry";var SegLine: Record "Segment Line")
    begin
        InteractLogEntry."Contact No." := SegLine."Contact No.";
        InteractLogEntry."Contact Company No." := SegLine."Contact Company No.";
        InteractLogEntry.Date := SegLine.Date;
        InteractLogEntry.Description := SegLine.Description;
        InteractLogEntry."Information Flow" := SegLine."Information Flow";
        InteractLogEntry."Initiated By" := SegLine."Initiated By";
        InteractLogEntry."Attachment No." := SegLine."Attachment No.";
        InteractLogEntry."Cost (LCY)" := SegLine."Cost (LCY)";
        InteractLogEntry."Duration (Min.)" := SegLine."Duration (Min.)";
        InteractLogEntry."User ID" := UserId;
        InteractLogEntry."Interaction Group Code" := SegLine."Interaction Group Code";
        InteractLogEntry."Interaction Template Code" := SegLine."Interaction Template Code";
        InteractLogEntry."Interaction Language Code" := SegLine."Language Code";
        InteractLogEntry.Subject := SegLine.Subject;
        InteractLogEntry."Campaign No." := SegLine."Campaign No.";
        InteractLogEntry."Campaign Entry No." := SegLine."Campaign Entry No.";
        InteractLogEntry."Campaign Response" := SegLine."Campaign Response";
        InteractLogEntry."Campaign Target" := SegLine."Campaign Target";
        InteractLogEntry."Segment No." := SegLine."Segment No.";
        InteractLogEntry.Evaluation := SegLine.Evaluation;
        InteractLogEntry."Time of Interaction" := SegLine."Time of Interaction";
        InteractLogEntry."Attempt Failed" := SegLine."Attempt Failed";
        InteractLogEntry."To-do No." := SegLine."To-do No.";
        InteractLogEntry."Salesperson Code" := SegLine."Salesperson Code";
        InteractLogEntry."Correspondence Type" := SegLine."Correspondence Type";
        InteractLogEntry."Contact Alt. Address Code" := SegLine."Contact Alt. Address Code";
        InteractLogEntry."Document Type" := SegLine."Document Type";
        InteractLogEntry."Document No." := SegLine."Document No.";
        InteractLogEntry."Doc. No. Occurrence" := SegLine."Doc. No. Occurrence";
        InteractLogEntry."Version No." := SegLine."Version No.";
        InteractLogEntry."Send Word Docs. as Attmt." := SegLine."Send Word Doc. As Attmt.";
        InteractLogEntry."Contact Via" := SegLine."Contact Via";
        InteractLogEntry."Opportunity No." := SegLine."Opportunity No.";
    end;

    local procedure CopyFieldsToCampaignEntry(var CampaignEntry: Record "Campaign Entry";var SegLine: Record "Segment Line")
    var
        SegHeader: Record "Segment Header";
    begin
        CampaignEntry."Campaign No." := SegLine."Campaign No.";
        CampaignEntry.Date := SegLine.Date;
        CampaignEntry."Segment No." := SegLine."Segment No.";
        if SegLine."Segment No." <> '' then begin
          SegHeader.Get(SegLine."Segment No.");
          CampaignEntry.Description := SegHeader.Description;
        end else begin
          CampaignEntry.Description :=
            CopyStr(FindInteractTmplSetupCaption(SegLine."Document Type"),1,MaxStrLen(CampaignEntry.Description));
          if CampaignEntry.Description = '' then
            CampaignEntry.Description := Text004;
        end;
        CampaignEntry."Salesperson Code" := SegLine."Salesperson Code";
        CampaignEntry."User ID" := UserId;
        CampaignEntry."Document Type" := SegLine."Document Type";
    end;

    local procedure FindInteractTmplSetupCaption(DocumentType: Integer) InteractTmplSetupCaption: Text[80]
    begin
        InteractionTmplSetup.Get;
        case DocumentType of
          1:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Quotes");
          2:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Blnkt. Ord");
          3:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Ord. Cnfrmn.");
          4:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Invoices");
          5:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Shpt. Note");
          6:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Cr. Memo");
          7:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Statement");
          8:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Rmdr.");
          9:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Serv Ord Create");
          10:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Serv Ord Post");
          11:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch. Quotes");
          12:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch Blnkt Ord");
          13:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch. Orders");
          14:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch Invoices");
          15:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch. Rcpt.");
          16:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch Cr Memos");
          17:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Cover Sheets");
          18:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Return Order");
          19:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Finance Charge Memo");
          20:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Sales Return Receipt");
          21:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch. Return Shipment");
          22:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Purch. Return Ord. Cnfrmn.");
          23:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Service Contract");
          24:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Service Contract Quote");
          25:
            InteractTmplSetupCaption := InteractionTmplSetup.FieldCaption("Service Quote");
        end;
        exit(InteractTmplSetupCaption);
    end;


    procedure CopyFieldsFromInteractLogEntry(var SegLine: Record "Segment Line";var InteractLogEntry: Record "Interaction Log Entry")
    begin
        SegLine."Line No." := InteractLogEntry."Entry No.";
        SegLine."Contact No." := InteractLogEntry."Contact No.";
        SegLine."Contact Company No." := InteractLogEntry."Contact Company No.";
        SegLine.Date := InteractLogEntry.Date;
        SegLine.Description := InteractLogEntry.Description;
        SegLine."Information Flow" := InteractLogEntry."Information Flow";
        SegLine."Initiated By" := InteractLogEntry."Initiated By";
        SegLine."Attachment No." := InteractLogEntry."Attachment No.";
        SegLine."Cost (LCY)" := InteractLogEntry."Cost (LCY)";
        SegLine."Duration (Min.)" := InteractLogEntry."Duration (Min.)";
        SegLine."Interaction Group Code" := InteractLogEntry."Interaction Group Code";
        SegLine."Interaction Template Code" := InteractLogEntry."Interaction Template Code";
        SegLine."Language Code" := InteractLogEntry."Interaction Language Code";
        SegLine.Subject := InteractLogEntry.Subject;
        SegLine."Campaign No." := InteractLogEntry."Campaign No.";
        SegLine."Campaign Entry No." := InteractLogEntry."Campaign Entry No.";
        SegLine."Campaign Response" := InteractLogEntry."Campaign Response";
        SegLine."Campaign Target" := InteractLogEntry."Campaign Target";
        SegLine."Segment No." := InteractLogEntry."Segment No.";
        SegLine.Evaluation := InteractLogEntry.Evaluation;
        SegLine."Time of Interaction" := InteractLogEntry."Time of Interaction";
        SegLine."Attempt Failed" := InteractLogEntry."Attempt Failed";
        SegLine."To-do No." := InteractLogEntry."To-do No.";
        SegLine."Salesperson Code" := InteractLogEntry."Salesperson Code";
        SegLine."Correspondence Type" := InteractLogEntry."Correspondence Type";
        SegLine."Contact Alt. Address Code" := InteractLogEntry."Contact Alt. Address Code";
        SegLine."Document Type" := InteractLogEntry."Document Type";
        SegLine."Document No." := InteractLogEntry."Document No.";
        SegLine."Doc. No. Occurrence" := InteractLogEntry."Doc. No. Occurrence";
        SegLine."Version No." := InteractLogEntry."Version No.";
        SegLine."Send Word Doc. As Attmt." := InteractLogEntry."Send Word Docs. as Attmt.";
        SegLine."Contact Via" := InteractLogEntry."Contact Via";
        SegLine."Opportunity No." := InteractLogEntry."Opportunity No.";
    end;
}

