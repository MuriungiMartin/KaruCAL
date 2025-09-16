#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68179 "HMS-Doctor List List"
{
    Caption = 'Doctor''s List';
    CardPageID = "HMS-Doctors List";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61402;
    SourceTableView = where(Blocked=filter(No),
                            "Patient Current Location"=filter(="Doctor List"|=Laboratory|=Phamacy|="Radiology Room"),
                            "Doctor Visit Status"=filter(Doctor));

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
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Depandant Principle Member";"Depandant Principle Member")
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
            action("Treatment List")
            {
                ApplicationArea = Basic;
                Caption = 'Treatment List';
                Image = List;
                Promoted = true;
                RunObject = Page "HMS-Treatment List";
                RunPageLink = "Patient No."=field("Patient No.");
            }
            group("&Functions")
            {
                Caption = '&Functions';
            }
        }
    }
}

