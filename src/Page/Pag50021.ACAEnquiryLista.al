#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50021 "ACA-Enquiry List (a)"
{
    CardPageID = "ACA-Enquiry Form";
    PageType = List;
    SourceTable = UnknownTable61348;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Enquiry No.";"Enquiry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Enquiry Date";"Enquiry Date")
                {
                    ApplicationArea = Basic;
                }
                field("Name(Surname First)";"Name(Surname First)")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Birth";"Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Passport/National ID Number";"Passport/National ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Permanent Home Address";"Permanent Home Address")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address";"Correspondence Address")
                {
                    ApplicationArea = Basic;
                }
                field("Home Telephone No.";"Home Telephone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Office Telephone No.";"Office Telephone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Mobile Number";"Mobile Number")
                {
                    ApplicationArea = Basic;
                }
                field("Fax Number";"Fax Number")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address";"Email Address")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Stage";"Programme Stage")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Application Fee Receipt No.";"Application Fee Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Application Form Filled";"Application Form Filled")
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field("Ref No";"Ref No")
                {
                    ApplicationArea = Basic;
                }
                field("Registration No";"Registration No")
                {
                    ApplicationArea = Basic;
                }
                field("Registrar Approved";"Registrar Approved")
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
            action(pstSubmit)
            {
                ApplicationArea = Basic;
                Caption = 'Submit Record';
                Image = PostDocument;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = false;
            }
        }
    }
}

