#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51127 "Payment History"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payment History.rdlc';

    dataset
    {
        dataitem(UnknownTable61118;UnknownTable61118)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_8631; 8631)
            {
            }
            column(HR_Employee_No_;"No.")
            {
            }
            dataitem(UnknownTable61092;UnknownTable61092)
            {
                DataItemLink = "Employee Code"=field("No.");
                DataItemTableView = sorting("Employee Code","Transaction Code","Period Month","Period Year",Membership,"Reference No");
                column(ReportForNavId_7769; 7769)
                {
                }
                column(CompanyInfo_Picture;CompanyInfo.Picture)
                {
                }
                column(USERID;UserId)
                {
                }
                column(TODAY;Today)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(prPeriod_Transactions__Employee_Code_;"Employee Code")
                {
                }
                column(Names;Names)
                {
                }
                column(prPeriod_Transactions_Amount;Amount)
                {
                }
                column(prPeriod_Transactions__Transaction_Code_;"Transaction Code")
                {
                }
                column(prPeriod_Transactions__Transaction_Name_;"Transaction Name")
                {
                }
                column(prPeriod_Transactions_Amount_Control1102756030;Amount)
                {
                }
                column(User_Name_Caption;User_Name_CaptionLbl)
                {
                }
                column(Print_Date_Caption;Print_Date_CaptionLbl)
                {
                }
                column(Page_No_Caption;Page_No_CaptionLbl)
                {
                }
                column(Payment_History_Average_EarningsCaption;Payment_History_Average_EarningsCaptionLbl)
                {
                }
                column(AmountCaption;AmountCaptionLbl)
                {
                }
                column(prPeriod_Transactions__Transaction_Name_Caption;FieldCaption("Transaction Name"))
                {
                }
                column(prPeriod_Transactions__Transaction_Code_Caption;FieldCaption("Transaction Code"))
                {
                }
                column(TOTALSCaption;TOTALSCaptionLbl)
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

                trigger OnAfterGetRecord()
                begin
                        if "PRL-Period Transactions"."Group Order"<>3 then
                            CurrReport.Skip;
                        /*IF ("prPeriod Transactions"."Group Order"=8) AND ("prPeriod Transactions"."Sub Group Order" =9) THEN
                                 CurrReport.SKIP;
                        IF "prPeriod Transactions"."Group Order"=6  THEN
                                 CurrReport.SKIP;
                    
                        IF ("prPeriod Transactions"."Group Order"=4)  THEN
                                 CurrReport.SKIP;  */

                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Transaction Code");
                    if CompanyInfo.Get() then
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        CompanyInfo: Record "Company Information";
        HrEmp: Record UnknownRecord61118;
        Names: Text[250];
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Page_No_CaptionLbl: label 'Page No:';
        Payment_History_Average_EarningsCaptionLbl: label 'Payment History/Average Earnings';
        AmountCaptionLbl: label 'Amount';
        TOTALSCaptionLbl: label 'TOTALS';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

