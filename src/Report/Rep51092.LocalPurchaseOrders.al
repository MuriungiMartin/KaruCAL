#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51092 "Local Purchase Orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Local Purchase Orders.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = where("Document Type"=const(Order),"Buy-from Vendor No."=filter(<>''));
            RequestFilterFields = Status,"Document Date",Field39005543;
            column(ReportForNavId_4458; 4458)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Purchase_Header__No__;"No.")
            {
            }
            column(Purchase_Header__Pay_to_Vendor_No__;"Pay-to Vendor No.")
            {
            }
            column(Purchase_Header__Pay_to_Name_;"Pay-to Name")
            {
            }
            column(Purchase_Header_Status;Status)
            {
            }
            column(Purchase_Header__Document_Date_;"Document Date")
            {
            }
            column(Purchase_Header__Order_Amount_;Amount)
            {
            }
            column(PurchLine_Quantity;PurchLine.Quantity)
            {
            }
            column(PurchLine__Quantity_Received_;'cccccccccccc')
            {
            }
            column(PurchLine__Outstanding_Quantity_;PurchLine."Outstanding Quantity")
            {
            }
            column(Purchase_Header__Order_Amount__Control1102755024;Amount)
            {
            }
            column(Purchase_HeaderCaption;Purchase_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Purchase_Header__No__Caption;FieldCaption("No."))
            {
            }
            column(Vendor_No_Caption;Vendor_No_CaptionLbl)
            {
            }
            column(Purchase_Header__Pay_to_Name_Caption;FieldCaption("Pay-to Name"))
            {
            }
            column(Purchase_Header_StatusCaption;FieldCaption(Status))
            {
            }
            column(Purchase_Header__Document_Date_Caption;FieldCaption("Document Date"))
            {
            }
            column(Purchase_Header__Order_Amount_Caption;FieldCaption(Amount))
            {
            }
            column(Quantity_OrderedCaption;Quantity_OrderedCaptionLbl)
            {
            }
            column(Quanity_ReceivedCaption;Quanity_ReceivedCaptionLbl)
            {
            }
            column(Quantity_RemainingCaption;Quantity_RemainingCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Purchase_Header_Document_Type;"Document Type")
            {
            }

            trigger OnAfterGetRecord()
            begin
                PurchLine.Reset;
                PurchLine.SetRange(PurchLine."Document Type","Purchase Header"."Document Type");
                PurchLine.SetRange(PurchLine."Document No.","Purchase Header"."No.");
                if PurchLine.Find('-') then
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
        PurchLine: Record "Purchase Line";
        Purchase_HeaderCaptionLbl: label 'Purchase Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Vendor_No_CaptionLbl: label 'Vendor No.';
        Quantity_OrderedCaptionLbl: label 'Quantity Ordered';
        Quanity_ReceivedCaptionLbl: label 'Quanity Received';
        Quantity_RemainingCaptionLbl: label 'Quantity Remaining';
        TotalCaptionLbl: label 'Total';
}

