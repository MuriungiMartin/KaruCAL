#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7014 "Purchase Line Discounts"
{
    Caption = 'Purchase Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTable = "Purchase Line Discount";

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
                    ToolTip = 'Specifies a filter for which purchase line discounts to display.';

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
                field(ItemNoFilterCtrl;ItemNoFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which purchase line discounts to display.';

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
                    ToolTip = 'Specifies a filter for which purchase line discounts to display.';

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
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code of the purchase line discount price.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the item that the purchase line discount applies to.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code that the purchase line discount is valid for.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to receive the purchase line discount.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount percentage to use to calculate the purchase line discount.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date from which the purchase line discount is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date to which the purchase line discount is valid.';
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
        VendNoFilter: Text;
        ItemNoFilter: Text;
        StartingDateFilter: Text[30];

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

        CurrPage.Update(false);
    end;

    local procedure GetCaption(): Text[250]
    var
        Vendor: Record Vendor;
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[250];
        Description: Text[250];
    begin
        GetRecFilters;

        if ItemNoFilter <> '' then
          SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table,Database::Item)
        else
          SourceTableName := '';

        if VendNoFilter = '' then
          Description := ''
        else begin
          Vendor.SetFilter("No.",VendNoFilter);
          if Vendor.FindFirst then
            Description := Vendor.Name;
        end;

        exit(StrSubstNo('%1 %2 %3 %4 ',VendNoFilter,Description,SourceTableName,ItemNoFilter));
    end;

    local procedure VendNoFilterOnAfterValidate()
    begin
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
}

