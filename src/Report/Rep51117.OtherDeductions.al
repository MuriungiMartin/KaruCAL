#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51117 "Other Deductions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Other Deductions.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting(Membership) where(Membership=filter(<>""));
            RequestFilterFields = Membership,"Payroll Period";
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
            column(prPeriod_Transactions_Membership;Membership)
            {
            }
            column(Employee_Code_______Names;"Employee Code"+': '+Names)
            {
            }
            column(prPeriod_Transactions__Reference_No_;"Reference No")
            {
            }
            column(Transaction_Code________Transaction_Name_;"Transaction Code"+': '+"Transaction Name")
            {
            }
            column(prPeriod_Transactions_Amount;Amount)
            {
            }
            column(TOTAL_;'TOTAL')
            {
            }
            column(prPeriod_Transactions_Amount_Control1102756026;Amount)
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
            column(Other_DeductionsCaption;Other_DeductionsCaptionLbl)
            {
            }
            column(Employee_DetailsCaption;Employee_DetailsCaptionLbl)
            {
            }
            column(Membership_NoCaption;Membership_NoCaptionLbl)
            {
            }
            column(Transaction_DetailsCaption;Transaction_DetailsCaptionLbl)
            {
            }
            column(prPeriod_Transactions_AmountCaption;FieldCaption(Amount))
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

            trigger OnAfterGetRecord()
            begin
                  //IF "prPeriod Transactions".Membership='' THEN
                    // CurrReport.SKIP;
                  Names:='';
                  if HrEmp.Get("PRL-Period Transactions"."Employee Code") then
                    Names:=HrEmp."First Name"+' '+HrEmp."Middle Name"+' '+HrEmp."Last Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Membership);
                if CompanyInfo.Get() then
                CompanyInfo.CalcFields(CompanyInfo.Picture);
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

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        HrEmp: Record UnknownRecord61118;
        Names: Text[100];
        CompanyInfo: Record "Company Information";
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Page_No_CaptionLbl: label 'Page No:';
        Other_DeductionsCaptionLbl: label 'Other Deductions';
        Employee_DetailsCaptionLbl: label 'Employee Details';
        Membership_NoCaptionLbl: label 'Membership No';
        Transaction_DetailsCaptionLbl: label 'Transaction Details';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

