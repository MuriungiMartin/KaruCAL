#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68785 "ACA-Course Registration New"
{
    AutoSplitKey = true;
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61532;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Reg. Transacton ID";"Reg. Transacton ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                            // BKK
                            CReg.Reset;
                            CReg.SetRange(CReg."Student No.","Student No.");
                            CReg.SetRange(CReg.Programme,Programme);
                            CReg.SetRange(CReg.Stage,Stage);
                            if CReg.Find('-') then begin
                               Error('Stage '+CReg.Stage+' Already Exist For This Student')
                            end;
                    end;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                }
                field(ProgDesc;ProgDesc)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                }
                field(Options;Options)
                {
                    ApplicationArea = Basic;
                }
                field("Registration Date";"Registration Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reg. Date';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Registered;Registered)
                {
                    ApplicationArea = Basic;
                }
                field(Session;Session)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                    OptionCaption = '<Full Time,Evening,Sandwich>';
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Units Taken";"Units Taken")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Re-sits";"Re-sits")
                {
                    ApplicationArea = Basic;
                }
                field(Transfered;Transfered)
                {
                    ApplicationArea = Basic;
                }
                field("Units Passed";"Units Passed")
                {
                    ApplicationArea = Basic;
                }
                field("Units Failed";"Units Failed")
                {
                    ApplicationArea = Basic;
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Grade";"Exam Grade")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Exam Status";"Exam Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Attending Classes";"Attending Classes")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(Remarks;Remarks)
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
            action("Print Registered Courses")
            {
                ApplicationArea = Basic;
                Caption = 'Print Registered Courses';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                       CReg.Reset;
                       CReg.SetFilter(CReg.Semester,Semester);
                       CReg.SetFilter(CReg."Student No.","Student No.");
                       CReg.SetFilter(CReg."Reg. Transacton ID","Reg. Transacton ID");
                       if CReg.Find('-') then
                       Report.Run(39005951,true,true,CReg);
                end;
            }
            action(SuppExams)
            {
                ApplicationArea = Basic;
                Caption = 'Supplementary Examinations';
                Image = RegisteredDocs;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Supp. Exams Details List";
                RunPageLink = "Student No."=field("Student No.");
                RunPageView = where(Category=filter(Supplementary));
            }
            action(SpecialExamsReg)
            {
                ApplicationArea = Basic;
                Caption = 'Special Examination Reg.';
                Image = RegisterPick;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Special Exams Details List";
                RunPageLink = "Student No."=field("Student No.");
                RunPageView = where("Total Marks"=filter(1));
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ProgDesc:='';
        if Prog.Get(Programme) then
        ProgDesc:=Prog.Description;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        if "Attending Classes" = true then
        //ERROR('Transaction once posted cannot be modified.');

        if Posted = true then
;

    trigger OnInit()
    begin
        ProgDesc:='';
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if "Attending Classes" = true then
        //ERROR('Transaction once posted cannot be modified.');

        if Posted = true then
;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ProgDesc:='';
    end;

    var
        Prog: Record UnknownRecord61511;
        ProgDesc: Text[200];
        CReg: Record UnknownRecord61532;

    local procedure OnBeforePutRecord()
    begin
        ProgDesc:='';
    end;
}

