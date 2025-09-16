#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51167 "Hr Length Of Service"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hr Length Of Service.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(FullName_HREmployees;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
            {
            }
            column(No_HREmployees;"HRM-Employee C"."No.")
            {
            }
            column(Length_Of_Service;DService)
            {
            }
            column(DateOfJoiningtheCompany_HREmployees;"HRM-Employee C"."Date Of Join")
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

    var
        DAge: Text[100];
        DService: Text[100];
        DPension: Text[100];
        DMedical: Text[100];
        D: Date;
        Dates: Codeunit "HR Dates";
}

