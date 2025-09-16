#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8619 "Config. Pckg. Compression Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        FileNotExistErr: label 'The file %1 does not exist.';
        FileAlreadyExistErr: label 'The file name %1 already exists.';
        NotValidFileNameErr: label '%1 is not a valid file name.';


    procedure ServersideCompress(SourceFilePath: Text;DestinationFilePath: Text)
    begin
        ProcessGZip(SourceFilePath,DestinationFilePath,true);
    end;


    procedure ServersideDecompress(SourceFilePath: Text;DestinationFilePath: Text): Boolean
    var
        FileMgt: Codeunit "File Management";
    begin
        if not FileMgt.IsGZip(SourceFilePath) then
          exit(false);
        ProcessGZip(SourceFilePath,DestinationFilePath,false);

        exit(true);
    end;

    local procedure ProcessGZip(SourceFilePath: Text;DestinationFilePath: Text;ToCompress: Boolean)
    var
        FileMgt: Codeunit "File Management";
        CompressionMode: dotnet CompressionMode;
        CompressedStream: dotnet GZipStream;
        SourceFile: File;
        DestinationFile: File;
        OutStream: OutStream;
        InStream: InStream;
    begin
        if not FILE.Exists(SourceFilePath) then
          Error(FileNotExistErr,SourceFilePath);

        if not FileMgt.IsValidFileName(FileMgt.GetFileName(DestinationFilePath)) then
          Error(NotValidFileNameErr,DestinationFilePath);

        if FILE.Exists(DestinationFilePath) then
          Error(FileAlreadyExistErr,DestinationFilePath);

        OpenFileAndInStream(InStream,SourceFile,SourceFilePath);
        CreateFileAndOutStream(OutStream,DestinationFile,DestinationFilePath);

        if ToCompress then begin
          CompressedStream := CompressedStream.GZipStream(OutStream,CompressionMode.Compress);
          CopyStream(CompressedStream,InStream);
        end else begin
          CompressedStream := CompressedStream.GZipStream(InStream,CompressionMode.Decompress);
          CopyStream(OutStream,CompressedStream);
        end;

        CompressedStream.Close;
    end;

    local procedure OpenFileAndInStream(var InStream: InStream;var File: File;FilePath: Text)
    begin
        File.WriteMode(false);
        File.TextMode(false);
        File.Open(FilePath);
        File.CreateInstream(InStream);
    end;

    local procedure CreateFileAndOutStream(var OutStream: OutStream;var File: File;FilePath: Text)
    begin
        File.WriteMode(false);
        File.TextMode(false);
        File.Create(FilePath);
        File.CreateOutstream(OutStream);
    end;
}

