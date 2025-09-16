#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68646 "HMS Laboratory Item Subform"
{
    PageType = ListPart;
    SourceTable = UnknownTable61434;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field("Item Name";"Item Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                }
                field("Item Unit Of Measure";"Item Unit Of Measure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit of measure';
                }
                field("Item Quantity";"Item Quantity")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quantity';
                }
                field(Posted;Posted)
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

