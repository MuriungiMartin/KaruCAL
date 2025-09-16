#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 300 "Ship-to Address"
{
    Caption = 'Ship-to Address';
    DataCaptionExpression = Caption;
    PageType = Card;
    SourceTable = "Ship-to Address";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control3)
                {
                    field("Code";Code)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies a ship-to address code.';
                    }
                    field(Name;Name)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the name associated with the ship-to address.';
                    }
                    field(Address;Address)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the ship-to address.';
                    }
                    field("Address 2";"Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the city the items are being shipped to.';
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
                        ToolTip = 'Specifies the ZIP code.';
                    }
                    field("Country/Region Code";"Country/Region Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap;ShowMapLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the customer''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            DisplayMap;
                        end;
                    }
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the recipient''s telephone number.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the person you contact about orders shipped to this address.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the recipient''s fax number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the recipient''s email address.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the recipient''s home page address.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code to be used for the recipient.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies a code for the shipment method to be used for the recipient.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the shipping agent code for the ship-to address.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the shipping agent service to use for this customer.';
                }
                field("Service Zone Code";"Service Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the service zone in which the ship-to address is located.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the ship-to address was last modified.';
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the customer number.';
                    Visible = false;
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
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(GetFilterCustNo) then begin
          Validate(Name,Customer.Name);
          Validate(Address,Customer.Address);
          Validate("Address 2",Customer."Address 2");
          Validate(City,Customer.City);
          Validate(County,Customer.County);
          Validate("Post Code",Customer."Post Code");
          Validate("Country/Region Code",Customer."Country/Region Code");
          Validate(Contact,Customer.Contact);
        end;
    end;

    var
        ShowMapLbl: label 'Show on Map';
}

