#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6019 "Resource Skills"
{
    Caption = 'Resource Skills';
    DataCaptionFields = "No.","Skill Code";
    PageType = List;
    SourceTable = "Resource Skill";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the skill type associated with the entry.';
                    Visible = TypeVisible;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the skill''s object, which can be a resource number, service item group code, item number, or service item number.';
                    Visible = NoVisible;
                }
                field("Skill Code";"Skill Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the skill you want to assign.';
                    Visible = SkillCodeVisible;
                }
                field("Assigned From";"Assigned From")
                {
                    ApplicationArea = Basic;
                    BlankZero = true;
                    Editable = false;
                    ToolTip = 'Specifies the object, such as item or service item group, from which the skill code was assigned.';
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

    trigger OnDeleteRecord(): Boolean
    begin
        Clear(ResSkill);
        CurrPage.SetSelectionFilter(ResSkill);
        ResSkillMgt.PrepareRemoveMultipleResSkills(ResSkill);

        ResSkillMgt.RemoveResSkill(Rec);

        if ResSkill.Count = 1 then
          ResSkillMgt.DropGlobals;
    end;

    trigger OnInit()
    begin
        NoVisible := true;
        SkillCodeVisible := true;
        TypeVisible := true;
    end;

    trigger OnOpenPage()
    var
        i: Integer;
    begin
        SkillCodeVisible := GetFilter("Skill Code") = '';
        NoVisible := GetFilter("No.") = '';

        TypeVisible := true;

        for i := 0 to 3 do begin
          FilterGroup(i);
          if GetFilter(Type) <> '' then
            TypeVisible := false
        end;

        FilterGroup(0);
    end;

    var
        ResSkill: Record "Resource Skill";
        ResSkillMgt: Codeunit "Resource Skill Mgt.";
        [InDataSet]
        TypeVisible: Boolean;
        [InDataSet]
        SkillCodeVisible: Boolean;
        [InDataSet]
        NoVisible: Boolean;
}

