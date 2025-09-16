#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5089 "Campaign Entries"
{
    ApplicationArea = Basic;
    Caption = 'Campaign Entries';
    DataCaptionFields = "Campaign No.",Description;
    Editable = false;
    PageType = List;
    SourceTable = "Campaign Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the entry. The program automatically fills in this field when a new entry is created.';
                }
                field(Canceled;Canceled)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the entry has been canceled.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the campaign entry was recorded. The field is not editable.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the campaign entry.';
                }
                field("Cost (LCY)";"Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the cost of the campaign entry. The field is not editable.';
                }
                field("Duration (Min.)";"Duration (Min.)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the duration of the action linked to the campaign entry. The field is not editable.';
                }
                field("No. of Interactions";"No. of Interactions")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of interactions created as part of the campaign entry. The field is not editable.';
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
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Interaction Log E&ntry")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Log E&ntry';
                    Image = Interaction;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Campaign No."=field("Campaign No."),
                                  "Campaign Entry No."=field("Entry No.");
                    RunPageView = sorting("Campaign No.","Campaign Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Switch Check&mark in Canceled")
                {
                    ApplicationArea = Basic;
                    Caption = 'Switch Check&mark in Canceled';
                    Image = ReopenCancelled;
                    ToolTip = 'Change records that have a checkmark in Canceled.';

                    trigger OnAction()
                    begin
                        ToggleCanceledCheckmark;
                    end;
                }
            }
        }
    }
}

