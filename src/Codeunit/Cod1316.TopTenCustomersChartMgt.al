#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1316 "Top Ten Customers Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        CustomerXCaptionTxt: label 'Customer Name';
        SalesLCYYCaptionTxt: label 'Sales ($)';
        AllOtherCustomersTxt: label 'All Other Customers';


    procedure UpdateChart(var BusChartBuf: Record "Business Chart Buffer")
    var
        ColumnIndex: Integer;
        CustomerName: array [11] of Text[50];
        SalesLCY: array [11] of Decimal;
    begin
        with BusChartBuf do begin
          Initialize;
          AddMeasure(SalesLCYYCaptionTxt,1,"data type"::Decimal,"chart type"::StackedColumn);
          SetXAxis(CustomerXCaptionTxt,"data type"::String);
          CalcTopTenSalesCustomers(CustomerName,SalesLCY);
          for ColumnIndex := 1 to 11 do begin
            AddColumn(CustomerName[ColumnIndex]);
            SetValueByIndex(0,ColumnIndex - 1,SalesLCY[ColumnIndex]);
          end;
        end;
    end;


    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        CustomerName: Variant;
    begin
        BusChartBuf.GetXValue(BusChartBuf."Drill-Down X Index",CustomerName);
        // drill down only for top 10 customers
        // for the 11th column "all other customers", it drills down to customer list of all other customers
        if (BusChartBuf."Drill-Down Measure Index" = 0) and (BusChartBuf."Drill-Down X Index" < 10) then
          DrillDownCust(Format(CustomerName));
        if (BusChartBuf."Drill-Down Measure Index" = 0) and (BusChartBuf."Drill-Down X Index" = 10) then
          DrillDownOtherCustList;
    end;

    local procedure CalcTopTenSalesCustomers(var CustomerName: array [11] of Text[50];var SalesLCY: array [11] of Decimal)
    var
        Customer: Record Customer;
        ColumnIndex: Integer;
    begin
        ColumnIndex := 1;
        Customer.CalcFields("Sales (LCY)");
        Customer.SetCurrentkey("Sales (LCY)");
        Customer.Ascending(false);
        with Customer do begin
          if Find('-') then
            repeat
              // Return Sales (LCY) for top 10 customer, and as 11th measure - the sum of Sales (LCY) for all other customers
              if ColumnIndex <= 10 then begin
                CustomerName[ColumnIndex] := Name;
                SalesLCY[ColumnIndex] := "Sales (LCY)";
              end else
                SalesLCY[11] += "Sales (LCY)";
              ColumnIndex := ColumnIndex + 1;
            until Next = 0;
          CustomerName[11] := AllOtherCustomersTxt;
        end;
    end;

    local procedure DrillDownCust(DrillDownName: Text[50])
    var
        Customer: Record Customer;
    begin
        Customer.SetRange(Name,DrillDownName);
        Customer.FindFirst;
        Page.Run(Page::"Customer Card",Customer);
    end;

    local procedure DrillDownOtherCustList()
    var
        Customer: Record Customer;
    begin
        Customer.SetFilter("No.",GetFilterToExcludeTopTenCustomers);
        Customer.SetCurrentkey(Name);
        Customer.Ascending(true);
        Page.Run(Page::"Customer List",Customer);
    end;

    local procedure GetFilterToExcludeTopTenCustomers(): Text
    var
        Customer: Record Customer;
        CustomerCounter: Integer;
        FilterToExcludeTopTenCustomers: Text;
    begin
        CustomerCounter := 1;
        Customer.CalcFields("Sales (LCY)");
        Customer.SetCurrentkey("Sales (LCY)");
        Customer.Ascending(false);
        with Customer do begin
          if Find('-') then
            repeat
              if CustomerCounter = 1 then
                FilterToExcludeTopTenCustomers := StrSubstNo('<>%1',"No.")
              else
                FilterToExcludeTopTenCustomers += StrSubstNo('&<>%1',"No.");
              CustomerCounter := CustomerCounter + 1;
            until (Next = 0) or (CustomerCounter = 11);
        end;
        exit(FilterToExcludeTopTenCustomers);
    end;
}

