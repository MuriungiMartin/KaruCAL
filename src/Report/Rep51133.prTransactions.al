#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51133 "pr Transactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/pr Transactions.rdlc';

    dataset
    {
        dataitem(UnknownTable61091;UnknownTable61091)
        {
            DataItemTableView = sorting("Employee Code","Transaction Code","Period Month","Period Year","Payroll Period","Reference No") where("Emp Status"=const(Normal),Amount=filter(<>0));
            RequestFilterFields = "Employee Code","Transaction Code","Period Year","Period Month";
            column(ReportForNavId_5642; 5642)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(prEmployee_Transactions__Transaction_Code_;"Transaction Code")
            {
            }
            column(prEmployee_Transactions__Transaction_Name_;"Transaction Name")
            {
            }
            column(pic;companyinfo.Picture)
            {
            }
            column(prEmployee_Transactions__Employee_Code_;"Employee Code")
            {
            }
            column(Emp__First_Name______Emp__Middle_Name______Emp__Last_Name_;Emp."First Name"+' '+Emp."Middle Name"+' '+Emp."Last Name")
            {
            }
            column(prEmployee_Transactions_Amount;Amount)
            {
            }
            column(prEmployee_Transactions_Amount_Control1102755000;Amount)
            {
            }
            column(Transactions_DetailsCaption;Transactions_DetailsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_No_Caption;Employee_No_CaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(prEmployee_Transactions_AmountCaption;FieldCaption(Amount))
            {
            }
            column(prEmployee_Transactions_Amount_Control1102755000Caption;FieldCaption(Amount))
            {
            }
            column(prEmployee_Transactions_Period_Month;"Period Month")
            {
            }
            column(prEmployee_Transactions_Period_Year;"Period Year")
            {
            }
            column(prEmployee_Transactions_Payroll_Period;"Payroll Period")
            {
            }
            column(prEmployee_Transactions_Reference_No;"Reference No")
            {
            }
            column(filters;"PRL-Employee Transactions".GetFilters)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  if not Emp.Get("PRL-Employee Transactions"."Employee Code") then
;
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
         if companyinfo.Get() then begin
         companyinfo.CalcFields(companyinfo.Picture);
         end
    end;

    var
        Emp: Record UnknownRecord61118;
        Transactions_DetailsCaptionLbl: label 'Transactions Details';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_No_CaptionLbl: label 'Employee No.';
        NamesCaptionLbl: label 'Names';
        companyinfo: Record "Company Information";
}

