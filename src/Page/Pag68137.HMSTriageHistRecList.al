#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68137 "HMS-Triage Hist. Rec. List"
{
    CardPageID = "HMS-Triage History Header";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61402;
    SourceTableView = where("Triage Status"=filter(Cleared));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
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
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Correspondence Address 1";"Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

