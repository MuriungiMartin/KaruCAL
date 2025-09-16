#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5601 "Fixed Asset - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fixed Asset - List.rdlc';
    Caption = 'Fixed Asset - List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Fixed Asset";"Fixed Asset")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code","Budgeted Asset";
            column(ReportForNavId_3794; 3794)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(DeprBookText;DeprBookText)
            {
            }
            column(FATableCaptionFAFilter;TableCaption + ': ' + FAFilter)
            {
            }
            column(FAFilter;FAFilter)
            {
            }
            column(FANo;"No.")
            {
                IncludeCaption = true;
            }
            column(FADesc;Description)
            {
            }
            column(FAMainAssetComponent;"Main Asset/Component")
            {
            }
            column(BudgetedAssetFieldname;BudgetedAssetFieldname)
            {
            }
            column(FASerialNo;"Serial No.")
            {
            }
            column(FAComponentofMainAsset;"Component of Main Asset")
            {
            }
            column(ComponentFieldname;ComponentFieldname)
            {
            }
            column(FAGlobalDim1Code;"Global Dimension 1 Code")
            {
            }
            column(FAGlobalDim2Code;"Global Dimension 2 Code")
            {
            }
            column(FAClassCode;"FA Class Code")
            {
                IncludeCaption = true;
            }
            column(FASubclassCode;"FA Subclass Code")
            {
                IncludeCaption = true;
            }
            column(FALocationCode;"FA Location Code")
            {
                IncludeCaption = true;
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(FAListCaption;FAListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            dataitem("FA Depreciation Book";"FA Depreciation Book")
            {
                DataItemTableView = sorting("FA No.","Depreciation Book Code");
                column(ReportForNavId_2285; 2285)
                {
                }
                column(FADeprBookDeprMethod;"Depreciation Method")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookDeprStartingDate;Format("Depreciation Starting Date"))
                {
                }
                column(FADeprBookFAPostingGroup;"FA Posting Group")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookStraightLine;"Straight-Line %")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookNoofDeprYrs;"No. of Depreciation Years")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookNoofDeprMonths;"No. of Depreciation Months")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookDeprEndingDate;Format("Depreciation Ending Date"))
                {
                }
                column(FADeprBookFixedDeprAmt;"Fixed Depr. Amount")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookDecliningBalance;"Declining-Balance %")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookDeprTableCode;"Depreciation Table Code")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookUserDefinedDeprDt;Format("First User-Defined Depr. Date"))
                {
                }
                column(FADeprBookFinalRoundingAmt;"Final Rounding Amount")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookEndingBookValue;"Ending Book Value")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookFAExchangeRate;"FA Exchange Rate")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookUseFALedgCheck;"Use FA Ledger Check")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookDeprbelowZero;"Depr. below Zero %")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookFDeprAmtbelowZero;"Fixed Depr. Amount below Zero")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookProjProceedDspsl;"Projected Proceeds on Disposal")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookProjDisposalDate;Format("Projected Disposal Date"))
                {
                }
                column(FADeprBookStartingDateCustom;Format("Depr. Starting Date (Custom 1)"))
                {
                }
                column(FADeprBookAccumDeprCustom;"Accum. Depr. % (Custom 1)")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookThisYrCustom;"Depr. This Year % (Custom 1)")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookEndingDateCustom;Format("Depr. Ending Date (Custom 1)"))
                {
                }
                column(FADeprBookPropertyClassCustom;"Property Class (Custom 1)")
                {
                    IncludeCaption = true;
                }
                column(FADeprBookDeprStartDateCaption;FADeprBookDeprStartDateCaptionLbl)
                {
                }
                column(FADeprBookDeprEndDateCaption;FADeprBookDeprEndDateCaptionLbl)
                {
                }
                column(FADeprBookUsrDfndDeprDtCaption;FADeprBookUsrDfndDeprDtCaptionLbl)
                {
                }
                column(FADeprBookProjDisplDateCaption;FADeprBookProjDisplDateCaptionLbl)
                {
                }
                column(FADeprBookStartDateCustomCaption;FADeprBookStartDateCustomCaptionLbl)
                {
                }
                column(FADeprBookEndDateCustomCptn;FADeprBookEndDateCustomCptnLbl)
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("FA No.","Fixed Asset"."No.");
                    SetRange("Depreciation Book Code",DeprBookCode);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Inactive then
                  CurrReport.Skip;
                if "Main Asset/Component" <> "main asset/component"::" " then
                  ComponentFieldname := FieldCaption("Component of Main Asset")
                else
                  ComponentFieldname := '';
                if "Budgeted Asset" then
                  BudgetedAssetFieldname := FieldCaption("Budgeted Asset")
                else
                  BudgetedAssetFieldname := '';
                if PrintOnlyOnePerPage then
                  PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
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
                    field(DeprBookCode;DeprBookCode)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Depreciation Book';
                        TableRelation = "Depreciation Book";
                        ToolTip = 'Specifies a code for the depreciation book that is included in the report. You can set up an unlimited number of depreciation books to accommodate various depreciation purposes (such as tax and financial statements). For each depreciation book, you must define the terms and conditions, such as integration with general ledger.';
                    }
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'New Page per Asset';
                        ToolTip = 'Specifies if you want to print each asset on a separate page. Each asset will begin at the top of the following page. Otherwise, each asset will follow the previous account on the current page.';
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
        PrintOnlyOnePerPage: Boolean;
        DeprBookCode: Code[10];
        FAFilter: Text;
        ComponentFieldname: Text[100];
        BudgetedAssetFieldname: Text[100];
        DeprBookText: Text[50];
        PageGroupNo: Integer;
        FAListCaptionLbl: label 'Fixed Asset - List';
        CurrReportPageNoCaptionLbl: label 'Page';
        FADeprBookDeprStartDateCaptionLbl: label 'Depreciation Starting Date';
        FADeprBookDeprEndDateCaptionLbl: label 'Depreciation Ending Date';
        FADeprBookUsrDfndDeprDtCaptionLbl: label 'First User-Defined Depr. Date';
        FADeprBookProjDisplDateCaptionLbl: label 'Projected Disposal Date';
        FADeprBookStartDateCustomCaptionLbl: label 'Depr. Starting Date (Custom 1)';
        FADeprBookEndDateCustomCptnLbl: label 'Depr. Ending Date (Custom 1)';
}

