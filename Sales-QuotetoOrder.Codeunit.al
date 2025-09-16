#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 86 "Sales-Quote to Order"
{
    TableNo = "Sales Header";

    trigger OnRun()
    var
        OldSalesCommentLine: Record "Sales Comment Line";
        Cust: Record Customer;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        RecordLinkManagement: Codeunit "Record Link Management";
        ShouldRedistributeInvoiceAmount: Boolean;
    begin
        TestField("Document Type","document type"::Quote);
        ShouldRedistributeInvoiceAmount := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

        OnCheckSalesPostRestrictions;

        Cust.Get("Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust,"document type"::Order,true,false);
        CalcFields("Amount Including VAT","Work Description");
        SalesOrderHeader := Rec;
        if GuiAllowed and not HideValidationDialog then
          CustCheckCreditLimit.SalesHeaderCheck(SalesOrderHeader);
        SalesOrderHeader."Document Type" := SalesOrderHeader."document type"::Order;

        CheckAvailability(Rec);
        CheckInProgressOpportunities(Rec);

        SalesOrderHeader."No. Printed" := 0;
        SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
        SalesOrderHeader."No." := '';
        SalesOrderHeader."Quote No." := "No.";
        SalesOrderLine.LockTable;
        SalesOrderHeader.Insert(true);

        SalesOrderHeader."Order Date" := "Order Date";
        if "Posting Date" <> 0D then
          SalesOrderHeader."Posting Date" := "Posting Date";

        SalesOrderHeader.InitFromSalesHeader(Rec);
        SalesOrderHeader."Outbound Whse. Handling Time" := "Outbound Whse. Handling Time";
        SalesOrderHeader.Reserve := Reserve;

        SalesOrderHeader."Prepayment %" := Cust."Prepayment %";
        if SalesOrderHeader."Posting Date" = 0D then
          SalesOrderHeader."Posting Date" := WorkDate;

        SalesOrderHeader.Modify;
        TransferQuoteToSalesOrderLines(SalesQuoteLine,Rec,SalesOrderLine,SalesOrderHeader,Cust);

        SalesSetup.Get;
        if SalesSetup."Archive Quotes and Orders" then
          ArchiveManagement.ArchSalesDocumentNoConfirm(Rec);

        if SalesSetup."Default Posting Date" = SalesSetup."default posting date"::"No Date" then begin
          SalesOrderHeader."Posting Date" := 0D;
          SalesOrderHeader.Modify;
        end;

        SalesCommentLine.SetRange("Document Type","Document Type");
        SalesCommentLine.SetRange("No.","No.");
        if not SalesCommentLine.IsEmpty then begin
          SalesCommentLine.LockTable;
          if SalesCommentLine.FindSet then
            repeat
              OldSalesCommentLine := SalesCommentLine;
              SalesCommentLine.Delete;
              SalesCommentLine."Document Type" := SalesOrderHeader."Document Type";
              SalesCommentLine."No." := SalesOrderHeader."No.";
              SalesCommentLine.Insert;
              SalesCommentLine := OldSalesCommentLine;
            until SalesCommentLine.Next = 0;
        end;
        RecordLinkManagement.CopyLinks(Rec,SalesOrderHeader);

        ItemChargeAssgntSales.Reset;
        ItemChargeAssgntSales.SetRange("Document Type","Document Type");
        ItemChargeAssgntSales.SetRange("Document No.","No.");
        while ItemChargeAssgntSales.FindFirst do begin
          ItemChargeAssgntSales.Delete;
          ItemChargeAssgntSales."Document Type" := SalesOrderHeader."Document Type";
          ItemChargeAssgntSales."Document No." := SalesOrderHeader."No.";
          if not (ItemChargeAssgntSales."Applies-to Doc. Type" in
                  [ItemChargeAssgntSales."applies-to doc. type"::Shipment,
                   ItemChargeAssgntSales."applies-to doc. type"::"Return Receipt"])
          then begin
            ItemChargeAssgntSales."Applies-to Doc. Type" := SalesOrderHeader."Document Type";
            ItemChargeAssgntSales."Applies-to Doc. No." := SalesOrderHeader."No.";
          end;
          ItemChargeAssgntSales.Insert;
        end;

        MoveWonLostOpportunites(Rec,SalesOrderHeader);

        ApprovalsMgmt.CopyApprovalEntryQuoteToOrder(Database::"Sales Header","No.",SalesOrderHeader."No.",SalesOrderHeader.RecordId);
        ApprovalsMgmt.DeleteApprovalEntry(Rec);

        DeleteLinks;
        Delete;

        SalesQuoteLine.DeleteAll;

        if not ShouldRedistributeInvoiceAmount then
          SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SalesOrderHeader);
        Commit;
        Clear(CustCheckCreditLimit);
        Clear(ItemCheckAvail);
    end;

    var
        Text000: label 'An open %1 is linked to this %2. The %1 has to be closed before the %2 can be converted to an %3. Do you want to close the %1 now and continue the conversion?', Comment='An open Opportunity is linked to this Quote. The Opportunity has to be closed before the Quote can be converted to an Order. Do you want to close the Opportunity now and continue the conversion?';
        Text001: label 'An open %1 is still linked to this %2. The conversion to an %3 was aborted.', Comment='An open Opportunity is still linked to this Quote. The conversion to an Order was aborted.';
        SalesQuoteLine: Record "Sales Line";
        SalesLine: Record "Sales Line";
        SalesOrderHeader: Record "Sales Header";
        SalesOrderLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        ArchiveManagement: Codeunit ArchiveManagement;
        HideValidationDialog: Boolean;


    procedure GetSalesOrderHeader(var SalesHeader2: Record "Sales Header")
    begin
        SalesHeader2 := SalesOrderHeader;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure CheckInProgressOpportunities(var SalesHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type","Sales Document No.");
        Opp.SetRange("Sales Document Type",Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.",SalesHeader."No.");
        Opp.SetRange(Status,Opp.Status::"In Progress");
        if Opp.FindFirst then begin
          if not Confirm(Text000,true,Opp.TableCaption,Opp."sales document type"::Quote,Opp."sales document type"::Order) then
            Error('');
          TempOpportunityEntry.DeleteAll;
          TempOpportunityEntry.Init;
          TempOpportunityEntry.Validate("Opportunity No.",Opp."No.");
          TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
          TempOpportunityEntry."Contact No." := Opp."Contact No.";
          TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
          TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
          TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
          TempOpportunityEntry."Action Taken" := TempOpportunityEntry."action taken"::Won;
          TempOpportunityEntry."Wizard Step" := 1;
          TempOpportunityEntry.Insert;
          TempOpportunityEntry.SetRange("Action Taken",TempOpportunityEntry."action taken"::Won);
          Page.RunModal(Page::"Close Opportunity",TempOpportunityEntry);
          Opp.Reset;
          Opp.SetCurrentkey("Sales Document Type","Sales Document No.");
          Opp.SetRange("Sales Document Type",Opp."sales document type"::Quote);
          Opp.SetRange("Sales Document No.",SalesHeader."No.");
          Opp.SetRange(Status,Opp.Status::"In Progress");
          if Opp.FindFirst then
            Error(Text001,Opp.TableCaption,Opp."sales document type"::Quote,Opp."sales document type"::Order);
          Commit;
          SalesHeader.Get(SalesHeader."Document Type",SalesHeader."No.");
        end;
    end;

    local procedure MoveWonLostOpportunites(var SalesQuoteHeader: Record "Sales Header";var SalesOrderHeader: Record "Sales Header")
    var
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
    begin
        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type","Sales Document No.");
        Opp.SetRange("Sales Document Type",Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.",SalesQuoteHeader."No.");
        if Opp.FindFirst then
          if Opp.Status = Opp.Status::Won then begin
            Opp."Sales Document Type" := Opp."sales document type"::Order;
            Opp."Sales Document No." := SalesOrderHeader."No.";
            Opp.Modify;
            OpportunityEntry.Reset;
            OpportunityEntry.SetCurrentkey(Active,"Opportunity No.");
            OpportunityEntry.SetRange(Active,true);
            OpportunityEntry.SetRange("Opportunity No.",Opp."No.");
            if OpportunityEntry.FindFirst then begin
              OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesOrderHeader);
              OpportunityEntry.Modify;
            end;
          end else
            if Opp.Status = Opp.Status::Lost then begin
              Opp."Sales Document Type" := Opp."sales document type"::" ";
              Opp."Sales Document No." := '';
              Opp.Modify;
            end;
    end;

    local procedure CheckAvailability(SalesQuoteHeader: Record "Sales Header")
    begin
        SalesQuoteLine.SetRange("Document Type",SalesQuoteHeader."Document Type");
        SalesQuoteLine.SetRange("Document No.",SalesQuoteHeader."No.");
        SalesQuoteLine.SetRange(Type,SalesQuoteLine.Type::Item);
        SalesQuoteLine.SetFilter("No.",'<>%1','');
        if SalesQuoteLine.FindSet then
          repeat
            if SalesQuoteLine."Outstanding Quantity" > 0 then begin
              SalesLine := SalesQuoteLine;
              SalesLine.Validate("Reserved Qty. (Base)",0);
              SalesLine."Outstanding Quantity" -= SalesLine."Qty. to Assemble to Order";
              SalesLine."Outstanding Qty. (Base)" -= SalesLine."Qty. to Asm. to Order (Base)";
              if GuiAllowed and not HideValidationDialog then
                if ItemCheckAvail.SalesLineCheck(SalesLine) then
                  ItemCheckAvail.RaiseUpdateInterruptedError;
            end;
          until SalesQuoteLine.Next = 0;
    end;

    local procedure TransferQuoteToSalesOrderLines(var QuoteSalesLine: Record "Sales Line";var QuoteSalesHeader: Record "Sales Header";var OrderSalesLine: Record "Sales Line";var OrderSalesHeader: Record "Sales Header";Customer: Record Customer)
    var
        ATOLink: Record "Assemble-to-Order Link";
    begin
        QuoteSalesLine.Reset;
        QuoteSalesLine.SetRange("Document Type",QuoteSalesHeader."Document Type");
        QuoteSalesLine.SetRange("Document No.",QuoteSalesHeader."No.");
        if QuoteSalesLine.FindSet then
          repeat
            OrderSalesLine := QuoteSalesLine;
            OrderSalesLine."Document Type" := OrderSalesHeader."Document Type";
            OrderSalesLine."Document No." := OrderSalesHeader."No.";
            OrderSalesLine."Shortcut Dimension 1 Code" := QuoteSalesLine."Shortcut Dimension 1 Code";
            OrderSalesLine."Shortcut Dimension 2 Code" := QuoteSalesLine."Shortcut Dimension 2 Code";
            OrderSalesLine."Dimension Set ID" := QuoteSalesLine."Dimension Set ID";
            if Customer."Prepayment %" <> 0 then
              OrderSalesLine."Prepayment %" := Customer."Prepayment %";
            PrepmtMgt.SetSalesPrepaymentPct(OrderSalesLine,OrderSalesHeader."Posting Date");
            OrderSalesLine.Validate("Prepayment %");
            if OrderSalesLine."No." <> '' then
              OrderSalesLine.DefaultDeferralCode;

            OrderSalesLine.Insert;
            ATOLink.MakeAsmOrderLinkedToSalesOrderLine(QuoteSalesLine,OrderSalesLine);
            ReserveSalesLine.TransferSaleLineToSalesLine(
              QuoteSalesLine,OrderSalesLine,QuoteSalesLine."Outstanding Qty. (Base)");
            ReserveSalesLine.VerifyQuantity(OrderSalesLine,QuoteSalesLine);

            if OrderSalesLine.Reserve = OrderSalesLine.Reserve::Always then
              OrderSalesLine.AutoReserve;

          until QuoteSalesLine.Next = 0;
    end;
}

