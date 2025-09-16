#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 698 "Get Sales Orders"
{
    Caption = 'Get Sales Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line";"Sales Line")
        {
            DataItemTableView = where("Document Type"=const(Order),Type=const(Item),"Purch. Order Line No."=const(0),"Outstanding Quantity"=filter(<>0));
            RequestFilterFields = "Document No.","Sell-to Customer No.","No.";
            RequestFilterHeading = 'Sales Order Line';
            column(ReportForNavId_2844; 2844)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ("Purchasing Code" = '') and (SpecOrder <> 1)then
                  if "Drop Shipment" then begin
                    LineCount := LineCount + 1;
                    Window.Update(1,LineCount);
                    InsertReqWkshLine("Sales Line");
                  end;

                if "Purchasing Code" <> '' then
                  if PurchasingCode.Get("Purchasing Code") then
                    if PurchasingCode."Drop Shipment" and (SpecOrder <> 1) then begin
                      LineCount := LineCount + 1;
                      Window.Update(1,LineCount);
                      InsertReqWkshLine("Sales Line");
                    end else
                      if PurchasingCode."Special Order" and
                         ("Special Order Purchase No." = '') and
                         (SpecOrder <> 0)
                      then begin
                        LineCount := LineCount + 1;
                        Window.Update(1,LineCount);
                        InsertReqWkshLine("Sales Line");
                      end;
            end;

            trigger OnPostDataItem()
            begin
                if LineCount = 0 then
                  Error(Text001);
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
                    field(GetDim;GetDim)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Retrieve dimensions from';
                        OptionCaption = 'Item,Sales Line';
                        ToolTip = 'Specifies the source of dimensions that will be copied in the batch job. Dimensions can be copied exactly as they were used on a sales line or can be copied from the items used on a sales line.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ReqWkshTmpl.Get(ReqLine."Worksheet Template Name");
        ReqWkshName.Get(ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name");
        ReqLine.SetRange("Worksheet Template Name",ReqLine."Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name",ReqLine."Journal Batch Name");
        ReqLine.LockTable;
        if ReqLine.FindLast then begin
          ReqLine.Init;
          LineNo := ReqLine."Line No.";
        end;
        Window.Open(Text000);
    end;

    var
        Text000: label 'Processing sales lines  #1######';
        Text001: label 'There are no sales lines to retrieve.';
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        SalesHeader: Record "Sales Header";
        PurchasingCode: Record Purchasing;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        Window: Dialog;
        LineCount: Integer;
        SpecOrder: Integer;
        GetDim: Option Item,"Sales Line";
        LineNo: Integer;


    procedure SetReqWkshLine(NewReqLine: Record "Requisition Line";SpecialOrder: Integer)
    begin
        ReqLine := NewReqLine;
        SpecOrder := SpecialOrder;
    end;

    local procedure InsertReqWkshLine(SalesLine: Record "Sales Line")
    begin
        ReqLine.Reset;
        ReqLine.SetCurrentkey(Type,"No.");
        ReqLine.SetRange(Type,"Sales Line".Type);
        ReqLine.SetRange("No.","Sales Line"."No.");
        ReqLine.SetRange("Sales Order No.","Sales Line"."Document No.");
        ReqLine.SetRange("Sales Order Line No.","Sales Line"."Line No.");
        if ReqLine.FindFirst then
          exit;

        LineNo := LineNo + 10000;
        Clear(ReqLine);
        ReqLine.SetDropShipment(SalesLine."Drop Shipment");
        with ReqLine do begin
          Init;
          "Worksheet Template Name" := ReqWkshName."Worksheet Template Name";
          "Journal Batch Name" := ReqWkshName.Name;
          "Line No." := LineNo;
          Validate(Type,SalesLine.Type);
          Validate("No.",SalesLine."No.");
          "Variant Code" := SalesLine."Variant Code";
          Validate("Location Code",SalesLine."Location Code");
          "Bin Code" := SalesLine."Bin Code";

          // Drop Shipment means replenishment by purchase only
          if ("Replenishment System" <> "replenishment system"::Purchase) and
             SalesLine."Drop Shipment"
          then
            Validate("Replenishment System","replenishment system"::Purchase);

          if SpecOrder <> 1 then
            Validate("Unit of Measure Code",SalesLine."Unit of Measure Code");
          Validate(
            Quantity,
            ROUND(SalesLine."Outstanding Quantity" * SalesLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure",0.00001));
          "Sales Order No." := SalesLine."Document No.";
          "Sales Order Line No." := SalesLine."Line No.";
          "Sell-to Customer No." := SalesLine."Sell-to Customer No.";
          Description := SalesLine.Description;
          "Description 2" := SalesLine."Description 2";
          SalesHeader.Get(1,SalesLine."Document No.");
          if SpecOrder <> 1 then
            "Ship-to Code" := SalesHeader."Ship-to Code";
          "Item Category Code" := SalesLine."Item Category Code";
          Nonstock := SalesLine.Nonstock;
          "Action Message" := "action message"::New;
          "Purchasing Code" := SalesLine."Purchasing Code";
          // Backward Scheduling
          "Due Date" := SalesLine."Shipment Date";
          "Ending Date" :=
            LeadTimeMgt.PlannedEndingDate(
              "No.","Location Code","Variant Code","Due Date","Vendor No.","Ref. Order Type");
          CalcStartingDate('');
          UpdateDatetime;

          Insert;
          ItemTrackingMgt.CopyItemTracking(SalesLine.RowID1,RowID1,true);
          if GetDim = Getdim::"Sales Line" then begin
            "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := SalesLine."Dimension Set ID";
            Modify;
          end;
        end;
    end;


    procedure InitializeRequest(NewRetrieveDimensionsFrom: Option)
    begin
        GetDim := NewRetrieveDimensionsFrom;
    end;
}

