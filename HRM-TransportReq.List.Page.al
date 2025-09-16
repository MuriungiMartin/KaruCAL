#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69015 "HRM-Transport Req. List"
{
    CardPageID = "HRM-Transport Req. Card";
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61621;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Time";"Requisition Time")
                {
                    ApplicationArea = Basic;
                }
                field("Requester Code";"Requester Code")
                {
                    ApplicationArea = Basic;
                }
                field(Requester;Requester)
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field("To";"To")
                {
                    ApplicationArea = Basic;
                }
                field("Purpose of Request";"Purpose of Request")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Allocation Done";"Allocation Done")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1102755016;Outlook)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                action("Show Comments")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                }
                action("Cancel approval Request")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }
}

