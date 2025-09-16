#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7133 "Item Budget Entries"
{
    ApplicationArea = Basic;
    Caption = 'Item Budget Entries';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Item Budget Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the item budget that this entry belongs to.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of this item budget entry.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that this budget entry applies to.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the budget figure.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source type of this budget entry.';
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer or vendor that this budget entry applies, to based on the source type in the Source Type Filter field.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Enabled = GlobalDimension1CodeEnable;
                    ToolTip = 'Specifies the dimension value code that this item budget entry is linked to.';
                    Visible = GlobalDimension1CodeVisible;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Enabled = GlobalDimension2CodeEnable;
                    ToolTip = 'Specifies the dimension value code that this item budget entry is linked to.';
                    Visible = GlobalDimension2CodeVisible;
                }
                field("Budget Dimension 1 Code";"Budget Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Enabled = BudgetDimension1CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 1 code that this item budget entry is linked to.';
                    Visible = BudgetDimension1CodeVisible;
                }
                field("Budget Dimension 2 Code";"Budget Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Enabled = BudgetDimension2CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 2 code that this item budget entry is linked to.';
                    Visible = BudgetDimension2CodeVisible;
                }
                field("Budget Dimension 3 Code";"Budget Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Enabled = BudgetDimension3CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 3 Code that this item budget entry is linked to.';
                    Visible = BudgetDimension3CodeVisible;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location that this item budget entry is linked to.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of this item budget entry.';
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost amount of this item budget entry.';
                }
                field("Sales Amount";"Sales Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sales amount of this item budget line entry.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of this item budget entry.';
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
        area(navigation)
        {
            group("<Action23>")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("<Action24>")
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if "Entry No." <> 0 then
          if "Dimension Set ID" <> xRec."Dimension Set ID" then
            LowestModifiedEntryNo := "Entry No.";
    end;

    trigger OnClosePage()
    var
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
    begin
        if LowestModifiedEntryNo < 2147483647 then
          UpdateItemAnalysisView.SetLastBudgetEntryNo(LowestModifiedEntryNo - 1);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if "Entry No." < LowestModifiedEntryNo then
          LowestModifiedEntryNo := "Entry No.";
        exit(true);
    end;

    trigger OnInit()
    begin
        BudgetDimension3CodeEnable := true;
        BudgetDimension2CodeEnable := true;
        BudgetDimension1CodeEnable := true;
        GlobalDimension2CodeEnable := true;
        GlobalDimension1CodeEnable := true;
        BudgetDimension3CodeVisible := true;
        BudgetDimension2CodeVisible := true;
        BudgetDimension1CodeVisible := true;
        GlobalDimension2CodeVisible := true;
        GlobalDimension1CodeVisible := true;
        LowestModifiedEntryNo := 2147483647;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if "Entry No." < LowestModifiedEntryNo then
          LowestModifiedEntryNo := "Entry No.";
        exit(true);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Budget Name" := GetRangeMin("Budget Name");
        "Analysis Area" := GetRangeMin("Analysis Area");
        if (ItemBudgetName.Name <> "Budget Name") or (ItemBudgetName."Analysis Area" <> "Analysis Area") then
          ItemBudgetName.Get("Analysis Area","Budget Name");
        if GetFilter("Item No.") <> '' then
          "Item No." := GetFirstItem(GetFilter("Item No."));
        Date := GetFirstDate(GetFilter(Date));
        "User ID" := UserId;

        if GetFilter("Global Dimension 1 Code") <> '' then
          "Global Dimension 1 Code" :=
            GetFirstDimValue(GLSetup."Global Dimension 1 Code",GetFilter("Global Dimension 1 Code"));

        if GetFilter("Global Dimension 2 Code") <> '' then
          "Global Dimension 2 Code" :=
            GetFirstDimValue(GLSetup."Global Dimension 2 Code",GetFilter("Global Dimension 2 Code"));

        if GetFilter("Budget Dimension 1 Code") <> '' then
          "Budget Dimension 1 Code" :=
            GetFirstDimValue(ItemBudgetName."Budget Dimension 1 Code",GetFilter("Budget Dimension 1 Code"));

        if GetFilter("Budget Dimension 2 Code") <> '' then
          "Budget Dimension 2 Code" :=
            GetFirstDimValue(ItemBudgetName."Budget Dimension 2 Code",GetFilter("Budget Dimension 2 Code"));

        if GetFilter("Budget Dimension 3 Code") <> '' then
          "Budget Dimension 3 Code" :=
            GetFirstDimValue(ItemBudgetName."Budget Dimension 3 Code",GetFilter("Budget Dimension 3 Code"));

        if GetFilter("Location Code") <> '' then
          "Location Code" := GetFirstLocationCode(GetFilter("Location Code"));
    end;

    trigger OnOpenPage()
    begin
        if GetFilter("Budget Name") = '' then
          ItemBudgetName.Init
        else begin
          Copyfilter("Analysis Area",ItemBudgetName."Analysis Area");
          Copyfilter("Budget Name",ItemBudgetName.Name);
          ItemBudgetName.FindFirst;
        end;
        CurrPage.Editable := not ItemBudgetName.Blocked;
        GLSetup.Get;
        GlobalDimension1CodeEnable := GLSetup."Global Dimension 1 Code" <> '';
        GlobalDimension2CodeEnable := GLSetup."Global Dimension 2 Code" <> '';
        BudgetDimension1CodeEnable := ItemBudgetName."Budget Dimension 1 Code" <> '';
        BudgetDimension2CodeEnable := ItemBudgetName."Budget Dimension 2 Code" <> '';
        BudgetDimension3CodeEnable := ItemBudgetName."Budget Dimension 3 Code" <> '';
        GlobalDimension1CodeVisible := GLSetup."Global Dimension 1 Code" <> '';
        GlobalDimension2CodeVisible := GLSetup."Global Dimension 2 Code" <> '';
        BudgetDimension1CodeVisible := ItemBudgetName."Budget Dimension 1 Code" <> '';
        BudgetDimension2CodeVisible := ItemBudgetName."Budget Dimension 2 Code" <> '';
        BudgetDimension3CodeVisible := ItemBudgetName."Budget Dimension 3 Code" <> '';
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ItemBudgetName: Record "Item Budget Name";
        LowestModifiedEntryNo: Integer;
        [InDataSet]
        GlobalDimension1CodeVisible: Boolean;
        [InDataSet]
        GlobalDimension2CodeVisible: Boolean;
        [InDataSet]
        BudgetDimension1CodeVisible: Boolean;
        [InDataSet]
        BudgetDimension2CodeVisible: Boolean;
        [InDataSet]
        BudgetDimension3CodeVisible: Boolean;
        [InDataSet]
        GlobalDimension1CodeEnable: Boolean;
        [InDataSet]
        GlobalDimension2CodeEnable: Boolean;
        [InDataSet]
        BudgetDimension1CodeEnable: Boolean;
        [InDataSet]
        BudgetDimension2CodeEnable: Boolean;
        [InDataSet]
        BudgetDimension3CodeEnable: Boolean;

    local procedure GetFirstItem(ItemFilter: Text[250]): Code[20]
    var
        Item: Record Item;
    begin
        with Item do begin
          SetFilter("No.",ItemFilter);
          if FindFirst then
            exit("No.");

          exit('');
        end;
    end;

    local procedure GetFirstDate(DateFilter: Text[250]): Date
    var
        Period: Record Date;
    begin
        if DateFilter = '' then
          exit(0D);
        with Period do begin
          SetRange("Period Type","period type"::Date);
          SetFilter("Period Start",DateFilter);
          if FindFirst then
            exit("Period Start");

          exit(0D);
        end;
    end;

    local procedure GetFirstDimValue(DimCode: Code[20];DimValFilter: Text[250]): Code[20]
    var
        DimVal: Record "Dimension Value";
    begin
        if (DimCode = '') or (DimValFilter = '') then
          exit('');
        with DimVal do begin
          SetRange("Dimension Code",DimCode);
          SetFilter(Code,DimValFilter);
          if FindFirst then
            exit(Code);

          exit('');
        end;
    end;

    local procedure GetFirstLocationCode(LocationCodetFilter: Text[250]): Code[10]
    var
        Location: Record Location;
    begin
        with Location do begin
          SetFilter(Code,LocationCodetFilter);
          if FindFirst then
            exit(Code);

          exit('');
        end;
    end;
}

