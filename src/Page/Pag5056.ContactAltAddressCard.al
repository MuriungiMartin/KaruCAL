#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5056 "Contact Alt. Address Card"
{
    Caption = 'Contact Alt. Address Card';
    DataCaptionExpression = Caption;
    PageType = Card;
    SourceTable = "Contact Alt. Address";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the alternate address.';
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the company for the alternate address.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the alternate address of the contact.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the additional part of the alternate address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the city of the contact''s alternate address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State / ZIP Code';
                    ToolTip = 'Specifies the county for the contact''s alternative address.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ZIP code of the contact''s alternate address.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the country/region for the alternate address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number for the alternate address.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telephone number for the alternate address.';
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the mobile phone number for the alternate address.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the fax number for the alternate address.';
                }
                field("Telex No.";"Telex No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telex number for the alternate address.';
                }
                field(Pager;Pager)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the pager number for the contact at the alternate address.';
                }
                field("Telex Answer Back";"Telex Answer Back")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the telex answer back number for the alternate address.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the e-mail address for the contact at the alternate address.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the home page address for the contact at the alternate address.';
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
            group("&Alt. Contact Address")
            {
                Caption = '&Alt. Contact Address';
                action("Date Ranges")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Date Ranges';
                    Image = DateRange;
                    RunObject = Page "Alt. Addr. Date Ranges";
                    RunPageLink = "Contact No."=field("Contact No."),
                                  "Contact Alt. Address Code"=field(Code);
                    ToolTip = 'Specify date ranges that apply to the contact''s alternate address.';
                }
            }
        }
    }

    var
        Text000: label 'untitled';

    local procedure Caption(): Text[130]
    var
        Cont: Record Contact;
    begin
        if Cont.Get("Contact No.") then
          exit("Contact No." + ' ' + Cont.Name + ' ' + Code + ' ' + "Company Name");

        exit(Text000);
    end;
}

