#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 211 "Customer - Payment Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer - Payment Receipt.rdlc';
    Caption = 'Customer - Payment Receipt';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Document Type","Customer No.","Posting Date","Currency Code") where("Document Type"=filter(Payment|Refund));
            RequestFilterFields = "Customer No.","Posting Date","Document No.";
            column(ReportForNavId_8503; 8503)
            {
            }
            column(EntryNo_CustLedgEntry;"Entry No.")
            {
            }
            dataitem(PageLoop;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_6455; 6455)
                {
                }
                column(CustAddr6;CustAddr[6])
                {
                }
                column(CustAddr7;CustAddr[7])
                {
                }
                column(CustAddr8;CustAddr[8])
                {
                }
                column(CustAddr4;CustAddr[4])
                {
                }
                column(CustAddr5;CustAddr[5])
                {
                }
                column(CustAddr3;CustAddr[3])
                {
                }
                column(CustAddr1;CustAddr[1])
                {
                }
                column(CustAddr2;CustAddr[2])
                {
                }
                column(CustomerNo_CustLedgEntry;"Cust. Ledger Entry"."Customer No.")
                {
                    IncludeCaption = true;
                }
                column(DocDate_CustLedgEntry;Format("Cust. Ledger Entry"."Document Date",0,4))
                {
                }
                column(CompanyAddr1;CompanyAddr[1])
                {
                }
                column(CompanyAddr2;CompanyAddr[2])
                {
                }
                column(CompanyAddr3;CompanyAddr[3])
                {
                }
                column(CompanyAddr4;CompanyAddr[4])
                {
                }
                column(CompanyAddr5;CompanyAddr[5])
                {
                }
                column(CompanyAddr6;CompanyAddr[6])
                {
                }
                column(CompanyInfoEMail;CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                {
                }
                column(CompanyInfoHomePage;CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfoBankName;CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfoBankAccountNo;CompanyInfo."Bank Account No.")
                {
                }
                column(ReportTitle;ReportTitle)
                {
                }
                column(DocumentNo_CustLedgEntry;"Cust. Ledger Entry"."Document No.")
                {
                }
                column(PaymentDiscountTitle;PaymentDiscountTitle)
                {
                }
                column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                {
                }
                column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                {
                }
                column(CompanyInfoBankNameCptn;CompanyInfoBankNameCptnLbl)
                {
                }
                column(CompanyInfoBankAccNoCptn;CompanyInfoBankAccNoCptnLbl)
                {
                }
                column(ReceiptNoCaption;ReceiptNoCaptionLbl)
                {
                }
                column(CompanyInfoVATRegNoCptn;CompanyInfoVATRegNoCptnLbl)
                {
                }
                column(CustLedgEntry1PostDtCptn;CustLedgEntry1PostDtCptnLbl)
                {
                }
                column(AmountCaption;AmountCaptionLbl)
                {
                }
                column(PaymAmtSpecificationCptn;PaymAmtSpecificationCptnLbl)
                {
                }
                column(PmtTolInvCurrCaption;PmtTolInvCurrCaptionLbl)
                {
                }
                column(DocumentDateCaption;DocumentDateCaptionLbl)
                {
                }
                column(CompanyInfoEMailCaption;CompanyInfoEMailCaptionLbl)
                {
                }
                column(CompanyInfoHomePageCptn;CompanyInfoHomePageCptnLbl)
                {
                }
                dataitem(DetailedCustLedgEntry1;"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Applied Cust. Ledger Entry No."=field("Entry No.");
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemTableView = sorting("Applied Cust. Ledger Entry No.","Entry Type") where(Unapplied=const(false));
                    column(ReportForNavId_4751; 4751)
                    {
                    }
                    dataitem(CustLedgEntry1;"Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No."=field("Cust. Ledger Entry No.");
                        DataItemLinkReference = DetailedCustLedgEntry1;
                        DataItemTableView = sorting("Entry No.");
                        column(ReportForNavId_1125; 1125)
                        {
                        }
                        column(PostDate_CustLedgEntry1;Format("Posting Date"))
                        {
                        }
                        column(DocType_CustLedgEntry1;"Document Type")
                        {
                            IncludeCaption = true;
                        }
                        column(DocumentNo_CustLedgEntry1;"Document No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Desc_CustLedgEntry1;Description)
                        {
                            IncludeCaption = true;
                        }
                        column(CurrCode_CustLedgEntry1;CurrencyCode("Currency Code"))
                        {
                        }
                        column(ShowAmount;ShowAmount)
                        {
                        }
                        column(PmtDiscInvCurr;PmtDiscInvCurr)
                        {
                        }
                        column(PmtTolInvCurr;PmtTolInvCurr)
                        {
                        }
                        column(CurrencyCodeCaption;FieldCaption("Currency Code"))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Cust. Ledger Entry"."Entry No." then
                              CurrReport.Skip;

                            PmtDiscInvCurr := 0;
                            PmtTolInvCurr := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            ShowAmount := -DetailedCustLedgEntry1.Amount;

                            if "Cust. Ledger Entry"."Currency Code" <> "Currency Code" then begin
                              PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Original Currency Factor");
                              PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                              AppliedAmount :=
                                ROUND(
                                  -DetailedCustLedgEntry1.Amount / "Original Currency Factor" *
                                  "Cust. Ledger Entry"."Original Currency Factor",Currency."Amount Rounding Precision");
                            end else begin
                              PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                              PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                              AppliedAmount := -DetailedCustLedgEntry1.Amount;
                            end;

                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");

                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(DetailedCustLedgEntry2;"Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No."=field("Entry No.");
                    DataItemLinkReference = "Cust. Ledger Entry";
                    DataItemTableView = sorting("Cust. Ledger Entry No.","Entry Type","Posting Date") where(Unapplied=const(false));
                    column(ReportForNavId_3799; 3799)
                    {
                    }
                    dataitem(CustLedgEntry2;"Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No."=field("Applied Cust. Ledger Entry No.");
                        DataItemLinkReference = DetailedCustLedgEntry2;
                        DataItemTableView = sorting("Entry No.");
                        column(ReportForNavId_9065; 9065)
                        {
                        }
                        column(AppliedAmount;AppliedAmount)
                        {
                        }
                        column(Desc_CustLedgEntry2;Description)
                        {
                        }
                        column(DocumentNo_CustLedgEntry2;"Document No.")
                        {
                        }
                        column(DocType_CustLedgEntry2;"Document Type")
                        {
                        }
                        column(PostDate_CustLedgEntry2;Format("Posting Date"))
                        {
                        }
                        column(PmtDiscInvCurr1;PmtDiscInvCurr)
                        {
                        }
                        column(PmtTolInvCurr1;PmtTolInvCurr)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Cust. Ledger Entry"."Entry No." then
                              CurrReport.Skip;

                            PmtDiscInvCurr := 0;
                            PmtTolInvCurr := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            ShowAmount := DetailedCustLedgEntry2.Amount;

                            if "Cust. Ledger Entry"."Currency Code" <> "Currency Code" then begin
                              PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Original Currency Factor");
                              PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                            end else begin
                              PmtDiscInvCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                              PmtTolInvCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            end;

                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Given (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");
                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Cust. Ledger Entry"."Original Currency Factor");

                            AppliedAmount := DetailedCustLedgEntry2.Amount;
                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(Total;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_3476; 3476)
                    {
                    }
                    column(RemainingAmount;RemainingAmount)
                    {
                    }
                    column(CurrCode_CustLedgEntry;CurrencyCode("Cust. Ledger Entry"."Currency Code"))
                    {
                    }
                    column(OriginalAmt_CustLedgEntry;"Cust. Ledger Entry"."Original Amount")
                    {
                    }
                    column(ExtDocNo_CustLedgEntry;"Cust. Ledger Entry"."External Document No.")
                    {
                    }
                    column(PaymAmtNotAllocatedCptn;PaymAmtNotAllocatedCptnLbl)
                    {
                    }
                    column(CustLedgEntryOrgAmtCptn;CustLedgEntryOrgAmtCptnLbl)
                    {
                    }
                    column(ExternalDocumentNoCaption;ExternalDocumentNoCaptionLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                Cust.Get("Customer No.");
                FormatAddr.Customer(CustAddr,Cust);

                if not Currency.Get("Currency Code") then
                  Currency.InitRoundingPrecision;

                if "Document Type" = "document type"::Payment then begin
                  ReportTitle := Text003;
                  PaymentDiscountTitle := Text006;
                end else begin
                  ReportTitle := Text004;
                  PaymentDiscountTitle := Text007;
                end;

                CalcFields("Original Amount");
                RemainingAmount := -"Original Amount";
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr,CompanyInfo);
                GLSetup.Get;
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
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Cust: Record Customer;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array [8] of Text[50];
        CustAddr: array [8] of Text[50];
        RemainingAmount: Decimal;
        AppliedAmount: Decimal;
        PmtDiscInvCurr: Decimal;
        PmtTolInvCurr: Decimal;
        PmtDiscPmtCurr: Decimal;
        Text003: label 'Payment Receipt';
        Text004: label 'Payment Voucher';
        Text006: label 'Pmt. Disc. Given';
        Text007: label 'Pmt. Disc. Rcvd.';
        PmtTolPmtCurr: Decimal;
        ShowAmount: Decimal;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCptnLbl: label 'Bank';
        CompanyInfoBankAccNoCptnLbl: label 'Account No.';
        ReceiptNoCaptionLbl: label 'Receipt No.';
        CompanyInfoVATRegNoCptnLbl: label 'GST Reg. No.';
        CustLedgEntry1PostDtCptnLbl: label 'Posting Date';
        AmountCaptionLbl: label 'Amount';
        PaymAmtSpecificationCptnLbl: label 'Payment Amount Specification';
        PmtTolInvCurrCaptionLbl: label 'Pmt Tol.';
        DocumentDateCaptionLbl: label 'Document Date';
        CompanyInfoEMailCaptionLbl: label 'Email';
        CompanyInfoHomePageCptnLbl: label 'Home Page';
        PaymAmtNotAllocatedCptnLbl: label 'Payment Amount Not Allocated';
        CustLedgEntryOrgAmtCptnLbl: label 'Payment Amount';
        ExternalDocumentNoCaptionLbl: label 'External Document No.';

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
          exit(GLSetup."LCY Code");
        exit(SrcCurrCode);
    end;
}

