#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51086 "Vendor Ledger Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor Ledger Entries.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
        {
            DataItemTableView = where("Vendor Posting Group"=const('LECTURER'));
            RequestFilterFields = "Vendor No.","Posting Date";
            column(ReportForNavId_4114; 4114)
            {
            }
            column(Vendor_Ledger_Entry__Vendor_No__;"Vendor No.")
            {
            }
            column(VendorName;VendorName)
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Vendor_Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Vendor_Ledger_Entry_Amount;Amount)
            {
            }
            column(Vendor_Ledger_Entry__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_;"Document Type")
            {
            }
            column(Vendor_Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Vendor_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Vendor_Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Business_CodeCaption;Business_CodeCaptionLbl)
            {
            }
            column(VendorCaption;VendorCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(Vendor_Ledger_EntriesCaption;Vendor_Ledger_EntriesCaptionLbl)
            {
            }
            column(Document_TypeCaption;Document_TypeCaptionLbl)
            {
            }
            column(Posting_DateCaption;Posting_DateCaptionLbl)
            {
            }
            column(Document_No_Caption;Document_No_CaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(Business_CodeCaption_Control1102760011;Business_CodeCaption_Control1102760011Lbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption;FieldCaption("Document Type"))
            {
            }
            column(Vendor_Ledger_Entry_Entry_No_;"Entry No.")
            {
            }
            column(ID;"Vendor Ledger Entry"."Applies-to ID")
            {
            }
            column(Descr;"Vendor Ledger Entry".Description)
            {
            }
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
        if VendorRec.Get("Vendor Ledger Entry".GetFilter("Vendor Ledger Entry"."Vendor No.")) then
        VendorName:=VendorRec.Name;
    end;

    var
        VendorRec: Record Vendor;
        VendorName: Text[50];
        Business_CodeCaptionLbl: label 'Business Code';
        VendorCaptionLbl: label 'Vendor';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        Vendor_Ledger_EntriesCaptionLbl: label 'Vendor Ledger Entries';
        Document_TypeCaptionLbl: label 'Document Type';
        Posting_DateCaptionLbl: label 'Posting Date';
        Document_No_CaptionLbl: label 'Document No.';
        AmountCaptionLbl: label 'Amount';
        Business_CodeCaption_Control1102760011Lbl: label 'Business Code';
}

