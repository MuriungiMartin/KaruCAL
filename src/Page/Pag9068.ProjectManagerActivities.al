#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9068 "Project Manager Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Job Cue";

    layout
    {
        area(content)
        {
            cuegroup(Control7)
            {
                Caption = 'Invoicing';
                Visible = ShowJobInvoicingActivities;
                field("Upcoming Invoices";"Upcoming Invoices")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the number of upcoming invoices that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Invoices Due - Not Created";"Invoices Due - Not Created")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the number of invoices that are due but not yet created that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Job Create Sales Invoice")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job Create Sales Invoice';
                        Image = CreateJobSalesInvoice;
                        RunObject = Report "Job Create Sales Invoice";
                        ToolTip = 'Create an invoice for a job or for one or more job tasks for a customer when either the work to be invoiced is complete or the date for invoicing based on an invoicing schedule has been reached.';
                    }
                }
            }
            cuegroup("Work in Process")
            {
                Caption = 'Work in Process';
                Visible = ShowJobWIPActivities;
                field("WIP Not Posted";"WIP Not Posted")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the amount of work in process that has not been posted that is displayed in the Service Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Completed - WIP Not Calculated";"Completed - WIP Not Calculated")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the total of work in process that is complete but not calculated that is displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Update Job Item Cost")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Update Job Item Cost';
                        Image = "Report";
                        RunObject = Report "Update Job Item Cost";
                        ToolTip = 'Update the usage costs in the job ledger entries to match the actual costs in the item ledger entry. If adjustment value entries have a different date than the original value entry, such as when the inventory period is closed, then the job ledger is not updated.';
                    }
                    action("<Action15>")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Job WIP Cockpit';
                        RunObject = Page "Job WIP Cockpit";
                        ToolTip = 'Get an overview of work in process (WIP). The Job WIP Cockpit is the central location to track WIP for all of your projects. Each line contains information about a job, including calculated and posted WIP.';
                    }
                }
            }
            cuegroup("Jobs to Budget")
            {
                Caption = 'Jobs to Budget';
                Visible = ShowJobBudgetActivities;
                field("Jobs Over Budget";"Jobs Over Budget")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Over Budget';
                    DrillDownPageID = "Job List";
                    Editable = false;
                    ToolTip = 'Specifies the number of jobs where the usage cost exceeds the budgeted cost.';
                }
            }
            cuegroup(Control19)
            {
                Caption = 'Start';
                Visible = ShowJobStartActivities;

                actions
                {
                    action("<Page Job>")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Job';
                        Image = TileNew;
                        RunObject = Page "Job Creation Wizard";
                        RunPageMode = Create;
                        ToolTip = 'Create a new job.';
                    }
                    action("<Page Job Journal>")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Job Journal';
                        Image = TileNew;
                        RunObject = Page "Job Journal";
                        RunPageMode = Edit;
                        ToolTip = 'Prepare to post usage for a job.';
                    }
                    action("Create Job &Sales Invoice")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Create Job &Sales Invoice';
                        Image = TileNew;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Report "Job Create Sales Invoice";
                        ToolTip = 'Use a batch job to help you create job sales invoices for the involved job planning lines.';
                        Visible = JobSimplificationAvailable;
                    }
                }
            }
            cuegroup("Get started")
            {
                Caption = 'Get started';
                Visible = ReplayGettingStartedVisible;

                actions
                {
                    action(ShowStartInMyCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Try with my own data';
                        Image = TileSettings;
                        ToolTip = 'Set up My Company with the settings you choose. We''ll show you how, it''s easy.';
                        Visible = false;

                        trigger OnAction()
                        begin
                            if UserTours.IsAvailable then
                              UserTours.StartUserTour(O365GettingStartedMgt.GetChangeCompanyTourID);
                        end;
                    }
                    action(ReplayGettingStarted)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Replay Getting Started';
                        Image = TileVideo;
                        ToolTip = 'Show the Getting Started guide again.';

                        trigger OnAction()
                        var
                            O365GettingStarted: Record "O365 Getting Started";
                        begin
                            if O365GettingStarted.Get(UserId,CurrentClientType) then begin
                              O365GettingStarted."Tour in Progress" := false;
                              O365GettingStarted."Current Page" := 1;
                              O365GettingStarted.Modify;
                              Commit;
                            end;

                            O365GettingStartedMgt.LaunchWizard(true,false);
                        end;
                    }
                }
            }
            cuegroup(Jobs)
            {
                Caption = 'Jobs';
                Visible = ShowJobSetupActivities;

                actions
                {
                    action("<PageJobSetup>")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Set Up Jobs';
                        Image = TileSettings;
                        RunObject = Page "Jobs Setup Wizard";
                        RunPageMode = Create;
                        ToolTip = 'Open the assisted setup guide to set up how you want to use jobs.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CueSetup.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
            group("Show/Hide Activities")
            {
                Caption = 'Show/Hide Activities';
                Image = Answers;
                action(Invoicing)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoicing';
                    Image = Invoice;
                    RunObject = Codeunit "Job Invoicing Activities Mgt.";
                    ToolTip = 'Show or hide the Job Invoicing cues.';
                }
                action("Work in Progress")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work in Progress';
                    Image = WIP;
                    RunObject = Codeunit "Item Templ. Mgt.";
                    ToolTip = 'Show or hide the Job Work in Progress cues.';
                }
                action("Jobs to Budget")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Jobs to Budget';
                    Image = Job;
                    RunObject = Codeunit "Job Budget Activities Mgt.";
                    ToolTip = 'Show or hide the Jobs to Budget cue.';
                }
                action(Start)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Start';
                    Image = NewDocument;
                    RunObject = Codeunit "Start Job Activities Mgt.";
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                }
                action(Setup)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Get Started with Jobs';
                    Image = NewDocument;
                    RunObject = Codeunit "Undo Bank Statement (Yes/No)";
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible,ReplayGettingStartedVisible);
    end;

    trigger OnAfterGetRecord()
    begin
        SetActivityGroupVisibility;
    end;

    trigger OnInit()
    var
        Job: Record Job;
        JobsSetup: Record "Jobs Setup";
        MyCompName: Text;
    begin
        O365GettingStartedMgt.UpdateGettingStartedVisible(TileGettingStartedVisible,ReplayGettingStartedVisible);
        JobSimplificationAvailable := Job.IsJobSimplificationAvailable;

        SetupIsComplete := false;

        MyCompName := COMPANYNAME;

        if JobsSetup.FindFirst then begin
          if MyCompName = MyCompanyTxt then
            SetupIsComplete := JobsSetup."Default Job Posting Group" <> ''
          else
            SetupIsComplete := JobsSetup."Job Nos." <> '';
        end;
    end;

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Date Filter",'>=%1',WorkDate);
        SetFilter("Date Filter2",'<%1&<>%2',WorkDate,0D);

        if SetupIsComplete then begin
          ShowJobInvoicingActivities := SetupIsComplete;
          ShowJobWIPActivities := SetupIsComplete;
          ShowJobStartActivities := SetupIsComplete;
          ShowJobBudgetActivities := SetupIsComplete;
          ShowJobSetupActivities := not SetupIsComplete;
        end else begin
          ShowJobInvoicingActivities := not SetupIsComplete;
          ShowJobWIPActivities := not SetupIsComplete;
          ShowJobStartActivities := not SetupIsComplete;
          ShowJobBudgetActivities := not SetupIsComplete;
          ShowJobSetupActivities := SetupIsComplete;
        end;
    end;

    var
        CueSetup: Codeunit "Cues And KPIs";
        O365GettingStartedMgt: Codeunit "O365 Getting Started Mgt.";
        [RunOnClient]
        [WithEvents]
        UserTours: dotnet UserTours;
        ReplayGettingStartedVisible: Boolean;
        ShowJobBudgetActivities: Boolean;
        ShowJobInvoicingActivities: Boolean;
        ShowJobWIPActivities: Boolean;
        ShowJobStartActivities: Boolean;
        ShowJobSetupActivities: Boolean;
        TileGettingStartedVisible: Boolean;
        JobSimplificationAvailable: Boolean;
        SetupIsComplete: Boolean;
        MyCompanyTxt: label 'My Company';

    local procedure SetActivityGroupVisibility()
    var
        JobInvoicingActivitiesMgt: Codeunit "Job Invoicing Activities Mgt.";
        JobWIPActivitiesMgt: Codeunit "Item Templ. Mgt.";
        StartJobActivitiesMgt: Codeunit "Start Job Activities Mgt.";
        JobBudgetActivitiesMgt: Codeunit "Job Budget Activities Mgt.";
        SetupJobActivitiesMgt: Codeunit "Setup Job Activities Mgt.";
    begin
        ShowJobStartActivities := SetupIsComplete and StartJobActivitiesMgt.IsActivitiesVisible;
        ShowJobInvoicingActivities := SetupIsComplete and JobInvoicingActivitiesMgt.IsActivitiesVisible;
        ShowJobBudgetActivities := SetupIsComplete and JobBudgetActivitiesMgt.IsActivitiesVisible;
        ShowJobWIPActivities := SetupIsComplete and JobWIPActivitiesMgt.IsActivitiesVisible;
        ShowJobSetupActivities := not SetupIsComplete and SetupJobActivitiesMgt.IsActivitiesVisible;
    end;


    procedure RefreshRoleCenter()
    begin
        CurrPage.Update;
    end;

    trigger Usertours::ShowTourWizard(hasTourCompleted: Boolean)
    begin
    end;

    trigger Usertours::IsTourInProgressResultReady(isInProgress: Boolean)
    begin
    end;
}

