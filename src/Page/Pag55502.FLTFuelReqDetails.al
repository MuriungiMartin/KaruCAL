#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55502 "FLT-Fuel Req. Details"
{
    PageType = ListPart;
    SourceTable = UnknownTable55501;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Vehicle Registration";"Vehicle Registration")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity (Litres)";"Quantity (Litres)")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Vehicle Details";"Vehicle Details")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Fuel Type";"Fuel Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("CC Rating";"CC Rating")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Fuelling Date";"Fuelling Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                }
                field("Fuelling Time";"Fuelling Time")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                    Visible = true;
                }
                field("Fuelling Done By (Employee)";"Fuelling Done By (Employee)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }
}

