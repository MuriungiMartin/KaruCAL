#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10146 "Blob Management"
{

    trigger OnRun()
    begin
    end;

    var
        TempBlob: Record TempBlob;
        InStr: InStream;
        OutStr: OutStream;
        TempText: Text[1024];


    procedure Init()
    begin
        Clear(TempBlob);
        TempBlob.Init;
        TempBlob.Blob.CreateOutstream(OutStr);
    end;


    procedure Write(TextParam: Text[1024])
    begin
        if StrLen(TextParam) > 1 then
          OutStr.WriteText(TextParam,StrLen(TextParam));
    end;


    procedure Get(var TempBlobParam: Record TempBlob)
    begin
        TempBlobParam := TempBlob;
    end;


    procedure Read(var ReturnText: BigText;var BlobToRead: Record TempBlob)
    begin
        TempText := '';
        BlobToRead.Blob.CreateInstream(InStr);
        while not InStr.eos do begin
          InStr.ReadText(TempText,1024);
          ReturnText.AddText(TempText);
        end;
    end;
}

