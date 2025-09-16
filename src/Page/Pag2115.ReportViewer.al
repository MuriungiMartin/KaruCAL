#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 2115 "Report Viewer"
{
    Caption = 'Report Viewer';

    layout
    {
        area(content)
        {
            usercontrol(PdfViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
            {
                ApplicationArea = Basic,Suite;

                trigger ControlAddInReady(callbackUrl: Text)
                var
                    FileManagement: Codeunit "File Management";
                begin
                    if DocumentPath = '' then
                      Error(NoDocErr);

                    CurrPage.PdfViewer.SetContent(FileManagement.GetFileContent(DocumentPath));
                end;

                trigger DocumentReady()
                begin
                end;

                trigger Callback(data: Text)
                begin
                end;

                trigger Refresh(callbackUrl: Text)
                var
                    FileManagement: Codeunit "File Management";
                begin
                    if DocumentPath <> '' then
                      CurrPage.PdfViewer.SetContent(FileManagement.GetFileContent(DocumentPath));
                end;
            }
        }
    }

    actions
    {
    }

    var
        DocumentPath: Text[250];
        NoDocErr: label 'No document has been specified.';


    procedure SetDocument(RecordVariant: Variant;ReportType: Integer;CustNo: Code[20])
    var
        ReportSelections: Record "Report Selections";
    begin
        ReportSelections.GetHtmlReport(DocumentPath,ReportType,RecordVariant,CustNo);
    end;
}

