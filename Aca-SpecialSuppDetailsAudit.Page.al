#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77217 "Aca-Special/Supp Details Audit"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77217;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Session";"Exam Session")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Description";"Unit Description")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Marks";"Exam Marks")
                {
                    ApplicationArea = Basic;
                }
                field("CATs Marks";"CATs Marks")
                {
                    ApplicationArea = Basic;
                }
                field("EXAMs Marks";"EXAMs Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field("Update Type";"Update Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Clear(UserSetup);
        UserSetup.Reset;
        UserSetup.SetRange("User ID",UserId);
        if UserSetup.Find('-') then begin
          UserSetup.TestField("Use Two Factor Authentication");
          end else Error('Access denied!');
    end;

    var
        UserSetup: Record "User Setup";
}

