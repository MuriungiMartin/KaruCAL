#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5310 "Outlook Synch. Setup Details"
{
    Caption = 'Outlook Synch. Setup Details';
    DataCaptionExpression = GetFormCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Outlook Synch. Setup Detail";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Outlook Collection";"Outlook Collection")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the Outlook collection which is selected to be synchronized.';
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


    procedure GetFormCaption(): Text[80]
    var
        OSynchEntity: Record "Outlook Synch. Entity";
    begin
        OSynchEntity.Get("Synch. Entity Code");
        exit(StrSubstNo('%1 %2',OSynchEntity.TableCaption,"Synch. Entity Code"));
    end;
}

