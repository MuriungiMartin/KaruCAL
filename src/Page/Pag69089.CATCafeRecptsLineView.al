#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69089 "CAT-Cafe. Recpts Line View"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61775;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Code";"Meal Code")
                {
                    ApplicationArea = Basic;
                }
                field("Meal Descption";"Meal Descption")
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
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
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

