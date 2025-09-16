#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51205 "Petty Cash PV"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Petty Cash PV.rdlc';

    dataset
    {
        dataitem(UnknownTable61134;UnknownTable61134)
        {
            DataItemTableView = sorting(No);
            RequestFilterFields = No;
            column(ReportForNavId_3752; 3752)
            {
            }
            column(Payments_No;No)
            {
            }
            column(Payments_Date;Date)
            {
            }
            column(Payments__Bank_Code_;"Bank Code")
            {
            }
            column(Payments_Cashier;Cashier)
            {
            }
            column(PGAccount;PGAccount)
            {
            }
            column(Payments_Amount;Amount)
            {
            }
            column(BankAccountUsed;BankAccountUsed)
            {
            }
            column(Payments_Payee;Payee)
            {
            }
            column(Payments__Branch_Code_;"Branch Code")
            {
            }
            column(Payments__Bank_Account_No_;"Bank Account No")
            {
            }
            column(BankAccountUsedName;BankAccountUsedName)
            {
            }
            column(Payments__Account_No__;"Account No.")
            {
            }
            column(Payments__Account_Name_;"Account Name")
            {
            }
            column(Payments_Date_Control1000000052;Date)
            {
            }
            column(BankName;BankName)
            {
            }
            column(Payments__PO_INV_No_;"PO/INV No")
            {
            }
            column(PGAccountUsedName;PGAccountUsedName)
            {
            }
            column(Payments_Remarks;Remarks)
            {
            }
            column(PGAccountUsedName_Control1000000016;PGAccountUsedName)
            {
            }
            column(Payments_NoCaption;FieldCaption(No))
            {
            }
            column(DATECaption;DATECaptionLbl)
            {
            }
            column(BANKCaption;BANKCaptionLbl)
            {
            }
            column(PREPARED_BYCaption;PREPARED_BYCaptionLbl)
            {
            }
            column(DEBIT_ACCOUNTCaption;DEBIT_ACCOUNTCaptionLbl)
            {
            }
            column(PAYMENT_TYPECaption;PAYMENT_TYPECaptionLbl)
            {
            }
            column(CREDIT_ACCOUNTCaption;CREDIT_ACCOUNTCaptionLbl)
            {
            }
            column(PAY_TOCaption;PAY_TOCaptionLbl)
            {
            }
            column(PAYMENT_VOUCHERCaption;PAYMENT_VOUCHERCaptionLbl)
            {
            }
            column(OFFICE_IDCaption;OFFICE_IDCaptionLbl)
            {
            }
            column(AMOUNTSCaption;AMOUNTSCaptionLbl)
            {
            }
            column(PAYEE_BANK_ACCOUNT_NOCaption;PAYEE_BANK_ACCOUNT_NOCaptionLbl)
            {
            }
            column(SUBLEDGER_ACCOUNTCaption;SUBLEDGER_ACCOUNTCaptionLbl)
            {
            }
            column(AUTHORISED_BYCaption;AUTHORISED_BYCaptionLbl)
            {
            }
            column(RECIPIENTCaption;RECIPIENTCaptionLbl)
            {
            }
            column(DATE_PREPAREDCaption;DATE_PREPAREDCaptionLbl)
            {
            }
            column(DATE_Caption;DATE_CaptionLbl)
            {
            }
            column(DATE_Caption_Control1000000058;DATE_Caption_Control1000000058Lbl)
            {
            }
            column(Payments__PO_INV_No_Caption;FieldCaption("PO/INV No"))
            {
            }
            column(Payment_DetailsCaption;Payment_DetailsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DimValues.Reset;
                DimValues.SetRange(DimValues."Dimension Code",'BRANCHES');
                DimValues.SetRange(DimValues.Code,"FIN-Payments"."Branch Code");

                if DimValues.Find('-') then begin
                CompName:=DimValues.Name;
                end
                else begin
                CompName:='';
                end;

                Banks.Reset;
                Banks.SetRange(Banks.Code,"FIN-Payments"."Bank Code");
                if Banks.Find('-') then begin
                BankName:=Banks.Description;
                end
                else begin
                BankName:='';
                end;

                Bank.Reset;
                Bank.SetRange(Bank."No.","FIN-Payments"."Paying Bank Account");
                if Bank.Find('-') then begin
                PayeeBankName:=Bank.Name;
                end
                else begin
                PayeeBankName:='';
                end;

                PGAccount:='';

                if "FIN-Payments"."Account Type"="FIN-Payments"."account type"::"G/L Account" then begin
                PGAccount:="FIN-Payments"."Account No.";
                end;

                if "FIN-Payments"."Account Type"="FIN-Payments"."account type"::"Bank Account" then begin
                Bank.Reset;
                Bank.SetRange(Bank."No.","FIN-Payments"."Account No.");
                if Bank.Find('-') then begin
                Bank.TestField(Bank."Bank Acc. Posting Group");
                BankPG.Reset;
                BankPG.SetRange(BankPG.Code,Bank."Bank Acc. Posting Group");
                if BankPG.Find('-') then begin
                PGAccount:=BankPG."G/L Bank Account No.";
                end;
                end;
                end;

                if "FIN-Payments"."Account Type"="FIN-Payments"."account type"::Vendor then begin
                Vend.Reset;
                Vend.SetRange(Vend."No.","FIN-Payments"."Account No.");
                if Vend.Find('-') then begin
                Vend.TestField(Vend."Vendor Posting Group");
                VendorPG.Reset;
                VendorPG.SetRange(VendorPG.Code,Vend."Vendor Posting Group");
                if VendorPG.Find('-') then begin
                PGAccount:=VendorPG."Payables Account";
                end;
                end;
                end;

                if "FIN-Payments"."Account Type"="FIN-Payments"."account type"::Customer then begin
                Cust.Reset;
                Cust.SetRange(Cust."No.","FIN-Payments"."Account No.");
                if Cust.Find('-') then begin
                Cust.TestField(Cust."Customer Posting Group");
                CustPG.Reset;
                CustPG.SetRange(CustPG.Code,Cust."Customer Posting Group");
                if CustPG.Find('-') then begin
                PGAccount:=CustPG."Receivables Account";
                end;
                end;
                end;

                if "FIN-Payments"."Account Type"="FIN-Payments"."account type"::"Fixed Asset" then begin
                FA.Reset;
                FA.SetRange(FA."No.","FIN-Payments"."Account No.");
                if FA.Find('-') then begin
                FA.TestField(FA."FA Posting Group");
                FAPG.Reset;
                FAPG.SetRange(FAPG.Code,FA."FA Posting Group");
                if FAPG.Find('-') then begin
                PGAccount:=FAPG."Acquisition Cost Account";
                end;
                end;
                end;

                BankAccountUsed:='';
                BankAccountUsedName:='';

                BankAccountUsed:="FIN-Payments"."Paying Bank Account";
                Bank.Reset;
                Bank.SetRange(Bank."No.",BankAccountUsed);
                if Bank.Find('-') then begin
                Bank.TestField(Bank."Bank Acc. Posting Group");
                BankPG.Reset;
                BankPG.SetRange(BankPG.Code,Bank."Bank Acc. Posting Group");
                if BankPG.Find('-') then begin
                BankAccountUsed:=BankPG."G/L Bank Account No.";
                end;

                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.",BankAccountUsed);
                if GLAccount.Find('-') then begin
                BankAccountUsedName:=GLAccount.Name;
                end;
                end;

                PGAccountUsedName:='';
                GLAccount.Reset;
                GLAccount.SetRange(GLAccount."No.",PGAccount);
                if GLAccount.Find('-') then begin
                PGAccountUsedName:=GLAccount.Name;
                end;
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
        DimValues: Record "Dimension Value";
        CompName: Text[100];
        TypeOfDoc: Text[100];
        RecPayTypes: Record UnknownRecord61129;
        BankName: Text[100];
        Banks: Record UnknownRecord61132;
        Bank: Record "Bank Account";
        PayeeBankName: Text[100];
        VendorPG: Record "Vendor Posting Group";
        CustPG: Record "Customer Posting Group";
        FAPG: Record "FA Posting Group";
        BankPG: Record "Bank Account Posting Group";
        PGAccount: Text[50];
        Vend: Record Vendor;
        Cust: Record Customer;
        FA: Record "Fixed Asset";
        CashierLinks: Record UnknownRecord61055;
        BankAccountUsed: Text[50];
        BankAccountUsedName: Text[100];
        PGAccountUsedName: Text[50];
        GLAccount: Record "G/L Account";
        DATECaptionLbl: label 'DATE';
        BANKCaptionLbl: label 'BANK';
        PREPARED_BYCaptionLbl: label 'PREPARED BY';
        DEBIT_ACCOUNTCaptionLbl: label 'DEBIT ACCOUNT';
        PAYMENT_TYPECaptionLbl: label 'PAYMENT TYPE';
        CREDIT_ACCOUNTCaptionLbl: label 'CREDIT ACCOUNT';
        PAY_TOCaptionLbl: label 'PAY TO';
        PAYMENT_VOUCHERCaptionLbl: label 'PAYMENT VOUCHER';
        OFFICE_IDCaptionLbl: label 'OFFICE ID';
        AMOUNTSCaptionLbl: label 'AMOUNTS';
        PAYEE_BANK_ACCOUNT_NOCaptionLbl: label 'PAYEE BANK ACCOUNT NO';
        SUBLEDGER_ACCOUNTCaptionLbl: label 'SUBLEDGER ACCOUNT';
        AUTHORISED_BYCaptionLbl: label 'AUTHORISED BY';
        RECIPIENTCaptionLbl: label 'RECIPIENT';
        DATE_PREPAREDCaptionLbl: label 'DATE PREPARED';
        DATE_CaptionLbl: label 'DATE:';
        DATE_Caption_Control1000000058Lbl: label 'DATE:';
        Payment_DetailsCaptionLbl: label 'Payment Details';
}

