#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 119 "Customer - Sales List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Sales List.rdlc';
    Caption = 'Customer - Sales List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer;Customer)
        {
            RequestFilterFields = "No.","Date Filter";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(MinAmtLCY;MinAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(TABLECAPTION__________CustFilter;TableCaption + ': ' + CustFilter)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__VAT_Registration_No__;"VAT Registration No.")
            {
            }
            column(AmtSalesLCY;AmtSalesLCY)
            {
                AutoFormatType = 1;
            }
            column(CustAddr_2_;CustAddr[2])
            {
            }
            column(CustAddr_3_;CustAddr[3])
            {
            }
            column(CustAddr_4_;CustAddr[4])
            {
            }
            column(CustAddr_5_;CustAddr[5])
            {
            }
            column(CustAddr_6_;CustAddr[6])
            {
            }
            column(CustAddr_7_;CustAddr[7])
            {
            }
            column(CustAddr_8_;CustAddr[8])
            {
            }
            column(HideAddress;HideAddress)
            {
            }
            column(Customer___Sales_ListCaption;Customer___Sales_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(MinAmtLCYCaption;MinAmtLCYCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer__VAT_Registration_No__Caption;FieldCaption("VAT Registration No."))
            {
            }
            column(AmtSalesLCYCaption;AmtSalesLCYCaptionLbl)
            {
            }
            column(Total_Reported_Amount_of_Sales__LCY_Caption;Total_Reported_Amount_of_Sales__LCY_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
            begin
                AmtSalesLCY := CalculateAmtOfSaleLCY;
                if AmtSalesLCY < MinAmtLCY then
                  CurrReport.Skip;

                if not HideAddress then
                  FormatAddr.Customer(CustAddr,Customer);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(AmtSalesLCY);
            end;
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
                    field(MinAmtLCY;MinAmtLCY)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatType = 1;
                        Caption = 'Amounts ($) Greater Than';
                        ToolTip = 'Specifies an amount so that the report will only include those customers to which you have sold more than this amount within the specified dates.';
                    }
                    field(HideAddress;HideAddress)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Hide Address Detail';
                        ToolTip = 'Specifies that you do not want the report to show address details for each customer.';
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
    var
        CaptionManagement: Codeunit "Caption Class";
    begin
        CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
    end;

    var
        MinAmtLCY: Decimal;
        HideAddress: Boolean;
        AmtSalesLCY: Decimal;
        CustAddr: array [8] of Text[50];
        CustFilter: Text;
        Customer___Sales_ListCaptionLbl: label 'Customer - Sales List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        MinAmtLCYCaptionLbl: label 'Amounts ($) greater than';
        AmtSalesLCYCaptionLbl: label 'Amount of Sales ($)';
        Total_Reported_Amount_of_Sales__LCY_CaptionLbl: label 'Total Reported Amount of Sales ($)';

    local procedure CalculateAmtOfSaleLCY(): Decimal
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        with CustLedgEntry do begin
          SetCurrentkey("Document Type","Customer No.","Posting Date");
          SetRange("Customer No.",Customer."No.");
          SetFilter("Posting Date",Customer.GetFilter("Date Filter"));
          for i := 1 to 2 do begin
            case i of
              1:
                SetRange("Document Type","document type"::Invoice);
              2:
                SetRange("Document Type","document type"::"Credit Memo");
            end;
            CalcSums("Sales (LCY)");
            Amt := Amt + "Sales (LCY)";
          end;
          exit(Amt);
        end;
    end;


    procedure InitializeRequest(MinimumAmtLCY: Decimal;HideAddressDetails: Boolean)
    begin
        MinAmtLCY := MinimumAmtLCY;
        HideAddress := HideAddressDetails;
    end;
}

