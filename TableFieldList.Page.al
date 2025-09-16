#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6521 "Table Field List"
{
    Caption = 'Field List';
    DataCaptionExpression = Caption;
    Editable = false;
    PageType = List;
    SourceTable = "Field";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field("Field Caption";"Field Caption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Field Caption';
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

    local procedure Caption(): Text[100]
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        AllObjWithCaption.SetRange("Object Type",AllObjWithCaption."object type"::Table);
        AllObjWithCaption.SetRange("Object ID",TableNo);
        if AllObjWithCaption.FindFirst then
          exit(StrSubstNo('%1',AllObjWithCaption."Object Caption"));
        exit(StrSubstNo('%1',TableName));
    end;
}

