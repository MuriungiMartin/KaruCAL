#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9101 "Untracked Plng. Elements Part"
{
    Caption = 'Untracked Planning Elements';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Untracked Planning Element";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item in the requisition line for which untracked planning surplus exists.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code associated with the item in the requisition line, for which untracked planning surplus exists.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code in the requisition line associated with the untracked planning surplus.';
                    Visible = false;
                }
                field(Source;Source)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what the source of this untracked surplus quantity is.';
                }
                field("Source ID";"Source ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the identification code for the source of the untracked planning quantity.';
                    Visible = false;
                }
                field("Parameter Value";"Parameter Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of this planning parameter.';
                }
                field("Track Quantity From";"Track Quantity From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how much the total surplus quantity is, including the quantity from this entry.';
                    Visible = false;
                }
                field("Untracked Quantity";"Untracked Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how much this planning parameter contributed to the total surplus quantity.';
                }
                field("Track Quantity To";"Track Quantity To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what the surplus quantity would be without the quantity from this entry.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

