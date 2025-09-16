#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69300 "ACA-Meal Booking Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable61779;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Meal Code";"Meal Code")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Name";"Meal Name")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(Cost;Cost)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

