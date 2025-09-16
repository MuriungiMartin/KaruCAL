#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6300 "Azure AD App Setup Wizard"
{
    Caption = 'SETUP AZURE ACTIVE DIRECTORY';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(Control14)
            {
                Editable = false;
                Visible = TopBannerVisible and not DoneVisible;
                field("<MediaRepositoryStandard>";MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '';
                    Editable = false;
                }
            }
            group(Control4)
            {
                Editable = false;
                Visible = TopBannerVisible and DoneVisible;
                field("<MediaRepositoryDone>";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '';
                    Editable = false;
                }
            }
            group(Intro)
            {
                Caption = 'Intro';
                Visible = IntroVisible;
                group("Para1.1")
                {
                    Caption = 'Welcome to Azure Active Directory (Azure AD) Setup';
                    group("Para1.1.1")
                    {
                        Caption = '';
                        InstructionalText = 'When you register an application in the Azure Portal, it enables on premise applications to communicate with Power BI Services, Office 365 Exchange Online and other Azure services directly.';
                    }
                    group("Para1.1.2")
                    {
                        Caption = '';
                        InstructionalText = 'This wizard will guide you through the steps required to register Microsoft Dynamics NAV in the Azure Portal, how to select the Azure services you want to use and what permissions to grant to each of the services you selected.';
                    }
                    group("Paral1.1.3")
                    {
                        Caption = '';
                        InstructionalText = 'At the end of the registration process, the Azure Portal will provide you with an Application ID and Key that will be required to complete this setup.';
                    }
                }
                group("Para1.2")
                {
                    Caption = 'Let''s go!';
                    InstructionalText = 'Choose Next to step through the process of registering Microsoft Dynamics NAV in the Azure Portal and obtaining the necessary information to complete this setup.';
                }
            }
            group(Step1)
            {
                Caption = 'Step 1';
                Visible = Step1Visible;
                group("Para2.1")
                {
                    Caption = 'Registering Microsoft Dynamics NAV';
                    group("Para2.1.1")
                    {
                        Caption = '';
                        InstructionalText = 'To complete the setup process, you will need to obtain an Application ID and Key from the Azure Portal.  Choose the Help icon, or find the topic called "How to: Register Dynamics NAV in the Azure Management Portal" in Help.  If the topic is not available in Help, verify that that this topic has been deployed to your Help server.';
                    }
                    group("Para2.1.2")
                    {
                        Caption = '';
                        InstructionalText = 'Before closing the Azure Management Portal, copy and paste the Application ID and Key into the associated fields provided below and choose Next.';
                        part(AzureAdSetup;"Azure AD App Setup Part")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = ' ';
                        }
                    }
                }
            }
            group(Done)
            {
                Caption = 'Done';
                Visible = DoneVisible;
                group("Para3.1")
                {
                    Caption = 'That''s it!';
                    group("Para3.1.1")
                    {
                        Caption = '';
                        InstructionalText = 'To begin using the Azure Active Directory services, choose Finish.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Back';
                Enabled = BackEnabled;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    GoToNextStep(false);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Enabled = NextEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    GoToNextStep(true);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Finish';
                Enabled = FinishEnabled;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CurrPage.AzureAdSetup.Page.Save;

                    // notify Assisted Setup that this setup has been completed
                    AssistedSetup.SetStatus(Page::"Azure AD App Setup Wizard",AssistedSetup.Status::Completed);
                    CurrPage.Update(false);
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    var
        AzureADAppSetup: Record "Azure AD App Setup";
    begin
        // Checks user permissions and closes the wizard with an error message if necessary.
        if not AzureADAppSetup.WritePermission then
          Error(PermissionsErr);
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        // Always start on the introduction step
        SetStep(Currentstep::Intro);
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        AssistedSetup: Record "Assisted Setup";
        CurrentStep: Option Intro,AzureAD,Done;
        IntroVisible: Boolean;
        Step1Visible: Boolean;
        DoneVisible: Boolean;
        NextEnabled: Boolean;
        BackEnabled: Boolean;
        FinishEnabled: Boolean;
        StepOutOfRangeErr: label 'Wizard step out of range.';
        PermissionsErr: label 'Please contact an administrator to set up your Azure Active Directory application.';
        TopBannerVisible: Boolean;

    local procedure SetStep(NewStep: Option)
    begin
        if (NewStep < Currentstep::Intro) or (NewStep > Currentstep::Done) then
          Error(StepOutOfRangeErr);

        ClearStepControls;
        CurrentStep := NewStep;

        case NewStep of
          Currentstep::Intro:
            begin
              IntroVisible := true;
              NextEnabled := true;
            end;
          Currentstep::AzureAD:
            begin
              Step1Visible := true;
              BackEnabled := true;
              NextEnabled := true;
            end;
          Currentstep::Done:
            begin
              DoneVisible := true;
              BackEnabled := true;
              FinishEnabled := true;
            end;
        end;

        CurrPage.Update(true);
    end;

    local procedure ClearStepControls()
    begin
        // hide all tabs
        IntroVisible := false;
        Step1Visible := false;
        DoneVisible := false;

        // disable all buttons
        BackEnabled := false;
        NextEnabled := false;
        FinishEnabled := false;
    end;

    local procedure CalculateNextStep(Forward: Boolean) NextStep: Integer
    begin
        // // Calculates the next step and hides steps based on whether the Power BI setup is enabled or not

        // General cases
        if Forward and (CurrentStep < Currentstep::Done) then
          // move forward 1 step
          NextStep := CurrentStep + 1
        else
          if not Forward and (CurrentStep > Currentstep::Intro) then
            // move backward 1 step
            NextStep := CurrentStep - 1
          else
            // stay on the current step
            NextStep := CurrentStep;
    end;

    local procedure GoToNextStep(Forward: Boolean)
    begin
        if Forward then
          ValidateStep(CurrentStep);

        SetStep(CalculateNextStep(Forward));
    end;

    local procedure ValidateStep(Step: Option)
    begin
        if Step = Currentstep::AzureAD then
          CurrPage.AzureAdSetup.Page.ValidateFields;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;
}

