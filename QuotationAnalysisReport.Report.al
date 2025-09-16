#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51470 "Quotation Analysis Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Quotation Analysis Report.rdlc';

    dataset
    {
        dataitem("Purchase Line";"Purchase Line")
        {
            DataItemTableView = where("Document Type"=filter(Quote));
            RequestFilterFields = "Request for Quote No.";
            column(ReportForNavId_6547; 6547)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(Purchase_Line__No__;"No.")
            {
            }
            column(Purchase_Header___Buy_from_Vendor_No__;"Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(Purchase_Header___Buy_from_Vendor_Name_;"Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(Purchase_Line_Quantity;Quantity)
            {
            }
            column(Purchase_Line__Direct_Unit_Cost_;"Direct Unit Cost")
            {
            }
            column(Purchase_Line__Line_Amount_;"Line Amount")
            {
            }
            column(Purchase_Line__Unit_of_Measure_Code_;"Unit of Measure Code")
            {
            }
            column(Purchase_Line__Purchase_Line___Request_for_Quote_No__;"Purchase Line"."Request for Quote No.")
            {
            }
            column(KARATINAUNIVERSITYCaption;KARATINAUNIVERSITYCaptionLbl)
            {
            }
            column(TENDER_SCHEDULECaption;TENDER_SCHEDULECaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
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
            column(COMMENTCaption;COMMENTCaptionLbl)
            {
            }
            column(MEMBERS_PRESENTCaption;MEMBERS_PRESENTCaptionLbl)
            {
            }
            column(SIGNATURE_DATECaption;SIGNATURE_DATECaptionLbl)
            {
            }
            column(V1_________________________________________________________________________________Caption;V1_________________________________________________________________________________CaptionLbl)
            {
            }
            column(V2_________________________________________________________________________________Caption;V2_________________________________________________________________________________CaptionLbl)
            {
            }
            column(V3_________________________________________________________________________________Caption;V3_________________________________________________________________________________CaptionLbl)
            {
            }
            column(V4_________________________________________________________________________________Caption;V4_________________________________________________________________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1000000048;EmptyStringCaption_Control1000000048Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000049;EmptyStringCaption_Control1000000049Lbl)
            {
            }
            column(EmptyStringCaption_Control1000000050;EmptyStringCaption_Control1000000050Lbl)
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
        KARATINAUNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        TENDER_SCHEDULECaptionLbl: label 'TENDER SCHEDULE';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TOTAL_COSTCaptionLbl: label 'TOTAL COST';
        UNIT_COSTCaptionLbl: label 'UNIT COST';
        QUANTITYCaptionLbl: label 'QUANTITY';
        UNIT_OF_MEASURECaptionLbl: label 'UNIT OF MEASURE';
        ITEM_NO_CaptionLbl: label 'ITEM NO.';
        NAMECaptionLbl: label 'NAME';
        SUPPLIER_NO_CaptionLbl: label 'SUPPLIER NO.';
        PRF_No_CaptionLbl: label 'PRF No.';
        COMMENTCaptionLbl: label 'COMMENT';
        MEMBERS_PRESENTCaptionLbl: label 'MEMBERS PRESENT';
        SIGNATURE_DATECaptionLbl: label 'SIGNATURE/DATE';
        V1_________________________________________________________________________________CaptionLbl: label '1. ...............................................................................';
        V2_________________________________________________________________________________CaptionLbl: label '2. ...............................................................................';
        V3_________________________________________________________________________________CaptionLbl: label '3. ...............................................................................';
        V4_________________________________________________________________________________CaptionLbl: label '4. ...............................................................................';
        EmptyStringCaptionLbl: label '...............................................................................';
        EmptyStringCaption_Control1000000048Lbl: label '...............................................................................';
        EmptyStringCaption_Control1000000049Lbl: label '...............................................................................';
        EmptyStringCaption_Control1000000050Lbl: label ' ...............................................................................';
}

