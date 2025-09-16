#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68937 "GEN-Additional Group Approvers"
{
    PageType = List;
    SourceTable = UnknownTable61240;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Approver ID";"Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field("Title Header";"Title Header")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Code";"Approval Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approval Type";"Approval Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Limit Type";"Limit Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sequence No.";"Sequence No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Minimum Amount";"Minimum Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Maximum Amount";"Maximum Amount")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}

