#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68327 "HRM-Emp Resp. Center Card"
{
    Caption = 'Responsibility Center Card';
    PageType = Document;
    SourceTable = UnknownTable61278;

    layout
    {
        area(content)
        {
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
            field(City;City)
            {
                ApplicationArea = Basic;
            }
            field("Post Code";"Post Code")
            {
                ApplicationArea = Basic;
            }
            field("Country Code";"Country Code")
            {
                ApplicationArea = Basic;
            }
            field("Phone No.";"Phone No.")
            {
                ApplicationArea = Basic;
            }
            field("Fax No.";"Fax No.")
            {
                ApplicationArea = Basic;
            }
            field("Name 2";"Name 2")
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
            field(County;County)
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
            field("Date Filter";"Date Filter")
            {
                ApplicationArea = Basic;
            }
            field("Contract Gain/Loss Amount";"Contract Gain/Loss Amount")
            {
                ApplicationArea = Basic;
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
                    RunPageLink = "Table ID"=const(5714),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }

    var
        Mail: Codeunit Mail;
        Emp: Record UnknownRecord61188;
}

