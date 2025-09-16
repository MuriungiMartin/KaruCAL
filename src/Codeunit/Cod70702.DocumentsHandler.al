#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 70702 "Documents Handler"
{

    trigger OnRun()
    begin
    end;


    procedure ImportStudentImagesFromFileManager(StudentNo: Code[25])
    var
        TempBlob: Record TempBlob;
        Filename: Text;
        Cust: Record Customer;
        FileMgmt: Codeunit "File Management";
    begin
        Cust.Reset;
        Cust.SetRange("Customer Type",Cust."customer type"::Student);
        if StudentNo<>'' then
          Cust.SetRange("No.",StudentNo);
        if Cust.Find('-') then begin
          repeat
            Filename := '';
            if Exists(Filename) then begin
            FileMgmt.BLOBImportFromServerFile(TempBlob, Filename);
             // Cust.Picture.CREATEINSTREAM(TempBlob.Blob.CREATEINSTREAM(),'');
              end;
            until Cust.Next=0;
          end;
    end;
}

