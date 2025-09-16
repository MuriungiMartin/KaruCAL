#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51663 "Quotation Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Quotation Analysis.rdlc';

    dataset
    {
        dataitem("Purchase Line";"Purchase Line")
        {
            DataItemTableView = sorting("Buy-from Vendor No.");
            RequestFilterFields = "Request for Quote No.";
            column(ReportForNavId_6547; 6547)
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Purchase_Line__Buy_from_Vendor_No__;"Buy-from Vendor No.")
            {
            }
            column(Purchase_Header___Buy_from_Vendor_Name_;"Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(Purchase_Line__Line_Amount_;"Line Amount")
            {
            }
            column(Purchase_Line__Direct_Unit_Cost_;"Direct Unit Cost")
            {
            }
            column(Purchase_Line_Quantity;Quantity)
            {
            }
            column(Purchase_Line__Unit_of_Measure_Code_;"Unit of Measure Code")
            {
            }
            column(Purchase_Line__No__;"No.")
            {
            }
            column(Purchase_Line__Purchase_Line___Request_for_Quote_No__;"Purchase Line"."Request for Quote No.")
            {
            }
            column(Purchase_Line_Description;Description)
            {
            }
            column(Purchase_Line__No___Control1102755003;"No.")
            {
            }
            column(TENDER_SCHEDULECaption;TENDER_SCHEDULECaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(KARATINAUNIVERSITYCaption;KARATINAUNIVERSITYCaptionLbl)
            {
            }
            column(COMMENTCaption;COMMENTCaptionLbl)
            {
            }
            column(TOTAL_COSTCaption;TOTAL_COSTCaptionLbl)
            {
            }
            column(UNIT_COSTCaption;UNIT_COSTCaptionLbl)
            {
            }
            column(QUANTITYCaption;QUANTITYCaptionLbl)
            {
            }
            column(UNIT_OF_MEASURECaption;UNIT_OF_MEASURECaptionLbl)
            {
            }
            column(ITEM_NO_Caption;ITEM_NO_CaptionLbl)
            {
            }
            column(NAMECaption;NAMECaptionLbl)
            {
            }
            column(SUPPLIER_NO_Caption;SUPPLIER_NO_CaptionLbl)
            {
            }
            column(PRF_No_Caption;PRF_No_CaptionLbl)
            {
            }
            column(Purchase_Line_Document_Type;"Document Type")
            {
            }
            column(Purchase_Line_Document_No_;"Document No.")
            {
            }
            column(Purchase_Line_Line_No_;"Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 "Purchase Header".Reset;
                 "Purchase Header".SetRange("Purchase Header"."Document Type","Purchase Header"."document type"::Quote);
                 "Purchase Header".SetRange("Purchase Header"."No.","Purchase Line"."Document No.");
                 "Purchase Header".SetRange("Purchase Header"."Buy-from Vendor No.","Purchase Line"."Buy-from Vendor No.");
                 if "Purchase Header".Find('-') then
;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Buy-from Vendor No.");
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        "Purchase Header": Record "Purchase Header";
        Company: Record "Company Information";
        TENDER_SCHEDULECaptionLbl: label 'TENDER SCHEDULE';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        KARATINAUNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        COMMENTCaptionLbl: label 'COMMENT';
        TOTAL_COSTCaptionLbl: label 'TOTAL COST';
        UNIT_COSTCaptionLbl: label 'UNIT COST';
        QUANTITYCaptionLbl: label 'QUANTITY';
        UNIT_OF_MEASURECaptionLbl: label 'UNIT OF MEASURE';
        ITEM_NO_CaptionLbl: label 'ITEM NO.';
        NAMECaptionLbl: label 'NAME';
        SUPPLIER_NO_CaptionLbl: label 'SUPPLIER NO.';
        PRF_No_CaptionLbl: label 'PRF No.';
}

