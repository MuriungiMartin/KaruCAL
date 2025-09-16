#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9072 "IT Operations Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Administration Cue";

    layout
    {
        area(content)
        {
            cuegroup(Administration)
            {
                Caption = 'Administration';
                field("Job Queue Entries Until Today";"Job Queue Entries Until Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Job Queue Entries";
                    ToolTip = 'Specifies the number of job queue entries that are displayed in the Administration Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("User Posting Period";"User Posting Period")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "User Setup";
                    ToolTip = 'Specifies the period number of the documents that are displayed in the Administration Cue on the Role Center.';
                }
                field("No. Series Period";"No. Series Period")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "No. Series Lines";
                    ToolTip = 'Specifies the period number of the number series for the documents that are displayed in the Administration Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Edit Job Queue Entry Card")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Job Queue Entry Card';
                        RunObject = Page "Job Queue Entry Card";
                    }
                    action("Edit User Setup")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit User Setup';
                        RunObject = Page "User Setup";
                    }
                    action("Edit Migration Overview")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Edit Migration Overview';
                        RunObject = Page "Config. Package Card";
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;

        SetFilter("Date Filter2",'<=%1',CreateDatetime(Today,0T));
        SetFilter("Date Filter3",'>%1',CreateDatetime(Today,0T));
    end;
}

