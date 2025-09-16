#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68036 "HRM-Company Jobs"
{
    PageType = Document;
    SourceTable = UnknownTable61056;

    layout
    {
        area(content)
        {
            field("Job ID";"Job ID")
            {
                ApplicationArea = Basic;
            }
            field("Job Description";"Job Description")
            {
                ApplicationArea = Basic;
            }
            field("Position Reporting to";"Position Reporting to")
            {
                ApplicationArea = Basic;
            }
            field("Dimension 1";"Dimension 1")
            {
                ApplicationArea = Basic;
            }
            field("Dimension 2";"Dimension 2")
            {
                ApplicationArea = Basic;
            }
            field(Department;Department)
            {
                ApplicationArea = Basic;
            }
            field(Category;Category)
            {
                ApplicationArea = Basic;
            }
            field(Grade;Grade)
            {
                ApplicationArea = Basic;
            }
            field(Objective;Objective)
            {
                ApplicationArea = Basic;
                Caption = 'Objective/Function';
                MultiLine = true;
            }
            field("No of Posts";"No of Posts")
            {
                ApplicationArea = Basic;
            }
            field("Occupied Position";"Occupied Position")
            {
                ApplicationArea = Basic;
            }
            field("Vacant Posistions";"Vacant Posistions")
            {
                ApplicationArea = Basic;
                Caption = 'Vacant Positions';
                Editable = false;
            }
            field("Key Position";"Key Position")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                Caption = 'Job';
                action("Position Supervised")
                {
                    ApplicationArea = Basic;
                    Caption = 'Position Supervised';
                    RunObject = Page "HRM-J. Position Supervised";
                    RunPageLink = "Job ID"=field("Job ID");
                }
                action("Job Specification")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Specification';
                    RunObject = Page "HRM-J. Specification";
                    RunPageLink = "Job ID"=field("Job ID");
                }
                action("Key Responsibilities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Key Responsibilities';
                    RunObject = Page "HRM-J. Responsiblities";
                    RunPageLink = "Job ID"=field("Job ID");
                }
                action("Working Relationships")
                {
                    ApplicationArea = Basic;
                    Caption = 'Working Relationships';
                    RunObject = Page "HRM-J. Working Relationships";
                    RunPageLink = "Job ID"=field("Job ID");
                }
                separator(Action1000000025)
                {
                }
                action("Vacant Positions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vacant Positions';
                    RunObject = Page "HRM-Vacant Positions";
                }
                action("Over Staffed Positions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Over Staffed Positions';
                    RunObject = Page "HRM-Over Staffed Positions";
                }
            }
        }
        area(processing)
        {
            action(Preview)
            {
                ApplicationArea = Basic;
                Caption = 'Preview';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Jobs.Reset;
                    Jobs.SetRange(Jobs."Job ID","Job ID");
                    if Jobs.Find('-') then
                    Report.RunModal(60003,true,false,Jobs);
                end;
            }
        }
    }

    var
        Jobs: Record UnknownRecord61056;
}

