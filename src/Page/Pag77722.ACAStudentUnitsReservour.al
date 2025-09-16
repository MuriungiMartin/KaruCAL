#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77722 "ACA-Student Units Reservour"
{
    PageType = List;
    SourceTable = UnknownTable77722;
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
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
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
                field("Special Exam";"Special Exam")
                {
                    ApplicationArea = Basic;
                }
                field("Reason for Special Exam";"Reason for Special Exam")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. Transacton ID";"Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
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
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                }
                field("Reg Reversed";"Reg Reversed")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
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

