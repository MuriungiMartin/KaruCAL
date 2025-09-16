#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99411 "POS Sales Lines"
{
    PageType = ListPart;
    SourceTable = "POS Sales Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Price;Price)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Line Total";"Line Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Inventory;Inventory)
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

