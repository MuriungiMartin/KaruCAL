#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68314 "ACA-Hostel Ledger"
{
    Editable = false;
    PageType = List;
    SourceTable = "ACA-Hostel Ledger";

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Hostel No";"Hostel No")
                {
                    ApplicationArea = Basic;
                }
                field("Hostel Name";"Hostel Name")
                {
                    ApplicationArea = Basic;
                }
                field("Room No";"Room No")
                {
                    ApplicationArea = Basic;
                }
                field("Space No";"Space No")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Room Cost";"Room Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Student No";"Student No")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt No";"Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field(Booked;Booked)
                {
                    ApplicationArea = Basic;
                }
                field(No;No)
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

