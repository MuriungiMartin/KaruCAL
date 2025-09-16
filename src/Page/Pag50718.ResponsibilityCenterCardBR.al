#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50718 "Responsibility Center Card BR"
{
    Caption = 'Responsibility Center Card';
    PageType = Card;
    SourceTable = UnknownTable60213;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic;
                }
                field("Notify Payment User(s)";"Notify Payment User(s)")
                {
                    ApplicationArea = Basic;
                }
                field("Payment User(s) - E-Mail";"Payment User(s) - E-Mail")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Resp. Ctr.")
            {
                Caption = '&Resp. Ctr.';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(60016),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = false;
                }
            }
        }
    }

    var
        Mail: Codeunit Mail;
}

