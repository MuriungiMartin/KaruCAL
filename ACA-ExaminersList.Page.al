#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69031 "ACA-Examiners List"
{
    CardPageID = "ACA-Examiners";
    PageType = List;
    SourceTable = UnknownTable61578;

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
                field(Type;Type)
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
                field(City;City)
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
                field("Work Phone Number";"Work Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Ext.";"Ext.")
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
                field("Country Code";"Country Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
                field("Known As";"Known As")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Birth";"Date of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Join";"Date of Join")
                {
                    ApplicationArea = Basic;
                }
                field("Length of Service";"Length of Service")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Leaving";"Date of Leaving")
                {
                    ApplicationArea = Basic;
                }
                field("NSSF No.";"NSSF No.")
                {
                    ApplicationArea = Basic;
                }
                field("NHIF No.";"NHIF No.")
                {
                    ApplicationArea = Basic;
                }
                field("PayRoll No.";"PayRoll No.")
                {
                    ApplicationArea = Basic;
                }
                field("HELB No.";"HELB No.")
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("FullTime/Part Time";"FullTime/Part Time")
                {
                    ApplicationArea = Basic;
                }
                field(PayPeriod;PayPeriod)
                {
                    ApplicationArea = Basic;
                }
                field(AmountDue;AmountDue)
                {
                    ApplicationArea = Basic;
                }
                field(StatusofPayment;StatusofPayment)
                {
                    ApplicationArea = Basic;
                }
                field(DateofPayment;DateofPayment)
                {
                    ApplicationArea = Basic;
                }
                field("PayRoll No";"PayRoll No")
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
            action("Examiner Units")
            {
                ApplicationArea = Basic;
                Caption = 'Examiner Units';
                Image = List;
                Promoted = true;
                RunObject = Page "ACA-Examiners Units";
                RunPageLink = No=field("No.");
            }
            action("Examiner Qualifications")
            {
                ApplicationArea = Basic;
                Caption = 'Examiner Qualifications';
                Image = ListPage;
                Promoted = true;
                RunObject = Page "ACA-Examiners Qualification";
                RunPageLink = Code=field("No.");
            }
        }
    }
}

