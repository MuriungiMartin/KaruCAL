#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51326 "Modify Adm Documents Verified"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            DataItemTableView = where("Academic Year"=const("2024/2025"));
            RequestFilterFields = "Admission No";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Applic. Form Header"."Documents Verified":=false;
                "ACA-Applic. Form Header".Status:="ACA-Applic. Form Header".Status::"Provisional Admission";
                "ACA-Applic. Form Header".Modify;
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
}

