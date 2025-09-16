#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6007 "Res. Availability Lines (SM)"
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

                    trigger OnDrillDown()
                    var
                        ResCapacityEntry: Record "Res. Capacity Entry";
                    begin
                        ResCapacityEntry.SetRange("Resource No.",Res."No.");
                        ResCapacityEntry.SetRange(Date,"Period Start","Period End");
                        Page.RunModal(0,ResCapacityEntry);
                    end;
                }
                field("Res.""Qty. on Service Order""";Res."Qty. on Service Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qty. on Service Order';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        ServOrderAlloc.SetCurrentkey("Resource No.","Document Type","Allocation Date",Status,Posted);
                        ServOrderAlloc.SetRange("Resource No.",Res."No.");
                        ServOrderAlloc.SetFilter("Document Type",'%1|%2',ServOrderAlloc."document type"::Quote,ServOrderAlloc."document type"::Order);
                        ServOrderAlloc.SetRange("Allocation Date","Period Start","Period End");
                        ServOrderAlloc.SetFilter(Status,'=%1|%2',ServOrderAlloc.Status::Active,ServOrderAlloc.Status::Finished);
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
        Res.CalcFields(Capacity,"Qty. on Service Order");
        CapacityAfterOrders := Res.Capacity;
        CapacityAfterQuotes := CapacityAfterOrders;
        NetAvailability := CapacityAfterQuotes - Res."Qty. on Service Order";
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
        ServOrderAlloc: Record "Service Order Allocation";
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

