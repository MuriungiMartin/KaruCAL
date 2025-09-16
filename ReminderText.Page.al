#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 433 "Reminder Text"
{
    AutoSplitKey = true;
    Caption = 'Reminder Text';
    DataCaptionExpression = PageCaption;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Reminder Text";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reminder terms code this text applies to.';
                    Visible = false;
                }
                field("Reminder Level";"Reminder Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reminder level this text applies to.';
                    Visible = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the text will appear at the beginning or the end of the reminder.';
                    Visible = false;
                }
                field(Text;Text)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the text that you want to insert in the reminder.';
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
    }

    trigger OnOpenPage()
    begin
        PageCaption := "Reminder Terms Code" + ' ' + Format("Reminder Level") + ' ' + Format(Position);
    end;

    var
        PageCaption: Text[250];
}

