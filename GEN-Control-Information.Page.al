#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68078 "GEN-Control-Information"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61119;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field("Company P.I.N";"Company P.I.N")
                {
                    ApplicationArea = Basic;
                }
                field("N.S.S.F No.";"N.S.S.F No.")
                {
                    ApplicationArea = Basic;
                }
                field("N.H.I.F No";"N.H.I.F No")
                {
                    ApplicationArea = Basic;
                }
                field("Company code";"Company code")
                {
                    ApplicationArea = Basic;
                }
                field(Mission;Mission)
                {
                    ApplicationArea = Basic;
                }
                field(Vision;Vision)
                {
                    ApplicationArea = Basic;
                }
                field("Mission/Vision Link";"Mission/Vision Link")
                {
                    ApplicationArea = Basic;
                }
                field("Payslip Message";"Payslip Message")
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("Multiple Payroll";"Multiple Payroll")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.1";"Phone No.")
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
            }
            group("Physical Address")
            {
                Caption = 'Physical Address';
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 2';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact';
                }
                field("Location Code";"Location Code")
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
            group(Company)
            {
                Caption = 'Company';
                action(Committes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Committes';
                    RunObject = Page "HRM-Committees (C)";
                }
                action("Board Of Directors")
                {
                    ApplicationArea = Basic;
                    Caption = 'Board Of Directors';
                    RunObject = Page "HRM-Board of Directors";
                }
                action("Rules & Regulations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rules & Regulations';
                    RunObject = Page "HRM-Rules & Regulations";
                }
                action("Company Activities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Company Activities';
                    RunObject = Page "HRM-Company Activities";
                }
                action("Base Calendar")
                {
                    ApplicationArea = Basic;
                    Caption = 'Base Calendar';
                    RunObject = Page "Base Calendar Card";
                }
                action("Vendors & Service Providers")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendors & Service Providers';
                    RunObject = Page "Vendor Card";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        Mail: Codeunit Mail;
        PictureExists: Boolean;
}

