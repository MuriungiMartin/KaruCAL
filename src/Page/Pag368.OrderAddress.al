#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 368 "Order Address"
{
    Caption = 'Order Address';
    DataCaptionExpression = Caption;
    PageType = Card;
    SourceTable = "Order Address";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an order-from address code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company name for the order address.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the order address.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies another line of the order address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the city of the order address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State / ZIP Code';
                    ToolTip = 'Specifies the state or ZIP code as a part of the address.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ZIP code of the order address.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number that is associated with the order address.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor at this address.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies when this order address was last modified.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number that is associated with the order address.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the fax number associated with the order address.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the email address associated with the order address.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the home page address associated with the order address.';
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
        area(navigation)
        {
            group("&Address")
            {
                Caption = '&Address';
                Image = Addresses;
                separator(Action39)
                {
                }
                action("Online Map")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'View the address on an online map.';

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
            }
        }
    }
}

