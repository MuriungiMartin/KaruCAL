#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5212 "Employee - Contracts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Contracts.rdlc';
    Caption = 'Employee - Contracts';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Employment Contract";"Employment Contract")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_9751; 9751)
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
            column(Employment_Contract__TABLECAPTION__________EmploymentContractFilter;TableCaption + ': ' + EmploymentContractFilter)
            {
            }
            column(EmploymentContractFilter;EmploymentContractFilter)
            {
            }
            column(Employment_Contract_Code;Code)
            {
            }
            column(Employment_Contract_Description;Description)
            {
            }
            column(Employee___ContractsCaption;Employee___ContractsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Full_NameCaption;Full_NameCaptionLbl)
            {
            }
            column(Employee__No__Caption;o.FieldCaption("No."))
            {
            }
            dataitem(Employee;Employee)
            {
                DataItemLink = "Emplymt. Contract Code"=field(Code);
                DataItemTableView = sorting(Status,"Emplymt. Contract Code");
                column(ReportForNavId_7528; 7528)
                {
                }
                column(Employee__No__;"No.")
                {
                }
                column(FullName;FullName)
                {
                }
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
        EmploymentContractFilter := "Employment Contract".GetFilters;
    end;

    var
        EmploymentContractFilter: Text;
        Employee___ContractsCaptionLbl: label 'Employee - Contracts';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Full_NameCaptionLbl: label 'Full Name';
}

