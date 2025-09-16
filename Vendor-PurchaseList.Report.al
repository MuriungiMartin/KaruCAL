#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 309 "Vendor - Purchase List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Purchase List.rdlc';
    Caption = 'Vendor - Purchase List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = "No.","Date Filter";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(MinAmtLCY;MinAmtLCY)
            {
                AutoFormatType = 1;
            }
            column(HideAddr;HideAddr)
            {
            }
            column(TableCaptVendFilter;TableCaption + ': ' + VendFilter)
            {
            }
            column(VendFilter;VendFilter)
            {
            }
            column(VendNo;"No.")
            {
                IncludeCaption = true;
            }
            column(VendName;Name)
            {
                IncludeCaption = true;
            }
            column(VendVATRegNo;"VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(AmtPurchLCY;AmtPurchLCY)
            {
                AutoFormatType = 1;
            }
            column(VendAddr2;VendorAddr[2])
            {
            }
            column(VendAddr3;VendorAddr[3])
            {
            }
            column(VendAddr4;VendorAddr[4])
            {
            }
            column(VendAddr5;VendorAddr[5])
            {
            }
            column(VendAddr6;VendorAddr[6])
            {
            }
            column(VendAddr7;VendorAddr[7])
            {
            }
            column(VendAddr8;VendorAddr[8])
            {
            }
            column(VendPurchListCapt;VendPurchListCaptLbl)
            {
            }
            column(CurrRptPageNoCapt;CurrRptPageNoCaptLbl)
            {
            }
            column(MinAmtLCYCapt;MinAmtLCYCaptLbl)
            {
            }
            column(AmtPurchLCYCapt;AmtPurchLCYCaptLbl)
            {
            }
            column(TotRptedAmtofPurchLCYCapt;TotRptedAmtofPurchLCYCaptLbl)
            {
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
            begin
                AmtPurchLCY := CalculateAmtOfPurchaseLCY;
                if AmtPurchLCY < MinAmtLCY then
                  CurrReport.Skip;

                if not HideAddr then
                  FormatAddr.Vendor(VendorAddr,Vendor);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(AmtPurchLCY);
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
                    field(HideAddr;HideAddr)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Hide Address Detail';
                        ToolTip = 'Specifies that you do not want the report to show address details for each vendor.';
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
        VendFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);
    end;

    var
        MinAmtLCY: Decimal;
        HideAddr: Boolean;
        AmtPurchLCY: Decimal;
        VendorAddr: array [8] of Text[50];
        VendFilter: Text;
        VendPurchListCaptLbl: label 'Vendor - Purchase List';
        CurrRptPageNoCaptLbl: label 'Page';
        MinAmtLCYCaptLbl: label 'Amounts ($) greater than';
        AmtPurchLCYCaptLbl: label 'Amount of Purchase ($)';
        TotRptedAmtofPurchLCYCaptLbl: label 'Total Reported Amount of Purchase ($)';

    local procedure CalculateAmtOfPurchaseLCY(): Decimal
    var
        VendorLedgEntry: Record "Vendor Ledger Entry";
        Amt: Decimal;
        i: Integer;
    begin
        with VendorLedgEntry do begin
          SetCurrentkey("Document Type","Vendor No.","Posting Date");
          SetRange("Vendor No.",Vendor."No.");
          SetFilter("Posting Date",Vendor.GetFilter("Date Filter"));
          for i := 1 to 3 do begin
            case i of
              1:
                SetRange("Document Type","document type"::Invoice);
              2:
                SetRange("Document Type","document type"::"Credit Memo");
              3:
                SetRange("Document Type","document type"::Refund);
            end;
            CalcSums("Purchase (LCY)");
            Amt := Amt + "Purchase (LCY)";
          end;
          exit(-Amt);
        end;
    end;


    procedure InitializeRequest(NewMinAmtLCY: Decimal;NewHideAddress: Boolean)
    begin
        MinAmtLCY := NewMinAmtLCY;
        HideAddr := NewHideAddress;
    end;
}

