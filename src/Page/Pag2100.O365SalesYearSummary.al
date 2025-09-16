#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2100 "O365 Sales Year Summary"
{
    Caption = 'Year to Date';
    CardPageID = "O365 Sales Month Summary";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(MonthyInfo)
            {
                Caption = '';
                InstructionalText = 'Tap a month to see a weekly overview';
            }
            usercontrol(Chart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                begin
                    ShowMonth(point.XValueString);
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                var
                    GLSetup: Record "General Ledger Setup";
                    O365SalesStatistics: Codeunit "O365 Sales Statistics";
                begin
                    GLSetup.Get;

                    O365SalesStatistics.GenerateChart(CurrPage.Chart,Rec,MonthTxt,StrSubstNo(AmountTxt,GLSetup.GetCurrencySymbol))
                end;

                trigger Refresh()
                var
                    GLSetup: Record "General Ledger Setup";
                    O365SalesStatistics: Codeunit "O365 Sales Statistics";
                begin
                    GLSetup.Get;

                    O365SalesStatistics.GenerateChart(CurrPage.Chart,Rec,MonthTxt,StrSubstNo(AmountTxt,GLSetup.GetCurrencySymbol))
                end;
            }
            repeater(Control2)
            {
                field(Date;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the summarized date.';
                }
                field("Amount (LCY)";Value)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the summarized amount in $.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Show Weekly Summary")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show Weekly Summary';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "O365 Sales Month Summary";
                RunPageOnRec = true;
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Displays a weekly overview of the selected month.';
            }
        }
    }

    trigger OnOpenPage()
    var
        O365SalesStatistics: Codeunit "O365 Sales Statistics";
    begin
        O365SalesStatistics.GenerateMonthlyOverview(Rec);
    end;

    var
        MonthTxt: label 'Month';
        AmountTxt: label 'Amount (%1)', Comment='%1=Currency Symbol (e.g. $)';

    local procedure ShowMonth(Month: Text)
    var
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        TypeHelper: Codeunit "Type Helper";
    begin
        Get(TypeHelper.GetLocalizedMonthToInt(Month));
        TempNameValueBuffer.Copy(Rec);

        Page.Run(Page::"O365 Sales Month Summary",TempNameValueBuffer);
    end;
}

