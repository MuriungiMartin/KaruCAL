#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1702 "Deferral Summary - Purchasing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Deferral Summary - Purchasing.rdlc';
    Caption = 'Purchasing Deferral Summary';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Posted Deferral Header";"Posted Deferral Header")
        {
            DataItemTableView = sorting("Deferral Doc. Type",CustVendorNo,"Posting Date","Gen. Jnl. Document No.","Account No.","Document Type","Document No.","Line No.") order(ascending) where("Deferral Doc. Type"=const(Purchase),CustVendorNo=filter(<>''));
            RequestFilterFields = CustVendorNo,"Document No.";
            column(ReportForNavId_17; 17)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(GLAccTableCaption;TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter;GLFilter)
            {
            }
            column(EmptyString;'')
            {
            }
            column(VendorFilter;VendorFilter)
            {
            }
            column(VendNo;CustVendorNo)
            {
            }
            column(No_GLAcc;"Account No.")
            {
            }
            column(Document_No;"Document No.")
            {
            }
            column(Document_Type;"Document Type")
            {
            }
            column(DocumentTypeString;DocumentTypeString)
            {
            }
            column(Line_No;"Line No.")
            {
            }
            column(DeferralSummaryPurchCaption;DeferralSummaryPurchCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(PeriodCaption;PeriodCaptionLbl)
            {
            }
            column(GLBalCaption;GLBalCaptionLbl)
            {
            }
            column(RemAmtDefCaption;RemAmtDefCaptionLbl)
            {
            }
            column(TotAmtDefCaption;TotAmtDefCaptionLbl)
            {
            }
            column(BalanceAsOfDateCaption;BalanceAsOfDateCaptionLbl + Format(BalanceAsOfDateFilter))
            {
            }
            column(BalanceAsOfDateFilter;BalanceAsOfDateFilter)
            {
            }
            column(DocumentCaption;DocumentCaptionLbl + Format(DocumentFilter))
            {
            }
            column(DocumentFilter;DocumentFilter)
            {
            }
            column(VendorCaption;VendorCaptionLbl + Format(VendorFilter))
            {
            }
            column(AccountNoCaption;AccountNoLbl)
            {
            }
            column(AmtRecognizedCaption;AmtRecognizedLbl)
            {
            }
            column(AccountName;AccountName)
            {
            }
            column(VendorName;VendorName)
            {
            }
            column(TotalAmtDeferred;"Amount to Defer (LCY)")
            {
            }
            column(NumOfPeriods;"No. of Periods")
            {
            }
            column(DocumentType;"Document Type")
            {
            }
            column(DeferralStartDate;Format("Start Date"))
            {
            }
            column(AmtRecognized;AmtRecognized)
            {
            }
            column(RemainingAmtDeferred;RemainingAmtDeferred)
            {
            }
            column(PostingDate;Format(PostingDate))
            {
            }
            column(DeferralAccount;DeferralAccount)
            {
            }
            column(Amount;"Amount to Defer (LCY)")
            {
            }
            column(LineDescription;LineDescription)
            {
            }
            column(LineType;LineType)
            {
            }

            trigger OnAfterGetRecord()
            var
                PostedDeferralLine: Record "Posted Deferral Line";
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                PurchInvHeader: Record "Purch. Inv. Header";
                PurchInvLine: Record "Purch. Inv. Line";
                PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                PurchCrMemoLine: Record "Purch. Cr. Memo Line";
                ReverseAmounts: Boolean;
            begin
                PreviousVendor := WorkingVendor;
                ReverseAmounts := false;

                if Vendor.Get(CustVendorNo) then begin
                  VendorName := Vendor.Name;
                  WorkingVendor := CustVendorNo;
                end;

                if PrintOnlyOnePerPage and (PreviousVendor <> WorkingVendor) then begin
                  PostedDeferralHeaderPage.Reset;
                  PostedDeferralHeaderPage.SetRange(CustVendorNo,CustVendorNo);
                  if PostedDeferralHeaderPage.FindFirst then
                    PageGroupNo := PageGroupNo + 1;
                end;

                LineDescription := '';
                case "Document Type" of
                  7: // Posted Invoice
                    if PurchInvLine.Get("Document No.","Line No.") then begin
                      LineDescription := PurchInvLine.Description;
                      LineType := PurchInvLine.Type;
                      if PurchInvHeader.Get("Document No.") then
                        PostingDate := PurchInvHeader."Posting Date";
                    end;
                  8: // Posted Credit Memo
                    if PurchCrMemoLine.Get("Document No.","Line No.") then begin
                      LineDescription := PurchCrMemoLine.Description;
                      LineType := PurchCrMemoLine.Type;
                      if PurchCrMemoHdr.Get("Document No.") then
                        PostingDate := PurchCrMemoHdr."Posting Date";
                      ReverseAmounts := true;
                    end;
                  9: // Posted Return Receipt
                    if PurchaseLine.Get("Document Type","Document No.","Line No.") then begin
                      LineDescription := PurchaseLine.Description;
                      LineType := PurchaseLine.Type;
                      if PurchaseHeader.Get("Document Type","Document No.") then
                        PostingDate := PurchaseHeader."Posting Date";
                      ReverseAmounts := true;
                    end;
                end;

                AmtRecognized := 0;
                RemainingAmtDeferred := 0;

                PostedDeferralLine.SetRange("Deferral Doc. Type","Deferral Doc. Type");
                PostedDeferralLine.SetRange("Gen. Jnl. Document No.","Gen. Jnl. Document No.");
                PostedDeferralLine.SetRange("Account No.","Account No.");
                PostedDeferralLine.SetRange("Document Type","Document Type");
                PostedDeferralLine.SetRange("Document No.","Document No.");
                PostedDeferralLine.SetRange("Line No.","Line No.");
                if PostedDeferralLine.Find('-') then
                  repeat
                    DeferralAccount := PostedDeferralLine."Deferral Account";
                    if PostedDeferralLine."Posting Date" <= BalanceAsOfDateFilter then
                      AmtRecognized := AmtRecognized + PostedDeferralLine."Amount (LCY)"
                    else
                      RemainingAmtDeferred := RemainingAmtDeferred + PostedDeferralLine."Amount (LCY)";
                  until (PostedDeferralLine.Next = 0);

                DocumentTypeString := ReturnPurchDocTypeString("Document Type");
                if ReverseAmounts then begin
                  AmtRecognized := -AmtRecognized;
                  RemainingAmtDeferred := -RemainingAmtDeferred;
                  "Amount to Defer (LCY)" := -"Amount to Defer (LCY)";
                end;
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
                    field(NewPageperVendor;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Suite;
                        Caption = 'New Page per Vendor';
                        ToolTip = 'Specifies if each vendor''s information is printed on a new page if you have chosen two or more vendors to be included in the report.';
                    }
                    field(BalanceAsOfDateFilter;BalanceAsOfDateFilter)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Balance as of:';
                        ToolTip = 'Specifies the date up to which you want to see deferred expenses.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if BalanceAsOfDateFilter = 0D then
              BalanceAsOfDateFilter := WorkDate;
        end;
    }

    labels
    {
        PostingDateCaption = 'Posting Date';
        DocNoCaption = 'Document No.';
        DescCaption = 'Description';
        EntryNoCaption = 'Entry No.';
        NoOfPeriodsCaption = 'No. of Periods';
        DeferralAccountCaption = 'Deferral Account';
        DocTypeCaption = 'Document Type';
        DefStartDateCaption = 'Deferral Start Date';
        AcctNameCaption = 'Account Name';
        LineNoCaption = 'Line No.';
        VendNoCaption = 'Vendor No.';
        VendNameCaption = 'Vendor Name';
        LineDescCaption = 'Line Description';
        LineTypeCaption = 'Line Type';
    }

    trigger OnPreReport()
    var
        CaptionManagement: Codeunit "Caption Class";
    begin
        VendorFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);
    end;

    var
        Vendor: Record Vendor;
        PostedDeferralHeaderPage: Record "Posted Deferral Header";
        GLFilter: Text;
        VendorFilter: Text;
        DocumentFilter: Text;
        PrintOnlyOnePerPage: Boolean;
        PageGroupNo: Integer;
        PageCaptionLbl: label 'Page';
        BalanceCaptionLbl: label 'This also includes general ledger accounts that only have a balance.';
        PeriodCaptionLbl: label 'This report also includes closing entries within the period.';
        GLBalCaptionLbl: label 'Balance';
        DeferralSummaryPurchCaptionLbl: label 'Deferral Summary - Purchasing';
        RemAmtDefCaptionLbl: label 'Remaining Amt. Deferred';
        TotAmtDefCaptionLbl: label 'Total Amt. Deferred';
        BalanceAsOfDateFilter: Date;
        PostingDate: Date;
        AmtRecognized: Decimal;
        RemainingAmtDeferred: Decimal;
        BalanceAsOfDateCaptionLbl: label 'Balance as of: ';
        AccountNoLbl: label 'Account No.';
        AmtRecognizedLbl: label 'Amt. Recognized';
        AccountName: Text[50];
        VendorName: Text[50];
        WorkingVendor: Code[20];
        PreviousVendor: Code[20];
        DeferralAccount: Code[20];
        DocumentTypeString: Text;
        QuoteLbl: label 'Quote';
        OrderLbl: label 'Order';
        InvoiceLbl: label 'Invoice';
        CreditMemoLbl: label 'Credit Memo';
        BlanketOrderLbl: label 'Blanket Order';
        ReturnOrderLbl: label 'Return Order';
        ShipmentLbl: label 'Shipment';
        PostedInvoiceLbl: label 'Posted Invoice';
        PostedCreditMemoLbl: label 'Posted Credit Memo';
        PostedReturnReceiptLbl: label 'Posted Return Receipt';
        LineDescription: Text[50];
        LineType: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        DocumentCaptionLbl: label 'Document:';
        VendorCaptionLbl: label 'Vendor:';


    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean;NewBalanceAsOfDateFilter: Date;NewDocumentNoFilter: Text;NewVendorNoFilter: Text)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
        BalanceAsOfDateFilter := NewBalanceAsOfDateFilter;
        VendorFilter := NewVendorNoFilter;
        DocumentFilter := NewDocumentNoFilter;
    end;

    local procedure ReturnPurchDocTypeString(PurchDocType: Integer): Text
    begin
        case PurchDocType of
          0:
            exit(QuoteLbl);
          1:
            exit(OrderLbl);
          2:
            exit(InvoiceLbl);
          3:
            exit(CreditMemoLbl);
          4:
            exit(BlanketOrderLbl);
          5:
            exit(ReturnOrderLbl);
          6:
            exit(ShipmentLbl);
          7:
            exit(PostedInvoiceLbl);
          8:
            exit(PostedCreditMemoLbl);
          9:
            exit(PostedReturnReceiptLbl);
          else
            exit('');
        end;
    end;
}

