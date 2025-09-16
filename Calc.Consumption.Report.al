#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5405 "Calc. Consumption"
{
    Caption = 'Calc. Consumption';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Production Order";"Production Order")
        {
            DataItemTableView = sorting(Status,"No.") where(Status=const(Released));
            RequestFilterFields = "No.";
            column(ReportForNavId_4824; 4824)
            {
            }
            dataitem("Prod. Order Component";"Prod. Order Component")
            {
                DataItemLink = Status=field(Status),"Prod. Order No."=field("No.");
                RequestFilterFields = "Item No.";
                column(ReportForNavId_7771; 7771)
                {
                }

                trigger OnAfterGetRecord()
                var
                    NeededQty: Decimal;
                begin
                    Window.Update(2,"Item No.");

                    Clear(ItemJnlLine);
                    Item.Get("Item No.");
                    ProdOrderLine.Get(Status,"Prod. Order No.","Prod. Order Line No.");

                    NeededQty := GetNeededQty(CalcBasedOn,true);

                    if NeededQty <> 0 then begin
                      if LocationCode <> '' then
                        CreateConsumpJnlLine(LocationCode,'',NeededQty)
                      else
                        CreateConsumpJnlLine("Location Code","Bin Code",NeededQty);
                      LastItemJnlLine := ItemJnlLine;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Flushing Method",'<>%1&<>%2',"flushing method"::Backward,"flushing method"::"Pick + Backward");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
            end;

            trigger OnPreDataItem()
            begin
                ItemJnlLine.SetRange("Journal Template Name",ToTemplateName);
                ItemJnlLine.SetRange("Journal Batch Name",ToBatchName);
                if ItemJnlLine.FindLast then
                  NextConsumpJnlLineNo := ItemJnlLine."Line No." + 10000
                else
                  NextConsumpJnlLineNo := 10000;

                Window.Open(
                  Text000 +
                  Text001 +
                  Text002 +
                  Text003);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                    }
                    field(CalcBasedOn;CalcBasedOn)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calculation Based on';
                        OptionCaption = 'Actual Output,Expected Output';
                    }
                    field(LocationCode;LocationCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Picking Location';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            Location: Record Location;
                        begin
                            if Page.RunModal(0,Location) = Action::LookupOK then begin
                              Text := Location.Code;
                              exit(true);
                            end;
                            exit(false);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitializeRequest(WorkDate,Calcbasedon::"Expected Output");
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Calculating consumption...\\';
        Text001: label 'Prod. Order No.   #1##########\';
        Text002: label 'Item No.          #2##########\';
        Text003: label 'Quantity          #3##########';
        Item: Record Item;
        ProdOrderLine: Record "Prod. Order Line";
        ItemJnlLine: Record "Item Journal Line";
        LastItemJnlLine: Record "Item Journal Line";
        Window: Dialog;
        PostingDate: Date;
        CalcBasedOn: Option "Actual Output","Expected Output";
        LocationCode: Code[10];
        ToTemplateName: Code[10];
        ToBatchName: Code[10];
        NextConsumpJnlLineNo: Integer;


    procedure InitializeRequest(NewPostingDate: Date;NewCalcBasedOn: Option)
    begin
        PostingDate := NewPostingDate;
        CalcBasedOn := NewCalcBasedOn;
    end;

    local procedure CreateConsumpJnlLine(LocationCode: Code[10];BinCode: Code[20];QtyToPost: Decimal)
    var
        Location: Record Location;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        Window.Update(3,QtyToPost);

        if Location.Get(LocationCode) and Location."Require Pick" and Location."Require Shipment" then
          "Prod. Order Component".AdjustQtyToQtyPicked(QtyToPost);

        if (ItemJnlLine."Item No." = "Prod. Order Component"."Item No.") and
           (LocationCode = ItemJnlLine."Location Code") and
           (BinCode = ItemJnlLine."Bin Code")
        then begin
          if Item."Rounding Precision" > 0 then
            ItemJnlLine.Validate(Quantity,ItemJnlLine.Quantity + ROUND(QtyToPost,Item."Rounding Precision",'>'))
          else
            ItemJnlLine.Validate(Quantity,ItemJnlLine.Quantity + ROUND(QtyToPost,0.00001));
          ItemJnlLine.Modify;
        end else begin
          ItemJnlLine.Init;
          ItemJnlLine."Journal Template Name" := ToTemplateName;
          ItemJnlLine."Journal Batch Name" := ToBatchName;
          ItemJnlLine.SetUpNewLine(LastItemJnlLine);
          ItemJnlLine."Line No." := NextConsumpJnlLineNo;

          ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::Consumption);
          ItemJnlLine.Validate("Order Type",ItemJnlLine."order type"::Production);
          ItemJnlLine.Validate("Order No.","Prod. Order Component"."Prod. Order No.");
          ItemJnlLine.Validate("Source No.",ProdOrderLine."Item No.");
          ItemJnlLine.Validate("Posting Date",PostingDate);
          ItemJnlLine.Validate("Item No.","Prod. Order Component"."Item No.");
          ItemJnlLine.Validate("Unit of Measure Code","Prod. Order Component"."Unit of Measure Code");
          ItemJnlLine.Description := "Prod. Order Component".Description;
          if Item."Rounding Precision" > 0 then
            ItemJnlLine.Validate(Quantity,ROUND(QtyToPost,Item."Rounding Precision",'>'))
          else
            ItemJnlLine.Validate(Quantity,ROUND(QtyToPost,0.00001));
          ItemJnlLine."Variant Code" := "Prod. Order Component"."Variant Code";
          ItemJnlLine.Validate("Location Code",LocationCode);
          if BinCode <> '' then
            ItemJnlLine."Bin Code" := BinCode;
          ItemJnlLine.Validate("Order Line No.","Prod. Order Component"."Prod. Order Line No.");
          ItemJnlLine.Validate("Prod. Order Comp. Line No.","Prod. Order Component"."Line No.");

          ItemJnlLine.Insert;
          if Item."Item Tracking Code" <> '' then
            ItemTrackingMgt.CopyItemTracking("Prod. Order Component".RowID1,ItemJnlLine.RowID1,false);
        end;

        NextConsumpJnlLineNo := NextConsumpJnlLineNo + 10000;
    end;


    procedure SetTemplateAndBatchName(TemplateName: Code[10];BatchName: Code[10])
    begin
        ToTemplateName := TemplateName;
        ToBatchName := BatchName;
    end;
}

