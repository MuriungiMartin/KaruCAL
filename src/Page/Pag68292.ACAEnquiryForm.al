#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68292 "ACA-Enquiry Form"
{
    PageType = Card;
    SourceTable = UnknownTable61348;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Enquiry Date";"Enquiry Date")
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
                    Caption = 'Postal Address';
                }
                field("Correspondence Address";"Correspondence Address")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postal Code';
                }
                field("Home Telephone No.";"Home Telephone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
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
                field(Intake;Intake)
                {
                    ApplicationArea = Basic;
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Study";"Mode of Study")
                {
                    ApplicationArea = Basic;
                }
                field("How You knew about us";"How You knew about us")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control20;Notes)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }
}

