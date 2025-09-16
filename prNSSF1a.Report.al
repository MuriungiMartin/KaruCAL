#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51857 "prNSSF 1a"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prNSSF 1a.rdlc';

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
            column(Gpay;Gpay)
            {
            }
            column(Pins;objEmp."PIN Number")
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
            column(PIN;objEmp."PAYE Number")
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
            column(LastName;LastName)
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
            column(Voluntarynssf;voluntarynssf)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Gpay);
                objEmp.Reset;
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then;
                  EmployeeName:=objEmp."First Name"+' '+objEmp."Middle Name";
                  LastName:=objEmp."Last Name";
                  NssfNo:=objEmp."NSSF No.";
                  IDNumber:=objEmp."ID Number";

                //Volume Amount****************************************************************************
                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Transaction Code",'621');  Nssf Volu Code
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");

                "Volume Amount":=0;
                voluntarynssf:=0;
                if PeriodTrans.Find('-') then
                   begin
                      voluntarynssf:=PeriodTrans.Amount;
                   end;

                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Transaction Code",'GPAY');  Nssf Volu Code
                if PeriodTrans.Find('-') then
                   begin
                      Gpay:=PeriodTrans.Amount;
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
                     repeat
                      NssfAmount+= PeriodTrans.Amount+PeriodTrans.Amount;;
                      until PeriodTrans.Next=0;
                   end;

                //Total Amount=NssfAmount+Volume Amount**************************************************
                TotalAmount:=NssfAmount+"Volume Amount";



                //Summation Total Amount=****************************************************************
                totTotalAmount:=totTotalAmount+TotalAmount;

                if (NssfAmount<=0) and (voluntarynssf<=0) then
                  CurrReport.Skip;
                  TotNssfAmount:=TotNssfAmount+NssfAmount;
            end;

            trigger OnPreDataItem()
            begin
                "PRL-Salary Card".SetFilter("PRL-Salary Card"."Payroll Period",'%1',PeriodFilter);
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


        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    trigger OnPreReport()
    begin
        //PeriodFilter:="prSalary Card".GETFILTER("Period Filter");
        if PeriodFilter=0D then Error('You must specify the period filter');

        SelectedPeriod:=PeriodFilter;
        objPeriod.Reset;
        if objPeriod.Get(SelectedPeriod) then PeriodName:=objPeriod."Period Name";
    end;

    var
        PeriodTrans: Record UnknownRecord61092;
        NssfAmount: Decimal;
        TotNssfAmount: Decimal;
        objEmp: Record UnknownRecord61118;
        EmployeeName: Text[150];
        NssfNo: Text[30];
        IDNumber: Text[30];
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Date;
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
        voluntarynssf: Decimal;
        Gpay: Decimal;
        LastName: Text[50];
}

