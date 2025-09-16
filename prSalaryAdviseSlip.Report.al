#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51131 "prSalary Advise Slip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prSalary Advise Slip.rdlc';

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
            column(companyinfo_Picture;companyinfo.Picture)
            {
            }
            column(prSalary_Card__prSalary_Card___Employee_Code_;"PRL-Salary Card"."Employee Code")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(TotNetPay;TotNetPay)
            {
            }
            column(Salary_Advise_SlipCaption;Salary_Advise_SlipCaptionLbl)
            {
            }
            column(Net_Pay_Caption;Net_Pay_CaptionLbl)
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
            column(Employee_No_Caption;Employee_No_CaptionLbl)
            {
            }
            column(Names_Caption;Names_CaptionLbl)
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

                BasicPay:=0;
                GrossPay:=0;
                NetPay:=0;

                PeriodTrans.Reset;
                PeriodTrans.SetRange(PeriodTrans."Employee Code","Employee Code");
                PeriodTrans.SetRange(PeriodTrans."Payroll Period",SelectedPeriod);
                PeriodTrans.SetFilter(PeriodTrans."Group Order",'=1|=4|=9');
                PeriodTrans.SetFilter(PeriodTrans."Sub Group Order",'<=1');
                PeriodTrans.SetCurrentkey(PeriodTrans."Employee Code",PeriodTrans."Period Month",PeriodTrans."Period Year",
                PeriodTrans."Group Order",PeriodTrans."Sub Group Order");
                if PeriodTrans.Find('-') then
                    repeat
                         if PeriodTrans."Group Order"=1 then
                         begin
                            BasicPay:=PeriodTrans.Amount;
                         end;

                         if PeriodTrans."Group Order"=4 then
                         begin
                            GrossPay:=PeriodTrans.Amount; //Gross pay
                         end;

                         if PeriodTrans."Group Order"=9 then
                         begin
                            NetPay:=PeriodTrans.Amount; //Net pay
                         end;
                    until PeriodTrans.Next=0;

                if NetPay<=0 then
                 CurrReport.Skip;
                 TotBasicPay:=TotBasicPay+BasicPay;
                 TotGrossPay:=TotGrossPay+GrossPay;
                 TotNetPay:=TotNetPay+NetPay;
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
        BasicPay: Decimal;
        GrossPay: Decimal;
        NetPay: Decimal;
        TotBasicPay: Decimal;
        TotGrossPay: Decimal;
        TotNetPay: Decimal;
        EmployeeName: Text[30];
        objEmp: Record UnknownRecord61118;
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        PeriodFilter: Text[30];
        companyinfo: Record "Company Information";
        Salary_Advise_SlipCaptionLbl: label 'Salary Advise Slip';
        Net_Pay_CaptionLbl: label 'Net Pay:';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Employee_No_CaptionLbl: label 'Employee No:';
        Names_CaptionLbl: label 'Names:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Totals_CaptionLbl: label 'Totals:';
}

