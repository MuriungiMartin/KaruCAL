#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69094 "CAT-Cafe. Item Inventory List"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61782;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item No";"Item No")
                {
                    ApplicationArea = Basic;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Price Per Item";"Price Per Item")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity in Store";"Quantity in Store")
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

