#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5846 "Inventory Report Entry"
{
    Caption = 'Inventory Report Entry';
    PageType = List;
    SourceTable = "Inventory Report Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the inventory report entry refers to an item or a general ledger account.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory report entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory report entry.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownInventory(Rec);
                    end;
                }
                field("Inventory (Interim)";"Inventory (Interim)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownInventoryInterim(Rec);
                    end;
                }
                field("WIP Inventory";"WIP Inventory")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownWIPInventory(Rec);
                    end;
                }
                field("Direct Cost Applied Actual";"Direct Cost Applied Actual")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownDirectCostApplActual(Rec);
                    end;
                }
                field("Overhead Applied Actual";"Overhead Applied Actual")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownOverheadAppliedActual(Rec);
                    end;
                }
                field("Purchase Variance";"Purchase Variance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownPurchaseVariance(Rec);
                    end;
                }
                field("Inventory Adjmt.";"Inventory Adjmt.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownInventoryAdjmt(Rec);
                    end;
                }
                field("Invt. Accrual (Interim)";"Invt. Accrual (Interim)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownInvtAccrualInterim(Rec);
                    end;
                }
                field(COGS;COGS)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownCOGS(Rec);
                    end;
                }
                field("COGS (Interim)";"COGS (Interim)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownCOGSInterim(Rec);
                    end;
                }
                field("Material Variance";"Material Variance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownMaterialVariance(Rec);
                    end;
                }
                field("Capacity Variance";"Capacity Variance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownCapVariance(Rec);
                    end;
                }
                field("Subcontracted Variance";"Subcontracted Variance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownSubcontractedVariance(Rec);
                    end;
                }
                field("Capacity Overhead Variance";"Capacity Overhead Variance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownCapOverheadVariance(Rec);
                    end;
                }
                field("Mfg. Overhead Variance";"Mfg. Overhead Variance")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownMfgOverheadVariance(Rec);
                    end;
                }
                field("Direct Cost Applied WIP";"Direct Cost Applied WIP")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownDirectCostApplToWIP(Rec);
                    end;
                }
                field("Overhead Applied WIP";"Overhead Applied WIP")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GetInvtReport.DrillDownOverheadAppliedToWIP(Rec);
                    end;
                }
                field("Inventory To WIP";"Inventory To WIP")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownInvtToWIP(Rec);
                    end;
                }
                field("WIP To Interim";"WIP To Interim")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownWIPToInvtInterim(Rec);
                    end;
                }
                field("Direct Cost Applied";"Direct Cost Applied")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownDirectCostApplied(Rec);
                    end;
                }
                field("Overhead Applied";"Overhead Applied")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a value that depends on the type of the inventory period entry.';

                    trigger OnDrillDown()
                    begin
                        GetInvtReport.DrillDownOverheadApplied(Rec);
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    var
        GetInvtReport: Codeunit "Get Inventory Report";
}

