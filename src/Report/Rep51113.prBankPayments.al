#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51113 "prBank Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prBank Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61077;UnknownTable61077)
        {
            RequestFilterFields = "Bank Code","Branch Code";
            column(ReportForNavId_4233; 4233)
            {
            }
            column(USERID;UserId)
            {
            }
            column(TODAY;Today)
            {
            }
            column(PeriodName;PeriodName)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(companyinfo_Picture;companyinfo.Picture)
            {
            }
            column(TotTaxablePay;TotTaxablePay)
            {
            }
            column(User_Name_Caption;User_Name_CaptionLbl)
            {
            }
            column(Print_Date_Caption;Print_Date_CaptionLbl)
            {
            }
            column(BANK_PAYMENT_REPORTCaption;BANK_PAYMENT_REPORTCaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(Page_No_Caption;Page_No_CaptionLbl)
            {
            }
            column(Net_Amount_Caption;Net_Amount_CaptionLbl)
            {
            }
            column(Account_Number_Caption;Account_Number_CaptionLbl)
            {
            }
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(Employee_BankCaption;Employee_BankCaptionLbl)
            {
            }
            column(Bank_Branch_Caption;Bank_Branch_CaptionLbl)
            {
            }
            column(Prepared_by_______________________________________Date_________________Caption;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked_by________________________________________Date_________________Caption;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Authorized_by____________________________________Date_________________Caption;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(Approved_by______________________________________Date_________________Caption;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }
            column(Total_Caption;Total_CaptionLbl)
            {
            }
            column(prBank_Structure_Bank_Code;"Bank Code")
            {
            }
            column(prBank_Structure_Branch_Code;"Branch Code")
            {
            }
            dataitem(UnknownTable61118;UnknownTable61118)
            {
                DataItemLink = "Main Bank"=field("Bank Code"),"Branch Bank"=field("Branch Code");
                DataItemTableView = sorting("No.") order(ascending);
                column(ReportForNavId_8631; 8631)
                {
                }
                column(HR_Employee__Main_Bank_;"Main Bank")
                {
                }
                column(HR_Employee__Branch_Bank_;"Branch Bank")
                {
                }
                column(HR_Employee__Main_Bank_Caption;FieldCaption("Main Bank"))
                {
                }
                column(HR_Employee__Branch_Bank_Caption;FieldCaption("Branch Bank"))
                {
                }
                column(HR_Employee_No_;"No.")
                {
                }
                dataitem(UnknownTable61105;UnknownTable61105)
                {
                    DataItemLink = "Employee Code"=field("No.");
                    RequestFilterFields = "Period Filter","Employee Code";
                    column(ReportForNavId_6207; 6207)
                    {
                    }
                    column(prSalary_Card__prSalary_Card___Employee_Code_;"PRL-Salary Card"."Employee Code")
                    {
                    }
                    column(EmployeeName;EmployeeName)
                    {
                    }
                    column(TaxablePay;TaxablePay)
                    {
                    }
                    column(bankAcc;bankAcc)
                    {
                    }
                    column(mainBankNM;mainBankNM)
                    {
                    }
                    column(BranchBankNM;BranchBankNM)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //  bankAcc:='';
                        //  mainBankNM:='';
                        //  BranchBankNM:='';

                        objEmp.Reset;
                        objEmp.SetRange(objEmp."No.","Employee Code");
                        if objEmp.Find('-') then
                          EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";

                          //Bank Details
                          bankAcc:=objEmp."Bank Account Number";

                          bankStruct.Reset;
                          bankStruct.SetRange(bankStruct."Bank Code",objEmp."Main Bank");
                          bankStruct.SetRange(bankStruct."Branch Code",objEmp."Branch Bank");
                          if bankStruct.Find('-') then
                          begin
                           mainBankNM:=bankStruct."Bank Name";
                           BranchBankNM:=bankStruct."Branch Name";
                          end;

                        PeriodTrans.Reset;
                        PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                        PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);

                        TaxablePay:=0;
                        if PeriodTrans.Find('-') then
                           repeat
                              //TXBP Taxable Pay -  BY DENNIS
                              if (PeriodTrans."Transaction Code"='NPAY') then
                              begin
                                 TaxablePay:=PeriodTrans.Amount;
                              end;
                           until PeriodTrans.Next=0;

                          TotTaxablePay:=TotTaxablePay+TaxablePay;
                          TotPayeAmount:=TotPayeAmount+PayeAmount;
                    end;
                }
            }
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

    trigger OnPreReport()
    begin
        PeriodFilter:="PRL-Salary Card".GetFilter("Period Filter");
        if PeriodFilter='' then Error('You must specify the period filter');

        SelectedPeriod:="PRL-Salary Card".GetRangeMin("Period Filter");
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";


        if companyinfo.Get() then
        companyinfo.CalcFields(companyinfo.Picture);
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        PayeAmount: Decimal;
        TotPayeAmount: Decimal;
        TaxablePay: Decimal;
        TotTaxablePay: Decimal;
        EmployeeName: Text[30];
        PinNumber: Text[30];
        objPeriod: Record UnknownRecord61081;
        objEmp: Record UnknownRecord61118;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        companyinfo: Record "Company Information";
        bankStruct: Record UnknownRecord61077;
        bankAcc: Text[50];
        BranchBankNM: Text[100];
        mainBankNM: Text[100];
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        BANK_PAYMENT_REPORTCaptionLbl: label 'BANK PAYMENT REPORT';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Net_Amount_CaptionLbl: label 'Net Amount:';
        Account_Number_CaptionLbl: label 'Account Number:';
        Employee_NameCaptionLbl: label 'Employee Name';
        No_CaptionLbl: label 'No:';
        Employee_BankCaptionLbl: label 'Employee Bank';
        Bank_Branch_CaptionLbl: label 'Bank Branch:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Total_CaptionLbl: label 'Total:';
}

