#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69023 "ACA-Exam Results Buffer 2"
{
    DeleteAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61746;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Failure Reason";"Failure Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Unit Name";"Unit Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Exam;Exam)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Exam Score";"Exam Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Units Reg. Created";"Units Reg. Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Course Reg. Created";"Course Reg. Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostMks)
            {
                ApplicationArea = Basic;
                Caption = 'Post Marks';
                Image = ViewCheck;
                Promoted = true;

                trigger OnAction()
                begin

                      //  REPORT.RUN(51148,FALSE,FALSE);
                      // REPORT.RUN(51149,FALSE,FALSE);
                      // REPORT.RUN(52017852,FALSE,FALSE);
                      // REPORT.RUN(51094,FALSE,FALSE);
                        Page.Run(77717);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetFilter("User Name",UserId);
    end;

    trigger OnOpenPage()
    begin
        SetFilter("User Name",UserId);
    end;
}

