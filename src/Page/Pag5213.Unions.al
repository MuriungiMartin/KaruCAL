#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5213 Unions
{
    ApplicationArea = Basic;
    Caption = 'Unions';
    PageType = List;
    SourceTable = Union;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a union code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the union.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the union''s address.';
                    Visible = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the address.';
                    Visible = false;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                    Visible = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the union''s telephone number.';
                }
                field("No. of Members Employed";"No. of Members Employed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of members employed.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

