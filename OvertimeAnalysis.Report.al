#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51128 "Overtime Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Overtime Analysis.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            DataItemTableView = sorting("Employee Code","Department Code");
            RequestFilterFields = "Employee Code","Department Code","Payroll Period";
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
            column(prPeriod_Transactions__Department_Code_;"Department Code")
            {
            }
            column(prPeriod_Transactions__Employee_Code_;"Employee Code")
            {
            }
            column(prPeriod_Transactions__Transaction_Name_;"Transaction Name")
            {
            }
            column(prPeriod_Transactions_Amount;Amount)
            {
            }
            column(Names;Names)
            {
            }
            column(TOTAL_;'TOTAL')
            {
            }
            column(prPeriod_Transactions_Amount_Control1102756031;Amount)
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
            column(Overtime_AnalysisCaption;Overtime_AnalysisCaptionLbl)
            {
            }
            column(prPeriod_Transactions__Employee_Code_Caption;FieldCaption("Employee Code"))
            {
            }
            column(prPeriod_Transactions__Transaction_Name_Caption;FieldCaption("Transaction Name"))
            {
            }
            column(prPeriod_Transactions_AmountCaption;FieldCaption(Amount))
            {
            }
            column(NamesCaption;NamesCaptionLbl)
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

            trigger OnAfterGetRecord()
            begin
                Names:='';
                if HrEmp.Get("PRL-Period Transactions"."Employee Code") then
                   Names:=HrEmp."First Name"+' '+HrEmp."Middle Name"+' '+HrEmp."Last Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Department Code");
                "PRL-Period Transactions".SetRange("PRL-Period Transactions"."coop parameters","PRL-Period Transactions"."coop parameters"::Overtime);
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
        if CompanyInfo.Get() then
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CompanyInfo: Record "Company Information";
        HrEmp: Record UnknownRecord61118;
        Names: Text[100];
        User_Name_CaptionLbl: label 'User Name:';
        Print_Date_CaptionLbl: label 'Print Date:';
        Page_No_CaptionLbl: label 'Page No:';
        Overtime_AnalysisCaptionLbl: label 'Overtime Analysis';
        NamesCaptionLbl: label 'Names';
        Prepared_by_______________________________________Date_________________CaptionLbl: label 'Prepared by……………………………………………………..                 Date……………………………………………';
        Checked_by________________________________________Date_________________CaptionLbl: label 'Checked by…………………………………………………..                   Date……………………………………………';
        Authorized_by____________________________________Date_________________CaptionLbl: label 'Authorized by……………………………………………………..              Date……………………………………………';
        Approved_by______________________________________Date_________________CaptionLbl: label 'Approved by……………………………………………………..                Date……………………………………………';
}

