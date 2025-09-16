#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5197 "Attendee Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Attendee;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                IndentationColumn = AttendanceTypeIndent;
                IndentationControls = "Attendance Type";
                field("Attendance Type";"Attendance Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the type of attendance for the meeting. You can select from: Required, Optional and To-do Organizer.';
                }
                field("Attendee Type";"Attendee Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the type of the attendee. You can choose from Contact or Salesperson.';
                }
                field("Attendee No.";"Attendee No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the number of the attendee participating in the to-do.';
                }
                field("Attendee Name";"Attendee Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the name of the attendee participating in the to-do.';
                }
                field("Send Invitation";"Send Invitation")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = SendInvitationEditable;
                    ToolTip = 'Specifies that you want to send an invitation to the attendee by e-mail. The Send Invitation option is only available for contacts and salespeople with an e-mail address. The Send Invitation option is not available for the meeting organizer.';
                }
                field("Invitation Response Type";"Invitation Response Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the type of the attendee''s response to a meeting invitation.';
                }
                field("Invitation Sent";"Invitation Sent")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the meeting invitation has been sent to the attendee. The Send Invitation option is not available for the meeting organizer.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Make &Phone Call")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Make &Phone Call';
                    Image = Calls;
                    ToolTip = 'Call the selected contact.';

                    trigger OnAction()
                    begin
                        MakePhoneCall;
                    end;
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the attendee.';

                    trigger OnAction()
                    begin
                        ShowCard;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := false;
        AttendanceTypeIndent := 0;
        SendInvitationEditable := true;

        if "Attendance Type" = "attendance type"::"To-do Organizer" then begin
          StyleIsStrong := true;
          SendInvitationEditable := false;
        end else
          AttendanceTypeIndent := 1;
    end;

    var
        Text004: label 'The Make Phone Call function is not available for a salesperson.';
        [InDataSet]
        StyleIsStrong: Boolean;
        [InDataSet]
        SendInvitationEditable: Boolean;
        AttendanceTypeIndent: Integer;

    local procedure ShowCard()
    var
        Cont: Record Contact;
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if "Attendee Type" = "attendee type"::Contact then begin
          if Cont.Get("Attendee No.") then
            Page.Run(Page::"Contact Card",Cont);
        end else
          if Salesperson.Get("Attendee No.") then
            Page.Run(Page::"Salesperson/Purchaser Card",Salesperson);
    end;

    local procedure MakePhoneCall()
    var
        Attendee: Record Attendee;
        SegLine: Record "Segment Line";
        Cont: Record Contact;
        Todo: Record "To-do";
    begin
        if "Attendee Type" = "attendee type"::Salesperson then
          Error(Text004);
        if Cont.Get("Attendee No.") then begin
          if Todo.FindAttendeeTodo(Todo,Attendee) then
            SegLine."To-do No." := Todo."No.";
          SegLine."Contact No." := Cont."No.";
          SegLine."Contact Company No." := Cont."Company No.";
          SegLine."Campaign No." := Todo."Campaign No.";
          SegLine.CreateCall;
        end;
    end;
}

