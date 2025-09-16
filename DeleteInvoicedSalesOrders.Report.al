#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 299 "Delete Invoiced Sales Orders"
{
    Caption = 'Delete Invoiced Sales Orders';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.","Sell-to Customer No.","Bill-to Customer No.";
            RequestFilterHeading = 'Sales Order';
            column(ReportForNavId_6640; 6640)
            {
            }

            trigger OnAfterGetRecord()
            var
                ATOLink: Record "Assemble-to-Order Link";
                ReserveSalesLine: Codeunit "Sales Line-Reserve";
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                PostSalesDelete: Codeunit "PostSales-Delete";
            begin
                Window.Update(1,"No.");

                AllLinesDeleted := true;
                ItemChargeAssgntSales.Reset;
                ItemChargeAssgntSales.SetRange("Document Type","Document Type");
                ItemChargeAssgntSales.SetRange("Document No.","No.");
                SalesOrderLine.Reset;
                SalesOrderLine.SetRange("Document Type","Document Type");
                SalesOrderLine.SetRange("Document No.","No.");
                SalesOrderLine.SetFilter("Quantity Invoiced",'<>0');
                if SalesOrderLine.Find('-') then begin
                  SalesOrderLine.SetRange("Quantity Invoiced");
                  SalesOrderLine.SetFilter("Outstanding Quantity",'<>0');
                  if not SalesOrderLine.Find('-') then begin
                    SalesOrderLine.SetRange("Outstanding Quantity");
                    SalesOrderLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');
                    if not SalesOrderLine.Find('-') then begin
                      SalesOrderLine.LockTable;
                      if not SalesOrderLine.Find('-') then begin
                        SalesOrderLine.SetRange("Qty. Shipped Not Invoiced");
                        if SalesOrderLine.Find('-') then
                          repeat
                            SalesOrderLine.CalcFields("Qty. Assigned");
                            if ((SalesOrderLine."Qty. Assigned" = SalesOrderLine."Quantity Invoiced") and
                                (SalesOrderLine."Qty. Assigned" <> 0)) or
                               (SalesOrderLine.Type <> SalesOrderLine.Type::"Charge (Item)")
                            then begin
                              if SalesOrderLine.Type = SalesOrderLine.Type::"Charge (Item)" then begin
                                ItemChargeAssgntSales.SetRange("Document Line No.",SalesOrderLine."Line No.");
                                ItemChargeAssgntSales.DeleteAll;
                              end;
                              if SalesOrderLine.Type = SalesOrderLine.Type::Item then
                                ATOLink.DeleteAsmFromSalesLine(SalesOrderLine);
                              if SalesOrderLine.HasLinks then
                                SalesOrderLine.DeleteLinks;
                              SalesOrderLine.Delete;
                            end else
                              AllLinesDeleted := false;
                            UpdateAssPurchOrder;
                          until SalesOrderLine.Next = 0;

                        if AllLinesDeleted then begin
                          PostSalesDelete.DeleteHeader(
                            "Sales Header",SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
                            PrepmtSalesInvHeader,PrepmtSalesCrMemoHeader);

                          ReserveSalesLine.DeleteInvoiceSpecFromHeader("Sales Header");

                          SalesCommentLine.SetRange("Document Type","Document Type");
                          SalesCommentLine.SetRange("No.","No.");
                          SalesCommentLine.DeleteAll;

                          WhseRequest.SetRange("Source Type",Database::"Sales Line");
                          WhseRequest.SetRange("Source Subtype","Document Type");
                          WhseRequest.SetRange("Source No.","No.");
                          if not WhseRequest.IsEmpty then
                            WhseRequest.DeleteAll(true);

                          ApprovalsMgmt.DeleteApprovalEntry("Sales Header");

                          if HasLinks then
                            DeleteLinks;
                          Delete;
                        end;
                        Commit;
                      end;
                    end;
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000);
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
        Text000: label 'Processing sales orders #1##########';
        SalesOrderLine: Record "Sales Line";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        PrepmtSalesInvHeader: Record "Sales Invoice Header";
        PrepmtSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCommentLine: Record "Sales Comment Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        WhseRequest: Record "Warehouse Request";
        Window: Dialog;
        AllLinesDeleted: Boolean;

    local procedure UpdateAssPurchOrder()
    var
        PurchLine: Record "Purchase Line";
    begin
        if not SalesOrderLine."Special Order" then
          exit;
        with PurchLine do begin
          Reset;
          SetRange("Special Order Sales No.",SalesOrderLine."Document No.");
          SetRange("Special Order Sales Line No.",SalesOrderLine."Line No.");
          SetRange("Purchasing Code",SalesOrderLine."Purchasing Code");
          if FindFirst then begin
            "Special Order Sales No." := '';
            "Special Order Sales Line No." := 0;
            Modify;
          end;
        end;
    end;
}

