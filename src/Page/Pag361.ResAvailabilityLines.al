#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 361 "Res. Availability Lines"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Start';
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Name';
                }
                field(Capacity;Res.Capacity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Capacity';
                    DecimalPlaces = 0:5;
                }
                field("Res.""Qty. on Order (Job)""";Res."Qty. on Order (Job)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Order (Job)';
                    DecimalPlaces = 0:5;
                }
                field(CapacityAfterOrders;CapacityAfterOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Availability After Orders';
                    DecimalPlaces = 0:5;
                }
                field("Res.""Qty. Quoted (Job)""";Res."Qty. Quoted (Job)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Quotes Allocation';
                    DecimalPlaces = 0:5;
                }
                field(CapacityAfterQuotes;CapacityAfterQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Availability After Quotes';
                    DecimalPlaces = 0:5;
                }
                field("Res.""Qty. on Service Order""";Res."Qty. on Service Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Service Order';
                }
                field(QtyOnAssemblyOrder;Res."Qty. on Assembly Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Assembly Order';
                }
                field(NetAvailability;NetAvailability)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Net Availability';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetDateFilter;
        Res.CalcFields(Capacity,"Qty. on Order (Job)","Qty. Quoted (Job)","Qty. on Service Order","Qty. on Assembly Order");
        CapacityAfterOrders := Res.Capacity - Res."Qty. on Order (Job)";
        CapacityAfterQuotes := CapacityAfterOrders - Res."Qty. Quoted (Job)";
        NetAvailability := CapacityAfterQuotes - Res."Qty. on Service Order" - Res."Qty. on Assembly Order";
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,PeriodType));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,PeriodType));
    end;

    trigger OnOpenPage()
    begin
        Reset;
    end;

    var
        Res: Record Resource;
        PeriodFormMgt: Codeunit PeriodFormManagement;
        CapacityAfterOrders: Decimal;
        CapacityAfterQuotes: Decimal;
        NetAvailability: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";


    procedure Set(var NewRes: Record Resource;NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        Res.Copy(NewRes);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          Res.SetRange("Date Filter","Period Start","Period End")
        else
          Res.SetRange("Date Filter",0D,"Period End");
    end;
}

