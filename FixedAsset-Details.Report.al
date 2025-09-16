#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5604 "Fixed Asset - Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fixed Asset - Details.rdlc';
    Caption = 'Fixed Asset - Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Fixed Asset";"Fixed Asset")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code","Budgeted Asset","FA Posting Date Filter";
            column(ReportForNavId_3794; 3794)
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
            column(DeprBookText;DeprBookText)
            {
            }
            column(Fixed_Asset__TABLECAPTION__________FAFilter;TableCaption + ': ' + FAFilter)
            {
            }
            column(FAFilter;FAFilter)
            {
            }
            column(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
            {
            }
            column(Fixed_Asset__No__;"No.")
            {
            }
            column(Fixed_Asset_Description;Description)
            {
            }
            column(Fixed_Asset___DetailsCaption;Fixed_Asset___DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(FA_Ledger_Entry__FA_Posting_Date_Caption;FA_Ledger_Entry__FA_Posting_Date_CaptionLbl)
            {
            }
            column(FA_Ledger_Entry__Document_Type_Caption;"FA Ledger Entry".FieldCaption("Document Type"))
            {
            }
            column(FA_Ledger_Entry__Document_No__Caption;"FA Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(FA_Ledger_Entry_DescriptionCaption;"FA Ledger Entry".FieldCaption(Description))
            {
            }
            column(FA_Ledger_Entry_AmountCaption;"FA Ledger Entry".FieldCaption(Amount))
            {
            }
            column(FA_Ledger_Entry__Entry_No__Caption;"FA Ledger Entry".FieldCaption("Entry No."))
            {
            }
            column(FA_Ledger_Entry__FA_Posting_Type_Caption;"FA Ledger Entry".FieldCaption("FA Posting Type"))
            {
            }
            column(FA_Ledger_Entry__No__of_Depreciation_Days_Caption;"FA Ledger Entry".FieldCaption("No. of Depreciation Days"))
            {
            }
            column(FA_Ledger_Entry__User_ID_Caption;"FA Ledger Entry".FieldCaption("User ID"))
            {
            }
            column(FA_Ledger_Entry__Posting_Date_Caption;FA_Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(FA_Ledger_Entry__G_L_Entry_No__Caption;"FA Ledger Entry".FieldCaption("G/L Entry No."))
            {
            }
            column(FA_Ledger_Entry__FA_Posting_Category_Caption;"FA Ledger Entry".FieldCaption("FA Posting Category"))
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone;CompanyInformation."Phone No.")
            {
            }
            column(logo;CompanyInformation.Picture)
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompUrl;CompanyInformation."Home Page")
            {
            }
            dataitem("FA Ledger Entry";"FA Ledger Entry")
            {
                DataItemTableView = sorting("FA No.","Depreciation Book Code","FA Posting Date");
                column(ReportForNavId_9888; 9888)
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Date_;Format("FA Posting Date"))
                {
                }
                column(FA_Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(FA_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(FA_Ledger_Entry_Description;Description)
                {
                }
                column(FA_Ledger_Entry_Amount;Amount)
                {
                }
                column(FA_Ledger_Entry__Entry_No__;"Entry No.")
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Type_;"FA Posting Type")
                {
                }
                column(FA_Ledger_Entry__No__of_Depreciation_Days_;"No. of Depreciation Days")
                {
                }
                column(FA_Ledger_Entry__User_ID_;"User ID")
                {
                }
                column(FA_Ledger_Entry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(FA_Ledger_Entry__G_L_Entry_No__;"G/L Entry No.")
                {
                }
                column(FA_Ledger_Entry__FA_Posting_Category_;"FA Posting Category")
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("FA No.","Fixed Asset"."No.");
                    SetRange("Depreciation Book Code",DeprBookCode);
                    SetFilter("FA Posting Date","Fixed Asset".GetFilter("FA Posting Date Filter"));
                    if not PrintReversedEntries then
                      SetRange(Reversed,false);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Inactive then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);
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
                    field(DepreciationBook;DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies a code for the depreciation book that is included in the report. You can set up an unlimited number of depreciation books to accommodate various depreciation purposes (such as tax and financial statements). For each depreciation book, you must define the terms and conditions, such as integration with general ledger.';
                    }
                    field(NewPagePerAsset;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'New Page per Asset';
                        ToolTip = 'Specifies if you want to print each asset on a separate page. Each asset will begin at the top of the following page. Otherwise, each asset will follow the previous account on the current page.';
                    }
                    field(IncludeReversedEntries;PrintReversedEntries)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Include Reversed Entries';
                        ToolTip = 'Specifies if you want to include reversed fixed asset entries in the report.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if DeprBookCode = '' then begin
              FASetup.Get;
              DeprBookCode := FASetup."Default Depr. Book";
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DeprBook.Get(DeprBookCode);
        FAFilter := "Fixed Asset".GetFilters;
        DeprBookText := StrSubstNo('%1%2 %3',DeprBook.TableCaption,':',DeprBookCode);
    end;

    var
        FASetup: Record "FA Setup";
        DeprBook: Record "Depreciation Book";
        DeprBookCode: Code[10];
        DeprBookText: Text[50];
        PrintOnlyOnePerPage: Boolean;
        FAFilter: Text;
        PrintReversedEntries: Boolean;
        Fixed_Asset___DetailsCaptionLbl: label 'Fixed Asset - Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        FA_Ledger_Entry__FA_Posting_Date_CaptionLbl: label 'FA Posting Date';
        FA_Ledger_Entry__Posting_Date_CaptionLbl: label 'Posting Date';
        CompanyInformation: Record "Company Information";


    procedure InitializeRequest(NewDeprBookCode: Code[10];NewPrintOnlyOnePerPage: Boolean;NewPrintReversedEntries: Boolean)
    begin
        DeprBookCode := NewDeprBookCode;
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        PrintReversedEntries := NewPrintReversedEntries;
    end;
}

