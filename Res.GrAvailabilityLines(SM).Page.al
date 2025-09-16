#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6012 "Res.Gr Availability Lines (SM)"
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
                field(Capacity;ResGr.Capacity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Capacity';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    var
                        ResCapacityEntry: Record "Res. Capacity Entry";
                    begin
                        ResCapacityEntry.SetRange("Resource Group No.",ResGr."No.");
                        ResCapacityEntry.SetRange(Date,"Period Start","Period End");
                        Page.RunModal(0,ResCapacityEntry);
                    end;
                }
                field("ResGr.""Qty. on Service Order""";ResGr."Qty. on Service Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Service Order';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    var
                        ServOrderAlloc: Record "Service Order Allocation";
                    begin
                        ServOrderAlloc.SetRange("Resource Group No.",ResGr."No.");
                        ServOrderAlloc.SetRange("Allocation Date","Period Start","Period End");
                        ServOrderAlloc.SetFilter(Status,'%1|%2',ServOrderAlloc.Status::Active,ServOrderAlloc.Status::Finished);
                        ServOrderAlloc.SetRange(Posted,false);
                        Page.RunModal(0,ServOrderAlloc);
                    end;
                }
                field(NetAvailability;NetAvailability)
                {
                    ApplicationArea = Basic;
                    Caption = 'Net Availability';
                    DecimalPlaces = 0:5;
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
        ResGr.CalcFields(Capacity,"Qty. on Service Order");
        CapacityAfterOrders := ResGr.Capacity;
        CapacityAfterQuotes := CapacityAfterOrders;
        NetAvailability := CapacityAfterQuotes - ResGr."Qty. on Service Order";
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
        ResGr: Record "Resource Group";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        CapacityAfterOrders: Decimal;
        CapacityAfterQuotes: Decimal;
        NetAvailability: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";


    procedure Set(var NewResGr: Record "Resource Group";NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        ResGr.Copy(NewResGr);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          ResGr.SetRange("Date Filter","Period Start","Period End")
        else
          ResGr.SetRange("Date Filter",0D,"Period End");
    end;
}

