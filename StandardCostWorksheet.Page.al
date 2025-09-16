#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5841 "Standard Cost Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Standard Cost Worksheet';
    DataCaptionFields = "Standard Cost Worksheet Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Standard Cost Worksheet";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrWkshName;CurrWkshName)
            {
                ApplicationArea = Basic;
                Caption = 'Name';
                Lookup = true;
                ToolTip = 'Specifies the name of the Standard Cost Worksheet.';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    Commit;
                    if Page.RunModal(0,StdCostWkshName) = Action::LookupOK then begin
                      CurrWkshName := StdCostWkshName.Name;
                      FilterGroup := 2;
                      SetRange("Standard Cost Worksheet Name",CurrWkshName);
                      FilterGroup := 0;
                      if Find('-') then;
                    end;
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    CurrWkshNameOnAfterValidate;
                end;
            }
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                    ToolTip = 'Specifies the type of worksheet line.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number, work center number or machine center number, depending on the Type of the worksheet line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the worksheet line.';
                }
                field("Standard Cost";"Standard Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the standard cost.';
                }
                field("New Standard Cost";"New Standard Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the indirect cost percentage.';
                }
                field("New Indirect Cost %";"New Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                }
                field("Overhead Rate";"Overhead Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the overhead rate.';
                }
                field("New Overhead Rate";"New Overhead Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                }
                field(Implemented;Implemented)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you have run the Implement Standard Cost Changes batch job.';
                }
                field("Replenishment System";"Replenishment System")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the replenishment method for the items, for example, purchase or prod. order.';
                }
                field("Single-Lvl Material Cost";"Single-Lvl Material Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the single-level material cost of the item.';
                    Visible = false;
                }
                field("New Single-Lvl Material Cost";"New Single-Lvl Material Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Single-Lvl Cap. Cost";"Single-Lvl Cap. Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the single-level capacity cost of the item.';
                    Visible = false;
                }
                field("New Single-Lvl Cap. Cost";"New Single-Lvl Cap. Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Single-Lvl Subcontrd Cost";"Single-Lvl Subcontrd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the single-level subcontracted cost of the item.';
                    Visible = false;
                }
                field("New Single-Lvl Subcontrd Cost";"New Single-Lvl Subcontrd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Single-Lvl Cap. Ovhd Cost";"Single-Lvl Cap. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the single-level capacity overhead cost of the item.';
                    Visible = false;
                }
                field("New Single-Lvl Cap. Ovhd Cost";"New Single-Lvl Cap. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Single-Lvl Mfg. Ovhd Cost";"Single-Lvl Mfg. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the single-level manufacturing overhead cost of the item.';
                    Visible = false;
                }
                field("New Single-Lvl Mfg. Ovhd Cost";"New Single-Lvl Mfg. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Rolled-up Material Cost";"Rolled-up Material Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rolled-up material cost of the item.';
                    Visible = false;
                }
                field("New Rolled-up Material Cost";"New Rolled-up Material Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated rolled-up material cost based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Rolled-up Cap. Cost";"Rolled-up Cap. Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rolled-up capacity cost of the item.';
                    Visible = false;
                }
                field("New Rolled-up Cap. Cost";"New Rolled-up Cap. Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Rolled-up Subcontrd Cost";"Rolled-up Subcontrd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rolled-up subcontracted cost of the item.';
                    Visible = false;
                }
                field("New Rolled-up Subcontrd Cost";"New Rolled-up Subcontrd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Rolled-up Cap. Ovhd Cost";"Rolled-up Cap. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rolled-up capacity overhead cost of the item.';
                    Visible = false;
                }
                field("New Rolled-up Cap. Ovhd Cost";"New Rolled-up Cap. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
                }
                field("Rolled-up Mfg. Ovhd Cost";"Rolled-up Mfg. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rolled-up manufacturing overhead cost of the item.';
                    Visible = false;
                }
                field("New Rolled-up Mfg. Ovhd Cost";"New Rolled-up Mfg. Ovhd Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the updated value based on either the batch job or what you have entered manually.';
                    Visible = false;
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Suggest I&tem Standard Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest I&tem Standard Cost';
                    Ellipsis = true;
                    Image = SuggestItemCost;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        SuggItemStdCost: Report "Suggest Item Standard Cost";
                    begin
                        Item.SetRange("Replenishment System",Item."replenishment system"::Purchase);
                        SuggItemStdCost.SetTableview(Item);
                        SuggItemStdCost.SetCopyToWksh(CurrWkshName);
                        SuggItemStdCost.RunModal;
                    end;
                }
                action("Suggest &Capacity Standard Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest &Capacity Standard Cost';
                    Ellipsis = true;
                    Image = SuggestCapacity;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        SuggWorkMachCtrStdWksh: Report "Suggest Capacity Standard Cost";
                    begin
                        SuggWorkMachCtrStdWksh.SetCopyToWksh(CurrWkshName);
                        SuggWorkMachCtrStdWksh.RunModal;
                    end;
                }
                separator(Action80)
                {
                }
                action("Copy Standard Cost Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Standard Cost Worksheet';
                    Ellipsis = true;
                    Image = CopyWorksheet;

                    trigger OnAction()
                    var
                        CopyStdCostWksh: Report "Copy Standard Cost Worksheet";
                    begin
                        CopyStdCostWksh.SetCopyToWksh(CurrWkshName);
                        CopyStdCostWksh.RunModal;
                    end;
                }
                separator(Action82)
                {
                }
                action("Roll Up Standard Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Roll Up Standard Cost';
                    Ellipsis = true;
                    Image = RollUpCosts;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        RollUpStdCost: Report "Roll Up Standard Cost";
                    begin
                        Clear(RollUpStdCost);
                        Item.SetRange("Costing Method",Item."costing method"::Standard);
                        RollUpStdCost.SetTableview(Item);
                        RollUpStdCost.SetStdCostWksh(CurrWkshName);
                        RollUpStdCost.RunModal;
                    end;
                }
                action("&Implement Standard Cost Changes")
                {
                    ApplicationArea = Basic;
                    Caption = '&Implement Standard Cost Changes';
                    Ellipsis = true;
                    Image = ImplementCostChanges;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ImplStdCostChg: Report "Implement Standard Cost Change";
                    begin
                        Clear(ImplStdCostChg);
                        ImplStdCostChg.SetStdCostWksh(CurrWkshName);
                        ImplStdCostChg.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        StdCostWkshName.Get("Standard Cost Worksheet Name");
        Type := xRec.Type;
        "Replenishment System" := "replenishment system"::Assembly;
    end;

    trigger OnOpenPage()
    begin
        if not StdCostWkshName.Get("Standard Cost Worksheet Name") then begin
          if StdCostWkshName.FindFirst then begin
            if CurrWkshName = '' then
              CurrWkshName := StdCostWkshName.Name
          end else begin
            StdCostWkshName.Name := Text001;
            StdCostWkshName.Description := Text001;
            StdCostWkshName.Insert;
            CurrWkshName := StdCostWkshName.Name;
          end;
        end else
          CurrWkshName := "Standard Cost Worksheet Name";

        FilterGroup := 2;
        SetRange("Standard Cost Worksheet Name",CurrWkshName);
        FilterGroup := 0;
    end;

    var
        StdCostWkshName: Record "Standard Cost Worksheet Name";
        CurrWkshName: Code[10];
        Text001: label 'Default';

    local procedure CurrWkshNameOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        Commit;
        FilterGroup := 2;
        SetRange("Standard Cost Worksheet Name",CurrWkshName);
        FilterGroup := 0;
        if Find('-') then;
        CurrPage.Update(false);
    end;
}

