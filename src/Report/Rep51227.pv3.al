#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51227 pv3
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/pv3.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            RequestFilterFields = "Entry No.";
            column(ReportForNavId_8503; 8503)
            {
            }
            column(VendorName;VendorName)
            {
            }
            column(CompanyLine1;CompanyLine1)
            {
            }
            column(CompanyLine2;CompanyLine2)
            {
            }
            column(CompanyLine3;CompanyLine3)
            {
            }
            column(CompanyLine4;CompanyLine4)
            {
            }
            column(CompanyLine5;CompanyLine5)
            {
            }
            column(VendorAddress__________VendorAddress2;VendorAddress + ' '  + VendorAddress2)
            {
            }
            column(VendorPhoneFax;VendorPhoneFax)
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Cust__Ledger_Entry___Customer_No__;"Cust. Ledger Entry"."Customer No.")
            {
            }
            column(BankCurr;BankCurr)
            {
            }
            column(Cust__Ledger_Entry__External_Document_No__;"External Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(PurchaseHeaderNo__;"PurchaseHeaderNo.")
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(Payments_Department;Payments.Department)
            {
            }
            column(Payments__Total_Allocation_;Payments."Total Allocation")
            {
            }
            column(Payments__Vote_Book_;Payments."Vote Book")
            {
            }
            column(Payments_Balance;Payments.Balance)
            {
            }
            column(Payments__Balance_Less_this_Entry_;Payments."Balance Less this Entry")
            {
            }
            column(Budget_Bal;Budget_Bal)
            {
            }
            column(FORMAT_TODAY_0_4__Control1000000063;Format(Today,0,4))
            {
            }
            column(Payments__Posted_By_;Payments."Posted By")
            {
            }
            column(Payments__Date_Posted_;Payments."Date Posted")
            {
            }
            column(Payments__Cheque_No_;Payments."Cheque No")
            {
            }
            column(Cust__Ledger_Entry_Amount_Control1000000116;Amount)
            {
            }
            column(Cust__Ledger_Entry__User_ID_;"User ID")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date__Control1000000129;"Posting Date")
            {
            }
            column(Payments__Posted_By__Control1000000136;Payments."Posted By")
            {
            }
            column(Payments__Date_Posted__Control1000000137;Payments."Date Posted")
            {
            }
            column(Payments__Payment_Date_;Payments."Payment Date")
            {
            }
            column(Payment_VoucherCaption;Payment_VoucherCaptionLbl)
            {
            }
            column(Payee_s_A_C_CodeCaption;Payee_s_A_C_CodeCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Voucher_No_Caption;Voucher_No_CaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Payee_s_AddressCaption;Payee_s_AddressCaptionLbl)
            {
            }
            column(Invoice_No_Caption;Invoice_No_CaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(L_P_O_No_Caption;L_P_O_No_CaptionLbl)
            {
            }
            column(Expense_DescriptionCaption;Expense_DescriptionCaptionLbl)
            {
            }
            column(Prepared_By_______________________________________________________________________________Caption;Prepared_By_______________________________________________________________________________CaptionLbl)
            {
            }
            column(Approved_By_Caption;Approved_By_CaptionLbl)
            {
            }
            column(Date_______________________________________________________________________________Caption;Date_______________________________________________________________________________CaptionLbl)
            {
            }
            column(Date_Caption;Date_CaptionLbl)
            {
            }
            column(Date______________________________________________________________________Caption;Date______________________________________________________________________CaptionLbl)
            {
            }
            column(Passed_For_Payment_______________________________________________________Caption;Passed_For_Payment_______________________________________________________CaptionLbl)
            {
            }
            column(Date_______________________________________________________________________________Caption_Control1000000036;Date_______________________________________________________________________________Caption_Control1000000036Lbl)
            {
            }
            column(Amount_in_wordsCaption;Amount_in_wordsCaptionLbl)
            {
            }
            column(Vote_Book_ControlCaption;Vote_Book_ControlCaptionLbl)
            {
            }
            column(Department_CodeCaption;Department_CodeCaptionLbl)
            {
            }
            column(Approved_Annual_Estimates_KshsCaption;Approved_Annual_Estimates_KshsCaptionLbl)
            {
            }
            column(Account_CodeCaption;Account_CodeCaptionLbl)
            {
            }
            column(Less_Expenditure_Plus_CommitmentsCaption;Less_Expenditure_Plus_CommitmentsCaptionLbl)
            {
            }
            column(BalanceCaption;BalanceCaptionLbl)
            {
            }
            column(Balance_Less_This_EntryCaption;Balance_Less_This_EntryCaptionLbl)
            {
            }
            column(AUTHORIZATIONCaption;AUTHORIZATIONCaptionLbl)
            {
            }
            column(I_certify_that_the_above_expenditure_is_CORRECT_has_been_incurred_for_the_Caption;I_certify_that_the_above_expenditure_is_CORRECT_has_been_incurred_for_the_CaptionLbl)
            {
            }
            column(University_Purpose_and_authorize_the_payments_withiout_any_alteration_Caption;University_Purpose_and_authorize_the_payments_withiout_any_alteration_CaptionLbl)
            {
            }
            column(Date_____________________________________________________________________________________________________________Caption;Date_____________________________________________________________________________________________________________CaptionLbl)
            {
            }
            column(PAYMENT___CASHBOOK_SECTIONS_Caption;PAYMENT___CASHBOOK_SECTIONS_CaptionLbl)
            {
            }
            column(Cheque_DateCaption;Cheque_DateCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Approved_By_Budget_Accountant____________________________________________________________________Caption;Approved_By_Budget_Accountant____________________________________________________________________CaptionLbl)
            {
            }
            column(DVC_A___F_Caption;DVC_A___F_CaptionLbl)
            {
            }
            column(VC___DVC_A___F_Caption;VC___DVC_A___F_CaptionLbl)
            {
            }
            column(DataItem1000000124;Date_____________________________________________________________________________________________________________Caption_ContLbl)
            {
            }
            column(DataItem1000000125;Date_____________________________________________________________________________________________________________Caption_C000Lbl)
            {
            }
            column(For__Finance_OfficerCaption;For__Finance_OfficerCaptionLbl)
            {
            }
            column(For__Chief_Internal_AuditorCaption;For__Chief_Internal_AuditorCaptionLbl)
            {
            }
            column(DataItem1000000128;Date_____________________________________________________________________________________________________________Caption_C001Lbl)
            {
            }
            column(Date_PaidCaption;Date_PaidCaptionLbl)
            {
            }
            column(ByCaption;ByCaptionLbl)
            {
            }
            column(Received_By_Caption;Received_By_CaptionLbl)
            {
            }
            column(Name_______________________________________________________Caption;Name_______________________________________________________CaptionLbl)
            {
            }
            column(Date_______________________________________________________________________________Caption_Control1000000134;Date_______________________________________________________________________________Caption_Control1000000134Lbl)
            {
            }
            column(Cheque_NoCaption;Cheque_NoCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                 CurrReport.CreateTotals("Cust. Ledger Entry".Amount);
                 Hesabu:=0;
                //IF BankAcc='' THEN
                // ERROR('Please select the paying bank from the options tab');
                Payments.SetRange(Payments."Apply to ID","Cust. Ledger Entry"."Applies-to ID");
                Payments.FindLast();
                Budget_Bal:=Payments."Total Allocation"- (Payments."Total Expenditure" + Payments."Total Commitments");
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

    trigger OnInitReport()
    begin
        //retrieve the company information
        GetCompanyInformation();
    end;

    var
        Budget_Bal: Decimal;
        CheckReport: Report Check;
        NumberText: array [2] of Text[80];
        PostingDate: Date;
        "PurchaseHeaderNo.": Code[20];
        PurchaseHeader: Record "Purch. Inv. Header";
        Company: Record "Company Information";
        CompanyLine1: Text[100];
        CompanyLine2: Text[100];
        CompanyLine3: Text[100];
        CompanyLine4: Text[100];
        CompanyLine5: Text[100];
        Customer: Record Customer;
        VendorName: Text[150];
        VendorAddress: Text[100];
        VendorAddress2: Text[100];
        VendorPhoneFax: Text[100];
        VendorEmail: Text[100];
        Genjournal: Record "Gen. Journal Line";
        CHEQNO: Code[10];
        Amount: Decimal;
        WTAX: Decimal;
        ate: Text[100];
        PurchLine: Record "Purch. Inv. Line";
        "G/l Account": Code[10];
        Description: Integer;
        Pdate: Date;
        DocumentNo: Code[20];
        Detail: Text[50];
        BankName: Text[30];
        TAmount: Decimal;
        Hesabu: Integer;
        BankAcc: Code[20];
        BankAccc: Record "Bank Account";
        BankCurr: Code[10];
        Gensetup: Record "General Ledger Setup";
        Payments: Record UnknownRecord61134;
        CurrRate: Code[10];
        Payment_VoucherCaptionLbl: label 'Payment Voucher';
        Payee_s_A_C_CodeCaptionLbl: label 'Payee''s A/C Code';
        DateCaptionLbl: label 'Date';
        Voucher_No_CaptionLbl: label 'Voucher No.';
        NameCaptionLbl: label 'Name';
        Payee_s_AddressCaptionLbl: label 'Payee''s Address';
        Invoice_No_CaptionLbl: label 'Invoice No.';
        AmountCaptionLbl: label 'Amount';
        L_P_O_No_CaptionLbl: label 'L.P.O No.';
        Expense_DescriptionCaptionLbl: label 'Expense Description';
        Prepared_By_______________________________________________________________________________CaptionLbl: label 'Prepared By ..............................................................................';
        Approved_By_CaptionLbl: label 'Approved By ';
        Date_______________________________________________________________________________CaptionLbl: label 'Date ..............................................................................';
        Date_CaptionLbl: label 'Date ';
        Date______________________________________________________________________CaptionLbl: label 'Date......................................................................';
        Passed_For_Payment_______________________________________________________CaptionLbl: label 'Passed For Payment.......................................................';
        Date_______________________________________________________________________________Caption_Control1000000036Lbl: label 'Date ..............................................................................';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        Vote_Book_ControlCaptionLbl: label 'Vote Book Control';
        Department_CodeCaptionLbl: label 'Department Code';
        Approved_Annual_Estimates_KshsCaptionLbl: label 'Approved Annual Estimates Kshs';
        Account_CodeCaptionLbl: label 'Account Code';
        Less_Expenditure_Plus_CommitmentsCaptionLbl: label 'Less Expenditure Plus Commitments';
        BalanceCaptionLbl: label 'Balance';
        Balance_Less_This_EntryCaptionLbl: label 'Balance Less This Entry';
        AUTHORIZATIONCaptionLbl: label 'AUTHORIZATION';
        I_certify_that_the_above_expenditure_is_CORRECT_has_been_incurred_for_the_CaptionLbl: label 'I certify that the above expenditure is CORRECT has been incurred for the ';
        University_Purpose_and_authorize_the_payments_withiout_any_alteration_CaptionLbl: label 'University Purpose and authorize the payments withiout any alteration.';
        Date_____________________________________________________________________________________________________________CaptionLbl: label '...............................................................................................Date.............................................................................................................';
        PAYMENT___CASHBOOK_SECTIONS_CaptionLbl: label 'PAYMENT & CASHBOOK SECTIONS:';
        Cheque_DateCaptionLbl: label 'Cheque Date';
        TotalCaptionLbl: label 'Total';
        Approved_By_Budget_Accountant____________________________________________________________________CaptionLbl: label 'Approved By Budget Accountant................................................................... ';
        DVC_A___F_CaptionLbl: label 'DVC(A & F)';
        VC___DVC_A___F_CaptionLbl: label 'VC / DVC(A & F)';
        Date_____________________________________________________________________________________________________________Caption_ContLbl: label '...............................................................................................Date.............................................................................................................';
        Date_____________________________________________________________________________________________________________Caption_C000Lbl: label '...............................................................................................Date.............................................................................................................';
        For__Finance_OfficerCaptionLbl: label 'For: Finance Officer';
        For__Chief_Internal_AuditorCaptionLbl: label 'For: Chief Internal Auditor';
        Date_____________________________________________________________________________________________________________Caption_C001Lbl: label '...............................................................................................Date.............................................................................................................';
        Date_PaidCaptionLbl: label ' Date Paid';
        ByCaptionLbl: label 'By';
        Received_By_CaptionLbl: label 'Received By:';
        Name_______________________________________________________CaptionLbl: label 'Name.......................................................';
        Date_______________________________________________________________________________Caption_Control1000000134Lbl: label 'Date ..............................................................................';
        Cheque_NoCaptionLbl: label 'Cheque No';


    procedure GetCompanyInformation()
    begin
        Company.Reset;
        if Company.Find('-') then
            begin
                CompanyLine1:=Company.Name;
                CompanyLine2:=Company.Address +  ' ' + Company."Address 2" + '-' + Company."Post Code" +  Company.City + ',KENYA' ;
                CompanyLine3:='Tel No.:' + ' ' + Company."Phone No." + ' Fax No.:' + Company."Fax No.";
                CompanyLine4:='E-mail:' + ' ' + Company."E-Mail";
                CompanyLine5:='www.karu.ac.ke';
            end;
    end;


    procedure GetLPONumber(var InvoiceNo: Code[20])
    begin
        //reset the purchase header record and retrieve the l.p.o number from the database using the GET method
        PurchaseHeader.Reset;
        //use the parameter passed by the client and retrieve the details from the database
        if PurchaseHeader.Get(InvoiceNo) then
            begin
                //set the purchase order number from the database to the variable holding the same
                "PurchaseHeaderNo.":=PurchaseHeader."Order No.";
                PostingDate:=PurchaseHeader."Posting Date";
            end;
    end;
}

