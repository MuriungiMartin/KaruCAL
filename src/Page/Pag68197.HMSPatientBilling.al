#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68197 "HMS-Patient Billing"
{
    CardPageID = "FIN-Customer Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61402;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Ref. No.";"Patient Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Photo;Photo)
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 1";"Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 2";"Correspondence Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 3";"Correspondence Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 2";"Telephone No. 2")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Patient Current Location";"Patient Current Location")
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
            action(Charges)
            {
                ApplicationArea = Basic;
                Caption = 'Charges';
                Image = Invoice;
                Promoted = true;
                RunObject = Page "HMS-Patient Charges List";
                RunPageLink = "Patient No."=field("Patient No.");
            }
            action("&Print Invoive")
            {
                ApplicationArea = Basic;
                Caption = '&Print Invoive';
                Image = PrintDocument;
                Promoted = true;
            }
            action("Post Charges")
            {
                ApplicationArea = Basic;
                Caption = 'Post Charges';
                Image = PostedPayment;
                Promoted = true;
            }
        }
    }
}

