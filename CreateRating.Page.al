#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5189 "Create Rating"
{
    Caption = 'Create Rating';
    DataCaptionExpression = "Profile Questionnaire Code" + ' ' + Description;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = NavigatePage;
    SourceTable = "Profile Questionnaire Line";

    layout
    {
        area(content)
        {
            group(Step3)
            {
                Caption = 'Step 3';
                InstructionalText = 'Please specify the range of points required to get the different answer options.';
                Visible = Step3Visible;
                field(GetProfileLineAnswerDesc;GetProfileLineAnswerDesc)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Please select one of the options below to specify the points your contact must earn in order to receive this rating.';
                    Editable = false;
                    MultiLine = true;
                }
                group(Control3)
                {
                    field("Interval Option";"Interval Option")
                    {
                        ApplicationArea = RelationshipMgmt;
                        ToolTip = 'Specifies options for the questionnaire interval.';
                        ValuesAllowed = Interval;

                        trigger OnValidate()
                        begin
                            if "Interval Option" = "interval option"::Interval then
                              IntervalIntervalOptionOnValida;
                        end;
                    }
                    field("Wizard From Value";"Wizard From Value")
                    {
                        ApplicationArea = RelationshipMgmt;
                        BlankZero = true;
                        Caption = 'From:';
                        DecimalPlaces = 0:;
                        Enabled = WizardFromValueEnable;
                        ToolTip = 'Specifies the value in the wizard.';
                    }
                    field("Wizard To Value";"Wizard To Value")
                    {
                        ApplicationArea = RelationshipMgmt;
                        BlankZero = true;
                        Caption = 'To:';
                        DecimalPlaces = 0:;
                        Enabled = WizardToValueEnable;
                        ToolTip = 'Specifies the value in the wizard.';
                    }
                }
                group(Control32)
                {
                    field("Interval Option2";"Interval Option")
                    {
                        ApplicationArea = RelationshipMgmt;
                        ToolTip = 'Specifies options for the questionnaire interval.';
                        ValuesAllowed = Minimum;

                        trigger OnValidate()
                        begin
                            if "Interval Option" = "interval option"::Minimum then
                              MinimumIntervalOptionOnValidat;
                        end;
                    }
                    field(Minimum;"Wizard From Value")
                    {
                        ApplicationArea = RelationshipMgmt;
                        BlankZero = true;
                        Caption = 'From:';
                        DecimalPlaces = 0:;
                        Enabled = MinimumEnable;
                        ToolTip = 'Specifies the value in the wizard.';
                    }
                }
                group(Control33)
                {
                    field("Interval Option3";"Interval Option")
                    {
                        ApplicationArea = RelationshipMgmt;
                        ToolTip = 'Specifies options for the questionnaire interval.';
                        ValuesAllowed = Maximum;

                        trigger OnValidate()
                        begin
                            if "Interval Option" = "interval option"::Maximum then
                              MaximumIntervalOptionOnValidat;
                        end;
                    }
                    field(Maximum;"Wizard To Value")
                    {
                        ApplicationArea = RelationshipMgmt;
                        BlankZero = true;
                        Caption = 'To:';
                        DecimalPlaces = 0:;
                        Enabled = MaximumEnable;
                        ToolTip = 'Specifies the value in the wizard.';
                    }
                }
            }
            group(Step1)
            {
                Caption = 'Step 1';
                InstructionalText = 'This wizard helps you define the methods you will use to rate your contacts.';
                Visible = Step1Visible;
                field("Profile Questionnaire Code";"Profile Questionnaire Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'For which questionnaire should this rating be created';
                    TableRelation = "Profile Questionnaire Header";
                    ToolTip = 'Specifies the code of the profile questionnaire to which the line is linked.';
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Describe the type of rating (for example, Overall Customer Rating)';
                    MultiLine = true;
                    ToolTip = 'Specifies the profile question or answer.';
                }
                field("Min. % Questions Answered";"Min. % Questions Answered")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'What percentage of questions need to be answered before a rating is assigned?';
                    MultiLine = true;
                    ToolTip = 'Specifies the number of questions in percentage that must be answered for this rating to be calculated.';
                }
            }
            group(Step4)
            {
                Caption = 'Step 4';
                InstructionalText = 'When you choose Finish, the questions and answers you have created will be saved and the Answer Points window will open. In this window, you can assign points to each answer.';
                Visible = Step4Visible;
                part(SubForm;"Create Rating Subform")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    Visible = SubFormVisible;
                }
            }
            group(Step2)
            {
                Caption = 'Step 2';
                Visible = Step2Visible;
                field("Answer Option";"Answer Option")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Specify which of the following grouping methods you will use to rate your contacts.';
                    ToolTip = 'Specifies options for questionnaire answers.';
                    ValuesAllowed = HighLow,ABC,Custom;

                    trigger OnValidate()
                    begin
                        if "Answer Option" = "answer option"::Custom then
                          CustomAnswerOptionOnValidate;
                        if "Answer Option" = "answer option"::ABC then
                          ABCAnswerOptionOnValidate;
                        if "Answer Option" = "answer option"::HighLow then
                          HighLowAnswerOptionOnValidate;
                    end;
                }
                field(NoOfAnswers;NoOfProfileAnswers)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Number of possible answers:';
                    Enabled = NoOfAnswersEnable;

                    trigger OnDrillDown()
                    begin
                        ShowAnswers;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Back';
                Enabled = BackEnable;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    ShowStep(false);
                    PerformPrevWizardStatus;
                    ShowStep(true);
                    UpdateCntrls;
                    CurrPage.Update(true);
                end;
            }
            action(Next)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Next';
                Enabled = NextEnable;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    CheckStatus;
                    ShowStep(false);
                    PerformNextWizardStatus;
                    ShowStep(true);
                    UpdateCntrls;
                    CurrPage.Update(true);
                end;
            }
            action(Finish)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Finish';
                Enabled = FinishEnable;
                Image = Approve;
                InFooterBar = true;
                ToolTip = 'Complete the rating.';

                trigger OnAction()
                begin
                    CheckStatus;
                    FinishWizard;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        MaximumEnable := true;
        MinimumEnable := true;
        WizardToValueEnable := true;
        WizardFromValueEnable := true;
        NoOfAnswersEnable := true;
        NextEnable := true;
        SubFormVisible := true;
    end;

    trigger OnOpenPage()
    begin
        FormWidth := CancelXPos + CancelWidth + 220;
        FrmXPos := ROUND((FrmWidth - FormWidth) / 2,1) + FrmXPos;
        FrmWidth := FormWidth;

        Validate("Auto Contact Classification",true);
        Validate("Contact Class. Field","contact class. field"::Rating);
        Modify;

        ValidateAnswerOption;
        ValidateIntervalOption;

        ShowStep(true);

        UpdateCntrls;
    end;

    var
        TempProfileLineAnswer: Record "Profile Questionnaire Line" temporary;
        FormWidth: Integer;
        CancelXPos: Integer;
        CancelWidth: Integer;
        FrmXPos: Integer;
        FrmWidth: Integer;
        [InDataSet]
        Step1Visible: Boolean;
        [InDataSet]
        Step2Visible: Boolean;
        [InDataSet]
        Step3Visible: Boolean;
        [InDataSet]
        Step4Visible: Boolean;
        [InDataSet]
        SubFormVisible: Boolean;
        [InDataSet]
        NextEnable: Boolean;
        [InDataSet]
        BackEnable: Boolean;
        [InDataSet]
        FinishEnable: Boolean;
        [InDataSet]
        NoOfAnswersEnable: Boolean;
        [InDataSet]
        WizardFromValueEnable: Boolean;
        [InDataSet]
        WizardToValueEnable: Boolean;
        [InDataSet]
        MinimumEnable: Boolean;
        [InDataSet]
        MaximumEnable: Boolean;

    local procedure ShowStep(Visible: Boolean)
    begin
        case "Wizard Step" of
          "wizard step"::"1":
            begin
              NextEnable := true;
              BackEnable := false;
              Step1Visible := Visible;
              if Visible then;
            end;
          "wizard step"::"2":
            begin
              Step2Visible := Visible;
              BackEnable := true;
              NextEnable := true;
            end;
          "wizard step"::"3":
            begin
              Step3Visible := Visible;
              if Visible then begin
                BackEnable := true;
                NextEnable := true;
                FinishEnable := false;
              end;
            end;
          "wizard step"::"4":
            begin
              if Visible then begin
                GetAnswers(TempProfileLineAnswer);
                CurrPage.SubForm.Page.SetRecords(Rec,TempProfileLineAnswer);
              end;
              FinishEnable := true;
              NextEnable := false;
              Step4Visible := Visible;
              CurrPage.SubForm.Page.UpdateForm;
            end;
        end;
    end;

    local procedure UpdateCntrls()
    begin
        NoOfAnswersEnable := "Answer Option" = "answer option"::Custom;
        WizardFromValueEnable := "Interval Option" = "interval option"::Interval;
        WizardToValueEnable := "Interval Option" = "interval option"::Interval;
        MinimumEnable := "Interval Option" = "interval option"::Minimum;
        MaximumEnable := "Interval Option" = "interval option"::Maximum;
    end;

    local procedure IntervalIntervalOptionOnValida()
    begin
        ValidateIntervalOption;
        UpdateCntrls;
    end;

    local procedure MinimumIntervalOptionOnValidat()
    begin
        ValidateIntervalOption;
        UpdateCntrls
    end;

    local procedure MaximumIntervalOptionOnValidat()
    begin
        ValidateIntervalOption;
        UpdateCntrls
    end;

    local procedure HighLowAnswerOptionOnValidate()
    begin
        ValidateAnswerOption;
        UpdateCntrls;
    end;

    local procedure ABCAnswerOptionOnValidate()
    begin
        ValidateAnswerOption;
        UpdateCntrls;
    end;

    local procedure CustomAnswerOptionOnValidate()
    begin
        ValidateAnswerOption;
        ShowAnswers;
        UpdateCntrls;
    end;
}

