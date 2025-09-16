#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5198 "Attendee Wizard Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Attendee;
    SourceTableTemporary = true;

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
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        StyleIsStrong := false;
        AttendanceTypeIndent := 0;
        SendInvitationEditable := true;

        if "Attendance Type" = "attendance type"::"To-do Organizer" then begin
          StyleIsStrong := true;
          SendInvitationEditable := false;
          "Send Invitation" := true;
        end else
          AttendanceTypeIndent := 1;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Get("To-do No.","Line No.");
        if "Attendee No." in [SalespersonFilter,ContactFilter] then
          Error(Text001,TableCaption);
        Delete;
        exit(false);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        xAttendee: Record Attendee;
        SplitResult: Integer;
    begin
        xAttendee.Copy(Rec);
        ValidateAttendee(Rec,Rec);
        Reset;
        Rec := xAttendee;
        if Get("To-do No.","Line No.") then begin
          repeat
          until (Next = 0) or ("Line No." = xRec."Line No.");
          Next(-1);
          SplitResult := ROUND((xRec."Line No." - "Line No.") / 2,1,'=');
        end;
        Copy(xAttendee);
        "Line No." := "Line No." + SplitResult;
        Insert;
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        xAttendee: Record Attendee;
    begin
        xAttendee.Copy(Rec);
        Get("To-do No.","Line No.");
        if ("Attendee No." in [SalespersonFilter,ContactFilter]) and
           (("Attendee Type" <> "Attendee Type") or
            ("Attendee No." <> "Attendee No.") or
            (("Attendance Type" = "attendance type"::"To-do Organizer") and
             ("Attendance Type" <> "attendance type"::"To-do Organizer")))
        then
          Error(Text001,TableCaption);
        ValidateAttendee(xAttendee,Rec);
        Copy(xAttendee);
        Modify;
        exit(false);
    end;

    var
        SalespersonFilter: Code[10];
        Text001: label 'You cannot delete or change this %1.';
        ContactFilter: Code[20];
        [InDataSet]
        StyleIsStrong: Boolean;
        [InDataSet]
        SendInvitationEditable: Boolean;
        [InDataSet]
        AttendanceTypeIndent: Integer;


    procedure SetAttendee(var Attendee: Record Attendee)
    begin
        DeleteAll;

        if Attendee.FindSet then
          repeat
            Rec := Attendee;
            Insert;
          until Attendee.Next = 0;
    end;


    procedure GetAttendee(var Attendee: Record Attendee)
    begin
        Attendee.DeleteAll;

        if FindSet then
          repeat
            Attendee := Rec;
            Attendee.Insert;
          until Next = 0;
    end;


    procedure UpdateForm()
    begin
        CurrPage.Update(false);
    end;


    procedure SetTodoFilter(NewSalespersonFilter: Code[10];NewContactFilter: Code[20])
    begin
        SalespersonFilter := NewSalespersonFilter;
        ContactFilter := NewContactFilter;
    end;
}

