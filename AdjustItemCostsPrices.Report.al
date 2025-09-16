#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 794 "Adjust Item Costs/Prices"
{
    Caption = 'Adjust Item Costs/Prices';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Vendor No.","Inventory Posting Group","Costing Method";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");

                case Selection of
                  Selection::"Unit Price":
                    OldFieldValue := "Unit Price";
                  Selection::"Profit %":
                    OldFieldValue := "Profit %";
                  Selection::"Indirect Cost %":
                    OldFieldValue := "Indirect Cost %";
                  Selection::"Last Direct Cost":
                    OldFieldValue := "Last Direct Cost";
                  Selection::"Standard Cost":
                    OldFieldValue := "Standard Cost";
                end;
                NewFieldValue := OldFieldValue * AdjFactor;

                GetGLSetup;
                PriceIsRnded := false;
                if RoundingMethod.Code <> '' then begin
                  RoundingMethod."Minimum Amount" := NewFieldValue;
                  if RoundingMethod.Find('=<') then begin
                    NewFieldValue := NewFieldValue + RoundingMethod."Amount Added Before";
                    if RoundingMethod.Precision > 0 then begin
                      NewFieldValue := ROUND(NewFieldValue,RoundingMethod.Precision,CopyStr('=><',RoundingMethod.Type + 1,1));
                      PriceIsRnded := true;
                    end;
                    NewFieldValue := NewFieldValue + RoundingMethod."Amount Added After";
                  end;
                end;
                if not PriceIsRnded then
                  NewFieldValue := ROUND(NewFieldValue,GLSetup."Unit-Amount Rounding Precision");

                case Selection of
                  Selection::"Unit Price":
                    Validate("Unit Price",NewFieldValue);
                  Selection::"Profit %":
                    Validate("Profit %",NewFieldValue);
                  Selection::"Indirect Cost %":
                    Validate("Indirect Cost %",NewFieldValue);
                  Selection::"Last Direct Cost":
                    Validate("Last Direct Cost",NewFieldValue);
                  Selection::"Standard Cost":
                    Validate("Standard Cost",NewFieldValue);
                end;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                if AdjustCard = Adjustcard::"Stockkeeping Unit Card" then
                  CurrReport.Break;

                Window.Open(Text000);
            end;
        }
        dataitem("Stockkeeping Unit";"Stockkeeping Unit")
        {
            DataItemTableView = sorting("Item No.","Location Code","Variant Code");
            column(ReportForNavId_5605; 5605)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SkipNoneExistingItem("Item No.");

                Window.Update(1,"Item No.");
                Window.Update(2,"Location Code");
                Window.Update(3,"Variant Code");

                case Selection of
                  Selection::"Last Direct Cost":
                    OldFieldValue := "Last Direct Cost";
                  Selection::"Standard Cost":
                    OldFieldValue := "Standard Cost";
                end;
                NewFieldValue := OldFieldValue * AdjFactor;

                PriceIsRnded := false;
                if RoundingMethod.Code <> '' then begin
                  RoundingMethod."Minimum Amount" := NewFieldValue;
                  if RoundingMethod.Find('=<') then begin
                    NewFieldValue := NewFieldValue + RoundingMethod."Amount Added Before";
                    if RoundingMethod.Precision > 0 then begin
                      NewFieldValue := ROUND(NewFieldValue,RoundingMethod.Precision,CopyStr('=><',RoundingMethod.Type + 1,1));
                      PriceIsRnded := true;
                    end;
                    NewFieldValue := NewFieldValue + RoundingMethod."Amount Added After";
                  end;
                end;
                if not PriceIsRnded then
                  NewFieldValue := ROUND(NewFieldValue,0.00001);

                case Selection of
                  Selection::"Last Direct Cost":
                    Validate("Last Direct Cost",NewFieldValue);
                  Selection::"Standard Cost":
                    Validate("Standard Cost",NewFieldValue);
                end;
                Modify;
            end;

            trigger OnPreDataItem()
            begin
                if AdjustCard = Adjustcard::"Item Card" then
                  CurrReport.Break;

                Item.Copyfilter("No.","Item No.");
                Item.Copyfilter("Location Filter","Location Code");
                Item.Copyfilter("Variant Filter","Variant Code");

                Window.Open(
                  Text002 +
                  Text003 +
                  Text004);
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
                    field(Adjust;AdjustCard)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Adjust';
                        OptionCaption = 'Item Card,Stockkeeping Unit Card';

                        trigger OnValidate()
                        begin
                            UpdateEnabled;
                        end;
                    }
                    field(AdjustField;Selection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Adjust Field';
                        OptionCaption = 'Unit Price,Profit %,Indirect Cost %,Last Direct Cost,Standard Cost';

                        trigger OnValidate()
                        begin
                            if Selection = Selection::"Indirect Cost %" then
                              IndirectCost37SelectionOnValid;
                            if Selection = Selection::"Profit %" then
                              Profit37SelectionOnValidate;
                            if Selection = Selection::"Unit Price" then
                              UnitPriceSelectionOnValidate;
                        end;
                    }
                    field(AdjustmentFactor;AdjFactor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Adjustment Factor';
                        DecimalPlaces = 0:5;
                        MinValue = 0;
                    }
                    field(Rounding_Method;RoundingMethod.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Rounding Method';
                        TableRelation = "Rounding Method";
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            Selection3Enable := true;
            Selection2Enable := true;
            Selection1Enable := true;
        end;

        trigger OnOpenPage()
        begin
            if AdjFactor = 0 then
              AdjFactor := 1;
            UpdateEnabled;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        RoundingMethod.SetRange(Code,RoundingMethod.Code);

        if Item.GetFilters <> '' then
          FilteredItem.CopyFilters(Item);
    end;

    var
        Text000: label 'Processing items     #1##########';
        Text002: label 'Processing items     #1##########\';
        Text003: label 'Processing locations #2##########\';
        Text004: label 'Processing variants  #3##########';
        RoundingMethod: Record "Rounding Method";
        GLSetup: Record "General Ledger Setup";
        FilteredItem: Record Item;
        Window: Dialog;
        NewFieldValue: Decimal;
        OldFieldValue: Decimal;
        PriceIsRnded: Boolean;
        GLSetupRead: Boolean;
        AdjFactor: Decimal;
        Selection: Option "Unit Price","Profit %","Indirect Cost %","Last Direct Cost","Standard Cost";
        AdjustCard: Option "Item Card","Stockkeeping Unit Card";
        [InDataSet]
        Selection1Enable: Boolean;
        [InDataSet]
        Selection2Enable: Boolean;
        [InDataSet]
        Selection3Enable: Boolean;
        SelectionErr: label '%1 is not a valid selection.';
        SelectionTxt: label 'Unit Price,Profit %,Indirect Cost %,Last Direct Cost,Standard Cost';

    local procedure UpdateEnabled()
    begin
        PageUpdateEnabled;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure PageUpdateEnabled()
    begin
        if AdjustCard = Adjustcard::"Stockkeeping Unit Card" then
          if Selection < 3 then
            Selection := 3;
    end;

    local procedure UnitPriceSelectionOnValidate()
    begin
        if not Selection1Enable then
          Error(SelectionErr,SelectStr(Selection + 1,SelectionTxt));
    end;

    local procedure Profit37SelectionOnValidate()
    begin
        if not Selection2Enable then
          Error(SelectionErr,SelectStr(Selection + 1,SelectionTxt));
    end;

    local procedure IndirectCost37SelectionOnValid()
    begin
        if not Selection3Enable then
          Error(SelectionErr,SelectStr(Selection + 1,SelectionTxt));
    end;

    local procedure SkipNoneExistingItem(ItemNo: Code[20])
    begin
        if Item.GetFilters <> '' then begin
          FilteredItem.SetRange("No.",ItemNo);
          if FilteredItem.IsEmpty then
            CurrReport.Skip;
        end;
    end;
}

