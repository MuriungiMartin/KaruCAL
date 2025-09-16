#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51574 "Purchase Order1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Order1.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(PaytoVendorNo_PurchaseHeader;"Purchase Header"."Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchaseHeader;"Purchase Header"."Pay-to Name")
            {
            }
            column(PaytoName2_PurchaseHeader;"Purchase Header"."Pay-to Name 2")
            {
            }
            column(PaytoAddress_PurchaseHeader;"Purchase Header"."Pay-to Address")
            {
            }
            column(PaytoAddress2_PurchaseHeader;"Purchase Header"."Pay-to Address 2")
            {
            }
            column(PaytoCity_PurchaseHeader;"Purchase Header"."Pay-to City")
            {
            }
            column(ShiptoCode_PurchaseHeader;"Purchase Header"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchaseHeader;"Purchase Header"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchaseHeader;"Purchase Header"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchaseHeader;"Purchase Header"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeader;"Purchase Header"."Ship-to Address 2")
            {
            }
            column(CompanyInfo_Name;CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address;CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2;CompanyInfo."Address 2")
            {
            }
            column(CompanyInfo_City;CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone;CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfo_Fax;CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(ExpectedReceiptDate_PurchaseHeader;"Purchase Header"."Expected Receipt Date")
            {
            }
            column(PostingDate_PurchaseHeader;"Purchase Header"."Posting Date")
            {
            }
            column(No_PurchaseHeader;"Purchase Header"."No.")
            {
            }
            column(LpoDuedate;"Purchase Header"."Due Date")
            {
            }
            column(CopyText;CopyText)
            {
            }
            column(PaymentTermsCode_PurchaseHeader;"Purchase Header"."Payment Terms Code")
            {
            }
            column(CurrencyCode_PurchaseHeader;"Purchase Header"."Currency Code")
            {
            }
            column(Amount_PurchaseHeader;"Purchase Header".Amount)
            {
            }
            column(AmountIncludingVAT_PurchaseHeader;"Purchase Header"."Amount Including VAT")
            {
            }
            column(TotalDiscountAmount;PurchLines."Line Discount Amount")
            {
            }
            column(NumberText;NumberText[1])
            {
            }
            column(NoPrinted;"Purchase Header"."No. Printed")
            {
            }
            column(LPOText;LPOText)
            {
            }
            column(Department;"Purchase Header"."Shortcut Dimension 2 Code")
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                column(ReportForNavId_2; 2)
                {
                }
                column(LineNo_PurchaseLine;"Purchase Line"."Line No.")
                {
                }
                column(LineAmount_PurchaseLine;"Purchase Line"."Line Amount")
                {
                }
                column(DirectUnitCost_PurchaseLine;"Purchase Line"."Direct Unit Cost")
                {
                }
                column(Quantity_PurchaseLine;"Purchase Line".Quantity)
                {
                }
                column(No_PurchaseLine;"Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine;"Purchase Line".Description)
                {
                }
                column(UnitofMeasure_PurchaseLine;"Purchase Line"."Unit of Measure")
                {
                }
                column(LineDiscount_PurchaseLine;"Purchase Line"."Line Discount %")
                {
                }
                column(LineDiscountAmount_PurchaseLine;"Purchase Line"."Line Discount Amount")
                {
                }
                column(Unit_of_Measure_code;"Purchase Line"."Unit of Measure Code")
                {
                }
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("No."),"Document Type"=field("Document Type");
                DataItemTableView = where(Status=const(Approved));
                column(ReportForNavId_35; 35)
                {
                }
                column(SequenceNo_ApprovalEntry;"Approval Entry"."Sequence No.")
                {
                }
                column(ApproverID_ApprovalEntry;"Approval Entry"."Approver ID")
                {
                }
                column(LastDateTimeModified_ApprovalEntry;"Approval Entry"."Last Date-Time Modified")
                {
                }
                column(SenderID_ApprovalEntry;"Approval Entry"."Sender ID")
                {
                }
                column(DateTimeSentforApproval_ApprovalEntry;"Approval Entry"."Date-Time Sent for Approval")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                PurchLines.Reset;
                PurchLines.SetRange("Document Type","Document Type");
                PurchLines.SetRange("Document No.","No.");
                PurchLines.CalcSums("Line Discount Amount");
                CalcFields("Amount Including VAT");
                //Amount into words
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText,"Amount Including VAT",'');
                /*
                IF "No. Printed" = 0 THEN LPOText:= 'Suppliers copy'
                ELSE IF "No. Printed" = 1 THEN LPOText:= 'Accounts copy'
                ELSE IF "No. Printed" = 2 THEN LPOText:= 'Store copy'
                ELSE IF "No. Printed" = 3 THEN LPOText:= 'Files copy';
                  */
                GenLedgerSetup.Get;
                if "Currency Code"='' then "Currency Code":=GenLedgerSetup."LCY Code";

            end;

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview=false then
                  begin
                    "No. Printed":="No. Printed" + 1;
                    Modify;
                end
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
        PurchaseOrderCaption = 'Purchase Order';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture)
    end;

    var
        CompanyInfo: Record "Company Information";
        CopyText: Text;
        PurchLines: Record "Purchase Line";
        NumberText: array [2] of Text[120];
        CheckReport: Report Check;
        LPOText: Text;
        GenLedgerSetup: Record "General Ledger Setup";
}

