#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 411 "Vendor - Payment Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor - Payment Receipt.rdlc';
    Caption = 'Vendor - Payment Receipt';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Document Type","Vendor No.","Posting Date","Currency Code") where("Document Type"=filter(Payment|Refund));
            RequestFilterFields = "Vendor No.","Posting Date","Document No.";
            column(ReportForNavId_4114; 4114)
            {
            }
            dataitem(PageLoop;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_6455; 6455)
                {
                }
                column(VendAddr6;VendAddr[6])
                {
                }
                column(VendAddr7;VendAddr[7])
                {
                }
                column(VendAddr8;VendAddr[8])
                {
                }
                column(VendAddr4;VendAddr[4])
                {
                }
                column(VendAddr5;VendAddr[5])
                {
                }
                column(VendAddr3;VendAddr[3])
                {
                }
                column(VendAddr1;VendAddr[1])
                {
                }
                column(VendAddr2;VendAddr[2])
                {
                }
                column(VendNo_VendLedgEntry;"Vendor Ledger Entry"."Vendor No.")
                {
                    IncludeCaption = true;
                }
                column(DocDate_VendLedgEntry;Format("Vendor Ledger Entry"."Document Date",0,4))
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
                column(PhoneNo;CompanyInfo."Phone No.")
                {
                }
                column(HomePage;CompanyInfo."Home Page")
                {
                }
                column(Email;CompanyInfo."E-Mail")
                {
                }
                column(VATRegistrationNo;CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo;CompanyInfo."Giro No.")
                {
                }
                column(BankName;CompanyInfo."Bank Name")
                {
                }
                column(BankAccountNo;CompanyInfo."Bank Account No.")
                {
                }
                column(ReportTitle;ReportTitle)
                {
                }
                column(DocNo_VendLedgEntry;"Vendor Ledger Entry"."Document No.")
                {
                }
                column(PymtDiscTitle;PaymentDiscountTitle)
                {
                }
                column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                {
                }
                column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                {
                }
                column(CompanyInfoBankNameCaption;CompanyInfoBankNameCaptionLbl)
                {
                }
                column(CompanyInfoBankAccNoCaption;CompanyInfoBankAccNoCaptionLbl)
                {
                }
                column(RcptNoCaption;RcptNoCaptionLbl)
                {
                }
                column(CompanyInfoVATRegNoCaption;CompanyInfoVATRegNoCaptionLbl)
                {
                }
                column(PostingDateCaption;PostingDateCaptionLbl)
                {
                }
                column(AmtCaption;AmtCaptionLbl)
                {
                }
                column(PymtAmtSpecCaption;PymtAmtSpecCaptionLbl)
                {
                }
                column(PymtTolInvCurrCaption;PymtTolInvCurrCaptionLbl)
                {
                }
                dataitem(DetailedVendorLedgEntry1;"Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Applied Vend. Ledger Entry No."=field("Entry No.");
                    DataItemLinkReference = "Vendor Ledger Entry";
                    DataItemTableView = sorting("Applied Vend. Ledger Entry No.","Entry Type") where(Unapplied=const(false));
                    column(ReportForNavId_5741; 5741)
                    {
                    }
                    column(AppliedVLENo_DtldVendLedgEntry;"Applied Vend. Ledger Entry No.")
                    {
                    }
                    dataitem(VendLedgEntry1;"Vendor Ledger Entry")
                    {
                        DataItemLink = "Entry No."=field("Vendor Ledger Entry No.");
                        DataItemLinkReference = DetailedVendorLedgEntry1;
                        DataItemTableView = sorting("Entry No.");
                        column(ReportForNavId_5994; 5994)
                        {
                        }
                        column(PostingDate_VendLedgEntry1;Format("Posting Date"))
                        {
                        }
                        column(DocType_VendLedgEntry1;"Document Type")
                        {
                            IncludeCaption = true;
                        }
                        column(DocNo_VendLedgEntry1;"Document No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_VendLedgEntry1;Description)
                        {
                            IncludeCaption = true;
                        }
                        column(NegShowAmountVendLedgEntry1;-NegShowAmountVendLedgEntry1)
                        {
                        }
                        column(CurrCode_VendLedgEntry1;CurrencyCode("Currency Code"))
                        {
                        }
                        column(NegPmtDiscInvCurrVendLedgEntry1;-NegPmtDiscInvCurrVendLedgEntry1)
                        {
                        }
                        column(NegPmtTolInvCurrVendLedgEntry1;-NegPmtTolInvCurrVendLedgEntry1)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Vendor Ledger Entry"."Entry No." then
                              CurrReport.Skip;

                            NegPmtDiscInvCurrVendLedgEntry1 := 0;
                            NegPmtTolInvCurrVendLedgEntry1 := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            NegShowAmountVendLedgEntry1 := -DetailedVendorLedgEntry1.Amount;

                            if "Vendor Ledger Entry"."Currency Code" <> "Currency Code" then begin
                              NegPmtDiscInvCurrVendLedgEntry1 := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              NegPmtTolInvCurrVendLedgEntry1 := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              AppliedAmount :=
                                ROUND(
                                  -DetailedVendorLedgEntry1.Amount / "Original Currency Factor" * "Vendor Ledger Entry"."Original Currency Factor",
                                  Currency."Amount Rounding Precision");
                            end else begin
                              NegPmtDiscInvCurrVendLedgEntry1 := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              NegPmtTolInvCurrVendLedgEntry1 := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              AppliedAmount := -DetailedVendorLedgEntry1.Amount;
                            end;

                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                        end;
                    }
                }
                dataitem(DetailedVendorLedgEntry2;"Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Vendor Ledger Entry No."=field("Entry No.");
                    DataItemLinkReference = "Vendor Ledger Entry";
                    DataItemTableView = sorting("Vendor Ledger Entry No.","Entry Type","Posting Date") where(Unapplied=const(false));
                    column(ReportForNavId_1758; 1758)
                    {
                    }
                    column(VLENo_DtldVendLedgEntry;"Vendor Ledger Entry No.")
                    {
                    }
                    dataitem(VendLedgEntry2;"Vendor Ledger Entry")
                    {
                        DataItemLink = "Entry No."=field("Applied Vend. Ledger Entry No.");
                        DataItemLinkReference = DetailedVendorLedgEntry2;
                        DataItemTableView = sorting("Entry No.");
                        column(ReportForNavId_2011; 2011)
                        {
                        }
                        column(NegAppliedAmt;-AppliedAmount)
                        {
                        }
                        column(Description_VendLedgEntry2;Description)
                        {
                        }
                        column(DocNo_VendLedgEntry2;"Document No.")
                        {
                        }
                        column(DocType_VendLedgEntry2;"Document Type")
                        {
                        }
                        column(PostingDate_VendLedgEntry2;Format("Posting Date"))
                        {
                        }
                        column(CurrCode_VendLedgEntry2;CurrencyCode("Currency Code"))
                        {
                        }
                        column(NegPmtDiscInvCurrVendLedgEntry2;-NegPmtDiscInvCurrVendLedgEntry1)
                        {
                        }
                        column(NegPmtTolInvCurr1VendLedgEntry2;-NegPmtTolInvCurrVendLedgEntry1)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Vendor Ledger Entry"."Entry No." then
                              CurrReport.Skip;

                            NegPmtDiscInvCurrVendLedgEntry1 := 0;
                            NegPmtTolInvCurrVendLedgEntry1 := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;

                            NegShowAmountVendLedgEntry1 := DetailedVendorLedgEntry2.Amount;

                            if "Vendor Ledger Entry"."Currency Code" <> "Currency Code" then begin
                              NegPmtDiscInvCurrVendLedgEntry1 := ROUND("Pmt. Disc. Rcd.(LCY)" * "Original Currency Factor");
                              NegPmtTolInvCurrVendLedgEntry1 := ROUND("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                            end else begin
                              NegPmtDiscInvCurrVendLedgEntry1 := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              NegPmtTolInvCurrVendLedgEntry1 := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                            end;

                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");

                            AppliedAmount := DetailedVendorLedgEntry2.Amount;
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
                    column(NegRemainingAmt;-RemainingAmount)
                    {
                    }
                    column(CurrCode_VendLedgEntry;CurrencyCode("Vendor Ledger Entry"."Currency Code"))
                    {
                    }
                    column(NegOriginalAmt_VendLedgEntry;-"Vendor Ledger Entry"."Original Amount")
                    {
                    }
                    column(ExtDocNo_VendLedgEntry;"Vendor Ledger Entry"."External Document No.")
                    {
                    }
                    column(PymtAmtNotAllocatedCaption;PymtAmtNotAllocatedCaptionLbl)
                    {
                    }
                    column(PymtAmtCaption;PymtAmtCaptionLbl)
                    {
                    }
                    column(ExternalDocNoCaption;ExternalDocNoCaptionLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                Vend.Get("Vendor No.");
                FormatAddr.Vendor(VendAddr,Vend);
                if not Currency.Get("Currency Code") then
                  Currency.InitRoundingPrecision;

                if "Document Type" = "document type"::Payment then begin
                  ReportTitle := Text004;
                  PaymentDiscountTitle := Text007;
                end else begin
                  ReportTitle := Text003;
                  PaymentDiscountTitle := Text006;
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
        CurrencyCodeCaption = 'Currency Code';
        PageCaption = 'Page';
        DocDateCaption = 'Document Date';
        EmailCaption = 'Email';
        HomePageCaption = 'Home Page';
    }

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ReportTitle: Text[30];
        PaymentDiscountTitle: Text[30];
        CompanyAddr: array [8] of Text[50];
        VendAddr: array [8] of Text[50];
        RemainingAmount: Decimal;
        AppliedAmount: Decimal;
        NegPmtDiscInvCurrVendLedgEntry1: Decimal;
        NegPmtTolInvCurrVendLedgEntry1: Decimal;
        PmtDiscPmtCurr: Decimal;
        Text003: label 'Payment Receipt';
        Text004: label 'Payment Voucher';
        Text006: label 'Payment Discount Given';
        Text007: label 'Payment Discount Received';
        PmtTolPmtCurr: Decimal;
        NegShowAmountVendLedgEntry1: Decimal;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccNoCaptionLbl: label 'Account No.';
        RcptNoCaptionLbl: label 'Receipt No.';
        CompanyInfoVATRegNoCaptionLbl: label 'GST Registration No.';
        PostingDateCaptionLbl: label 'Posting Date';
        AmtCaptionLbl: label 'Amount';
        PymtAmtSpecCaptionLbl: label 'Payment Amount Specification';
        PymtTolInvCurrCaptionLbl: label 'Payment Total';
        PymtAmtNotAllocatedCaptionLbl: label 'Payment Amount Not Allocated';
        PymtAmtCaptionLbl: label 'Payment Amount';
        ExternalDocNoCaptionLbl: label 'External Document No.';

    local procedure CurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
          exit(GLSetup."LCY Code");

        exit(SrcCurrCode);
    end;
}

