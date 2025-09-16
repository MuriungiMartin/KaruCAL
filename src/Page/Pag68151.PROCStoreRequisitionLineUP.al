#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68151 "PROC-Store Requisition Line UP"
{
    PageType = ListPart;
    SourceTable = UnknownTable61724;

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
                field("Issuing Store";"Issuing Store")
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity Requested";"Quantity Requested")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity To Issue";"Quantity To Issue")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity Issued";"Quantity Issued")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Qty in store";"Qty in store")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Issue UserID";"Issue UserID")
                {
                    ApplicationArea = Basic;
                }
                field(Committed;Committed)
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

