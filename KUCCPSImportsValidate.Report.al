#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77366 "KUCCPS Imports Validate"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(KuccpsImports;UnknownTable70082)
        {
            RequestFilterFields = Index,Admin,Prog;
            column(ReportForNavId_1000000010; 1000000010)
            {
            }

            trigger OnAfterGetRecord()
            begin
                KuccpsImports.Validate(ser);
                KuccpsImports.Modify;
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

    trigger OnInitReport()
    begin
        Clear(CompanyInformation);
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then  CompanyInformation.TestField(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        ACANewStudDocSetup: Record UnknownRecord77361;
        ACAProgramme: Record UnknownRecord61511;
        DimensionValue: Record "Dimension Value";
        SchoolName: Text[150];
        DepartmentName: Text[150];
        Sems: Record UnknownRecord61518;
}

