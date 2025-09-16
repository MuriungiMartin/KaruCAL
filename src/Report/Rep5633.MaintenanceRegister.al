#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5633 "Maintenance Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Maintenance Register.rdlc';
    Caption = 'Maintenance Register';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("FA Register";"FA Register")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_1711; 1711)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FA_Register__TABLECAPTION__________MaintenanceRegFilter;TableCaption + ': ' + MaintenanceRegFilter)
            {
            }
            column(MaintenanceRegFilter;MaintenanceRegFilter)
            {
            }
            column(FA_Register__No__;"No.")
            {
            }
            column(Maintenance_Ledger_Entry__Amount;"Maintenance Ledger Entry".Amount)
            {
            }
            column(Maintenance_RegisterCaption;Maintenance_RegisterCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Maintenance_Ledger_Entry_DescriptionCaption;"Maintenance Ledger Entry".FieldCaption(Description))
            {
            }
            column(Maintenance_Ledger_Entry__FA_No__Caption;"Maintenance Ledger Entry".FieldCaption("FA No."))
            {
            }
            column(Maintenance_Ledger_Entry__Document_No__Caption;"Maintenance Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Maintenance_Ledger_Entry__Document_Type_Caption;"Maintenance Ledger Entry".FieldCaption("Document Type"))
            {
            }
            column(Maintenance_Ledger_Entry__FA_Posting_Date_Caption;Maintenance_Ledger_Entry__FA_Posting_Date_CaptionLbl)
            {
            }
            column(Maintenance_Ledger_Entry__Depreciation_Book_Code_Caption;"Maintenance Ledger Entry".FieldCaption("Depreciation Book Code"))
            {
            }
            column(Maintenance_Ledger_Entry__Maintenance_Code_Caption;"Maintenance Ledger Entry".FieldCaption("Maintenance Code"))
            {
            }
            column(Maintenance_Ledger_Entry_AmountCaption;"Maintenance Ledger Entry".FieldCaption(Amount))
            {
            }
            column(Maintenance_Ledger_Entry__Entry_No__Caption;"Maintenance Ledger Entry".FieldCaption("Entry No."))
            {
            }
            column(FA_DescriptionCaption;FA_DescriptionCaptionLbl)
            {
            }
            column(Maintenance_Ledger_Entry__Posting_Date_Caption;Maintenance_Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Maintenance_Ledger_Entry__G_L_Entry_No__Caption;"Maintenance Ledger Entry".FieldCaption("G/L Entry No."))
            {
            }
            column(FA_Register__No__Caption;FA_Register__No__CaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Maintenance Ledger Entry";"Maintenance Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                column(ReportForNavId_9437; 9437)
                {
                }
                column(Maintenance_Ledger_Entry__FA_Posting_Date_;Format("FA Posting Date"))
                {
                }
                column(Maintenance_Ledger_Entry__Posting_Date_;Format("Posting Date"))
                {
                }
                column(Maintenance_Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(Maintenance_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Maintenance_Ledger_Entry__FA_No__;"FA No.")
                {
                }
                column(FA_Description;FA.Description)
                {
                }
                column(Maintenance_Ledger_Entry_Description;Description)
                {
                }
                column(Maintenance_Ledger_Entry__Depreciation_Book_Code_;"Depreciation Book Code")
                {
                }
                column(Maintenance_Ledger_Entry__Maintenance_Code_;"Maintenance Code")
                {
                }
                column(Maintenance_Ledger_Entry_Amount;Amount)
                {
                }
                column(Maintenance_Ledger_Entry__Entry_No__;"Entry No.")
                {
                }
                column(Maintenance_Ledger_Entry__G_L_Entry_No__;"G/L Entry No.")
                {
                }
                column(MaintenanceAmountTotal;MaintenanceAmountTotal)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not FA.Get("FA No.") then
                      FA.Init;
                    MaintenanceAmountTotal += Amount;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(
                      "Entry No.","FA Register"."From Maintenance Entry No.",
                      "FA Register"."To Maintenance Entry No.");
                    CurrReport.CreateTotals(Amount);
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Maintenance Ledger Entry".Amount);
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        MaintenanceRegFilter := "FA Register".GetFilters;
    end;

    var
        FA: Record "Fixed Asset";
        MaintenanceRegFilter: Text;
        MaintenanceAmountTotal: Decimal;
        Maintenance_RegisterCaptionLbl: label 'Maintenance Register';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Maintenance_Ledger_Entry__FA_Posting_Date_CaptionLbl: label 'FA Posting Date';
        FA_DescriptionCaptionLbl: label 'FA Description';
        Maintenance_Ledger_Entry__Posting_Date_CaptionLbl: label 'Posting Date';
        FA_Register__No__CaptionLbl: label 'Register No.';
        TotalCaptionLbl: label 'Total';
}

