#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51095 "prAllowances Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prAllowances Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Group Order","Transaction Code","Period Month","Period Year",Membership,"Reference No","Department Code");
            RequestFilterFields = "Payroll Period";
            column(ReportForNavId_7769; 7769)
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
            column(prPeriod_Transactions__Group_Text_;"Group Text")
            {
            }
            column(prPeriod_Transactions_Amount;Amount)
            {
            }
            column(prPeriod_Transactions__Transaction_Name_;"Transaction Name")
            {
            }
            column(Allowances_ReportCaption;Allowances_ReportCaptionLbl)
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
            column(Transaction_Name_Caption;Transaction_Name_CaptionLbl)
            {
            }
            column(Period_Amount_Caption;Period_Amount_CaptionLbl)
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
            column(prPeriod_Transactions_Employee_Code;"Employee Code")
            {
            }
            column(prPeriod_Transactions_Transaction_Code;"Transaction Code")
            {
            }
            column(prPeriod_Transactions_Period_Month;"Period Month")
            {
            }
            column(prPeriod_Transactions_Period_Year;"Period Year")
            {
            }
            column(prPeriod_Transactions_Membership;Membership)
            {
            }
            column(prPeriod_Transactions_Reference_No;"Reference No")
            {
            }
            column(prPeriod_Transactions_Group_Order;"Group Order")
            {
            }
            column(prPeriod_Transactions_Department_Code;"Department Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "PRL-Period Transactions".SetRange("Payroll Period",SelectedPeriod);
                //"prPeriod Transactions".SETFILTER("Group Order",'=1|3');
                //"prPeriod Transactions".SETFILTER("prPeriod Transactions"."Sub Group Order",'=2');
                if Amount<=0 then
                  CurrReport.Skip;
                TotalsAllowances:=TotalsAllowances+"PRL-Period Transactions".Amount;

                PrevMonth:=0;
                PeriodTrans2.Reset;
                PeriodTrans2.SetRange(PeriodTrans2."Period Year","PRL-Period Transactions"."Period Year");
                if "PRL-Period Transactions"."Period Month"=1 then begin
                PeriodTrans2.SetRange(PeriodTrans2."Period Month",12);
                PeriodTrans2.SetRange(PeriodTrans2."Period Year","PRL-Period Transactions"."Period Year"-1);
                end else begin
                PeriodTrans2.SetRange(PeriodTrans2."Period Month","PRL-Period Transactions"."Period Month"-1);
                end;
                //PeriodTrans2.SETFILTER(PeriodTrans2."Group Order",'=7|=8');
                PeriodTrans2.SetRange(PeriodTrans2."Transaction Code","PRL-Period Transactions"."Transaction Code");
                PeriodTrans2.SetRange(PeriodTrans2."Employee Code","PRL-Period Transactions"."Employee Code");
                if PeriodTrans2.Find('-') then
                PrevMonth:=PeriodTrans2.Amount;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Period Year");
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
        SelectedPeriod:="PRL-Period Transactions".GetRangeMin("Payroll Period");
        objPeriod.Reset;
        objPeriod.SetRange(objPeriod."Date Opened",SelectedPeriod);
        if objPeriod.Find('-') then
        begin
            PeriodName:=objPeriod."Period Name";
        end;


        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        PeriodTrans: Record UnknownRecord61092;
        GroupOrder: label '3';
        objPeriod: Record UnknownRecord61081;
        SelectedPeriod: Date;
        PeriodName: Text[30];
        CompanyInfo: Record "Company Information";
        TotalsAllowances: Decimal;
        Dept: Boolean;
        PrevMonth: Decimal;
        PeriodTrans2: Record UnknownRecord61092;
        Allowances_ReportCaptionLbl: label 'Allowances Report';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Transaction_Name_CaptionLbl: label 'Transaction Name:';
        Period_Amount_CaptionLbl: label 'Period Amount:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

