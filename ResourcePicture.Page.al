#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 407 "Resource Picture"
{
    Caption = 'Resource Picture';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            field(Image;Image)
            {
                ApplicationArea = Jobs;
                ShowCaption = false;
                ToolTip = 'Specifies the picture that has been inserted for the resource.';
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
                    if Image.Hasvalue then
                      if not Confirm(OverrideImageQst) then
                        exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
                    if FileName = '' then
                      exit;

                    Clear(Image);
                    Image.ImportFile(FileName,ClientFileName);
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
                    ExportPath := TemporaryPath + "No." + Format(Image.MediaId);
                    Image.ExportFile(ExportPath);
                    FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,TemporaryPath);
                    TempNameValueBuffer.SetFilter(Name,StrSubstNo('%1*',ExportPath));
                    TempNameValueBuffer.FindFirst;
                    ToFile := StrSubstNo('%1 %2.jpg',"No.",Name);
                    Download(TempNameValueBuffer.Name,DownloadImageTxt,'','',ToFile);
                    if FileManagement.DeleteServerFile(TempNameValueBuffer.Name) then;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    if not Confirm(DeleteImageQst) then
                      exit;

                    Clear(Image);
                    Modify(true);
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
        DeleteExportEnabled := Image.Hasvalue;
    end;

    trigger Cameraprovider::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    var
        File: File;
        Instream: InStream;
    begin
        if (PictureName = '') or (PictureFilePath = '') then
          exit;

        if Image.Hasvalue then
          if not Confirm(OverrideImageQst) then begin
            if Erase(PictureFilePath) then;
            exit;
          end;

        File.Open(PictureFilePath);
        File.CreateInstream(Instream);

        Clear(Image);
        Image.ImportStream(Instream,PictureName);
        Modify(true);

        File.Close;
        if Erase(PictureFilePath) then;
    end;
}

