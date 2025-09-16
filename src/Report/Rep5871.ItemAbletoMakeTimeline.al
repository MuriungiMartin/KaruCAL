#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5871 "Item - Able to Make (Timeline)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item - Able to Make (Timeline).rdlc';
    Caption = 'Item - Able to Make (Timeline)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Location Filter","Variant Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Item__No__;"No.")
            {
                IncludeCaption = true;
            }
            column(Item_Description;Description)
            {
                IncludeCaption = true;
            }
            dataitem(BOMBufferLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1925; 1925)
                {
                }
                column(TotalQty;TotalQty)
                {
                    DecimalPlaces = 0:5;
                }
                column(GrossReqQty;GrossReqQty)
                {
                    DecimalPlaces = 0:5;
                }
                column(SchRcptQty;SchRcptQty)
                {
                    DecimalPlaces = 0:5;
                }
                column(InvtQty;InvtQty)
                {
                    DecimalPlaces = 0:5;
                }
                column(AbleToMakeQty;AbleToMakeQty)
                {
                    DecimalPlaces = 0:5;
                }
                column(AsOfPeriod;Format(AsOfPeriod))
                {
                }
                column(ShowDetails;ShowDetails)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number <> 1 then begin
                      CurrDate := CalcDate(DateFormula,CurrDate);
                      GenerateAvailTrend(CurrDate);
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,NoOfIntervals);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrDate := StartDate;
                if not GenerateAvailTrend(CurrDate) then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                Evaluate(DateFormula,GetDateFormulaInterval);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartDate;StartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(DateInterval;DateInterval)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date Interval';
                    }
                    field(NoOfIntervals;NoOfIntervals)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Intervals';
                        MaxValue = 31;
                        MinValue = 1;

                        trigger OnValidate()
                        begin
                            if NoOfIntervals > 31 then
                              Error(Text000)
                        end;
                    }
                    field(ShowDetails;ShowDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Details';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            if NoOfIntervals = 0 then
              NoOfIntervals := 7;
        end;
    }

    labels
    {
        ItemAbleToMakeProjectionCaption = 'Item - Able to Make (Timeline)';
        AsOfPeriodCaption = 'As of Period';
        CurrReport_PAGENOCaption = 'Page';
        TotalQtyCaption = 'Total';
        GrossReqQtyCaption = 'Gross Requirement';
        SchRcptQtyCaption = 'Scheduled Receipts';
        InvtQtyCaption = 'Inventory';
        AbleToMakeQtyCaption = 'Able to Make';
    }

    trigger OnInitReport()
    begin
        StartDate := WorkDate;
    end;

    var
        AsmHeader: Record "Assembly Header";
        ProdOrderLine: Record "Prod. Order Line";
        TempBOMBuffer: Record "BOM Buffer" temporary;
        CalcBOMTree: Codeunit "Calculate BOM Tree";
        DateInterval: Option Day,Week,Month,Quarter,Year;
        NoOfIntervals: Integer;
        StartDate: Date;
        AbleToMakeQty: Decimal;
        InvtQty: Decimal;
        SchRcptQty: Decimal;
        GrossReqQty: Decimal;
        TotalQty: Decimal;
        AsOfPeriod: Date;
        Text000: label 'The number of intervals cannot be greater than 31.';
        DateFormula: DateFormula;
        CurrDate: Date;
        ShowDetails: Boolean;
        ShowBy: Option Item,Assembly,Production;

    local procedure GenerateAvailTrend(CurrDate: Date): Boolean
    begin
        CalcBOMTree.SetShowTotalAvailability(true);
        case ShowBy of
          Showby::Item:
            CalcBOMTree.GenerateTreeForItem(Item,TempBOMBuffer,CurrDate,1);
          Showby::Assembly:
            begin
              AsmHeader."Due Date" := CurrDate;
              CalcBOMTree.GenerateTreeForAsm(AsmHeader,TempBOMBuffer,1);
            end;
          Showby::Production:
            begin
              ProdOrderLine."Due Date" := CurrDate;
              CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine,TempBOMBuffer,1);
            end;
        end;

        if not TempBOMBuffer.FindFirst then
          exit(false);
        AbleToMakeQty := TempBOMBuffer."Able to Make Top Item";
        TotalQty := TempBOMBuffer."Able to Make Top Item" + TempBOMBuffer."Available Quantity";
        CalcQuantities(Item,InvtQty,SchRcptQty,GrossReqQty,CurrDate);
        AsOfPeriod := CurrDate;
        exit(true);
    end;

    local procedure GetDateFormulaInterval(): Text[10]
    begin
        case DateInterval of
          Dateinterval::Day:
            exit('<+1D>');
          Dateinterval::Week:
            exit('<CW+1D>');
          Dateinterval::Month:
            exit('<CM+1D>');
          Dateinterval::Quarter:
            exit('<CQ+1D>');
          Dateinterval::Year:
            exit('<CY+1D>');
        end;
    end;


    procedure Initialize(NewStartingDate: Date;NewDateInterval: Option;NewNoOfIntervals: Integer;NewShowDetails: Boolean)
    begin
        StartDate := NewStartingDate;
        DateInterval := NewDateInterval;
        NoOfIntervals := NewNoOfIntervals;
        ShowDetails := NewShowDetails;
    end;


    procedure InitAsmOrder(NewAsmHeader: Record "Assembly Header")
    begin
        AsmHeader := NewAsmHeader;
        ShowBy := Showby::Assembly;
    end;


    procedure InitProdOrder(NewProdOrderLine: Record "Prod. Order Line")
    begin
        ProdOrderLine := NewProdOrderLine;
        ShowBy := Showby::Production;
    end;

    local procedure CalcQuantities(var Item: Record Item;var InvtQty: Decimal;var SchRcptQty: Decimal;var GrossReqQty: Decimal;Date: Date)
    var
        Item2: Record Item;
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        PlannedOrderReceipt: Decimal;
        PlannedOrderReleases: Decimal;
    begin
        Item2.Copy(Item);

        Item2.CalcFields(Inventory);
        InvtQty := Item2.Inventory;

        Item2.SetRange("Date Filter",0D,Date);
        ItemAvailFormsMgt.CalculateNeed(Item2,GrossReqQty,PlannedOrderReceipt,SchRcptQty,PlannedOrderReleases);
    end;
}

