#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51132 "Staff Clearance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Clearance Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Group Order","Transaction Code","Period Month","Period Year") where("coop parameters"=const(loan));
            RequestFilterFields = "Payroll Period","Employee Code";
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
            column(Employee_Code_______strEmpName_;"Employee Code"+': '+strEmpName )
            {
            }
            column(prPeriod_Transactions__Transaction_Name_;"Transaction Name")
            {
            }
            column(prPeriod_Transactions_Amount;Amount)
            {
            }
            column(prPeriod_Transactions_Balance;Balance)
            {
            }
            column(prPeriod_Transactions__prPeriod_Transactions__Membership;"PRL-Period Transactions".Membership)
            {
            }
            column(GrandTotal;GrandTotal)
            {
            }
            column(GrandBalance;GrandBalance)
            {
            }
            column(Staff_ClearanceCaption;Staff_ClearanceCaptionLbl)
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
            column(Repayment_Caption;Repayment_CaptionLbl)
            {
            }
            column(Balance_Caption;Balance_CaptionLbl)
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
            column(prPeriod_Transactions_Reference_No;"Reference No")
            {
            }
            column(prPeriod_Transactions_Group_Order;"Group Order")
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
                "PRL-Period Transactions".SetFilter("Group Order",'=7|=8');

                if (Amount<=0) or ("PRL-Period Transactions"."Transaction Code"='TOT-DED') or ("PRL-Period Transactions"."Group Order"=1) then
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
        EmpCode:="PRL-Period Transactions".GetRangeMin("Employee Code");

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
        EmpCode: Code[20];
        Staff_ClearanceCaptionLbl: label 'Staff Clearance';
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Period_CaptionLbl: label 'Period:';
        Page_No_CaptionLbl: label 'Page No:';
        Repayment_CaptionLbl: label 'Repayment:';
        Balance_CaptionLbl: label 'Balance:';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Grand_Total_CaptionLbl: label 'Grand Total:';
}

