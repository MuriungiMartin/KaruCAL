#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 513 "Move IC Trans. to Partner Comp"
{
    Caption = 'Move IC Trans. to Partner Comp';
    ProcessingOnly = true;

    dataset
    {
        dataitem("IC Outbox Transaction";"IC Outbox Transaction")
        {
            DataItemTableView = sorting("Transaction No.","IC Partner Code","Transaction Source","Document Type") order(ascending);
            column(ReportForNavId_1220; 1220)
            {
            }
            dataitem("IC Outbox Jnl. Line";"IC Outbox Jnl. Line")
            {
                DataItemLink = "Transaction No."=field("Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source");
                DataItemTableView = sorting("Transaction No.","IC Partner Code","Transaction Source","Line No.");
                column(ReportForNavId_9410; 9410)
                {
                }
                dataitem("IC Inbox/Outbox Jnl. Line Dim.";"IC Inbox/Outbox Jnl. Line Dim.")
                {
                    DataItemLink = "IC Partner Code"=field("IC Partner Code"),"Transaction No."=field("Transaction No."),"Line No."=field("Line No.");
                    DataItemTableView = sorting("Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.","Dimension Code") order(ascending) where("Table ID"=const(415));
                    column(ReportForNavId_9924; 9924)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                          ICInboxOutboxMgt.OutboxJnlLineDimToInbox(
                            TempICInboxJnlLine,"IC Inbox/Outbox Jnl. Line Dim.",
                            TempInboxOutboxJnlLineDim,Database::"IC Inbox Jnl. Line");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                      ICInboxOutboxMgt.OutboxJnlLineToInbox(TempICInboxTransaction,"IC Outbox Jnl. Line",TempICInboxJnlLine);
                end;
            }
            dataitem("IC Outbox Sales Header";"IC Outbox Sales Header")
            {
                DataItemLink = "IC Partner Code"=field("IC Partner Code"),"IC Transaction No."=field("Transaction No."),"Transaction Source"=field("Transaction Source");
                DataItemTableView = sorting("IC Transaction No.","IC Partner Code","Transaction Source");
                column(ReportForNavId_4982; 4982)
                {
                }
                dataitem("IC Document Dimension SH";"IC Document Dimension")
                {
                    DataItemLink = "Transaction No."=field("IC Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source");
                    DataItemTableView = sorting("Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.","Dimension Code") order(ascending) where("Table ID"=const(426),"Line No."=const(0));
                    column(ReportForNavId_6933; 6933)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                          ICInboxOutboxMgt.OutboxDocDimToInbox(
                            "IC Document Dimension SH",TempICDocDim,Database::"IC Inbox Purchase Header",
                            TempInboxPurchHeader."IC Partner Code",TempInboxPurchHeader."Transaction Source");
                    end;
                }
                dataitem("IC Outbox Sales Line";"IC Outbox Sales Line")
                {
                    DataItemLink = "IC Transaction No."=field("IC Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source");
                    DataItemTableView = sorting("IC Transaction No.","IC Partner Code","Transaction Source");
                    column(ReportForNavId_8929; 8929)
                    {
                    }
                    dataitem("IC Document Dimension SL";"IC Document Dimension")
                    {
                        DataItemLink = "Transaction No."=field("IC Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source"),"Line No."=field("Line No.");
                        DataItemTableView = sorting("Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.","Dimension Code") order(ascending) where("Table ID"=const(427));
                        column(ReportForNavId_1776; 1776)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                              ICInboxOutboxMgt.OutboxDocDimToInbox(
                                "IC Document Dimension SL",TempICDocDim,Database::"IC Inbox Purchase Line",
                                TempInboxPurchLine."IC Partner Code",TempInboxPurchLine."Transaction Source");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                          ICInboxOutboxMgt.OutboxSalesLineToInbox(TempICInboxTransaction,"IC Outbox Sales Line",TempInboxPurchLine);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                      ICInboxOutboxMgt.OutboxSalesHdrToInbox(TempICInboxTransaction,"IC Outbox Sales Header",TempInboxPurchHeader);
                end;
            }
            dataitem("IC Outbox Purchase Header";"IC Outbox Purchase Header")
            {
                DataItemLink = "IC Partner Code"=field("IC Partner Code"),"IC Transaction No."=field("Transaction No."),"Transaction Source"=field("Transaction Source");
                DataItemTableView = sorting("IC Transaction No.","IC Partner Code","Transaction Source");
                column(ReportForNavId_5739; 5739)
                {
                }
                dataitem("IC Document Dimension PH";"IC Document Dimension")
                {
                    DataItemLink = "Transaction No."=field("IC Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source");
                    DataItemTableView = sorting("Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.","Dimension Code") order(ascending) where("Table ID"=const(428),"Line No."=const(0));
                    column(ReportForNavId_8943; 8943)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                          ICInboxOutboxMgt.OutboxDocDimToInbox(
                            "IC Document Dimension PH",TempICDocDim,Database::"IC Inbox Sales Header",
                            TempInboxSalesHeader."IC Partner Code",TempInboxSalesHeader."Transaction Source");
                    end;
                }
                dataitem("IC Outbox Purchase Line";"IC Outbox Purchase Line")
                {
                    DataItemLink = "IC Transaction No."=field("IC Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source");
                    DataItemTableView = sorting("IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
                    column(ReportForNavId_4616; 4616)
                    {
                    }
                    dataitem("IC Document Dimension PL";"IC Document Dimension")
                    {
                        DataItemLink = "Transaction No."=field("IC Transaction No."),"IC Partner Code"=field("IC Partner Code"),"Transaction Source"=field("Transaction Source"),"Line No."=field("Line No.");
                        DataItemTableView = sorting("Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.","Dimension Code") order(ascending) where("Table ID"=const(429));
                        column(ReportForNavId_7965; 7965)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                              ICInboxOutboxMgt.OutboxDocDimToInbox(
                                "IC Document Dimension PL",TempICDocDim,Database::"IC Inbox Sales Line",
                                TempInboxSalesLine."IC Partner Code",TempInboxSalesLine."Transaction Source");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                          ICInboxOutboxMgt.OutboxPurchLineToInbox(TempICInboxTransaction,"IC Outbox Purchase Line",TempInboxSalesLine);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if "IC Outbox Transaction"."Line Action" = "IC Outbox Transaction"."line action"::"Send to IC Partner" then
                      ICInboxOutboxMgt.OutboxPurchHdrToInbox(TempICInboxTransaction,"IC Outbox Purchase Header",TempInboxSalesHeader);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if CurrentPartner.Code <> "IC Partner Code" then
                  CurrentPartner.Get("IC Partner Code");

                case "Line Action" of
                  "line action"::"Send to IC Partner":
                    ICInboxOutboxMgt.OutboxTransToInbox(
                      "IC Outbox Transaction",TempICInboxTransaction,CompanyInfo."IC Partner Code");
                  "line action"::"Return to Inbox":
                    RecreateInboxTrans("IC Outbox Transaction");
                end;
            end;

            trigger OnPostDataItem()
            begin
                TransferToPartner;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.TestField("IC Partner Code");
                GLSetup.Get;
                GLSetup.TestField("LCY Code");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CurrentPartner: Record "IC Partner";
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        TempICInboxTransaction: Record "IC Inbox Transaction" temporary;
        TempICInboxJnlLine: Record "IC Inbox Jnl. Line" temporary;
        TempInboxPurchHeader: Record "IC Inbox Purchase Header" temporary;
        TempInboxPurchLine: Record "IC Inbox Purchase Line" temporary;
        TempInboxSalesHeader: Record "IC Inbox Sales Header" temporary;
        TempInboxSalesLine: Record "IC Inbox Sales Line" temporary;
        Text001: label 'Your IC registration code %1 is not recognized by IC Partner %2.';
        TempInboxOutboxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim." temporary;
        TempICDocDim: Record "IC Document Dimension" temporary;
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        Text002: label '%1 %2 to IC Partner %3 already exists in the IC inbox of IC Partner %3. IC Partner %3 must complete the line action for transaction %2 in their IC inbox.';

    local procedure TransferToPartner()
    var
        PartnerInboxTransaction: Record "IC Inbox Transaction";
        PartnerInboxJnlLine: Record "IC Inbox Jnl. Line";
        PartnerInboxSalesHeader: Record "IC Inbox Sales Header";
        PartnerInboxSalesLine: Record "IC Inbox Sales Line";
        PartnerInboxPurchHeader: Record "IC Inbox Purchase Header";
        PartnerInboxPurchLine: Record "IC Inbox Purchase Line";
        PartnerInboxOutboxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim.";
        PartnerICDocDim: Record "IC Document Dimension";
        PartnerICPartner: Record "IC Partner";
    begin
        PartnerICPartner.ChangeCompany(CurrentPartner."Inbox Details");
        if not PartnerICPartner.Get(CompanyInfo."IC Partner Code") then
          Error(Text001,CompanyInfo."IC Partner Code",CurrentPartner.Code);

        PartnerInboxTransaction.ChangeCompany(CurrentPartner."Inbox Details");
        PartnerInboxTransaction.LockTable;
        if TempICInboxTransaction.Find('-') then
          repeat
            PartnerInboxTransaction := TempICInboxTransaction;
            if not PartnerInboxTransaction.Insert then
              Error(
                Text002,TempICInboxTransaction.FieldCaption("Transaction No."),
                TempICInboxTransaction."Transaction No.",
                TempICInboxTransaction."IC Partner Code");
          until TempICInboxTransaction.Next = 0;

        PartnerInboxJnlLine.ChangeCompany(CurrentPartner."Inbox Details");
        if TempICInboxJnlLine.Find('-') then
          repeat
            PartnerInboxJnlLine := TempICInboxJnlLine;
            if PartnerInboxJnlLine."Currency Code" = '' then
              PartnerInboxJnlLine."Currency Code" := GLSetup."LCY Code";
            if PartnerInboxJnlLine."Currency Code" = CurrentPartner."Currency Code" then
              PartnerInboxJnlLine."Currency Code" := '';
            PartnerInboxJnlLine.Insert;
          until TempICInboxJnlLine.Next = 0;

        PartnerInboxPurchHeader.ChangeCompany(CurrentPartner."Inbox Details");
        if TempInboxPurchHeader.Find('-') then
          repeat
            PartnerInboxPurchHeader := TempInboxPurchHeader;
            PartnerInboxPurchHeader."Buy-from Vendor No." := PartnerICPartner."Vendor No.";
            PartnerInboxPurchHeader."Pay-to Vendor No." := PartnerICPartner."Vendor No.";
            PartnerInboxPurchHeader.Insert;
          until TempInboxPurchHeader.Next = 0;

        PartnerInboxPurchLine.ChangeCompany(CurrentPartner."Inbox Details");
        if TempInboxPurchLine.Find('-') then
          repeat
            PartnerInboxPurchLine := TempInboxPurchLine;
            PartnerInboxPurchLine.Insert;
          until TempInboxPurchLine.Next = 0;

        PartnerInboxSalesHeader.ChangeCompany(CurrentPartner."Inbox Details");
        if TempInboxSalesHeader.Find('-') then
          repeat
            PartnerInboxSalesHeader := TempInboxSalesHeader;
            PartnerInboxSalesHeader."Sell-to Customer No." := PartnerICPartner."Customer No.";
            PartnerInboxSalesHeader."Bill-to Customer No." := PartnerICPartner."Customer No.";
            PartnerInboxSalesHeader.Insert;
          until TempInboxSalesHeader.Next = 0;

        PartnerInboxSalesLine.ChangeCompany(CurrentPartner."Inbox Details");
        if TempInboxSalesLine.Find('-') then
          repeat
            PartnerInboxSalesLine := TempInboxSalesLine;
            PartnerInboxSalesLine.Insert;
          until TempInboxSalesLine.Next = 0;

        PartnerInboxOutboxJnlLineDim.ChangeCompany(CurrentPartner."Inbox Details");
        if TempInboxOutboxJnlLineDim.Find('-') then
          repeat
            PartnerInboxOutboxJnlLineDim := TempInboxOutboxJnlLineDim;
            PartnerInboxOutboxJnlLineDim.Insert;
          until TempInboxOutboxJnlLineDim.Next = 0;

        PartnerICDocDim.ChangeCompany(CurrentPartner."Inbox Details");
        if TempICDocDim.Find('-') then
          repeat
            PartnerICDocDim := TempICDocDim;
            PartnerICDocDim.Insert;
          until TempICDocDim.Next = 0;

        TempICInboxTransaction.DeleteAll;
        TempInboxPurchHeader.DeleteAll;
        TempInboxPurchLine.Reset;
        TempInboxPurchLine.DeleteAll;
        TempInboxSalesHeader.DeleteAll;
        TempInboxSalesLine.Reset;
        TempInboxSalesLine.DeleteAll;
        TempICInboxJnlLine.Reset;
        TempICInboxJnlLine.DeleteAll;
        TempInboxOutboxJnlLineDim.DeleteAll;
        TempICDocDim.DeleteAll;
    end;


    procedure RecreateInboxTrans(OutboxTrans: Record "IC Outbox Transaction")
    var
        ICInboxTrans: Record "IC Inbox Transaction";
        ICInboxJnlLine: Record "IC Inbox Jnl. Line";
        ICInboxSalesHdr: Record "IC Inbox Sales Header";
        ICInboxSalesLine: Record "IC Inbox Sales Line";
        ICInboxPurchHdr: Record "IC Inbox Purchase Header";
        ICInboxPurchLine: Record "IC Inbox Purchase Line";
        ICInboxOutboxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim.";
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
        HandledICInboxJnlLine: Record "Handled IC Inbox Jnl. Line";
        HandledICInboxSalesHdr: Record "Handled IC Inbox Sales Header";
        HandledICInboxSalesLine: Record "Handled IC Inbox Sales Line";
        HandledICInboxPurchHdr: Record "Handled IC Inbox Purch. Header";
        HandledICInboxPurchLine: Record "Handled IC Inbox Purch. Line";
        HandledICInboxOutboxJnlLineDim: Record "IC Inbox/Outbox Jnl. Line Dim.";
        ICCommentLine: Record "IC Comment Line";
        HandledICCommentLine: Record "IC Comment Line";
    begin
        HandledICInboxTrans.LockTable;
        ICInboxTrans.LockTable;

        HandledICInboxTrans.Get(
          OutboxTrans."Transaction No.",OutboxTrans."IC Partner Code",
          ICInboxTrans."transaction source"::"Created by Partner",OutboxTrans."Document Type");
        ICInboxTrans.TransferFields(HandledICInboxTrans,true);
        ICInboxTrans."Line Action" := ICInboxTrans."line action"::"No Action";
        ICInboxTrans.Insert;
        HandledICInboxTrans.Delete;

        HandledICCommentLine.SetRange("Table Name",HandledICCommentLine."table name"::"Handled IC Inbox Transaction");
        HandledICCommentLine.SetRange("Transaction No.",HandledICInboxTrans."Transaction No.");
        HandledICCommentLine.SetRange("IC Partner Code",HandledICInboxTrans."IC Partner Code");
        HandledICCommentLine.SetRange("Transaction Source",HandledICInboxTrans."Transaction Source");
        if HandledICCommentLine.Find('-') then
          repeat
            ICCommentLine := HandledICCommentLine;
            ICCommentLine."Table Name" := ICCommentLine."table name"::"IC Inbox Transaction";
            ICCommentLine.Insert;
            HandledICCommentLine.Delete;
          until HandledICCommentLine.Next = 0;

        with HandledICInboxJnlLine do begin
          SetRange("Transaction No.",ICInboxTrans."Transaction No.");
          SetRange("IC Partner Code",ICInboxTrans."IC Partner Code");
          SetRange("Transaction Source",ICInboxTrans."Transaction Source");
          if Find('-') then
            repeat
              ICInboxJnlLine.TransferFields(HandledICInboxJnlLine,true);
              ICInboxJnlLine.Insert;
              HandledICInboxOutboxJnlLineDim.SetRange("Table ID",Database::"Handled IC Inbox Jnl. Line");
              HandledICInboxOutboxJnlLineDim.SetRange("Transaction No.","Transaction No.");
              HandledICInboxOutboxJnlLineDim.SetRange("IC Partner Code","IC Partner Code");
              if HandledICInboxOutboxJnlLineDim.Find('-') then
                repeat
                  ICInboxOutboxJnlLineDim := HandledICInboxOutboxJnlLineDim;
                  ICInboxOutboxJnlLineDim."Table ID" := Database::"IC Inbox Jnl. Line";
                  ICInboxOutboxJnlLineDim.Insert;
                  HandledICInboxOutboxJnlLineDim.Delete;
                until HandledICInboxOutboxJnlLineDim.Next = 0;
              Delete;
            until Next = 0;
        end;

        with HandledICInboxSalesHdr do begin
          SetRange("IC Transaction No.",ICInboxTrans."Transaction No.");
          SetRange("IC Partner Code",ICInboxTrans."IC Partner Code");
          SetRange("Transaction Source",ICInboxTrans."Transaction Source");
          if Find('-') then
            repeat
              ICInboxSalesHdr.TransferFields(HandledICInboxSalesHdr,true);
              ICInboxSalesHdr.Insert;
              MoveHandledICDocDim(
                Database::"Handled IC Inbox Sales Header",Database::"IC Inbox Sales Header",
                "IC Transaction No.","IC Partner Code");

              HandledICInboxSalesLine.SetRange("IC Transaction No.","IC Transaction No.");
              HandledICInboxSalesLine.SetRange("IC Partner Code","IC Partner Code");
              HandledICInboxSalesLine.SetRange("Transaction Source","Transaction Source");
              if HandledICInboxSalesLine.Find('-') then
                repeat
                  ICInboxSalesLine.TransferFields(HandledICInboxSalesLine,true);
                  ICInboxSalesLine.Insert;
                  MoveHandledICDocDim(
                    Database::"Handled IC Inbox Sales Line",Database::"IC Inbox Sales Line",
                    "IC Transaction No.","IC Partner Code");
                  HandledICInboxSalesLine.Delete;
                until HandledICInboxSalesLine.Next = 0;
              Delete;
            until Next = 0;
        end;

        with HandledICInboxPurchHdr do begin
          SetRange("IC Transaction No.",ICInboxTrans."Transaction No.");
          SetRange("IC Partner Code",ICInboxTrans."IC Partner Code");
          SetRange("Transaction Source",ICInboxTrans."Transaction Source");
          if Find('-') then
            repeat
              ICInboxPurchHdr.TransferFields(HandledICInboxPurchHdr,true);
              ICInboxPurchHdr.Insert;
              MoveHandledICDocDim(
                Database::"Handled IC Inbox Purch. Header",Database::"IC Inbox Purchase Header",
                "IC Transaction No.","IC Partner Code");

              HandledICInboxPurchLine.SetRange("IC Transaction No.","IC Transaction No.");
              HandledICInboxPurchLine.SetRange("IC Partner Code","IC Partner Code");
              HandledICInboxPurchLine.SetRange("Transaction Source","Transaction Source");
              if HandledICInboxPurchLine.Find('-') then
                repeat
                  ICInboxPurchLine.TransferFields(HandledICInboxPurchLine,true);
                  ICInboxPurchLine.Insert;
                  MoveHandledICDocDim(
                    Database::"Handled IC Inbox Purch. Line",Database::"IC Inbox Purchase Line",
                    "IC Transaction No.","IC Partner Code");
                  HandledICInboxPurchLine.Delete;
                until HandledICInboxPurchLine.Next = 0;
              Delete;
            until Next = 0;
        end;
    end;

    local procedure MoveHandledICDocDim(FromTableID: Integer;ToTableID: Integer;TransactionNo: Integer;PartnerCode: Code[20])
    var
        ICDocDim: Record "IC Document Dimension";
        HandledICDocDim: Record "IC Document Dimension";
    begin
        HandledICDocDim.SetRange("Table ID",FromTableID);
        HandledICDocDim.SetRange("Transaction No.",TransactionNo);
        HandledICDocDim.SetRange("IC Partner Code",PartnerCode);
        if HandledICDocDim.Find('-') then
          repeat
            ICDocDim := HandledICDocDim;
            ICDocDim."Table ID" := ToTableID;
            ICDocDim.Insert;
            HandledICDocDim.Delete;
          until HandledICDocDim.Next = 0;
    end;
}

