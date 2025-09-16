#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5956 "Service Load Level"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Load Level.rdlc';
    Caption = 'Service Load Level';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Resource;Resource)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Resource Group No.","Date Filter","Unit of Measure Filter","Chargeable Filter","Service Zone Filter";
            column(ReportForNavId_5508; 5508)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(SelctnFrmtSTRQtyCostPrice;Text001 + ' ' + Format(SelectStr(Selection + 1,Text002)))
            {
            }
            column(ResTblCptnResourceFilter;TableCaption + ': ' + ResourceFilter)
            {
            }
            column(ResourceFilter;ResourceFilter)
            {
            }
            column(Selection;Selection)
            {
            }
            column(Values1;Values[1])
            {
                DecimalPlaces = 0:5;
            }
            column(Values2;Values[2])
            {
                DecimalPlaces = 0:5;
            }
            column(Values3;Values[3])
            {
                DecimalPlaces = 0:5;
            }
            column(Values4;Values[4])
            {
                DecimalPlaces = 0:5;
            }
            column(Values5;Values[5])
            {
                DecimalPlaces = 0:5;
            }
            column(No_Resource;"No.")
            {
                IncludeCaption = true;
            }
            column(Name_Resource;Name)
            {
                IncludeCaption = true;
            }
            column(Values6;Values[6])
            {
                DecimalPlaces = 0:5;
            }
            column(ServiceLoadLevelCaption;ServiceLoadLevelCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(UnusedCaption;UnusedCaptionLbl)
            {
            }
            column(UnusedCaption1;UnusedCaption1Lbl)
            {
            }
            column(UsageCaption;UsageCaptionLbl)
            {
            }
            column(CapacityCaption;CapacityCaptionLbl)
            {
            }
            column(SalesCaption;SalesCaptionLbl)
            {
            }
            column(SalesCaption1;SalesCaption1Lbl)
            {
            }
            column(QTYCaption;QTYCaptionLbl)
            {
            }
            column(CostCaption;CostCaptionLbl)
            {
            }
            column(PriceCaption;PriceCaptionLbl)
            {
            }
            column(ReporttotalCaption;ReporttotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                case Selection of
                  Selection::Quantity:
                    begin
                      CalcFields(Capacity,"Usage (Qty.)","Sales (Qty.)");
                      Values[1] := Capacity;
                      Values[2] := "Usage (Qty.)";
                      Values[3] := Capacity - "Usage (Qty.)";
                      Values[5] := "Sales (Qty.)";
                    end;
                  Selection::Cost:
                    begin
                      CalcFields(Capacity,"Usage (Cost)","Sales (Cost)");
                      Values[1] := Capacity * "Unit Cost";
                      Values[2] := "Usage (Cost)";
                      Values[3] := Values[1] - "Usage (Cost)";
                      Values[5] := "Sales (Cost)";
                    end;
                  Selection::Price:
                    begin
                      CalcFields(Capacity,"Usage (Price)","Sales (Price)");
                      Values[1] := Capacity * "Unit Price";
                      Values[2] := "Usage (Price)";
                      Values[3] := Values[1] - "Usage (Price)";
                      Values[5] := "Sales (Price)";
                    end;
                end;

                if Values[1] <> 0 then
                  Values[4] := Values[3] / Values[1] * 100
                else
                  Values[4] := 0;

                if Values[2] <> 0 then
                  Values[6] := Values[5] / Values[2] * 100
                else
                  Values[6] := 0;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(Values[1],Values[2],Values[3],Values[5]);
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
                    field(Selection;Selection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Selection';
                        OptionCaption = 'Quantity,Cost,Price';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ResourceFilter := Resource.GetFilters;
    end;

    var
        ResourceFilter: Text;
        Selection: Option Quantity,Cost,Price;
        Values: array [6] of Decimal;
        Text001: label 'Selection :';
        Text002: label 'Quantity,Cost,Price';
        ServiceLoadLevelCaptionLbl: label 'Service Load Level';
        CurrReportPageNoCaptionLbl: label 'Page';
        UnusedCaptionLbl: label 'Unused';
        UnusedCaption1Lbl: label 'Unused %';
        UsageCaptionLbl: label 'Usage';
        CapacityCaptionLbl: label 'Capacity';
        SalesCaptionLbl: label 'Sales';
        SalesCaption1Lbl: label 'Sales %';
        QTYCaptionLbl: label '(QTY)';
        CostCaptionLbl: label '(Cost)';
        PriceCaptionLbl: label '(Price)';
        ReporttotalCaptionLbl: label 'Report total';


    procedure InitializeRequest(NewSelection: Option)
    begin
        Selection := NewSelection;
    end;
}

