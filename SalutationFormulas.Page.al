#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5152 "Salutation Formulas"
{
    Caption = 'Salutation Formulas';
    DataCaptionFields = "Salutation Code";
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
                field(Salutation;Salutation)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the salutation itself.';
                }
                field("Name 1";"Name 1")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.';
                }
                field("Name 2";"Name 2")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.';
                }
                field("Name 3";"Name 3")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.';
                }
                field("Name 4";"Name 4")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies a salutation. The options are: Job Title, First Name, Middle Name, Surname, Initials and Company Name.';
                }
                field("Name 5";"Name 5")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies a salutation.';
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

