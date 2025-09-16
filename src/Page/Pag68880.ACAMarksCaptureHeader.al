#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68880 "ACA-Marks Capture Header"
{

    layout
    {
        area(content)
        {
            field(lectNo;lectNo)
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer No.';

                trigger OnValidate()
                begin
                      lectName:='';
                      if empl.Get(lectNo) then
                      lectName:=empl."First Name"+' '+empl."Middle Name"+' '+empl."Last Name"
                      else Error('Lecturer Code not found');
                end;
            }
            field(Passwords;Passwords)
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer Password';
                ExtendedDatatype = Masked;
                HideValue = true;

                trigger OnValidate()
                begin
                    /*
                    PassOk:=FALSE;
                    IF empl.GET(lectNo) THEN BEGIN
                    IF Passwords <> empl."Portal Password" THEN
                    ERROR('Incorrect password. Passwords are case sensitive.')
                    ELSE
                    PassOk:=TRUE;
                    
                    END;
                        */

                end;
            }
            field(lectName;lectName)
            {
                ApplicationArea = Basic;
                Caption = 'Lecturer Name';
                Editable = false;
            }
            field(Prog;Prog)
            {
                ApplicationArea = Basic;
                Caption = 'Program/Course';
                TableRelation = "ACA-Programme".Code;

                trigger OnValidate()
                var
                    programme: Record UnknownRecord61511;
                begin
                    validate_Password;
                    Clear(examCat);
                    programme.Reset;
                    programme.SetRange(programme.Code,Prog);
                    if programme.Find('-') then begin
                      programme.TestField(programme."Exam Category");
                    examCat:=programme."Exam Category";
                    end;

                    CurrPage.Update;
                end;
            }
            field(examCat;examCat)
            {
                ApplicationArea = Basic;
                Caption = 'Exam Category';
                Editable = false;
            }
            field(Semez;Semez)
            {
                ApplicationArea = Basic;
                Caption = 'Semester';
                TableRelation = "ACA-Semesters".Code;

                trigger OnValidate()
                begin
                         validate_Password;
                         CurrPage.Update;
                end;
            }
            field(AcadYear;AcadYear)
            {
                ApplicationArea = Basic;
                Caption = 'Academic Year';
                TableRelation = "ACA-Academic Year".Code;

                trigger OnValidate()
                begin
                       validate_Password;
                       CurrPage.Update;
                end;
            }
            field(Units;Units)
            {
                ApplicationArea = Basic;
                Caption = 'Unit/Subject';
                TableRelation = "ACA-Units/Subjects".Code;

                trigger OnValidate()
                begin
                      if lectNo='' then Error('Input a staff number.');
                      if Passwords='' then Error('Input your password.');
                      if Semez='' then Error('Specify the Semester.');
                      if AcadYear='' then Error('Specify the academic year');
                     // validate_Password;
                      Clear(SubjName);
                      unitsSubj.Reset;
                      unitsSubj.SetRange(unitsSubj.Code,Units);
                      if unitsSubj.Find('-') then
                      SubjName:=unitsSubj.Desription;

                    // Check if the lecturer can capture marks for the subject
                    lectUnits.Reset;
                    lectUnits.SetRange(lectUnits.Unit,Units);
                    lectUnits.SetRange(lectUnits.Lecturer,lectNo);
                    if not (lectUnits.Find('-')) then Error('You are not allowed to capture Marks for '+Format(SubjName));

                    Clear(UnitStage);
                    unitsSubj.Reset;
                    unitsSubj.SetRange(unitsSubj.Code,Units);
                    if unitsSubj.Find('-') then begin
                     UnitStage:=unitsSubj."Stage Code";
                    end;
                    //
                    // Populate the Students
                    populateStudents;

                    CurrPage.Update;
                end;
            }
            field(SubjName;SubjName)
            {
                ApplicationArea = Basic;
                Caption = 'Unit Name';
                Editable = false;
            }
            group(Students)
            {
                part(Control9;"ACA-Marks Capture Line")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post_Marks)
            {
                ApplicationArea = Basic;
                Caption = 'Post Marks';
                Image = PostDocument;
                Promoted = true;

                trigger OnAction()
                begin
                      if ((Prog='') or (AcadYear='') or (Semez='') or (Units='')) then Error('Enter the required Filters first.');
                      validate_Password;
                    // Check if the lecturer can capture marks for the subject
                    lectUnits.Reset;
                    lectUnits.SetRange(lectUnits.Unit,Units);
                    lectUnits.SetRange(lectUnits.Lecturer,lectNo);
                    if not (lectUnits.Find('-')) then Error('You are not allowed to capture Marks for '+Format(SubjName));


                        if Confirm('Post marks?',true)=false then exit;
                       postScores();
                      Message('Marks Posted successfully');
                end;
            }
        }
    }

    var
        Prog: Code[30];
        AcadYear: Code[20];
        Semez: Code[20];
        Units: Code[20];
        lectNo: Code[30];
        Passwords: Code[30];
        lectUnits: Record UnknownRecord61541;
        SubjName: Code[250];
        unitsSubj: Record UnknownRecord61517;
        examCat: Code[30];
        UnitStage: Code[20];
        lectName: Code[250];
        empl: Record UnknownRecord61188;
        PassOk: Boolean;


    procedure validate_Password()
    var
        employee: Record UnknownRecord61188;
    begin
        // // IF ((lectNo='') OR (Passwords='')) THEN BEGIN
        // // //ERROR('Please enter your no. and password.');
        // // END;
        // // CLEAR(lectName);
        // // employee.RESET;
        // // employee.SETRANGE(employee."No.",lectNo);
        // // employee.SETRANGE(employee."Portal Password",Passwords);
        // // IF NOT (employee.FIND('-')) THEN ERROR('The employee number or password is incorect.')
        // // ELSE
        // // lectName:=employee."First Name"+' '+employee."Middle Name"+' '+employee."Last Name";
    end;


    procedure populateStudents()
    var
        CourseReg: Record UnknownRecord61532;
        studUnits: Record UnknownRecord61549;
        MarksCapture: Record UnknownRecord61702;
        Examres: Record UnknownRecord61548;
    begin
        // Delete Existing Data
        MarksCapture.Reset;
        if MarksCapture.Find('-') then
          MarksCapture.DeleteAll;

        studUnits.Reset;
        studUnits.SetRange(studUnits.Unit,Units);
        studUnits.SetRange(studUnits.Semester,Semez);
        studUnits.SetRange(studUnits."Academic Year",AcadYear);
        if studUnits.Find('-') then begin
          repeat
            begin
              MarksCapture.Reset;
              MarksCapture.SetRange(MarksCapture."Student No.",studUnits."Student No.");
              MarksCapture.SetRange(MarksCapture."Academic Year",AcadYear);
              MarksCapture.SetRange(MarksCapture.Semester,Semez);
              MarksCapture.SetRange(MarksCapture."Unit Code",Units);
              MarksCapture.SetRange(MarksCapture."Programme Code",Prog);
              if not (MarksCapture.Find('-')) then begin
                 // Insert
                MarksCapture.Init;
                MarksCapture."Student No.":=studUnits."Student No.";
                MarksCapture."Academic Year":=AcadYear;
                MarksCapture.Semester:=Semez;
                MarksCapture."Unit Code":=Units;
                MarksCapture."Programme Code":=Prog;
                MarksCapture."Reg. Trans Id":=studUnits."Reg. Transacton ID";
                MarksCapture.Insert;
              end;
            end;
          until studUnits.Next=0;
        end;

        // Update Scores
              MarksCapture.Reset;
             // MarksCapture.SETRANGE(MarksCapture."Student No.",studUnits."Student No.");
              MarksCapture.SetRange(MarksCapture."Academic Year",AcadYear);
              MarksCapture.SetRange(MarksCapture.Semester,Semez);
              MarksCapture.SetRange(MarksCapture."Unit Code",Units);
              MarksCapture.SetRange(MarksCapture."Programme Code",Prog);
              if MarksCapture.Find('-') then begin
                repeat
                  begin
                    Examres.Reset;
                    Examres.SetRange(Examres."Student No.",MarksCapture."Student No.");
                    Examres.SetRange(Examres.Programme,MarksCapture."Programme Code");
                    Examres.SetRange(Examres.Unit,MarksCapture."Unit Code");
                    Examres.SetRange(Examres.Semester,MarksCapture.Semester);
                    Examres.SetRange(Examres."Reg. Transaction ID",MarksCapture."Reg. Trans Id");
                    if Examres.Find('-') then
                    begin
                      repeat
                        begin
                         if Examres.Exam='CAT1' then begin
                         MarksCapture."CAT 1":=Examres.Score;
                         MarksCapture.Modify;
                         end;
                         if Examres.Exam='CAT2' then begin
                         MarksCapture."CAT 2":=Examres.Score;
                         MarksCapture.Modify;
                         end;
                         if Examres.Exam='EXAM' then begin
                         MarksCapture.Exam:=Examres.Score;
                         MarksCapture.Modify;
                         end;
                        end;
                      until Examres.Next=0;
                    end;
                  end;
                until MarksCapture.Next=0;
              end;
    end;


    procedure postScores()
    var
        Examres: Record UnknownRecord61548;
        MarksCapture: Record UnknownRecord61702;
    begin
              MarksCapture.Reset;
             // MarksCapture.SETRANGE(MarksCapture."Student No.",studUnits."Student No.");
              MarksCapture.SetRange(MarksCapture."Academic Year",AcadYear);
              MarksCapture.SetRange(MarksCapture.Semester,Semez);
              MarksCapture.SetRange(MarksCapture."Unit Code",Units);
              MarksCapture.SetRange(MarksCapture."Programme Code",Prog);
              if MarksCapture.Find('-') then begin
                repeat
              //  if ((MarksCapture."CAT 1"+MarksCapture."CAT 2"+MarksCapture.Exam)>0)
                  begin
                    Examres.Reset;
                    Examres.SetRange(Examres."Student No.",MarksCapture."Student No.");
                    Examres.SetRange(Examres.Programme,MarksCapture."Programme Code");
                    Examres.SetRange(Examres.Unit,MarksCapture."Unit Code");
                    Examres.SetRange(Examres.Semester,MarksCapture.Semester);
                    Examres.SetRange(Examres."Reg. Transaction ID",MarksCapture."Reg. Trans Id");
                    if Examres.Find('-') then Examres.DeleteAll;
                    // Insert New
                    Examres.Init;
                    Examres."Student No.":=MarksCapture."Student No.";
                    Examres.Programme:=MarksCapture."Programme Code";
                    Examres.Stage:=UnitStage;
                    Examres.Unit:=Units;
                    Examres.Semester:=Semez;
                    Examres."Reg. Transaction ID" :=MarksCapture."Reg. Trans Id";
                    Examres.Score:=MarksCapture.Exam;
                    Examres.Exam :='EXAM';
                    Examres.ExamType:='EXAM';
                    Examres."Exam Category":=examCat;
                    Examres."Admission No":=MarksCapture."Student No.";
                    Examres."Lecturer Names":=lectName;
                    Examres.Category:=examCat;
                    Examres.Insert;

                    Examres.Init;
                    Examres."Student No.":=MarksCapture."Student No.";
                    Examres.Programme:=MarksCapture."Programme Code";
                    Examres.Stage:=UnitStage;
                    Examres.Unit:=Units;
                    Examres.Semester:=Semez;
                    Examres."Reg. Transaction ID" :=MarksCapture."Reg. Trans Id";
                    Examres.Score:=MarksCapture."CAT 1";
                    Examres.Exam :='CAT1';
                    Examres.ExamType:='CAT1';
                    Examres."Exam Category":=examCat;
                    Examres."Admission No":=MarksCapture."Student No.";
                    Examres."Lecturer Names":=lectName;
                    Examres.Category:=examCat;
                    Examres.Insert;

                    Examres.Init;
                    Examres."Student No.":=MarksCapture."Student No.";
                    Examres.Programme:=MarksCapture."Programme Code";
                    Examres.Stage:=UnitStage;
                    Examres.Unit:=Units;
                    Examres.Semester:=Semez;
                    Examres."Reg. Transaction ID" :=MarksCapture."Reg. Trans Id";
                    Examres.Score:=MarksCapture."CAT 2";
                    Examres.Exam :='CAT2';
                    Examres.ExamType:='CAT2';
                    Examres."Exam Category":=examCat;
                    Examres."Admission No":=MarksCapture."Student No.";
                    Examres."Lecturer Names":=lectName;
                    Examres.Category:=examCat;
                    Examres.Insert;


                  end;
                until MarksCapture.Next=0;
              end;
    end;
}

