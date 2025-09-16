#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51171 "HRM - Payment Information"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM - Payment Information.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            RequestFilterFields = "No.",Status,"Contract Type";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(no;"HRM-Employee C"."No.")
            {
            }
            column(Name;"HRM-Employee C"."First Name"+' '+"HRM-Employee C"."Middle Name"+' '+"HRM-Employee C"."Last Name")
            {
            }
            column(Middlename;"HRM-Employee C"."Middle Name")
            {
            }
            column(LastName;"HRM-Employee C"."Last Name")
            {
            }
            column(Id;"HRM-Employee C"."ID Number")
            {
            }
            column(NSSf;"HRM-Employee C"."NSSF No.")
            {
            }
            column(NHIF;"HRM-Employee C"."NHIF No.")
            {
            }
            column(Pin;"HRM-Employee C"."PIN Number")
            {
            }
            column(pICTURE;CI.Picture)
            {
            }
            column(JoiningDate;"HRM-Employee C"."Date Of Join")
            {
            }
            column(PhoneNumber;"HRM-Employee C"."Cellular Phone Number")
            {
            }
            column(Email;"HRM-Employee C"."E-Mail")
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
                       CI.Get();
                       CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
}

