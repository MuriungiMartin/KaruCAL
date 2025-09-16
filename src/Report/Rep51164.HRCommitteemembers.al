#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51164 "HR Committee members"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Committee members.rdlc';

    dataset
    {
        dataitem(UnknownTable61234;UnknownTable61234)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Committee;"HRM-Commitee Members (KNCHR)".Committee)
            {
            }
            column(Member_No;"HRM-Commitee Members (KNCHR)"."Member No.")
            {
            }
            column(Member_Name;"HRM-Commitee Members (KNCHR)"."Member Name")
            {
            }
            column(Role;"HRM-Commitee Members (KNCHR)".Role)
            {
            }
            column(Date_Appointed;"HRM-Commitee Members (KNCHR)"."Date Appointed")
            {
            }
            column(Grade;"HRM-Commitee Members (KNCHR)".Grade)
            {
            }
            column(Active;"HRM-Commitee Members (KNCHR)".Active)
            {
            }
        }
        dataitem("Company Information";"Company Information")
        {
            column(ReportForNavId_1000000008; 1000000008)
            {
            }
            column(Name;"Company Information".Name)
            {
            }
            column(Picture;"Company Information".Picture)
            {
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
        CompanyInfo.Get();
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

