#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 592 "Change Log Setup"
{
    ApplicationArea = Basic;
    Caption = 'Change Log Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Setup';
    SourceTable = "Change Log Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Change Log Activated";"Change Log Activated")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the change log is active.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Setup")
            {
                Caption = '&Setup';
                Image = Setup;
                action(Tables)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tables';
                    Image = "Table";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'View what must be logged for each table.';

                    trigger OnAction()
                    var
                        ChangeLogSetupList: Page "Change Log Setup (Table) List";
                    begin
                        ChangeLogSetupList.SetSource;
                        ChangeLogSetupList.RunModal;
                    end;
                }
            }
        }
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

