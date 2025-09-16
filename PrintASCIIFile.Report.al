#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1301 "Print ASCII File"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Print ASCII File.rdlc';
    Caption = 'Print ASCII File';

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_8; 8)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(FileName;FileName)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(TextLine;TextLine)
            {
            }
            column(Print_ASCII_FileCaption;Print_ASCII_FileCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if TextFile.LEN = TextFile.POS then
                  CurrReport.Break;
                TextFile.Read(TextLine);
                if CopyStr(TextLine,1,4) = Text001 then begin
                  CurrReport.Newpage;
                  TextLine := '';
                end;
            end;

            trigger OnPostDataItem()
            begin
                TextFile.Close;
            end;

            trigger OnPreDataItem()
            begin
                if ServerFileName = '' then
                  Error(Text000);
                Clear(TextFile);
                TextFile.TextMode := true;
                TextFile.Open(ServerFileName);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FileName;FileName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'File Name';
                        Editable = false;

                        trigger OnAssistEdit()
                        var
                            FileMgt: Codeunit "File Management";
                        begin
                            ServerFileName := FileMgt.UploadFile(Text002,'');
                            if ServerFileName <> '' then
                              FileName := Text004;
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            FileName := '';
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Please enter the file name.';
        Text001: label '<FF>';
        TextFile: File;
        FileName: Text;
        ServerFileName: Text;
        TextLine: Text[1024];
        Text002: label 'Import';
        Text004: label 'The file was successfully uploaded to server';
        Print_ASCII_FileCaptionLbl: label 'Print ASCII File';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

