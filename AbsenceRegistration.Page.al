#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5212 "Absence Registration"
{
    ApplicationArea = Basic;
    Caption = 'Absence Registration';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Absence";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number for the employee.';
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the first day of the employee''s absence registered on this line.';
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last day of the employee''s absence registered on this line.';
                }
                field("Cause of Absence Code";"Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a cause of absence code to define the type of absence.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the absence.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity associated with absences, in hours or days.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure for the absence.';
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity associated with absences, in hours or days.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a comment is associated with this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&bsence")
            {
                Caption = 'A&bsence';
                Image = Absence;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const("Employee Absence"),
                                  "Table Line No."=field("Entry No.");
                }
                separator(Action31)
                {
                }
                action("Overview by &Categories")
                {
                    ApplicationArea = Basic;
                    Caption = 'Overview by &Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Absence Overview by Categories";
                    RunPageLink = "Employee No. Filter"=field("Employee No.");
                }
                action("Overview by &Periods")
                {
                    ApplicationArea = Basic;
                    Caption = 'Overview by &Periods';
                    Image = AbsenceCalendar;
                    RunObject = Page "Absence Overview by Periods";
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        exit(Employee.Get("Employee No."));
    end;

    var
        Employee: Record Employee;
}

