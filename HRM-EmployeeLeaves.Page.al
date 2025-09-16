#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68331 "HRM-Employee Leaves"
{
    PageType = Document;
    SourceTable = UnknownTable61188;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
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
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Join";"Date Of Join")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000028;"HRM-Employee Leave Assignment")
            {
                SubPageLink = "Employee No"=field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                       /*IF CONFIRM('Do really want to post the Allocation?') THEN BEGIN
                       EmpLeave.RESET;
                       EmpLeave.SETRANGE(EmpLeave."Employee No","No.");
                       EmpLeave.SETRANGE(EmpLeave.Posted,FALSE);
                       IF EmpLeave.FIND('-') THEN BEGIN
                       REPEAT
                       LeaveEntry.INIT;
                       LeaveEntry."Document No":=EmpLeave."Employee No";
                       LeaveEntry."To Date":=EmpLeave."Leave Code";
                       LeaveEntry."Duration Units":=TODAY;
                       LeaveEntry.Duration:=EmpLeave.Balance;
                       LeaveEntry."Cost Of Training":=LeaveEntry."Cost Of Training"::"1";
                       LeaveEntry.INSERT(TRUE);
                       EmpLeave.Posted:=TRUE;
                       EmpLeave."Posting Date":=TODAY;
                       EmpLeave.UserID:=USERID;
                       EmpLeave.MODIFY;
                       UNTIL EmpLeave.NEXT=0;
                       END;
                       END;
                                           */

                end;
            }
        }
    }

    var
        LeaveEntry: Record UnknownRecord61624;
        EmpLeave: Record UnknownRecord61281;
}

