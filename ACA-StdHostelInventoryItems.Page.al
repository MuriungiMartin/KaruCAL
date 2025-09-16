#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68936 "ACA-Std Hostel Inventory Items"
{
    PageType = List;
    SourceTable = "ACA-Std Hostel Inventory Items";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code";"Item Code")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Hostel Block";"Hostel Block")
                {
                    ApplicationArea = Basic;
                }
                field("Room Code";"Room Code")
                {
                    ApplicationArea = Basic;
                }
                field("Space Code";"Space Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Cleared;Cleared)
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

