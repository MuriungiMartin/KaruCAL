#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1816 "Job Creation Wizard"
{
    Caption = 'Create New Job';
    DelayedInsert = true;
    PageType = NavigatePage;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            group(Control96)
            {
                Editable = false;
                Visible = TopBannerVisible and not FinalStepVisible;
                field("MediaRepositoryStandard.Image";MediaRepositoryStandard.Image)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control98)
            {
                Editable = false;
                Visible = TopBannerVisible and FinalStepVisible;
                field("MediaRepositoryDone.Image";MediaRepositoryDone.Image)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Control25)
            {
                Visible = FirstStepVisible;
                group("Welcome to Create New Job")
                {
                    Caption = 'Welcome to Create New Job';
                    Visible = FirstStepVisible;
                    group(Control23)
                    {
                        InstructionalText = 'Do you want to create a new job from an existing job?';
                        Visible = FirstStepVisible;
                        field(YesCheckbox;FromExistingJobYes)
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Yes';

                            trigger OnValidate()
                            begin
                                if FromExistingJobYes then
                                  FromExistingJobNo := false;
                            end;
                        }
                        field(NoCheckbox;FromExistingJobNo)
                        {
                            ApplicationArea = Jobs;
                            Caption = 'No';

                            trigger OnValidate()
                            begin
                                if FromExistingJobNo then
                                  FromExistingJobYes := false;
                            end;
                        }
                    }
                }
            }
            group(Control19)
            {
                Visible = CreationStepVisible;
                group(Control20)
                {
                    Caption = 'Welcome to Create New Job';
                    Visible = CreationStepVisible;
                    group(Control18)
                    {
                        InstructionalText = 'Fill in the following fields for the new job.';
                        Visible = CreationStepVisible;
                        field("No.";"No.")
                        {
                            ApplicationArea = Jobs;
                            Caption = 'No.';

                            trigger OnAssistEdit()
                            begin
                                if AssistEdit(xRec) then
                                  CurrPage.Update;
                            end;
                        }
                        field(Description;Description)
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Description';
                        }
                        field("Bill-to Customer No.";"Bill-to Customer No.")
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Bill-to Customer No.';
                            TableRelation = Customer;
                        }
                    }
                    group(Control9)
                    {
                        InstructionalText = 'To select the tasks to copy from an existing job, choose Next.';
                    }
                }
            }
            group(Control8)
            {
                Visible = FinalStepVisible;
                group("That's it!")
                {
                    Caption = 'That''s it!';
                    group(Control4)
                    {
                        InstructionalText = 'To view your new job, choose Finish.';
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
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                //The property 'ToolTip' cannot be empty.
                //ToolTip = '';

                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                //The property 'ToolTip' cannot be empty.
                //ToolTip = '';

                trigger OnAction()
                begin
                    FinishAction;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        LoadTopBanners;
    end;

    trigger OnOpenPage()
    begin
        Init;

        Step := Step::Start;
        EnableControls;
    end;

    var
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        Step: Option Start,Creation,Finish;
        TopBannerVisible: Boolean;
        FirstStepVisible: Boolean;
        CreationStepVisible: Boolean;
        FinalStepVisible: Boolean;
        FinishActionEnabled: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        FromExistingJobYes: Boolean;
        FromExistingJobNo: Boolean;
        SelectYesNoMsg: label 'To continue, specify if you want to create the new job based on an existing job.';
        SelectJobNumberMsg: label 'To continue, specify the job number that you want to copy.';
        SelectCustomerNumberMsg: label 'To continue, specify the customer of the new job.';

    local procedure EnableControls()
    begin
        if Step = Step::Creation then
          if (not FromExistingJobNo) and (not FromExistingJobYes) then begin
            Message(SelectYesNoMsg);
            Step := Step - 1;
            exit;
          end;

        if Step = Step::Finish then begin
          if "No." = '' then begin
            Message(SelectJobNumberMsg);
            Step := Step - 1;
            exit;
          end;

          if "Bill-to Customer No." = '' then begin
            Message(SelectCustomerNumberMsg);
            Step := Step - 1;
            exit;
          end;
        end;

        ResetControls;

        case Step of
          Step::Start:
            ShowStartStep;
          Step::Creation:
            ShowCreationStep;
          Step::Finish:
            ShowFinalStep;
        end;
    end;

    local procedure FinishAction()
    begin
        Page.Run(Page::"Job Card",Rec);
        CurrPage.Close;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        EnableControls;
    end;

    local procedure ShowStartStep()
    begin
        FirstStepVisible := true;
        FinishActionEnabled := false;
        BackActionEnabled := false;
        FromExistingJobYes := true;
        FromExistingJobNo := false;
    end;

    local procedure ShowCreationStep()
    begin
        CreationStepVisible := true;
        FinishActionEnabled := false;

        // If user clicked "Back", the Job will already exist, so don't try to create it again.
        if "No." = '' then begin
          Insert(true);
          Commit;
        end;

        if FromExistingJobNo then
          FinishAction;
    end;

    local procedure ShowFinalStep()
    var
        CopyJobTasks: Page "Copy Job Tasks";
    begin
        FinalStepVisible := true;
        BackActionEnabled := false;
        NextActionEnabled := false;

        CopyJobTasks.SetToJob(Rec);
        CopyJobTasks.Run;
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := true;
        BackActionEnabled := true;
        NextActionEnabled := true;

        FirstStepVisible := false;
        CreationStepVisible := false;
        FinalStepVisible := false;
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png',Format(CurrentClientType)) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png',Format(CurrentClientType))
        then
          TopBannerVisible := MediaRepositoryDone.Image.Hasvalue;
    end;
}

