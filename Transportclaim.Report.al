#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51867 "Transport claim"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Transport claim.rdlc';

    dataset
    {
        dataitem("Company Information";"Company Information")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Picture_CompanyInformation;"Company Information".Picture)
            {
            }
            column(Log;comp.Picture)
            {
            }
            column(CompName;comp.Name)
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

    trigger OnInitReport()
    begin
        comp.Reset;
        if comp.FindFirst then begin
          comp.CalcFields(Picture);
        end;
    end;

    var
        comp: Record "Company Information";
}

