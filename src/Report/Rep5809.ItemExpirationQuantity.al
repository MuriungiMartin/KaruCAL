#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5809 "Item Expiration - Quantity"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Expiration - Quantity.rdlc';
    Caption = 'Item Expiration - Quantity';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Header;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(0));
            column(ReportForNavId_7745; 7745)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemCaption;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter = '')
            {
            }
            column(PeriodStartDate21;PeriodStartDate[2] + 1)
            {
            }
            column(PeriodStartDate3;PeriodStartDate[3])
            {
            }
            column(PeriodStartDate31;PeriodStartDate[3] + 1)
            {
            }
            column(PeriodStartDate4;PeriodStartDate[4])
            {
            }
            column(PeriodStartDate41;PeriodStartDate[4] + 1)
            {
            }
            column(PeriodStartDate5;PeriodStartDate[5])
            {
            }
        }
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Inventory Posting Group","Statistics Group","Location Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(No_Item;"No.")
            {
            }
            column(Description_Item;Description)
            {
            }
            dataitem("Item Ledger Entry";"Item Ledger Entry")
            {
                DataItemLink = "Item No."=field("No."),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date","Expiration Date","Lot No.","Serial No.") where(Open=const(true));
                column(ReportForNavId_7209; 7209)
                {
                }
                column(InvtQty1;InvtQty[1])
                {
                    DecimalPlaces = 0:2;
                }
                column(InvtQty2;InvtQty[2])
                {
                    DecimalPlaces = 0:2;
                }
                column(InvtQty3;InvtQty[3])
                {
                    DecimalPlaces = 0:2;
                }
                column(InvtQty4;InvtQty[4])
                {
                    DecimalPlaces = 0:2;
                }
                column(InvtQty5;InvtQty[5])
                {
                    DecimalPlaces = 0:2;
                }
                column(TotalInvtQty;TotalInvtQty)
                {
                    DecimalPlaces = 0:2;
                }

                trigger OnAfterGetRecord()
                begin
                    for i := 1 to 5 do
                      InvtQty[i] := 0;

                    TotalInvtQty := "Remaining Quantity";
                    for i := 1 to 5 do
                      if ("Expiration Date" > PeriodStartDate[i]) and
                         ("Expiration Date" <= PeriodStartDate[i + 1])
                      then
                        InvtQty[i] := "Remaining Quantity";
                end;

                trigger OnPreDataItem()
                begin
                    SetFilter("Expiration Date",'<>%1',0D);
                    SetFilter("Remaining Quantity",'<>%1',0);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(EndingDate;PeriodStartDate[5])
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';

                        trigger OnValidate()
                        begin
                            if PeriodStartDate[5] = 0D then
                              Error(Text002);
                        end;
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Length';

                        trigger OnValidate()
                        begin
                            if (CalcDate(PeriodLength) - Today < 1) or (Format(PeriodLength) = '') then
                              Error(Text003);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PeriodStartDate[5] = 0D then
              PeriodStartDate[5] := CalcDate('<CM>',WorkDate);
            if Format(PeriodLength) = '' then
              Evaluate(PeriodLength,'<1M>');
        end;
    }

    labels
    {
        ItemExpirationQutyCaption = 'Item Expiration - Quantity';
        PageCaption = 'Page';
        AfterCaption = 'After...';
        BeforeCaption = '...Before';
        TotalInvtQtyCaption = 'Inventory';
        DescriptionCaption = 'Description';
        ItemNoCaption = 'Item No.';
    }

    trigger OnPreReport()
    var
        NegPeriodLength: DateFormula;
    begin
        ItemFilter := Item.GetFilters;

        PeriodStartDate[6] := Dmy2date(31,12,9999);
        Evaluate(NegPeriodLength,StrSubstNo('-%1',Format(PeriodLength)));
        for i := 1 to 3 do
          PeriodStartDate[5 - i] := CalcDate(NegPeriodLength,PeriodStartDate[6 - i]);
    end;

    var
        Text002: label 'Enter the ending date.';
        ItemFilter: Text;
        InvtQty: array [6] of Decimal;
        PeriodStartDate: array [7] of Date;
        PeriodLength: DateFormula;
        i: Integer;
        TotalInvtQty: Decimal;
        Text003: label 'The minimum permitted value is 1D.';


    procedure InitializeRequest(NewPeriodStartDate: Date;NewPeriodLength: DateFormula)
    begin
        PeriodStartDate[5] := NewPeriodStartDate;
        PeriodLength := NewPeriodLength;
    end;
}

