#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68634 "HMS Dependant Reg Request"
{
    PageType = ListPart;
    SourceTable = UnknownTable61402;
    SourceTableView = where("Patient Type"=const(Employee),
                            Blocked=const(Yes),
                            "Request Registration"=const(No));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Request Registration";"Request Registration")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Relative No.";"Relative No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Photo;Photo)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Telephone No. 2";"Telephone No. 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

