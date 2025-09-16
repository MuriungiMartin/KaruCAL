#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7012 "Purchase Prices"
{
    Caption = 'Purchase Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Purchase Price";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VendNoFilterCtrl;VendNoFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor No. Filter';
                    ToolTip = 'Specifies a filter for which purchase prices to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendList: Page "Vendor List";
                    begin
                        VendList.LookupMode := true;
                        if VendList.RunModal = Action::LookupOK then
                          Text := VendList.GetSelectionFilter
                        else
                          exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        VendNoFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFIlterCtrl;ItemNoFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which purchase prices to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = Action::LookupOK then
                          Text := ItemList.GetSelectionFilter
                        else
                          exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter;StartingDateFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Starting Date Filter';
                    ToolTip = 'Specifies a filter for which purchase prices to display.';

                    trigger OnValidate()
                    var
                        ApplicationMgt: Codeunit ApplicationManagement;
                    begin
                        if ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 then;
                        StartingDateFilterOnAfterValid;
                    end;
                }
            }
            repeater(Control1)
            {
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the vendor who offers the line discount on the item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item that the purchase price applies to.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the purchase price.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code that the purchase price is valid for.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to get the purchase price.';
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cost per unit.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date from which the purchase price is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date to which the purchase price is valid.';
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

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        Vend: Record Vendor;
        VendNoFilter: Text;
        ItemNoFilter: Text;
        StartingDateFilter: Text[30];
        NoDataWithinFilterErr: label 'There is no %1 within the filter %2.', Comment='%1: Field(Code), %2: GetFilter(Code)';

    local procedure GetRecFilters()
    begin
        if GetFilters <> '' then begin
          VendNoFilter := GetFilter("Vendor No.");
          ItemNoFilter := GetFilter("Item No.");
          Evaluate(StartingDateFilter,GetFilter("Starting Date"));
        end;
    end;


    procedure SetRecFilters()
    begin
        if VendNoFilter <> '' then
          SetFilter("Vendor No.",VendNoFilter)
        else
          SetRange("Vendor No.");

        if StartingDateFilter <> '' then
          SetFilter("Starting Date",StartingDateFilter)
        else
          SetRange("Starting Date");

        if ItemNoFilter <> '' then
          SetFilter("Item No.",ItemNoFilter)
        else
          SetRange("Item No.");

        CheckFilters(Database::Vendor,VendNoFilter);
        CheckFilters(Database::Item,ItemNoFilter);

        CurrPage.Update(false);
    end;

    local procedure GetCaption(): Text
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[250];
        Description: Text[50];
    begin
        GetRecFilters;

        if ItemNoFilter <> '' then
          SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,27)
        else
          SourceTableName := '';

        if Vend.Get(CopyStr(VendNoFilter,1,MaxStrLen(Vend."No."))) then
          Description := Vend.Name;

        exit(StrSubstNo('%1 %2 %3 %4 ',VendNoFilter,Description,SourceTableName,ItemNoFilter));
    end;

    local procedure VendNoFilterOnAfterValidate()
    var
        Item: Record Item;
    begin
        if Item.Get("Item No.") then
          CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;


    procedure CheckFilters(TableNo: Integer;FilterTxt: Text)
    var
        FilterRecordRef: RecordRef;
        FilterFieldRef: FieldRef;
    begin
        if FilterTxt = '' then
          exit;
        Clear(FilterRecordRef);
        Clear(FilterFieldRef);
        FilterRecordRef.Open(TableNo);
        FilterFieldRef := FilterRecordRef.Field(1);
        FilterFieldRef.SetFilter(FilterTxt);
        if FilterRecordRef.IsEmpty then
          Error(NoDataWithinFilterErr,FilterRecordRef.Caption,FilterTxt);
    end;
}

