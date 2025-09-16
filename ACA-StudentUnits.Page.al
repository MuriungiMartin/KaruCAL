#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68778 "ACA-Student Units"
{
    PageType = List;
    SourceTable = UnknownTable61549;
    SourceTableView = sorting(Stage)
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field("Year Of Study";"Year Of Study")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year (Flow)";"Academic Year (Flow)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    Editable = false;
                    Enabled = false;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Desc;Desc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    Enabled = true;
                }
                field("Exclude from Classification";"Exclude from Classification")
                {
                    ApplicationArea = Basic;
                }
                field("Special Exam";"Special Exam")
                {
                    ApplicationArea = Basic;
                }
                field("Reason for Special Exam/Susp.";"Reason for Special Exam/Susp.")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Transacton ID";"Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Type";"Unit Type")
                {
                    ApplicationArea = Basic;
                }
                field(Taken;Taken)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //IF xRec.Taken=FALSE THEN
                        //ERROR('The Course must be marked Taken!');
                        if Taken=true then begin
                        UnitsS.Reset;
                        //UnitsS.SETRANGE(UnitsS."Programme Code",Programme);
                        //UnitsS.SETRANGE(UnitsS."Stage Code",Stage);
                        UnitsS.SetRange(UnitsS.Code,Unit);
                        if UnitsS.Find('-') then begin
                        Desc:=UnitsS.Desription;
                        UnitStage:=UnitsS."Stage Code";
                        end else
                        Desc:='';
                        end;
                    end;
                }
                field("Repeat Unit";"Repeat Unit")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-sit';
                }
                field("Re-Take";"Re-Take")
                {
                    ApplicationArea = Basic;
                }
                field("Student Class";"Student Class")
                {
                    ApplicationArea = Basic;
                }
                field(UnitStage;UnitStage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Stage';
                }
                field(Audit;Audit)
                {
                    ApplicationArea = Basic;
                }
                field(Exempted;Exempted)
                {
                    ApplicationArea = Basic;
                }
                field("Final Score";"Final Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Attendance;Attendance)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("CATs Marks Exists";"CATs Marks Exists")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("EXAMs Marks Exists";"EXAMs Marks Exists")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Allow Supplementary";"Allow Supplementary")
                {
                    ApplicationArea = Basic;
                }
                field("Sat Supplementary";"Sat Supplementary")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                }
                field("Reg Reversed";"Reg Reversed")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                }
                field("Supp. Registered & Passed";"Supp. Registered & Passed")
                {
                    ApplicationArea = Basic;
                }
                field("No of Supplementaries";"No of Supplementaries")
                {
                    ApplicationArea = Basic;
                }
                field("Course Evaluated";"Course Evaluated")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Exempted in Evaluation";"Exempted in Evaluation")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Date created";"Date created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Edited";"Date Edited")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("System Created";"System Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created by";"Created by")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Edited By";"Edited By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year Exclude Comp.";"Academic Year Exclude Comp.")
                {
                    ApplicationArea = Basic;
                }
                field("Exists Final Stage";"Exists Final Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Student Status";"Student Status")
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
            action("UnSelect All Units")
            {
                ApplicationArea = Basic;
                Caption = 'UnSelect All Units';
                Image = SelectLineToApply;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                       StudUnits.Reset;
                       StudUnits.SetRange(StudUnits."Student No.","Student No.");
                       StudUnits.SetRange(StudUnits.Semester,Semester);
                       if StudUnits.Find('-') then begin
                       repeat
                       if StudUnits.Taken=true then begin
                           StudUnits.Taken:=false;
                           StudUnits.Modify;
                       end;
                      until StudUnits.Next=0;
                      end;
                end;
            }
            action("Delete Untaken Units")
            {
                ApplicationArea = Basic;
                Caption = 'Delete Untaken Units';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                       StudUnits.Reset;
                       StudUnits.SetRange(StudUnits."Student No.","Student No.");
                       StudUnits.SetRange(StudUnits.Semester,Semester);
                       if StudUnits.Find('-') then begin
                       repeat
                       if StudUnits.Taken=false then
                       StudUnits.Delete;
                      until StudUnits.Next=0;
                      end;
                end;
            }
            action("Print Registered Courses")
            {
                ApplicationArea = Basic;
                Caption = 'Print Registered Courses';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                       CReg.Reset;
                       CReg.SetFilter(CReg.Semester,Semester);
                       CReg.SetFilter(CReg."Student No.","Student No.");
                       if CReg.Find('-') then
                       Report.Run(51517,true,true,CReg);
                end;
            }
            action("Exam Results Review")
            {
                ApplicationArea = Basic;
                Caption = 'Exam Results Review';
                Image = CalculateCrossDock;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Exam Results View";
                RunPageLink = "Student No."=field("Student No."),
                              Unit=field(Unit);
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UnitStage:='';

        UnitsS.Reset;
        UnitsS.SetRange(UnitsS."Programme Code",Programme);
        //UnitsS.SETRANGE(UnitsS."Stage Code",Stage);
        UnitsS.SetRange(UnitsS.Code,Unit);
        if UnitsS.Find('-') then begin
        Desc:=UnitsS.Desription;
        UnitStage:=UnitsS."Stage Code";
        end else
        Desc:='';
    end;

    var
        UnitsS: Record UnknownRecord61517;
        Desc: Text[250];
        UnitStage: Code[20];
        Prog: Record UnknownRecord61511;
        ProgDesc: Text[200];
        CReg: Record UnknownRecord61532;
        StudUnits: Record UnknownRecord61549;

    local procedure UnitOnActivate()
    begin
           if "Reg. Transacton ID"='' then begin
           CReg.Reset;
           CReg.SetRange(CReg."Student No.","Student No.");
           if CReg.Find('-') then begin
           "Reg. Transacton ID":=CReg."Reg. Transacton ID";
           Programme:=CReg.Programme;
           Stage :=CReg.Stage;
           Semester:=CReg.Semester;
           end;
           end;

        UnitsS.Reset;
        //UnitsS.SETRANGE(UnitsS."Programme Code",Programme);
        //UnitsS.SETRANGE(UnitsS."Stage Code",Stage);
        UnitsS.SetRange(UnitsS.Code,Unit);
        if UnitsS.Find('-') then begin
        Desc:=UnitsS.Desription;
        UnitStage:=UnitsS."Stage Code";
        end else
        Desc:='';
    end;
}

