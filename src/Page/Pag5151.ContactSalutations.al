#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5151 "Contact Salutations"
{
    Caption = 'Contact Salutations';
    Editable = false;
    PageType = List;
    SourceTable = "Salutation Formula";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Language Code";"Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the language code for the salutation formula.';
                }
                field("Salutation Type";"Salutation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the salutation is formal or informal. Make your selection by clicking the field.';
                }
                field(GetContactSalutation;GetContactSalutation)
                {
                    ApplicationArea = All;
                    Caption = 'Salutation';
                    ToolTip = 'Specifies a salutation. Use a code that makes it easy for you to remember the salutation, for example, M-JOB for "Male person with a job title".';
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
}

