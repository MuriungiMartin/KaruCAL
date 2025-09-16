#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51590 "Transfer Order Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Transfer Order Form.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Transfer Header";"Transfer Header")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(No_TransferHeader;"Transfer Header"."No.")
            {
            }
            column(TransferfromCode_TransferHeader;"Transfer Header"."Transfer-from Code")
            {
            }
            column(TransferfromName_TransferHeader;"Transfer Header"."Transfer-from Name")
            {
            }
            column(TransferfromName2_TransferHeader;"Transfer Header"."Transfer-from Name 2")
            {
            }
            column(TransferfromAddress_TransferHeader;"Transfer Header"."Transfer-from Address")
            {
            }
            column(TransferfromAddress2_TransferHeader;"Transfer Header"."Transfer-from Address 2")
            {
            }
            column(TransferfromPostCode_TransferHeader;"Transfer Header"."Transfer-from Post Code")
            {
            }
            column(TransferfromCity_TransferHeader;"Transfer Header"."Transfer-from City")
            {
            }
            column(TransferfromCounty_TransferHeader;"Transfer Header"."Transfer-from County")
            {
            }
            column(TrsffromCountryRegionCode_TransferHeader;"Transfer Header"."Trsf.-from Country/Region Code")
            {
            }
            column(TransfertoCode_TransferHeader;"Transfer Header"."Transfer-to Code")
            {
            }
            column(TransfertoName_TransferHeader;"Transfer Header"."Transfer-to Name")
            {
            }
            column(TransfertoName2_TransferHeader;"Transfer Header"."Transfer-to Name 2")
            {
            }
            column(TransfertoAddress_TransferHeader;"Transfer Header"."Transfer-to Address")
            {
            }
            column(TransfertoAddress2_TransferHeader;"Transfer Header"."Transfer-to Address 2")
            {
            }
            column(TransfertoPostCode_TransferHeader;"Transfer Header"."Transfer-to Post Code")
            {
            }
            column(TransfertoCity_TransferHeader;"Transfer Header"."Transfer-to City")
            {
            }
            column(TransfertoCounty_TransferHeader;"Transfer Header"."Transfer-to County")
            {
            }
            column(TrsftoCountryRegionCode_TransferHeader;"Transfer Header"."Trsf.-to Country/Region Code")
            {
            }
            column(PostingDate_TransferHeader;"Transfer Header"."Posting Date")
            {
            }
            column(ShipmentDate_TransferHeader;"Transfer Header"."Shipment Date")
            {
            }
            column(ReceiptDate_TransferHeader;"Transfer Header"."Receipt Date")
            {
            }
            column(Status_TransferHeader;"Transfer Header".Status)
            {
            }
            column(Comment_TransferHeader;"Transfer Header".Comment)
            {
            }
            column(ShortcutDimension1Code_TransferHeader;"Transfer Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_TransferHeader;"Transfer Header"."Shortcut Dimension 2 Code")
            {
            }
            column(InTransitCode_TransferHeader;"Transfer Header"."In-Transit Code")
            {
            }
            column(NoSeries_TransferHeader;"Transfer Header"."No. Series")
            {
            }
            column(LastShipmentNo_TransferHeader;"Transfer Header"."Last Shipment No.")
            {
            }
            column(LastReceiptNo_TransferHeader;"Transfer Header"."Last Receipt No.")
            {
            }
            column(TransferfromContact_TransferHeader;"Transfer Header"."Transfer-from Contact")
            {
            }
            column(TransfertoContact_TransferHeader;"Transfer Header"."Transfer-to Contact")
            {
            }
            column(ExternalDocumentNo_TransferHeader;"Transfer Header"."External Document No.")
            {
            }
            column(ShippingAgentCode_TransferHeader;"Transfer Header"."Shipping Agent Code")
            {
            }
            column(ShippingAgentServiceCode_TransferHeader;"Transfer Header"."Shipping Agent Service Code")
            {
            }
            column(ShippingTime_TransferHeader;"Transfer Header"."Shipping Time")
            {
            }
            column(ShipmentMethodCode_TransferHeader;"Transfer Header"."Shipment Method Code")
            {
            }
            column(TransactionType_TransferHeader;"Transfer Header"."Transaction Type")
            {
            }
            column(TransportMethod_TransferHeader;"Transfer Header"."Transport Method")
            {
            }
            column(EntryExitPoint_TransferHeader;"Transfer Header"."Entry/Exit Point")
            {
            }
            column(Area_TransferHeader;"Transfer Header".Area)
            {
            }
            column(TransactionSpecification_TransferHeader;"Transfer Header"."Transaction Specification")
            {
            }
            column(DimensionSetID_TransferHeader;"Transfer Header"."Dimension Set ID")
            {
            }
            column(ShippingAdvice_TransferHeader;"Transfer Header"."Shipping Advice")
            {
            }
            column(PostingfromWhseRef_TransferHeader;"Transfer Header"."Posting from Whse. Ref.")
            {
            }
            column(CompletelyShipped_TransferHeader;"Transfer Header"."Completely Shipped")
            {
            }
            column(CompletelyReceived_TransferHeader;"Transfer Header"."Completely Received")
            {
            }
            column(LocationFilter_TransferHeader;"Transfer Header"."Location Filter")
            {
            }
            column(OutboundWhseHandlingTime_TransferHeader;"Transfer Header"."Outbound Whse. Handling Time")
            {
            }
            column(InboundWhseHandlingTime_TransferHeader;"Transfer Header"."Inbound Whse. Handling Time")
            {
            }
            column(DateFilter_TransferHeader;"Transfer Header"."Date Filter")
            {
            }
            column(AssignedUserID_TransferHeader;"Transfer Header"."Assigned User ID")
            {
            }
            column(CopyText;CopyText)
            {
            }
            column(NumberText;NumberText[1])
            {
            }
            column(LPOText;LPOText)
            {
            }
            column(logo;CompanyInfo.Picture)
            {
            }
            dataitem("Transfer Line";"Transfer Line")
            {
                DataItemLink = "Document No."=field("No.");
                column(ReportForNavId_2; 2)
                {
                }
                column(ItemNo_TransferLine;"Transfer Line"."Item No.")
                {
                }
                column(Description;"Transfer Line".Description)
                {
                }
                column(Quantity_TransferLine;"Transfer Line".Quantity)
                {
                }
                column(UnitofMeasure_TransferLine;"Transfer Line"."Unit of Measure")
                {
                }
                column(QtytoShip_TransferLine;"Transfer Line"."Qty. to Ship")
                {
                }
                column(QtytoReceive_TransferLine;"Transfer Line"."Qty. to Receive")
                {
                }
                column(Amount_TransferLine;"Transfer Line".Amount)
                {
                }
                column(UnitCost_TransferLine;"Transfer Line"."Unit Cost")
                {
                }
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("No.");
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
                /*PurchLines.RESET;
                PurchLines.SETRANGE("Document Type","Document Type");
                PurchLines.SETRANGE("Document No.","No.");
                PurchLines.CALCSUMS("Line Discount Amount");
                CALCFIELDS("Amount Including VAT");
                //Amount into words
                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText,"Amount Including VAT",'');
                {
                IF "No. Printed" = 0 THEN LPOText:= 'Suppliers copy'
                ELSE IF "No. Printed" = 1 THEN LPOText:= 'Accounts copy'
                ELSE IF "No. Printed" = 2 THEN LPOText:= 'Store copy'
                ELSE IF "No. Printed" = 3 THEN LPOText:= 'Files copy';
                  }
                GenLedgerSetup.GET;
                IF "Currency Code"='' THEN "Currency Code":=GenLedgerSetup."LCY Code";
                */

            end;

            trigger OnPostDataItem()
            begin
                /*IF CurrReport.PREVIEW=FALSE THEN
                  BEGIN
                    "No. Printed":="No. Printed" + 1;
                    MODIFY;
                END
                */

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

