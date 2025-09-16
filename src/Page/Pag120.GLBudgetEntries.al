#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 120 "G/L Budget Entries"
{
    ApplicationArea = Basic;
    Caption = 'G/L Budget Entries';
    DataCaptionFields = "G/L Account No.","Budget Name";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "G/L Budget Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the G/L budget that the entry belongs to.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date of the budget entry.';
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the G/L account that the budget entry applies to, or, the account on the line where the budget figure has been entered.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the budget figure.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    Enabled = GlobalDimension1CodeEnable;
                    ToolTip = 'Specifies the dimension value code that the budget entry is linked to.';
                    Visible = GlobalDimension1CodeVisible;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    Enabled = GlobalDimension2CodeEnable;
                    ToolTip = 'Specifies the dimension value code that the budget entry is linked to.';
                    Visible = GlobalDimension2CodeVisible;
                }
                field("Budget Dimension 1 Code";"Budget Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    Enabled = BudgetDimension1CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 1 Code the budget entry is linked to.';
                    Visible = BudgetDimension1CodeVisible;
                }
                field("Budget Dimension 2 Code";"Budget Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    Enabled = BudgetDimension2CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 2 Code the budget entry is linked to.';
                    Visible = BudgetDimension2CodeVisible;
                }
                field("Budget Dimension 3 Code";"Budget Dimension 3 Code")
                {
                    ApplicationArea = Suite;
                    Enabled = BudgetDimension3CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 3 Code the budget entry is linked to.';
                    Visible = BudgetDimension3CodeVisible;
                }
                field("Budget Dimension 4 Code";"Budget Dimension 4 Code")
                {
                    ApplicationArea = Suite;
                    Enabled = BudgetDimension4CodeEnable;
                    ToolTip = 'Specifies the dimension value code for the Budget Dimension 4 Code the budget entry is linked to.';
                    Visible = BudgetDimension4CodeVisible;
                }
                field("Business Unit Code";"Business Unit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the business unit that the budget entry is linked to.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount of the budget entry.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the budget line''s entry number.';
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
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
            }
        }
    }

    trigger OnClosePage()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        if LowestModifiedEntryNo < 2147483647 then
          UpdateAnalysisView.SetLastBudgetEntryNo(LowestModifiedEntryNo - 1);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if "Entry No." < LowestModifiedEntryNo then
          LowestModifiedEntryNo := "Entry No.";
        exit(true);
    end;

    trigger OnInit()
    begin
        BudgetDimension4CodeEnable := true;
        BudgetDimension3CodeEnable := true;
        BudgetDimension2CodeEnable := true;
        BudgetDimension1CodeEnable := true;
        GlobalDimension2CodeEnable := true;
        GlobalDimension1CodeEnable := true;
        BudgetDimension4CodeVisible := true;
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
        if GetFilter("Budget Name") <> '' then
          "Budget Name" := GetRangeMin("Budget Name");
        if GLBudgetName.Name <> "Budget Name" then
          GLBudgetName.Get("Budget Name");
        if GetFilter("G/L Account No.") <> '' then
          "G/L Account No." := GetFirstGLAcc(GetFilter("G/L Account No."));
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
            GetFirstDimValue(GLBudgetName."Budget Dimension 1 Code",GetFilter("Budget Dimension 1 Code"));

        if GetFilter("Budget Dimension 2 Code") <> '' then
          "Budget Dimension 2 Code" :=
            GetFirstDimValue(GLBudgetName."Budget Dimension 2 Code",GetFilter("Budget Dimension 2 Code"));

        if GetFilter("Budget Dimension 3 Code") <> '' then
          "Budget Dimension 3 Code" :=
            GetFirstDimValue(GLBudgetName."Budget Dimension 3 Code",GetFilter("Budget Dimension 3 Code"));

        if GetFilter("Budget Dimension 4 Code") <> '' then
          "Budget Dimension 4 Code" :=
            GetFirstDimValue(GLBudgetName."Budget Dimension 4 Code",GetFilter("Budget Dimension 4 Code"));

        if GetFilter("Business Unit Code") <> '' then
          "Business Unit Code" := GetFirstBusUnit(GetFilter("Business Unit Code"));
    end;

    trigger OnOpenPage()
    var
        GLBudgetName: Record "G/L Budget Name";
    begin
        if GetFilter("Budget Name") = '' then
          GLBudgetName.Init
        else begin
          Copyfilter("Budget Name",GLBudgetName.Name);
          GLBudgetName.FindFirst;
        end;
        CurrPage.Editable := not GLBudgetName.Blocked;
        GLSetup.Get;
        GlobalDimension1CodeEnable := GLSetup."Global Dimension 1 Code" <> '';
        GlobalDimension2CodeEnable := GLSetup."Global Dimension 2 Code" <> '';
        BudgetDimension1CodeEnable := GLBudgetName."Budget Dimension 1 Code" <> '';
        BudgetDimension2CodeEnable := GLBudgetName."Budget Dimension 2 Code" <> '';
        BudgetDimension3CodeEnable := GLBudgetName."Budget Dimension 3 Code" <> '';
        BudgetDimension4CodeEnable := GLBudgetName."Budget Dimension 4 Code" <> '';
        GlobalDimension1CodeVisible := GLSetup."Global Dimension 1 Code" <> '';
        GlobalDimension2CodeVisible := GLSetup."Global Dimension 2 Code" <> '';
        BudgetDimension1CodeVisible := GLBudgetName."Budget Dimension 1 Code" <> '';
        BudgetDimension2CodeVisible := GLBudgetName."Budget Dimension 2 Code" <> '';
        BudgetDimension3CodeVisible := GLBudgetName."Budget Dimension 3 Code" <> '';
        BudgetDimension4CodeVisible := GLBudgetName."Budget Dimension 4 Code" <> '';
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLBudgetName: Record "G/L Budget Name";
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
        BudgetDimension4CodeVisible: Boolean;
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
        [InDataSet]
        BudgetDimension4CodeEnable: Boolean;

    local procedure GetFirstGLAcc(GLAccFilter: Text[250]): Code[20]
    var
        GLAcc: Record "G/L Account";
    begin
        with GLAcc do begin
          SetFilter("No.",GLAccFilter);
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

    local procedure GetFirstBusUnit(BusUnitFilter: Text[250]): Code[10]
    var
        BusUnit: Record "Business Unit";
    begin
        with BusUnit do begin
          SetFilter(Code,BusUnitFilter);
          if FindFirst then
            exit(Code);

          exit('');
        end;
    end;
}

