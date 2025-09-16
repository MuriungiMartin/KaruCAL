#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77717 "Process Graduation Params"
{
    PageType = Card;
    SourceTable = UnknownTable61511;
    SourceTableView = where(Code=filter(A100));

    layout
    {
        area(content)
        {
            group(ProgrammeFil)
            {
                Caption = 'Programme Filter';
                field(Schools;Schools)
                {
                    ApplicationArea = Basic;
                    Caption = 'School Filter';
                    TableRelation = "Dimension Value".Code where ("Dimension Code"=filter('SCHOOL'));
                }
                field(progy;programs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme';
                    TableRelation = "ACA-Programme".Code;
                }
                field(AcaYears;AcadYears)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    TableRelation = "ACA-Academic Year".Code;
                }
                field(vo;UnitCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Code';
                }
                field(StudNo;StudNos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Student No';
                    TableRelation = Customer."No." where ("Customer Posting Group"=filter('STUDENT'));

                    trigger OnValidate()
                    begin
                        UpdateAcadYear(programs);
                          CurrPage.Update;
                    end;
                }
                field(v;GradAcademicYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grad. Academic Year';
                    Editable = false;
                    Enabled = false;
                    TableRelation = "ACA-Academic Year".Code;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(ProcessGraduation)
            {
                ApplicationArea = Basic;
                Caption = 'Process Graduation';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Aca2ndSpecialExamsDetails: Record UnknownRecord78031;
                    ACAUnitsSubjects693: Record UnknownRecord61517;
                    AcaSpecialExamsResults333: Record UnknownRecord78003;
                    ACAGradfuationGroups: Record "ACA-Graduation Groups";
                    ClassCourseRegistration: Record UnknownRecord61532;
                    CourseRegistration666: Record UnknownRecord61532;
                    ClassStudentUnits: Record UnknownRecord61549;
                    ClassUnitsSubjects: Record UnknownRecord61517;
                    ClassProgramme: Record UnknownRecord61511;
                    ClassProgrammeStages: Record UnknownRecord61516;
                    ClassAcademicYear: Record UnknownRecord61382;
                    ClassSemesters: Record UnknownRecord61692;
                    ClassExamResults: Record UnknownRecord61548;
                    ClassSpecialExamsDetails: Record UnknownRecord78002;
                    ClassCustomer: Record Customer;
                    ClassClassificationStudents: Record UnknownRecord66630;
                    ClassClassificationCourseReg: Record UnknownRecord66631;
                    ClassClassificationUnits: Record UnknownRecord66632;
                    ClassExamResultsBuffer2: Record UnknownRecord61746;
                    ClassDimensionValue: Record "Dimension Value";
                    ClassGradingSystem: Record UnknownRecord61521;
                    ClassClassGradRubrics: Record UnknownRecord78011;
                    ClassExamResults2: Record UnknownRecord61548;
                    TotalRecs: Integer;
                    CountedRecs: Integer;
                    RemeiningRecs: Integer;
                    ACAClassificationStudentsCheck: Record UnknownRecord66630;
                    ACANotGraduatingReasons: Record UnknownRecord66633;
                    ExpectedElectives: Integer;
                    CountedElectives: Integer;
                    ProgBar2: Dialog;
                    Progyz: Record UnknownRecord61511;
                    ACADefinedUnitsperYoS: Record UnknownRecord78017;
                    Total_First_Year_Courses: Integer;
                    Total_First_Year_Marks: Decimal;
                    New_Total_Marks: Decimal;
                    New_Total_Courses: Integer;
                    New_Classifiable_Average: Decimal;
                    ExistsOption: Option " ","Both Exists","CAT Only","Exam Only","None Exists";
                    AcaSpecialExamsDetails: Record UnknownRecord78002;
                    AcaSpecialExamsResults: Record UnknownRecord78003;
                    NewScore: Decimal;
                    Aca2ndSuppExamsResults: Record UnknownRecord78032;
                    StudUnitsForExclude: Record UnknownRecord61549;
                begin
                    ExamsProcessing.MarksPermissions(UserId);
                    if Confirm('Process Graduation?',true)=false then Error('Cancelled by user!');
                    if ((programs='') and (Schools='')) then  Error('Specify at least a programm or a school on the filters!');
                    Clear(ProgFIls);
                    Clear(ProgList);
                    ProgList.Reset;
                    if Schools <> '' then
                      ProgList.SetFilter("School Code",Schools)
                    else if programs<>'' then
                      ProgList.SetFilter(Code,programs);
                    if ProgList.Find('-') then begin
                      repeat
                        begin
                        // Check if for all the Programs within the filter, the final stage have been defined
                    Clear(ACAProgramme963);
                      ACAProgramme963.Reset;
                      ACAProgramme963.SetFilter(ACAProgramme963.Code,ProgList.Code);
                      if ACAProgramme963.Find('-') then begin
                        repeat
                          begin
                          ACAProgrammeStages.Reset;
                          ACAProgrammeStages.SetRange("Programme Code",ACAProgramme963.Code);
                          ACAProgrammeStages.SetRange("Final Stage",true);
                          if not ACAProgrammeStages.Find('-') then begin
                            ACACourseRegistration.Reset;
                            ACACourseRegistration.SetRange(Programme,ACAProgramme963.Code);
                            ACACourseRegistration.SetFilter(Status,'%1|%2|%3',ACACourseRegistration.Status::Current,ACACourseRegistration.Status::Registration,ACACourseRegistration.Status::Deceased);
                            if ACACourseRegistration.Find('-') then Error('Programme '''+ACAProgramme963.Code+''' has no defined Final Stage');
                            end;
                          end;
                            until ACAProgramme963.Next=0;
                            end;
                        end;
                          until ProgList.Next = 0;
                          end;

                    if ProgList.Find('-') then begin
                      repeat
                        begin

                          Clear(ACAProgrammeYearsofStudy);
                          ACAProgrammeYearsofStudy.Reset;
                          ACAProgrammeYearsofStudy.SetRange("Programme Code",ProgList.Code);
                          if not ACAProgrammeYearsofStudy.Find('-') then Error('Academic Years Missing!');
                        Clear(ProgFIls);
                        ProgFIls:=ProgList.Code;
                        Clear(ClassStudentUnits);
                    ClassStudentUnits.Reset;
                    //ClassStudentUnits.SETFILTER("Unit is Old",'%1',FALSE);
                    //ClassStudentUnits.SETFILTER(Status,'%1|%2|%3',ClassStudentUnits."Registration Status"::Specials,ClassStudentUnits."Registration Status"::" ",ClassStudentUnits."Registration Status"::"9");

                    Clear(TotalRecs);
                    Clear(RemeiningRecs);
                    Clear(CountedRecs);
                    // Clear CLassification For Selected Filters
                    ClassClassificationStudents.Reset;
                    ClassClassificationCourseReg.Reset;
                    ClassClassificationUnits.Reset;
                    ClassClassificationStudents.SetRange("Graduation Academic Year",GradAcademicYear);
                    ClassClassificationCourseReg.SetRange("Graduation Academic Year",GradAcademicYear);
                    ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                    if Schools <> '' then begin
                    ClassClassificationStudents.SetFilter("School Code",Schools);
                    ClassClassificationCourseReg.SetFilter("School Code",Schools);
                    ClassClassificationUnits.SetFilter("School Code",Schools);
                      end else if programs <> '' then begin
                    ClassClassificationStudents.SetFilter(Programme,programs);
                    ClassClassificationCourseReg.SetFilter(Programme,programs);
                    ClassClassificationUnits.SetFilter(Programme,programs);
                        end else if StudNos <> '' then begin
                    ClassClassificationStudents.SetFilter("Student Number",StudNos);
                    ClassClassificationCourseReg.SetFilter("Student Number",StudNos);
                    ClassClassificationUnits.SetFilter("Student No.",StudNos);
                          end;
                    if ClassClassificationStudents.Find('-') then ClassClassificationStudents.DeleteAll;
                    if ClassClassificationCourseReg.Find('-') then ClassClassificationCourseReg.DeleteAll;
                    if ClassClassificationUnits.Find('-') then ClassClassificationUnits.DeleteAll;

                    // Populate Classification Tables Here
                    if StudNos<>'' then
                    ClassStudentUnits.SetFilter("Student No.",StudNos) else
                    ClassStudentUnits.SetFilter(Programme,ProgFIls);
                    ClassStudentUnits.SetFilter("Academic Year (Flow)",AcadYears);
                    ClassStudentUnits.SetFilter("Exists Final Stage",'%1',true);
                    ClassStudentUnits.SetFilter("Reg. Reversed",'%1',false);
                    ClassStudentUnits.SetFilter("Student Status",'%1|%2',ClassStudentUnits."student status"::Current,ClassStudentUnits."student status"::Registration);
                    if ClassStudentUnits.Find('-') then begin
                    TotalRecs:=ClassStudentUnits.Count;
                    RemeiningRecs:=TotalRecs;
                      // Loop through all the Units Reg. for the Students that are Finalists Populating the Classification tables
                      Progressbar.Open('#1#####################################################\'+
                      '#2############################################################\'+
                      '#3###########################################################\'+
                      '#4############################################################\'+
                      '#5###########################################################\'+
                      '#6############################################################');
                         Progressbar.Update(1,'Processing Graduation values....');
                         Progressbar.Update(2,'Total Recs.: '+Format(TotalRecs));
                      repeat
                      begin
                      ClassStudentUnits.CalcFields("Prog. Category");
                    CountedRecs:=CountedRecs+1;
                    RemeiningRecs:=RemeiningRecs-1;
                        // Create Registration Unit entry if Not Exists
                         Progressbar.Update(3,'.....................................................');
                         Progressbar.Update(4,'Processed: '+Format(CountedRecs));
                         Progressbar.Update(5,'Remaining: '+Format(RemeiningRecs));
                         Progressbar.Update(6,'----------------------------------------------------');
                          //Get best CAT Marks
                          ClassStudentUnits."Unit not in Catalogue":=false;
                          ClassUnitsSubjects.Reset;
                          ClassUnitsSubjects.SetRange("Programme Code",ClassStudentUnits.Programme);
                          ClassUnitsSubjects.SetRange(Code,ClassStudentUnits.Unit);
                          if ClassUnitsSubjects.Find('-') then begin
                            ClassClassificationStudents.Reset;
                            ClassClassificationStudents.SetRange("Student Number",ClassStudentUnits."Student No.");
                            ClassClassificationStudents.SetRange(Programme,ClassStudentUnits.Programme);
                            ClassClassificationStudents.SetRange("Graduation Academic Year",GradAcademicYear);
                            if not ClassClassificationStudents.Find('-') then begin
                            ClassClassificationStudents.Init;
                            ClassClassificationStudents."Student Number":=ClassStudentUnits."Student No.";
                            ClassClassificationStudents.Programme:=ClassStudentUnits.Programme;
                            ClassClassificationStudents."Graduation Academic Year":=GradAcademicYear;
                            ClassClassificationStudents."Year of Study":=GetYearOfStudy(ClassUnitsSubjects."Stage Code");
                            ClassClassificationStudents."Program Group":=Format(ClassStudentUnits."Prog. Category");
                            if ((ClassStudentUnits."Prog. Category"=ClassStudentUnits."prog. category"::"Certificate ") or
                              (ClassStudentUnits."Prog. Category"=ClassStudentUnits."prog. category"::"Course List") or
                              (ClassStudentUnits."Prog. Category"=ClassStudentUnits."prog. category"::Professional)) then
                            ClassClassificationStudents."Program Group Order":=3
                            else if ((ClassStudentUnits."Prog. Category"=ClassStudentUnits."prog. category"::Diploma) ) then
                            ClassClassificationStudents."Program Group Order":=2
                            else  ClassClassificationStudents."Program Group Order":=1;
                         //   ClassClassificationStudents."Programme Option":=FORMAT(ClassStudentUnits."Program Option (Flow)");
                            ClassClassificationStudents.Insert;
                            end;
                            ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassStudentUnits."Student No.");
                            ClassClassificationUnits.SetRange(Programme,ClassStudentUnits.Programme);
                            ClassClassificationUnits.SetRange("Unit Code",ClassStudentUnits.Unit);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            if not ClassClassificationUnits.Find('-') then begin
                                ClassClassificationUnits.Init;
                                ClassClassificationUnits."Student No.":=ClassStudentUnits."Student No.";
                                ClassClassificationUnits.Programme:=ClassStudentUnits.Programme;
                                ClassClassificationUnits."Unit Code":=ClassStudentUnits.Unit;
                                ClassClassificationUnits."Credit Hours":=ClassUnitsSubjects."No. Units";
                                ClassClassificationUnits."Unit Type":=Format(ClassUnitsSubjects."Unit Type");
                                ClassClassificationUnits."Unit Description":=ClassUnitsSubjects.Desription;
                                ClassClassificationUnits."Year of Study":=GetYearOfStudy(ClassUnitsSubjects."Stage Code");
                                if ClassClassificationUnits."Year of Study"=0 then
                                  ClassClassificationUnits."Year of Study":=GetYearOfStudy(ClassStudentUnits.Stage);
                                if ClassClassificationUnits."Year of Study"=0 then
                                  ClassClassificationUnits."Year of Study":=GetYearOfStudy(ClassStudentUnits."Unit Stage");
                                ClassClassificationUnits."Graduation Academic Year":=GradAcademicYear;
                                if ClassClassificationUnits.Insert then;
                              end;
                            end else begin
                              ClassStudentUnits."Unit not in Catalogue":=true;
                              end;
                      ClassStudentUnits.Modify;
                      end;
                      until ClassStudentUnits.Next=0;
                      Progressbar.Close;
                    end;

                    // Populate the Academic Results agaist the Units Registered in the Graduation Units
                    ACANotGraduatingReasons.Reset;
                    ACANotGraduatingReasons.SetRange("Graduation Academic Year",GradAcademicYear);
                    Clear(TotalRecs);
                    Clear(CountedRecs);
                    Clear(RemeiningRecs);
                    Clear(ClassClassificationStudents);
                    ClassClassificationStudents.Reset;
                    ClassClassificationStudents.SetFilter("Graduation Academic Year",GradAcademicYear);
                    if StudNos<>'' then
                    ClassClassificationStudents.SetFilter("Student Number",StudNos) else
                    ClassClassificationStudents.SetFilter(Programme,ProgFIls);
                    if ClassClassificationStudents.Find('-') then begin
                      TotalRecs:=ClassClassificationStudents.Count;
                      RemeiningRecs:=TotalRecs;
                      ProgBar2.Open('#1#####################################################\'+
                      '#2############################################################\'+
                      '#3###########################################################\'+
                      '#4############################################################\'+
                      '#5###########################################################\'+
                      '#6############################################################');
                         ProgBar2.Update(1,'2 of 2 Updating Graduation Items');
                         ProgBar2.Update(2,'Total Recs.: '+Format(TotalRecs));
                        repeat
                          begin
                          // For each Record

                          ClassClassificationStudents.CalcFields("Programme Option");
                          if ACAProgrammeYearsofStudy.Find('-') then begin
                            repeat
                              begin
                              //////////////////////////////////////////////////////////////////
                              Clear(CourseRegistration666);
                              CourseRegistration666.Reset;
                              CourseRegistration666.SetRange("Year Of Study",ACAProgrammeYearsofStudy."Year of Study");
                              CourseRegistration666.SetRange("Student No.",ClassClassificationStudents."Student Number");
                              CourseRegistration666.SetRange(Programme,ClassClassificationStudents.Programme);
                              CourseRegistration666.SetRange(Reversed,false);
                              CourseRegistration666.SetRange(Options,'<>%1','');
                              if CourseRegistration666.Find('-') then;

                                ClassClassificationCourseReg.Init;
                                ClassClassificationCourseReg."Student Number":=ClassClassificationStudents."Student Number";
                                ClassClassificationCourseReg.Programme:=ClassClassificationStudents.Programme;
                                ClassClassificationCourseReg."Programme Option" :=CourseRegistration666.Options;
                                ClassClassificationCourseReg."Year of Study":=ACAProgrammeYearsofStudy."Year of Study";
                                ClassClassificationCourseReg."Graduation Academic Year":=GradAcademicYear;
                                ClassClassificationCourseReg.Insert;

                    //      ACADefinedUnitsperYoS.RESET;
                    //      ACADefinedUnitsperYoS.SETRANGE(Programme,ClassClassificationStudents.Programme);
                    //      ACADefinedUnitsperYoS.SETRANGE("Academic Year",ClassClassificationStudents."Graduation Academic Year");
                    //      ACADefinedUnitsperYoS.SETRANGE(Options,ClassClassificationStudents."Programme Option");
                    //      IF ACADefinedUnitsperYoS.FIND('-') THEN BEGIN
                    //        REPEAT
                    //          BEGIN
                    //        ClassClassificationCourseReg.RESET;
                    //        ClassClassificationCourseReg.SETRANGE("Student Number",ClassClassificationStudents."Student Number");
                    //        ClassClassificationCourseReg.SETRANGE(Programme,ClassClassificationStudents.Programme);
                    //        ClassClassificationCourseReg.SETRANGE("Year of Study",ACADefinedUnitsperYoS."Year of Study");
                    //        ClassClassificationCourseReg.SETRANGE("Graduation Academic Year",GradAcademicYear);
                    //        IF NOT ClassClassificationCourseReg.FIND('-') THEN BEGIN
                    //            ClassClassificationCourseReg.INIT;
                    //            ClassClassificationCourseReg."Student Number":=ClassClassificationStudents."Student Number";
                    //            ClassClassificationCourseReg.Programme:=ClassClassificationStudents.Programme;
                    //            ClassClassificationCourseReg."Year of Study":=ACADefinedUnitsperYoS."Year of Study";
                    //            ClassClassificationCourseReg."Graduation Academic Year":=GradAcademicYear;
                    //            ClassClassificationCourseReg.INSERT;
                    //          END;
                    //          END;
                    //          UNTIL ACADefinedUnitsperYoS.NEXT=0;
                    //          END;
                              ////////////////////////////////////////////////////////////////////////////
                              end;
                              until ACAProgrammeYearsofStudy.Next = 0;
                            end;

                    ACANotGraduatingReasons.SetRange("Student No.",ClassClassificationStudents."Student Number");
                    if ACANotGraduatingReasons.Find('-') then ACANotGraduatingReasons.DeleteAll;
                          CountedRecs+=1;
                          RemeiningRecs-=1;
                         ProgBar2.Update(3,'.....................................................');
                         ProgBar2.Update(4,'Processed: '+Format(CountedRecs));
                         ProgBar2.Update(5,'Remaining: '+Format(RemeiningRecs));
                         ProgBar2.Update(6,'----------------------------------------------------');
                         if Progyz.Get(ClassClassificationStudents.Programme) then begin
                           ClassClassificationStudents.Department:=Progyz."Department Code";
                           ClassClassificationStudents."School Code":=Progyz."School Code";
                           end;
                          ClassClassificationStudents."School Name":=GetDepartmentNameOrSchool(ClassClassificationStudents."School Code");
                          ClassClassificationStudents."Student Name":=GetStudentName(ClassClassificationStudents."Student Number");
                          ClassClassificationStudents.Cohort:=GetCohort(ClassClassificationStudents."Student Number",ClassClassificationStudents.Programme);
                          ClassClassificationStudents."Final Stage":=GetFinalStage(ClassClassificationStudents.Programme);
                          ClassClassificationStudents."Final Academic Year":=GetFinalAcademicYear(ClassClassificationStudents."Student Number",ClassClassificationStudents.Programme);
                          ClassClassificationStudents."Final Year of Study":=GetFinalYearOfStudy(ClassClassificationStudents.Programme);
                          ClassClassificationStudents."Admission Date":=GetAdmissionDate(ClassClassificationStudents."Student Number",ClassClassificationStudents.Programme);
                          ClassClassificationStudents."Admission Academic Year":=GetAdmissionAcademicYear(ClassClassificationStudents."Student Number",ClassClassificationStudents.Programme);
                          ClassClassificationStudents."Graduation Group":=GetGradGroup(ClassClassificationStudents."Admission Academic Year",Progyz."Exam Category");
                          ClassClassificationStudents.Graduating:=false;
                          ClassClassificationStudents.Classification:='';
                            ClassClassificationCourseReg.Reset;
                            ClassClassificationCourseReg.SetRange("Student Number",ClassClassificationStudents."Student Number");
                            ClassClassificationCourseReg.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationCourseReg.SetRange("Graduation Academic Year",GradAcademicYear);
                            if ClassClassificationCourseReg.Find('-') then begin
                                repeat
                                  begin
                          ClassClassificationCourseReg."Department Name":=ClassClassificationStudents."Department Name";
                          ClassClassificationCourseReg."School Name":=ClassClassificationStudents."School Name";
                          ClassClassificationCourseReg."Student Name":=ClassClassificationStudents."Student Name";
                          ClassClassificationCourseReg.Cohort:=ClassClassificationStudents.Cohort;
                          ClassClassificationCourseReg."Final Stage":=ClassClassificationStudents."Final Stage";
                          ClassClassificationCourseReg."Final Academic Year":=ClassClassificationStudents."Final Academic Year";
                          ClassClassificationCourseReg."Final Year of Study":=ClassClassificationStudents."Final Year of Study";
                          ClassClassificationCourseReg."Admission Date":=ClassClassificationStudents."Admission Date";
                          ClassClassificationCourseReg."Admission Academic Year":=ClassClassificationStudents."Admission Academic Year";
                          ClassClassificationCourseReg.Graduating:=false;
                          ClassClassificationCourseReg.Classification:='';
                          ClassClassificationCourseReg."Graduation group":=GetGradGroup(ClassClassificationCourseReg."Admission Academic Year",Progyz."Exam Category");
                            ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                           // ClassClassificationUnits.SETRANGE("Year of Study",ClassClassificationCourseReg."Year of Study");
                            if ClassClassificationUnits.Find('-') then begin
                              repeat
                                  begin
                    // //              IF ((ClassClassificationUnits."Unit Code"='AAG 303') AND (ClassClassificationUnits."Student No."='AF/00004/016')) THEN
                    // //              ClassStudentUnits.RESET;
                                  ClassStudentUnits.Reset;
                                  ClassStudentUnits.SetRange("Student No.",ClassClassificationUnits."Student No.");
                                  ClassStudentUnits.SetRange(Programme,ClassClassificationUnits.Programme);
                                  ClassStudentUnits.SetRange("Reg. Reversed",false);
                                  ClassStudentUnits.SetRange(Unit,ClassClassificationUnits."Unit Code");
                                  if ClassStudentUnits.Find('+') then begin
                                    ClassStudentUnits.CalcFields("EXAMs Marks","CATs Marks","CATs Marks Exists","EXAMs Marks Exists");
                                  //Get CAT Marks
                    // //                ClassExamResults.RESET;
                    // //                ClassExamResults.SETRANGE("Student No.",ClassClassificationUnits."Student No.");
                    // //                ClassExamResults.SETRANGE(Unit,ClassClassificationUnits."Unit Code");
                    // //                ClassExamResults.SETFILTER(Exam,'%1|%2','ASSIGNMENT','CAT');
                    // //                ClassExamResults.SETCURRENTKEY(Semester);
                    // //                IF ClassExamResults.FIND('+') THEN BEGIN
                    ClassClassificationUnits."CAT Score":='';
                                  if ClassStudentUnits."CATs Marks Exists" then begin
                                      ClassClassificationUnits."CAT Score":=Format(ClassStudentUnits."CATs Marks");
                                      ClassClassificationUnits."CAT Score Decimal":=ClassStudentUnits."CATs Marks";
                                      end else begin
                                      ClassClassificationUnits."CAT Score":='';
                                      ClassClassificationUnits."CAT Score Decimal":=0;
                                        end;
                    // //                  END;
                                  //Get Exam Marks
                    // //                ClassExamResults.RESET;
                    // //                ClassExamResults.SETRANGE("Student No.",ClassClassificationUnits."Student No.");
                    // //                ClassExamResults.SETRANGE(Unit,ClassClassificationUnits."Unit Code");
                    // //                ClassExamResults.SETFILTER(Exam,'%1|%2|%3|%4','EXAM','EXAM100','EXAMS','FINAL EXAM');
                    // //                ClassExamResults.SETCURRENTKEY(Semester);
                    // //                IF ClassExamResults.FIND('+') THEN BEGIN
                    //              IF ClassStudentUnits."EXAMs Marks Exists" THEN BEGIN
                    //                  ClassClassificationUnits."Exam Score":=FORMAT(ClassStudentUnits."EXAMs Marks");
                    //                  ClassClassificationUnits."Exam Score Decimal":=ClassStudentUnits."EXAMs Marks";
                    //                  END;
                    // // //                  END;
                                      end;

                                    Clear(ClassExamResults);
                                     ClassExamResults.Reset;
                                     ClassExamResults.SetRange("Student No.",ClassClassificationUnits."Student No.");
                                     ClassExamResults.SetRange(Unit,ClassClassificationUnits."Unit Code");
                                     ClassExamResults.SetRange(Semester,ClassStudentUnits.Semester);
                                    // ClassExamResults.SETRANGE("Reg. Stopped",FALSE);
                                     ClassExamResults.SetFilter(ExamType,'%1|%2|%3|%4|%5|%6','EXAM','EXAM100','EXAMS','FINAL EXAM','FINAL','EXAMS');
                                     ClassExamResults.SetCurrentkey(Semester);
                                     if ClassExamResults.Find('+') then begin
                                      ClassClassificationUnits."Exam Score":=Format(ClassExamResults.Score);
                                      ClassClassificationUnits."Exam Score Decimal":=ClassExamResults.Score;
                                       end;
                                      //  END;
                                    //  IF ClassClassificationUnits."CAT Score"='' THEN BEGIN
                                    Clear(ClassExamResults);
                                     ClassExamResults.Reset;
                                     ClassExamResults.SetRange("Student No.",ClassClassificationUnits."Student No.");
                                     ClassExamResults.SetRange(Unit,ClassClassificationUnits."Unit Code");
                                     ClassExamResults.SetRange(Semester,ClassStudentUnits.Semester);
                                   //  ClassExamResults.SETRANGE("Reg. Stopped",FALSE);
                                     ClassExamResults.SetFilter(ExamType,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                                     ClassExamResults.SetCurrentkey(Semester);
                                     if ClassExamResults.Find('+') then begin
                                      ClassClassificationUnits."CAT Score":=Format(ClassExamResults.Score);
                                      ClassClassificationUnits."CAT Score Decimal":=ClassExamResults.Score;
                                       end;
                                   //    END;
                    // Check if Special Exists and Adopt Special Marks
                    Clear(AcaSpecialExamsDetails);
                                        AcaSpecialExamsDetails.Reset;
                                        AcaSpecialExamsDetails.SetRange("Student No.",ClassClassificationUnits."Student No.");
                                        AcaSpecialExamsDetails.SetRange("Unit Code",ClassClassificationUnits."Unit Code");
                                        AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Special);
                                       // AcaSpecialExamsDetails.SETRANGE("Semester flow",ClassStudentUnits.Semester);
                                        AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                                        if AcaSpecialExamsDetails.Find('+') then begin
                                      ClassClassificationUnits."Exam Score Decimal":=AcaSpecialExamsDetails."Exam Marks";
                                      ClassClassificationUnits."Exam Score":=Format(ClassClassificationUnits."Exam Score Decimal");
                                      end;
                                      // Check if exists in special Results

                    // Check if Supplementary Marks exists and update the Scores with Supplementary
                    Clear(AcaSpecialExamsDetails);
                                        AcaSpecialExamsDetails.Reset;
                                        AcaSpecialExamsDetails.SetRange("Student No.",ClassClassificationUnits."Student No.");
                                        AcaSpecialExamsDetails.SetRange("Unit Code",ClassClassificationUnits."Unit Code");
                                        AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Supplementary);
                                      //  AcaSpecialExamsDetails.SETRANGE("Semester flow",ClassStudentUnits.Semester);
                                        AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                                        if AcaSpecialExamsDetails.Find('+') then begin
                                            // Update the Course Unit Scores
                    // // // // //                  CLEAR(AcaSpecialExamsResults);
                    // // // // //                  AcaSpecialExamsResults.RESET;
                    // // // // //                  AcaSpecialExamsResults.SETRANGE("Student No.",ClassClassificationUnits."Student No.");
                    // // // // //                  AcaSpecialExamsResults.SETRANGE(Unit,ClassClassificationUnits."Unit Code");
                    // // // // //                  AcaSpecialExamsResults.SETRANGE("Semester flow",ClassStudentUnits.Semester);
                    // // // // //                  IF AcaSpecialExamsResults.FIND('-') THEN BEGIN
                    // // // // //                     IF AcaSpecialExamsResults.Score <>0 THEN BEGIN
                    // // // // //                       AcaSpecialExamsDetails."Exam Marks":=AcaSpecialExamsResults.Score;
                    // // // // //                       AcaSpecialExamsDetails.MODIFY;
                    // // // // //                       END;
                    // // // // //                    END;
                                      ClassClassificationUnits."Exam Score Decimal":=ROUND((GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                                      ClassClassificationUnits."Exam Score":=Format(ClassClassificationUnits."Exam Score Decimal");
                                      ClassClassificationUnits."CAT Score":=Format(0);
                                      ClassClassificationUnits."CAT Score Decimal":=0;
                                      end;
                    // Check if 2nd Supplementary Marks exists and update the Scores with Supplementary
                    Clear(Aca2ndSpecialExamsDetails);
                                        Aca2ndSpecialExamsDetails.Reset;
                                        Aca2ndSpecialExamsDetails.SetRange("Student No.",ClassClassificationUnits."Student No.");
                                        Aca2ndSpecialExamsDetails.SetRange("Unit Code",ClassClassificationUnits."Unit Code");
                                     //   Aca2ndSpecialExamsDetails.SETRANGE("Semester flow",ClassStudentUnits.Semester);
                                        Aca2ndSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                                        if Aca2ndSpecialExamsDetails.Find('+') then begin


                    //                  CLEAR(Aca2ndSuppExamsResults);
                    //                  Aca2ndSuppExamsResults.RESET;
                    //                  Aca2ndSuppExamsResults.SETRANGE("Student No.",ClassClassificationUnits."Student No.");
                    //                  Aca2ndSuppExamsResults.SETRANGE(Unit,ClassClassificationUnits."Unit Code");
                    //                  Aca2ndSuppExamsResults.SETRANGE("Semester flow",ClassStudentUnits.Semester);
                    //                  IF Aca2ndSuppExamsResults.FIND('-') THEN BEGIN
                    //                     IF Aca2ndSuppExamsResults.Score <>0 THEN BEGIN
                    //                       Aca2ndSpecialExamsDetails."Exam Marks":=Aca2ndSuppExamsResults.Score;
                    //                       Aca2ndSpecialExamsDetails.MODIFY;
                    //                       END;
                    //                    END;

                                      ClassClassificationUnits."Exam Score Decimal":=ROUND(GetSupp2MaxScore(Aca2ndSpecialExamsDetails,Progyz."Exam Category",Aca2ndSpecialExamsDetails."Exam Marks"),0.01,'=');
                                      ClassClassificationUnits."Exam Score":=Format(ClassClassificationUnits."Exam Score Decimal");
                                      ClassClassificationUnits."CAT Score":=Format(0);
                                      ClassClassificationUnits."CAT Score Decimal":=0;
                                      end;
                                      // CAT Marks Flow

                    // //                CLEAR(ClassExamResults);
                    // //                 ClassExamResults.RESET;
                    // //                 ClassExamResults.SETRANGE("Student No.",ClassClassificationUnits."Student No.");
                    // //                 ClassExamResults.SETRANGE(Unit,ClassClassificationUnits."Unit Code");
                    // //               //  ClassExamResults.SETRANGE(Semester,ClassStudentUnits.Semester);
                    // //                 ClassExamResults.SETFILTER(ExamType,'%1|%2|%3|%4|%5|%6','CAT','CAT100','CATS','FINAL CAT','FINALCAT','CATS');
                    // //                 ClassExamResults.SETCURRENTKEY(Semester);
                    // //                 IF ClassExamResults.FIND('+') THEN BEGIN
                    // //                  ClassClassificationUnits."CAT Score":=FORMAT(ClassExamResults.Score);
                    // //                  ClassClassificationUnits."CAT Score Decimal":=ClassExamResults.Score;
                    // //                   END;

                                    //Update Tatal Marks
                                    if ((ClassClassificationUnits."Exam Score"='') and (ClassClassificationUnits."CAT Score"='')) then begin
                                        ClassClassificationUnits.Pass:=false;
                                        ClassClassificationUnits.Grade:='?';
                                   end else  if ((ClassClassificationUnits."Exam Score"<>'') and (ClassClassificationUnits."CAT Score"<>'')) then begin
                                      ClassClassificationUnits."Total Score Decimal":=ROUND((ClassClassificationUnits."Exam Score Decimal"+ClassClassificationUnits."CAT Score Decimal"),1,'=');
                                      ClassClassificationUnits."Total Score":=Format(ClassClassificationUnits."Total Score Decimal");
                                      ClassClassificationUnits."Weighted Total Score":=ClassClassificationUnits."Credit Hours"*ClassClassificationUnits."Total Score Decimal";
                                      ClassClassificationUnits.Grade:=GetGrade(ClassClassificationUnits."Total Score Decimal",ClassClassificationUnits."Unit Code",ClassClassificationUnits.Programme);
                                      ClassClassificationUnits.Pass:=GetUnitPassStatus(ClassClassificationUnits."Total Score Decimal",ClassClassificationUnits."Unit Code",ClassClassificationUnits.Programme);
                                      end else begin
                                        ClassClassificationUnits.Pass:=false;
                                        ClassClassificationUnits.Grade:='!';
                                      ClassClassificationUnits."Total Score Decimal":=ROUND(( ClassClassificationUnits."Exam Score Decimal"+ClassClassificationUnits."CAT Score Decimal"),1,'=');
                                      ClassClassificationUnits."Total Score":=Format(ClassClassificationUnits."Total Score Decimal");
                                      ClassClassificationUnits."Weighted Total Score":=ClassClassificationUnits."Credit Hours"*ClassClassificationUnits."Total Score Decimal";
                                        end;
                                        ClassClassificationUnits.Cohort:=ClassClassificationStudents.Cohort;
                                        if ClassClassificationUnits.Pass = true then
                                           if ((ClassClassificationUnits."Unit Type"='CORE') or (ClassClassificationUnits."Unit Type"='REQUIRED')) then
                                          ClassClassificationUnits."Allow In Graduate 222":=true;

                              // Units tagged as Exclude from Graduation on the Students Card to be Tagged as NOT Allow in Graduate
                              Clear(StudUnitsForExclude);
                              StudUnitsForExclude.Reset;
                              StudUnitsForExclude.SetRange("Student No.",ClassClassificationUnits."Student No.");
                              StudUnitsForExclude.SetRange(Unit,ClassClassificationUnits."Unit Code");
                              StudUnitsForExclude.SetRange("Reg. Reversed",false);
                              StudUnitsForExclude.SetRange("Exclude from Classification",true);
                              if StudUnitsForExclude.Find('-') then begin
                                  ClassClassificationUnits."Allow In Graduate 222":=false;
                                  ClassClassificationUnits.Modify;
                                end;

                                          if ClassClassificationUnits."Unit Description" = '' then begin
                                            Clear(ACAUnitsSubjects693);
                                            ACAUnitsSubjects693.Reset;
                                            ACAUnitsSubjects693.SetRange("Programme Code",ClassClassificationUnits.Programme);
                                            ACAUnitsSubjects693.SetRange(Code,ClassClassificationUnits."Unit Code");
                                            ACAUnitsSubjects693.SetFilter(Desription,'<>%1','');
                                            if ACAUnitsSubjects693.Find('-') then begin
                                                ClassClassificationUnits."Unit Description":=ACAUnitsSubjects693.Desription;
                                              end;
                                            end;
                                        if ClassClassificationUnits.Modify then;
                                  end;
                                until ClassClassificationUnits.Next=0;
                              end;
                              // Update Course Registration for Graduation
                              Clear(ExpectedElectives);
                              ClassClassificationCourseReg.CalcFields("Total Cores Done","Total Required Done");
                              ExpectedElectives:=RequiredStageUnits(ClassClassificationCourseReg.Programme,
                              ClassClassificationCourseReg."Year of Study",ClassClassificationCourseReg."Student Number",ClassClassificationCourseReg."Graduation Academic Year");
                              ExpectedElectives:=ExpectedElectives-ClassClassificationCourseReg."Total Cores Done"-ClassClassificationCourseReg."Total Required Done";
                              // Update Classifiable Electives
                              if ExpectedElectives>0 then begin
                                      ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationUnits.SetRange("Year of Study",ClassClassificationCourseReg."Year of Study");
                            ClassClassificationUnits.SetRange("Unit Type",'ELECTIVE');
                            ClassClassificationUnits.SetCurrentkey("Total Score");
                            if ClassClassificationUnits.Find('-') then begin
                              Clear(CountedElectives);
                              CountedElectives:=ClassClassificationUnits.Count;
                              repeat
                                  begin
                                  ClassClassificationUnits."Course Cat. Presidence":=CountedElectives;
                                  CountedElectives:=CountedElectives-1;
                                  ClassClassificationUnits.Modify;
                                  end;
                                until ClassClassificationUnits.Next=0;
                              end;
                              // Get Top Electives and tag for Graduation
                                      ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationUnits.SetRange("Year of Study",ClassClassificationCourseReg."Year of Study");
                            ClassClassificationUnits.SetRange("Unit Type",'ELECTIVE');
                            ClassClassificationUnits.SetCurrentkey("Course Cat. Presidence");
                            if ClassClassificationUnits.Find('-') then begin
                              Clear(CountedElectives);
                              repeat
                                  begin
                                  CountedElectives:=CountedElectives+1;
                                  ClassClassificationUnits."Allow In Graduate 222":=true;
                                  ClassClassificationUnits.Modify;

                              // Units tagged as Exclude from Graduation on the Students Card to be Tagged as NOT Allow in Graduate
                              Clear(StudUnitsForExclude);
                              StudUnitsForExclude.Reset;
                              StudUnitsForExclude.SetRange("Student No.",ClassClassificationUnits."Student No.");
                              StudUnitsForExclude.SetRange(Unit,ClassClassificationUnits."Unit Code");
                              StudUnitsForExclude.SetRange("Reg Reversed",false);
                              StudUnitsForExclude.SetRange("Exclude from Classification",true);
                              if StudUnitsForExclude.Find('-') then begin

                                  CountedElectives:=CountedElectives-1;
                                  ClassClassificationUnits."Allow In Graduate 222":=false;
                                  ClassClassificationUnits.Modify;
                                end;

                                  end;
                                until ((ClassClassificationUnits.Next=0) or (CountedElectives=ExpectedElectives));
                              end;
                              end;

                              ClassClassificationCourseReg.CalcFields("Total Marks","Total Courses","Total Weighted Marks",
                              "Total Units","Classified Total Marks","Total Classified C. Count","Classified W. Total","Attained Stage Units");
                              ClassClassificationCourseReg.CalcFields("CATS Missing","Exam Missing");
                              if ClassClassificationCourseReg."Total Courses"<>0 then
                              ClassClassificationCourseReg."Normal Average":=ClassClassificationCourseReg."Total Marks"/ClassClassificationCourseReg."Total Courses";
                              if ClassClassificationCourseReg."Total Units"<>0 then
                              ClassClassificationCourseReg."Weighted Average":=ClassClassificationCourseReg."Total Weighted Marks"/ClassClassificationCourseReg."Total Units";
                              if ClassClassificationCourseReg."Total Classified C. Count"<>0 then
                              ClassClassificationCourseReg."Classified Average":=ClassClassificationCourseReg."Classified Total Marks"/ClassClassificationCourseReg."Total Classified C. Count";
                              if ClassClassificationCourseReg."Total Classified Units"<>0 then
                              ClassClassificationCourseReg."Classified W. Average":=ClassClassificationCourseReg."Classified W. Total"/ClassClassificationCourseReg."Total Classified Units";
                              ClassClassificationCourseReg."Required Stage Units":=RequiredStageUnits(ClassClassificationCourseReg.Programme,
                              ClassClassificationCourseReg."Year of Study",ClassClassificationCourseReg."Student Number",ClassClassificationCourseReg."Graduation Academic Year");
                              if ClassClassificationCourseReg."Required Stage Units">ClassClassificationCourseReg."Attained Stage Units" then
                              ClassClassificationCourseReg."Units Deficit":=ClassClassificationCourseReg."Required Stage Units"-ClassClassificationCourseReg."Attained Stage Units";
                              ClassClassificationCourseReg."Multiple Programe Reg. Exists":=GetMultipleProgramExists(ClassClassificationCourseReg."Student Number",ClassClassificationCourseReg."Graduation Academic Year");

                              ClassClassificationCourseReg.CalcFields("CATS Missing","Exam Missing");
                              Clear(ExistsOption);
                              if ((ClassClassificationCourseReg."Exam Missing") and (ClassClassificationCourseReg."CATS Missing")) then ExistsOption:=Existsoption::"None Exists"
                              else if  ((ClassClassificationCourseReg."Exam Missing"=true) and (ClassClassificationCourseReg."CATS Missing"=false)) then ExistsOption:=Existsoption::"Exam Only"
                              else if  ((ClassClassificationCourseReg."Exam Missing"=false) and (ClassClassificationCourseReg."CATS Missing"=true)) then ExistsOption:=Existsoption::"CAT Only"
                              else if  ((ClassClassificationCourseReg."Exam Missing"=false) and (ClassClassificationCourseReg."CATS Missing"=false)) then ExistsOption:=Existsoption::"Both Exists";
                              ClassClassificationCourseReg."Final Classification":=GetClassification(ClassClassificationCourseReg.Programme,ClassClassificationCourseReg."Weighted Average",false,ExistsOption,ClassClassificationStudents);
                              ClassClassificationCourseReg."Final Classification Pass":=GetClassPassStatus(ClassClassificationCourseReg."Final Classification");
                              ClassClassificationCourseReg."Graduation Grade":=GetClassificationGrade(ClassClassificationCourseReg."Normal Average",ClassClassificationCourseReg.Programme,ExistsOption);
                              ClassClassificationCourseReg."Final Classification Grade":=GetClassificationGrade(ClassClassificationCourseReg."Weighted Average",ClassClassificationCourseReg.Programme,ExistsOption);
                              ClassClassificationCourseReg."Final Classification Order":=GetClassificationOrder(ClassClassificationCourseReg."Final Classification");
                              ClassClassificationCourseReg.Graduating:=GetClassPassStatus(ClassClassificationCourseReg."Final Classification");
                              ClassClassificationCourseReg.Classification:=ClassClassificationCourseReg."Final Classification";
                               ClassClassificationCourseReg."Transcript Comments":=GetTranscripCOmments(Progyz."Exam Category",ClassClassificationCourseReg."Year of Study");
                              ClassClassificationCourseReg.Modify;

                              if ClassClassificationCourseReg."Total Courses"<>0 then
                              ClassClassificationCourseReg."Normal Average":=ClassClassificationCourseReg."Total Marks"/ClassClassificationCourseReg."Total Courses";
                                  end;
                                  until ClassClassificationCourseReg.Next=0;
                              end;
                              // Update Student Grad. Master
                              Clear(Total_First_Year_Courses);
                              Clear(Total_First_Year_Marks);
                              Clear(New_Total_Courses);
                              Clear(New_Total_Marks);
                              Clear(New_Classifiable_Average);
                              ClassClassificationStudents.CalcFields(ClassClassificationStudents."Prog. Exam Category");
                              ClassClassificationStudents.CalcFields("Total Marks","Total Courses","Total Weighted Marks",
                              "Total Units","Classified Total Marks","Total Classified C. Count","Classified W. Total","Attained Stage Units");
                              if ((ClassClassificationStudents."Program Group"='DEGREE') or (ClassClassificationStudents."Program Group"='UNDERGRADUATE')) then begin
                            ClassClassificationCourseReg.Reset;
                            ClassClassificationCourseReg.SetRange("Student Number",ClassClassificationStudents."Student Number");
                            ClassClassificationCourseReg.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationCourseReg.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationCourseReg.SetRange("Year of Study",1);
                            if ClassClassificationCourseReg.Find('-') then begin
                                        ClassClassificationCourseReg.CalcFields("Total Marks","Total Courses","Total Weighted Marks",
                              "Total Units","Classified Total Marks","Total Classified C. Count","Classified W. Total","Attained Stage Units");
                              Total_First_Year_Courses:=ClassClassificationCourseReg."Total Courses";
                              Total_First_Year_Marks:=ClassClassificationCourseReg."Total Marks";
                              New_Total_Courses:=ClassClassificationStudents."Total Courses"-Total_First_Year_Courses;
                              New_Total_Marks:=ClassClassificationStudents."Total Marks"-Total_First_Year_Marks;
                              end;
                              end else begin
                              New_Total_Courses:=ClassClassificationStudents."Total Courses";
                              New_Total_Marks:=ClassClassificationStudents."Total Marks";
                              end;

                              if New_Total_Courses>0 then
                              New_Classifiable_Average:=New_Total_Marks/New_Total_Courses;
                              New_Classifiable_Average:=ROUND(New_Classifiable_Average,0.01,'=');

                              if ClassClassificationStudents."Total Courses"<>0 then
                              ClassClassificationStudents."Normal Average":=ClassClassificationStudents."Total Marks"/ClassClassificationStudents."Total Courses";
                              if ClassClassificationStudents."Total Units"<>0 then
                              ClassClassificationStudents."Weighted Average":=ClassClassificationStudents."Total Weighted Marks"/ClassClassificationStudents."Total Units";
                    //          IF ClassClassificationStudents."Total Classified C. Count"<>0 THEN
                              ClassClassificationStudents."Classified Average":=New_Classifiable_Average;
                              if ClassClassificationStudents."Total Classified Units"<>0 then
                              ClassClassificationStudents."Classified W. Average":=ClassClassificationStudents."Classified W. Total"/ClassClassificationStudents."Total Classified Units";
                              ClassClassificationStudents."Required Stage Units":=RequiredStageUnits(ClassClassificationStudents.Programme,
                              ClassClassificationStudents."Year of Study",ClassClassificationStudents."Student Number",ClassClassificationStudents."Graduation Academic Year");
                              if ClassClassificationStudents."Required Stage Units">ClassClassificationStudents."Attained Stage Units" then
                              ClassClassificationStudents."Units Deficit":=ClassClassificationStudents."Required Stage Units"-ClassClassificationStudents."Attained Stage Units";

                               ClassClassificationStudents.CalcFields("CATS Missing","Exam Missing");
                              Clear(ExistsOption);
                              if ((ClassClassificationStudents."Exam Missing") and (ClassClassificationStudents."CATS Missing")) then ExistsOption:=Existsoption::"None Exists"
                              else if  ((ClassClassificationStudents."Exam Missing"=true) and (ClassClassificationStudents."CATS Missing"=false)) then ExistsOption:=Existsoption::"Exam Only"
                              else if  ((ClassClassificationStudents."Exam Missing"=false) and (ClassClassificationStudents."CATS Missing"=true)) then ExistsOption:=Existsoption::"CAT Only"
                              else if  ((ClassClassificationStudents."Exam Missing"=false) and (ClassClassificationStudents."CATS Missing"=false)) then ExistsOption:=Existsoption::"Both Exists";

                              ClassClassificationStudents."Final Classification":=GetClassification2(ClassClassificationCourseReg.Programme,New_Classifiable_Average,false,ExistsOption,ClassClassificationStudents);
                              ClassClassificationStudents."Final Classification Pass":=GetClassPassStatus(ClassClassificationStudents."Final Classification");
                              ClassClassificationStudents."Graduation Grade":=GetClassificationGrade(New_Classifiable_Average,ClassClassificationStudents.Programme,ExistsOption);
                              ClassClassificationStudents."Final Classification Grade":=GetClassificationGrade(New_Classifiable_Average,ClassClassificationStudents.Programme,ExistsOption);
                              ClassClassificationStudents."Final Classification Order":=GetClassificationOrder(ClassClassificationStudents."Final Classification");
                              ClassClassificationStudents.Graduating:=GetClassPassStatus(ClassClassificationStudents."Final Classification");
                              ClassClassificationStudents.Classification:=ClassClassificationStudents."Final Classification";
                              ClassClassificationStudents."Transcript Comments":=GetTranscripCOmments(Progyz."Exam Category",ClassClassificationCourseReg."Year of Study");
                              ClassClassificationStudents.Modify;
                    ToGraduate:=true;
                    //Less Courses in a Stage/Level
                    if ClassClassificationStudents."Units Deficit">0 then begin
                       ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='LESS COURSES';
                      ACANotGraduatingReasons."Reason Details":='Deficit on units:\ Ensure the students is registered.';
                      if ACANotGraduatingReasons.Insert then;
                      end;
                    //Failed A Unit

                            ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationUnits.SetRange(Pass,false);
                            if ClassClassificationUnits.Find('-') then begin
                            ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='FAILED COURSES';
                      ACANotGraduatingReasons."Reason Details":='Failed Some Courses:\ e.g. '+ClassClassificationUnits."Unit Code";
                    if ACANotGraduatingReasons.Insert then;
                            end;
                    //Unit Registered not on the Catalog
                            ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationUnits.SetRange("Unit Exists",false);
                            if ClassClassificationUnits.Find('-') then begin
                            ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='UNIT NOT IN CATALOG';
                      ACANotGraduatingReasons."Reason Details":='Some Registered Units are Missing in the Course Catalog:\ e.g. '+ClassClassificationUnits."Unit Code";
                    if ACANotGraduatingReasons.Insert then;
                            end;
                    //Multiple Programs Registered
                    ACAClassificationStudentsCheck.Reset;
                    ACAClassificationStudentsCheck.SetRange("Student Number",ClassClassificationStudents."Student Number");
                    ACAClassificationStudentsCheck.SetRange("Graduation Academic Year",GradAcademicYear);
                    if ACAClassificationStudentsCheck.Find('-') then begin
                    if ACAClassificationStudentsCheck.Count>1 then begin
                            ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='MULTIPLE COURSE REG';
                      ACANotGraduatingReasons."Reason Details":='Multiple Course Registration identified with Multiple Programs';
                    if ACANotGraduatingReasons.Insert then;
                    end;
                    end;
                    // Missing Both CAT and Exam
                            ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationUnits.SetRange(Grade,'?');
                            if ClassClassificationUnits.Find('-') then begin
                            ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='MISSING CAT & EXAM';
                      ACANotGraduatingReasons."Reason Details":='CAT & Exam Missing on some units e.g.  '+ClassClassificationUnits."Unit Code";
                    if ACANotGraduatingReasons.Insert then;
                            end;
                    //Exists With Missing Mark
                            ClassClassificationUnits.Reset;
                            ClassClassificationUnits.SetRange("Student No.",ClassClassificationStudents."Student Number");
                            ClassClassificationUnits.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationUnits.SetRange("Graduation Academic Year",GradAcademicYear);
                            ClassClassificationUnits.SetRange(Grade,'!');
                            if ClassClassificationUnits.Find('-') then begin
                            ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='MISSING MARK';
                      ACANotGraduatingReasons."Reason Details":='Some CAT and/or Exam Marks Missing\ e.g. '+ClassClassificationUnits."Unit Code";
                    if ACANotGraduatingReasons.Insert then;
                            end;
                            ClassClassificationStudents.CalcFields("Required Stage Units","Attained Stage Units","Failed Courses");
                    // //        IF (ClassClassificationStudents."Required Stage Units">ClassClassificationStudents."Attained Stage Units") THEN
                    // //          ToGraduate:=FALSE;
                            if ClassClassificationStudents."Failed Courses">0 then
                              ToGraduate:=false;
                             if ClassClassificationStudents."Final Classification"='' then begin
                        ToGraduate:=false;
                      ACANotGraduatingReasons.Init;
                      ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                      ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                      ACANotGraduatingReasons."Reason Code":='UNKNORN CLASS';
                      ACANotGraduatingReasons."Reason Details":='Empty Classifications ';;
                    if ACANotGraduatingReasons.Insert then;
                               end;
                    //Failed to attained course required in a Year of study

                            ClassClassificationCourseReg.Reset;
                            ClassClassificationCourseReg.SetRange("Student Number",ClassClassificationStudents."Student Number");
                            ClassClassificationCourseReg.SetRange("Graduation Academic Year",GradAcademicYear);
                            if  ClassClassificationCourseReg.Find('-') then begin
                              repeat
                                  begin
                                    ClassClassificationCourseReg.CalcFields("Attained Stage Units");
                                    if ClassClassificationCourseReg."Attained Stage Units"<ClassClassificationCourseReg."Required Stage Units" then begin
                                      if (ClassClassificationStudents."Required Stage Units">ClassClassificationStudents."Attained Stage Units") then begin
                                      if (ClassClassificationStudents."Required Stage Units">ClassClassificationStudents."Attained Stage Units") then begin
                                              ToGraduate:=false;
                                              ACANotGraduatingReasons.Init;
                                       ACANotGraduatingReasons."Graduation Academic Year":=GradAcademicYear;
                                       ACANotGraduatingReasons."Student No.":=ClassClassificationStudents."Student Number";
                                       ACANotGraduatingReasons."Reason Code":='LESS UNITS ATTAINED';
                                       ACANotGraduatingReasons."Reason Details":='Did not attain all the required units in Year'+Format(ClassClassificationCourseReg."Year of Study")+'. Required: '+
                                       Format(ClassClassificationCourseReg."Required Stage Units")+'. Attained: '+Format(ClassClassificationCourseReg."Attained Stage Units");
                                      if ACANotGraduatingReasons.Insert then;
                                      end;
                                      end;
                                      end;
                                  end;
                                until ClassClassificationCourseReg.Next=0;
                              end;


                    if ToGraduate=false then begin
                      ClassClassificationStudents.Graduating:=ToGraduate;
                      ClassClassificationStudents.Classification:='INCOMPLETE';
                      ClassClassificationStudents."Final Classification":='INCOMPLETE';
                      ClassClassificationStudents."Final Classification Pass":=false;
                      end;


                            ClassClassificationCourseReg.Reset;
                            ClassClassificationCourseReg.SetRange("Student Number",ClassClassificationStudents."Student Number");
                            ClassClassificationCourseReg.SetRange(Programme,ClassClassificationStudents.Programme);
                            ClassClassificationCourseReg.SetRange("Graduation Academic Year",GradAcademicYear);
                            if ClassClassificationCourseReg.Find('-') then begin
                                repeat
                                  begin
                      ClassClassificationCourseReg.Graduating:=ClassClassificationStudents.Graduating;
                      ClassClassificationCourseReg.Classification:=ClassClassificationStudents.Classification;
                     ClassClassificationCourseReg."Transcript Comments":=GetTranscripCOmments(Progyz."Exam Category",ClassClassificationCourseReg."Year of Study");
                      ClassClassificationCourseReg."Final Classification":=ClassClassificationStudents."Final Classification";
                      ClassClassificationCourseReg."Final Classification Pass":=ClassClassificationStudents."Final Classification Pass";
                      ClassClassificationCourseReg.Modify;
                                  end;
                                    until ClassClassificationCourseReg.Next=0;
                                  end;
                      ClassClassificationStudents.Modify
                          end;
                          until ClassClassificationStudents.Next=0;
                      ProgBar2.Close;
                      end;
                        end;
                          until ProgList.Next = 0;
                          end;

                    Message('Processing completed successfully!');

                    UpdateFilters(UserId,programs,AcadYears,GradAcademicYear);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        ACAExamProcessingFilterLog: Record UnknownRecord78010;
    begin
        ACAExamProcessingFilterLog.Reset;
        ACAExamProcessingFilterLog.SetRange("User ID",UserId);
        if ACAExamProcessingFilterLog.Find('-') then begin
            AcadYears:=ACAExamProcessingFilterLog."Academic Year Code";
        programs:=ACAExamProcessingFilterLog."Programme Code";
        //GradAcademicYear:=ACAExamProcessingFilterLog."Graduation Year";
          end;
          ACAAcademicYear963.Reset;
          ACAAcademicYear963.SetRange("Graduating Group",true);
          if not ACAAcademicYear963.Find('-') then Error('Graduating group is not defined!');
          GradAcademicYear:=ACAAcademicYear963.Code;
    end;

    var
        programs: Code[1024];
        AcadYears: Code[1024];
        Stages: Code[1024];
        StudNos: Code[1024];
        ACAExamResultsBuffer2: Record UnknownRecord61746;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAExamResults: Record UnknownRecord61548;
        SemesterFilter: Text[1024];
        AcaSpecialExamsResults: Record UnknownRecord78003;
        GradAcademicYear: Code[20];
        ACACourseRegistration5: Record UnknownRecord61532;
        Progrezz: Dialog;
        ACAProgramme963: Record UnknownRecord61511;
        ACAAcademicYear963: Record UnknownRecord61382;
        Schools: Code[20];
        UnitCode: Code[1024];
        ACAProgrammeStages: Record UnknownRecord61516;
        ProgFIls: Text[1024];
        Progressbar: Dialog;
        ToGraduate: Boolean;
        ProgFilters: Text[1024];
        ExamsProcessing: Codeunit "Exams Processing";
        ProgList: Record UnknownRecord61511;
        YosStages: Text[150];
        ACAExamProcActiveUsers: Record UnknownRecord66675;
        ACAExamProcActiveUsers2: Record UnknownRecord66675;
        Aca2ndSuppExamsResults: Record UnknownRecord78032;
        ProgForFilters: Record UnknownRecord61511;
        AcaAcademicYear_Buffer: Record UnknownRecord65815;
        AcaAcademicYear_Buffer2: Record UnknownRecord65815;
        CountedLoops: Integer;
        AcademicYearArray: array [100] of Text[20];
        Arrayfound: Boolean;
        ACAProgrammeYearsofStudy: Record "ACA-Programme Years of Study";

    local procedure UpdateFilters(UserCode: Code[50];ProgCodes: Code[1024];AcadYearsCodes: Code[1024];GradYearOfStudy: Code[1024])
    var
        ACAExamProcessingFilterLog: Record UnknownRecord78010;
    begin
        ACAExamProcessingFilterLog.Reset;
        ACAExamProcessingFilterLog.SetRange("User ID",UserCode);
        if ACAExamProcessingFilterLog.Find('-') then begin
          //Exists, Update
          ACAExamProcessingFilterLog."Programme Code":=ProgCodes;
          ACAExamProcessingFilterLog."Academic Year Code":=AcadYears;
          ACAExamProcessingFilterLog."Graduation Year":=GradAcademicYear;
          ACAExamProcessingFilterLog.Modify;
          end else begin
            // Doesent Exists, Insert
          ACAExamProcessingFilterLog.Init;
          ACAExamProcessingFilterLog."User ID":=UserCode;
          ACAExamProcessingFilterLog."Programme Code":=ProgCodes;
          ACAExamProcessingFilterLog."Academic Year Code":=AcadYears;
          ACAExamProcessingFilterLog."Graduation Year":=GradAcademicYear;
          ACAExamProcessingFilterLog.Insert;
            end;
    end;


    procedure GetGrade(EXAMMark: Decimal;UnitG: Code[20];Proga: Code[20]) xGrade: Text[100]
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
    begin
        EXAMMark:=ROUND(EXAMMark,0.1,'=');
         Clear(Marks);
        Marks:=EXAMMark;
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",Proga);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(Proga) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if ((GradeCategory='') or (GradeCategory=' ')) then  GradeCategory:='DEFAULT';
        end;
        end;

        xGrade:='';
        //IF Marks > 0 THEN BEGIN
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Results Exists Status",'%1',Gradings."results exists status"::"Both Exists");
        // // LastGrade:='';
        // // LastRemark:='';
        // // LastScore:=0;
        if Gradings.Find('-') then begin
        // // ExitDo:=FALSE;
        // // //REPEAT
        // // LastScore:=Gradings."Up to";
        // // IF Marks < LastScore THEN BEGIN
        // // IF ExitDo = FALSE THEN BEGIN
        xGrade:=Gradings.Grade;
        // IF Gradings.Failed=FALSE THEN
        // LastRemark:='PASS'
        // ELSE
        // LastRemark:='FAIL';
        // ExitDo:=TRUE;
        // END;
        // END;
        //
        //
        // END;

        end;
    end;


    procedure GetUnitPassStatus(EXAMMark: Decimal;UnitG: Code[20];Proga: Code[20]) Passed: Boolean
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
    begin
         Clear(Marks);
         EXAMMark:=ROUND(EXAMMark,0.1,'=');
        Marks:=EXAMMark;
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",Proga);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(Proga) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';
        end;
        end;
        Passed:=false;
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Results Exists Status",'%1',Gradings."results exists status"::"Both Exists");
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        //REPEAT
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
          if Gradings.Failed then
        Passed:=false else Passed:=true;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;


        end;

        end else begin
        Passed:=false;
        end;
    end;

    local procedure GetStudentName(StudNo: Code[20]) StudName: Text[250]
    var
        Customer: Record Customer;
    begin
        Customer.Reset;
        Customer.SetRange("No.",StudNo);
        if Customer.Find('-') then
          StudName:=Customer.Name;
    end;

    local procedure GetDepartmentNameOrSchool(DimCode: Code[20]) DimName: Text[150]
    var
        dimVal: Record "Dimension Value";
    begin
        dimVal.Reset;
        dimVal.SetRange(Code,DimCode);
        if dimVal.Find('-') then DimName:=dimVal.Name;
    end;

    local procedure GetFinalStage(ProgCode: Code[20]) FinStage: Code[20]
    var
        ACAProgrammeStages: Record UnknownRecord61516;
    begin
        Clear(FinStage);
        ACAProgrammeStages.Reset;
        ACAProgrammeStages.SetRange("Programme Code",ProgCode);
        ACAProgrammeStages.SetRange("Final Stage",true);
        if ACAProgrammeStages.Find('-') then begin
         FinStage:=ACAProgrammeStages.Code;
          end;
    end;

    local procedure GetFinalYearOfStudy(ProgCode: Code[20]) FinYearOfStudy: Integer
    var
        ACAProgrammeStages: Record UnknownRecord61516;
    begin
        Clear(FinYearOfStudy);
        ACAProgrammeStages.Reset;
        ACAProgrammeStages.SetRange("Programme Code",ProgCode);
        ACAProgrammeStages.SetRange("Final Stage",true);
        if ACAProgrammeStages.Find('-') then begin
          if StrLen(ACAProgrammeStages.Code)>2 then begin
            if Evaluate(FinYearOfStudy,CopyStr(ACAProgrammeStages.Code,2,1)) then;
            end;
          end;
    end;

    local procedure GetAdmissionDate(StudNo: Code[20];ProgCode: Code[20]) AdmissionDate: Date
    var
        coregz: Record UnknownRecord61532;
    begin
        Clear(AdmissionDate);
        coregz.Reset;
        coregz.SetRange("Student No.",StudNo);
        coregz.SetRange(Programme,ProgCode);
        coregz.SetRange(Reversed,false);
        if coregz.Find('-') then begin
          AdmissionDate:=coregz."Registration Date";
          end;
    end;

    local procedure GetAdmissionAcademicYear(StudNo: Code[20];ProgCode: Code[20]) AdmissionAcadYear: Code[20]
    var
        coregz: Record UnknownRecord61532;
    begin
        Clear(AdmissionAcadYear);
        coregz.Reset;
        coregz.SetRange("Student No.",StudNo);
        coregz.SetRange(Programme,ProgCode);
        coregz.SetRange(Reversed,false);
        if coregz.Find('-') then begin
          AdmissionAcadYear:=coregz."Academic Year";
          end;
    end;

    local procedure GetFinalAcademicYear(StudNo: Code[20];ProgCode: Code[20]) FinalAcadYear: Code[20]
    var
        coregz: Record UnknownRecord61532;
    begin
        Clear(FinalAcadYear);
        coregz.Reset;
        coregz.SetRange("Student No.",StudNo);
        coregz.SetRange(Programme,ProgCode);
        coregz.SetRange(Reversed,false);
        if coregz.Find('+') then begin
          FinalAcadYear:=coregz."Academic Year";
          end;
    end;

    local procedure GetMultipleProgramExists(StudNoz: Code[20];AcademicYear: Code[20]) Multiples: Boolean
    var
        ClassClassificationStudents: Record UnknownRecord66630;
        ClassClassificationCourseReg: Record UnknownRecord66631;
        ClassClassificationUnits: Record UnknownRecord66632;
    begin
        ClassClassificationStudents.Reset;
        ClassClassificationStudents.SetRange("Student Number",StudNoz);
        ClassClassificationStudents.SetRange("Graduation Academic Year",AcademicYear);
        if ClassClassificationStudents.Find('-') then
          if ClassClassificationStudents.Count>1 then Multiples:=true else Multiples:=false;
    end;

    local procedure GetCohort(StudNo: Code[20];ProgCode: Code[20]) Cohort: Code[20]
    var
        coregz: Record UnknownRecord61532;
        ACAProgrammeGraduationGroup: Record UnknownRecord77800;
    begin
        Clear(Cohort);
        coregz.Reset;
        coregz.SetRange("Student No.",StudNo);
        coregz.SetRange(Programme,ProgCode);
        coregz.SetRange(Reversed,false);
        if coregz.Find('-') then begin
          ACAProgrammeGraduationGroup.Reset;
          ACAProgrammeGraduationGroup.SetRange("Programme Code",ProgCode);
          ACAProgrammeGraduationGroup.SetRange("Admission Academic Year",coregz."Academic Year");
          if ACAProgrammeGraduationGroup.Find('-') then
            ACAProgrammeGraduationGroup.TestField("Graduation Academic Year");
            Cohort:=ACAProgrammeGraduationGroup."Graduation Academic Year";
          end;
    end;

    local procedure RequiredStageUnits(ProgCode: Code[20];YoS: Integer;StudNo: Code[20];AcademicYearszzz: Code[20]) ExpectedUnits: Decimal
    var
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        AcacourseReg: Record UnknownRecord61532;
    begin
        Clear(AcacourseReg);
        AcacourseReg.Reset;
        AcacourseReg.SetRange("Student No.",StudNo);
        AcacourseReg.SetRange(Programme,ProgCode);
        AcacourseReg.SetRange("Year Of Study",YoS);
        AcacourseReg.SetFilter("Academic Year",'<>%1','');
        if AcacourseReg.Find('-') then;
        if AcacourseReg."Academic Year" <> '' then
        AcademicYearszzz := AcacourseReg."Academic Year";
        Clear(ACADefinedUnitsperYoS);
        ACADefinedUnitsperYoS.Reset;
        ACADefinedUnitsperYoS.SetRange("Year of Study",YoS);
        ACADefinedUnitsperYoS.SetRange(Programme,ProgCode);
        ACADefinedUnitsperYoS.SetRange("Academic Year",AcademicYearszzz);
          if AcacourseReg.Options<>'-' then
        ACADefinedUnitsperYoS.SetRange(Options,AcacourseReg.Options);
        if ACADefinedUnitsperYoS.Find('-') then ExpectedUnits:=ACADefinedUnitsperYoS."Number of Units";

        if ExpectedUnits=0 then begin
          AcacourseReg.Reset;
        AcacourseReg.SetRange("Student No.",StudNo);
        AcacourseReg.SetRange(Programme,ProgCode);
        AcacourseReg.SetRange("Year Of Study",YoS);
        if AcacourseReg.Find('-') then
        if ACADefinedUnitsperYoS.Find('-') then ExpectedUnits:=ACADefinedUnitsperYoS."Number of Units";
          end;
    end;

    local procedure GetClassification(ProgCode: Code[20];AverageScore: Decimal;HasIrregularity: Boolean;MarksStatus: Option " ","Both Exists","CAT Only","Exam Only","None Exists";ACAClassificationStudents: Record UnknownRecord66630) Classification: Code[100]
    var
        ACAClassGradRubrics: Record UnknownRecord78011;
        ACAGradingSystemSetup: Record UnknownRecord61599;
        Programz1: Record UnknownRecord61511;
        ACAClassGradLubrics: Record UnknownRecord78011;
    begin
        Clear(Classification);
        AverageScore:=ROUND(AverageScore,0.1,'=');
        Clear(Programz1);
                  Programz1.Reset;
                  Programz1.SetRange(Code,ProgCode);
                  if Programz1.Find('-') then;
        ACAGradingSystemSetup.Reset;
        ACAGradingSystemSetup.Reset;
          ACAGradingSystemSetup.SetRange(Category,Programz1."Exam Category");
          ACAGradingSystemSetup.SetFilter("Graduation Lower Limit",'=%1|<%2',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetFilter("Graduation Upper Limit",'>%2|=%1',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetRange("Results Exists Status",MarksStatus);
          if ACAGradingSystemSetup.Find('-') then begin
            if HasIrregularity then begin
              ACAClassGradRubrics.Reset;
              ACAClassGradRubrics.SetRange(Code,ACAGradingSystemSetup.Remarks);
              if ACAClassGradRubrics.Find('-') then begin
                if ACAClassGradRubrics."Alternate Rubric"<>'' then begin
              Classification:=ACAClassGradRubrics."Alternate Rubric";
                  end else begin
              Classification:=ACAGradingSystemSetup.Remarks;
                    end;
                end else begin
              Classification:=ACAGradingSystemSetup.Remarks;
                  end;
              end else begin
              Classification:=ACAGradingSystemSetup.Remarks;
                end;
                ACAClassificationStudents.CalcFields("Exists Alternative Rubric");
                if ACAClassificationStudents."Exists Alternative Rubric" then begin
                  ACAClassGradLubrics.Reset;
                  ACAClassGradLubrics.SetRange(Code,Classification);
                 if  ACAClassGradLubrics.Find('-') then begin
                    if ACAClassGradLubrics."Alternate Rubric"<>'' then begin
                      Classification:=ACAClassGradLubrics."Alternate Rubric";
                      end;
                   end;
                  end;
                if ((Programz1."Special Programme Class"=Programz1."special programme class"::"Medicine & Nursing") or
                  (Programz1.Category=Programz1.Category::Postgraduate) or (Programz1."Not Classified")) then
                  if not ACAGradingSystemSetup.Failed then Classification:='PASS';
            end;
    end;


    procedure GetClassificationGrade(EXAMMark: Decimal;Proga: Code[20];MarksStatus: Option " ","Both Exists","CAT Only","Exam Only","None Exists") xGrade: Text[100]
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
    begin
         Clear(Marks);
        EXAMMark:=ROUND(EXAMMark,0.1,'=');
        Marks:=EXAMMark;
        GradeCategory:='';
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(Proga) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';
        xGrade:='';
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Graduation Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Graduation Upper Limit",'>%1|=%2',Marks,Marks);
          Gradings.SetRange("Results Exists Status",MarksStatus);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        //REPEAT
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        xGrade:=Gradings.Grade;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;


        end;

        end;
    end;


    procedure GetClassPassStatus(Class: Code[100]) Passed: Boolean
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
        ACAClassGradLubrics: Record UnknownRecord78011;
    begin
         ACAClassGradLubrics.Reset;
         ACAClassGradLubrics.SetRange(Code,Class);
         if ACAClassGradLubrics.Find('-') then begin
           Passed:=ACAClassGradLubrics.Pass
           end;
    end;

    local procedure GetClassificationOrder(Class: Code[100]) ClassOrder: Integer
    var
        ACAClassGradRubrics: Record UnknownRecord78011;
        ACAProgramme123: Record UnknownRecord61511;
        ACAGradingSystemSetup: Record UnknownRecord61599;
        Classification: Code[50];
    begin

          Clear(ClassOrder);
          ACAClassGradRubrics.Reset;
          ACAClassGradRubrics.SetRange(Code,Class);
          if ACAClassGradRubrics.Find('-') then
            ClassOrder:=ACAClassGradRubrics."Order No";
    end;

    local procedure GetYearOfStudy(StageCode: Code[20]) YearOfStudy: Integer
    var
        ACAProgrammeStages: Record UnknownRecord61516;
    begin
        Clear(YearOfStudy);

          if StrLen(StageCode)>2 then begin
            if Evaluate(YearOfStudy,CopyStr(StageCode,2,1)) then;
            end;
    end;

    local procedure FormatNames(CommonName: Text[250]) NewName: Text[250]
    var
        NamesSmall: Text[250];
        FirsName: Text[250];
        SpaceCount: Integer;
        SpaceFound: Boolean;
        Counts: Integer;
        Strlegnth: Integer;
        OtherNames: Text[250];
        FormerCommonName: Text[250];
        OneSpaceFound: Boolean;
        Countings: Integer;
    begin
        Clear(OneSpaceFound);
        Clear(Countings);
        CommonName:=ConvertStr(CommonName,',',' ');
           FormerCommonName:='';
          repeat
           begin
          Countings+=1;
          if CopyStr(CommonName,Countings,1)=' ' then begin
           if OneSpaceFound=false then FormerCommonName:=FormerCommonName+CopyStr(CommonName,Countings,1);
            OneSpaceFound:=true
           end else begin
             OneSpaceFound:=false;
             FormerCommonName:=FormerCommonName+CopyStr(CommonName,Countings,1)
           end;
           end;
             until Countings=StrLen(CommonName);
             CommonName:=FormerCommonName;
        Clear(NamesSmall);
        Clear(FirsName);
        Clear(SpaceCount);
        Clear(SpaceFound);
        Clear(OtherNames);
        if StrLen(CommonName)>100 then  CommonName:=CopyStr(CommonName,1,100);
        Strlegnth:=StrLen(CommonName);
        if StrLen(CommonName)>4 then begin
          NamesSmall:=Lowercase(CommonName);
          repeat
            begin
              SpaceCount+=1;
              if ((CopyStr(NamesSmall,SpaceCount,1)='') or (CopyStr(NamesSmall,SpaceCount,1)=' ') or (CopyStr(NamesSmall,SpaceCount,1)=',')) then SpaceFound:=true;
              if not SpaceFound then begin
                FirsName:=FirsName+UpperCase(CopyStr(NamesSmall,SpaceCount,1));
                end else  begin
                  if StrLen(OtherNames)<150 then begin
                if ((CopyStr(NamesSmall,SpaceCount,1)='') or (CopyStr(NamesSmall,SpaceCount,1)=' ') or (CopyStr(NamesSmall,SpaceCount,1)=',')) then begin
                  OtherNames:=OtherNames+' ';
                SpaceCount+=1;
                  OtherNames:=OtherNames+UpperCase(CopyStr(NamesSmall,SpaceCount,1));
                  end else begin
                  OtherNames:=OtherNames+CopyStr(NamesSmall,SpaceCount,1);
                    end;

                end;
                end;
            end;
              until ((SpaceCount=Strlegnth))
          end;
          Clear(NewName);
        NewName:=FirsName+','+OtherNames;
    end;

    local procedure GetGradGroup(AdmissionYear: Code[20];ExamCategory: Code[20]) GradGroup: Code[20]
    var
        ACAGraduationGroups: Record "ACA-Graduation Groups";
    begin
        Clear(GradGroup);
        ACAGraduationGroups.Reset;
        ACAGraduationGroups.SetRange("Academic Year",AdmissionYear);
        ACAGraduationGroups.SetRange("Exam Category",ExamCategory);
        if ACAGraduationGroups.Find('-') then begin
          ACAGraduationGroups.TestField("Graduation Group");
          GradGroup:=ACAGraduationGroups."Graduation Group";
          end;
    end;

    local procedure GetTranscripCOmments(Category: Code[20];Yos: Integer) RetTransComments: Text[250]
    var
        ACAProgCatTranscriptComm: Record UnknownRecord78020;
    begin
        Clear(RetTransComments);
        ACAProgCatTranscriptComm.Reset;
        ACAProgCatTranscriptComm.SetRange("Exam Catogory",Category);
        ACAProgCatTranscriptComm.SetRange("Year of Study",Yos);
        if ACAProgCatTranscriptComm.Find('-') then
          ACAProgCatTranscriptComm.TestField("Pass Comment");
        RetTransComments:=ACAProgCatTranscriptComm."Pass Comment";
        if RetTransComments='' then Error('Transcript Comment Setup is empty for Category: '+Category);
    end;

    local procedure GetClassification2(ProgCode: Code[20];AverageScore: Decimal;HasIrregularity: Boolean;MarksStatus: Option " ","Both Exists","CAT Only","Exam Only","None Exists";ACAClassificationStudents: Record UnknownRecord66630) Classification: Code[100]
    var
        ACAClassGradRubrics: Record UnknownRecord78011;
        ACAGradingSystemSetup: Record UnknownRecord61599;
        Programz1: Record UnknownRecord61511;
        ACAClassGradLubrics: Record UnknownRecord78011;
    begin
        Clear(Classification);
        AverageScore:=ACAClassificationStudents."Weighted Average";
        AverageScore:=ROUND(AverageScore,0.1,'=');
                  Programz1.Reset;
                  Programz1.SetRange(Code,ProgCode);
                  if Programz1.Find('-') then;
        ACAGradingSystemSetup.Reset;
          ACAGradingSystemSetup.SetRange(Category,Programz1."Exam Category");
          ACAGradingSystemSetup.SetFilter("Graduation Lower Limit",'=%1|<%2',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetFilter("Graduation Upper Limit",'>%2|=%1',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetRange("Results Exists Status",MarksStatus);
          if ACAGradingSystemSetup.Find('-') then begin
            if HasIrregularity then begin
              ACAClassGradRubrics.Reset;
              ACAClassGradRubrics.SetRange(Code,ACAGradingSystemSetup.Remarks);
              if ACAClassGradRubrics.Find('-') then begin
                if ACAClassGradRubrics."Alternate Rubric"<>'' then begin
              Classification:=ACAClassGradRubrics."Alternate Rubric";
                  end else begin
              Classification:=ACAGradingSystemSetup.Remarks;
                    end;
                end else begin
              Classification:=ACAGradingSystemSetup.Remarks;
                  end;
              end else begin
              Classification:=ACAGradingSystemSetup.Remarks;
                end;
                ACAClassificationStudents.CalcFields("Exists Alternative Rubric");
                if ACAClassificationStudents."Exists Alternative Rubric" then begin
                  ACAClassGradLubrics.Reset;
                  ACAClassGradLubrics.SetRange(Code,Classification);
                 if  ACAClassGradLubrics.Find('-') then begin
                    if ACAClassGradLubrics."Alternate Rubric"<>'' then begin
                      Classification:=ACAClassGradLubrics."Alternate Rubric";
                      end;
                   end;
                  end;
                if ((Programz1."Special Programme Class"=Programz1."special programme class"::"Medicine & Nursing") or
                  (Programz1.Category=Programz1.Category::Postgraduate)) then
                  if not ACAGradingSystemSetup.Failed then Classification:='PASS';
            end;
    end;

    local procedure GetSuppMaxScore(SuppDets: Record UnknownRecord78002;Categoryz: Code[20];Scorezs: Decimal) SuppScoreNormalized: Decimal
    var
        ACAExamCategory: Record UnknownRecord61568;
    begin
        SuppScoreNormalized:=Scorezs;
        if SuppDets.Category = SuppDets.Category::Supplementary then begin
        ACAExamCategory.Reset;
        ACAExamCategory.SetRange(Code,Categoryz);
        if ACAExamCategory.Find('-') then begin
          if ACAExamCategory."Supplementary Max. Score"<>0 then begin
            if Scorezs>ACAExamCategory."Supplementary Max. Score" then
              SuppScoreNormalized:=ACAExamCategory."Supplementary Max. Score";
            end;
          end;
          end;
    end;

    local procedure GetSupp2MaxScore(SuppDets: Record UnknownRecord78031;Categoryz: Code[20];Scorezs: Decimal) SuppScoreNormalized: Decimal
    var
        ACAExamCategory: Record UnknownRecord61568;
    begin
        SuppScoreNormalized:=Scorezs;
        if SuppDets.Category = SuppDets.Category::Supplementary then begin
        ACAExamCategory.Reset;
        ACAExamCategory.SetRange(Code,Categoryz);
        if ACAExamCategory.Find('-') then begin
          if ACAExamCategory."Supplementary Max. Score"<>0 then begin
            if Scorezs>ACAExamCategory."Supplementary Max. Score" then
              SuppScoreNormalized:=ACAExamCategory."Supplementary Max. Score";
            end;
          end;
          end;
    end;

    local procedure UpdateAcadYear(var ProgramList: Code[1024])
    var
        AcaProgrammes_Buffer: Record UnknownRecord65824;
        AcaProgrammes_Buffer2: Record UnknownRecord65824;
    begin
        if StudNos <> '' then begin
          Clear(AcadYears);
          Clear(AcaAcademicYear_Buffer);
          AcaAcademicYear_Buffer.Reset;
          AcaAcademicYear_Buffer.SetRange(User_Id,UserId);
          if AcaAcademicYear_Buffer.Find('-') then AcaAcademicYear_Buffer.DeleteAll;
          Schools := '';
          programs := '';
          ProgramList := '';
          Clear(AcadYears);
          Clear(CountedLoops);
          Clear(AcademicYearArray);
          Clear(ACACourseRegistration);
          Clear(AcaProgrammes_Buffer);
          AcaProgrammes_Buffer.Reset;
          AcaProgrammes_Buffer.SetRange(User_Id,UserId);
          if AcaProgrammes_Buffer.Find('-') then AcaProgrammes_Buffer.DeleteAll;

          ACACourseRegistration.Reset;
          ACACourseRegistration.SetFilter("Student No.",StudNos);
         // ACACourseRegistration.SETRANGE(Reversed,FALSE);
          if ACACourseRegistration.Find('-') then begin
            repeat
              begin

          AcaProgrammes_Buffer2.Init;
          AcaProgrammes_Buffer2.User_Id := UserId;
          AcaProgrammes_Buffer2."Programme Code" :=ACACourseRegistration.Programme;
          if AcaProgrammes_Buffer2.Insert then;

          AcaAcademicYear_Buffer2.Init;
          AcaAcademicYear_Buffer2.User_Id := UserId;
          AcaAcademicYear_Buffer2.Academic_Year :=ACACourseRegistration."Academic Year";
          if AcaAcademicYear_Buffer2.Insert then;
              end;
                until ACACourseRegistration.Next=0;
            end;

          Clear(AcaAcademicYear_Buffer);
          AcaAcademicYear_Buffer.Reset;
          AcaAcademicYear_Buffer.SetRange(User_Id,UserId);
          if AcaAcademicYear_Buffer.Find('-') then begin
            repeat
              begin
                  if AcadYears <> '' then begin
                AcadYears := AcadYears+'|'+AcaAcademicYear_Buffer.Academic_Year;
                    end else begin
                AcadYears := AcaAcademicYear_Buffer.Academic_Year;
                      end;
              end;
              until AcaAcademicYear_Buffer.Next = 0;
            end;
          end;

         Clear(AcaProgrammes_Buffer2);
          AcaProgrammes_Buffer2.Reset;
          AcaProgrammes_Buffer2.SetRange(User_Id,UserId);
          if AcaProgrammes_Buffer2.Find('-') then begin
            repeat
              begin
                  if ProgramList <> '' then begin
                ProgramList := ProgramList+'|'+AcaProgrammes_Buffer2."Programme Code";
                    end else begin
                ProgramList := AcaProgrammes_Buffer2."Programme Code";
                      end;
              end;
              until AcaProgrammes_Buffer2.Next = 0;
            end;

    end;

    local procedure UpdateProgrammes()
    begin
        if StudNos <> '' then begin
          Clear(programs);
          Clear(AcaAcademicYear_Buffer);
          AcaAcademicYear_Buffer.Reset;
          AcaAcademicYear_Buffer.SetRange(User_Id,UserId);
          if AcaAcademicYear_Buffer.Find('-') then AcaAcademicYear_Buffer.DeleteAll;
          Schools := '';
          //programs := '';
          Clear(AcadYears);
          Clear(CountedLoops);
          Clear(AcademicYearArray);
          Clear(ACACourseRegistration);
          ACACourseRegistration.Reset;
          ACACourseRegistration.SetFilter("Student No.",StudNos);
          ACACourseRegistration.SetRange(Reversed,false);
          if ACACourseRegistration.Find('-') then begin
            repeat
              begin

          AcaAcademicYear_Buffer2.Init;
          AcaAcademicYear_Buffer2.User_Id := UserId;
          AcaAcademicYear_Buffer2.Academic_Year :=ACACourseRegistration."Academic Year";
          if AcaAcademicYear_Buffer2.Insert then;
              end;
                until ACACourseRegistration.Next=0;
            end;

          Clear(AcaAcademicYear_Buffer);
          AcaAcademicYear_Buffer.Reset;
          AcaAcademicYear_Buffer.SetRange(User_Id,UserId);
          if AcaAcademicYear_Buffer.Find('-') then begin
            repeat
              begin
                  if AcadYears <> '' then begin
                AcadYears := AcadYears+'|'+AcaAcademicYear_Buffer.Academic_Year;
                    end else begin
                AcadYears := AcaAcademicYear_Buffer.Academic_Year;
                      end;
              end;
              until AcaAcademicYear_Buffer.Next = 0;
            end;
          end;

    end;
}

