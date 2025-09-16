#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69019 "HRM-Medical Claims List"
{
    CardPageID = "HRM-Medical Claims Card";
    PageType = List;
    SourceTable = UnknownTable61252;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member ID";"Member ID")
                {
                    ApplicationArea = Basic;
                }
                field("Member No";"Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Member Names";"Member Names")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Type";"Claim Type")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Date";"Claim Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Ref";"Document Ref")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Name";"Patient Name")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Amount";"Claim Amount")
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

