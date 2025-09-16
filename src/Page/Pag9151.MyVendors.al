#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9151 "My Vendors"
{
    Caption = 'My Vendors';
    PageType = ListPart;
    SourceTable = "My Vendor";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor numbers that are displayed in the My Vendor Cue on the Role Center.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Phone No.';
                    DrillDown = false;
                    ExtendedDatatype = PhoneNo;
                    Lookup = false;
                    ToolTip = 'Specifies the vendor''s phone number.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the name of the record.';
                }
                field("<Balance>";Balance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance';
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        Vend: Record Vendor;
                    begin
                        if Vend.Get("Vendor No.") then
                          Vend.OpenVendorLedgerEntries(false);
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
                RunObject = Page "Vendor Card";
                RunPageLink = "No."=field("Vendor No.");
                RunPageMode = View;
                RunPageView = sorting("No.");
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange("User ID",UserId);
    end;
}

