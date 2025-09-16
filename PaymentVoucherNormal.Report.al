#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50892 "Payment Voucher Normal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payment Voucher Normal.rdlc';

    dataset
    {
        dataitem(UnknownTable61688;UnknownTable61688)
        {
            CalcFields = "Total Net Amount","Total Levy";
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6437; 6437)
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
            column(Payments_HeaderCaption;Payments_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Payments_Header_No_;"FIN-Payments Header"."No.")
            {
            }
            column(ChequeNo;"FIN-Payments Header"."Cheque No.")
            {
            }
            column(PayingBank;"FIN-Payments Header"."Paying Bank Account")
            {
            }
            column(Payee;"FIN-Payments Header".Payee)
            {
            }
            column(BankName;BankName)
            {
            }
            column(BankNo;BankNo)
            {
            }
            column(TotalLevy_FINPaymentsHeader;"FIN-Payments Header"."Total Levy")
            {
            }
            column(WHT2Code_FINPaymentsHeader;"FIN-Payments Header"."WHT 2 Code")
            {
            }
            column(TotalWHT2Amount_FINPaymentsHeader;"FIN-Payments Header"."Total WHT2 Amount")
            {
            }
            column(LevyCode_FINPaymentsHeader;"FIN-Payments Header"."Levy Code")
            {
            }
            column(AmntApplied;AmntApplied)
            {
            }
            column(VATHeaderAmount;"FIN-Payments Header"."Total VAT Amount")
            {
            }
            column(PaymentNarration_PaymentsHeader;"FIN-Payments Header"."Payment Narration")
            {
            }
            column(NetHeaderAmount;"FIN-Payments Header"."Total Net Amount")
            {
            }
            column(TotalPayment_Amount;"FIN-Payments Header"."Total Payment Amount")
            {
            }
            column(PayMode;"FIN-Payments Header"."Pay Mode")
            {
            }
            column(TotalVATWithholdingAmount_FINPaymentsHeader;"FIN-Payments Header"."Total VAT Withholding Amount")
            {
            }
            column(TotalWithholdingAmount_FINPaymentsHeader;"FIN-Payments Header"."Total Withholding Amount")
            {
            }
            column(PayNarattion;PayNarattion)
            {
            }
            dataitem(UnknownTable61705;UnknownTable61705)
            {
                DataItemLink = No=field("No.");
                column(ReportForNavId_3474; 3474)
                {
                }
                column(Payment_Line__Account_Name_;"FIN-Payment Line"."Account Name")
                {
                }
                column(Payment_Line__Withholding_Tax_Amount_;"FIN-Payment Line"."Withholding Tax Amount")
                {
                }
                column(Payment_Line__Net_Amount_;"FIN-Payment Line"."Net Amount")
                {
                }
                column(Payment_Line_Line_No_;"FIN-Payment Line"."Line No.")
                {
                }
                column(Payment_Line_No;"FIN-Payment Line".No)
                {
                }
                column(Payment_Line_Type;"FIN-Payment Line".Type)
                {
                }
                column(Payment_Line_Account_No_;"FIN-Payment Line"."Account No.")
                {
                }
                column(InvPaid;InvPaid)
                {
                }
                column(PAYE;"FIN-Payment Line"."PAYE Amount")
                {
                }
                column(AmountInWords;AmountInWords)
                {
                }
                column(TTotal;TTotal)
                {
                }
                column(TotalTax;TotalTax)
                {
                }
                column(NumberText_1_;NumberText[1])
                {
                }
                column(InvNo;InvNo)
                {
                }
                column(VatLinesAmount;"FIN-Payment Line"."VAT Amount")
                {
                }
                column(InvDate;InvDate)
                {
                }
                dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
                {
                    DataItemLink = "Vendor No."=field("Account No."),"Applies-to ID"=field(No);
                    RequestFilterFields = Amount;
                    column(ReportForNavId_4114; 4114)
                    {
                    }
                    column(Vendor_Ledger_Entry__Posting_Date_;"Vendor Ledger Entry"."Posting Date")
                    {
                    }
                    column(VendAmount;"Vendor Ledger Entry".Amount)
                    {
                    }
                    column(Vendor_Ledger_Entry__Amount_to_Apply_;"Amount to Apply")
                    {
                    }
                    column(Vendor_Ledger_Entry_Description;Description)
                    {
                    }
                    column(Vendor_Ledger_Entry_Entry_No_;"Entry No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_Vendor_No_;"Vendor No.")
                    {
                    }
                    column(Vendor_Ledger_Entry_Applies_to_ID;"Applies-to ID")
                    {
                    }
                    column(ExDocNo;"Vendor Ledger Entry"."External Document No.")
                    {
                    }
                    column(OrderNo;OrderNo)
                    {
                    }
                    column(InvAmount;InvAmount)
                    {
                    }
                    column(HslAmoun;HslAmoun)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                         InvAmount:= "Vendor Ledger Entry"."Amount to Apply"*-1;
                         HslAmoun:=-0.015*"Vendor Ledger Entry"."Amount to Apply";

                        Pheader.Reset;
                        Pheader.SetRange("No.","Vendor Ledger Entry"."Document No.");
                        if Pheader.Find('-') then begin
                          OrderNo:=Pheader."Order No.";
                          end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(TotalTax);
                    "FIN-Payment Line".CalcSums("Withholding Tax Amount");
                    "FIN-Payment Line".CalcSums("VAT Amount");
                    "FIN-Payment Line".CalcSums("PAYE Amount");
                    TotalTax:="FIN-Payment Line"."Withholding Tax Amount"+"FIN-Payment Line"."VAT Amount"+"FIN-Payment Line"."PAYE Amount";
                    TTotal:=TTotal+"FIN-Payment Line"."Net Amount";


                    if "FIN-Payment Line"."Account Type"="FIN-Payment Line"."account type"::"G/L Account" then begin
                    InvNo:="FIN-Payment Line"."Account No.";
                    InvDate:="FIN-Payment Line".Date;
                    end else
                    InvNo:='';
                    InvDate:=0D;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //AmntApplied:='';

                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText,"FIN-Payments Header"."Total Net Amount",'');
                "Vendor Ledger Entry".Reset;
                "Vendor Ledger Entry".SetRange("Vendor Ledger Entry"."Applies-to ID","FIN-Payments Header"."No.");
                if "Vendor Ledger Entry".Find('-') then begin
                InvPaid:='Summary of Invoices Paid';
                //AppliedAmount:="Vendor Ledger Entry"."Amount to Apply";
                end else
                InvPaid:='';
                //AppliedAmount:=FORMAT(AmntApplied);
                //AmntApplied:='';
                TTotal:=0;
                //Get bank name and AC.NO..........JLL
                BankRec.Reset;
                BankRec.SetRange(BankRec."No.","FIN-Payments Header"."Paying Bank Account");
                if BankRec.Find('-') then begin
                BankName:=BankRec.Name;
                BankNo:=BankRec."Bank Account No.";
                end;
                pline.Reset;
                pline.SetRange(No,"FIN-Payments Header"."No." );
                if pline.Find('-') then begin
                    if "FIN-Payments Header"."PV Category"<> "FIN-Payments Header"."pv category"::"Normal PV" then begin
                    PayNarattion:=  pline."Transaction Name"+' for '+ pline."Account Name";
                      end else
                       PayNarattion:= '';
                      //PayNarattion:=  pLine."Transaction Name"+' for '+ pLine."Account Name";

                  end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
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
        Payments_HeaderCaptionLbl: label 'Payments Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        InvPaid: Code[30];
        AmountInWords: Text[200];
        CheckReport: Report Check;
        NumberText: array [2] of Text[100];
        TTotal: Decimal;
        BankName: Text[100];
        BankNo: Code[50];
        BankRec: Record "Bank Account";
        InvNo: Code[20];
        InvDate: Date;
        AmntApplied: Text;
        AppliedAmount: Decimal;
        InvAmount: Decimal;
        PayNarattion: Text[100];
        pline: Record UnknownRecord61705;
        HslAmoun: Decimal;
        TotalTax: Decimal;
        InvoiceLineAmount: Decimal;
        Pheader: Record "Purch. Inv. Header";
        OrderNo: Code[10];
}

