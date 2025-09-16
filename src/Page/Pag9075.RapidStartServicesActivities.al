#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9075 "RapidStart Services Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "RapidStart Services Cue";

    layout
    {
        area(content)
        {
            cuegroup(Tables)
            {
                Caption = 'Tables';
                field(Promoted;Promoted)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Config. Tables";
                    ToolTip = 'Specifies the number of configuration tables that have been promoted. The documents are filtered by today''s date.';
                }
                field("Not Started";"Not Started")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Config. Tables";
                    ToolTip = 'Specifies the number of configuration tables that have not been started. The documents are filtered by today''s date.';
                }
                field("In Progress";"In Progress")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Config. Tables";
                    ToolTip = 'Specifies the number of configuration tables that are in progress. The documents are filtered by today''s date.';
                }
                field(Completed;Completed)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Config. Tables";
                    ToolTip = 'Specifies the number of configuration tables that have been completed. The documents are filtered by today''s date.';
                }
                field(Ignored;Ignored)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Config. Tables";
                    ToolTip = 'Specifies the number of configuration tables that you have designated to be ignored. The documents are filtered by today''s date.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    DrillDownPageID = "Config. Tables";
                    ToolTip = 'Specifies the number of configuration tables that are blocked. The documents are filtered by today''s date.';
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
    end;
}

