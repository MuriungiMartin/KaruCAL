#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 319 "Payments on Hold"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payments on Hold.rdlc';
    Caption = 'Payments on Hold';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.",Open,Positive,"Due Date") where(Open=const(true),"On Hold"=filter(<>''));
            RequestFilterFields = "Due Date";
            column(ReportForNavId_4114; 4114)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Vendor_Ledger_Entry__TABLECAPTION__________VendLedgEntryFilter;TableCaption + ': ' + VendLedgEntryFilter)
            {
            }
            column(VendLedgEntryFilter;VendLedgEntryFilter)
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_;Format("Due Date"))
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_;Format("Posting Date"))
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_;"Document Type")
            {
            }
            column(Vendor_Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Vendor_Ledger_Entry_Description;Description)
            {
            }
            column(Vendor_Ledger_Entry__Vendor_No__;"Vendor No.")
            {
            }
            column(Vend_Name;Vend.Name)
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amount_;"Remaining Amount")
            {
            }
            column(Vendor_Ledger_Entry__Currency_Code_;"Currency Code")
            {
            }
            column(Vendor_Ledger_Entry__On_Hold_;"On Hold")
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amt___LCY__;"Remaining Amt. (LCY)")
            {
            }
            column(Payments_on_HoldCaption;Payments_on_HoldCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption;Vendor_Ledger_Entry__Due_Date_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_Caption;Vendor_Ledger_Entry__Posting_Date_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption;Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Vendor_Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Vendor_Ledger_Entry__Vendor_No__Caption;FieldCaption("Vendor No."))
            {
            }
            column(Vend_NameCaption;Vend_NameCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amount_Caption;FieldCaption("Remaining Amount"))
            {
            }
            column(Vendor_Ledger_Entry__On_Hold_Caption;FieldCaption("On Hold"))
            {
            }
            column(Vendor_Ledger_Entry__Remaining_Amt___LCY__Caption;Vendor_Ledger_Entry__Remaining_Amt___LCY__CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Remaining Amt. (LCY)");
                Vend.Get("Vendor No.");
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Remaining Amt. (LCY)");
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
        VendLedgEntryFilter := "Vendor Ledger Entry".GetFilters;
    end;

    var
        Vend: Record Vendor;
        VendLedgEntryFilter: Text;
        Payments_on_HoldCaptionLbl: label 'Payments on Hold';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Vendor_Ledger_Entry__Due_Date_CaptionLbl: label 'Due Date';
        Vendor_Ledger_Entry__Posting_Date_CaptionLbl: label 'Posting Date';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: label 'Document Type';
        Vend_NameCaptionLbl: label 'Name';
        Vendor_Ledger_Entry__Remaining_Amt___LCY__CaptionLbl: label 'Total ($)';
}

