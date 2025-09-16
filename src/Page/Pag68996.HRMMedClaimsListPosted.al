#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68996 "HRM-Med. Claims List (Posted)"
{
    CardPageID = "HRM-Medical Claims Card";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61252;
    SourceTableView = where(Status=filter(Posted));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No";"Member No")
                {
                    ApplicationArea = Basic;
                }
                field("Claim No";"Claim No")
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
                field(Dependants;Dependants)
                {
                    ApplicationArea = Basic;
                }
                field("Patient Name";"Patient Name")
                {
                    ApplicationArea = Basic;
                }
                field("Document Ref";"Document Ref")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Service";"Date of Service")
                {
                    ApplicationArea = Basic;
                }
                field("Facility Attended";"Facility Attended")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Currency Code";"Scheme Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Currency Code";"Claim Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Amount";"Claim Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Amount Charged";"Scheme Amount Charged")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        Dependants: Record UnknownRecord61053;
}

