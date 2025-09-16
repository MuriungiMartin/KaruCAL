#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65018 "Cafeteria Menu Prices"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable65018;
    UsageCategory = Lists;

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
                field("Meal Description";"Meal Description")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Price";"Staff Price")
                {
                    ApplicationArea = Basic;
                }
                field("Students Price";"Students Price")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Category";"Meal Category")
                {
                    ApplicationArea = Basic;
                }
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                }
                field("Quantity on Hand";"Quantity on Hand")
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

