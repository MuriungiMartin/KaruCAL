#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68119 "PROC-Procurement Plan Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable61696;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Type No";"Type No")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of measure";Unit)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Method;Method)
                {
                    ApplicationArea = Basic;
                }
                field("Procurement Plan Period";"Procurement Plan Period")
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

