#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51039 "prAllowances details Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/prAllowances details Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Group Order","Transaction Code","Period Month","Period Year") order(ascending);
            RequestFilterFields = "Transaction Code";
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
            column(prPeriod_Transactions__prPeriod_Transactions___Transaction_Name_;"PRL-Period Transactions"."Transaction Name")
            {
            }
            column(prPeriod_Transactions__Transaction_Name_;"Transaction Name")
            {
            }
            column(prPeriod_Transactions_Amount;Amount)
            {
            }
            column(prPeriod_Transactions__Employee_Code_;"Employee Code")
            {
            }
            column(strEmpName;strEmpName)
            {
            }
            column(prPeriod_Transactions__prPeriod_Transactions__Membership;"PRL-Period Transactions".Membership)
            {
            }
            column(prPeriod_Transactions_Amount_Control1102755038;Amount)
            {
            }
            column(prPeriod_Transactions__Transaction_Name__Control1102755016;"Transaction Name")
            {
            }
            column(GrandTotal;GrandTotal)
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
            column(Period_Amount_Caption22;Period_Amount_22)
            {
            }
            column(Employee_No_Caption;Employee_No_CaptionLbl)
            {
            }
            column(Employee_Name_Caption;Employee_Name_CaptionLbl)
            {
            }
            column(SubtotalsCaption;SubtotalsCaptionLbl)
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
            column(Grand_Total_Caption;Grand_Total_CaptionLbl)
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
            column(prPeriod_Transactions_Reference_No;"Reference No")
            {
            }
            column(prPeriod_Transactions_Group_Order;"Group Order")
            {
            }
            column(prPeriod_Transactions_Payroll_Period;"Payroll Period")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //Get the staff details (header)
                objEmp.SetRange(objEmp."No.","Employee Code");
                if objEmp.Find('-') then
                begin
                   strEmpName:=objEmp."Last Name"+' '+objEmp."First Name"+' '+objEmp."Middle Name";
                end;

                "PRL-Period Transactions".SetRange("Payroll Period",SelectedPeriod);
                "PRL-Period Transactions".SetRange("Payroll Period",Periods);
                "PRL-Period Transactions".SetFilter("Group Order",'=3');

                if (Amount<=0) or ("PRL-Period Transactions"."Group Order"=1) then
                begin
                 GrandTotal:=GrandTotal+0;
                 CurrReport.Skip;
                end;

                GrandTotal:=GrandTotal+Amount;
                GrandBalance:=GrandBalance+Balance;
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
            area(content)
            {
                field(Periods;Periods)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period';
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

    trigger OnPreReport()
    begin
        //SelectedPeriod:="prPeriod Transactions".GETRANGEMIN("Payroll Period");
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
        GrandTotal: Decimal;
        strEmpName: Text[100];
        objEmp: Record UnknownRecord61118;
        GrandBalance: Decimal;
        CompanyInfo: Record "Company Information";
        Allowances_ReportCaptionLbl: label 'Allowances Report';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Transaction_Name_CaptionLbl: label 'Transaction Name:';
        Period_Amount_22: label 'Period Amount:';
        Employee_No_CaptionLbl: label 'Employee No.';
        Employee_Name_CaptionLbl: label 'Employee Name:';
        SubtotalsCaptionLbl: label 'Subtotals';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Grand_Total_CaptionLbl: label 'Grand Total:';
        Periods: Date;
}

