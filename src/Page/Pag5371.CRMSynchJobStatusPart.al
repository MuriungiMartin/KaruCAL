#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5371 "CRM Synch. Job Status Part"
{
    Caption = 'Microsoft Dynamics CRM Synch. Job Status';
    PageType = CardPart;
    SourceTable = "CRM Synch. Job Status Cue";

    layout
    {
        area(content)
        {
            cuegroup(Control1)
            {
                field("Failed Synch. Jobs";"Failed Synch. Jobs")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "CRM Synch. Job Queue";
                    Image = Checklist;
                    ToolTip = 'Specifies the number of failed Microsoft Dynamics CRM synchronization jobs in the job queue.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Job Queue Entries")
            {
                ApplicationArea = Suite;
                Caption = 'Edit Job Queue Entries';
                Image = ViewDetails;
                RunObject = Page "Job Queue Entries";
                RunPageView = where("Object ID to Run"=const(5339));
                ToolTip = 'Change the settings for the job queue entry.';
            }
            action("<Page CRM Connection Setup>")
            {
                ApplicationArea = Suite;
                Caption = 'Microsoft Dynamics CRM Connection Setup';
                Image = Setup;
                RunObject = Page "CRM Connection Setup";
            }
            action(Reset)
            {
                ApplicationArea = Suite;
                Caption = 'Reset';
                Image = Cancel;
                ToolTip = 'Reset the synchronization status.';

                trigger OnAction()
                begin
                    CRMSynchJobManagement.OnReset(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CRMSynchJobManagement.SetInitialState(Rec);
    end;

    var
        CRMSynchJobManagement: Codeunit "CRM Synch. Job Management";
}

