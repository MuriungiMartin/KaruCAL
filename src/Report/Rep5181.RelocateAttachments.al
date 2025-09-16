#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5181 "Relocate Attachments"
{
    Caption = 'Relocate Attachments';
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem(Attachment;Attachment)
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_5264; 5264)
            {
            }

            trigger OnAfterGetRecord()
            var
                FromDiskFileName: Text[250];
                ServerFileName: Text;
            begin
                LineCount := LineCount + 1;
                Window.Update(1,ROUND(LineCount / NoOfRecords * 10000,1));

                // Copy DiskFile to DiskFile
                if ("Storage Type" = "storage type"::"Disk File") and
                   (RMSetup."Attachment Storage Type" = RMSetup."attachment storage type"::"Disk File")
                then begin
                  RMSetup.TestField("Attachment Storage Location");
                  if "Storage Pointer" <> RMSetup."Attachment Storage Location" then begin
                    FromDiskFileName := ConstDiskFileName;
                    "Storage Pointer" := RMSetup."Attachment Storage Location";
                    Modify;
                    FileManagement.CopyServerFile(FromDiskFileName,ConstDiskFileName,false); // Copy from UNC location to another UNC location
                    Commit;
                    FileManagement.DeleteServerFile(FromDiskFileName);
                  end;
                  CurrReport.Skip;
                end;

                // Export Embedded Blob to Diskfile
                if ("Storage Type" = "storage type"::Embedded) and
                   (RMSetup."Attachment Storage Type" = RMSetup."attachment storage type"::"Disk File")
                then begin
                  RMSetup.TestField("Attachment Storage Location");
                  CalcFields("Attachment File");
                  if "Attachment File".Hasvalue then begin
                    "Storage Pointer" := RMSetup."Attachment Storage Location";
                    ServerFileName := ConstDiskFileName;
                    ExportAttachmentToServerFile(ServerFileName); // Export blob to UNC location
                    "Storage Type" := "storage type"::"Disk File";
                    Clear("Attachment File");
                    Modify;
                    Commit;
                    CurrReport.Skip;
                  end;
                end;

                // Import DiskFile to Embedded Blob
                if ("Storage Type" = "storage type"::"Disk File") and
                   (RMSetup."Attachment Storage Type" = RMSetup."attachment storage type"::Embedded)
                then begin
                  FromDiskFileName := ConstDiskFileName;
                  ImportAttachmentFromServerFile(ConstDiskFileName,false,true); // Import file from UNC location
                  Commit;
                  FileManagement.DeleteServerFile(FromDiskFileName);
                  CurrReport.Skip;
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

    trigger OnInitReport()
    begin
        if not Confirm(Text000,true) then
          CurrReport.Quit;
    end;

    trigger OnPreReport()
    begin
        RMSetup.Get;
        NoOfRecords := Attachment.Count;
        Window.Open(Text001);
    end;

    var
        RMSetup: Record "Marketing Setup";
        Text000: label 'Do you want to relocate existing attachments?';
        FileManagement: Codeunit "File Management";
        Window: Dialog;
        Text001: label 'Relocating attachments @1@@@@@@@@@@@@@';
        NoOfRecords: Integer;
        LineCount: Integer;
}

