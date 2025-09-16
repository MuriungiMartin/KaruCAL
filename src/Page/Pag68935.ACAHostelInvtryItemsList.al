#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68935 "ACA-Hostel Invtry Items List"
{
    PageType = List;
    SourceTable = "ACA-Hostel Inventory";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Item;Item)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quantity Per Room";"Quantity Per Room")
                {
                    ApplicationArea = Basic;
                }
                field("Applies To";"Applies To")
                {
                    ApplicationArea = Basic;
                }
                field("Hostel Gender";"Hostel Gender")
                {
                    ApplicationArea = Basic;
                }
                field("Fine Amount";"Fine Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Bill Total";"Bill Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("All Rooms";"All Rooms")
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

