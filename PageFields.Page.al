#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9620 "Page Fields"
{
    Caption = 'Add Field to Page';
    CardPageID = "Add Page Fields";
    DeleteAllowed = false;
    Description = 'Place fields by dragging from the list to a position on the page.';
    Editable = true;
    InstructionalText = 'Place fields by dragging from the list to a position on the page.';
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Page Table Field";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Page ID";"Page ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the page where the field can be placed.';
                }
                field("Field ID";"Field ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the field.';
                }
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the field.';
                }
                field(Length;Length)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the length of the field.';
                }
                field(Caption;Caption)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the caption of the field.';
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    StyleExpr = FieldPlaced;
                    ToolTip = 'Specifies the field''s status, such as if the field is already placed on the page.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FieldPlaced := Status = 1;
    end;

    trigger OnOpenPage()
    var
        DesignerPageId: Codeunit DesignerPageId;
    begin
        DesignerPageId.SetPageId("Page ID");
    end;

    var
        FieldPlaced: Boolean;
}

