#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 10000 "Import Budget Information"
{
    Caption = 'Import Budget Information';
    PageType = Card;

    layout
    {
        area(content)
        {
            field(BudgetName;BudgetName)
            {
                ApplicationArea = Suite;
                Caption = 'Budget Name';
                TableRelation = "G/L Budget Name";
                ToolTip = 'Specifies the name of the budget to be imported.';
            }
            field(StartDate;StartDate)
            {
                ApplicationArea = Suite;
                Caption = 'Budget Start Date';
                ToolTip = 'Specifies the start date of the imported budget.';
            }
            field(NumPeriods;NumPeriods)
            {
                ApplicationArea = Suite;
                Caption = 'Number of Periods';
                MaxValue = 12;
                MinValue = 1;
                ToolTip = 'Specifies the number of budget periods to be created.';
            }
            field(BusinessUnitCode;BusinessUnitCode)
            {
                ApplicationArea = Basic;
                Caption = 'Business Unit Code';
                TableRelation = "Business Unit";
            }
            field(GlobDim1;GlobDim1Code)
            {
                ApplicationArea = Suite;
                CaptionClass = '1,1,1';
                Enabled = GlobDim1Enable;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    LookupShortcutDimCode(1,GlobDim1Code);
                end;

                trigger OnValidate()
                begin
                    ValidateShortcutDimCode(1,GlobDim1Code);
                end;
            }
            field(GlobDim2;GlobDim2Code)
            {
                ApplicationArea = Suite;
                CaptionClass = '1,1,2';
                Enabled = GlobDim2Enable;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    LookupShortcutDimCode(2,GlobDim2Code);
                end;

                trigger OnValidate()
                begin
                    ValidateShortcutDimCode(2,GlobDim2Code);
                end;
            }
            field(Description;Description)
            {
                ApplicationArea = Suite;
                Caption = 'Description';
                ToolTip = 'Specifies a description of the budget import.';
            }
            field(ReplaceOption;ReplaceOption)
            {
                ApplicationArea = Suite;
                OptionCaption = 'Replace Current Budget,Add to Current Budget';
            }
            label(Control21)
            {
                ApplicationArea = Suite;
                CaptionClass = Text19033369;
                MultiLine = true;
            }
            label(Control20)
            {
                ApplicationArea = Suite;
                CaptionClass = Text19080001;
            }
            label(Control19)
            {
                ApplicationArea = Suite;
                CaptionClass = Text19015020;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
        GlobDim2Enable := true;
        GlobDim1Enable := true;
    end;

    trigger OnOpenPage()
    begin
        GLSetup.Get;
        if GLSetup."Global Dimension 1 Code" = '' then begin
          GlobDim1Enable := false;
          GlobDim1Code := '';
        end;
        if GLSetup."Global Dimension 2 Code" = '' then begin
          GlobDim2Enable := false;
          GlobDim2Code := '';
        end;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimManagement: Codeunit DimensionManagement;
        BudgetName: Code[10];
        StartDate: Date;
        NumPeriods: Integer;
        GlobDim1Code: Code[20];
        GlobDim2Code: Code[20];
        BusinessUnitCode: Code[20];
        Description: Text[50];
        ReplaceOption: Option "Replace Current Budget","Add to Current Budget";
        [InDataSet]
        GlobDim1Enable: Boolean;
        [InDataSet]
        GlobDim2Enable: Boolean;
        Text19015020: label '*';
        Text19080001: label '*';
        Text19033369: label 'Imported budget amount will be divided evenly among this number of Accounting Periods';


    procedure SetBudgetName(NewBudgetName: Code[10])
    begin
        BudgetName := NewBudgetName;
    end;


    procedure GetBudgetName(): Code[10]
    begin
        exit(BudgetName);
    end;


    procedure SetStartDate(NewStartDate: Date)
    begin
        StartDate := NewStartDate;
    end;


    procedure GetStartDate(): Date
    begin
        exit(StartDate);
    end;


    procedure SetNumPeriods(NewNumPeriods: Integer)
    begin
        NumPeriods := NewNumPeriods;
    end;


    procedure GetNumPeriods(): Integer
    begin
        exit(NumPeriods);
    end;


    procedure SetGlobDim1Code(NewGlobDim1Code: Code[20])
    begin
        GlobDim1Code := NewGlobDim1Code;
    end;


    procedure GetGlobDim1Code(): Code[20]
    begin
        exit(GlobDim1Code);
    end;


    procedure SetGlobDim2Code(NewGlobDim2Code: Code[20])
    begin
        GlobDim2Code := NewGlobDim2Code;
    end;


    procedure GetGlobDim2Code(): Code[20]
    begin
        exit(GlobDim2Code);
    end;


    procedure SetBusinessUnitCode(NewBusinessUnitCode: Code[10])
    begin
        BusinessUnitCode := NewBusinessUnitCode;
    end;


    procedure GetBusinessUnitCode(): Code[10]
    begin
        exit(BusinessUnitCode);
    end;


    procedure SetDescription(NewDescription: Text[50])
    begin
        Description := NewDescription;
    end;


    procedure GetDescription(): Text[50]
    begin
        exit(Description);
    end;


    procedure SetReplaceOption(NewReplaceOption: Option "Replace Current Budget","Add to Current Budget")
    begin
        ReplaceOption := NewReplaceOption;
    end;


    procedure GetReplaceOption(): Integer
    begin
        exit(ReplaceOption);
    end;

    local procedure ValidateShortcutDimCode(FieldNo: Integer;var ShortcutDimCode: Code[20])
    begin
        DimManagement.ValidateDimValueCode(FieldNo,ShortcutDimCode);
    end;

    local procedure LookupShortcutDimCode(FieldNo: Integer;var ShortcutDimCode: Code[20])
    begin
        DimManagement.LookupDimValueCode(FieldNo,ShortcutDimCode);
    end;
}

