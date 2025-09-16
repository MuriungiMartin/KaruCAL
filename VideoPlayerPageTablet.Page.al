#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1396 "Video Player Page Tablet"
{
    Caption = 'Video Player';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            usercontrol(VideoPlayer;"Microsoft.Dynamics.Nav.Client.VideoPlayer")
            {
                ApplicationArea = Basic;

                trigger AddInReady()
                begin
                    CurrPage.VideoPlayer.SetHeight(Height);
                    CurrPage.VideoPlayer.SetWidth(Width);
                    CurrPage.VideoPlayer.SetFrameAttribute('src',Src);
                end;
            }
            group(Control3)
            {
                Visible = VideoLinkVisible;
                field(OpenSourceVideoInNewWindowLbl;OpenSourceVideoInNewWindowLbl)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(LinkSrc);
                        CurrPage.Close;
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
        CurrPage.Caption(NewCaption);
        SetSourceVideoVisible;
    end;

    var
        [InDataSet]
        Height: Integer;
        [InDataSet]
        Width: Integer;
        [InDataSet]
        Src: Text;
        LinkSrc: Text;
        [InDataSet]
        NewCaption: Text;
        OpenSourceVideoInNewWindowLbl: label 'Watch the video in a new window.';
        VideoLinkVisible: Boolean;


    procedure SetParameters(VideoHeight: Integer;VideoWidth: Integer;VideoSrc: Text;VideoLinkSrc: Text;PageCaption: Text)
    begin
        Height := VideoHeight;
        Width := VideoWidth;
        Src := VideoSrc;
        LinkSrc := VideoLinkSrc;
        NewCaption := PageCaption;
    end;

    local procedure SetSourceVideoVisible()
    begin
        VideoLinkVisible := false;

        if LinkSrc <> '' then
          VideoLinkVisible := true;
    end;
}

