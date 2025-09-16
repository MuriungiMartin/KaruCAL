#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70706 "SMS Header List"
{
    ApplicationArea = Basic;
    CardPageID = "SMS Header Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable70701;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SMS Code";"SMS Code")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
                field("Send By";"Send By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                }
                field("Time Created";"Time Created")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Recipients;Recipients)
                {
                    ApplicationArea = Basic;
                }
                field("Messages Send";"Messages Send")
                {
                    ApplicationArea = Basic;
                }
                field("Messages Pending";"Messages Pending")
                {
                    ApplicationArea = Basic;
                }
                field("Text Message 1";"Text Message 1")
                {
                    ApplicationArea = Basic;
                }
                field("Text Message 2";"Text Message 2")
                {
                    ApplicationArea = Basic;
                }
                field("Text Message 3";"Text Message 3")
                {
                    ApplicationArea = Basic;
                }
                field("Recipient Type";"Recipient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Recipient Scope";"Recipient Scope")
                {
                    ApplicationArea = Basic;
                }
                field(Programmes;Programmes)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("Created By",UserId);
    end;

    trigger OnOpenPage()
    begin
        SetFilter("Created By",UserId);
    end;
}

