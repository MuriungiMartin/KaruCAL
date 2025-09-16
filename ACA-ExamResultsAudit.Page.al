#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77216 "ACA-Exam Results Audit"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable77216;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field(Exam;Exam)
                {
                    ApplicationArea = Basic;
                }
                field("Last Modified Date";"Last Modified Date")
                {
                    ApplicationArea = Basic;
                }
                field("Last Modified Time";"Last Modified Time")
                {
                    ApplicationArea = Basic;
                }
                field("Last Modified by";"Last Modified by")
                {
                    ApplicationArea = Basic;
                }
                field("Update Type";"Update Type")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Transaction ID";"Reg. Transaction ID")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field(Percentage;Percentage)
                {
                    ApplicationArea = Basic;
                }
                field(Contribution;Contribution)
                {
                    ApplicationArea = Basic;
                }
                field("No Registration";"No Registration")
                {
                    ApplicationArea = Basic;
                }
                field("System Created";"System Created")
                {
                    ApplicationArea = Basic;
                }
                field("Re-Sit";"Re-Sit")
                {
                    ApplicationArea = Basic;
                }
                field("Re-Sited";"Re-Sited")
                {
                    ApplicationArea = Basic;
                }
                field("Repeated Score";"Repeated Score")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field(ExamType;ExamType)
                {
                    ApplicationArea = Basic;
                }
                field("Admission No";"Admission No")
                {
                    ApplicationArea = Basic;
                }
                field(SN;SN)
                {
                    ApplicationArea = Basic;
                }
                field(Reported;Reported)
                {
                    ApplicationArea = Basic;
                }
                field("Lecturer Names";"Lecturer Names")
                {
                    ApplicationArea = Basic;
                }
                field(User_ID;User_ID)
                {
                    ApplicationArea = Basic;
                }
                field("Original Score";"Original Score")
                {
                    ApplicationArea = Basic;
                }
                field("Last Edited By";"Last Edited By")
                {
                    ApplicationArea = Basic;
                }
                field("Last Edited On";"Last Edited On")
                {
                    ApplicationArea = Basic;
                }
                field(Submitted;Submitted)
                {
                    ApplicationArea = Basic;
                }
                field("Submitted On";"Submitted On")
                {
                    ApplicationArea = Basic;
                }
                field("Submitted By";"Submitted By")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Original Contribution";"Original Contribution")
                {
                    ApplicationArea = Basic;
                }
                field("Semester Total";"Semester Total")
                {
                    ApplicationArea = Basic;
                }
                field("Attachment Unit";"Attachment Unit")
                {
                    ApplicationArea = Basic;
                }
                field("Re-Take";"Re-Take")
                {
                    ApplicationArea = Basic;
                }
                field(Cancelled;Cancelled)
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled By";"Cancelled By")
                {
                    ApplicationArea = Basic;
                }
                field("Cancelled Date";"Cancelled Date")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No";"Entry No")
                {
                    ApplicationArea = Basic;
                }
                field("GPA Points";"GPA Points")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Hours";"Credit Hours")
                {
                    ApplicationArea = Basic;
                }
                field("Edit Count";"Edit Count")
                {
                    ApplicationArea = Basic;
                }
                field("Counted Occurances";"Counted Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Registration Exists";"Unit Registration Exists")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Occurances";"Number of Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("To Delete";"To Delete")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Count Exam Occurances";"Count Exam Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Count CAT Occurances";"Count CAT Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Exam is Multiple";"Exam is Multiple")
                {
                    ApplicationArea = Basic;
                }
                field("CAT is Multiple";"CAT is Multiple")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Resits";"Number of Resits")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Repeats";"Number of Repeats")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Name";"Unit Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Unarchive Marks")
            {
                ApplicationArea = Basic;
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    AuditRes: Record UnknownRecord77216;
                begin
                    AuditRes.Reset;
                    AuditRes.SetRange("Student No.",Rec."Student No.");
                    if AuditRes.FindFirst then begin
                      Report.Run(Report::"Transfer Archived Results",true,false,AuditRes);
                      end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Clear(UserSetup);
        UserSetup.Reset;
        UserSetup.SetRange("User ID",UserId);
        if UserSetup.Find('-') then begin
          UserSetup.TestField("Can Archive Results");
          end else Error('Access denied!');
    end;

    var
        UserSetup: Record "User Setup";
}

