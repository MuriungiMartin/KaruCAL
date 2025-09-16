#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 36626 "Sales Order Shipment List"
{
    ApplicationArea = Basic;
    Caption = 'Sales Order Shipment List';
    CardPageID = "Sales Order Shipment";
    DataCaptionFields = "Document Type";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type"=const(Order));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the address that items were shipped to. This field is used when multiple the customer has multiple ship-to addresses.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the customer at the address that the items were shipped to.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number that the customer uses in their own system to refer to this sales document. You can fill this field to use it later to search for sales lines using the customer''s order number.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
            }
        }
    }

    actions
    {
    }
}

