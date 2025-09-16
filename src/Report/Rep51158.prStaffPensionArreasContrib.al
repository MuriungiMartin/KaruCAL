#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51158 "prStaff Pension Arreas Contrib"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prStaff Pension Arreas Contrib.rdlc';

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
            column(CompanyContrib;CompanyContrib)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(CummContrib;CummContrib)
            {
            }
            column(TotCompanyContrib;TotCompanyContrib)
            {
            }
            column(TotSelfContrib;TotSelfContrib)
            {
            }
            column(TotBasicPay;TotBasicPay)
            {
            }
            column(TotCummContrib;TotCummContrib)
            {
            }
            column(Employee_Employer_Pension_Arreas_ContributionCaption;Employee_Employer_Pension_Arreas_ContributionCaptionLbl)
            {
            }
            column(Self_Contribution_Caption;Self_Contribution_CaptionLbl)
            {
            }
            column(Company_Contrib_Caption;Company_Contrib_CaptionLbl)
            {
            }
            column(Cumm_Contribution_Caption;Cumm_Contribution_CaptionLbl)
            {
            }
            column(Basic_Pay_Caption;Basic_Pay_CaptionLbl)
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
                EmpVol:=0;
                SelfContrib:=0;
                CompanyContrib:=0;
                SelfContribARREARS:=0;
                CompanyContribARREARS:=0;
                
                //Get the Basic pay Arreas
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                //PeriodTrans.SETRANGE(PeriodTrans."Transaction Name",'PENSION');
                //PeriodTrans.SETRANGE(PeriodTrans."Company Deduction",FALSE);  //BKK
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'690');
                
                BasicPay:=0;
                if PeriodTrans.Find('-') then
                    begin
                       BasicPay:=PeriodTrans.Amount;
                    end;
                
                //E-010
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                //PeriodTrans.SETRANGE(PeriodTrans."Transaction Name",'PENSION');
                //PeriodTrans.SETRANGE(PeriodTrans."Company Deduction",FALSE);  //dennis
                PeriodTrans.SetRange(PeriodTrans."Transaction Code",'690');
                
                if PeriodTrans.Find('-') then
                    begin
                       SelfContrib:=PeriodTrans.Amount;
                    end;
                /*
                //SelfContrib:=SelfContrib+SelfContribARREARS;
                EmpVol:=0;
                prEmpTrans.RESET;
                prEmpTrans.SETRANGE(prEmpTrans."Employee Code","Employee Code");
                PeriodTrans.SETRANGE(PeriodTrans."Payroll Period",SelectedPeriod);
                prEmpTrans.SETRANGE(prEmpTrans."Transaction Code",'D-051');
                IF prEmpTrans.FIND('-') THEN BEGIN
                 EmpVol:=prEmpTrans.Amount;
                 END;
                */
                if ( SelfContrib=0) and ( EmpVol=0) then
                CurrReport.Skip
                else
                EmpCount:=EmpCount+1;
                
                
                CompanyContrib:=SelfContrib*2;
                //SelfContrib:=BasicPay*0.1;
                CummContrib:= SelfContrib+CompanyContrib+EmpVol;
                
                 //CompanyContrib:=ROUND(BasicPay*0.155,0.05);
                 TotVolContrib:=TotVolContrib+EmpVol;
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
        EmployeeName: Text[50];
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
        EmpVol: Decimal;
        TotVolContrib: Decimal;
        prEmpTrans: Record UnknownRecord61091;
        EmpCount: Integer;
        Employee_Employer_Pension_Arreas_ContributionCaptionLbl: label 'Employee/Employer Pension Arreas Contribution';
        Self_Contribution_CaptionLbl: label 'Self Contribution:';
        Company_Contrib_CaptionLbl: label 'Company Contrib:';
        Cumm_Contribution_CaptionLbl: label 'Cumm Contribution:';
        Basic_Pay_CaptionLbl: label 'Basic Pay:';
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

