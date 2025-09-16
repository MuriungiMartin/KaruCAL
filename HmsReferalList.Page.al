#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78032 "Hms Referal List"
{
    CardPageID = "HMS referal Card";
    PageType = List;
    SourceTable = UnknownTable61433;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Treatment no.";"Treatment no.")
                {
                    ApplicationArea = Basic;
                }
                field("Hospital No.";"Hospital No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Referred";"Date Referred")
                {
                    ApplicationArea = Basic;
                }
                field("Referral Reason";"Referral Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Referral Remarks";"Referral Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
                field("ID Number";"ID Number")
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
                field("Patient Ref. No.";"Patient Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No";"Staff No")
                {
                    ApplicationArea = Basic;
                }
                field("Provisional Diagnosis";"Provisional Diagnosis")
                {
                    ApplicationArea = Basic;
                }
                field("Present Treatment";"Present Treatment")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
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

