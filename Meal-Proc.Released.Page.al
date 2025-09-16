#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99909 "Meal-Proc. Released"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable99901;
    SourceTableView = where("BOM Count"=filter(>0),
                            Approve=filter(Yes),
                            Posted=filter(No),
                            "Required QTY"=filter(<>0));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filters';
                field(DateFil;DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batch Date';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
                        //CurrPage.UPDATE;
                    end;
                }
            }
            repeater(Group)
            {
                field("Item Code";"Item Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Production  Area";"Production  Area")
                {
                    ApplicationArea = Basic;
                }
                field("Required QTY";"Required QTY")
                {
                    ApplicationArea = Basic;
                }
                field("Requirered Unit of Measure";"Requirered Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("BOM Count";"BOM Count")
                {
                    ApplicationArea = Basic;
                }
                field("QTY in KGs";"QTY in KGs")
                {
                    ApplicationArea = Basic;
                }
                field("QTY in Tones";"QTY in Tones")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Serial";"Batch Serial")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic;
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(PostOrder)
                {
                    ApplicationArea = Basic;
                    Caption = '&Post Plan';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedIsBig = true;
                    ShortCutKey = 'F2';

                    trigger OnAction()
                    var
                        counted: Integer;
                    begin
                        Rec.TestField(Approve);
                        ProductionPermissions.Reset;
                        ProductionPermissions.SetRange("User Id",UserId);
                        if ProductionPermissions.Find('-') then begin
                            ProductionPermissions.TestField("Default Meal-Proc. Template");
                            ProductionPermissions.TestField("Default Meal-Proc. Batch");
                            ProductionPermissions.TestField("Default Raw Material Location");
                            ProductionPermissions.TestField("Default Product Location");
                          end else Error('Access Denied!');
                        if Confirm('Post Production?',true)=false then exit;
                        ItemJnlLine.Reset;
                        ItemJnlLine.SetRange("Journal Template Name",ToTemplateName);
                        ItemJnlLine.SetRange("Journal Batch Name",ToBatchName);
                        if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;

                        Clear(ToTemplateName);
                        Clear(ToBatchName);
                        ToTemplateName:=ProductionPermissions."Default Meal-Proc. Template";
                        ToBatchName:=ProductionPermissions."Default Meal-Proc. Batch";
                        ItemJnlTemplate.Reset;
                        ItemJnlTemplate.SetRange(Name,ToTemplateName);
                        if ItemJnlTemplate.Find('-') then begin
                        end;
                        ItemJnlBatch.Reset;
                        ItemJnlBatch.SetRange("Journal Template Name",ToTemplateName);
                        ItemJnlBatch.SetRange(Name,ToBatchName);
                        if ItemJnlBatch.Find('-') then begin
                        end;
                        ProductionBatchLines.Reset;
                        ProductionBatchLines.SetRange("Batch Date",DateFilter);
                        ProductionBatchLines.SetRange("Batch ID",Rec."Batch ID");
                        ProductionBatchLines.SetFilter(Posted,'%1',false);
                        if ProductionBatchLines.Find('-') then begin
                          repeat
                            begin
                        //////////////////////////////////////////////////////////////Post Consumption Journal
                        Clear(NextLineNo);
                        ItemJnlLine.Reset;
                        ItemJnlLine.SetRange("Journal Template Name",ToTemplateName);
                        ItemJnlLine.SetRange("Journal Batch Name",ToBatchName);
                        if ItemJnlLine.FindLast then NextLineNo:=ItemJnlLine."Line No.";
                        Clear(OrderLineNo);
                        ProductionBOMProdSource.Reset;
                        ProductionBOMProdSource.SetRange("Batch Date",ProductionBatchLines."Batch Date");
                        ProductionBOMProdSource.SetRange("Batch ID",Rec."Batch ID");
                        ProductionBOMProdSource.SetRange("Parent Item",ProductionBatchLines."Item Code");
                        //ProductionBOMProdSource.SETRANGE("Production  Area",ProductionBatchLines."Production  Area");
                        ProductionBOMProdSource.SetFilter("Consumption Quantiry",'<>0');
                        if ProductionBOMProdSource.Find('-') then begin
                        repeat
                        begin
                        NextLineNo:=NextLineNo+1000;
                        OrderLineNo:=OrderLineNo+100;
                          ItemJnlLine.Init;
                          ItemJnlLine."Journal Template Name" := ToTemplateName;
                          ItemJnlLine."Journal Batch Name" := ToBatchName;
                          ItemJnlLine."Line No." := NextLineNo;
                          ItemJnlLine.Validate("Posting Date",ProductionBOMProdSource."Batch Date");
                          ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::"Negative Adjmt.");
                          ItemJnlLine."Document Date":=ProductionBOMProdSource."Batch Date";
                          ItemJnlLine."Document No.":=ProductionBatchLines."Batch Serial";
                        //  ItemJnlLine.."Document Type":=ItemJnlLine.."Document Type"::
                          ItemJnlLine."Document Line No.":=NextLineNo;
                          //ItemJnlLine."Order Type":=ItemJnlLine."Order Type"::Production;
                          ItemJnlLine."Order No.":=ProductionBatchLines."Batch Serial";
                          ItemJnlLine.Validate("Source No.",ProductionBOMProdSource."Item No.");
                          ItemJnlLine.Validate("Item No.",ProductionBOMProdSource."Item No.");
                          ItemJnlLine."Unit of Measure Code":=ProductionBOMProdSource."Unit of Measure";
                          ProductionBOMProdSource.CalcFields(Description);
                          ItemJnlLine.Description := ProductionBOMProdSource.Description;

                          if ProductionBOMProdSource."Consumption Quantiry" <> 0 then
                           // IF Item."Rounding Precision" > 0 THEN
                              ItemJnlLine.Validate(Quantity,ProductionBOMProdSource."Consumption Quantiry");
                            //ELSE
                            //  ItemJnlLine.VALIDATE(Quantity,ROUND(NeededQty,0.00001));

                          ItemJnlLine.Validate("Location Code",ProductionPermissions."Default Raw Material Location");
                         // IF "Bin Code" <> '' THEN
                         //   ItemJnlLine."Bin Code" := "Bin Code";

                         // ItemJnlLine."Variant Code" := "Variant Code";
                          ItemJnlLine."Order Line No.":=OrderLineNo;
                          ItemJnlLine."Prod. Order Comp. Line No.":=OrderLineNo;

                          ItemJnlLine.Level := 1;
                          ItemJnlLine."Flushing Method" := ItemJnlLine."flushing method"::Manual;
                          ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
                          ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
                          ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";
                          if ItemJnlLine.Quantity<>0 then
                          ItemJnlLine.Insert;
                          end;
                          until ProductionBOMProdSource.Next = 0;
                          end;

                        ////////////////////////////////////////////////////////////// Post Output Journal
                        ItemJnlLine.Reset;
                        ItemJnlLine.SetRange("Journal Template Name",ToTemplateName);
                        ItemJnlLine.SetRange("Journal Batch Name",ToBatchName);
                        if ItemJnlLine.FindLast then NextLineNo:=ItemJnlLine."Line No.";

                        NextLineNo:=NextLineNo+1000;
                        OrderLineNo:=OrderLineNo+100;

                        ItemJnlLine.Init;
                          ItemJnlLine."Journal Template Name" := ToTemplateName;
                          ItemJnlLine."Journal Batch Name" := ToBatchName;
                          ItemJnlLine."Line No." := NextLineNo;
                          ItemJnlLine.Validate("Posting Date",ProductionBatchLines."Batch Date");
                          ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::"Positive Adjmt.");
                        //  ItemJnlLine.VALIDATE("Order Type",ItemJnlLine."Order Type"::Production);
                          ItemJnlLine."Document Date":=ProductionBatchLines."Batch Date";
                          ItemJnlLine."Document No.":=ProductionBatchLines."Batch Serial";
                        //  ItemJnlLine.."Document Type":=ItemJnlLine.."Document Type"::
                          ItemJnlLine."Document Line No.":=NextLineNo;
                         // ItemJnlLine."Order Type":=ItemJnlLine."Order Type"::Production;
                          ItemJnlLine."Order No.":=ProductionBatchLines."Batch Serial";;
                          ItemJnlLine."Order Line No.":=OrderLineNo;
                          ItemJnlLine.Validate("Item No.",ProductionBatchLines."Item Code");
                          ItemJnlLine."Source Type":=ItemJnlLine."source type"::Item;
                          ItemJnlLine.Validate("Source No.",ProductionBatchLines."Item Code");
                          //ItemJnlLine.VALIDATE("Variant Code","Variant Code");
                          ItemJnlLine.Validate("Location Code",ProductionPermissions."Default Product Location");
                          //IF "Bin Code" <> '' THEN
                          //  ItemJnlLine.VALIDATE("Bin Code","Bin Code");
                          //ItemJnlLine.VALIDATE("Routing No.","Routing No.");
                          //ItemJnlLine.VALIDATE("Routing Reference No.","Routing Reference No.");
                         // IF ProdOrderRtngLine."Prod. Order No." <> '' THEN
                          //  ItemJnlLine.VALIDATE("Operation No.",ProdOrderRtngLine."Operation No.");
                          ItemJnlLine."Invoiced Quantity":=ProductionBatchLines."Required QTY";
                          ItemJnlLine.Validate("Invoiced Quantity");
                          ItemJnlLine."Unit of Measure Code":=ProductionBatchLines."Requirered Unit of Measure";
                          ItemJnlLine.Validate("Setup Time",0);
                          ItemJnlLine.Validate("Run Time",0);
                        //  IF ("Location Code" <> '') AND (ProdOrderRtngLine."Next Operation No." = '') THEN
                        //    ItemJnlLine.CheckWhse("Location Code",QtyToPost);
                        //  IF ItemJnlLine.SubcontractingWorkCenterUsed THEN
                        //    ItemJnlLine.VALIDATE("Output Quantity",0)
                        //  ELSE
                           // ItemJnlLine.VALIDATE("Output Quantity",ProductionBatchLines."Required QTY");
                            ItemJnlLine.Validate(Quantity,ProductionBatchLines."Required QTY");

                        //  IF ProdOrderRtngLine."Routing Status" = ProdOrderRtngLine."Routing Status"::Finished THEN
                            ItemJnlLine.Finished := true;
                          ItemJnlLine."Flushing Method" := ItemJnlLine."flushing method"::Manual;
                          ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
                          ItemJnlLine."Reason Code" := ItemJnlBatch."Reason Code";
                          ItemJnlLine."Posting No. Series" := ItemJnlBatch."Posting No. Series";

                          if ItemJnlLine.Quantity<>0 then
                          ItemJnlLine.Insert;

                        ProductionBatchLines.Posted:=true;
                        ProductionBatchLines.Modify;
                        end;
                        until ProductionBatchLines.Next=0;
                        end;

                        //************************* Post Meal-Proc. Journal here*************************//
                        ItemJnlLine.Reset;
                        ItemJnlLine.SetRange("Journal Template Name",ToTemplateName);
                        ItemJnlLine.SetRange("Journal Batch Name",ToBatchName);
                        if ItemJnlLine.FindFirst then
                        Codeunit.Run(Codeunit::"Item Jnl.-Post",ItemJnlLine);
                    end;
                }
            }
            group("Summary Reports")
            {
                Caption = 'Summary Reports';
                action(BOMSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'BoM Summary report';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "BOM Summary Report - Meal";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(DailyProdSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily prod. Summary';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Daily Meal-Proc. Summary";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(MonthlyProdSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Pro. Summary';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Monthly Meal-Proc. Summary";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(MonthlyProdAnalysis)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Pro. Analysis';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Monthly Meal-Proc. Analysis";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(RMSumm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Material Requisition Summ.';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Meal Cons. Material Req. Sum.";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(RmMontTo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Raw Material Summary';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Monthly Comsumption Rm Sum.";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(RMMontlySumm2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Consuption Sum';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Meal Proc. Monthly Consumption";

                    trigger OnAction()
                    var
                        ProductionBatches: Record UnknownRecord99900;
                    begin
                    end;
                }
                action(ProcBatched)
                {
                    ApplicationArea = Basic;
                    Caption = 'Proccessing Batches';
                    Image = Description;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Meal Process Batches";
                    RunPageLink = "Batch Date"=field("Batch Date");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Batch Date",'=%1',DateFilter);
    end;

    trigger OnOpenPage()
    begin
        DateFilter:=Today;
        Rec.SetFilter("Batch Date",'=%1',DateFilter);
    end;

    var
        NextLineNo: Integer;
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        OrderLineNo: Integer;
        ItemJnlLine: Record "Item Journal Line";
        ProductionBatchLines: Record UnknownRecord99901;
        ProductionBOMProdSource: Record UnknownRecord99902;
        ProductionPermissions: Record UnknownRecord99905;
        ProductionCentralSetup: Record UnknownRecord99903;
        ToTemplateName: Code[20];
        ToBatchName: Code[20];
        DateFilter: Date;
        lineNo: Integer;
        ProductionBatches: Record UnknownRecord99900;
        NextOderNo: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        InsertMode: Boolean;
        HideCreditCheckDialogue: Boolean;
        UpdateDocumentDate: Boolean;
        BilltoCustomerNoChanged: Boolean;
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        Customer: Record Customer;
        ProductionCustProdSource: Record UnknownRecord99902;
        Item: Record Item;
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        UserMgt: Codeunit "User Setup Management";

    local procedure Post(PostingCodeunitID: Integer;DocNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        OfficeMgt: Codeunit "Office Management";
        InstructionMgt: Codeunit "Instruction Mgt.";
        PreAssignedNo: Code[20];
    begin
        // Post Meal-Proc. to Update Items Accordingly
    end;


    procedure CreateTransferOrder()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
        ItmJnl: Record UnknownRecord99901;
        ItemRec: Record Item;
        TransferNo: Code[20];
    begin
        //IF "Transfer Order Created" THEN
         //ERROR('Transfer order has been created for this document');
        with TransferHeader do begin
         Init;
         ItmJnl.Reset;
         ItmJnl.SetRange(ItmJnl."Batch Serial",Rec."Batch Serial");
         if ItmJnl.FindFirst then
         TransferNo:=NoSeriesManagement.GetNextNo('MI-11',"Posting Date",true);
         //TransferNo:=
         TransferHeader."No.":=TransferNo;
         "Transfer-from Code":='Packaging'; //ItmJnl.Processing';
         Validate("Transfer-from Code");
         "Transfer-to Code":= 'COLDROOM 2';
         Validate("Transfer-to Code");
         "In-Transit Code":='TRANSIT';
         "Posting Date":=ItmJnl."Batch Date";
        "Shipment Date":=ItmJnl."Batch Date";
        "Receipt Date":=ItmJnl."Batch Date";
        //"Output Voucher No.":="Document No.";
        //"Transfer Type":="Transfer Type"::"Output Transfer";
         TransferHeader."Assigned User ID":=UserId;
         //TransferHeader."External Document No.":=Rec."Order No.";
          Validate("Transfer-from Code");
          Validate("Transfer-to Code");
         if Insert then begin
         //Rec."Transfer Order No.":=TransferHeader."No.";
         //Rec."Transfer Order Created":=TRUE;
         Modify;
        end;
         end;
         /*"Transfer Order No.":=TransferHeader."No.";
         "Transfer Order Created":=TRUE;
         MODIFY;
        */
        TransferHeader.Reset;
        TransferHeader.SetRange(TransferHeader."No.","Batch Serial");
        TransferHeader.SetRange("Posting Date","Batch Date");
        //TransferHeader.SETRANGE(TransferHeader."External Document No.","Order No.");
        if TransferHeader.FindFirst then begin
        ItmJnl.Reset;
        ItmJnl.SetRange(ItmJnl."Batch Serial",Rec."Batch Serial");
        ItmJnl.SetFilter(ItmJnl."Required QTY",'>%1',0);
        if ItmJnl.FindSet then begin
         repeat
         LineNo+=10000;
         with TransferLine do begin
          Init;
           "Line No.":=LineNo;
           TransferLine."Document No.":=TransferHeader."No.";
            if ItemRec.Get(ItmJnl."Item Code") then begin
            TransferLine."Item Category Code":=ItemRec."Item Category Code";
            TransferLine."Product Group Code":=ItemRec."Product Group Code";
            end;
            TransferLine."Item No.":=ItmJnl."Item Code";
            TransferLine.Validate("Item No.");
            TransferLine.Quantity:=ItmJnl."Required QTY";
            TransferLine."Transfer-from Code":=TransferHeader."Transfer-from Code";
            TransferLine."Transfer-to Code":=TransferHeader."Transfer-to Code";
            TransferLine."Shortcut Dimension 1 Code":='A07';//ItmJnl."Shortcut Dimension 1 Code";
            TransferLine."Shipment Date":=TransferHeader."Posting Date";
            TransferLine."Receipt Date":=TransferHeader."Posting Date";
            TransferLine.Validate("Shortcut Dimension 1 Code");
            TransferLine."Shortcut Dimension 2 Code":='Processing';//ItmJnl."Shortcut Dimension 2 Code";
            TransferLine.Validate("Shortcut Dimension 2 Code");
            //TransferLine."Gen. Prod. Posting Group":=ItmJnl."Gen. Prod. Posting Group";
            TransferLine.Validate(Quantity);
             TransferLine.Validate("Transfer-from Code");
             TransferLine.Validate("Transfer-to Code");
             TransferLine."Unit of Measure Code":=ItmJnl."Requirered Unit of Measure";
          TransferLine."Document No." :=TransferHeader."No.";
          TransferLine."Unit of Measure":=ItmJnl."Requirered Unit of Measure";
          TransferLine.Validate("Unit of Measure Code");
           Insert(true);
          end;
          until ItmJnl.Next = 0;
         end;
         //"Transfer Order No.":=TransferHeader."No.";
         //"Transfer Order Created":=TRUE;
         Modify;
        
        end;
         //"Transfer Order No.":=TransferHeader."No.";
         //"Transfer Order Created":=TRUE;
        
          Page.Run(Page::"Transfer Order",TransferHeader);

    end;
}

