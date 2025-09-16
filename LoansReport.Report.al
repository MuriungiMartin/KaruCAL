#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51106 "Loans Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loans Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61082;UnknownTable61082)
        {
            DataItemTableView = sorting("Transaction Code") order(ascending) where("IsCoop/LnRep"=const(Yes));
            column(ReportForNavId_6955; 6955)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(PeriodName;PeriodName)
            {
            }
            column(TODAY;Today)
            {
            }
            column(USERID;UserId)
            {
            }
            column(GrandTotal;GrandTotal)
            {
            }
            column(GrandBalance;GrandBalance)
            {
            }
            column(GrandTotInt;GrandTotInt)
            {
            }
            column(Loans_ReportCaption;Loans_ReportCaptionLbl)
            {
            }
            column(Page_No_Caption;Page_No_CaptionLbl)
            {
            }
            column(Period_Caption;Period_CaptionLbl)
            {
            }
            column(Print_Date_Caption;Print_Date_CaptionLbl)
            {
            }
            column(User_Name_Caption;User_Name_CaptionLbl)
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
            column(Grand_Total_Caption;Grand_Total_CaptionLbl)
            {
            }
            column(prTransaction_Codes_Transaction_Code;"Transaction Code")
            {
            }
            dataitem(UnknownTable61092;UnknownTable61092)
            {
                DataItemLink = "Transaction Code"=field("Transaction Code");
                DataItemTableView = sorting("Group Order","Transaction Code","Period Month","Period Year");
                RequestFilterFields = "Payroll Period","Transaction Code";
                column(ReportForNavId_7769; 7769)
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
                column(prPeriod_Transactions_Balance;Balance)
                {
                }
                column(Employee_Code_______strEmpName;"Employee Code"+': '+strEmpName)
                {
                }
                column(Interest;Interest)
                {
                }
                column(prPeriod_Transactions_Amount_Control1102755038;Amount)
                {
                }
                column(prPeriod_Transactions_Balance_Control1102755039;Balance)
                {
                }
                column(prPeriod_Transactions__Transaction_Name__Control1102755016;"Transaction Name")
                {
                }
                column(SubTotInt;SubTotInt)
                {
                }
                column(Transaction_Name_Caption;Transaction_Name_CaptionLbl)
                {
                }
                column(Period_Amount_Caption;Period_Amount_CaptionLbl)
                {
                }
                column(Balance_Caption;Balance_CaptionLbl)
                {
                }
                column(EmployeeCaption;EmployeeCaptionLbl)
                {
                }
                column(Interest_Caption;Interest_CaptionLbl)
                {
                }
                column(SubtotalsCaption;SubtotalsCaptionLbl)
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

                    Interest:=0;
                    prPeriodTrans.Reset;
                    prPeriodTrans.SetRange(prPeriodTrans."Employee Code","PRL-Period Transactions"."Employee Code");
                    prPeriodTrans.SetRange(prPeriodTrans."Transaction Code","PRL-Period Transactions"."Transaction Code"+'-INT');
                    prPeriodTrans.SetRange(prPeriodTrans."Payroll Period","PRL-Period Transactions"."Payroll Period");
                    if  prPeriodTrans.Find('-') then begin
                    Interest:=prPeriodTrans.Amount;
                    SubTotInt:=SubTotInt+prPeriodTrans.Amount;
                    GrandTotInt:=GrandTotInt+prPeriodTrans.Amount;
                    end;
                    GrandTotal:=GrandTotal+Amount;
                    GrandBalance:=GrandBalance+Balance;
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Period Year");
                    Interest:=0;
                    SubTotInt:=0;
                end;
            }
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
        GrandTotal: Decimal;
        strEmpName: Text[100];
        objEmp: Record UnknownRecord61118;
        GrandBalance: Decimal;
        CompanyInfo: Record "Company Information";
        Interest: Decimal;
        SubTotInt: Decimal;
        GrandTotInt: Decimal;
        prPeriodTrans: Record UnknownRecord61092;
        Loans_ReportCaptionLbl: label 'Loans Report';
        Page_No_CaptionLbl: label 'Page No:';
        Period_CaptionLbl: label 'Period:';
        Print_Date_CaptionLbl: label 'Print Date:';
        User_Name_CaptionLbl: label 'User Name:';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Grand_Total_CaptionLbl: label 'Grand Total:';
        Transaction_Name_CaptionLbl: label 'Transaction Name:';
        Period_Amount_CaptionLbl: label 'Period Amount:';
        Balance_CaptionLbl: label 'Balance:';
        EmployeeCaptionLbl: label 'Employee';
        Interest_CaptionLbl: label 'Interest:';
        SubtotalsCaptionLbl: label 'Subtotals';
}

