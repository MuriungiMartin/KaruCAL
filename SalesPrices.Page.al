#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7002 "Sales Prices"
{
    Caption = 'Sales Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = "Sales Price";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Visible = not IsOnMobile;
                field(SalesTypeFilter;SalesTypeFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Type Filter';
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,None';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate()
                    begin
                        SalesTypeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl;SalesCodeFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: Page "Customer List";
                        CustPriceGrList: Page "Customer Price Groups";
                        CampaignList: Page "Campaign List";
                    begin
                        if SalesTypeFilter = Salestypefilter::"All Customers" then
                          exit;

                        case SalesTypeFilter of
                          Salestypefilter::Customer:
                            begin
                              CustList.LookupMode := true;
                              if CustList.RunModal = Action::LookupOK then
                                Text := CustList.GetSelectionFilter
                              else
                                exit(false);
                            end;
                          Salestypefilter::"Customer Price Group":
                            begin
                              CustPriceGrList.LookupMode := true;
                              if CustPriceGrList.RunModal = Action::LookupOK then
                                Text := CustPriceGrList.GetSelectionFilter
                              else
                                exit(false);
                            end;
                          Salestypefilter::Campaign:
                            begin
                              CampaignList.LookupMode := true;
                              if CampaignList.RunModal = Action::LookupOK then
                                Text := CampaignList.GetSelectionFilter
                              else
                                exit(false);
                            end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilterCtrl;ItemNoFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

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
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate()
                    var
                        ApplicationMgt: Codeunit ApplicationManagement;
                    begin
                        if ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 then;
                        StartingDateFilterOnAfterValid;
                    end;
                }
                field(SalesCodeFilterCtrl2;CurrencyCodeFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CurrencyList: Page Currencies;
                    begin
                        CurrencyList.LookupMode := true;
                        if CurrencyList.RunModal = Action::LookupOK then
                          Text := CurrencyList.GetSelectionFilter
                        else
                          exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeFilterOnAfterValid;
                    end;
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                Visible = IsOnMobile;
                field(GetFilterDescription;GetFilterDescription)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnAssistEdit()
                    begin
                        FilterLines;
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Control1)
            {
                field("Sales Type";"Sales Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = SalesTypeControlEditable;
                    ToolTip = 'Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.';

                    trigger OnValidate()
                    begin
                        SalesCodeControlEditable := SetSalesCodeEditable("Sales Type");
                    end;
                }
                field("Sales Code";"Sales Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = SalesCodeControlEditable;
                    ToolTip = 'Specifies the code that belongs to the Sales Type.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = ItemNoControlEditable;
                    ToolTip = 'Specifies the number of the item for which the sales price is valid.';
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
                    Editable = CurrencyCodeControlEditable;
                    ToolTip = 'Specifies the code for the currency of the sales price.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code for the sales price, if you have specified the same code on the item card.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum sales quantity required to warrant the sales price.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the sales price per unit.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = StartingDateControlEditable;
                    ToolTip = 'Specifies the date from which the sales price is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the calendar date when the sales price agreement ends.';
                }
                field("Price Includes VAT";"Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the sales price includes tax.';
                    Visible = false;
                }
                field("Allow Line Disc.";"Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a line discount will be calculated when the sales price is offered.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if an invoice discount will be calculated when the sales price is offered.';
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)";"VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax business posting group for customers for whom you want the sales price (which includes tax) to apply.';
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
            action("Filter")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Filter';
                Image = "Filter";
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Apply filter.';
                Visible = IsOnMobile;

                trigger OnAction()
                begin
                    FilterLines;
                end;
            }
            action(ClearFilter)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Clear Filter';
                Image = ClearFilter;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Clear filter.';
                Visible = IsOnMobile;

                trigger OnAction()
                begin
                    Reset;
                    UpdateBasicRecFilters;
                    Evaluate(StartingDateFilter,GetFilter("Starting Date"));
                    SetEditableFields;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SalesCodeControlEditable := SetSalesCodeEditable("Sales Type");
    end;

    trigger OnInit()
    begin
        SalesCodeFilterCtrlEnable := true;
        SalesCodeControlEditable := true;
    end;

    trigger OnOpenPage()
    begin
        IsOnMobile := CurrentClientType = Clienttype::Phone;
        GetRecFilters;
        SetRecFilters;
        SetEditableFields;
    end;

    var
        Cust: Record Customer;
        CustPriceGr: Record "Customer Price Group";
        Campaign: Record Campaign;
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text;
        ItemNoFilter: Text;
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text;
        Text000: label 'All Customers';
        Text001: label 'No %1 within the filter %2.';
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        IsOnMobile: Boolean;
        SalesTypeControlEditable: Boolean;
        SalesCodeControlEditable: Boolean;
        ItemNoControlEditable: Boolean;
        StartingDateControlEditable: Boolean;
        CurrencyCodeControlEditable: Boolean;

    local procedure GetRecFilters()
    begin
        if GetFilters <> '' then
          UpdateBasicRecFilters;

        Evaluate(StartingDateFilter,GetFilter("Starting Date"));
    end;

    local procedure UpdateBasicRecFilters()
    begin
        if GetFilter("Sales Type") <> '' then
          SalesTypeFilter := GetSalesTypeFilter
        else
          SalesTypeFilter := Salestypefilter::None;

        SalesCodeFilter := GetFilter("Sales Code");
        ItemNoFilter := GetFilter("Item No.");
        CurrencyCodeFilter := GetFilter("Currency Code");
    end;


    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;

        if SalesTypeFilter <> Salestypefilter::None then
          SetRange("Sales Type",SalesTypeFilter)
        else
          SetRange("Sales Type");

        if SalesTypeFilter in [Salestypefilter::"All Customers",Salestypefilter::None] then begin
          SalesCodeFilterCtrlEnable := false;
          SalesCodeFilter := '';
        end;

        if SalesCodeFilter <> '' then
          SetFilter("Sales Code",SalesCodeFilter)
        else
          SetRange("Sales Code");

        if StartingDateFilter <> '' then
          SetFilter("Starting Date",StartingDateFilter)
        else
          SetRange("Starting Date");

        if ItemNoFilter <> '' then begin
          SetFilter("Item No.",ItemNoFilter);
        end else
          SetRange("Item No.");

        if CurrencyCodeFilter <> '' then begin
          SetFilter("Currency Code",CurrencyCodeFilter);
        end else
          SetRange("Currency Code");

        case SalesTypeFilter of
          Salestypefilter::Customer:
            CheckFilters(Database::Customer,SalesCodeFilter);
          Salestypefilter::"Customer Price Group":
            CheckFilters(Database::"Customer Price Group",SalesCodeFilter);
          Salestypefilter::Campaign:
            CheckFilters(Database::Campaign,SalesCodeFilter);
        end;
        CheckFilters(Database::Item,ItemNoFilter);
        CheckFilters(Database::Currency,CurrencyCodeFilter);

        CurrPage.Update(false);
    end;

    local procedure GetCaption(): Text
    begin
        if IsOnMobile then
          exit('');

        exit(GetFilterDescription);
    end;

    local procedure GetFilterDescription(): Text
    var
        ObjTranslation: Record "Object Translation";
        SourceTableName: Text;
        SalesSrcTableName: Text;
        Description: Text;
    begin
        GetRecFilters;

        SourceTableName := '';
        if ItemNoFilter <> '' then
          SourceTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,27);

        SalesSrcTableName := '';
        case SalesTypeFilter of
          Salestypefilter::Customer:
            begin
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,18);
              Cust."No." := CopyStr(SalesCodeFilter,1,MaxStrLen(Cust."No."));
              if Cust.Find then
                Description := Cust.Name;
            end;
          Salestypefilter::"Customer Price Group":
            begin
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,6);
              CustPriceGr.Code := CopyStr(SalesCodeFilter,1,MaxStrLen(CustPriceGr.Code));
              if CustPriceGr.Find then
                Description := CustPriceGr.Description;
            end;
          Salestypefilter::Campaign:
            begin
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,5071);
              Campaign."No." := CopyStr(SalesCodeFilter,1,MaxStrLen(Campaign."No."));
              if Campaign.Find then
                Description := Campaign.Description;
            end;
          Salestypefilter::"All Customers":
            begin
              SalesSrcTableName := Text000;
              Description := '';
            end;
        end;

        if SalesSrcTableName = Text000 then
          exit(StrSubstNo('%1 %2 %3',SalesSrcTableName,SourceTableName,ItemNoFilter));
        exit(StrSubstNo('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,ItemNoFilter));
    end;

    local procedure CheckFilters(TableNo: Integer;FilterTxt: Text)
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
          Error(Text001,FilterRecordRef.Caption,FilterTxt);
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SalesCodeFilter := '';
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

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure GetSalesTypeFilter(): Integer
    begin
        case GetFilter("Sales Type") of
          Format("sales type"::Customer):
            exit(0);
          Format("sales type"::"Customer Price Group"):
            exit(1);
          Format("sales type"::"All Customers"):
            exit(2);
          Format("sales type"::Campaign):
            exit(3);
        end;
    end;

    local procedure SetSalesCodeEditable(SalesType: Option): Boolean
    begin
        exit(SalesType <> "sales type"::"All Customers");
    end;

    local procedure SetEditableFields()
    begin
        SalesTypeControlEditable := GetFilter("Sales Type") = '';
        SalesCodeControlEditable :=
          SalesCodeControlEditable and (GetFilter("Sales Code") = '');
        ItemNoControlEditable := GetFilter("Item No.") = '';
        StartingDateControlEditable := GetFilter("Starting Date") = '';
        CurrencyCodeControlEditable := GetFilter("Currency Code") = '';
    end;

    local procedure FilterLines()
    var
        FilterPageBuilder: FilterPageBuilder;
    begin
        FilterPageBuilder.AddTable(TableCaption,Database::"Sales Price");

        FilterPageBuilder.SetView(TableCaption,GetView);
        if GetFilter("Sales Type") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Sales Type"));
        if GetFilter("Sales Code") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Sales Code"));
        if GetFilter("Item No.") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Item No."));
        if GetFilter("Starting Date") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Starting Date"));
        if GetFilter("Currency Code") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Currency Code"));

        if FilterPageBuilder.RunModal then
          SetView(FilterPageBuilder.GetView(TableCaption));

        UpdateBasicRecFilters;
        Evaluate(StartingDateFilter,GetFilter("Starting Date"));
        SetEditableFields;
    end;
}

