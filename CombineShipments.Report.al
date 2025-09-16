#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 295 "Combine Shipments"
{
    Caption = 'Combine Shipments';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(SalesOrderHeader;"Sales Header")
        {
            DataItemTableView = sorting("Document Type","Combine Shipments","Bill-to Customer No.","Currency Code","EU 3-Party Trade","Dimension Set ID") where("Document Type"=const(Order),"Combine Shipments"=const(true));
            RequestFilterFields = "Sell-to Customer No.","Bill-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            column(ReportForNavId_2495; 2495)
            {
            }
            dataitem("Sales Shipment Header";"Sales Shipment Header")
            {
                DataItemLink = "Order No."=field("No.");
                DataItemTableView = sorting("Order No.");
                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Posted Sales Shipment';
                column(ReportForNavId_3595; 3595)
                {
                }
                dataitem("Sales Shipment Line";"Sales Shipment Line")
                {
                    DataItemLink = "Document No."=field("No.");
                    DataItemTableView = sorting("Document No.","Line No.");
                    column(ReportForNavId_2502; 2502)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Type = 0 then begin
                          if (not CopyTextLines) or ("Attached to Line No." <> 0) then
                            CurrReport.Skip;
                        end;

                        if "Authorized for Credit Card" then
                          CurrReport.Skip;

                        if ("Qty. Shipped Not Invoiced" <> 0) or (Type = 0) then begin
                          if ("Bill-to Customer No." <> Cust."No.") and
                             ("Sell-to Customer No." <> '')
                          then
                            Cust.Get("Bill-to Customer No.");
                          if not (Cust.Blocked in [Cust.Blocked::All,Cust.Blocked::Invoice]) then begin
                            if (SalesOrderHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") or
                               (SalesOrderHeader."Currency Code" <> SalesHeader."Currency Code") or
                               (SalesOrderHeader."EU 3-Party Trade" <> SalesHeader."EU 3-Party Trade") or
                               (SalesOrderHeader."Dimension Set ID" <> SalesHeader."Dimension Set ID")
                            then begin
                              if SalesHeader."No." <> '' then
                                FinalizeSalesInvHeader;
                              InsertSalesInvHeader;
                              SalesLine.SetRange("Document Type",SalesHeader."Document Type");
                              SalesLine.SetRange("Document No.",SalesHeader."No.");
                              SalesLine."Document Type" := SalesHeader."Document Type";
                              SalesLine."Document No." := SalesHeader."No.";
                            end;
                            SalesShptLine := "Sales Shipment Line";
                            HasAmount := HasAmount or ("Qty. Shipped Not Invoiced" <> 0);
                            SalesShptLine.InsertInvLineFromShptLine(SalesLine);
                          end else
                            NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
                        end;
                    end;

                    trigger OnPostDataItem()
                    var
                        SalesShipmentLine: Record "Sales Shipment Line";
                        SalesLineInvoice: Record "Sales Line";
                        SalesGetShpt: Codeunit "Sales-Get Shipment";
                    begin
                        SalesShipmentLine.SetRange("Document No.","Document No.");
                        SalesShipmentLine.SetRange(Type,Type::"Charge (Item)");
                        if SalesShipmentLine.FindSet then
                          repeat
                            SalesLineInvoice.SetRange("Document Type",SalesLineInvoice."document type"::Invoice);
                            SalesLineInvoice.SetRange("Document No.",SalesHeader."No.");
                            SalesLineInvoice.SetRange("Shipment Line No.",SalesShipmentLine."Line No.");
                            if SalesLineInvoice.FindFirst then
                              SalesGetShpt.GetItemChargeAssgnt(SalesShipmentLine,SalesLineInvoice."Qty. to Invoice");
                          until SalesShipmentLine.Next = 0;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    DueDate: Date;
                    PmtDiscDate: Date;
                    PmtDiscPct: Decimal;
                begin
                    Window.Update(3,"No.");

                    if IsCompletlyInvoiced then
                      CurrReport.Skip;

                    if OnlyStdPmtTerms then begin
                      Cust.Get("Bill-to Customer No.");
                      PmtTerms.Get(Cust."Payment Terms Code");
                      if PmtTerms.Code = "Payment Terms Code" then begin
                        DueDate := CalcDate(PmtTerms."Due Date Calculation","Document Date");
                        PmtDiscDate := CalcDate(PmtTerms."Discount Date Calculation","Document Date");
                        PmtDiscPct := PmtTerms."Discount %";
                        if (DueDate <> "Due Date") or
                           (PmtDiscDate <> "Pmt. Discount Date") or
                           (PmtDiscPct <> "Payment Discount %")
                        then begin
                          NoOfskippedShiment := NoOfskippedShiment + 1;
                          CurrReport.Skip;
                        end;
                      end else begin
                        NoOfskippedShiment := NoOfskippedShiment + 1;
                        CurrReport.Skip;
                      end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                Window.Update(1,"Bill-to Customer No.");
                Window.Update(2,"No.");
            end;

            trigger OnPostDataItem()
            begin
                CurrReport.Language := GlobalLanguage;
                Window.Close;
                if SalesHeader."No." <> '' then begin // Not the first time
                  FinalizeSalesInvHeader;
                  if (NoOfSalesInvErrors = 0) and not HideDialog then begin
                    if NoOfskippedShiment > 0 then begin
                      Message(
                        Text011,
                        NoOfSalesInv,NoOfskippedShiment)
                    end else
                      Message(
                        Text010,
                        NoOfSalesInv);
                  end else
                    if not HideDialog then
                      if PostInv then
                        Message(
                          Text007,
                          NoOfSalesInvErrors)
                      else
                        Message(
                          NotAllInvoicesCreatedMsg,
                          NoOfSalesInvErrors)
                end else
                  if not HideDialog then
                    Message(Text008);
            end;

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                  Error(Text000);
                if DocDateReq = 0D then
                  Error(Text001);

                Window.Open(
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate;PostingDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(DocDateReq;DocDateReq)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document Date';
                    }
                    field(CalcInvDisc;CalcInvDisc)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calc. Inv. Discount';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get;
                            SalesSetup.TestField("Calc. Inv. Discount",false);
                        end;
                    }
                    field(PostInv;PostInv)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Post Invoices';
                    }
                    field(OnlyStdPmtTerms;OnlyStdPmtTerms)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Std. Payment Terms';
                    }
                    field(CopyTextLines;CopyTextLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Copy Text Lines';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
              PostingDateReq := WorkDate;
            if DocDateReq = 0D then
              DocDateReq := WorkDate;
            SalesSetup.Get;
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Enter the document date.';
        Text002: label 'Combining shipments...\\';
        Text003: label 'Customer No.    #1##########\';
        Text004: label 'Order No.       #2##########\';
        Text005: label 'Shipment No.    #3##########';
        Text007: label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text008: label 'There is nothing to combine.';
        Text010: label 'The shipments are now combined and the number of invoices created is %1.';
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        Language: Record Language;
        PmtTerms: Record "Payment Terms";
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvDisc: Boolean;
        PostInv: Boolean;
        OnlyStdPmtTerms: Boolean;
        HasAmount: Boolean;
        HideDialog: Boolean;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        Text011: label 'The shipments are now combined, and the number of invoices created is %1.\%2 Shipments with nonstandard payment terms have not been combined.', Comment='%1-Number of invoices,%2-Number Of shipments';
        NoOfskippedShiment: Integer;
        CopyTextLines: Boolean;
        NotAllInvoicesCreatedMsg: label 'Not all the invoices were created. A total of %1 invoices were not created.';

    local procedure FinalizeSalesInvHeader()
    begin
        with SalesHeader do begin
          if not HasAmount then begin
            Delete(true);
            exit;
          end;
          if CalcInvDisc then
            SalesCalcDisc.Run(SalesLine);
          Find;
          Commit;
          Clear(SalesCalcDisc);
          Clear(SalesPost);
          NoOfSalesInv := NoOfSalesInv + 1;
          if PostInv then begin
            Clear(SalesPost);
            if not SalesPost.Run(SalesHeader) then
              NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
          end;
        end;
    end;

    local procedure InsertSalesInvHeader()
    begin
        Clear(SalesHeader);
        with SalesHeader do begin
          Init;
          "Document Type" := "document type"::Invoice;
          "No." := '';
          Insert(true);
          Validate("Sell-to Customer No.",SalesOrderHeader."Bill-to Customer No.");
          if "Bill-to Customer No." <> "Sell-to Customer No." then
            Validate("Bill-to Customer No.",SalesOrderHeader."Bill-to Customer No.");
          Validate("Posting Date",PostingDateReq);
          Validate("Document Date",DocDateReq);
          Validate("Currency Code",SalesOrderHeader."Currency Code");
          Validate("EU 3-Party Trade",SalesOrderHeader."EU 3-Party Trade");
          "Salesperson Code" := SalesOrderHeader."Salesperson Code";
          "Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
          "Dimension Set ID" := SalesOrderHeader."Dimension Set ID";
          Modify;
          Commit;
          HasAmount := false;
        end;
    end;


    procedure InitializeRequest(NewPostingDate: Date;NewDocDate: Date;NewCalcInvDisc: Boolean;NewPostInv: Boolean;NewOnlyStdPmtTerms: Boolean;NewCopyTextLines: Boolean)
    begin
        PostingDateReq := NewPostingDate;
        DocDateReq := NewDocDate;
        CalcInvDisc := NewCalcInvDisc;
        PostInv := NewPostInv;
        OnlyStdPmtTerms := NewOnlyStdPmtTerms;
        CopyTextLines := NewCopyTextLines;
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

