#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51114 "prOther Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prOther Payments.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            DataItemTableView = sorting("No.") order(ascending) where("Bank Account Number"=filter(""));
            column(ReportForNavId_8631; 8631)
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
            column(EmployeeName;EmployeeName)
            {
            }
            column(TaxablePay;TaxablePay)
            {
            }
            column(HR_Employee__HR_Employee___No__;"HRM-Employee (D)"."No.")
            {
            }
            column(icount;icount)
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
            column(FOSA_PAYMENT_REPORTCaption;FOSA_PAYMENT_REPORTCaptionLbl)
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
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(Approved_by______________________________________Date_________________Caption;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }
            column(Authorized_by____________________________________Date_________________Caption;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked_by________________________________________Date_________________Caption;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Prepared_by_______________________________________Date_________________Caption;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }
            column(Total_Caption;Total_CaptionLbl)
            {
            }
            dataitem(UnknownTable61105;UnknownTable61105)
            {
                DataItemLink = "Employee Code"=field("No.");
                RequestFilterFields = "Period Filter","Employee Code";
                column(ReportForNavId_6207; 6207)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //  bankAcc:='';
                    //  mainBankNM:='';
                    //  BranchBankNM:='';
                end;
            }

            trigger OnAfterGetRecord()
            begin
                  mainBankNM:='';
                  BranchBankNM:='';

                  EmployeeName:="First Name"+' '+"Middle Name"+' '+"Last Name";

                  bankAcc:=objEmp."Bank Account Number";

                  bankStruct.Reset;
                  bankStruct.SetRange(bankStruct."Bank Code","Main Bank");
                  bankStruct.SetRange(bankStruct."Branch Code","Branch Bank");
                  if bankStruct.Find('-') then
                  begin
                   mainBankNM:=bankStruct."Bank Name";
                   BranchBankNM:=bankStruct."Branch Name";
                  end;


                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","No.");
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
                 icount:=icount+1;
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
        icount: Integer;
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        FOSA_PAYMENT_REPORTCaptionLbl: label 'FOSA PAYMENT REPORT';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Net_Amount_CaptionLbl: label 'Net Amount:';
        Employee_NameCaptionLbl: label 'Employee Name';
        No_CaptionLbl: label 'No:';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Total_CaptionLbl: label 'Total:';
}

