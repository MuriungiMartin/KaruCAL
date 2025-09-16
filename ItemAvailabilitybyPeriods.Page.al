#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 157 "Item Availability by Periods"
{
    Caption = 'Item Availability by Periods';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        if PeriodType = Periodtype::Period then
                          PeriodPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Year then
                          YearPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Quarter then
                          QuarterPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Month then
                          MonthPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Week then
                          WeekPeriodTypeOnValidate;
                        if PeriodType = Periodtype::Day then
                          DayPeriodTypeOnValidate;
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View as';
                    OptionCaption = 'Net Change,Balance at Date';
                    ToolTip = 'Specifies how amounts are displayed. Net Change: The net change in the balance for the selected period. Balance at Date: The balance as of the last day in the selected period.';

                    trigger OnValidate()
                    begin
                        if AmountType = Amounttype::"Balance at Date" then
                          BalanceatDateAmountTypeOnValid;
                        if AmountType = Amounttype::"Net Change" then
                          NetChangeAmountTypeOnValidate;
                    end;
                }
            }
            part(ItemAvailLines;"Item Availability Lines")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Item")
            {
                Caption = '&Item';
                Image = Item;
                group("&Item Availability by")
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Event';
                        Image = "Event";
                        ToolTip = 'View how the actual and projected inventory level of an item will develop over time according to supply and demand events.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No."=field("No."),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Filter"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Filter");
                        ToolTip = 'Show the actual and projected quantity of an item over time according to a specified time interval, such as by day, week or month.';
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No."=field("No."),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Filter"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Filter");
                        ToolTip = 'Show the actual and projected quantity of an item over time according to a specified variant.';
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No."=field("No."),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Filter"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Filter");
                    }
                    action("BOM Level")
                    {
                        ApplicationArea = Basic;
                        Caption = 'BOM Level';
                        Image = BOMLevel;
                        ToolTip = 'Show the availability figures for BOM items that indicate how many units of a parent you can make based on the availability of child items.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetRange("Drop Shipment Filter",false);
        UpdateSubForm;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
    end;

    var
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        PeriodType: Option Day,Week,Month,Quarter,Year,Period;
        AmountType: Option "Net Change","Balance at Date";
        LastDate: Date;

    local procedure UpdateSubForm()
    begin
        CurrPage.ItemAvailLines.Page.Set(Rec,PeriodType,AmountType);
    end;


    procedure GetLastDate(): Date
    begin
        exit(LastDate);
    end;

    local procedure DayPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure WeekPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure MonthPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure QuarterPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure YearPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure PeriodPeriodTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure BalanceatDateAmountTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure NetChangeAmountTypeOnPush()
    begin
        UpdateSubForm;
    end;

    local procedure LookupOKOnPush()
    var
        Date: Record Date;
    begin
        CurrPage.ItemAvailLines.Page.GetRecord(Date);
        LastDate := Date."Period Start";
    end;

    local procedure DayPeriodTypeOnValidate()
    begin
        DayPeriodTypeOnPush;
    end;

    local procedure WeekPeriodTypeOnValidate()
    begin
        WeekPeriodTypeOnPush;
    end;

    local procedure MonthPeriodTypeOnValidate()
    begin
        MonthPeriodTypeOnPush;
    end;

    local procedure QuarterPeriodTypeOnValidate()
    begin
        QuarterPeriodTypeOnPush;
    end;

    local procedure YearPeriodTypeOnValidate()
    begin
        YearPeriodTypeOnPush;
    end;

    local procedure PeriodPeriodTypeOnValidate()
    begin
        PeriodPeriodTypeOnPush;
    end;

    local procedure NetChangeAmountTypeOnValidate()
    begin
        NetChangeAmountTypeOnPush;
    end;

    local procedure BalanceatDateAmountTypeOnValid()
    begin
        BalanceatDateAmountTypeOnPush;
    end;
}

