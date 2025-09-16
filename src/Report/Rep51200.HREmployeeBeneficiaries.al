#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51200 "HR Employee Beneficiaries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Employee Beneficiaries.rdlc';
    Caption = 'Employee Beneficiaries';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.",Status;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_HREmployees;"HRM-Employee C"."No.")
            {
            }
            column(FullName_HREmployees;"HRM-Employee C".Names)
            {
            }
            column(Emp_FirstName;"HRM-Employee C"."First Name")
            {
            }
            column(Emp_MiddleName;"HRM-Employee C"."Middle Name")
            {
            }
            column(Emp_LastName;"HRM-Employee C"."Last Name")
            {
            }
            column(CI_Name;CI.Name)
            {
            }
            column(CI_Picture;CI.Picture)
            {
            }
            dataitem(UnknownTable61324;UnknownTable61324)
            {
                DataItemLink = "Employee Code"=field("No.");
                PrintOnlyIfDetail = false;
                RequestFilterFields = Status,Age;
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(Relationship;"HRM-Employee Beneficiaries".Relationship)
                {
                }
                column(SurName;"HRM-Employee Beneficiaries".SurName)
                {
                }
                column(OtherNames;"HRM-Employee Beneficiaries"."Other Names")
                {
                }
                column(IDNoPassportNo;"HRM-Employee Beneficiaries"."ID No/Passport No")
                {
                }
                column(DateOfBirth;"HRM-Employee Beneficiaries"."Date Of Birth")
                {
                }
                column(Occupation;"HRM-Employee Beneficiaries".Occupation)
                {
                }
                column(Address;"HRM-Employee Beneficiaries".Address)
                {
                }
                column(OfficeTelNo;"HRM-Employee Beneficiaries"."Office Tel No")
                {
                }
                column(BeneficiaryAge;"HRM-Employee Beneficiaries".Age)
                {
                }
                column(Status;"HRM-Employee Beneficiaries".Status)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "HRM-Employee Beneficiaries".Validate("Date Of Birth");
                    "HRM-Employee Beneficiaries".Modify;
                    HRemp.Reset;
                    HRemp.SetRange(HRemp."No.","Employee Code");
                    if HRemp.Find('-') then

                       CurrReport.SHOWOUTPUT:=true;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

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
        CI.Reset;
        CI.Get();
        CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        CurrReport_PAGENOCaptionLbl: label 'Page';
        HRemp: Record UnknownRecord61188;
}

