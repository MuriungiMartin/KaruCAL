#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1052 "Reminder Terms Translation"
{
    Caption = 'Reminder Terms Translation';
    DataCaptionExpression = PageCaption;
    SourceTable = "Reminder Terms Translation";

    layout
    {
        area(content)
        {
            repeater(Control1004)
            {
                field("Reminder Terms Code";"Reminder Terms Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic;
                }
                field("Note About Line Fee on Report";"Note About Line Fee on Report")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        PageCaption := "Reminder Terms Code";
    end;

    var
        PageCaption: Text;
}

