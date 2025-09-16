#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9193 "Thirty Day Trial Dialog"
{
    Caption = '30-Day Trial';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(Control11)
            {
                Visible = FirstStepVisible;
                group("Get started with a free 30-day trial")
                {
                    Caption = 'Get started with a free 30-day trial';
                    InstructionalText = 'Explore the benefits of Dynamics 365 for Financials with your own company data.';
                }
                field(Content1Lbl;Content1Lbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    MultiLine = true;
                }
                field(Content2Lbl;Content2Lbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    MultiLine = true;
                }
                field(Content3Lbl;Content3Lbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    MultiLine = true;
                    Visible = not MyCompanyExists;
                }
                group(Control14)
                {
                    Visible = MyCompanyExists;
                    field(Content4Lbl;Content4Lbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        MultiLine = true;
                    }
                    field(NewCompanyName;NewCompanyName)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Company Name';

                        trigger OnValidate()
                        begin
                            if NewCompanyName <> DelChr(NewCompanyName,'=','''') then
                              Error(InvalidCharErr);
                        end;
                    }
                }
            }
            group(Control17)
            {
                Visible = FinalStepVisible;
                group("We're ready, let's get started")
                {
                    Caption = 'We''re ready, let''s get started';
                    InstructionalText = 'Read and accept the terms and conditions, and then choose Start Trial to start your 30-day trial period.';
                }
                field(LinkControl;LinkLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ExtendedDatatype = URL;
                    MultiLine = false;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        Hyperlink(UrlTxt);
                    end;
                }
                field(TermsAndConditionsCheckBox;TermsAndConditionsAccepted)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'I accept the Terms & Conditions';
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
            action(ActionStartTrial)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Start Trial';
                Enabled = TermsAndConditionsAccepted;
                Gesture = None;
                Image = Approve;
                InFooterBar = true;
                //The property 'ToolTip' cannot be empty.
                //ToolTip = '';

                trigger OnAction()
                begin
                    StartTrialAction;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Step := Step::Start;
        EnableControls;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::OK then
          if not TrialWizardCompleted then
            if not Confirm(AbortTrialQst,false) then
              Error('');
    end;

    var
        Company: Record Company;
        Step: Option Start,Finish;
        FirstStepVisible: Boolean;
        FinalStepVisible: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        MyCompanyExists: Boolean;
        NewCompanyName: Text[30];
        TrialWizardCompleted: Boolean;
        TermsAndConditionsAccepted: Boolean;
        LinkLbl: label 'View Terms & Conditions';
        UrlTxt: label 'http://go.microsoft.com/fwlink/?LinkId=828977', Comment='{locked}';
        Content1Lbl: label 'Use the setups that we provide, and import or create items, customers, and vendors to do things like post invoices or use graphs and reports to analyze your finances.';
        Content2Lbl: label 'If you decide to subscribe, you can continue using the data and setup that you create during the trial.';
        Content3Lbl: label 'Choose Next to learn more about how to get started.';
        Content4Lbl: label 'Enter your company name and then choose Next. The name will appear on invoices and documents that you create.';
        SpecifyCompanyNameErr: label 'Please specify a name for your new company.';
        AbortTrialQst: label 'Are you sure that you want to cancel?';
        InvalidCharErr: label 'The company name cannot contain the following characters: ''.';

    local procedure EnableControls()
    begin
        ResetControls;

        case Step of
          Step::Start:
            ShowStartStep;
          Step::Finish:
            ShowFinalStep;
        end;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if (Step = Step::Start) and not Backwards and MyCompanyExists then
          if NewCompanyName = '' then
            Error(SpecifyCompanyNameErr);

        if Backwards then
          Step := Step - 1
        else
          Step := Step + 1;

        EnableControls;
    end;

    local procedure ShowStartStep()
    begin
        FirstStepVisible := true;
        BackActionEnabled := false;
    end;

    local procedure ShowFinalStep()
    begin
        FinalStepVisible := true;
        NextActionEnabled := false;
    end;

    local procedure ResetControls()
    begin
        BackActionEnabled := true;
        NextActionEnabled := true;

        FirstStepVisible := false;
        FinalStepVisible := false;
    end;

    local procedure StartTrialAction()
    var
        PendingCompanyRename: Record UnknownRecord9192;
    begin
        if MyCompanyExists then begin
          PendingCompanyRename.Init;
          PendingCompanyRename."Current Company Name" := Company.Name;
          PendingCompanyRename."New Company Name" := NewCompanyName;
          PendingCompanyRename.Insert;
        end;
        TrialWizardCompleted := true;
        CurrPage.Close;
    end;


    procedure SetMyCompany(MyCompanyName: Text[30])
    begin
        MyCompanyExists := Company.Get(MyCompanyName);
    end;


    procedure Confirmed(): Boolean
    begin
        exit(TermsAndConditionsAccepted and TrialWizardCompleted);
    end;
}

