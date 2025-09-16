#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9171 "Export Profiles"
{
    Caption = 'Export Profiles';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Profile";"Profile")
        {
            DataItemTableView = sorting("Profile ID");
            RequestFilterFields = "Profile ID";
            column(ReportForNavId_3203; 3203)
            {
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

    trigger OnPostReport()
    var
        ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
        ToFile: Text[1024];
    begin
        ConfPersMgt.ExportProfiles(FileName,Profile);

        ToFile := Profile."Profile ID" + '.xml';
        Download(FileName,Text001,'',Text002,ToFile);
    end;

    trigger OnPreReport()
    var
        FileMgt: Codeunit "File Management";
    begin
        FileName := FileMgt.ServerTempFileName('xml');
    end;

    var
        FileName: Text;
        Text001: label 'Export to XML File';
        Text002: label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
}

