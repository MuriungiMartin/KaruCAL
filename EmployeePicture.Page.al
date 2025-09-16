#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5202 "Employee Picture"
{
    Caption = 'Employee Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field(Picture;Picture)
            {
                ApplicationArea = Basic,Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture of the employee.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable;

                trigger OnAction()
                var
                    CameraOptions: dotnet CameraOptions;
                begin
                    if not CameraAvailable then
                      exit;
                    CameraOptions := CameraOptions.CameraOptions;
                    CameraOptions.Quality := 100;
                    CameraProvider.RequestPictureAsync(CameraOptions);
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    //IF Picture.HASVALUE THEN
                     // IF NOT CONFIRM(OverridePictureQst) THEN
                     //   EXIT;

                    FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
                    if FileName = '' then
                      exit;

                    Clear(Picture);
                    //Picture.IMPORTFILE(FileName,ClientFileName);
                    Modify(true);
                    if FileManagement.DeleteServerFile(FileName) then;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    NameValueBuffer: Record "Name/Value Buffer";
                    TempNameValueBuffer: Record "Name/Value Buffer" temporary;
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    NameValueBuffer.DeleteAll;
                    //ExportPath := TEMPORARYPATH + "No." + FORMAT(Picture.MEDIAID);
                    /*Picture.EXPORTFILE(ExportPath);
                    FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,TEMPORARYPATH);
                    TempNameValueBuffer.SETFILTER(Name,STRSUBSTNO('%1*',ExportPath));
                    TempNameValueBuffer.FINDFIRST;
                    ToFile := STRSUBSTNO('%1 %2 %3.jpg',"No.","First Name","Last Name");
                    DOWNLOAD(TempNameValueBuffer.Name,DownloadPictureTxt,'','',ToFile);
                    IF FileManagement.DeleteServerFile(TempNameValueBuffer.Name) THEN;
                    */

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := CameraProvider.IsAvailable;
        if CameraAvailable then
          CameraProvider := CameraProvider.Create;
    end;

    var
        [RunOnClient]
        [WithEvents]
        CameraProvider: dotnet CameraProvider;
        CameraAvailable: Boolean;
        OverrideImageQst: label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        DownloadImageTxt: label 'Download image';

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Picture.Hasvalue;
    end;

    trigger Cameraprovider::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    var
        File: File;
        Instream: InStream;
    begin
        if (PictureName = '') or (PictureFilePath = '') then
          exit;

        if Picture.Hasvalue then
         // IF NOT CONFIRM(OverridePictureQst) THEN BEGIN
            if Erase(PictureFilePath) then;
            exit;
         // END;

        File.Open(PictureFilePath);
        File.CreateInstream(Instream);

        Clear(Picture);
        //picture.IMPORTSTREAM(Instream,PictureName);
        Modify(true);

        File.Close;
        if Erase(PictureFilePath) then;
    end;
}

