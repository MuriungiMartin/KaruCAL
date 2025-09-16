#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 912 "Component - Resource Details"
{
    Caption = 'Component - Resource Details';
    PageType = CardPart;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic;
                Caption = 'Resource No.';
                ToolTip = 'Specifies a number for the resource.';
            }
            field(Type;Type)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies whether the resource is a person or a machine.';
            }
            field("Job Title";"Job Title")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the person''s job title.';
            }
            field("Base Unit of Measure";"Base Unit of Measure")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the base unit used to measure the resource, such as hour, piece, or kilometer.';
            }
            field("Unit Cost";"Unit Cost")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the cost of one unit of the resource.';
            }
        }
    }

    actions
    {
    }
}

