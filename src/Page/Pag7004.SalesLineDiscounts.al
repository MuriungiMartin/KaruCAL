#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7004 "Sales Line Discounts"
{
    Caption = 'Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    ShowFilter = false;
    SourceTable = "Sales Line Discount";

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
                    OptionCaption = 'Customer,Customer Discount Group,All Customers,Campaign,None';
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

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
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustList: Page "Customer List";
                        CustDiscGrList: Page "Customer Disc. Groups";
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
                          Salestypefilter::"Customer Discount Group":
                            begin
                              CustDiscGrList.LookupMode := true;
                              if CustDiscGrList.RunModal = Action::LookupOK then
                                Text := CustDiscGrList.GetSelectionFilter
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
                field(StartingDateFilter;StartingDateFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Starting Date Filter';
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

                    trigger OnValidate()
                    var
                        ApplicationMgt: Codeunit ApplicationManagement;
                    begin
                        if ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 then;
                        StartingDateFilterOnAfterValid;
                    end;
                }
                field(ItemTypeFilter;ItemTypeFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Type Filter';
                    OptionCaption = 'Item,Item Discount Group,None';
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

                    trigger OnValidate()
                    begin
                        ItemTypeFilterOnAfterValidate;
                    end;
                }
                field(CodeFilterCtrl;CodeFilter)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Code Filter';
                    Enabled = CodeFilterCtrlEnable;
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                        ItemDiscGrList: Page "Item Disc. Groups";
                    begin
                        case Type of
                          Type::Item:
                            begin
                              ItemList.LookupMode := true;
                              if ItemList.RunModal = Action::LookupOK then
                                Text := ItemList.GetSelectionFilter
                              else
                                exit(false);
                            end;
                          Type::"Item Disc. Group":
                            begin
                              ItemDiscGrList.LookupMode := true;
                              if ItemDiscGrList.RunModal = Action::LookupOK then
                                Text := ItemDiscGrList.GetSelectionFilter
                              else
                                exit(false);
                            end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CodeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl2;CurrencyCodeFilter)
                {
                    ApplicationArea = Suite;
                    Caption = 'Currency Code Filter';
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

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
                    ToolTip = 'Specifies a filter for which sales line discounts to display.';

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
                    ToolTip = 'Specifies the sales type of the sales line discount. The sales type defines whether the sales price is for an individual customer, customer discount group, all customers, or for a campaign.';
                }
                field("Sales Code";"Sales Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = SalesCodeEditable;
                    ToolTip = 'Specifies one of the following values, depending on the value in the Sales Type field.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of item that the sales discount line is valid for. That is, either an item or an item discount group.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies one of two values, depending on the value in the Type field.';
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
                    ToolTip = 'Specifies the currency code of the sales line discount price.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code that the sales line discount is valid for.';
                }
                field("Minimum Quantity";"Minimum Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the minimum quantity that the customer must purchase in order to gain the agreed discount.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the discount percentage to use to calculate the sales line discount.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date from which the sales line discount is valid.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date to which the sales line discount is valid.';
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
                    SetEditableFields;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableFields;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := true;
        SalesCodeFilterCtrlEnable := true;
        SalesCodeEditable := true;
    end;

    trigger OnOpenPage()
    begin
        IsOnMobile := CurrentClientType = Clienttype::Phone;
        GetRecFilters;
        SetRecFilters;
    end;

    var
        Cust: Record Customer;
        CustDiscGr: Record "Customer Discount Group";
        Campaign: Record Campaign;
        Item: Record Item;
        ItemDiscGr: Record "Item Discount Group";
        SalesTypeFilter: Option Customer,"Customer Discount Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text;
        ItemTypeFilter: Option Item,"Item Discount Group","None";
        CodeFilter: Text;
        StartingDateFilter: Text[30];
        Text000: label 'All Customers';
        CurrencyCodeFilter: Text;
        [InDataSet]
        SalesCodeEditable: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;
        IsOnMobile: Boolean;

    local procedure GetRecFilters()
    begin
        if GetFilters <> '' then
          UpdateBasicRecFilters;
    end;


    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;
        CodeFilterCtrlEnable := true;

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

        if ItemTypeFilter <> Itemtypefilter::None then
          SetRange(Type,ItemTypeFilter)
        else
          SetRange(Type);

        if ItemTypeFilter = Itemtypefilter::None then begin
          CodeFilterCtrlEnable := false;
          CodeFilter := '';
        end;

        if CodeFilter <> '' then begin
          SetFilter(Code,CodeFilter);
        end else
          SetRange(Code);

        if CurrencyCodeFilter <> '' then begin
          SetFilter("Currency Code",CurrencyCodeFilter);
        end else
          SetRange("Currency Code");

        if StartingDateFilter <> '' then
          SetFilter("Starting Date",StartingDateFilter)
        else
          SetRange("Starting Date");

        CurrPage.Update(false);
    end;

    local procedure GetCaption(): Text[250]
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
        case ItemTypeFilter of
          Itemtypefilter::Item:
            begin
              SourceTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,27);
              Item.SetFilter("No.",CodeFilter);
              if not Item.FindFirst then
                Clear(Item);
            end;
          Itemtypefilter::"Item Discount Group":
            begin
              SourceTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,341);
              ItemDiscGr.SetFilter(Code,CodeFilter);
              if not ItemDiscGr.FindFirst then
                Clear(ItemDiscGr);
            end;
        end;

        SalesSrcTableName := '';
        case SalesTypeFilter of
          Salestypefilter::Customer:
            begin
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,18);
              Cust.SetFilter("No.",SalesCodeFilter);
              if Cust.FindFirst then
                Description := Cust.Name;
            end;
          Salestypefilter::"Customer Discount Group":
            begin
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,340);
              CustDiscGr.SetFilter(Code,SalesCodeFilter);
              if CustDiscGr.FindFirst then
                Description := CustDiscGr.Description;
            end;
          Salestypefilter::Campaign:
            begin
              SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."object type"::Table,5071);
              Campaign.SetFilter("No.",SalesCodeFilter);
              if Campaign.FindFirst then
                Description := Campaign.Description;
            end;
          Salestypefilter::"All Customers":
            begin
              SalesSrcTableName := Text000;
              Description := '';
            end;
        end;

        if SalesSrcTableName = Text000 then
          exit(StrSubstNo('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
        exit(StrSubstNo('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
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

    local procedure ItemTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
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
          Format("sales type"::"Customer Disc. Group"):
            exit(1);
          Format("sales type"::"All Customers"):
            exit(2);
          Format("sales type"::Campaign):
            exit(3);
        end;
    end;

    local procedure GetTypeFilter(): Integer
    begin
        case GetFilter(Type) of
          Format(Type::Item):
            exit(0);
          Format(Type::"Item Disc. Group"):
            exit(1);
        end;
    end;

    local procedure FilterLines()
    var
        FilterPageBuilder: FilterPageBuilder;
    begin
        FilterPageBuilder.AddTable(TableCaption,Database::"Sales Line Discount");
        FilterPageBuilder.SetView(TableCaption,GetView);

        if GetFilter("Sales Type") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Sales Type"));
        if GetFilter("Sales Code") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Sales Code"));
        if GetFilter(Type) = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo(Type));
        if GetFilter(Code) = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo(Code));
        if GetFilter("Starting Date") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Starting Date"));
        if GetFilter("Currency Code") = '' then
          FilterPageBuilder.AddFieldNo(TableCaption,FieldNo("Currency Code"));

        if FilterPageBuilder.RunModal then
          SetView(FilterPageBuilder.GetView(TableCaption));

        UpdateBasicRecFilters;
        SetEditableFields;
    end;

    local procedure UpdateBasicRecFilters()
    begin
        if GetFilter("Sales Type") <> '' then
          SalesTypeFilter := GetSalesTypeFilter
        else
          SalesTypeFilter := Salestypefilter::None;

        if GetFilter(Type) <> '' then
          ItemTypeFilter := GetTypeFilter
        else
          ItemTypeFilter := Itemtypefilter::None;

        SalesCodeFilter := GetFilter("Sales Code");
        CodeFilter := GetFilter(Code);
        CurrencyCodeFilter := GetFilter("Currency Code");
        Evaluate(StartingDateFilter,GetFilter("Starting Date"));
    end;

    local procedure SetEditableFields()
    begin
        SalesCodeEditable := "Sales Type" <> "sales type"::"All Customers";
    end;
}

