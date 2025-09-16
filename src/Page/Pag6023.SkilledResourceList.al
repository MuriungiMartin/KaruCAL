#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6023 "Skilled Resource List"
{
    Caption = 'Skilled Resource List';
    CardPageID = "Resource Card";
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Qualified;Qualified)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skilled';
                    Editable = false;
                    ToolTip = 'Specifies that there are skills required to service the service item, service item group or item, if you have opened the Skilled Resource List window.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number for the resource.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the resource.';
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

    trigger OnAfterGetRecord()
    begin
        Clear(ServOrderAllocMgt);
        Qualified := ServOrderAllocMgt.ResourceQualified("No.",ResourceSkillType,ResourceSkillNo);
    end;

    var
        ServOrderAllocMgt: Codeunit ServAllocationManagement;
        Qualified: Boolean;
        ResourceSkillType: Option Resource,"Service Item Group",Item,"Service Item";
        ResourceSkillNo: Code[20];
        Description: Text[50];


    procedure Initialize(Type2: Option Resource,"Service Item Group",Item,"Service Item";No2: Code[20];Description2: Text[50])
    begin
        ResourceSkillType := Type2;
        ResourceSkillNo := No2;
        Description := Description2;
    end;

    local procedure GetCaption() Text: Text[260]
    begin
        Text := CopyStr(ResourceSkillNo + ' ' + Description,1,MaxStrLen(Text));
    end;
}

