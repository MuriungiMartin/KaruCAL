#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10060 "Salesperson Statistics by Inv."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Salesperson Statistics by Inv..rdlc';
    Caption = 'Salesperson Statistics by Inv.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Salesperson/Purchaser";"Salesperson/Purchaser")
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code","Date Filter";
            RequestFilterHeading = 'Salesperson';
            column(ReportForNavId_3065; 3065)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(SubTitle;SubTitle)
            {
            }
            column(PeriodText;PeriodText)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(PrintDetail;PrintDetail)
            {
            }
            column(Salesperson_Purchaser_Code;Code)
            {
            }
            column(Salesperson_Purchaser_Name;Name)
            {
            }
            column(Cust__Ledger_Entry___Sales__LCY__;"Cust. Ledger Entry"."Sales (LCY)")
            {
            }
            column(Cust__Ledger_Entry___Profit__LCY__;"Cust. Ledger Entry"."Profit (LCY)")
            {
            }
            column(Profit__;"Profit%")
            {
                DecimalPlaces = 1:1;
            }
            column(Cust__Ledger_Entry___Inv__Discount__LCY__;"Cust. Ledger Entry"."Inv. Discount (LCY)")
            {
            }
            column(Cust__Ledger_Entry___Pmt__Disc__Given__LCY__;"Cust. Ledger Entry"."Pmt. Disc. Given (LCY)")
            {
            }
            column(Cust__Ledger_Entry___Remaining_Amt___LCY__;"Cust. Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(Salesperson_Purchaser_Date_Filter;"Date Filter")
            {
            }
            column(Salesperson_Statistics_by_InvoiceCaption;Salesperson_Statistics_by_InvoiceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(For_the_periodCaption;For_the_periodCaptionLbl)
            {
            }
            column(Salesperson_Purchaser_CodeCaption;Salesperson_Purchaser_CodeCaptionLbl)
            {
            }
            column(ContributionCaption;ContributionCaptionLbl)
            {
            }
            column(InvoiceCaption;InvoiceCaptionLbl)
            {
            }
            column(CashCaption;CashCaptionLbl)
            {
            }
            column(RemainingCaption;RemainingCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption;Cust__Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Sales__LCY__Caption;Cust__Ledger_Entry__Sales__LCY__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Profit__LCY__Caption;Cust__Ledger_Entry__Profit__LCY__CaptionLbl)
            {
            }
            column(Profit___Control48Caption;Profit___Control48CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Inv__Discount__LCY__Caption;Cust__Ledger_Entry__Inv__Discount__LCY__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Pmt__Disc__Given__LCY__Caption;Cust__Ledger_Entry__Pmt__Disc__Given__LCY__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY__Caption;Cust__Ledger_Entry__Remaining_Amt___LCY__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;Cust__Ledger_Entry__Customer_No__CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;"Cust. Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Sales__LCY___Control62Caption;Cust__Ledger_Entry__Sales__LCY___Control62CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Profit__LCY___Control63Caption;Cust__Ledger_Entry__Profit__LCY___Control63CaptionLbl)
            {
            }
            column(Profit___Control64Caption;Profit___Control64CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Inv__Discount__LCY___Control65Caption;Cust__Ledger_Entry__Inv__Discount__LCY___Control65CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Pmt__Disc__Given__LCY___Control66Caption;Cust__Ledger_Entry__Pmt__Disc__Given__LCY___Control66CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amt___LCY___Control67Caption;Cust__Ledger_Entry__Remaining_Amt___LCY___Control67CaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Salesperson Code"=field(Code),"Posting Date"=field("Date Filter");
                DataItemTableView = sorting("Salesperson Code","Posting Date");
                column(ReportForNavId_8503; 8503)
                {
                }
                column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(Cust__Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
                {
                }
                column(Cust__Ledger_Entry__Sales__LCY__;"Sales (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Profit__LCY__;"Profit (LCY)")
                {
                }
                column(Profit___Control48;"Profit%")
                {
                    DecimalPlaces = 1:1;
                }
                column(Cust__Ledger_Entry__Inv__Discount__LCY__;"Inv. Discount (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Pmt__Disc__Given__LCY__;"Pmt. Disc. Given (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY__;"Remaining Amt. (LCY)")
                {
                }
                column(Salesperson_Purchaser__Code;"Salesperson/Purchaser".Code)
                {
                }
                column(Cust__Ledger_Entry__Sales__LCY___Control53;"Sales (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Profit__LCY___Control54;"Profit (LCY)")
                {
                }
                column(Profit___Control55;"Profit%")
                {
                    DecimalPlaces = 1:1;
                }
                column(Cust__Ledger_Entry__Inv__Discount__LCY___Control56;"Inv. Discount (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Pmt__Disc__Given__LCY___Control57;"Pmt. Disc. Given (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY___Control58;"Remaining Amt. (LCY)")
                {
                }
                column(Salesperson_Purchaser__Code_Control60;"Salesperson/Purchaser".Code)
                {
                }
                column(Salesperson_Purchaser__Name;"Salesperson/Purchaser".Name)
                {
                }
                column(Cust__Ledger_Entry__Sales__LCY___Control62;"Sales (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Profit__LCY___Control63;"Profit (LCY)")
                {
                }
                column(Profit___Control64;"Profit%")
                {
                    DecimalPlaces = 1:1;
                }
                column(Cust__Ledger_Entry__Inv__Discount__LCY___Control65;"Inv. Discount (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Pmt__Disc__Given__LCY___Control66;"Pmt. Disc. Given (LCY)")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amt___LCY___Control67;"Remaining Amt. (LCY)")
                {
                }
                column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Salesperson_Code;"Salesperson Code")
                {
                }
                column(Salesperson_TotalCaption;Salesperson_TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                var
                    CostCalcMgt: Codeunit "Cost Calculation Management";
                begin
                    if "Document Type" in ["document type"::Invoice,"document type"::"Credit Memo"] then
                      "Profit (LCY)" += CostCalcMgt.CalcCustLedgAdjmtCostLCY("Cust. Ledger Entry");
                    if "Sales (LCY)" > 0 then begin
                      "Profit%" := ROUND("Profit (LCY)" / "Sales (LCY)" * 100,0.1);
                    end else
                      "Profit%" := 0;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Sales (LCY)","Profit (LCY)","Inv. Discount (LCY)","Pmt. Disc. Given (LCY)",
                      "Remaining Amt. (LCY)");
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Cust. Ledger Entry"."Sales (LCY)","Cust. Ledger Entry"."Profit (LCY)",
                  "Cust. Ledger Entry"."Inv. Discount (LCY)",
                  "Cust. Ledger Entry"."Pmt. Disc. Given (LCY)","Cust. Ledger Entry"."Remaining Amt. (LCY)");
                if PrintDetail then begin
                  SubTitle := '(Detail)';
                end else
                  SubTitle := '(Summary)';
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
                    field(PrintDetail;PrintDetail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Detail';
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
        CompanyInformation.Get;
        PeriodText := "Salesperson/Purchaser".GetFilter("Date Filter");
        "Salesperson/Purchaser".SetRange("Date Filter");
        FilterString := "Salesperson/Purchaser".GetFilters;
    end;

    var
        FilterString: Text;
        SubTitle: Text[88];
        PeriodText: Text;
        PrintDetail: Boolean;
        "Profit%": Decimal;
        CompanyInformation: Record "Company Information";
        Salesperson_Statistics_by_InvoiceCaptionLbl: label 'Salesperson Statistics by Invoice';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        For_the_periodCaptionLbl: label 'For the period';
        Salesperson_Purchaser_CodeCaptionLbl: label 'Salesperson';
        ContributionCaptionLbl: label 'Contribution';
        InvoiceCaptionLbl: label 'Invoice';
        CashCaptionLbl: label 'Cash';
        RemainingCaptionLbl: label 'Remaining';
        DateCaptionLbl: label 'Date';
        Cust__Ledger_Entry__Document_Type_CaptionLbl: label 'Doc Type';
        Cust__Ledger_Entry__Sales__LCY__CaptionLbl: label 'Sales';
        Cust__Ledger_Entry__Profit__LCY__CaptionLbl: label 'Margin';
        Profit___Control48CaptionLbl: label 'Ratio';
        Cust__Ledger_Entry__Inv__Discount__LCY__CaptionLbl: label 'Discount';
        Cust__Ledger_Entry__Pmt__Disc__Given__LCY__CaptionLbl: label 'Discount';
        Cust__Ledger_Entry__Remaining_Amt___LCY__CaptionLbl: label 'Balance';
        Cust__Ledger_Entry__Customer_No__CaptionLbl: label 'Customer';
        CodeCaptionLbl: label 'Code';
        NameCaptionLbl: label 'Name';
        Cust__Ledger_Entry__Sales__LCY___Control62CaptionLbl: label 'Sales';
        Cust__Ledger_Entry__Profit__LCY___Control63CaptionLbl: label 'Margin';
        Profit___Control64CaptionLbl: label 'Ratio';
        Cust__Ledger_Entry__Inv__Discount__LCY___Control65CaptionLbl: label 'DIscount';
        Cust__Ledger_Entry__Pmt__Disc__Given__LCY___Control66CaptionLbl: label 'Discount';
        Cust__Ledger_Entry__Remaining_Amt___LCY___Control67CaptionLbl: label 'Balance';
        Report_TotalCaptionLbl: label 'Report Total';
        Salesperson_TotalCaptionLbl: label 'Salesperson Total';
}

