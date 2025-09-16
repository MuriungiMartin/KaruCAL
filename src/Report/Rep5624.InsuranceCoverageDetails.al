#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5624 "Insurance - Coverage Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insurance - Coverage Details.rdlc';
    Caption = 'Insurance - Coverage Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Insurance;Insurance)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code","Date Filter";
            column(ReportForNavId_3288; 3288)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Insurance_TABLECAPTION__________InsuranceFilter;TableCaption + ': ' + InsuranceFilter)
            {
            }
            column(InsuranceFilter;InsuranceFilter)
            {
            }
            column(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
            {
            }
            column(Insurance__No__;"No.")
            {
            }
            column(Insurance_Description;Description)
            {
            }
            column(Insurance___Coverage_DetailsCaption;Insurance___Coverage_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Ins__Coverage_Ledger_Entry__Posting_Date_Caption;Ins__Coverage_Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Ins__Coverage_Ledger_Entry__Document_Type_Caption;"Ins. Coverage Ledger Entry".FieldCaption("Document Type"))
            {
            }
            column(Ins__Coverage_Ledger_Entry__Document_No__Caption;"Ins. Coverage Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Ins__Coverage_Ledger_Entry_DescriptionCaption;"Ins. Coverage Ledger Entry".FieldCaption(Description))
            {
            }
            column(Ins__Coverage_Ledger_Entry_AmountCaption;"Ins. Coverage Ledger Entry".FieldCaption(Amount))
            {
            }
            column(Ins__Coverage_Ledger_Entry__Entry_No__Caption;"Ins. Coverage Ledger Entry".FieldCaption("Entry No."))
            {
            }
            column(Ins__Coverage_Ledger_Entry__User_ID_Caption;"Ins. Coverage Ledger Entry".FieldCaption("User ID"))
            {
            }
            column(Ins__Coverage_Ledger_Entry__Disposed_FA_Caption;"Ins. Coverage Ledger Entry".FieldCaption("Disposed FA"))
            {
            }
            column(Ins__Coverage_Ledger_Entry__FA_No__Caption;"Ins. Coverage Ledger Entry".FieldCaption("FA No."))
            {
            }
            column(Ins__Coverage_Ledger_Entry__FA_Description_Caption;"Ins. Coverage Ledger Entry".FieldCaption("FA Description"))
            {
            }
            dataitem("Ins. Coverage Ledger Entry";"Ins. Coverage Ledger Entry")
            {
                DataItemTableView = sorting("Insurance No.","Disposed FA","Posting Date");
                column(ReportForNavId_8513; 8513)
                {
                }
                column(Ins__Coverage_Ledger_Entry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(Ins__Coverage_Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(Ins__Coverage_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Ins__Coverage_Ledger_Entry_Description;Description)
                {
                }
                column(Ins__Coverage_Ledger_Entry_Amount;Amount)
                {
                }
                column(Ins__Coverage_Ledger_Entry__Entry_No__;"Entry No.")
                {
                }
                column(Ins__Coverage_Ledger_Entry__User_ID_;"User ID")
                {
                }
                column(Ins__Coverage_Ledger_Entry__Disposed_FA_;"Disposed FA")
                {
                }
                column(Ins__Coverage_Ledger_Entry__FA_No__;"FA No.")
                {
                }
                column(Ins__Coverage_Ledger_Entry__FA_Description_;"FA Description")
                {
                }
                column(FORMAT__Disposed_FA__;Format("Disposed FA"))
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Insurance No.",Insurance."No.");
                    SetFilter("Posting Date",Insurance.GetFilter("Date Filter"));
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
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
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'New Page per Insurance No.';
                        ToolTip = 'Specifies if each insurance number information is printed on a new page if you have chosen two or more insurance numbers to be included in the report.';
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
        InsuranceFilter := Insurance.GetFilters;
    end;

    var
        PrintOnlyOnePerPage: Boolean;
        InsuranceFilter: Text;
        Insurance___Coverage_DetailsCaptionLbl: label 'Insurance - Coverage Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Ins__Coverage_Ledger_Entry__Posting_Date_CaptionLbl: label 'Posting Date';
}

