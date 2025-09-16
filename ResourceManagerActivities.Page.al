#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9067 "Resource Manager Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Job Cue";

    layout
    {
        area(content)
        {
            cuegroup(Allocation)
            {
                Caption = 'Allocation';
                field("Available Resources";"Available Resources")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Resource List";
                    ToolTip = 'Specifies the number of available resources that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Jobs w/o Resource";"Jobs w/o Resource")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Job List";
                    ToolTip = 'Specifies the number of jobs without an assigned resource that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }
                field("Unassigned Resource Groups";"Unassigned Resource Groups")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Resource Groups";
                    ToolTip = 'Specifies the number of unassigned resource groups that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.';
                }

                actions
                {
                    action("Resource Capacity")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Capacity';
                        Image = Capacity;
                        RunObject = Page "Resource Capacity";
                        ToolTip = 'View the capacity of the resource.';
                    }
                    action("Resource Group Capacity")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Resource Group Capacity';
                        RunObject = Page "Res. Group Capacity";
                        ToolTip = 'View the capacity of resource groups.';
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

        SetRange("Date Filter",WorkDate,WorkDate);
    end;
}

