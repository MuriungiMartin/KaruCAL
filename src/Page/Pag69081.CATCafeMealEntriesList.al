#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69081 "CAT-Cafe. Meal Entries List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61788;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Code";"Meal Code")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Description";"Meal Description")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
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
                field("Line Amount";"Line Amount")
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

