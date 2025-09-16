#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9150 "My Customers"
{
    Caption = 'My Customers';
    PageType = ListPart;
    SourceTable = "My Customer";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer numbers that are displayed in the My Customer Cue on the Role Center.';
                    Width = 4;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the name of the customer.';
                    Width = 20;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Phone No.';
                    DrillDown = false;
                    ExtendedDatatype = PhoneNo;
                    Lookup = false;
                    ToolTip = 'Specifies the customer''s phone number.';
                    Width = 8;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales.';

                    trigger OnDrillDown()
                    begin
                        if Cust.Get("Customer No.") then
                          Cust.OpenCustomerLedgerEntries(false);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "Customer Card";
                RunPageLink = "No."=field("Customer No.");
                RunPageMode = View;
                RunPageView = sorting("No.");
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange("User ID",UserId);
    end;

    var
        Cust: Record Customer;
}

