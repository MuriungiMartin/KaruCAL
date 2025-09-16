#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68508 "ACA-Pending Adm. List (SSP)"
{
    CardPageID = "ACA-Admission Form Header GOK";
    PageType = List;
    SourceTable = UnknownTable61372;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Admission Type";"Admission Type")
                {
                    ApplicationArea = Basic;
                }
                field("JAB S.No";"JAB S.No")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Application No.";"Application No.")
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
                field("Faculty Admitted To";"Faculty Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Degree Admitted To";"Degree Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Name";"Spouse Name")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Address 1";"Spouse Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Address 2";"Spouse Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Spouse Address 3";"Spouse Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Place Of Birth Village";"Place Of Birth Village")
                {
                    ApplicationArea = Basic;
                }
                field("Place Of Birth Location";"Place Of Birth Location")
                {
                    ApplicationArea = Basic;
                }
                field("Place Of Birth District";"Place Of Birth District")
                {
                    ApplicationArea = Basic;
                }
                field("Name of Chief";"Name of Chief")
                {
                    ApplicationArea = Basic;
                }
                field("Nearest Police Station";"Nearest Police Station")
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                }
                field(Religion;Religion)
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
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field("Mother Alive Or Dead";"Mother Alive Or Dead")
                {
                    ApplicationArea = Basic;
                }
                field("Mother Full Name";"Mother Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Father Alive Or Dead";"Father Alive Or Dead")
                {
                    ApplicationArea = Basic;
                }
                field("Father Full Name";"Father Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Full Name";"Guardian Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Mother Occupation";"Mother Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Father Occupation";"Father Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Guardian Occupation";"Guardian Occupation")
                {
                    ApplicationArea = Basic;
                }
                field("Former School Code";"Former School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Index Number";"Index Number")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade";"Mean Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Physical Impairment Details";"Physical Impairment Details")
                {
                    ApplicationArea = Basic;
                }
                field("Communication to University";"Communication to University")
                {
                    ApplicationArea = Basic;
                }
                field(Photo;Photo)
                {
                    ApplicationArea = Basic;
                }
                field(Height;Height)
                {
                    ApplicationArea = Basic;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                }
                field("Without Glasses R.6";"Without Glasses R.6")
                {
                    ApplicationArea = Basic;
                }
                field("Without Glasses L.6";"Without Glasses L.6")
                {
                    ApplicationArea = Basic;
                }
                field("With Glasses R.6";"With Glasses R.6")
                {
                    ApplicationArea = Basic;
                }
                field("With Glasses L.6";"With Glasses L.6")
                {
                    ApplicationArea = Basic;
                }
                field("Hearing Right Ear";"Hearing Right Ear")
                {
                    ApplicationArea = Basic;
                }
                field("Hearing Left Ear";"Hearing Left Ear")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Teeth";"Condition Of Teeth")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Throat";"Condition Of Throat")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Ears";"Condition Of Ears")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Lymphatic Glands";"Condition Of Lymphatic Glands")
                {
                    ApplicationArea = Basic;
                }
                field("Condition Of Nose";"Condition Of Nose")
                {
                    ApplicationArea = Basic;
                }
                field("Circulatory System Pulse";"Circulatory System Pulse")
                {
                    ApplicationArea = Basic;
                }
                field("Examining Officer";"Examining Officer")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Exam Date";"Medical Exam Date")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Details Not Covered";"Medical Details Not Covered")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Relationship";"Emergency Consent Relationship")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Full Name";"Emergency Consent Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Address 1";"Emergency Consent Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Address 2";"Emergency Consent Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Consent Address 3";"Emergency Consent Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency Date of Consent";"Emergency Date of Consent")
                {
                    ApplicationArea = Basic;
                }
                field("Emergency National ID Card No.";"Emergency National ID Card No.")
                {
                    ApplicationArea = Basic;
                }
                field("Declaration Full Name";"Declaration Full Name")
                {
                    ApplicationArea = Basic;
                }
                field("Declaration Relationship";"Declaration Relationship")
                {
                    ApplicationArea = Basic;
                }
                field("Declaration National ID No";"Declaration National ID No")
                {
                    ApplicationArea = Basic;
                }
                field("Declaration Date";"Declaration Date")
                {
                    ApplicationArea = Basic;
                }
                field("Acceptance Date";"Acceptance Date")
                {
                    ApplicationArea = Basic;
                }
                field("Accepted ?";"Accepted ?")
                {
                    ApplicationArea = Basic;
                }
                field("Family Problem";"Family Problem")
                {
                    ApplicationArea = Basic;
                }
                field("Health Problem";"Health Problem")
                {
                    ApplicationArea = Basic;
                }
                field("Overseas Scholarship";"Overseas Scholarship")
                {
                    ApplicationArea = Basic;
                }
                field("Course Not Preference";"Course Not Preference")
                {
                    ApplicationArea = Basic;
                }
                field(Employment;Employment)
                {
                    ApplicationArea = Basic;
                }
                field("Other Reason";"Other Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Home District";"Home District")
                {
                    ApplicationArea = Basic;
                }
                field("Res. District";"Res. District")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Declaration ID Number";"Declaration ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Stage Admitted To";"Stage Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field("Semester Admitted To";"Semester Admitted To")
                {
                    ApplicationArea = Basic;
                }
                field(Tribe;Tribe)
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
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
            action(Card)
            {
                ApplicationArea = Basic;
                Image = Card;
                RunObject = Page "ACA-Admission Form Header GOK";
                RunPageLink = "Admission No."=field("Admission No.");
            }
        }
    }
}

