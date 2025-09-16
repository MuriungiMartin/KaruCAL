#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51856 "prPaye Schedule 1a"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prPaye Schedule 1a.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            RequestFilterFields = "Employee Code";
            column(ReportForNavId_6207; 6207)
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
            column(prSalary_Card__prSalary_Card___Employee_Code_;"PRL-Salary Card"."Employee Code")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(PinNumber;PinNumber)
            {
            }
            column(PayeAmount;PayeAmount)
            {
            }
            column(TaxablePay;TaxablePay)
            {
            }
            column(TotTaxablePay;TotTaxablePay)
            {
            }
            column(TotPayeAmount;TotPayeAmount)
            {
            }
            column(User_Name_Caption;User_Name_CaptionLbl)
            {
            }
            column(Print_Date_Caption;Print_Date_CaptionLbl)
            {
            }
            column(P_A_Y_E_ScheduleCaption;P_A_Y_E_ScheduleCaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(Page_No_Caption;Page_No_CaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(PIN_Number_Caption;PIN_Number_CaptionLbl)
            {
            }
            column(Paye_Amount_Caption;Paye_Amount_CaptionLbl)
            {
            }
            column(Taxable_Pay_Caption;Taxable_Pay_CaptionLbl)
            {
            }
            column(Prepared_by_______________________________________Date_________________Caption;Prepared_by_______________________________________Date_________________CaptionLbl)
            {
            }
            column(Checked_by________________________________________Date_________________Caption;Checked_by________________________________________Date_________________CaptionLbl)
            {
            }
            column(Totals_Caption;Totals_CaptionLbl)
            {
            }
            column(Authorized_by____________________________________Date_________________Caption;Authorized_by____________________________________Date_________________CaptionLbl)
            {
            }
            column(Approved_by______________________________________Date_________________Caption;Approved_by______________________________________Date_________________CaptionLbl)
            {
            }
            column(PensionRelief;PensionRelief)
            {
            }
            column(InsuranceRelief;InsuranceRelief)
            {
            }
            column(TotalPension;TotPensionRelief)
            {
            }
            column(TotalInsurance;TotInsuranceRelief)
            {
            }
            column(Grosspay;GrossPay)
            {
            }
            column(Pensionself;PensionSelf)
            {
            }
            column(Nssf;Nssf)
            {
            }
            column(Providentself;ProvidentSelf)
            {
            }
            column(PersonalRelief;PersonalRelief)
            {
            }
            column(TotalPersonal;TotPersonalRelief)
            {
            }
            column(payspaye;"PRL-Salary Card"."Pays PAYE")
            {
            }
            column(NHIFRelief;NHIFRelief)
            {
            }
            column(Taxpension;Taxpension)
            {
            }
            column(Hse_LevyRelief;HseLevyRelief)
            {
            }

            trigger OnAfterGetRecord()
            begin

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";

                  PinNumber:=objEmp."PIN Number";

                GrossPay:=0;
                Taxpension:=0;
                PensionRelief:=0;
                InsuranceRelief:=0;
                TaxablePay:=0;
                PayeAmount:=0;
                ProvidentSelf:=0;
                Nssf:=0;
                PersonalRelief:=0;
                PensionSelf:=0;
                NHIFRelief:=0;

                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                //PeriodTrans.SETFILTER(PeriodTrans."Group Order",'=6|=7'); //Taxable Pay
                //PeriodTrans.SETFILTER(PeriodTrans."Sub Group Order",'=5|=3'); //Paye Amount
                if PeriodTrans.Find('-') then
                   repeat
                      //TXBP Taxable Pay -  BY DENNIS PSNR 690

                      if (PeriodTrans."Transaction Code"='GPAY') then
                      begin
                         GrossPay:=PeriodTrans.Amount;
                      end;

                      if (PeriodTrans."Transaction Code"='592') then
                      begin
                         ProvidentSelf:=PeriodTrans.Amount;
                      end;
                      if (PeriodTrans."Group Order" = 7) and (PeriodTrans."Sub Group Order" = 6) then
                      begin
                         Taxpension:=PeriodTrans.Amount;
                       // IF Taxpension<=0 THEN
                 //CurrReport.SKIP;
                      end;

                      if (PeriodTrans."Transaction Code"='690') then
                      begin
                         PensionSelf:=PeriodTrans.Amount;
                      end;

                      if (PeriodTrans."Transaction Code"='PSNR') then
                      begin
                         PersonalRelief:=PeriodTrans.Amount;
                      end;

                      if (PeriodTrans."Transaction Code"='NSSF') then
                      begin
                         Nssf:=PeriodTrans.Amount;
                      end;

                      if (PeriodTrans."Transaction Code"='TXBP') then
                      begin
                         TaxablePay:=PeriodTrans.Amount;
                      end;
                      if (PeriodTrans."Transaction Code"='INSR') then
                      begin
                         InsuranceRelief:=PeriodTrans.Amount;
                      end;
                      if (PeriodTrans."Transaction Code"='PNSR') then
                      begin
                         PensionRelief:=PeriodTrans.Amount;
                      end;
                      if (PeriodTrans."Transaction Code"='NHIFINSR') then
                      begin
                         NHIFRelief:=PeriodTrans.Amount;
                      end;
                      if (PeriodTrans."Transaction Code"='SHIFINSR') then
                      begin
                         NHIFRelief:=PeriodTrans.Amount;
                      end;
                       if (PeriodTrans."Transaction Code"='903') then
                      begin
                         HseLevyRelief:=PeriodTrans.Amount;
                      end;

                      //GrpOrder 7, SubGrpOrder 3 = Taxable Pay
                      //IF (PeriodTrans."Group Order"=7) AND (PeriodTrans."Sub Group Order"=3) THEN
                      if (PeriodTrans."Transaction Code"='PAYE') then
                      begin
                          PayeAmount:=PeriodTrans.Amount;
                      end;
                   until PeriodTrans.Next=0;

                 if PayeAmount<=0 then
                   CurrReport.Skip;
                 PayeAmount:=PayeAmount+Taxpension;
                 TotTaxablePay:=TotTaxablePay+TaxablePay;
                 TotPayeAmount:=TotPayeAmount+PayeAmount;
                 TotPensionRelief:=TotPensionRelief+PensionRelief;
                 TotPersonalRelief:=TotPersonalRelief+PersonalRelief;
                 TotInsuranceRelief :=TotInsuranceRelief+InsuranceRelief;
            end;

            trigger OnPreDataItem()
            begin

                  "PRL-Salary Card".Reset;
                "PRL-Salary Card".SetFilter("PRL-Salary Card"."Payroll Period",'=%1',PeriodFilter);
                if "PRL-Salary Card".Find('-') then begin
                  end;
                SelectedPeriod:=PeriodFilter;
                objPeriod.Reset;
                if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(periodfilter;PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    TableRelation = "PRL-Payroll Periods"."Date Opened";
                }
            }
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
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod.Closed,false);
        if objPeriod.Find('-') then;
        PeriodFilter:=objPeriod."Date Opened";
        if companyinfo.Get() then
        companyinfo.CalcFields(companyinfo.Picture);

          "PRL-Salary Card".Reset;
        "PRL-Salary Card".SetRange("PRL-Salary Card"."Payroll Period",PeriodFilter);
        if "PRL-Salary Card".Find('-') then begin
          end;
    end;

    trigger OnPreReport()
    begin
        //

        if PeriodFilter=0D then
          Error('You must specify the period filter');
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        PayeAmount: Decimal;
        TotPayeAmount: Decimal;
        TaxablePay: Decimal;
        TotTaxablePay: Decimal;
        EmployeeName: Text[150];
        PinNumber: Text[30];
        objPeriod: Record UnknownRecord61081;
        objEmp: Record UnknownRecord61118;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Date;
        companyinfo: Record "Company Information";
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        P_A_Y_E_ScheduleCaptionLbl: label 'P.A.Y.E Schedule';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        No_CaptionLbl: label 'No:';
        Employee_NameCaptionLbl: label 'Employee Name';
        PIN_Number_CaptionLbl: label 'PIN Number:';
        Paye_Amount_CaptionLbl: label 'Paye Amount:';
        Taxable_Pay_CaptionLbl: label 'Taxable Pay:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Totals_CaptionLbl: label 'Totals:';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        GrossPay: Decimal;
        PensionRelief: Decimal;
        InsuranceRelief: Decimal;
        TotPensionRelief: Decimal;
        TotInsuranceRelief: Decimal;
        PensionSelf: Decimal;
        ProvidentSelf: Decimal;
        Nssf: Decimal;
        PersonalRelief: Decimal;
        TotPersonalRelief: Decimal;
        NHIFRelief: Decimal;
        Taxpension: Decimal;
        HseLevyRelief: Decimal;
}

