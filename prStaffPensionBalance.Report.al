#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51130 "prStaff Pension Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prStaff Pension Balance.rdlc';

    dataset
    {
        dataitem(UnknownTable61105;UnknownTable61105)
        {
            RequestFilterFields = "Period Filter","Employee Code";
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
            column(Companyinfo_Picture;Companyinfo.Picture)
            {
            }
            column(prSalary_Card__prSalary_Card___Employee_Code_;"PRL-Salary Card"."Employee Code")
            {
            }
            column(SelfContrib;SelfContrib)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(TotSelfContrib;TotSelfContrib)
            {
            }
            column(Pension_BalancesCaption;Pension_BalancesCaptionLbl)
            {
            }
            column(Self_Contribution_Caption;Self_Contribution_CaptionLbl)
            {
            }
            column(User_Name_Caption;User_Name_CaptionLbl)
            {
            }
            column(Print_Date_Caption;Print_Date_CaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(Page_No_Caption;Page_No_CaptionLbl)
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
            column(Totals_Caption;Totals_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";

                SelfContrib:=0;
                CompanyContrib:=0;
                SelfContribARREARS:=0;
                CompanyContribARREARS:=0;

                //Get the Basic pay
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetRange(PeriodTrans."Group Order",1);
                PeriodTrans.SetRange(PeriodTrans."Sub Group Order",1);
                if PeriodTrans.Find('-') then
                    begin
                       BasicPay:=PeriodTrans.Amount;
                    end;


                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                //PeriodTrans.SETRANGE(PeriodTrans."Transaction Name",'PENSION');
                PeriodTrans.SetRange(PeriodTrans."Company Deduction",false);  //dennis
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",SelfContribCode);

                if PeriodTrans.Find('-') then
                    begin
                       SelfContrib:=PeriodTrans.Balance;
                    end;

                SelfContrib:=SelfContrib+SelfContribARREARS;


                prEmployerContrib.Reset;
                prEmployerContrib.SetRange(prEmployerContrib."Employee Code","Employee Code");
                prEmployerContrib.SetRange(prEmployerContrib."Payroll Period",SelectedPeriod);
                prEmployerContrib.SetRange(prEmployerContrib."Transaction Code",SelfContribCode);

                if prEmployerContrib.Find('-') then
                    begin
                       CompanyContrib:=prEmployerContrib.Amount;
                    end;


                CompanyContrib:=CompanyContrib+CompanyContribARREARS;

                CummContrib:= SelfContrib+CompanyContrib;

                if (SelfContrib<=0) and (CompanyContrib<=0) then
                 CurrReport.Skip;
                 TotBasicPay:=TotBasicPay+BasicPay;
                 TotSelfContrib:=TotSelfContrib+SelfContrib;
                 TotCompanyContrib:=TotCompanyContrib+CompanyContrib;
                 TotCummContrib:=TotCummContrib+CummContrib;
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

        //self contribution...Defined contribution is a Special Transaction 1
        objTransCode.Reset;
        //objTransCode.SETRANGE(objTransCode."Special Transactions",1); //Defined contribution/pension
        //objTransCode.SETRANGE(objTransCode."Employer Deduction",FALSE);
        objTransCode.SetRange(objTransCode."Transaction Code",'0007'); //HARD CODED TO ENSURE THE self pension is calx - Dennis
        if objTransCode.Find('-') then
           begin
               SelfContribCode:=objTransCode."Transaction Code";
           end;

        //self contribution...Defined contribution is a Special Transaction 1 PENSION ARREARS
        objTransCode.Reset;
        //objTransCode.SETRANGE(objTransCode."Special Transactions",1); //Defined contribution/pension
        //objTransCode.SETRANGE(objTransCode."Employer Deduction",FALSE);
        objTransCode.SetRange(objTransCode."Transaction Code",'114'); //HARD CODED TO ENSURE THE self pension is calx - Dennis
        if objTransCode.Find('-') then
           begin
               SelfContribCodeArrears:=objTransCode."Transaction Code";
           end;


        //Company contribution
        objTransCode.Reset;
        //objTransCode.SETRANGE(objTransCode."Special Transactions",1);
        //objTransCode.SETRANGE(objTransCode."Employer Deduction",TRUE);
        objTransCode.SetRange(objTransCode."Transaction Code",'Emp-455'); //HARD CODED TO ENSURE THE self pension is calx - Dennis
        if objTransCode.Find('-') then
           begin
              // CompanyContribCode:=objTransCode."Transaction Code";
           end;
        CompanyContribCode:='Emp-455';


        //Company contribution ARREARS
        objTransCode.Reset;
        //objTransCode.SETRANGE(objTransCode."Special Transactions",1);
        //objTransCode.SETRANGE(objTransCode."Employer Deduction",TRUE);
        objTransCode.SetRange(objTransCode."Transaction Code",'Emp-114'); //HARD CODED TO ENSURE THE self pension is calx - Dennis
        if objTransCode.Find('-') then
           begin
              // CompanyContribCode:=objTransCode."Transaction Code";
           end;
        CompanyContribCodeArrears:='Emp-114';


        if Companyinfo.Get() then
        Companyinfo.CalcFields(Companyinfo.Picture);
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        BasicPay: Decimal;
        SelfContrib: Decimal;
        CompanyContrib: Decimal;
        CummContrib: Decimal;
        TotBasicPay: Decimal;
        TotSelfContrib: Decimal;
        TotCompanyContrib: Decimal;
        TotCummContrib: Decimal;
        EmployeeName: Text[30];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodFilter: Text[30];
        PeriodName: Text[30];
        SelfContribCode: Text[30];
        CompanyContribCode: Text[30];
        objTransCode: Record UnknownRecord61082;
        SelfContribCodeArrears: Text[30];
        CompanyContribCodeArrears: Text[30];
        SelfContribARREARS: Decimal;
        CompanyContribARREARS: Decimal;
        prEmployerContrib: Record UnknownRecord61094;
        Companyinfo: Record "Company Information";
        Pension_BalancesCaptionLbl: label 'Pension Balances';
        Self_Contribution_CaptionLbl: label 'Self Contribution:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Totals_CaptionLbl: label 'Totals:';
}

