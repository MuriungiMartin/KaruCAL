#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 9172 "Import Profiles"
{
    Caption = 'Import Profiles';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    UseRequestPage = false;

    dataset
    {
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

    trigger OnInitReport()
    var
        ConfPersMgt: Codeunit "Conf./Personalization Mgt.";
        TempFile: File;
    begin
        TempFile.CreateTempfile;
        FileName := TempFile.Name + '.xml';
        TempFile.Close;
        if Upload(Text001,'',Text002,'',FileName) then
          ConfPersMgt.ImportProfiles(FileName);
        CurrReport.Quit;
    end;

    var
        FileName: Text[250];
        Text001: label 'Import from XML File';
        Text002: label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
}

