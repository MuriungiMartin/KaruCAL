#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 492 "Item Availability by Location"
{
    Caption = 'Item Availability by Location';
    DataCaptionFields = "No.",Description;
    DeleteAllowed = false;
    Editable = true;
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
                field(ItemPeriodLength;ItemPeriodLength)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        if ItemPeriodLength = Itemperiodlength::Period then
                          PeriodItemPeriodLengthOnValida;
                        if ItemPeriodLength = Itemperiodlength::Year then
                          YearItemPeriodLengthOnValidate;
                        if ItemPeriodLength = Itemperiodlength::Quarter then
                          QuarterItemPeriodLengthOnValid;
                        if ItemPeriodLength = Itemperiodlength::Month then
                          MonthItemPeriodLengthOnValidat;
                        if ItemPeriodLength = Itemperiodlength::Week then
                          WeekItemPeriodLengthOnValidate;
                        if ItemPeriodLength = Itemperiodlength::Day then
                          DayItemPeriodLengthOnValidate;
                    end;
                }
                field(AmountType;AmountType)
                {
                    ApplicationArea = Basic;
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
            part(ItemAvailLocLines;"Item Avail. by Location Lines")
            {
                Editable = false;
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
                        ApplicationArea = Basic;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByEvent);
                        end;
                    }
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No."=field("No."),
                                      "Global Dimension 1 Filter"=field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter"=field("Global Dimension 2 Filter"),
                                      "Location Filter"=field("Location Filter"),
                                      "Drop Shipment Filter"=field("Drop Shipment Filter"),
                                      "Variant Filter"=field("Variant Filter");
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

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromItem(Rec,ItemAvailFormsMgt.ByBOM);
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            action("Previous Period")
            {
                ApplicationArea = Basic;
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Previous Period';

                trigger OnAction()
                begin
                    FindPeriod('<=');
                    UpdateSubForm;
                end;
            }
            action("Next Period")
            {
                ApplicationArea = Basic;
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Next Period';

                trigger OnAction()
                begin
                    FindPeriod('>=');
                    UpdateSubForm;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetRange("Drop Shipment Filter",false);
        FindPeriod('');
        UpdateSubForm;
    end;

    trigger OnClosePage()
    var
        Location: Record Location;
    begin
        CurrPage.ItemAvailLocLines.Page.GetRecord(Location);
        LastLocation := Location.Code;
    end;

    trigger OnOpenPage()
    begin
        FindPeriod('');
    end;

    var
        Calendar: Record Date;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ItemPeriodLength: Option Day,Week,Month,Quarter,Year,Period;
        AmountType: Option "Net Change","Balance at Date";
        LastLocation: Code[10];

    local procedure FindPeriod(SearchText: Code[10])
    var
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        if GetFilter("Date Filter") <> '' then begin
          Calendar.SetFilter("Period Start",GetFilter("Date Filter"));
          if not PeriodFormMgt.FindDate('+',Calendar,ItemPeriodLength) then
            PeriodFormMgt.FindDate('+',Calendar,Itemperiodlength::Day);
          Calendar.SetRange("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText,Calendar,ItemPeriodLength);
        if AmountType = Amounttype::"Net Change" then begin
          SetRange("Date Filter",Calendar."Period Start",Calendar."Period End");
          if GetRangeMin("Date Filter") = GetRangemax("Date Filter") then
            SetRange("Date Filter",GetRangeMin("Date Filter"));
        end else
          SetRange("Date Filter",0D,Calendar."Period End");
    end;

    local procedure UpdateSubForm()
    begin
        CurrPage.ItemAvailLocLines.Page.Set(Rec,AmountType);
    end;


    procedure GetLastLocation(): Code[10]
    begin
        exit(LastLocation);
    end;

    local procedure PeriodItemPeriodLengthOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure YearItemPeriodLengthOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure QuarterItemPeriodLengthOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure MonthItemPeriodLengthOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure WeekItemPeriodLengthOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure DayItemPeriodLengthOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure NetChangeAmountTypeOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure BalanceatDateAmountTypeOnPush()
    begin
        FindPeriod('');
        UpdateSubForm;
    end;

    local procedure DayItemPeriodLengthOnValidate()
    begin
        DayItemPeriodLengthOnPush;
    end;

    local procedure WeekItemPeriodLengthOnValidate()
    begin
        WeekItemPeriodLengthOnPush;
    end;

    local procedure MonthItemPeriodLengthOnValidat()
    begin
        MonthItemPeriodLengthOnPush;
    end;

    local procedure QuarterItemPeriodLengthOnValid()
    begin
        QuarterItemPeriodLengthOnPush;
    end;

    local procedure YearItemPeriodLengthOnValidate()
    begin
        YearItemPeriodLengthOnPush;
    end;

    local procedure PeriodItemPeriodLengthOnValida()
    begin
        PeriodItemPeriodLengthOnPush;
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

