#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68710 "ACA-Units/Subject List"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61517;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                }
                field("Stage Code";"Stage Code")
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Desription;Desription)
                {
                    ApplicationArea = Basic;
                }
                field("Reserved Room";"Reserved Room")
                {
                    ApplicationArea = Basic;
                }
                field("Credit Hours";"Credit Hours")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account";"G/L Account")
                {
                    ApplicationArea = Basic;
                }
                field("Ignore in Final Average";"Ignore in Final Average")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Filter";"Programme Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Stage Filter";"Stage Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Filter";"Unit Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Semester Filter";"Semester Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Lecture Room Filter";"Lecture Room Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Total Income";"Total Income")
                {
                    ApplicationArea = Basic;
                }
                field("Students Registered";"Students Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Type";"Unit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Class Filter";"Class Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field("Day Filter";"Day Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Class Filter";"Unit Class Filter")
                {
                    ApplicationArea = Basic;
                }
                field(Allocation;Allocation)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Filter";"Exam Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Date";"Exam Date")
                {
                    ApplicationArea = Basic;
                }
                field(Tested;Tested)
                {
                    ApplicationArea = Basic;
                }
                field(Prerequisite;Prerequisite)
                {
                    ApplicationArea = Basic;
                }
                field("Lesson Filter";"Lesson Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Common Unit";"Common Unit")
                {
                    ApplicationArea = Basic;
                }
                field("No. Units";"No. Units")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Option";"Programme Option")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. ID Filter";"Reg. ID Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Student No. Filter";"Student No. Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Registered";"Unit Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Re-Sit";"Re-Sit")
                {
                    ApplicationArea = Basic;
                }
                field(Audit;Audit)
                {
                    ApplicationArea = Basic;
                }
                field(Submited;Submited)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Status";"Exam Status")
                {
                    ApplicationArea = Basic;
                }
                field("Printed Copies";"Printed Copies")
                {
                    ApplicationArea = Basic;
                }
                field("Issued Copies";"Issued Copies")
                {
                    ApplicationArea = Basic;
                }
                field("Returned Copies";"Returned Copies")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Remarks";"Exam Remarks")
                {
                    ApplicationArea = Basic;
                }
                field("Details Count";"Details Count")
                {
                    ApplicationArea = Basic;
                }
                field("Not Allocated";"Not Allocated")
                {
                    ApplicationArea = Basic;
                }
                field("Timetable Priority";"Timetable Priority")
                {
                    ApplicationArea = Basic;
                }
                field("Normal Slots";"Normal Slots")
                {
                    ApplicationArea = Basic;
                }
                field("Lab Slots";"Lab Slots")
                {
                    ApplicationArea = Basic;
                }
                field("Slots Varience";"Slots Varience")
                {
                    ApplicationArea = Basic;
                }
                field("Time Table";"Time Table")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Not Allocated";"Exam Not Allocated")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Slots Varience";"Exam Slots Varience")
                {
                    ApplicationArea = Basic;
                }
                field(Show;Show)
                {
                    ApplicationArea = Basic;
                }
                field("Estimate Reg";"Estimate Reg")
                {
                    ApplicationArea = Basic;
                }
                field("Exams Done";"Exams Done")
                {
                    ApplicationArea = Basic;
                }
                field("Default Exam Category";"Default Exam Category")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Name";"Programme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Lecturer Code";"Lecturer Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("New Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Units';
                    RunObject = Page "ACA-Units/Subjects";
                    RunPageLink = "New Unit"=filter(true);
                }
                separator(Action1000000119)
                {
                }
                action("Edit Units")
                {
                    ApplicationArea = Basic;
                    Caption = 'Edit Units';
                    RunObject = Page "ACA-Units/Subjects";
                }
            }
        }
    }
}

