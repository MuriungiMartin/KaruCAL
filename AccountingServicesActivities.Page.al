#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9070 "Accounting Services Activities"
{
    Caption = 'Accounting Services';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Accounting Services Cue";

    layout
    {
        area(content)
        {
            cuegroup(Documents)
            {
                Caption = 'Documents';
                field("My Incoming Documents";"My Incoming Documents")
                {
                    ApplicationArea = Basic;
                }
                field("Ongoing Sales Invoices";"Ongoing Sales Invoices")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales Invoice List";
                }
            }
            cuegroup(Camera)
            {
                Caption = 'Camera';
                Visible = HasCamera;

                actions
                {
                    action(CreateIncomingDocumentFromCamera)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Incoming Doc. from Camera';
                        Image = TileCamera;

                        trigger OnAction()
                        var
                            CameraOptions: dotnet CameraOptions;
                        begin
                            if not HasCamera then
                              exit;

                            CameraOptions := CameraOptions.CameraOptions;
                            CameraOptions.Quality := 100; // 100%
                            CameraProvider.RequestPictureAsync(CameraOptions);
                        end;
                    }
                }
            }
            cuegroup(Approvals)
            {
                Caption = 'Approvals';
                field("Requests to Approve";"Requests to Approve")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetRange("User ID Filter",UserId);

        HasCamera := CameraProvider.IsAvailable;
        if HasCamera then
          CameraProvider := CameraProvider.Create;
    end;

    var
        [RunOnClient]
        [WithEvents]
        CameraProvider: dotnet CameraProvider;
        HasCamera: Boolean;

    trigger Cameraprovider::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    var
        IncomingDocument: Record "Incoming Document";
    begin
        IncomingDocument.CreateIncomingDocumentFromServerFile(PictureName,PictureFilePath);
        CurrPage.Update;
    end;
}

