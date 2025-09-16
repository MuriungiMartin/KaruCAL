#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69029 "ACA-Examiners"
{
    PageType = Document;
    SourceTable = UnknownTable61578;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
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
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address";"Residential Address")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field("Home Phone Number";"Home Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Cellular Phone Number";"Cellular Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Picture;Picture)
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Fax Number";"Fax Number")
                {
                    ApplicationArea = Basic;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    Style = Favorable;
                    StyleExpr = true;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Birth";"Date of Birth")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control46;"ACA-Examiners Qualification")
            {
                SubPageLink = Code=field("No.");
            }
            part(Control35;"ACA-Examiners Units")
            {
                SubPageLink = No=field("No.");
            }
        }
    }

    actions
    {
    }
}

