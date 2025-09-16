#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8620 "Config. Package - Import"
{

    trigger OnRun()
    begin
    end;

    var
        PathIsEmptyErr: label 'You must enter a file path.';
        ErrorsImportingPackageErr: label '%1 errors occurred when importing %2 package.', Comment='%1 = No. of errors, %2 = Package Code';
        PathIsTooLongErr: label 'The path cannot be longer than %1 characters.', Comment='%1 = Max no. of characters';


    procedure ImportAndApplyRapidStartPackage(PackageFileLocation: Text)
    var
        TempConfigSetup: Record "Config. Setup" temporary;
    begin
        ImportRapidStartPackage(PackageFileLocation,TempConfigSetup);
        ApplyRapidStartPackage(TempConfigSetup);
    end;


    procedure ImportRapidStartPackage(PackageFileLocation: Text;var TempConfigSetup: Record "Config. Setup" temporary)
    var
        DecompressedFileName: Text;
        FileLocation: Text[250];
    begin
        if PackageFileLocation = '' then
          Error(PathIsEmptyErr);

        if StrLen(PackageFileLocation) > MaxStrLen(TempConfigSetup."Package File Name") then
          Error(PathIsTooLongErr,MaxStrLen(TempConfigSetup."Package File Name"));

        FileLocation :=
          CopyStr(PackageFileLocation,1,MaxStrLen(TempConfigSetup."Package File Name"));

        TempConfigSetup.Init;
        TempConfigSetup.Insert;
        TempConfigSetup."Package File Name" := FileLocation;
        DecompressedFileName := TempConfigSetup.DecompressPackage(false);

        TempConfigSetup.SetHideDialog(true);
        TempConfigSetup.ReadPackageHeader(DecompressedFileName);
        TempConfigSetup.ImportPackage(DecompressedFileName);
    end;


    procedure ApplyRapidStartPackage(var TempConfigSetup: Record "Config. Setup" temporary)
    var
        ErrorCount: Integer;
    begin
        ErrorCount := TempConfigSetup.ApplyPackages;
        if ErrorCount > 0 then
          Error(ErrorsImportingPackageErr,ErrorCount,TempConfigSetup."Package Code");
        TempConfigSetup.ApplyAnswers;
    end;
}

