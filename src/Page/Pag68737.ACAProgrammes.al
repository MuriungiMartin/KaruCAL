#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68737 "ACA-Programmes"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61511;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field("Old Code";"Old Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("School Code";"School Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'School';
                }
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Capacity";"Minimum Capacity")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Capacity";"Maximum Capacity")
                {
                    ApplicationArea = Basic;
                }
                field("Min No. of Courses";"Min No. of Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Max No. of Courses";"Max No. of Courses")
                {
                    ApplicationArea = Basic;
                }
                field("Min Pass Units";"Min Pass Units")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Grade";"Minimum Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Minimum Points";"Minimum Points")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Student Registered";"Student Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Units";"Programme Units")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Graduation Units";"Graduation Units")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Fee";"Unit Fee")
                {
                    ApplicationArea = Basic;
                }
                field("Time Table";"Time Table")
                {
                    ApplicationArea = Basic;
                }
                field("Semester Filter";"Semester Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Special Programme";"Special Programme")
                {
                    ApplicationArea = Basic;
                }
                field("Special Programme Class";"Special Programme Class")
                {
                    ApplicationArea = Basic;
                }
                field("Not Classified";"Not Classified")
                {
                    ApplicationArea = Basic;
                }
                field("Show Options on Graduation";"Show Options on Graduation")
                {
                    ApplicationArea = Basic;
                }
                field("Use Program Semesters";"Use Program Semesters")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Programme)
            {
                Caption = 'Programme';
                action(Semesters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semesters';
                    Ellipsis = true;
                    Image = Worksheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = New;
                    RunObject = Page "ACA-Programme Semesters";
                    RunPageLink = "Programme Code"=field(Code);
                }
                action(Stages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stages';
                    Ellipsis = false;
                    Image = LedgerBook;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;
                    RunObject = Page "ACA-Programme Stages";
                    RunPageLink = "Programme Code"=field(Code);
                }
                action("Defined Graduation Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'Defined Graduation Units';
                    Ellipsis = false;
                    Image = MakeDiskette;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;
                    RunObject = Page "Aca-Acad. Year Programmes";
                    RunPageLink = "Programme Code"=field(Code);
                }
                action("New Student Charges")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Student Charges';
                    Image = CheckJournal;
                    Promoted = true;
                    RunObject = Page "ACA-New Student Charges";
                    RunPageLink = "Programme Code"=field(Code);
                }
                separator(Action1102760002)
                {
                }
                action("Release Allocation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Release Allocation';
                    Image = Worksheet;

                    trigger OnAction()
                    begin
                        TimeTable.Reset;
                        TimeTable.SetRange(TimeTable.Programme,Code);
                        if TimeTable.Find('-') then begin
                        repeat
                        TimeTable.Released:=true;
                        TimeTable.Modify;
                        until TimeTable.Next = 0;

                        end;

                        Message('Release completed successfully.');
                    end;
                }
                action("Undo Release Allocation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Undo Release Allocation';
                    Image = Worksheet;
                    Visible = false;

                    trigger OnAction()
                    begin
                        TimeTable.Reset;
                        TimeTable.SetRange(TimeTable.Programme,Code);
                        if TimeTable.Find('-') then begin
                        repeat
                        TimeTable.Released:=false;
                        TimeTable.Modify;
                        until TimeTable.Next = 0;

                        end;

                        Message('Process completed successfully.');
                    end;
                }
                separator(Action1102756000)
                {
                }
                action("Entry Subjects")
                {
                    ApplicationArea = Basic;
                    Caption = 'Entry Subjects';
                    Image = Entries;
                    Promoted = true;
                    RunObject = Page "ACA-Programme Entry Subjects";
                    RunPageLink = Programme=field(Code);
                }
                action("Admission Req. Narration")
                {
                    ApplicationArea = Basic;
                    Image = Worksheet;
                    RunObject = Page "ACA-Admission Narration";
                    RunPageLink = "Programme Code"=field(Code);
                }
                separator(Action1102755006)
                {
                }
                action("Programme Options")
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme Options';
                    Image = Worksheet;
                    RunObject = Page "ACA-Programme Option";
                    RunPageLink = "Programme Code"=field(Code);
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Category:=Category::Diploma;
    end;

    var
        TimeTable: Record UnknownRecord61540;
}

