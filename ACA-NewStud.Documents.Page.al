#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77365 "ACA-New Stud. Documents"
{
    PageType = List;
    SourceTable = UnknownTable77360;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Code";"Document Code")
                {
                    ApplicationArea = Basic;
                }
                field(Approver_Id;Approver_Id)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Status";"Approval Status")
                {
                    ApplicationArea = Basic;
                }
                field("Reject Reason";"Reject Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Document Uploaded";"Document Uploaded")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Comments";"Approval Comments")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Sequence";"Approval Sequence")
                {
                    ApplicationArea = Basic;
                }
                field("Approved Date/Time";"Approved Date/Time")
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

