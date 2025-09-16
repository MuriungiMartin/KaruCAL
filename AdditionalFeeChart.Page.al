#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1051 "Additional Fee Chart"
{
    Caption = 'Additional Fee Visualization';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ChargePerLine;ChargePerLine)
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Fee';
                    Visible = ShowOptions;

                    trigger OnValidate()
                    begin
                        UpdateData;
                    end;
                }
                field(Currency;Currency)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    LookupPageID = Currencies;
                    TableRelation = Currency.Code;
                    ToolTip = 'Specifies the currency code that amounts are shown in.';

                    trigger OnValidate()
                    begin
                        UpdateData;
                    end;
                }
                field("Max. Remaining Amount";MaxRemAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Max. Remaining Amount';
                    MinValue = 0;
                    ToolTip = 'Specifies the maximum amount that is displayed as remaining in the chart.';

                    trigger OnValidate()
                    begin
                        UpdateData;
                    end;
                }
            }
            group(Graph)
            {
                Caption = 'Graph';
                usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
                {
                    ApplicationArea = Basic;

                    trigger AddInReady()
                    begin
                        AddInIsReady := true;
                        UpdateData;
                    end;

                    trigger Refresh()
                    begin
                        UpdateData;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Update(CurrPage.BusinessChart);
    end;

    var
        ReminderLevel: Record "Reminder Level";
        TempSortingTable: Record "Sorting Table" temporary;
        ChargePerLine: Boolean;
        RemAmountTxt: label 'Remaining Amount';
        Currency: Code[10];
        MaxRemAmount: Decimal;
        ShowOptions: Boolean;
        AddInIsReady: Boolean;


    procedure SetViewMode(SetReminderLevel: Record "Reminder Level";SetChargePerLine: Boolean;SetShowOptions: Boolean)
    begin
        ReminderLevel := SetReminderLevel;
        ChargePerLine := SetChargePerLine;
        ShowOptions := SetShowOptions;
    end;


    procedure UpdateData()
    begin
        if not AddInIsReady then
          exit;

        TempSortingTable.UpdateData(Rec,ReminderLevel,ChargePerLine,Currency,RemAmountTxt,MaxRemAmount);
        Update(CurrPage.BusinessChart);
    end;
}

