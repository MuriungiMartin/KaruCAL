#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69260 "CAT-Meal Recipe"
{
    PageType = List;
    SourceTable = UnknownTable69260;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Meal Description";"Meal Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Visible = false;
                }
                field("Resource Type";"Resource Type")
                {
                    ApplicationArea = Basic;
                }
                field(Resource;Resource)
                {
                    ApplicationArea = Basic;
                }
                field("Resource Name";"Resource Name")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Markup %";"Markup %")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Final Cost";"Final Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Final Price";"Final Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

