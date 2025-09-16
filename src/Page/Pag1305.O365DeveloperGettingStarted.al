#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1305 "O365 Developer Getting Started"
{
    Caption = 'Getting Started';
    PageType = NavigatePage;
    SourceTable = "O365 Getting Started";

    layout
    {
        area(content)
        {
            group(Control4)
            {
                Visible = FirstPageVisible;
                field(Image1;ImageO365GettingStartedPageData.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page1Group)
                {
                    Caption = 'This is your developer sandbox for Dynamics 365 for Financials';
                    field(BodyText1;BodyText)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'BodyText1';
                        Editable = false;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action6>")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Image = Start;
                InFooterBar = true;

                trigger OnAction()
                var
                    O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
                begin
                    UserTours.StartUserTour(O365GettingStartedMgt.GetDevJourneyTourID);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SetRange("User ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        CurrentPageID := 1;
        FirstPageVisible := true;

        LoadRecords;

        if UserTours.IsAvailable then
          UserTours := UserTours.Create;

        if not AlreadyShown then begin
          MarkAsShown;
          "Tour Completed" := true;
          Modify;
        end;
    end;

    var
        ImageO365GettingStartedPageData: Record "O365 Getting Started Page Data";
        [RunOnClient]
        [WithEvents]
        UserTours: dotnet UserTours;
        FirstPageVisible: Boolean;
        BodyText: BigText;
        CurrentPageID: Integer;

    local procedure LoadRecords()
    var
        TextO365GettingStartedPageData: Record "O365 Getting Started Page Data";
        TextInstream: InStream;
    begin
        ImageO365GettingStartedPageData.GetPageImage(
          ImageO365GettingStartedPageData,CurrentPageID,Page::"O365 Developer Getting Started");
        TextO365GettingStartedPageData.GetPageBodyText(
          TextO365GettingStartedPageData,CurrentPageID,Page::"O365 Developer Getting Started");
        TextO365GettingStartedPageData."Body Text".CreateInstream(TextInstream,Textencoding::UTF8);
        BodyText.Read(TextInstream);
    end;

    trigger Usertours::ShowTourWizard(hasTourCompleted: Boolean)
    begin
    end;

    trigger Usertours::IsTourInProgressResultReady(isInProgress: Boolean)
    begin
    end;
}

