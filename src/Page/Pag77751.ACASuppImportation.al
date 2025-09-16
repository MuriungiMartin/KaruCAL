#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77751 "ACA-Supp. Importation"
{
    PageType = List;
    SourceTable = UnknownTable78030;

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
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Exam Score";"Exam Score")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Description";"Unit Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Unit Reg. Semester";"Unit Reg. Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Reg. Academic Year";"Unit Reg. Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Reg. Stage";"Unit Reg. Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Registered";"Unit Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Unit In Catalogue";"Unit In Catalogue")
                {
                    ApplicationArea = Basic;
                }
                field("Student Exists";"Student Exists")
                {
                    ApplicationArea = Basic;
                }
                field("Prog. Unit Stage";"Prog. Unit Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Prog Unit Stage Reg. Semester";"Prog Unit Stage Reg. Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Prog Unit Stage Reg. Academic";"Prog Unit Stage Reg. Academic")
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
            action(Posts)
            {
                ApplicationArea = Basic;
                Caption = 'Post Imports';
                Image = AddToHome;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Check and register the Units
                    if Confirm('Post?',true)=false then Error('Cancelled!');
                    ACASuppImportation.Reset;
                    ACASuppImportation.SetRange(Posted,false);
                    if ACASuppImportation.Find('-') then begin
                      repeat
                        begin
                        ACAProgramme.Reset;
                        ACAProgramme.SetRange(Code,ACASuppImportation.Programme);
                        if ACAProgramme.Find('-') then;
                        ACASuppImportation.CalcFields("Unit Reg. Academic Year","Unit In Catalogue","Unit Reg. Semester","Unit Reg. Stage","Unit Registered",
                        "Student Exists","Prog. Unit Stage","Prog Unit Stage Reg. Academic","Prog Unit Stage Reg. Semester","Unit Description");
                        if ((ACASuppImportation."Unit In Catalogue") and (ACASuppImportation."Student Exists") and (ACASuppImportation."Unit Registered")) then begin
                    AcaSpecialExamsDetails.Init;
                    AcaSpecialExamsDetails."Student No.":=ACASuppImportation."Student No.";
                    AcaSpecialExamsDetails."Unit Code":=ACASuppImportation."Unit Code";
                    AcaSpecialExamsDetails."Academic Year":=ACASuppImportation."Unit Reg. Academic Year";
                    AcaSpecialExamsDetails.Semester:=ACASuppImportation."Unit Reg. Semester";
                    AcaSpecialExamsDetails.Stage:=ACASuppImportation."Unit Reg. Stage";
                    AcaSpecialExamsDetails.Programme:=ACASuppImportation.Programme;
                    AcaSpecialExamsDetails."Exam Marks":=ACASuppImportation."Exam Score";
                    AcaSpecialExamsDetails."Current Academic Year":=ACASuppImportation."Unit Reg. Academic Year";
                    if AcaSpecialExamsDetails.Insert then;
                    ///////////////////////////////////////////////////
                    AcaSpecialExamsResults.Init;
                    AcaSpecialExamsResults.Programme:=ACASuppImportation.Programme;
                    AcaSpecialExamsResults.Stage:=ACASuppImportation."Unit Reg. Stage";
                    AcaSpecialExamsResults.Semester:=ACASuppImportation."Unit Reg. Semester";
                    AcaSpecialExamsResults."Student No.":=ACASuppImportation."Student No.";
                    AcaSpecialExamsResults.Unit:=ACASuppImportation."Unit Code";
                    AcaSpecialExamsResults."Academic Year":=ACASuppImportation."Unit Reg. Academic Year";
                    AcaSpecialExamsResults.Score:=ACASuppImportation."Exam Score";
                    AcaSpecialExamsResults.Exam:='FINAl EXAM';
                    AcaSpecialExamsResults."Exam Category":=ACAProgramme."Exam Category";
                    AcaSpecialExamsResults.ExamType:='FINAl EXAM';
                    AcaSpecialExamsResults."Admission No":=ACASuppImportation."Student No.";
                    AcaSpecialExamsResults.Catogory:=AcaSpecialExamsResults.Catogory::Supplementary;
                    AcaSpecialExamsResults."Current Academic Year":=ACASuppImportation."Unit Reg. Academic Year";
                    AcaSpecialExamsResults."Modified Date":=Today;
                    AcaSpecialExamsResults."Capture Date":=Today;
                    if AcaSpecialExamsResults.Insert then;


                    AcaSpecialExamsResults.SetRange(Programme,ACASuppImportation.Programme);
                    AcaSpecialExamsResults.SetRange(Stage,ACASuppImportation."Unit Reg. Stage");
                    AcaSpecialExamsResults.SetRange(Semester,ACASuppImportation."Unit Reg. Semester");
                    AcaSpecialExamsResults.SetRange("Student No.",ACASuppImportation."Student No.");
                    AcaSpecialExamsResults.SetRange(Unit,ACASuppImportation."Unit Code");
                    AcaSpecialExamsResults.SetRange("Academic Year",ACASuppImportation."Unit Reg. Academic Year");
                    if AcaSpecialExamsResults.Find('-') then begin
                      AcaSpecialExamsResults.Validate(Score);
                      AcaSpecialExamsResults.Modify;
                      end;

                    ///////////////////////////////////////////////////
                    ACASuppImportation.Posted:=true;
                    ACASuppImportation.Modify;
                    end;
                        end;
                        until ACASuppImportation.Next=0;
                      end;
                      Message('Posted!');
                end;
            }
        }
    }

    var
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        AcaSpecialExamsResults: Record UnknownRecord78003;
        ACASuppImportation: Record UnknownRecord78030;
        ACAProgramme: Record UnknownRecord61511;
}

