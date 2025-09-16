#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68198 "HMS-Customers List"
{
    DeleteAllowed = true;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = Customer;
    SourceTableView = where("Customer Posting Group"=filter('HOSPITAL'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
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
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Telex No.";"Telex No.")
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
                field("Debit Amount (LCY)";"Debit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Amount (LCY)";"Credit Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("&Visits")
            {
                ApplicationArea = Basic;
                Caption = '&Visits';
                Image = Invoice;
                Promoted = true;
                RunObject = Page "HMS-Patient Billing";
                RunPageLink = "Patient Ref. No."=field("No.");
            }
            action("&Print Statement")
            {
                ApplicationArea = Basic;
                Caption = '&Print Statement';
            }
        }
    }
}

