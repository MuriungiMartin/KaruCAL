#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68519 "ACA-Pending Admissions (JAB)"
{
    PageType = List;
    SourceTable = UnknownTable61372;
    SourceTableView = where(Status=const(New),
                            "Admission Type"=const(JAB));

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
                field("Academic Year";"Academic Year")
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
                RunObject = Page "ACA-Admission Form Header";
                RunPageLink = "Admission No."=field("Admission No.");
            }
        }
    }
}

