#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51022 "Budget Upload"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Budget Upload.rdlc';

    dataset
    {
        dataitem("Excel Buffer";"Excel Buffer")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(a;"Excel Buffer"."Column No.")
            {
            }
            column(b;"Excel Buffer"."Cell Value as Text")
            {
            }

            trigger OnAfterGetRecord()
            begin
                "Excel Buffer".SetRange("Excel Buffer"."Column No.",1);
                if "Excel Buffer".Find('-') then begin
                "Excel Buffer".Comment:="Excel Buffer"."Cell Value as Text";
                "Excel Buffer".Modify;
                end;
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

