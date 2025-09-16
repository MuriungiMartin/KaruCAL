#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51097 "prNSSF 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prNSSF 2.rdlc';

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
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(PeriodName_Control1102756011;PeriodName)
            {
            }
            column(TotalAmount;TotalAmount)
            {
            }
            column(Volume_Amount_;"Volume Amount")
            {
            }
            column(IDNumber;IDNumber)
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(prSalary_Card__prSalary_Card___Employee_Code_;"PRL-Salary Card"."Employee Code")
            {
            }
            column(NssfAmount_2;NssfAmount/2)
            {
            }
            column(NssfNo;NssfNo)
            {
            }
            column(NssfAmount_2_Control1102756008;NssfAmount/2)
            {
            }
            column(TotNssfAmount_2;TotNssfAmount/2)
            {
            }
            column(totTotalAmount;totTotalAmount)
            {
            }
            column(TotVolume_Amount_;"TotVolume Amount")
            {
            }
            column(TotNssfAmount_2_Control1102756015;TotNssfAmount/2)
            {
            }
            column(NATIONAL_SOCIAL_SECURITY_FUNDCaption;NATIONAL_SOCIAL_SECURITY_FUNDCaptionLbl)
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
            column(PERIOD_Caption_Control1102755031;PERIOD_Caption_Control1102755031Lbl)
            {
            }
            column(EMPLOYER_NO_Caption;EMPLOYER_NO_CaptionLbl)
            {
            }
            column(EMPLOYER_NAME_Caption;EMPLOYER_NAME_CaptionLbl)
            {
            }
            column(Payroll_No_Caption;Payroll_No_CaptionLbl)
            {
            }
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(NSSF_No_Caption;NSSF_No_CaptionLbl)
            {
            }
            column(ID_Number_Caption;ID_Number_CaptionLbl)
            {
            }
            column(Vol_AmountCaption;Vol_AmountCaptionLbl)
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
            {
            }
            column(Employee_AmountCaption;Employee_AmountCaptionLbl)
            {
            }
            column(Employer_AmountCaption;Employer_AmountCaptionLbl)
            {
            }
            column(Total_Amounts_Caption;Total_Amounts_CaptionLbl)
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

            trigger OnAfterGetRecord()
            begin

                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then;
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name"+' '+objEmp."Last Name";
                  NssfNo:=objEmp."NSSF No.";
                  IDNumber:=objEmp."ID Number";

                //Volume Amount****************************************************************************
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Transaction Code",Format(427));  Nssf Code
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");

                "Volume Amount":=0;
                if PeriodTrans.Find('-') then
                   begin
                      "Volume Amount":=PeriodTrans.Amount;
                   end;

                "TotVolume Amount":="TotVolume Amount"+"Volume Amount";


                //Standard Amount**************************************************************************
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Group Order",'=7');
                PeriodTrans.SetFilter(PeriodTrans."Sub Group Order",'=1');
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");

                NssfAmount:=0;
                if PeriodTrans.Find('-') then
                   begin
                      NssfAmount:=PeriodTrans.Amount+PeriodTrans.Amount;
                   end;

                //Total Amount=NssfAmount+Volume Amount**************************************************
                TotalAmount:=NssfAmount+"Volume Amount";


                //Summation Total Amount=****************************************************************
                totTotalAmount:=totTotalAmount+TotalAmount;

                if NssfAmount<=0 then
                  CurrReport.Skip;
                  TotNssfAmount:=TotNssfAmount+NssfAmount;
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


        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        NssfAmount: Decimal;
        TotNssfAmount: Decimal;
        objEmp: Record UnknownRecord61118;
        EmployeeName: Text[100];
        NssfNo: Text[30];
        IDNumber: Text[30];
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        "Volume Amount": Decimal;
        "TotVolume Amount": Decimal;
        TotalAmount: Decimal;
        totTotalAmount: Decimal;
        CompanyInfo: Record "Company Information";
        NATIONAL_SOCIAL_SECURITY_FUNDCaptionLbl: label 'NATIONAL SOCIAL SECURITY FUND';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        PERIOD_Caption_Control1102755031Lbl: label 'PERIOD:';
        EMPLOYER_NO_CaptionLbl: label 'EMPLOYER NO:';
        EMPLOYER_NAME_CaptionLbl: label 'EMPLOYER NAME:';
        Payroll_No_CaptionLbl: label 'Payroll No:';
        Employee_NameCaptionLbl: label 'Employee Name';
        NSSF_No_CaptionLbl: label 'NSSF No:';
        ID_Number_CaptionLbl: label 'ID Number:';
        Vol_AmountCaptionLbl: label 'Vol Amount';
        Total_AmountCaptionLbl: label 'Total Amount';
        Employee_AmountCaptionLbl: label 'Employee Amount';
        Employer_AmountCaptionLbl: label 'Employer Amount';
        Total_Amounts_CaptionLbl: label 'Total Amounts:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

