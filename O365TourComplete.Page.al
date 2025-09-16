#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1306 "O365 Tour Complete"
{
    Caption = 'Tour Complete';
    PageType = NavigatePage;
    SourceTable = "O365 Getting Started";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Editable = false;
                Visible = CurrentPage = 1;
                field(Image1;ImageO365GettingStartedPageData.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Image1';
                    Editable = false;
                    ShowCaption = false;
                }
                group(Page1Group)
                {
                    Caption = 'That''s it';
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
            action(ReturnToGettingStarted)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Return to Getting Started';
                Image = NextRecord;
                InFooterBar = true;
                Promoted = true;

                trigger OnAction()
                var
                    DummyO365GettingStarted: Page "O365 Getting Started";
                begin
                    ShowToursWizard := true;
                    CurrPage.Close;
                    "Current Page" := DummyO365GettingStarted.GetNextPageID(1,"Current Page");
                    Modify;

                    Page.Run(Page::"O365 Getting Started");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateImageAndBodyText;
    end;

    trigger OnInit()
    begin
        SetRange("User ID",UserId);
    end;

    trigger OnOpenPage()
    begin
        CurrentPage := 1;
        if UserTours.IsAvailable then begin
          UserTours := UserTours.Create;
          UserTours.StopUserTour;
        end;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if ShowToursWizard then
          exit(true);

        if "Tour Completed" then begin
          "Tour in Progress" := false;
          Modify;
          exit(true);
        end;

        exit(ConfirmClosingOfTheWizard);
    end;

    var
        ImageO365GettingStartedPageData: Record "O365 Getting Started Page Data";
        [RunOnClient]
        [WithEvents]
        UserTours: dotnet UserTours;
        BodyText: BigText;
        ExitWizardQst: label 'Are you sure that you want to exit the Getting Started tour?';
        ExitWizardInstructionTxt: label '\\You can always resume the Getting Started tour later from the Home page.';
        ShowToursWizard: Boolean;
        CurrentPage: Integer;

    local procedure MarkWizardAsDone()
    begin
        "Tour in Progress" := false;
        "Tour Completed" := true;
        Modify;

        if UserTours.IsAvailable then begin
          UserTours := UserTours.Create;
          UserTours.StopNotifyShowTourWizard;
        end;
    end;

    local procedure ConfirmClosingOfTheWizard(): Boolean
    var
        ConfirmQst: Text;
    begin
        ConfirmQst := ExitWizardQst + ExitWizardInstructionTxt;
        if not Confirm(ConfirmQst) then
          exit(false);

        MarkWizardAsDone;
        exit(true);
    end;

    local procedure UpdateImageAndBodyText()
    var
        BodyTextO365GettingStartedPageData: Record "O365 Getting Started Page Data";
        TextInStream: InStream;
    begin
        ImageO365GettingStartedPageData.GetPageImage(
          ImageO365GettingStartedPageData,CurrentPage,Page::"O365 Tour Complete");
        if BodyTextO365GettingStartedPageData.GetPageBodyText(
             BodyTextO365GettingStartedPageData,CurrentPage,Page::"O365 Tour Complete")
        then begin
          BodyTextO365GettingStartedPageData."Body Text".CreateInstream(TextInStream,Textencoding::UTF8);
          BodyText.Read(TextInStream);
        end;
    end;
}

