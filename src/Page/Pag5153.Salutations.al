#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5153 Salutations
{
    ApplicationArea = Basic;
    Caption = 'Salutations';
    PageType = List;
    SourceTable = Salutation;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salutation code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the salutation.';
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
            group("&Salutation")
            {
                Caption = '&Salutation';
                Image = SalutationFormula;
                action(Formulas)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Formulas';
                    Image = SalutationFormula;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Salutation Formulas";
                    RunPageLink = "Salutation Code"=field(Code);
                    ToolTip = 'View or edit formal and an informal salutations for each language you want to use when interacting with your contacts.';
                }
            }
        }
    }
}

