#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9093 "Vendor Details FactBox"
{
    Caption = 'Vendor Details';
    PageType = CardPart;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor No.';
                ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                Visible = ShowVendorNo;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(Name;Name)
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the vendor''s name.';
            }
            field("Phone No.";"Phone No.")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the vendor''s telephone number.';
            }
            field("E-Mail";"E-Mail")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the vendor''s email address.';
            }
            field("Fax No.";"Fax No.")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the vendor''s fax number.';
            }
            field(Contact;Contact)
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Actions")
            {
                Caption = 'Actions';
                Image = "Action";
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Vendor),
                                  "No."=field("No.");
                    ToolTip = 'View or add comments.';
                }
            }
        }
    }

    trigger OnInit()
    begin
        ShowVendorNo := true;
    end;

    var
        ShowVendorNo: Boolean;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Vendor Card",Rec);
    end;


    procedure SetVendorNoVisibility(Visible: Boolean)
    begin
        ShowVendorNo := Visible;
    end;
}

