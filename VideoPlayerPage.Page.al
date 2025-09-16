#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1395 "Video Player Page"
{
    Caption = 'Video Player Page';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
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
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.Caption(NewCaption);
    end;

    var
        [InDataSet]
        Height: Integer;
        [InDataSet]
        Width: Integer;
        [InDataSet]
        Src: Text;
        [InDataSet]
        NewCaption: Text;


    procedure SetParameters(VideoHeight: Integer;VideoWidth: Integer;VideoSrc: Text;PageCaption: Text)
    begin
        Height := VideoHeight;
        Width := VideoWidth;
        Src := VideoSrc;
        NewCaption := PageCaption;
    end;
}

