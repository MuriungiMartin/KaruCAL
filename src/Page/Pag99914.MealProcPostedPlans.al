#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99914 "Meal-Proc. Posted Plans"
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
                            Posted=filter(Yes));
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
                        Rec.SetFilter("Batch Date",'=%1',DateFilter);
                        CurrPage.Update;
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Batch Date",'=%1',DateFilter);
    end;

    trigger OnOpenPage()
    begin
        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
        DateFilter:=Today;
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
}

