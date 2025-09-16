#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1819 "Setup and Help Resource Card"
{
    Caption = 'Setup and Help Resources';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = NavigatePage;
    SourceTable = "Assisted Setup";
    SourceTableView = sorting(Order,Visible)
                      where(Visible=const(true));

    layout
    {
        area(content)
        {
            group(Control10)
            {
                Visible = ShowBrowser;
                usercontrol(WebViewer;"Microsoft.Dynamics.Nav.Client.WebPageViewer")
                {
                    ApplicationArea = Basic,Suite;

                    trigger ControlAddInReady(callbackUrl: Text)
                    begin
                        if ShowBrowser then
                          CurrPage.WebViewer.Navigate(AssistedSetup."Video Url");
                    end;

                    trigger DocumentReady()
                    begin
                    end;

                    trigger Callback(data: Text)
                    begin
                    end;

                    trigger Refresh(callbackUrl: Text)
                    begin
                    end;
                }
            }
            repeater(Resources)
            {
                Caption = 'Resources';
                Editable = false;
                field(Icon;Icon)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Resource;Name)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Help;HelpAvailable)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = HelpStyle;
                    Width = 3;

                    trigger OnDrillDown()
                    begin
                        NavigateHelpPage;
                        CurrPage.Update;
                    end;
                }
                field(Video;VideoAvailable)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = VideoStyle;
                    Width = 3;

                    trigger OnDrillDown()
                    begin
                        if ("Item Type" = "item type"::Group) or ("Item Type" = "item type"::"5") then
                          if ShowBrowser then
                            CurrPage.WebViewer.Navigate(AssistedSetup."Video Url");
                        NavigateVideo;
                        CurrPage.Update;
                    end;
                }
                field("Assisted Setup";AssistedSetupAvailable)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = AssistedSetupStyle;
                    Width = 3;

                    trigger OnDrillDown()
                    begin
                        if "Assisted Setup Page ID" = 0 then
                          exit;
                        Run;
                        Get("Page ID");
                        CurrPage.Update;
                    end;
                }
                field("Product Tour";TourAvailable)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Product Tour';
                    StyleExpr = TourStyle;
                    Width = 3;

                    trigger OnDrillDown()
                    begin
                        if "Tour Id" = 0 then
                          exit;
                        StartProductTour("Tour Id");
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Manage)
            {
                Caption = 'Manage';
                action(View)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View';
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunPageMode = View;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        LocalAssistedSetup: Record "Assisted Setup";
                    begin
                        CurrPage.SetSelectionFilter(LocalAssistedSetup);
                        if LocalAssistedSetup.FindFirst then
                          LocalAssistedSetup.Navigate;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        HelpAvailable := '';
        VideoAvailable := '';
        TourAvailable := '';
        AssistedSetupAvailable := '';
        HelpStyle := StandardStatusStyleTok;
        AssistedSetupStyle := StandardStatusStyleTok;
        TourStyle := StandardStatusStyleTok;
        VideoStyle := StandardStatusStyleTok;

        if "Help Url" <> '' then begin
          HelpAvailable := HelpLinkTxt;
          if "Help Status" then
            HelpStyle := SeenStatusStyleTok
          else
            HelpStyle := StandardStatusStyleTok;
        end;

        if "Assisted Setup Page ID" <> 0 then begin
          AssistedSetupAvailable := AssistedSetupLinkTxt;
          if Status = Status::Completed then
            AssistedSetupStyle := SeenStatusStyleTok
          else
            AssistedSetupStyle := StandardStatusStyleTok;
        end;

        if "Tour Id" <> 0 then begin
          TourAvailable := TourLinkTxt;
          if "Tour Status" then
            TourStyle := SeenStatusStyleTok
          else
            TourStyle := StandardStatusStyleTok;
        end;

        if "Video Url" <> '' then begin
          VideoAvailable := VideoLinkTxt;
          if "Video Status" then
            VideoStyle := SeenStatusStyleTok
          else
            VideoStyle := StandardStatusStyleTok;
        end;
    end;

    trigger OnOpenPage()
    begin
        if ParentID <> 0 then
          if AssistedSetup.Get(ParentID) then
            ShowBrowser := (AssistedSetup."Video Url" <> '');

        SetRange(Parent,ParentID);
    end;

    var
        AssistedSetup: Record "Assisted Setup";
        [RunOnClient]
        [WithEvents]
        UserTours: dotnet UserTours;
        ShowBrowser: Boolean;
        ParentID: Integer;
        TourNotAvailableMsg: label 'Tour is not available.';
        HelpAvailable: Text;
        VideoAvailable: Text;
        AssistedSetupAvailable: Text;
        TourAvailable: Text;
        HelpLinkTxt: label 'Read';
        VideoLinkTxt: label 'Watch';
        AssistedSetupLinkTxt: label 'Start';
        TourLinkTxt: label 'Try';
        HelpStyle: Text;
        VideoStyle: Text;
        TourStyle: Text;
        AssistedSetupStyle: Text;
        StandardStatusStyleTok: label 'Standard', Locked=true;
        SeenStatusStyleTok: label 'Subordinate', Locked=true;


    procedure SetGroup(GroupID: Integer)
    begin
        ParentID := GroupID;
    end;

    local procedure StartProductTour(TourID: Integer)
    begin
        if UserTours.IsAvailable then begin
          UserTours := UserTours.Create;
          UserTours.StartUserTour(TourID);
          CurrPage.Close;
        end else
          Message(TourNotAvailableMsg);
    end;

    trigger Usertours::ShowTourWizard(hasTourCompleted: Boolean)
    begin
    end;

    trigger Usertours::IsTourInProgressResultReady(isInProgress: Boolean)
    begin
    end;
}

