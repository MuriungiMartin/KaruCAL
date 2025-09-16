#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2102 "O365 Sales Month Summary"
{
    Caption = 'This Month';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            usercontrol(Chart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                var
                    GLSetup: Record "General Ledger Setup";
                    TempNameValueBuffer: Record "Name/Value Buffer" temporary;
                    O365SalesStatistics: Codeunit "O365 Sales Statistics";
                begin
                    GLSetup.Get;

                    O365SalesStatistics.GenerateWeeklyOverview(TempNameValueBuffer,SelectedMonth);
                    O365SalesStatistics.GenerateChart(CurrPage.Chart,TempNameValueBuffer,WeekTxt,StrSubstNo(AmountTxt,GLSetup.GetCurrencySymbol));
                end;

                trigger Refresh()
                var
                    GLSetup: Record "General Ledger Setup";
                    TempNameValueBuffer: Record "Name/Value Buffer" temporary;
                    O365SalesStatistics: Codeunit "O365 Sales Statistics";
                begin
                    GLSetup.Get;

                    O365SalesStatistics.GenerateWeeklyOverview(TempNameValueBuffer,SelectedMonth);
                    O365SalesStatistics.GenerateChart(CurrPage.Chart,TempNameValueBuffer,WeekTxt,StrSubstNo(AmountTxt,GLSetup.GetCurrencySymbol));
                end;
            }
            part(O365MonthlyCustomerListpart;"O365 Monthly Customer Listpart")
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        if Name = '' then
          SelectedMonth := ID
        else
          SelectedMonth := TypeHelper.GetLocalizedMonthToInt(Name);

        ShowCustomers;

        if Insert then;
    end;

    var
        WeekTxt: label 'Week';
        AmountTxt: label 'Amount (%1)', Comment='%1=Currency Symbol (e.g. $)';
        SelectedMonth: Integer;

    local procedure ShowCustomers()
    var
        Customer: Record Customer;
        O365SalesStatistics: Codeunit "O365 Sales Statistics";
    begin
        if O365SalesStatistics.GenerateMonthlyCustomers(SelectedMonth,Customer) then
          CurrPage.O365MonthlyCustomerListpart.Page.InsertData(Customer);
    end;
}

