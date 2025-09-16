#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69086 "CAT-Cafe. Recpts Line"
{
    PageType = ListPart;
    SourceTable = UnknownTable61775;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Meal Code";"Meal Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                            CurrPage.Update;
                           Validate(Quantity);
                           "Total Amount":="Unit Price"*Quantity;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Meal Descption";"Meal Descption")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cafeteria Section";"Cafeteria Section")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Price;Price)
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

