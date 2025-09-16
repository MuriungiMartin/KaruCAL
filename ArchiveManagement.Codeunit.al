#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5063 ArchiveManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Document %1 has been archived.';
        Text002: label 'Do you want to Restore %1 %2 Version %3?';
        Text003: label '%1 %2 has been restored.';
        Text004: label 'Document restored from Version %1.';
        Text005: label '%1 %2 has been partly posted.\Restore not possible.';
        Text006: label 'Entries exist for on or more of the following:\  - %1\  - %2\  - %3.\Restoration of document will delete these entries.\Continue with restore?';
        Text007: label 'Archive %1 no.: %2?';
        Text008: label 'Item Tracking Line';
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        Text009: label 'Unposted %1 %2 does not exist anymore.\It is not possible to restore the %1.';
        DeferralUtilities: Codeunit "Deferral Utilities";


    procedure ArchiveSalesDocument(var SalesHeader: Record "Sales Header")
    begin
        if Confirm(
             Text007,true,SalesHeader."Document Type",
             SalesHeader."No.")
        then begin
          StoreSalesDocument(SalesHeader,false);
          Message(Text001,SalesHeader."No.");
        end;
    end;


    procedure ArchivePurchDocument(var PurchHeader: Record "Purchase Header")
    begin
        if Confirm(
             Text007,true,PurchHeader."Document Type",
             PurchHeader."No.")
        then begin
          StorePurchDocument(PurchHeader,false);
          Message(Text001,PurchHeader."No.");
        end;
    end;


    procedure StoreSalesDocument(var SalesHeader: Record "Sales Header";InteractionExist: Boolean)
    var
        SalesLine: Record "Sales Line";
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesLineArchive: Record "Sales Line Archive";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        SalesHeaderArchive.Init;
        SalesHeaderArchive.TransferFields(SalesHeader);
        SalesHeaderArchive."Archived By" := UserId;
        SalesHeaderArchive."Date Archived" := WorkDate;
        SalesHeaderArchive."Time Archived" := Time;
        SalesHeaderArchive."Version No." := GetNextVersionNo(
            Database::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",SalesHeader."Doc. No. Occurrence");
        SalesHeaderArchive."Interaction Exist" := InteractionExist;
        RecordLinkManagement.CopyLinks(SalesHeader,SalesHeaderArchive);
        SalesHeaderArchive.Insert;

        StoreSalesDocumentComments(
          SalesHeader."Document Type",SalesHeader."No.",
          SalesHeader."Doc. No. Occurrence",SalesHeaderArchive."Version No.");

        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        if SalesLine.FindSet then
          repeat
            with SalesLineArchive do begin
              Init;
              TransferFields(SalesLine);
              "Doc. No. Occurrence" := SalesHeader."Doc. No. Occurrence";
              "Version No." := SalesHeaderArchive."Version No.";
              RecordLinkManagement.CopyLinks(SalesLine,SalesLineArchive);
              Insert;
            end;
            if SalesLine."Deferral Code" <> '' then
              StoreDeferrals(DeferralUtilities.GetSalesDeferralDocType,SalesLine."Document Type",
                SalesLine."Document No.",SalesLine."Line No.",SalesHeader."Doc. No. Occurrence",SalesHeaderArchive."Version No.");

          until SalesLine.Next = 0;
    end;


    procedure StorePurchDocument(var PurchHeader: Record "Purchase Header";InteractionExist: Boolean)
    var
        PurchLine: Record "Purchase Line";
        PurchHeaderArchive: Record "Purchase Header Archive";
        PurchLineArchive: Record "Purchase Line Archive";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        PurchHeaderArchive.Init;
        PurchHeaderArchive.TransferFields(PurchHeader);
        PurchHeaderArchive."Archived By" := UserId;
        PurchHeaderArchive."Date Archived" := WorkDate;
        PurchHeaderArchive."Time Archived" := Time;
        PurchHeaderArchive."Version No." := GetNextVersionNo(
            Database::"Purchase Header",PurchHeader."Document Type",PurchHeader."No.",PurchHeader."Doc. No. Occurrence");
        PurchHeaderArchive."Interaction Exist" := InteractionExist;
        RecordLinkManagement.CopyLinks(PurchHeader,PurchHeaderArchive);
        PurchHeaderArchive.Insert;

        StorePurchDocumentComments(
          PurchHeader."Document Type",PurchHeader."No.",
          PurchHeader."Doc. No. Occurrence",PurchHeaderArchive."Version No.");

        PurchLine.SetRange("Document Type",PurchHeader."Document Type");
        PurchLine.SetRange("Document No.",PurchHeader."No.");
        if PurchLine.FindSet then
          repeat
            with PurchLineArchive do begin
              Init;
              TransferFields(PurchLine);
              "Doc. No. Occurrence" := PurchHeader."Doc. No. Occurrence";
              "Version No." := PurchHeaderArchive."Version No.";
              RecordLinkManagement.CopyLinks(PurchLine,PurchLineArchive);
              Insert;
            end;
            if PurchLine."Deferral Code" <> '' then
              StoreDeferrals(DeferralUtilities.GetPurchDeferralDocType,PurchLine."Document Type",
                PurchLine."Document No.",PurchLine."Line No.",PurchHeader."Doc. No. Occurrence",PurchHeaderArchive."Version No.");
          until PurchLine.Next = 0;
    end;


    procedure RestoreSalesDocument(var SalesHeaderArchive: Record "Sales Header Archive")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLineArchive: Record "Sales Line Archive";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReservEntry: Record "Reservation Entry";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        RecordLinkManagement: Codeunit "Record Link Management";
        ConfirmRequired: Boolean;
        RestoreDocument: Boolean;
        OldOpportunityNo: Code[20];
    begin
        if not SalesHeader.Get(SalesHeaderArchive."Document Type",SalesHeaderArchive."No.") then
          Error(Text009,SalesHeaderArchive."Document Type",SalesHeaderArchive."No.");
        SalesHeader.TestField(Status,SalesHeader.Status::Open);
        if SalesHeader."Document Type" = SalesHeader."document type"::Order then begin
          SalesShptHeader.Reset;
          SalesShptHeader.SetCurrentkey("Order No.");
          SalesShptHeader.SetRange("Order No.",SalesHeader."No.");
          if not SalesShptHeader.IsEmpty then
            Error(Text005,SalesHeader."Document Type",SalesHeader."No.");
          SalesInvHeader.Reset;
          SalesInvHeader.SetCurrentkey("Order No.");
          SalesInvHeader.SetRange("Order No.",SalesHeader."No.");
          if not SalesInvHeader.IsEmpty then
            Error(Text005,SalesHeader."Document Type",SalesHeader."No.");
        end;

        ConfirmRequired := false;
        ReservEntry.Reset;
        ReservEntry.SetCurrentkey(
          "Source ID",
          "Source Ref. No.",
          "Source Type",
          "Source Subtype");

        ReservEntry.SetRange("Source ID",SalesHeader."No.");
        ReservEntry.SetRange("Source Type",Database::"Sales Line");
        ReservEntry.SetRange("Source Subtype",SalesHeader."Document Type");
        if ReservEntry.FindFirst then
          ConfirmRequired := true;

        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetRange("Document Type",SalesHeader."Document Type");
        ItemChargeAssgntSales.SetRange("Document No.",SalesHeader."No.");
        if ItemChargeAssgntSales.FindFirst then
          ConfirmRequired := true;

        RestoreDocument := false;
        if ConfirmRequired then begin
          if Confirm(
               Text006,false,ReservEntry.TableCaption,ItemChargeAssgntSales.TableCaption,Text008)
          then
            RestoreDocument := true;
        end else
          if Confirm(
               Text002,true,SalesHeaderArchive."Document Type",
               SalesHeaderArchive."No.",SalesHeaderArchive."Version No.")
          then
            RestoreDocument := true;
        if RestoreDocument then begin
          SalesHeader.TestField("Doc. No. Occurrence",SalesHeaderArchive."Doc. No. Occurrence");
          SalesHeaderArchive.CalcFields("Work Description");
          if SalesHeader."Opportunity No." <> '' then begin
            OldOpportunityNo := SalesHeader."Opportunity No.";
            SalesHeader."Opportunity No." := '';
          end;
          SalesHeader.DeleteLinks;
          SalesHeader.Delete(true);
          SalesHeader.Init;

          SalesHeader.SetHideValidationDialog(true);
          SalesHeader."Document Type" := SalesHeaderArchive."Document Type";
          SalesHeader."No." := SalesHeaderArchive."No.";
          SalesHeader.Insert(true);
          SalesHeader.TransferFields(SalesHeaderArchive);
          SalesHeader.Status := SalesHeader.Status::Open;

          if SalesHeaderArchive."Sell-to Contact No." <> '' then
            SalesHeader.Validate("Sell-to Contact No.",SalesHeaderArchive."Sell-to Contact No.")
          else
            SalesHeader.Validate("Sell-to Customer No.",SalesHeaderArchive."Sell-to Customer No.");
          if SalesHeaderArchive."Bill-to Contact No." <> '' then
            SalesHeader.Validate("Bill-to Contact No.",SalesHeaderArchive."Bill-to Contact No.")
          else
            SalesHeader.Validate("Bill-to Customer No.",SalesHeaderArchive."Bill-to Customer No.");
          SalesHeader.Validate("Salesperson Code",SalesHeaderArchive."Salesperson Code");
          SalesHeader.Validate("Payment Terms Code",SalesHeaderArchive."Payment Terms Code");
          SalesHeader.Validate("Payment Discount %",SalesHeaderArchive."Payment Discount %");
          SalesHeader."Shortcut Dimension 1 Code" := SalesHeaderArchive."Shortcut Dimension 1 Code";
          SalesHeader."Shortcut Dimension 2 Code" := SalesHeaderArchive."Shortcut Dimension 2 Code";
          SalesHeader."Dimension Set ID" := SalesHeaderArchive."Dimension Set ID";
          RecordLinkManagement.CopyLinks(SalesHeaderArchive,SalesHeader);

          SalesHeader.LinkSalesDocWithOpportunity(OldOpportunityNo);

          SalesHeader.Modify(true);
          RestoreSalesLineComments(SalesHeaderArchive,SalesHeader);

          SalesLineArchive.SetRange("Document Type",SalesHeaderArchive."Document Type");
          SalesLineArchive.SetRange("Document No.",SalesHeaderArchive."No.");
          SalesLineArchive.SetRange("Doc. No. Occurrence",SalesHeaderArchive."Doc. No. Occurrence");
          SalesLineArchive.SetRange("Version No.",SalesHeaderArchive."Version No.");
          if SalesLineArchive.FindSet then
            repeat
              with SalesLine do begin
                Init;
                TransferFields(SalesLineArchive);
                Insert(true);
                if Type <> Type::" " then begin
                  Validate("No.");
                  if SalesLineArchive."Variant Code" <> '' then
                    Validate("Variant Code",SalesLineArchive."Variant Code");
                  if SalesLineArchive."Unit of Measure Code" <> '' then
                    Validate("Unit of Measure Code",SalesLineArchive."Unit of Measure Code");
                  Validate("Location Code",SalesLineArchive."Location Code");
                  if Quantity <> 0 then
                    Validate(Quantity,SalesLineArchive.Quantity);
                  Validate("Unit Price",SalesLineArchive."Unit Price");
                  Validate("Line Discount %",SalesLineArchive."Line Discount %");
                  if SalesLineArchive."Inv. Discount Amount" <> 0 then
                    Validate("Inv. Discount Amount",SalesLineArchive."Inv. Discount Amount");
                  if Amount <> SalesLineArchive.Amount then
                    Validate(Amount,SalesLineArchive.Amount);
                  Validate(Description,SalesLineArchive.Description);
                end;
                "Shortcut Dimension 1 Code" := SalesLineArchive."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := SalesLineArchive."Shortcut Dimension 2 Code";
                "Dimension Set ID" := SalesLineArchive."Dimension Set ID";
                "Deferral Code" := SalesLineArchive."Deferral Code";
                RestoreDeferrals(DeferralUtilities.GetSalesDeferralDocType,
                  SalesLineArchive."Document Type",
                  SalesLineArchive."Document No.",
                  SalesLineArchive."Line No.",
                  SalesHeaderArchive."Doc. No. Occurrence",
                  SalesHeaderArchive."Version No.");
                RecordLinkManagement.CopyLinks(SalesLineArchive,SalesLine);
                Modify(true);
              end
            until SalesLineArchive.Next = 0;

          SalesHeader.Status := SalesHeader.Status::Released;
          ReleaseSalesDoc.Reopen(SalesHeader);
          Message(Text003,SalesHeader."Document Type",SalesHeader."No.");
        end;
    end;


    procedure GetNextOccurrenceNo(TableId: Integer;DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";DocNo: Code[20]): Integer
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        PurchHeaderArchive: Record "Purchase Header Archive";
    begin
        case TableId of
          Database::"Sales Header":
            begin
              SalesHeaderArchive.LockTable;
              SalesHeaderArchive.SetRange("Document Type",DocType);
              SalesHeaderArchive.SetRange("No.",DocNo);
              if SalesHeaderArchive.FindLast then
                exit(SalesHeaderArchive."Doc. No. Occurrence" + 1);

              exit(1);
            end;
          Database::"Purchase Header":
            begin
              PurchHeaderArchive.LockTable;
              PurchHeaderArchive.SetRange("Document Type",DocType);
              PurchHeaderArchive.SetRange("No.",DocNo);
              if PurchHeaderArchive.FindLast then
                exit(PurchHeaderArchive."Doc. No. Occurrence" + 1);

              exit(1);
            end;
        end;
    end;


    procedure GetNextVersionNo(TableId: Integer;DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";DocNo: Code[20];DocNoOccurrence: Integer): Integer
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        PurchHeaderArchive: Record "Purchase Header Archive";
    begin
        case TableId of
          Database::"Sales Header":
            begin
              SalesHeaderArchive.LockTable;
              SalesHeaderArchive.SetRange("Document Type",DocType);
              SalesHeaderArchive.SetRange("No.",DocNo);
              SalesHeaderArchive.SetRange("Doc. No. Occurrence",DocNoOccurrence);
              if SalesHeaderArchive.FindLast then
                exit(SalesHeaderArchive."Version No." + 1);

              exit(1);
            end;
          Database::"Purchase Header":
            begin
              PurchHeaderArchive.LockTable;
              PurchHeaderArchive.SetRange("Document Type",DocType);
              PurchHeaderArchive.SetRange("No.",DocNo);
              PurchHeaderArchive.SetRange("Doc. No. Occurrence",DocNoOccurrence);
              if PurchHeaderArchive.FindLast then
                exit(PurchHeaderArchive."Version No." + 1);

              exit(1);
            end;
        end;
    end;


    procedure SalesDocArchiveGranule(): Boolean
    var
        SalesHeaderArchive: Record "Sales Header Archive";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if not SalesSetup."Archive Quotes and Orders" then
          exit(false);
        exit(SalesHeaderArchive.WritePermission);
    end;


    procedure PurchaseDocArchiveGranule(): Boolean
    var
        PurchaseHeaderArchive: Record "Purchase Header Archive";
        PurchaseSetup: Record "Purchases & Payables Setup";
    begin
        PurchaseSetup.Get;
        if not PurchaseSetup."Archive Quotes and Orders" then
          exit(false);
        exit(PurchaseHeaderArchive.WritePermission);
    end;

    local procedure StoreSalesDocumentComments(DocType: Option;DocNo: Code[20];DocNoOccurrence: Integer;VersionNo: Integer)
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLineArch: Record "Sales Comment Line Archive";
    begin
        SalesCommentLine.SetRange("Document Type",DocType);
        SalesCommentLine.SetRange("No.",DocNo);
        if SalesCommentLine.FindSet then
          repeat
            SalesCommentLineArch.Init;
            SalesCommentLineArch.TransferFields(SalesCommentLine);
            SalesCommentLineArch."Doc. No. Occurrence" := DocNoOccurrence;
            SalesCommentLineArch."Version No." := VersionNo;
            SalesCommentLineArch.Insert;
          until SalesCommentLine.Next = 0;
    end;

    local procedure StorePurchDocumentComments(DocType: Option;DocNo: Code[20];DocNoOccurrence: Integer;VersionNo: Integer)
    var
        PurchCommentLine: Record "Purch. Comment Line";
        PurchCommentLineArch: Record "Purch. Comment Line Archive";
    begin
        PurchCommentLine.SetRange("Document Type",DocType);
        PurchCommentLine.SetRange("No.",DocNo);
        if PurchCommentLine.FindSet then
          repeat
            PurchCommentLineArch.Init;
            PurchCommentLineArch.TransferFields(PurchCommentLine);
            PurchCommentLineArch."Doc. No. Occurrence" := DocNoOccurrence;
            PurchCommentLineArch."Version No." := VersionNo;
            PurchCommentLineArch.Insert;
          until PurchCommentLine.Next = 0;
    end;


    procedure ArchSalesDocumentNoConfirm(var SalesHeader: Record "Sales Header")
    begin
        StoreSalesDocument(SalesHeader,false);
    end;


    procedure ArchPurchDocumentNoConfirm(var PurchHeader: Record "Purchase Header")
    begin
        StorePurchDocument(PurchHeader,false);
    end;

    local procedure StoreDeferrals(DeferralDocType: Integer;DocType: Integer;DocNo: Code[20];LineNo: Integer;DocNoOccurrence: Integer;VersionNo: Integer)
    var
        DeferralHeaderArchive: Record "Deferral Header Archive";
        DeferralLineArchive: Record "Deferral Line Archive";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
    begin
        if DeferralHeader.Get(DeferralDocType,'','',DocType,DocNo,LineNo) then begin
          DeferralHeaderArchive.Init;
          DeferralHeaderArchive.TransferFields(DeferralHeader);
          DeferralHeaderArchive."Doc. No. Occurrence" := DocNoOccurrence;
          DeferralHeaderArchive."Version No." := VersionNo;
          DeferralHeaderArchive.Insert;

          DeferralLine.SetRange("Deferral Doc. Type",DeferralDocType);
          DeferralLine.SetRange("Gen. Jnl. Template Name",'');
          DeferralLine.SetRange("Gen. Jnl. Batch Name",'');
          DeferralLine.SetRange("Document Type",DocType);
          DeferralLine.SetRange("Document No.",DocNo);
          DeferralLine.SetRange("Line No.",LineNo);
          if DeferralLine.FindSet then
            repeat
              DeferralLineArchive.Init;
              DeferralLineArchive.TransferFields(DeferralLine);
              DeferralLineArchive."Doc. No. Occurrence" := DocNoOccurrence;
              DeferralLineArchive."Version No." := VersionNo;
              DeferralLineArchive.Insert;
            until DeferralLine.Next = 0;
        end;
    end;

    local procedure RestoreDeferrals(DeferralDocType: Integer;DocType: Integer;DocNo: Code[20];LineNo: Integer;DocNoOccurrence: Integer;VersionNo: Integer)
    var
        DeferralHeaderArchive: Record "Deferral Header Archive";
        DeferralLineArchive: Record "Deferral Line Archive";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
    begin
        if DeferralHeaderArchive.Get(DeferralDocType,DocType,DocNo,DocNoOccurrence,VersionNo,LineNo) then begin
          // Updates the header if is exists already and removes all the lines
          DeferralUtilities.SetDeferralRecords(DeferralHeader,
            DeferralDocType,'','',
            DocType,DocNo,LineNo,
            DeferralHeaderArchive."Calc. Method",
            DeferralHeaderArchive."No. of Periods",
            DeferralHeaderArchive."Amount to Defer",
            DeferralHeaderArchive."Start Date",
            DeferralHeaderArchive."Deferral Code",
            DeferralHeaderArchive."Schedule Description",
            DeferralHeaderArchive."Initial Amount to Defer",
            true,
            DeferralHeaderArchive."Currency Code");

          // Add lines as exist in the archives
          DeferralLineArchive.SetRange("Deferral Doc. Type",DeferralDocType);
          DeferralLineArchive.SetRange("Document Type",DocType);
          DeferralLineArchive.SetRange("Document No.",DocNo);
          DeferralLineArchive.SetRange("Doc. No. Occurrence",DocNoOccurrence);
          DeferralLineArchive.SetRange("Version No.",VersionNo);
          DeferralLineArchive.SetRange("Line No.",LineNo);
          if DeferralLineArchive.FindSet then
            repeat
              DeferralLine.Init;
              DeferralLine.TransferFields(DeferralLineArchive);
              DeferralLine.Insert;
            until DeferralLineArchive.Next = 0;
        end else
          // Removes any lines that may have been defaulted
          DeferralUtilities.RemoveOrSetDeferralSchedule('',DeferralDocType,'','',DocType,DocNo,LineNo,0,0D,'','',true);
    end;

    local procedure RestoreSalesLineComments(SalesHeaderArchive: Record "Sales Header Archive";SalesHeader: Record "Sales Header")
    var
        SalesCommentLineArchive: Record "Sales Comment Line Archive";
        SalesCommentLine: Record "Sales Comment Line";
        NextLine: Integer;
    begin
        SalesCommentLineArchive.SetRange("Document Type",SalesHeaderArchive."Document Type");
        SalesCommentLineArchive.SetRange("No.",SalesHeaderArchive."No.");
        SalesCommentLineArchive.SetRange("Doc. No. Occurrence",SalesHeaderArchive."Doc. No. Occurrence");
        SalesCommentLineArchive.SetRange("Version No.",SalesHeaderArchive."Version No.");
        if SalesCommentLineArchive.FindSet then
          repeat
            SalesCommentLine.Init;
            SalesCommentLine.TransferFields(SalesCommentLineArchive);
            SalesCommentLine.Insert;
          until SalesCommentLineArchive.Next = 0;

        SalesCommentLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesCommentLine.SetRange("No.",SalesHeader."No.");
        SalesCommentLine.SetRange("Document Line No.",0);
        if SalesCommentLine.FindLast then
          NextLine := SalesCommentLine."Line No.";
        NextLine += 10000;
        SalesCommentLine.Init;
        SalesCommentLine."Document Type" := SalesHeader."Document Type";
        SalesCommentLine."No." := SalesHeader."No.";
        SalesCommentLine."Document Line No." := 0;
        SalesCommentLine."Line No." := NextLine;
        SalesCommentLine.Date := WorkDate;
        SalesCommentLine.Comment := StrSubstNo(Text004,Format(SalesHeaderArchive."Version No."));
        SalesCommentLine.Insert;
    end;
}

