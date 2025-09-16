#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77701 "Process Exams Central Gen."
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
                field(UnitCode;UnitCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Code';
                    Visible = false;
                }
                field(StudNos;StudNos)
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
                field(AcadYear;AcadYear)
                {
                    ApplicationArea = Basic;
                    Caption = 'Academic Year';
                    TableRelation = "ACA-Academic Year".Code;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostMarksNew)
            {
                ApplicationArea = Basic;
                Caption = 'Process Marks';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Aca2ndSuppExamsDetails: Record UnknownRecord78031;
                    AcaSpecialExamsDetailsz: Record UnknownRecord78002;
                    AcdYrs: Record UnknownRecord61382;
                    Custos: Record Customer;
                    CountedRegistrations: Integer;
                    Coregcsz10: Record UnknownRecord61532;
                    StudentUnits: Record UnknownRecord61549;
                    UnitsSubjects: Record UnknownRecord61517;
                    Programme_Fin: Record UnknownRecord61511;
                    ProgrammeStages_Fin: Record UnknownRecord61516;
                    AcademicYear_Fin: Record UnknownRecord61382;
                    Semesters_Fin: Record UnknownRecord61692;
                    ExamResults: Record UnknownRecord61548;
                    ClassSpecialExamsDetails: Record UnknownRecord78002;
                    ClassCustomer: Record Customer;
                    ClassExamResultsBuffer2: Record UnknownRecord61746;
                    ClassDimensionValue: Record "Dimension Value";
                    ClassGradingSystem: Record UnknownRecord61521;
                    ClassClassGradRubrics: Record UnknownRecord78011;
                    ClassExamResults2: Record UnknownRecord61548;
                    TotalRecs: Integer;
                    CountedRecs: Integer;
                    RemeiningRecs: Integer;
                    ExpectedElectives: Integer;
                    CountedElectives: Integer;
                    ProgBar2: Dialog;
                    Progyz: Record UnknownRecord61511;
                    ACADefinedUnitsperYoS: Record UnknownRecord78017;
                    ACAExamClassificationUnits: Record UnknownRecord66650;
                    ACAExamCourseRegistration: Record UnknownRecord66651;
                    ACAExamFailedReasons: Record UnknownRecord66652;
                    ACASenateReportsHeader: Record UnknownRecord66654;
                    ACAExamClassificationStuds: Record UnknownRecord66653;
                    ACAExamClassificationStudsCheck: Record UnknownRecord66653;
                    ACAExamResultsFin: Record UnknownRecord61548;
                    ACAResultsStatus: Record UnknownRecord61739;
                    ProgressForCoReg: Dialog;
                    Tens: Text;
                    ACASemesters: Record UnknownRecord61692;
                    ACAExamResults_Fin: Record UnknownRecord61548;
                    ProgBar22: Dialog;
                    Coregcs: Record UnknownRecord61532;
                    ACAExamCummulativeResit: Record UnknownRecord66657;
                    ACAStudentUnitsForResits: Record UnknownRecord61549;
                    SEQUENCES: Integer;
                    CurrStudentNo: Code[20];
                    CountedNos: Integer;
                    CurrSchool: Code[20];
                    AcaSpecialExamsDetails6: Record UnknownRecord78002;
                    xxxxxxxxxxxxxxxxxxxxx: Text[20];
                    Aca2NDSpecialExamsDetails: Record UnknownRecord78031;
                    Aca2NDSpecialExamsDetails3: Record UnknownRecord78031;
                    ACAExam2NDSuppUnits: Record "ACA-2ndExam Supp. Units";
                    Aca2ndSuppExamsResults: Record UnknownRecord78032;
                    ACA2NDExamClassificationUnits: Record UnknownRecord66681;
                    ACA2NDExamCourseRegistration: Record UnknownRecord66682;
                    ACA2NDExamFailedReasons: Record "ACA-2ndSuppExam Fail Reasons";
                    ACA2NDSenateReportsHeader: Record "ACA-2ndSuppSenate Repo. Header";
                    ACA2NDExamClassificationStuds: Record "ACA-2ndSuppExam Class. Studs";
                    ACA2NDExamClassificationStudsCheck: Record "ACA-2ndSuppExam Class. Studs";
                    ACA2NDExamCummulativeResit: Record "ACA-2ndSuppExam Cumm. Resit";
                begin
                    ExamsProcessing.MarksPermissions(UserId);
                    if Confirm('Process Marks?',true)=false then Error('Cancelled by user!');
                    if AcadYear='' then Error('Specify Academic Year');
                    if ((Schools = '') and (programs = '') and (StudNos = '')) then Error('Specify one of the following:\a. School\b. Programme\c. Student');
                                      Clear(Coregcs);
                                      Clear(ACASenateReportsHeader);
                                      Clear(ACAExamClassificationUnits);
                                      Clear(ACAExamProcActiveUsers);
                                      Clear(ACAExamCourseRegistration);
                                      Clear(ACAExamClassificationStuds);
                                      Clear(Coregcs);
                                      Clear(ACASenateReportsHeader);

                    ACAExamProcActiveUsers.Reset;
                    ACAExamProcActiveUsers.SetRange("Processing Users",UserId);
                    if ACAExamProcActiveUsers.Find('-') then  ACAExamProcActiveUsers.DeleteAll;

                    ACAExamProcActiveUsers.Reset;
                    ACAExamProcActiveUsers.SetRange("User is Active",true);
                    if ACAExamProcActiveUsers.Find('-') then begin
                      if Confirm(ACAExamProcActiveUsers."Processing Users"+' is Processing!\Continue?',true,'FALSE','Test')=true then begin
                        ACAExamProcActiveUsers2.Reset;
                        if ACAExamProcActiveUsers2.Find('-') then ACAExamProcActiveUsers2.DeleteAll;
                        ACAExamProcActiveUsers2.Init;
                        ACAExamProcActiveUsers2."Token ID":=1;
                        ACAExamProcActiveUsers2."Processing Users":=UserId;
                       if ACAExamProcActiveUsers2.Insert then;
                        end else
                      Error(ACAExamProcActiveUsers."Processing Users"+' is Processing! Try after 5 Minutes');
                      end else begin
                        ACAExamProcActiveUsers2.Reset;
                        if ACAExamProcActiveUsers2.Find('-') then ACAExamProcActiveUsers2.DeleteAll;
                        ACAExamProcActiveUsers2.Init;
                        ACAExamProcActiveUsers2."Token ID":=1;
                        ACAExamProcActiveUsers2."Processing Users":=UserId;
                      if  ACAExamProcActiveUsers2.Insert then;
                        end;

                    Clear(ProgFIls);
                    Clear(ProgForFilters);
                    ProgForFilters.Reset;
                    if Schools<>'' then
                    ProgForFilters.SetFilter("School Code",Schools) else
                    if programs<>'' then
                    ProgForFilters.SetFilter(Code,programs);
                    if ProgForFilters.Find('-') then begin
                      repeat
                        begin
                    // Clear CLassification For Selected Filters
                    ProgFIls:=ProgForFilters.Code;
                    ACAExamClassificationStuds.Reset;
                    ACAExamCourseRegistration.Reset;
                    ACAExamClassificationUnits.Reset;
                    if StudNos<>'' then begin
                    ACAExamClassificationStuds.SetFilter("Student Number",StudNos);
                    ACAExamCourseRegistration.SetRange("Student Number",StudNos);
                    ACAExamClassificationUnits.SetRange("Student No.",StudNos);
                    end;
                    if AcadYear<>'' then begin
                    ACAExamClassificationStuds.SetFilter("Academic Year",AcadYear);
                    ACAExamCourseRegistration.SetFilter("Academic Year",AcadYear);
                    ACAExamClassificationUnits.SetFilter("Academic Year",AcadYear);
                    end;

                    ACAExamClassificationStuds.SetFilter(Programme,ProgFIls);
                    ACAExamCourseRegistration.SetFilter(Programme,ProgFIls);
                    ACAExamClassificationUnits.SetFilter(Programme,ProgFIls);
                    if ACAExamClassificationStuds.Find('-') then ACAExamClassificationStuds.DeleteAll;
                    if ACAExamCourseRegistration.Find('-') then ACAExamCourseRegistration.DeleteAll;
                    if ACAExamClassificationUnits.Find('-') then ACAExamClassificationUnits.DeleteAll;

                                      ACASenateReportsHeader.Reset;
                                      ACASenateReportsHeader.SetFilter("Academic Year",AcadYear);
                                      ACASenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                                      if  (ACASenateReportsHeader.Find('-')) then ACASenateReportsHeader.DeleteAll;


                     Clear(ACA2NDExamClassificationStuds);
                     Clear(ACA2NDExamCourseRegistration);
                     Clear(ACA2NDExamClassificationUnits);
                     Clear(ACAExam2NDSuppUnits);
                    ACA2NDExamClassificationStuds.Reset;
                    ACA2NDExamCourseRegistration.Reset;
                    ACA2NDExamClassificationUnits.Reset;
                    ACAExam2NDSuppUnits.Reset;
                    if StudNos<>'' then begin
                    ACA2NDExamClassificationStuds.SetFilter("Student Number",StudNos);
                    ACA2NDExamCourseRegistration.SetRange("Student Number",StudNos);
                    ACA2NDExamClassificationUnits.SetRange("Student No.",StudNos);
                    ACAExam2NDSuppUnits.SetRange("Student No.",StudNos);
                    end;
                    if AcadYear<>'' then begin
                    ACA2NDExamClassificationStuds.SetFilter("Academic Year",AcadYear);
                    ACA2NDExamCourseRegistration.SetFilter("Academic Year",AcadYear);
                    ACA2NDExamClassificationUnits.SetFilter("Academic Year",AcadYear);
                    ACAExam2NDSuppUnits.SetFilter("Academic Year",AcadYear);
                    end;

                    ACA2NDExamClassificationStuds.SetFilter(Programme,ProgFIls);
                    ACA2NDExamCourseRegistration.SetFilter(Programme,ProgFIls);
                    ACA2NDExamClassificationUnits.SetFilter(Programme,ProgFIls);
                    ACAExam2NDSuppUnits.SetFilter(Programme,ProgFIls);
                    if ACA2NDExamClassificationStuds.Find('-') then ACA2NDExamClassificationStuds.DeleteAll;
                    if ACA2NDExamCourseRegistration.Find('-') then ACA2NDExamCourseRegistration.DeleteAll;
                    if ACA2NDExamClassificationUnits.Find('-') then ACA2NDExamClassificationUnits.DeleteAll;
                    if ACAExam2NDSuppUnits.Find('-') then ACAExam2NDSuppUnits.DeleteAll;


                                      ACA2NDSenateReportsHeader.Reset;
                                      ACA2NDSenateReportsHeader.SetFilter("Academic Year",AcadYear);
                                      ACA2NDSenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                                      if  (ACA2NDSenateReportsHeader.Find('-')) then ACA2NDSenateReportsHeader.DeleteAll;



                    Clear(Coregcs);
                    Coregcs.Reset;
                    Coregcs.SetFilter("Academic Year",AcadYear);
                    Coregcs.SetRange("Exclude from Computation",false);
                    Coregcs.SetFilter(Programme,ProgFIls);
                    if StudNos<>'' then begin
                    Coregcs.SetFilter("Student No.",StudNos);
                      end else begin
                        end;
                    if Coregcs.Find('-') then begin
                      Clear(TotalRecs);
                    Clear(RemeiningRecs);
                    Clear(CountedRecs);
                    TotalRecs:=Coregcs.Count;
                    RemeiningRecs:=TotalRecs;
                      // Loop through all Ungraduated Students Units
                      Progressbar.Open('#1#####################################################\'+
                      '#2############################################################\'+
                      '#3###########################################################\'+
                      '#4############################################################\'+
                      '#5###########################################################\'+
                      '#6############################################################');
                         Progressbar.Update(1,'Processing  values....');
                         Progressbar.Update(2,'Total Recs.: '+Format(TotalRecs));
                      repeat
                        begin

                        CountedRecs:=CountedRecs+1;
                        RemeiningRecs:=RemeiningRecs-1;
                        // Create Registration Unit entry if Not Exists
                         Progressbar.Update(3,'.....................................................');
                         Progressbar.Update(4,'Processed: '+Format(CountedRecs));
                         Progressbar.Update(5,'Remaining: '+Format(RemeiningRecs));
                         Progressbar.Update(6,'----------------------------------------------------');
                            Progyz.Reset;
                            Progyz.SetFilter(Code,Coregcs.Programme);
                         if Progyz.Find('-') then begin
                           end;
                           Clear(YosStages);
                        if Coregcs."Year Of Study"=0 then begin Coregcs.Validate(Stage);
                         // Coregcs.MODIFY;
                          end;
                        if Coregcs."Year Of Study"=1 then YosStages:='Y1S1|Y1S2|Y1S3|Y1S4'
                        else if Coregcs."Year Of Study"=2 then YosStages:='Y2S1|Y2S2|Y2S3|Y2S4'
                        else if Coregcs."Year Of Study"=3 then YosStages:='Y3S1|Y3S2|Y3S3|Y3S4'
                        else if Coregcs."Year Of Study"=4 then YosStages:='Y4S1|Y4S2|Y4S3|Y4S4'
                        else if Coregcs."Year Of Study"=5 then YosStages:='Y5S1|Y5S2|Y5S3|Y5S4'
                        else if Coregcs."Year Of Study"=6 then YosStages:='Y6S1|Y6S2|Y6S3|Y6S4'
                        else if Coregcs."Year Of Study"=7 then YosStages:='Y7S1|Y7S2|Y7S3|Y7S4'
                        else if Coregcs."Year Of Study"=8 then YosStages:='Y8S1|Y8S2|Y8S3|Y8S4';


                    Custos.Reset;
                    Custos.SetRange("No.",Coregcs."Student No.");
                    if Custos.Find('-') then
                    Custos.CalcFields("Senate Classification Based on");
                    Clear(StudentUnits);
                    StudentUnits.Reset;
                    StudentUnits.SetRange("Student No.",Coregcs."Student No.");
                    //StudentUnits.SETRANGE("Academic Year (Flow)",Coregcs."Academic Year");
                    StudentUnits.SetRange("Year Of Study",Coregcs."Year Of Study");
                    //StudentUnits.SETRANGE("Academic Year Exclude Comp.",FALSE);
                    StudentUnits.SetFilter(Unit,'<>%1','');
                    //StudentUnits.SETRANGE("Reg. Reversed",FALSE);

                      Clear(CountedRegistrations);
                      Clear(Coregcsz10);
                      Coregcsz10.Reset;
                      Coregcsz10.SetRange("Student No.",Coregcs."Student No.");
                      Coregcsz10.SetRange("Year Of Study",Coregcs."Year Of Study");
                      Coregcsz10.SetRange(Reversed,false);
                      Coregcsz10.SetFilter(Stage,'..%1',Coregcs.Stage);
                      if Coregcsz10.Find('-') then begin
                       CountedRegistrations := Coregcsz10.Count;
                       if CountedRegistrations <2 then // Filter

                      StudentUnits.SetRange(Stage,Coregcs.Stage);
                       end;
                    Coregcs.CalcFields("Stoppage Exists In Acad. Year","Stoppage Exists in YoS","Stopped Academic Year","Stopage Yearly Remark");
                          if Coregcs."Stopped Academic Year" <>'' then begin
                           if Coregcs."Academic Year Exclude Comp."=false then
                                  StudentUnits.SetFilter("Academic Year (Flow)",'=%1|=%2',Coregcs."Stopped Academic Year",Coregcs."Academic Year");
                           end
                          else
                          StudentUnits.SetFilter("Academic Year (Flow)",'=%1',Coregcs."Academic Year");
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                      ////////////////////////////////////////////////////////////////////////////
                        // Grad Headers
                                ACAResultsStatus.Reset ;
                                ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
                                ACAResultsStatus.SetRange("Academic Year",Coregcs."Academic Year");
                                if ACAResultsStatus.Find('-') then begin
                                  repeat
                                      begin
                                      ACASenateReportsHeader.Reset;
                                      ACASenateReportsHeader.SetRange("Academic Year",Coregcs."Academic Year");
                                      ACASenateReportsHeader.SetRange("School Code",Progyz."School Code");
                                      ACASenateReportsHeader.SetRange("Classification Code",ACAResultsStatus.Code);
                                      ACASenateReportsHeader.SetRange("Programme Code",Progyz.Code);
                                      ACASenateReportsHeader.SetRange("Year of Study",Coregcs."Year Of Study");
                                      if not (ACASenateReportsHeader.Find('-')) then begin
                                        ACASenateReportsHeader.Init;
                                        ACASenateReportsHeader."Academic Year":=Coregcs."Academic Year";
                                        ACASenateReportsHeader."Reporting Academic Year":=Coregcs."Academic Year";
                                        ACASenateReportsHeader."Rubric Order":=ACAResultsStatus."Order No";
                                        ACASenateReportsHeader."Programme Code":=Progyz.Code;
                                        ACASenateReportsHeader."School Code":=Progyz."School Code";
                                        ACASenateReportsHeader."Year of Study":=Coregcs."Year Of Study";
                                        ACASenateReportsHeader."Classification Code":=ACAResultsStatus.Code;
                                        ACASenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
                                        ACASenateReportsHeader."IncludeVariable 1":=ACAResultsStatus."IncludeVariable 1";
                                        ACASenateReportsHeader."IncludeVariable 2":=ACAResultsStatus."IncludeVariable 2";
                                        ACASenateReportsHeader."IncludeVariable 3":=ACAResultsStatus."IncludeVariable 3";
                                        ACASenateReportsHeader."IncludeVariable 4":=ACAResultsStatus."IncludeVariable 4";
                                        ACASenateReportsHeader."IncludeVariable 5":=ACAResultsStatus."IncludeVariable 5";
                                        ACASenateReportsHeader."IncludeVariable 6":=ACAResultsStatus."IncludeVariable 6";
                                        ACASenateReportsHeader."Summary Page Caption":=ACAResultsStatus."Summary Page Caption";
                                        ACASenateReportsHeader."Include Failed Units Headers":=ACAResultsStatus."Include Failed Units Headers";
                                        ACASenateReportsHeader."Include Academic Year Caption":=ACAResultsStatus."Include Academic Year Caption";
                                        ACASenateReportsHeader."Academic Year Text":=ACAResultsStatus."Academic Year Text";
                                        ACASenateReportsHeader."Status Msg1":=ACAResultsStatus."Status Msg1";
                                        ACASenateReportsHeader."Status Msg2":=ACAResultsStatus."Status Msg2";
                                        ACASenateReportsHeader."Status Msg3":=ACAResultsStatus."Status Msg3";
                                        ACASenateReportsHeader."Status Msg4":=ACAResultsStatus."Status Msg4";
                                        ACASenateReportsHeader."Status Msg5":=ACAResultsStatus."Status Msg5";
                                        ACASenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
                                        ACASenateReportsHeader."Grad. Status Msg 1":=ACAResultsStatus."Grad. Status Msg 1";
                                        ACASenateReportsHeader."Grad. Status Msg 2":=ACAResultsStatus."Grad. Status Msg 2";
                                        ACASenateReportsHeader."Grad. Status Msg 3":=ACAResultsStatus."Grad. Status Msg 3";
                                        ACASenateReportsHeader."Grad. Status Msg 4":=ACAResultsStatus."Grad. Status Msg 4";
                                        ACASenateReportsHeader."Grad. Status Msg 5":=ACAResultsStatus."Grad. Status Msg 5";
                                        ACASenateReportsHeader."Grad. Status Msg 6":=ACAResultsStatus."Grad. Status Msg 6";
                                        ACASenateReportsHeader."Finalists Graduation Comments":=ACAResultsStatus."Finalists Grad. Comm. Degree";
                                        ACASenateReportsHeader."1st Year Grad. Comments":=ACAResultsStatus."1st Year Grad. Comments";
                                        ACASenateReportsHeader."2nd Year Grad. Comments":=ACAResultsStatus."2nd Year Grad. Comments";
                                        ACASenateReportsHeader."3rd Year Grad. Comments":=ACAResultsStatus."3rd Year Grad. Comments";
                                        ACASenateReportsHeader."4th Year Grad. Comments":=ACAResultsStatus."4th Year Grad. Comments";
                                        ACASenateReportsHeader."5th Year Grad. Comments":=ACAResultsStatus."5th Year Grad. Comments";
                                        ACASenateReportsHeader."6th Year Grad. Comments":=ACAResultsStatus."6th Year Grad. Comments";
                                        ACASenateReportsHeader."7th Year Grad. Comments":=ACAResultsStatus."7th Year Grad. Comments";
                                       if  ACASenateReportsHeader.Insert then;
                                        end;
                                      end;
                                    until ACAResultsStatus.Next=0;
                                  end;
                        ////////////////////////////////////////////////////////////////////////////
                            ACAExamClassificationStuds.Reset;
                            ACAExamClassificationStuds.SetRange("Student Number",Coregcs."Student No.");
                            ACAExamClassificationStuds.SetRange(Programme,Coregcs.Programme);
                            ACAExamClassificationStuds.SetRange("Academic Year",Coregcs."Academic Year");
                           // ACAExamClassificationStuds.SETRANGE("Reporting Academic Year",GradAcademicYear);
                            if not ACAExamClassificationStuds.Find('-') then begin
                            ACAExamClassificationStuds.Init;
                            ACAExamClassificationStuds."Student Number":=Coregcs."Student No.";
                            ACAExamClassificationStuds."Reporting Academic Year":=Coregcs."Academic Year";
                            ACAExamClassificationStuds."School Code":=Progyz."School Code";
                            ACAExamClassificationStuds.Department:=Progyz."Department Code";
                            ACAExamClassificationStuds."Programme Option":=Coregcs.Options;
                            ACAExamClassificationStuds.Programme:=Coregcs.Programme;
                            ACAExamClassificationStuds."Academic Year":=Coregcs."Academic Year";
                            ACAExamClassificationStuds."Year of Study":=Coregcs."Year Of Study";
                          //ACAExamClassificationStuds."Department Name":=GetDepartmentNameOrSchool(Progyz."Department Code");
                          ACAExamClassificationStuds."School Name":=GetDepartmentNameOrSchool(Progyz."School Code");
                          ACAExamClassificationStuds."Student Name":=GetStudentName(Coregcs."Student No.");
                          ACAExamClassificationStuds.Cohort:=GetCohort(Coregcs."Student No.",Coregcs.Programme);
                          ACAExamClassificationStuds."Final Stage":=GetFinalStage(Coregcs.Programme);
                          ACAExamClassificationStuds."Final Academic Year":=GetFinalAcademicYear(Coregcs."Student No.",Coregcs.Programme);
                          ACAExamClassificationStuds."Final Year of Study":=GetFinalYearOfStudy(Coregcs.Programme);
                          ACAExamClassificationStuds."Admission Date":=GetAdmissionDate(Coregcs."Student No.",Coregcs.Programme);
                          ACAExamClassificationStuds."Admission Academic Year":=GetAdmissionAcademicYear(Coregcs."Student No.",Coregcs.Programme);
                          ACAExamClassificationStuds.Graduating:=false;
                          ACAExamClassificationStuds.Classification:='';
                           if  ACAExamClassificationStuds.Insert then;

                        end;
                            /////////////////////////////////////// YoS Tracker
                            Progyz.Reset;
                            if Progyz.Get(Coregcs.Programme) then;
                            ACAExamCourseRegistration.Reset;
                            ACAExamCourseRegistration.SetRange("Student Number",Coregcs."Student No.");
                            ACAExamCourseRegistration.SetRange(Programme,Coregcs.Programme);
                            ACAExamCourseRegistration.SetRange("Year of Study",Coregcs."Year Of Study");
                            ACAExamCourseRegistration.SetRange("Academic Year",Coregcs."Academic Year");
                            // Clear 1st and 2nd Supp Entries here

                            if not ACAExamCourseRegistration.Find('-') then begin
                                ACAExamCourseRegistration.Init;
                                ACAExamCourseRegistration."Student Number":=Coregcs."Student No.";
                                ACAExamCourseRegistration.Programme:=Coregcs.Programme;
                                ACAExamCourseRegistration."Year of Study":=Coregcs."Year Of Study";
                                ACAExamCourseRegistration."Reporting Academic Year":=Coregcs."Academic Year";
                                ACAExamCourseRegistration."Academic Year":=Coregcs."Academic Year";
                                ACAExamCourseRegistration."School Code":=Progyz."School Code";
                                ACAExamCourseRegistration."Programme Option":=Coregcs.Options;
                          ACAExamCourseRegistration."School Name":=ACAExamClassificationStuds."School Name";
                          ACAExamCourseRegistration."Student Name":=ACAExamClassificationStuds."Student Name";
                          ACAExamCourseRegistration.Cohort:=ACAExamClassificationStuds.Cohort;
                          ACAExamCourseRegistration."Final Stage":=ACAExamClassificationStuds."Final Stage";
                          ACAExamCourseRegistration."Final Academic Year":=ACAExamClassificationStuds."Final Academic Year";
                          ACAExamCourseRegistration."Final Year of Study":=ACAExamClassificationStuds."Final Year of Study";
                          ACAExamCourseRegistration."Admission Date":=ACAExamClassificationStuds."Admission Date";
                          ACAExamCourseRegistration."Admission Academic Year":=ACAExamClassificationStuds."Admission Academic Year";

                      if ((Progyz.Category=Progyz.Category::"Certificate ") or
                         (Progyz.Category=Progyz.Category::"Course List") or
                         (Progyz.Category=Progyz.Category::Professional)) then begin
                          ACAExamCourseRegistration."Category Order":=2;
                          end else if (Progyz.Category=Progyz.Category::Diploma) then begin
                          ACAExamCourseRegistration."Category Order":=3;
                            end  else if (Progyz.Category=Progyz.Category::Postgraduate) then begin
                          ACAExamCourseRegistration."Category Order":=4;
                            end  else if (Progyz.Category=Progyz.Category::Undergraduate) then begin
                          ACAExamCourseRegistration."Category Order":=1;
                            end;

                          ACAExamCourseRegistration.Graduating:=false;
                          ACAExamCourseRegistration.Classification:='';
                              if  ACAExamCourseRegistration.Insert then;
                              end;
                            /////////////////////////////////////// end of YoS Tracker

                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    if StudentUnits.Find('-') then begin

                      repeat
                        begin
                         StudentUnits.CalcFields(StudentUnits."CATs Marks Exists");
                         if StudentUnits."CATs Marks Exists"=false then begin

                          UnitsSubjects.Reset;
                          UnitsSubjects.SetRange("Programme Code",StudentUnits.Programme);
                          UnitsSubjects.SetRange(Code,StudentUnits.Unit);
                          UnitsSubjects.SetRange("Exempt CAT",true);
                          if UnitsSubjects.Find('-') then begin
                             ExamResults.Init;
                             ExamResults."Student No.":=StudentUnits."Student No.";
                             ExamResults.Programme:=StudentUnits.Programme;
                             ExamResults.Stage:=StudentUnits.Stage;
                             ExamResults.Unit:=StudentUnits.Unit;
                             ExamResults.Semester:=StudentUnits.Semester;
                             ExamResults."Academic Year":=StudentUnits."Academic Year";
                             ExamResults."Reg. Transaction ID":=StudentUnits."Reg. Transacton ID";
                             ExamResults.ExamType:='CAT';
                             ExamResults.Exam:='CAT';
                             ExamResults."Exam Category":=Progyz."Exam Category";
                             ExamResults.Score:=0;
                             ExamResults."User Name":='AUTOPOST';
                          if   ExamResults.Insert then;
                             end;
                             end;
                          // END;
                            Clear(ExamResults); ExamResults.Reset;
                        ExamResults.SetRange("Student No.",StudentUnits."Student No.");
                        ExamResults.SetRange(Unit,StudentUnits.Unit);
                        if ExamResults.Find('-') then begin
                            repeat
                                begin
                                   if ExamResults.ExamType<>'' then begin
                       ExamResults.Exam:=ExamResults.ExamType;
                       ExamResults.Modify;
                       end else  if ExamResults.Exam<>'' then begin
                         if ExamResults.ExamType='' then begin
                       ExamResults.Rename(ExamResults."Student No.",ExamResults.Programme,ExamResults.Stage,
                       ExamResults.Unit,ExamResults.Semester,ExamResults.Exam,ExamResults."Reg. Transaction ID",ExamResults."Entry No");
                       end;
                       end;
                                end;
                              until ExamResults.Next = 0;
                          end;
                                ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii Update Units
                               Clear(ExamResults);
                        Clear(ExamResults); ExamResults.Reset;
                        ExamResults.SetFilter("Counted Occurances",'>%1',1);
                        ExamResults.SetRange("Student No.",StudentUnits."Student No.");
                        ExamResults.SetRange(Unit,StudentUnits.Unit);
                        if ExamResults.Find('-') then begin
                          repeat
                            begin
                            ACAExamResultsFin.Reset;
                            ACAExamResultsFin.SetRange("Student No.",StudentUnits."Student No.");
                            ACAExamResultsFin.SetRange(Programme,StudentUnits.Programme);
                            ACAExamResultsFin.SetRange(Unit,StudentUnits.Unit);
                            ACAExamResultsFin.SetRange(Semester,StudentUnits.Semester);
                            ACAExamResultsFin.SetRange(ExamType,ExamResults.ExamType);
                            if ACAExamResultsFin.Find('-') then begin
                              ACAExamResultsFin.CalcFields("Counted Occurances");
                              if ACAExamResultsFin."Counted Occurances">1 then begin
                                  ACAExamResultsFin.Delete;
                                end;
                              end;
                            end;
                            until ExamResults.Next=0;
                            end;
                      ////////////////////////////////// Remove Multiple Occurances of a Mark
                      // Deleted Header Creation here
                          //Get best CAT Marks
                          StudentUnits."Unit not in Catalogue":=false;

                          UnitsSubjects.Reset;
                          UnitsSubjects.SetRange("Programme Code",StudentUnits.Programme);
                          UnitsSubjects.SetRange(Code,StudentUnits.Unit);
                          if UnitsSubjects.Find('-') then begin
                            if UnitsSubjects."Default Exam Category"='' then begin UnitsSubjects."Default Exam Category":=Progyz."Exam Category";
                            UnitsSubjects.Modify;
                              end;
                            if UnitsSubjects."Exam Category"='' then begin
                              UnitsSubjects."Exam Category":=Progyz."Exam Category";
                            UnitsSubjects.Modify;
                              end;
                            ACAExamClassificationUnits.Reset;
                            ACAExamClassificationUnits.SetRange("Student No.",Coregcs."Student No.");
                            ACAExamClassificationUnits.SetRange(Programme,Coregcs.Programme);
                            ACAExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
                            ACAExamClassificationUnits.SetRange("Academic Year",Coregcs."Academic Year");
                            if not ACAExamClassificationUnits.Find('-') then begin
                                ACAExamClassificationUnits.Init;
                                ACAExamClassificationUnits."Student No.":=Coregcs."Student No.";
                                ACAExamClassificationUnits.Programme:=Coregcs.Programme;
                                ACAExamClassificationUnits."Reporting Academic Year":=Coregcs."Academic Year";
                                ACAExamClassificationUnits."School Code":=Progyz."School Code";
                                ACAExamClassificationUnits."Unit Code":=StudentUnits.Unit;
                                ACAExamClassificationUnits."Credit Hours":=UnitsSubjects."No. Units";
                                ACAExamClassificationUnits."Unit Type":=Format(UnitsSubjects."Unit Type");
                                ACAExamClassificationUnits."Unit Description":=UnitsSubjects.Desription;
                                ACAExamClassificationUnits."Year of Study":=ACAExamCourseRegistration."Year of Study";
                                ACAExamClassificationUnits."Academic Year":=Coregcs."Academic Year";

                                    Clear(ExamResults); ExamResults.Reset;
                                    ExamResults.SetRange("Student No.",StudentUnits."Student No.");
                                    ExamResults.SetRange(Unit,StudentUnits.Unit);
                                      if ExamResults.Find('-') then begin
                                        ExamResults.CalcFields("Number of Repeats","Number of Resits");
                                        if ExamResults."Number of Repeats">0 then
                                        ACAExamClassificationUnits."No. of Repeats":=ExamResults."Number of Repeats"-1;
                                        if ExamResults."Number of Resits">0 then
                                        ACAExamClassificationUnits."No. of Resits":=ExamResults."Number of Resits"-1;
                                        end;

                              if   ACAExamClassificationUnits.Insert  then;
                              end;

                                        /////////////////////////// Update Unit Score
                            ACAExamClassificationUnits.Reset;
                            ACAExamClassificationUnits.SetRange("Student No.",Coregcs."Student No.");
                            ACAExamClassificationUnits.SetRange(Programme,Coregcs.Programme);
                            ACAExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
                            ACAExamClassificationUnits.SetRange("Academic Year",Coregcs."Academic Year");
                            ACAExamClassificationUnits.SetRange("Reporting Academic Year",Coregcs."Academic Year");
                            if ACAExamClassificationUnits.Find('-') then begin
                                     Clear(ACAExamResults_Fin);
                                      ACAExamResults_Fin.Reset;
                                     ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                                     ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                                     ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                                     ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3|%4','EXAM','EXAM100','EXAMS','FINAL EXAM');
                                     ACAExamResults_Fin.SetCurrentkey(Score);
                                     if ACAExamResults_Fin.Find('+') then begin
                                      ACAExamClassificationUnits."Exam Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                                      ACAExamClassificationUnits."Exam Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                                       end;
                                   //     END;

                                   //   IF ACAExamClassificationUnits."CAT Score"='' THEN BEGIN
                                     Clear(ACAExamResults_Fin); ACAExamResults_Fin.Reset;
                                     ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                                     ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                                     ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                                     ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                                     ACAExamResults_Fin.SetCurrentkey(Score);
                                     if ACAExamResults_Fin.Find('+') then begin
                                      ACAExamClassificationUnits."CAT Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                                      ACAExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                                       end;
                                      // END;

                                    //Update Total Marks
                                    if ((ACAExamClassificationUnits."Exam Score"='') and (ACAExamClassificationUnits."CAT Score"='')) then begin
                                      ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"None Exists";
                                   end else if ((ACAExamClassificationUnits."Exam Score"='') and (ACAExamClassificationUnits."CAT Score"<>'')) then begin
                                      ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"CAT Only";
                                   end  else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (ACAExamClassificationUnits."CAT Score"='')) then begin
                                      ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Exam Only";
                                   end else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (ACAExamClassificationUnits."CAT Score"<>'')) then begin
                                      ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Both Exists";
                                     end;

                                   if ((ACAExamClassificationUnits."Exam Score"<>'') and (ACAExamClassificationUnits."CAT Score"<>'')) then begin
                                      ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                                      ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                                      ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                                      end else begin
                                      ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                                      ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                                      ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                                        end;
                                          ACAExamClassificationUnits."Allow In Graduate":=true;
                                          /// Update Cummulative Resit
                                  Clear(AcaSpecialExamsDetailsz);
                                  AcaSpecialExamsDetailsz.Reset;
                                  AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                  AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                  AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                  if AcaSpecialExamsDetailsz.Find('-')  then begin

                                    AcaSpecialExamsDetailsz.Rename(AcaSpecialExamsDetailsz."Student No.",AcaSpecialExamsDetailsz."Unit Code",
                                    AcaSpecialExamsDetailsz."Academic Year",StudentUnits.Semester,                AcaSpecialExamsDetailsz.Sequence,
                                    AcaSpecialExamsDetailsz.Category,AcaSpecialExamsDetailsz.Programme);
                                    end;

                                        AcaSpecialExamsDetailsz.Reset;
                                        AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                        AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                        AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                        //AcaSpecialExamsDetailsz.SETRANGE(Semester,StudentUnits.Semester);
                                        AcaSpecialExamsDetailsz.SetRange("Exam Marks",0);
                                  if AcaSpecialExamsDetailsz.Find('-') then AcaSpecialExamsDetailsz.DeleteAll;


                            ACAExamCummulativeResit.Reset;
                            ACAExamCummulativeResit.SetRange("Student Number",StudentUnits."Student No.");
                            ACAExamCummulativeResit.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                        //    ACAExamCummulativeResit.SETRANGE("Academic Year",Coregcs."Academic Year");
                            if ACAExamCummulativeResit.Find('-') then ACAExamCummulativeResit.DeleteAll;
                            ACAExamClassificationUnits.CalcFields(Grade,"Grade Comment","Comsolidated Prefix",Pass);
                            if ACAExamClassificationUnits.Pass=false then begin
                             // ERROR('%1%2%3%4','The unit is ',ACAExamClassificationUnits."Unit Code" , ' academic Year is ', ACAExamClassificationUnits."Academic Year");
                                        //Populate Supplementary Here
                             begin
                                ACAExamCummulativeResit.Init;
                                ACAExamCummulativeResit."Student Number":=StudentUnits."Student No.";
                                ACAExamCummulativeResit."School Code":=ACAExamClassificationStuds."School Code";
                                ACAExamCummulativeResit."Academic Year":=Coregcs."Academic Year";
                                ACAExamCummulativeResit."Unit Code":=ACAExamClassificationUnits."Unit Code";
                                ACAExamCummulativeResit."Student Name":=ACAExamClassificationStuds."Student Name";
                                ACAExamCummulativeResit.Programme:=StudentUnits.Programme;
                                ACAExamCummulativeResit."School Name":=ACAExamClassificationStuds."School Name";
                                ACAExamCummulativeResit."Unit Description":=UnitsSubjects.Desription;
                                ACAExamCummulativeResit."Credit Hours":=UnitsSubjects."No. Units";
                                  ACAExamCummulativeResit."Unit Type":=ACAExamClassificationUnits."Unit Type";

                                ACAExamCummulativeResit.Score:=ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                                ACAExamCummulativeResit.Grade:=ACAExamClassificationUnits.Grade;
                                if ACAExamCummulativeResit.Insert then;

                                Clear(AcaSpecialExamsDetailsz);


                                AcaSpecialExamsDetailsz.Reset;
                               // AcaSpecialExamsDetailsz.SETRANGE("Academic Year",Coregcs."Academic Year");
                                AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                AcaSpecialExamsDetailsz.SetRange(Programme,StudentUnits.Programme);
                                AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                //AcaSpecialExamsDetailsz.SETRANGE(Semester,StudentUnits.Semester);
                                //AcaSpecialExamsDetailsz.SETRANGE(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                if not (AcaSpecialExamsDetailsz.Find('-')) then
                                  begin
                                       //AcaSpecialExamsDetailsz.DELETEALL;
                                AcaSpecialExamsDetailsz.Init;
                                AcaSpecialExamsDetailsz."Academic Year":=Coregcs."Academic Year";
                                AcaSpecialExamsDetailsz.Semester:=StudentUnits.Semester;
                                AcaSpecialExamsDetailsz."Student No.":=StudentUnits."Student No.";
                                AcaSpecialExamsDetailsz.Validate("Student No.");
                                AcaSpecialExamsDetailsz.Stage:=StudentUnits.Stage;
                                AcaSpecialExamsDetailsz.Programme:=StudentUnits.Programme;
                                AcaSpecialExamsDetailsz."Unit Code":=StudentUnits.Unit;  //
                                //AcaSpecialExamsDetailsz.Status:=AcaSpecialExamsDetailsz.Status::Approved;
                                AcaSpecialExamsDetailsz.Category:=AcaSpecialExamsDetailsz.Category::Supplementary;


                                Clear(AcaSpecialExamsDetails6);
                                AcaSpecialExamsDetails6.Reset;
                                AcaSpecialExamsDetails6.SetRange("Student No.",StudentUnits."Student No.");
                                AcaSpecialExamsDetails6.SetRange(Programme,StudentUnits.Programme);
                                AcaSpecialExamsDetails6.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                AcaSpecialExamsDetails6.SetRange(Category,AcaSpecialExamsDetails6.Category::Special);
                                AcaSpecialExamsDetails6.SetRange("Exam Marks",0);
                                if not (AcaSpecialExamsDetails6.Find('-')) then begin

                                  // Check if the Rubric allows for supp creation
                                if AcaSpecialExamsDetailsz.Insert(true) then;;
                          end;
                      end
                      else begin

                            AcaSpecialExamsDetailsz.Rename(AcaSpecialExamsDetailsz."Student No.",AcaSpecialExamsDetailsz."Unit Code",
                            AcaSpecialExamsDetailsz."Academic Year",StudentUnits.Semester,        AcaSpecialExamsDetailsz.Sequence,
                                   AcaSpecialExamsDetailsz.Category,AcaSpecialExamsDetailsz.Programme);
                      end;
                    end;
                            end else begin
                                AcaSpecialExamsDetailsz.Reset;
                                AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                AcaSpecialExamsDetailsz.SetRange(Semester,StudentUnits.Semester);
                                AcaSpecialExamsDetailsz.SetRange("Exam Marks",0);
                                 if AcaSpecialExamsDetailsz.Find('-') then AcaSpecialExamsDetailsz.DeleteAll;
                              end;
                                        if ACAExamClassificationUnits.Modify then;
                                                            //////////////////////////// Update Units Scores.. End
                            end else begin
                              StudentUnits."Unit not in Catalogue":=true;
                              end;
                              end;
                      StudentUnits.Modify;
                            ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii End of Finalize Units
                    end;

                        until StudentUnits.Next=0;
                      end;

                    end;
                    until Coregcs.Next=0;
                        Progressbar.Close;
                    end;


                    // Update Averages
                    Clear(TotalRecs);
                    Clear(CountedRecs);
                    Clear(RemeiningRecs);
                    Clear(ACAExamClassificationStuds);
                    ACAExamCourseRegistration.Reset;
                     ACAExamCourseRegistration.SetFilter("Reporting Academic Year",AcadYear);
                    if StudNos<>'' then
                    ACAExamCourseRegistration.SetFilter("Student Number",StudNos) else
                    ACAExamCourseRegistration.SetFilter(Programme,ProgFIls);// Only Apply Prog & School if Student FIlter is not Applied
                    if ACAExamCourseRegistration.Find('-') then begin
                      TotalRecs:=ACAExamCourseRegistration.Count;
                      RemeiningRecs:=TotalRecs;
                      ProgBar2.Open('#1#####################################################\'+
                      '#2############################################################\'+
                      '#3###########################################################\'+
                      '#4############################################################\'+
                      '#5###########################################################\'+
                      '#6############################################################');
                         ProgBar2.Update(1,'3 of 3 Updating Class Items');
                         ProgBar2.Update(2,'Total Recs.: '+Format(TotalRecs));
                        repeat
                          begin

                          Clear(Coregcs);
                          Coregcs.Reset;
                    Coregcs.SetFilter("Academic Year",ACAExamCourseRegistration."Academic Year");
                    Coregcs.SetRange("Exclude from Computation",false);
                    if StudNos<>'' then begin
                    Coregcs.SetFilter("Student No.",ACAExamCourseRegistration."Student Number");
                      end else begin
                        end;
                    if Coregcs.Find('-') then Coregcs.CalcFields("Stopage Yearly Remark");
                          Progyz.Reset;
                          Progyz.SetRange(Code,ACAExamCourseRegistration.Programme);
                          if Progyz.Find('-') then;
                          CountedRecs+=1;
                          RemeiningRecs-=1;
                         ProgBar2.Update(3,'.....................................................');
                         ProgBar2.Update(4,'Processed: '+Format(CountedRecs));
                         ProgBar2.Update(5,'Remaining: '+Format(RemeiningRecs));
                         ProgBar2.Update(6,'----------------------------------------------------');
                                ACAExamCourseRegistration.CalcFields("Total Marks","Total Courses","Total Weighted Marks",
                              "Total Units","Classified Total Marks","Total Classified C. Count","Classified W. Total","Attained Stage Units",Average,"Weighted Average");
                              ACAExamCourseRegistration."Normal Average":=ROUND((ACAExamCourseRegistration.Average),0.01,'=');
                              if ACAExamCourseRegistration."Total Units">0 then
                              ACAExamCourseRegistration."Weighted Average":=ROUND((ACAExamCourseRegistration."Total Weighted Marks"/ACAExamCourseRegistration."Total Units"),0.01,'=');
                              if ACAExamCourseRegistration."Total Classified C. Count"<>0 then
                              ACAExamCourseRegistration."Classified Average":=ROUND((ACAExamCourseRegistration."Classified Total Marks"/ACAExamCourseRegistration."Total Classified C. Count"),0.01,'=');
                              if ACAExamCourseRegistration."Total Classified Units"<>0 then
                              ACAExamCourseRegistration."Classified W. Average":=ROUND((ACAExamCourseRegistration."Classified W. Total"/ACAExamCourseRegistration."Total Classified Units"),0.01,'=');
                              ACAExamCourseRegistration.CalcFields("Defined Units (Flow)");
                              ACAExamCourseRegistration."Required Stage Units":=ACAExamCourseRegistration."Defined Units (Flow)";//RequiredStageUnits(ACAExamCourseRegistration.Programme,
                             // ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration."Student Number");
                              if ACAExamCourseRegistration."Required Stage Units">ACAExamCourseRegistration."Attained Stage Units" then
                              ACAExamCourseRegistration."Units Deficit":=ACAExamCourseRegistration."Required Stage Units"-ACAExamCourseRegistration."Attained Stage Units";
                              ACAExamCourseRegistration."Multiple Programe Reg. Exists":=GetMultipleProgramExists(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Academic Year");
                              ACAExamCourseRegistration."Final Classification":=GetRubric(Progyz,ACAExamCourseRegistration,Coregcs.Semester);
                               if Coregcs."Stopage Yearly Remark"<>'' then
                               ACAExamCourseRegistration."Final Classification":=Coregcs."Stopage Yearly Remark";
                               ACAExamCourseRegistration."Final Classification Pass":=GetRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                               ACAExamCourseRegistration."Academic Year",Progyz);
                               ACAExamCourseRegistration."Final Classification Order":=GetRubricOrder(ACAExamCourseRegistration."Final Classification");
                               ACAExamCourseRegistration.Graduating:=GetRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                               ACAExamCourseRegistration."Academic Year",Progyz);
                               ACAExamCourseRegistration.Classification:=ACAExamCourseRegistration."Final Classification";
                               ACAExamCourseRegistration.CalcFields("Attained Stage Units");
                               if ((ACAExamCourseRegistration.Classification = 'PASS') and (ACAExamCourseRegistration."Attained Stage Units" = 0)) then  begin
                                 ACAExamCourseRegistration.Classification := 'DTSC';
                                 ACAExamCourseRegistration."Final Classification":= 'DTSC';
                               ACAExamCourseRegistration.Graduating:=GetRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                               ACAExamCourseRegistration."Academic Year",Progyz);
                                 end;
                                 if ACAExamCourseRegistration."Total Courses"=0 then begin
                              // ACAExamCourseRegistration."Final Classification":='HALT';
                               ACAExamCourseRegistration."Final Classification Pass":=false;
                               ACAExamCourseRegistration."Final Classification Order":=10;
                               ACAExamCourseRegistration.Graduating:=false;
                              // ACAExamCourseRegistration.Classification:='HALT';
                                   end;
                               if Coregcs."Stopage Yearly Remark"<>'' then
                                 ACAExamCourseRegistration.Classification:=Coregcs."Stopage Yearly Remark";
                                 ACAExamCourseRegistration.CalcFields("Total Marks",
                    "Total Weighted Marks",
                    "Total Failed Courses",
                    "Total Failed Units",
                    "Failed Courses",
                    "Failed Units",
                    "Failed Cores",
                    "Failed Required",
                    "Failed Electives",
                    "Total Cores Done",
                    "Total Cores Passed",
                    "Total Required Done",
                    "Total Electives Done",
                    "Tota Electives Passed");
                    ACAExamCourseRegistration.CalcFields(
                    "Classified Electives C. Count",
                    "Classified Electives Units",
                    "Total Classified C. Count",
                    "Total Classified Units",
                    "Classified Total Marks",
                    "Classified W. Total",
                    "Total Failed Core Units");
                              ACAExamCourseRegistration."Cummulative Fails":=GetCummulativeFails(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study");
                              ACAExamCourseRegistration."Cumm. Required Stage Units":=GetCummulativeReqStageUnitrs(ACAExamCourseRegistration.Programme,ACAExamCourseRegistration."Year of Study",
                              ACAExamCourseRegistration."Programme Option",ACAExamCourseRegistration."Academic Year");
                              ACAExamCourseRegistration."Cumm Attained Units":=GetCummAttainedUnits(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration.Programme);
                               ACAExamCourseRegistration.Modify;
                               ACAExamCourseRegistration.CalcFields("Skip Supplementary Generation");
                               if ACAExamCourseRegistration."Skip Supplementary Generation" = true then begin
                                 // Delete all Supp Registrations here
                                 if Coregcs.Find('-') then begin
                                   repeat
                                     begin
                                 Clear(AcaSpecialExamsDetailsz);
                                  AcaSpecialExamsDetailsz.Reset;
                                  AcaSpecialExamsDetailsz.SetRange("Student No.",ACAExamCourseRegistration."Student Number");
                    AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                    AcaSpecialExamsDetailsz.SetRange(Semester,Coregcs.Semester);
                    AcaSpecialExamsDetailsz.SetRange("Exam Marks",0);
                                  if AcaSpecialExamsDetailsz.Find('-') then AcaSpecialExamsDetailsz.DeleteAll;
                                  end;
                                  until Coregcs.Next = 0;
                                  end;
                                 end;
                                  end;
                                  until ACAExamCourseRegistration.Next=0;
                      ProgBar2.Close;
                              end;

                                ACASenateReportsHeader.Reset;
                                ACASenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                                ACASenateReportsHeader.SetFilter("Reporting Academic Year",Coregcs."Academic Year");
                                if ACASenateReportsHeader.Find('-') then begin
                                  ProgBar22.Open('#1##########################################');
                                  repeat
                                      begin
                                      ProgBar22.Update(1,'Student Number: '+ACASenateReportsHeader."Programme Code"+' Class: '+ACASenateReportsHeader."Classification Code");
                                      with ACASenateReportsHeader do
                                        begin
                                          ACASenateReportsHeader.CalcFields("School Classification Count","School Total Passed","School Total Passed",
                                          "School Total Failed","Programme Classification Count","Programme Total Passed","Programme Total Failed","School Total Count",
                                          "Prog. Total Count");

                                          CalcFields("School Classification Count","School Total Passed","School Total Failed","School Total Count",
                                          "Programme Classification Count","Prog. Total Count","Programme Total Failed","Programme Total Passed");
                                          if "School Total Count">0 then
                                          "Sch. Class % Value":=ROUND((("School Classification Count"/"School Total Count")*100),0.01,'=');
                                          if "School Total Count">0 then
                                          "School % Failed":=ROUND((("School Total Failed"/"School Total Count")*100),0.01,'=');
                                          if "School Total Count">0 then
                                          "School % Passed":=ROUND((("School Total Passed"/"School Total Count")*100),0.01,'=');
                                          if "Prog. Total Count">0 then
                                          "Prog. Class % Value":=ROUND((("Programme Classification Count"/"Prog. Total Count")*100),0.01,'=');
                                          if "Prog. Total Count">0 then
                                          "Programme % Failed":=ROUND((("Programme Total Failed"/"Prog. Total Count")*100),0.01,'=');
                                          if "Prog. Total Count">0 then
                                          "Programme % Passed":=ROUND((("Programme Total Passed"/"Prog. Total Count")*100),0.01,'=');
                                          end;
                                          ACASenateReportsHeader.Modify;
                                      end;
                                    until ACASenateReportsHeader.Next=0;
                                    ProgBar22.Close;
                                    end;


                      end;
                      until ProgForFilters.Next = 0;
                      end;
                      UpdateSupplementaryMarks;
                    Message('Processing completed successfully!');
                    if StrLen(programs)>249 then programs:=CopyStr(programs,1,249);
                    if StrLen(AcadYear)>249 then AcadYear:=CopyStr(AcadYear,1,249) else AcadYear:=AcadYear;
                    if StrLen(Schools)>249 then Schools:=CopyStr(Schools,1,249);

                    UpdateFilters(UserId,programs,AcadYear,Schools);
                    // Delete Token
                        ACAExamProcActiveUsers2.Reset;
                        ACAExamProcActiveUsers2.SetRange("Processing Users",UserId);
                        if ACAExamProcActiveUsers2.Find('-') then ACAExamProcActiveUsers2.DeleteAll;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        // Delete Token
            ACAExamProcActiveUsers2.Reset;
            ACAExamProcActiveUsers2.SetRange("Processing Users",UserId);
            if ACAExamProcActiveUsers2.Find('-') then ACAExamProcActiveUsers2.DeleteAll;
    end;

    trigger OnOpenPage()
    var
        ACAExamProcessingFilterLog: Record UnknownRecord78010;
    begin
        ACAExamProcessingFilterLog.Reset;
        ACAExamProcessingFilterLog.SetRange("User ID",UserId);
        if ACAExamProcessingFilterLog.Find('-') then begin
        UnitCode:=ACAExamProcessingFilterLog."Unit Code";
        programs:=ACAExamProcessingFilterLog."Programme Code";
        Schools:=ACAExamProcessingFilterLog."School Filters";
        AcadYear:=ACAExamProcessingFilterLog."Graduation Year";
        //StudNos:=ACAExamProcessingFilterLog."Student No";
          end;
          ACAAcademicYear963.Reset;
          ACAAcademicYear963.SetRange("Graduating Group",true);
          if not ACAAcademicYear963.Find('-') then Error('Graduating group is not defined!');
         // GradAcademicYear:=ACAAcademicYear963.Code;
    end;

    var
        YoS: Integer;
        programs: Code[1024];
        AcadYear: Code[1024];
        Stages: Code[1024];
        StudNos: Code[1024];
        ACAExamResultsBuffer2: Record UnknownRecord61746;
        ACAExamResults: Record UnknownRecord61548;
        SemesterFilter: Text[1024];
        ACACourseRegistration5: Record UnknownRecord61532;
        Progrezz: Dialog;
        ACAProgramme963: Record UnknownRecord61511;
        ACAAcademicYear963: Record UnknownRecord61382;
        Schools: Code[1024];
        UnitCode: Code[1024];
        ACAProgrammeStages: Record UnknownRecord61516;
        ProgFIls: Text[1024];
        Progressbar: Dialog;
        ToGraduate: Boolean;
        YosStages: Text[150];
        ACAExamProcActiveUsers: Record UnknownRecord66675;
        ACAExamProcActiveUsers2: Record UnknownRecord66675;
        ExamsProcessing: Codeunit "Exams Processing";
        AcaSpecialExamsResults: Record UnknownRecord78003;
        Aca2ndSuppExamsResults: Record UnknownRecord78032;
        ProgForFilters: Record UnknownRecord61511;
        AcaAcademicYear_Buffer: Record UnknownRecord65815;
        AcaAcademicYear_Buffer2: Record UnknownRecord65815;
        CountedLoops: Integer;
        AcademicYearArray: array [100] of Text[20];
        ACACourseRegistration: Record UnknownRecord61532;
        Arrayfound: Boolean;

    local procedure UpdateFilters(UserCode: Code[50];ProgCodes: Code[1024];GradYearOfStudy: Code[1024];Schoolscodes: Code[250])
    var
        ACAExamProcessingFilterLog: Record UnknownRecord78010;
    begin
        ACAExamProcessingFilterLog.Reset;
        ACAExamProcessingFilterLog.SetRange("User ID",UserCode);
        if ACAExamProcessingFilterLog.Find('-') then begin
          //Exists, Update
          ACAExamProcessingFilterLog."Programme Code":=ProgCodes;
          ACAExamProcessingFilterLog."Graduation Year":=AcadYear;
          ACAExamProcessingFilterLog."School Filters":=Schoolscodes;
          ACAExamProcessingFilterLog."Student No":=StudNos;
          ACAExamProcessingFilterLog."Unit Code":=UnitCode;
          ACAExamProcessingFilterLog.Modify;
          end else begin
            // Doesent Exists, Insert
          ACAExamProcessingFilterLog.Init;
          ACAExamProcessingFilterLog."User ID":=UserCode;
          ACAExamProcessingFilterLog."Programme Code":=ProgCodes;
          ACAExamProcessingFilterLog."Graduation Year":=AcadYear;
          ACAExamProcessingFilterLog."School Filters":=Schoolscodes;
          ACAExamProcessingFilterLog."Student No":=StudNos;
          ACAExamProcessingFilterLog."Unit Code":=UnitCode;
          if ACAExamProcessingFilterLog.Insert then;
            end;
    end;

    local procedure GetStudentName(StudNo: Code[20]) StudName: Text[250]
    var
        Customer: Record Customer;
    begin
        Customer.Reset;
        Customer.SetRange("No.",StudNo);
        if Customer.Find('-') then begin
          if StrLen(Customer.Name)>100 then Customer.Name:=CopyStr(Customer.Name,1,100);
          Customer.Name:=Customer.Name;
          Customer.Modify;
          StudName:=Customer.Name;
          end;
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

    local procedure GetMultipleProgramExists(StudNoz: Code[20];AcadYearsz: Code[20]) Multiples: Boolean
    var
        ACAExamClassificationStuds: Record UnknownRecord66653;
        ClassClassificationCourseReg: Record UnknownRecord66631;
        ClassClassificationUnits: Record UnknownRecord66632;
    begin
        ACAExamClassificationStuds.Reset;
        ACAExamClassificationStuds.SetRange("Student Number",StudNoz);
        ACAExamClassificationStuds.SetRange("Academic Year",AcadYearsz);
        if ACAExamClassificationStuds.Find('-') then
          if ACAExamClassificationStuds.Count>1 then Multiples:=true else Multiples:=false;
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
            Cohort:=ACAProgrammeGraduationGroup."Admission Academic Year";
          end;
    end;

    local procedure RequiredStageUnits(ProgCode: Code[20];YoS: Integer;StudNo: Code[20];AcademicYear: Code[20]) ExpectedUnits: Decimal
    var
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        AcacourseReg: Record UnknownRecord61532;
    begin
        ACADefinedUnitsperYoS.Reset;
        ACADefinedUnitsperYoS.SetRange("Year of Study",YoS);
        ACADefinedUnitsperYoS.SetRange(Programme,ProgCode);
        if AcademicYear = '' then Error('Missng academic year on Student: '+StudNo+', Year of Study: '+Format(YoS));
        ACADefinedUnitsperYoS.SetRange("Academic Year",AcademicYear);
        AcacourseReg.Reset;
        AcacourseReg.SetRange("Student No.",StudNo);
        AcacourseReg.SetRange(Programme,ProgCode);
        AcacourseReg.SetRange("Year Of Study",YoS);
        if AcacourseReg.Find('-') then
          if AcacourseReg.Options<>'-' then
        ACADefinedUnitsperYoS.SetRange(Options,AcacourseReg.Options);
        if ACADefinedUnitsperYoS.Find('-') then ExpectedUnits:=ACADefinedUnitsperYoS."Number of Units";
    end;

    local procedure GetClassification(ProgramCode: Code[100];AverageScore: Decimal;HasIrregularity: Boolean) Classification: Code[100]
    var
        ACAClassGradRubrics: Record UnknownRecord78011;
        ACAProgramme123: Record UnknownRecord61511;
        ACAGradingSystemSetup: Record UnknownRecord61599;
    begin
        Clear(Classification);
        ACAProgramme123.Reset;
        ACAProgramme123.SetRange(Code,ProgramCode);
        if ACAProgramme123.Find('-') then begin
        ACAGradingSystemSetup.Reset;
          ACAGradingSystemSetup.SetRange(Category,ACAProgramme123."Exam Category");
          ACAGradingSystemSetup.SetFilter("Lower Limit",'=%1|<%2',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetFilter("Upper Limit",'>%2|=%1',AverageScore,AverageScore);
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
            end;
          end;
    end;


    procedure GetClassificationGrade(EXAMMark: Decimal;Proga: Code[20]) xGrade: Text[100]
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
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
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


    procedure GetClassPassStatus(EXAMMark: Decimal;Proga: Code[20]) Passed: Boolean
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
        Marks:=EXAMMark;
        GradeCategory:='';
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(Proga) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';

        Passed:=false;
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
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

        end;
    end;

    local procedure GetClassificationOrder(ProgramCode: Code[100];AverageScore: Decimal;HasIrregularity: Boolean) ClassOrder: Integer
    var
        ACAClassGradRubrics: Record UnknownRecord78011;
        ACAProgramme123: Record UnknownRecord61511;
        ACAGradingSystemSetup: Record UnknownRecord61599;
        Classification: Code[50];
    begin
        Clear(Classification);
        ACAProgramme123.Reset;
        ACAProgramme123.SetRange(Code,ProgramCode);
        if ACAProgramme123.Find('-') then begin
        ACAGradingSystemSetup.Reset;
          ACAGradingSystemSetup.SetRange(Category,ACAProgramme123."Exam Category");
          ACAGradingSystemSetup.SetFilter("Lower Limit",'=%1|<%2',AverageScore,AverageScore);
          ACAGradingSystemSetup.SetFilter("Upper Limit",'>%2|=%1',AverageScore,AverageScore);
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
            end;
          end;
          Clear(ClassOrder);
          ACAClassGradRubrics.Reset;
          ACAClassGradRubrics.SetRange(Code,Classification);
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

    local procedure GetRubric(ACAProgramme: Record UnknownRecord61511;CoursesRegz: Record UnknownRecord66651;Semesz: Code[10]) StatusRemarks: Text[150]
    var
        Customer: Record UnknownRecord61532;
        LubricIdentified: Boolean;
        ACAResultsStatus: Record UnknownRecord61739;
        YearlyReMarks: Text[250];
        StudCoregcs: Record UnknownRecord61532;
        StudCoregcs2: Record UnknownRecord61532;
        StudCoregcs24: Record UnknownRecord61532;
        Customersz: Record Customer;
        ACARegStoppageReasons: Record UnknownRecord66620;
        AcaSpecialExamsDetails: Record UnknownRecord78002;
    begin
        Clear(StatusRemarks);
        Clear(YearlyReMarks);
              Customer.Reset;
              Customer.SetRange("Student No.",CoursesRegz."Student Number");
              Customer.SetRange("Academic Year",CoursesRegz."Academic Year");
              if Customer.Find('+') then  begin
                if ((Customer.Status=Customer.Status::Registration) or (Customer.Status=Customer.Status::Current)) then begin
          Clear(LubricIdentified);
                  CoursesRegz.CalcFields("Attained Stage Units","Failed Cores","Failed Courses","Failed Electives","Failed Required","Failed Units",
                  "Total Failed Units","Total Marks","Total Required Done",
                  "Total Required Passed","Total Units","Total Weighted Marks","Exists DTSC Prefix");
                  CoursesRegz.CalcFields("Total Cores Done","Total Cores Passed","Total Courses","Total Electives Done","Total Failed Courses",
                  "Tota Electives Passed","Total Classified C. Count","Total Classified Units","Total Classified Units");
                  if CoursesRegz."Total Courses">0 then
                    CoursesRegz."% Failed Courses":=(CoursesRegz."Failed Courses"/CoursesRegz."Total Courses")*100;
                  CoursesRegz."% Failed Courses":=ROUND(CoursesRegz."% Failed Courses",0.01,'>');
                  if CoursesRegz."% Failed Courses">100 then CoursesRegz."% Failed Courses":=100;
                  if CoursesRegz."Total Cores Done">0 then
                    CoursesRegz."% Failed Cores":=((CoursesRegz."Failed Cores"/CoursesRegz."Total Cores Done")*100);
                  CoursesRegz."% Failed Cores":=ROUND(CoursesRegz."% Failed Cores",0.01,'>');
                  if CoursesRegz."% Failed Cores">100 then CoursesRegz."% Failed Cores":=100;
                  if CoursesRegz."Total Units">0 then
                    CoursesRegz."% Failed Units":=(CoursesRegz."Failed Units"/CoursesRegz."Total Units")*100;
                  CoursesRegz."% Failed Units":=ROUND(CoursesRegz."% Failed Units",0.01,'>');
                  if CoursesRegz."% Failed Units">100 then CoursesRegz."% Failed Units":=100;
                  if CoursesRegz."Total Electives Done">0 then
                    CoursesRegz."% Failed Electives":=(CoursesRegz."Failed Electives"/CoursesRegz."Total Electives Done")*100;
                  CoursesRegz."% Failed Electives":=ROUND(CoursesRegz."% Failed Electives",0.01,'>');
                  if CoursesRegz."% Failed Electives">100 then CoursesRegz."% Failed Electives":=100;
                           // CoursesRegz.MODIFY;
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        if ACAProgramme."Special Programme Class"=ACAProgramme."special programme class"::"Medicine & Nursing" then begin
        ACAResultsStatus.SetFilter("Special Programme Class",'=%1',ACAResultsStatus."special programme class"::"Medicine & Nursing");
        end else begin
          ACAResultsStatus.SetFilter("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
          ACAResultsStatus.SetFilter("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
        end;
          ACAResultsStatus.SetFilter("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
          ACAResultsStatus.SetFilter("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
        ACAResultsStatus.SetCurrentkey("Order No");
        if ACAResultsStatus.Find('-') then begin
          repeat
          begin
              StatusRemarks:=ACAResultsStatus.Code;
              if ACAResultsStatus."Lead Status"<>'' then
              StatusRemarks:=ACAResultsStatus."Lead Status";
              YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
              LubricIdentified:=true;
          end;
          until ((ACAResultsStatus.Next=0) or (LubricIdentified=true))
        end;
        CoursesRegz.CalcFields("Supp/Special Exists","Attained Stage Units","Special Registration Exists");
        if CoursesRegz."Required Stage Units">CoursesRegz."Attained Stage Units" then StatusRemarks:='DTSC';
        if CoursesRegz."Exists DTSC Prefix" then StatusRemarks:='DTSC';
        if CoursesRegz."Special Registration Exists" then StatusRemarks:='Special';

        ////////////////////////////////////////////////////////////////////////////////////////////////
        // Check if exists a stopped Semester for the Academic Years and Pick the Status on the lines as the rightful Status
        Clear(StudCoregcs24);
        StudCoregcs24.Reset;
        StudCoregcs24.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs24.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs24.SetRange(Reversed,true);
        if StudCoregcs24.Find('-') then begin

          Clear(ACARegStoppageReasons);
          ACARegStoppageReasons.Reset;
          ACARegStoppageReasons.SetRange("Reason Code",StudCoregcs24."Stoppage Reason");
          if ACARegStoppageReasons.Find('-') then begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Status,ACARegStoppageReasons."Global Status");
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        end else begin
         // StatusRemarks:=UPPERCASE(FORMAT(Customer.Status));
          StatusRemarks:=UpperCase(Format(StudCoregcs24."Stoppage Reason"));
          YearlyReMarks:=StatusRemarks;
          end;
          end;
          end;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

                  end else begin

        CoursesRegz.CalcFields("Attained Stage Units");
        if CoursesRegz."Attained Stage Units" = 0 then  StatusRemarks:='DTSC';
        Clear(StudCoregcs);
        StudCoregcs.Reset;
        StudCoregcs.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs.SetRange("Stoppage Exists In Acad. Year",true);
        if StudCoregcs.Find('-') then begin
        Clear(StudCoregcs2);
        StudCoregcs2.Reset;
        StudCoregcs2.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs2.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs2.SetRange("Stoppage Exists In Acad. Year",true);
        StudCoregcs2.SetRange(Reversed,true);
        if StudCoregcs2.Find('-') then begin
            StatusRemarks:=UpperCase(Format(StudCoregcs2."Stoppage Reason"));
          YearlyReMarks:=StatusRemarks;
          end;
          end;

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Status,Customer.Status);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        end else begin
          StatusRemarks:=UpperCase(Format(Customer.Status));
          YearlyReMarks:=StatusRemarks;
          end;
                    end;
                end;

        Clear(ACAResultsStatus);
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,StatusRemarks);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          // Check if the Ststus does not allow Supp. Generation and delete
          if ACAResultsStatus."Skip Supp Generation" = true then  begin
            // Delete Entries from Supp Registration for the Semester
            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",CoursesRegz."Student Number");
            AcaSpecialExamsDetails.SetRange("Year of Study",CoursesRegz."Year of Study");
            AcaSpecialExamsDetails.SetRange("Exam Marks",0);
            AcaSpecialExamsDetails.SetRange(Semester,Semesz);
            AcaSpecialExamsDetails.SetRange(Status,AcaSpecialExamsDetails.Status::New);
            if AcaSpecialExamsDetails.Find('-') then AcaSpecialExamsDetails.DeleteAll;
            end;
          end;
    end;

    local procedure GetRubricPassStatus(RubricCode: Code[50];AcademicYears: Code[20];Progyz: Record UnknownRecord61511) PassStatus: Boolean
    var
        ACAResultsStatus: Record UnknownRecord61739;
    begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,RubricCode);
        ACAResultsStatus.SetRange("Academic Year",AcademicYears);
        ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          PassStatus:=ACAResultsStatus.Pass;
        end;
    end;

    local procedure GetRubricOrder(RubricCode: Code[50]) RubricOrder: Integer
    var
        ACAResultsStatus: Record UnknownRecord61739;
    begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,RubricCode);
        if ACAResultsStatus.Find('-') then begin
          RubricOrder:=ACAResultsStatus."Order No";
        end;
    end;

    local procedure GetProgFilters1(Programs: Code[1024];Schools: Code[1024]) ProgFilters: Code[1024]
    var
        ACAProgramme963: Record UnknownRecord61511;
        Progs2: Code[1024];
        exitLoop: Boolean;
    begin
        Clear(Progs2);
        Clear(ProgFilters);
        if ((Schools='') and (Programs='')) then Error('Specify a Programme and/or a School filter');
        Clear(exitLoop);
        if Schools<>'' then begin
          ACAProgramme963.Reset;
          ACAProgramme963.SetFilter(ACAProgramme963."School Code",Schools);
          if ACAProgramme963.Find('-') then begin
            repeat
              begin
              if ACAProgramme963.Code<>'' then begin
                  if ProgFilters='' then ProgFilters:=ACAProgramme963.Code
                  else begin
                    if (StrLen(ProgFilters)+StrLen(ACAProgramme963.Code)) < 1024 then begin
                       ProgFilters:=ProgFilters+'|'+ACAProgramme963.Code;
                      end else begin
                        end;
                    end;
                    end;
                    end;
                    until ((ACAProgramme963.Next=0) or (exitLoop=true));
                    end;
        end else if Programs<>'' then begin
          ProgFilters:=Programs;
          end;
    end;

    local procedure GetProgFilters2(Programs: Code[1024];Schools: Code[1024]) Progs2: Code[1024]
    var
        ACAProgramme963: Record UnknownRecord61511;
        ProgFilters: Code[1024];
    begin
        Clear(Progs2);
        Clear(ProgFilters);
        if ((Schools='') and (Programs='')) then Error('Specify a Programme and/or a School filter');

        if Schools<>'' then begin
          ACAProgramme963.Reset;
          ACAProgramme963.SetFilter(ACAProgramme963."School Code",Schools);
          if ACAProgramme963.Find('-') then begin
            repeat
              begin
              if ACAProgramme963.Code<>'' then begin
                  if ProgFilters='' then ProgFilters:=ACAProgramme963.Code
                  else begin
                    if (StrLen(ProgFilters)+StrLen(ACAProgramme963.Code)) < 1024 then begin
                       ProgFilters:=ProgFilters+'|'+ACAProgramme963.Code;
                      end else begin
                        if Progs2='' then Progs2:=ACAProgramme963.Code else begin
                         if (StrLen(Progs2)+StrLen(ACAProgramme963.Code)) < 1024 then begin
                           Progs2:=Progs2+'|'+ACAProgramme963.Code;
                           end;
                          end;
                        end;
                    end;
                    end;
                    end;
                    until ACAProgramme963.Next=0;
                    end;
        end else if Programs<>'' then begin
          ProgFilters:=Programs;
          end;
    end;

    local procedure GetUnitAcademicYear(ACAExamClassificationUnits9: Record UnknownRecord66650) AcademicYear: Code[20]
    var
        ACACourseRegistration9: Record UnknownRecord61532;
    begin
        Clear(AcademicYear);
        ACACourseRegistration9.Reset;
        ACACourseRegistration9.SetRange("Student No.",ACAExamClassificationUnits9."Student No.");
        ACACourseRegistration9.SetRange(Programme,ACAExamClassificationUnits9.Programme);
        ACACourseRegistration9.SetRange("Year Of Study",ACAExamClassificationUnits9."Year of Study");
        ACACourseRegistration9.SetRange(Reversed,false);
        ACACourseRegistration9.SetFilter("Academic Year",'<>%1','');
        if ACACourseRegistration9.Find('-') then AcademicYear:=ACACourseRegistration9."Academic Year"
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

    local procedure GetCummulativeFails(StudNo: Code[20];YoS: Integer) CumFails: Integer
    var
        AcadClassUnits: Record UnknownRecord66650;
    begin
        AcadClassUnits.Reset;
        AcadClassUnits.SetRange("Student No.",StudNo);
        AcadClassUnits.SetFilter("Year of Study",'..%1',YoS);
        AcadClassUnits.SetRange(Pass,false);
        if AcadClassUnits.Find('-') then CumFails:=AcadClassUnits.Count;
    end;

    local procedure GetCummulativeReqStageUnitrs(Programmez: Code[20];YoS: Integer;ProgOption: Code[20];AcademicYearssss: Code[20]) CummReqUNits: Decimal
    var
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
    begin
        Clear(CummReqUNits);
        ACADefinedUnitsperYoS.Reset;
        ACADefinedUnitsperYoS.SetRange(Programme,Programmez);
        ACADefinedUnitsperYoS.SetRange(Options,ProgOption);
        ACADefinedUnitsperYoS.SetRange("Academic Year",AcademicYearssss);
        ACADefinedUnitsperYoS.SetFilter("Year of Study",'..%1',YoS);
        if ACADefinedUnitsperYoS.Find('-') then begin
          repeat
            begin
            CummReqUNits:=CummReqUNits+ACADefinedUnitsperYoS."Number of Units";
            end;
              until ACADefinedUnitsperYoS.Next=0;
          end;
    end;

    local procedure GetCummAttainedUnits(StudNo: Code[20];YoS: Integer;Programmesz: Code[20]) CummAttained: Integer
    var
        AcadClassUnits: Record UnknownRecord66650;
    begin
        AcadClassUnits.Reset;
        AcadClassUnits.SetRange("Student No.",StudNo);
        AcadClassUnits.SetFilter("Year of Study",'..%1',YoS);
        AcadClassUnits.SetFilter(Programme,'%1',Programmesz);
        if AcadClassUnits.Find('-') then CummAttained:=AcadClassUnits.Count;
    end;

    local procedure UpdateSupplementaryMarks()
    var
        ACAExamCourseRegistration4SuppGeneration: Record UnknownRecord66651;
        CATExists: Boolean;
        CountedSeq: Integer;
        ACAExamCategory: Record UnknownRecord61568;
        ACAGeneralSetUp: Record UnknownRecord61534;
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        AcaSpecialExamsDetails3: Record UnknownRecord78002;
        ACAExamSuppUnits: Record UnknownRecord66649;
        AcdYrs: Record UnknownRecord61382;
        Custos: Record Customer;
        StudentUnits: Record UnknownRecord61549;
        Coregcsz10: Record UnknownRecord61532;
        CountedRegistrations: Integer;
        UnitsSubjects: Record UnknownRecord61517;
        Programme_Fin: Record UnknownRecord61511;
        ProgrammeStages_Fin: Record UnknownRecord61516;
        AcademicYear_Fin: Record UnknownRecord61382;
        Semesters_Fin: Record UnknownRecord61692;
        ExamResults: Record UnknownRecord61548;
        ClassCustomer: Record Customer;
        ClassExamResultsBuffer2: Record UnknownRecord61746;
        ClassDimensionValue: Record "Dimension Value";
        ClassGradingSystem: Record UnknownRecord61521;
        ClassClassGradRubrics: Record UnknownRecord78011;
        ClassExamResults2: Record UnknownRecord61548;
        TotalRecs: Integer;
        CountedRecs: Integer;
        RemeiningRecs: Integer;
        ExpectedElectives: Integer;
        CountedElectives: Integer;
        ProgBar2: Dialog;
        Progyz: Record UnknownRecord61511;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        ACAExamClassificationUnits: Record UnknownRecord66641;
        ACAExamCourseRegistration: Record UnknownRecord66642;
        ACAExamFailedReasons: Record UnknownRecord66643;
        ACASenateReportsHeader: Record UnknownRecord66645;
        ACAExamClassificationStuds: Record UnknownRecord66644;
        ACAExamClassificationStudsCheck: Record UnknownRecord66644;
        ACAExamResultsFin: Record UnknownRecord61548;
        ACAResultsStatus: Record UnknownRecord61739;
        ACAResultsStatusSuppGen: Record UnknownRecord61739;
        ProgressForCoReg: Dialog;
        Tens: Text;
        ACASemesters: Record UnknownRecord61692;
        ACAExamResults_Fin: Record UnknownRecord61548;
        ProgBar22: Dialog;
        Coregcs: Record UnknownRecord61532;
        ACAExamCummulativeResit: Record UnknownRecord66647;
        ACAStudentUnitsForResits: Record UnknownRecord61549;
        SEQUENCES: Integer;
        CurrStudentNo: Code[20];
        CountedNos: Integer;
        CurrSchool: Code[20];
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        Aca2ndSuppExamsResults: Record UnknownRecord78032;
        Aca2ndSuppExamsDetails3: Record UnknownRecord78031;
        Aca2ndSuppExamsDetails4: Record UnknownRecord78031;
        AcaSpecialExamsDetails4: Record UnknownRecord78002;
        ACAResultsStatusSupp: Record UnknownRecord69266;
    begin
        Clear(ProgFIls);
        Clear(ProgForFilters);
        ProgForFilters.Reset;
        if Schools<>'' then
        ProgForFilters.SetFilter("School Code",Schools) else
        if programs<>'' then
        ProgForFilters.SetFilter(Code,programs);
        if ProgForFilters.Find('-') then begin
          repeat
            begin
        // Clear CLassification For Selected Filters
        ProgFIls:=ProgForFilters.Code;

        Clear(ACAExamClassificationStuds);
        Clear(ACAExamCourseRegistration);
        Clear(ACAExamClassificationUnits);
        Clear(ACAExamSuppUnits);
        ACAExamClassificationStuds.Reset;
        ACAExamCourseRegistration.Reset;
        ACAExamClassificationUnits.Reset;
        ACAExamSuppUnits.Reset;
        if StudNos<>'' then begin
        ACAExamClassificationStuds.SetFilter("Student Number",StudNos);
        ACAExamCourseRegistration.SetRange("Student Number",StudNos);
        ACAExamClassificationUnits.SetRange("Student No.",StudNos);
        ACAExamSuppUnits.SetRange("Student No.",StudNos);
        end;
        if AcadYear<>'' then begin
        ACAExamClassificationStuds.SetFilter("Academic Year",AcadYear);
        ACAExamCourseRegistration.SetFilter("Academic Year",AcadYear);
        ACAExamClassificationUnits.SetFilter("Academic Year",AcadYear);
        ACAExamSuppUnits.SetFilter("Academic Year",AcadYear);
        end;

        ACAExamClassificationStuds.SetFilter(Programme,ProgFIls);
        ACAExamCourseRegistration.SetFilter(Programme,ProgFIls);
        ACAExamClassificationUnits.SetFilter(Programme,ProgFIls);
        ACAExamSuppUnits.SetFilter(Programme,ProgFIls);
        if ACAExamClassificationStuds.Find('-') then ACAExamClassificationStuds.DeleteAll;
        if ACAExamCourseRegistration.Find('-') then ACAExamCourseRegistration.DeleteAll;
        if ACAExamClassificationUnits.Find('-') then ACAExamClassificationUnits.DeleteAll;
        if ACAExamSuppUnits.Find('-') then ACAExamSuppUnits.DeleteAll;


                          ACASenateReportsHeader.Reset;
                          ACASenateReportsHeader.SetFilter("Academic Year",AcadYear);
                          ACASenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                          if  (ACASenateReportsHeader.Find('-')) then ACASenateReportsHeader.DeleteAll;

        Coregcs.Reset;
        Coregcs.SetFilter(Programme,ProgFIls);
        Coregcs.SetFilter("Academic Year",AcadYear);
        Coregcs.SetRange("Exclude from Computation",false);
        Coregcs.SetRange("Supp/Special Exists",true);
        if StudNos<>'' then begin
        Coregcs.SetFilter("Student No.",StudNos);
          end;
        if Coregcs.Find('-') then begin
          Clear(TotalRecs);
        Clear(RemeiningRecs);
        Clear(CountedRecs);
        TotalRecs:=Coregcs.Count;
        RemeiningRecs:=TotalRecs;
          // Loop through all Ungraduated Students Units
          Progressbar.Open('#1#####################################################\'+
          '#2############################################################\'+
          '#3###########################################################\'+
          '#4############################################################\'+
          '#5###########################################################\'+
          '#6############################################################');
             Progressbar.Update(1,'Processing  values....');
             Progressbar.Update(2,'Total Recs.: '+Format(TotalRecs));
          repeat
            begin

            CountedRecs:=CountedRecs+1;
            RemeiningRecs:=RemeiningRecs-1;
            // Create Registration Unit entry if Not Exists
             Progressbar.Update(3,'.....................................................');
             Progressbar.Update(4,'Processed: '+Format(CountedRecs));
             Progressbar.Update(5,'Remaining: '+Format(RemeiningRecs));
             Progressbar.Update(6,'----------------------------------------------------');
                Progyz.Reset;
                Progyz.SetFilter(Code,Coregcs.Programme);
             if Progyz.Find('-') then begin
               end;
               Clear(YosStages);
            if Coregcs."Year Of Study"=0 then  begin Coregcs.Validate(Stage);
              Coregcs.Modify;
              end;
            if Coregcs."Year Of Study"=1 then YosStages:='Y1S1|Y1S2|Y1S3|Y1S4'
            else if Coregcs."Year Of Study"=2 then YosStages:='Y2S1|Y2S2|Y2S3|Y2S4'
            else if Coregcs."Year Of Study"=3 then YosStages:='Y3S1|Y3S2|Y3S3|Y3S4'
            else if Coregcs."Year Of Study"=4 then YosStages:='Y4S1|Y4S2|Y4S3|Y4S4'
            else if Coregcs."Year Of Study"=5 then YosStages:='Y5S1|Y5S2|Y5S3|Y5S4'
            else if Coregcs."Year Of Study"=6 then YosStages:='Y6S1|Y6S2|Y6S3|Y6S4'
            else if Coregcs."Year Of Study"=7 then YosStages:='Y7S1|Y7S2|Y7S3|Y7S4'
            else if Coregcs."Year Of Study"=8 then YosStages:='Y8S1|Y8S2|Y8S3|Y8S4';


        Custos.Reset;
        Custos.SetRange("No.",Coregcs."Student No.");
        if Custos.Find('-') then
        Custos.CalcFields("Senate Classification Based on");
        Clear(StudentUnits);
        StudentUnits.Reset;
        StudentUnits.SetRange("Student No.",Coregcs."Student No.");
        StudentUnits.SetRange("Year Of Study",Coregcs."Year Of Study");
        //StudentUnits.SETRANGE("Academic Year Exclude Comp.",FALSE);
        //StudentUnits.SETRANGE("Reg. Reversed",FALSE);
        StudentUnits.SetFilter(Unit,'<>%1','');
        Coregcs.CalcFields("Stoppage Exists In Acad. Year","Stoppage Exists in YoS","Stopped Academic Year","Stopage Yearly Remark");
              if Coregcs."Stopped Academic Year" <>'' then begin
               if Coregcs."Academic Year Exclude Comp."=false then
              StudentUnits.SetFilter("Academic Year (Flow)",'=%1|=%2',Coregcs."Stopped Academic Year",Coregcs."Academic Year");
               end
              else
              StudentUnits.SetFilter("Academic Year (Flow)",'=%1',Coregcs."Academic Year");

           Clear(CountedRegistrations);
           Clear(Coregcsz10);
           Coregcsz10.Reset;
           Coregcsz10.SetRange("Student No.",Coregcs."Student No.");
           Coregcsz10.SetRange("Year Of Study",Coregcs."Year Of Study");
           Coregcsz10.SetRange(Reversed,false);
           Coregcsz10.SetFilter(Stage,'..%1',Coregcs.Stage);
           if Coregcsz10.Find('-') then begin
            CountedRegistrations := Coregcsz10.Count;
            if CountedRegistrations <2 then // Filter
          StudentUnits.SetRange(Stage,Coregcs.Stage);
           end;
        if StudentUnits.Find('-') then begin

          repeat
            begin
             StudentUnits.CalcFields(StudentUnits."CATs Marks Exists");
             if StudentUnits."CATs Marks Exists"=false then begin
              UnitsSubjects.Reset;
              UnitsSubjects.SetRange("Programme Code",StudentUnits.Programme);
              UnitsSubjects.SetRange(Code,StudentUnits.Unit);
              UnitsSubjects.SetRange("Exempt CAT",true);
              if UnitsSubjects.Find('-') then begin
                 ExamResults.Init;
                 ExamResults."Student No.":=StudentUnits."Student No.";
                 ExamResults.Programme:=StudentUnits.Programme;
                 ExamResults.Stage:=StudentUnits.Stage;
                 ExamResults.Unit:=StudentUnits.Unit;
                 ExamResults.Semester:=StudentUnits.Semester;
                 ExamResults."Academic Year":=StudentUnits."Academic Year";
                 ExamResults."Reg. Transaction ID":=StudentUnits."Reg. Transacton ID";
                 ExamResults.ExamType:='CAT';
                 ExamResults.Exam:='CAT';
                 ExamResults."Exam Category":=Progyz."Exam Category";
                 ExamResults.Score:=0;
                 ExamResults."User Name":='AUTOPOST';
                if  ExamResults.Insert then;
                 end;
                 end;
                Clear(ExamResults); ExamResults.Reset;
            ExamResults.SetRange("Student No.",StudentUnits."Student No.");
            ExamResults.SetRange(Unit,StudentUnits.Unit);
            if ExamResults.Find('-') then begin
                repeat
                    begin
                       if ExamResults.ExamType<>'' then begin
           ExamResults.Exam:=ExamResults.ExamType;
           ExamResults.Modify;
           end else  if ExamResults.Exam<>'' then begin
             if ExamResults.ExamType='' then begin
           ExamResults.Rename(ExamResults."Student No.",ExamResults.Programme,ExamResults.Stage,
           ExamResults.Unit,ExamResults.Semester,ExamResults.Exam,ExamResults."Reg. Transaction ID",ExamResults."Entry No");
           end;
           end;
                    end;
                  until ExamResults.Next = 0;
              end;
                    ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii Update Units
            Clear(ExamResults);
            ExamResults.Reset;
            ExamResults.SetFilter("Counted Occurances",'>%1',1);
            ExamResults.SetRange("Student No.",StudentUnits."Student No.");
            ExamResults.SetRange(Unit,StudentUnits.Unit);
            if ExamResults.Find('-') then begin
              repeat
                begin
                ACAExamResultsFin.Reset;
                ACAExamResultsFin.SetRange("Student No.",StudentUnits."Student No.");
                ACAExamResultsFin.SetRange(Programme,StudentUnits.Programme);
                ACAExamResultsFin.SetRange(Unit,StudentUnits.Unit);
                ACAExamResultsFin.SetRange(Semester,StudentUnits.Semester);
                ACAExamResultsFin.SetRange(ExamType,ExamResults.ExamType);
                if ACAExamResultsFin.Find('-') then begin
                  ACAExamResultsFin.CalcFields("Counted Occurances");
                  if ACAExamResultsFin."Counted Occurances">1 then begin
                      ACAExamResultsFin.Delete;
                    end;
                  end;
                end;
                until ExamResults.Next=0;
                end;
          ////////////////////////////////// Remove Multiple Occurances of a Mark
            ////////////////////////////////////////////////////////////////////////////
            // Grad Headers

                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
                    ACAResultsStatus.SetRange("Academic Year",Coregcs."Academic Year");
                    if ACAResultsStatus.Find('-') then begin
                      repeat
                          begin
                          ACASenateReportsHeader.Reset;
                          ACASenateReportsHeader.SetRange("Academic Year",Coregcs."Academic Year");
                          ACASenateReportsHeader.SetRange("School Code",Progyz."School Code");
                          ACASenateReportsHeader.SetRange("Classification Code",ACAResultsStatus.Code);
                          ACASenateReportsHeader.SetRange("Programme Code",Progyz.Code);
                          ACASenateReportsHeader.SetRange("Year of Study",Coregcs."Year Of Study");
                          if not (ACASenateReportsHeader.Find('-')) then begin
                            ACASenateReportsHeader.Init;
                            ACASenateReportsHeader."Academic Year":=Coregcs."Academic Year";
                            ACASenateReportsHeader."Reporting Academic Year":=Coregcs."Academic Year";
                            ACASenateReportsHeader."Rubric Order":=ACAResultsStatus."Order No";
                            ACASenateReportsHeader."Programme Code":=Progyz.Code;
                            ACASenateReportsHeader."School Code":=Progyz."School Code";
                            ACASenateReportsHeader."Year of Study":=Coregcs."Year Of Study";
                            ACASenateReportsHeader."Classification Code":=ACAResultsStatus.Code;
                            ACASenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
                            ACASenateReportsHeader."IncludeVariable 1":=ACAResultsStatus."IncludeVariable 1";
                            ACASenateReportsHeader."IncludeVariable 2":=ACAResultsStatus."IncludeVariable 2";
                            ACASenateReportsHeader."IncludeVariable 3":=ACAResultsStatus."IncludeVariable 3";
                            ACASenateReportsHeader."IncludeVariable 4":=ACAResultsStatus."IncludeVariable 4";
                            ACASenateReportsHeader."IncludeVariable 5":=ACAResultsStatus."IncludeVariable 5";
                            ACASenateReportsHeader."IncludeVariable 6":=ACAResultsStatus."IncludeVariable 6";
                            ACASenateReportsHeader."Summary Page Caption":=ACAResultsStatus."Summary Page Caption";
                            ACASenateReportsHeader."Include Failed Units Headers":=ACAResultsStatus."Include Failed Units Headers";
                            ACASenateReportsHeader."Include Academic Year Caption":=ACAResultsStatus."Include Academic Year Caption";
                            ACASenateReportsHeader."Academic Year Text":=ACAResultsStatus."Academic Year Text";
                            ACASenateReportsHeader."Status Msg1":=ACAResultsStatus."Status Msg1";
                            ACASenateReportsHeader."Status Msg2":=ACAResultsStatus."Status Msg2";
                            ACASenateReportsHeader."Status Msg3":=ACAResultsStatus."Status Msg3";
                            ACASenateReportsHeader."Status Msg4":=ACAResultsStatus."Status Msg4";
                            ACASenateReportsHeader."Status Msg5":=ACAResultsStatus."Status Msg5";
                            ACASenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
                            ACASenateReportsHeader."Grad. Status Msg 1":=ACAResultsStatus."Grad. Status Msg 1";
                            ACASenateReportsHeader."Grad. Status Msg 2":=ACAResultsStatus."Grad. Status Msg 2";
                            ACASenateReportsHeader."Grad. Status Msg 3":=ACAResultsStatus."Grad. Status Msg 3";
                            ACASenateReportsHeader."Grad. Status Msg 4":=ACAResultsStatus."Grad. Status Msg 4";
                            ACASenateReportsHeader."Grad. Status Msg 5":=ACAResultsStatus."Grad. Status Msg 5";
                            ACASenateReportsHeader."Grad. Status Msg 6":=ACAResultsStatus."Grad. Status Msg 6";
                            ACASenateReportsHeader."Finalists Graduation Comments":=ACAResultsStatus."Finalists Grad. Comm. Degree";
                            ACASenateReportsHeader."1st Year Grad. Comments":=ACAResultsStatus."1st Year Grad. Comments";
                            ACASenateReportsHeader."2nd Year Grad. Comments":=ACAResultsStatus."2nd Year Grad. Comments";
                            ACASenateReportsHeader."3rd Year Grad. Comments":=ACAResultsStatus."3rd Year Grad. Comments";
                            ACASenateReportsHeader."4th Year Grad. Comments":=ACAResultsStatus."4th Year Grad. Comments";
                            ACASenateReportsHeader."5th Year Grad. Comments":=ACAResultsStatus."5th Year Grad. Comments";
                            ACASenateReportsHeader."6th Year Grad. Comments":=ACAResultsStatus."6th Year Grad. Comments";
                            ACASenateReportsHeader."7th Year Grad. Comments":=ACAResultsStatus."7th Year Grad. Comments";
                          if   ACASenateReportsHeader.Insert then;
                            end;
                          end;
                        until ACAResultsStatus.Next=0;
                      end;
            ////////////////////////////////////////////////////////////////////////////
                ACAExamClassificationStuds.Reset;
                ACAExamClassificationStuds.SetRange("Student Number",Coregcs."Student No.");
                ACAExamClassificationStuds.SetRange(Programme,Coregcs.Programme);
                ACAExamClassificationStuds.SetRange("Academic Year",Coregcs."Academic Year");
                if not ACAExamClassificationStuds.Find('-') then begin
                ACAExamClassificationStuds.Init;
                ACAExamClassificationStuds."Student Number":=Coregcs."Student No.";
                ACAExamClassificationStuds."Reporting Academic Year":=Coregcs."Academic Year";
                ACAExamClassificationStuds."School Code":=Progyz."School Code";
                ACAExamClassificationStuds.Department:=Progyz."Department Code";
                ACAExamClassificationStuds."Programme Option":=Coregcs.Options;
                ACAExamClassificationStuds.Programme:=Coregcs.Programme;
                ACAExamClassificationStuds."Academic Year":=Coregcs."Academic Year";
                ACAExamClassificationStuds."Year of Study":=Coregcs."Year Of Study";
              ACAExamClassificationStuds."School Name":=GetDepartmentNameOrSchool(Progyz."School Code");
              ACAExamClassificationStuds."Student Name":=GetStudentName(Coregcs."Student No.");
              ACAExamClassificationStuds.Cohort:=GetCohort(Coregcs."Student No.",Coregcs.Programme);
              ACAExamClassificationStuds."Final Stage":=GetFinalStage(Coregcs.Programme);
              ACAExamClassificationStuds."Final Academic Year":=GetFinalAcademicYear(Coregcs."Student No.",Coregcs.Programme);
              ACAExamClassificationStuds."Final Year of Study":=GetFinalYearOfStudy(Coregcs.Programme);
              ACAExamClassificationStuds."Admission Date":=GetAdmissionDate(Coregcs."Student No.",Coregcs.Programme);
              ACAExamClassificationStuds."Admission Academic Year":=GetAdmissionAcademicYear(Coregcs."Student No.",Coregcs.Programme);
              ACAExamClassificationStuds.Graduating:=false;
              ACAExamClassificationStuds.Classification:='';
                if ACAExamClassificationStuds.Insert then;

            end;
                /////////////////////////////////////// YoS Tracker
                Progyz.Reset;
                if Progyz.Get(Coregcs.Programme) then;
                ACAExamCourseRegistration.Reset;
                ACAExamCourseRegistration.SetRange("Student Number",Coregcs."Student No.");
                ACAExamCourseRegistration.SetRange(Programme,Coregcs.Programme);
                ACAExamCourseRegistration.SetRange("Year of Study",Coregcs."Year Of Study");
                ACAExamCourseRegistration.SetRange("Academic Year",Coregcs."Academic Year");
                if not ACAExamCourseRegistration.Find('-') then begin
                    ACAExamCourseRegistration.Init;
                    ACAExamCourseRegistration."Student Number":=Coregcs."Student No.";
                    ACAExamCourseRegistration.Programme:=Coregcs.Programme;
                    ACAExamCourseRegistration."Year of Study":=Coregcs."Year Of Study";
                    ACAExamCourseRegistration."Reporting Academic Year":=Coregcs."Academic Year";
                    ACAExamCourseRegistration."Academic Year":=Coregcs."Academic Year";
                    ACAExamCourseRegistration."School Code":=Progyz."School Code";
                    ACAExamCourseRegistration."Programme Option":=Coregcs.Options;
              ACAExamCourseRegistration."School Name":=ACAExamClassificationStuds."School Name";
              ACAExamCourseRegistration."Student Name":=ACAExamClassificationStuds."Student Name";
              ACAExamCourseRegistration.Cohort:=ACAExamClassificationStuds.Cohort;
              ACAExamCourseRegistration."Final Stage":=ACAExamClassificationStuds."Final Stage";
              ACAExamCourseRegistration."Final Academic Year":=ACAExamClassificationStuds."Final Academic Year";
              ACAExamCourseRegistration."Final Year of Study":=ACAExamClassificationStuds."Final Year of Study";
              ACAExamCourseRegistration."Admission Date":=ACAExamClassificationStuds."Admission Date";
              ACAExamCourseRegistration."Admission Academic Year":=ACAExamClassificationStuds."Admission Academic Year";

          if ((Progyz.Category=Progyz.Category::"Certificate ") or
             (Progyz.Category=Progyz.Category::"Course List") or
             (Progyz.Category=Progyz.Category::Professional)) then begin
              ACAExamCourseRegistration."Category Order":=2;
              end else if (Progyz.Category=Progyz.Category::Diploma) then begin
              ACAExamCourseRegistration."Category Order":=3;
                end  else if (Progyz.Category=Progyz.Category::Postgraduate) then begin
              ACAExamCourseRegistration."Category Order":=4;
                end  else if (Progyz.Category=Progyz.Category::Undergraduate) then begin
              ACAExamCourseRegistration."Category Order":=1;
                end;

              ACAExamCourseRegistration.Graduating:=false;
              ACAExamCourseRegistration.Classification:='';
                  if  ACAExamCourseRegistration.Insert then;
                  end;
              //Get best CAT Marks
              StudentUnits."Unit not in Catalogue":=false;

              UnitsSubjects.Reset;
              UnitsSubjects.SetRange("Programme Code",StudentUnits.Programme);
              UnitsSubjects.SetRange(Code,StudentUnits.Unit);
              if UnitsSubjects.Find('-') then begin

                if UnitsSubjects."Default Exam Category"='' then UnitsSubjects."Default Exam Category":=Progyz."Exam Category";
                if UnitsSubjects."Exam Category"='' then UnitsSubjects."Exam Category":=Progyz."Exam Category";
                UnitsSubjects.Modify;
                ACAExamClassificationUnits.Reset;
                ACAExamClassificationUnits.SetRange("Student No.",StudentUnits."Student No.");
                ACAExamClassificationUnits.SetRange(Programme,StudentUnits.Programme);
                ACAExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
                ACAExamClassificationUnits.SetRange("Academic Year",Coregcs."Academic Year");
                if not ACAExamClassificationUnits.Find('-') then begin
                    ACAExamClassificationUnits.Init;
                    ACAExamClassificationUnits."Student No.":=Coregcs."Student No.";
                    ACAExamClassificationUnits.Programme:=Coregcs.Programme;
                    ACAExamClassificationUnits."Reporting Academic Year":=Coregcs."Academic Year";
                    ACAExamClassificationUnits."School Code":=Progyz."School Code";
                    ACAExamClassificationUnits."Unit Code":=StudentUnits.Unit;
                    ACAExamClassificationUnits."Credit Hours":=UnitsSubjects."No. Units";
                    ACAExamClassificationUnits."Unit Type":=Format(UnitsSubjects."Unit Type");
                    ACAExamClassificationUnits."Unit Description":=UnitsSubjects.Desription;
                    ACAExamClassificationUnits."Year of Study":=ACAExamCourseRegistration."Year of Study";
                    ACAExamClassificationUnits."Academic Year":=Coregcs."Academic Year";

                        Clear(ExamResults); ExamResults.Reset;
                        ExamResults.SetRange("Student No.",StudentUnits."Student No.");
                        ExamResults.SetRange(Unit,StudentUnits.Unit);
                          if ExamResults.Find('-') then begin
                            ExamResults.CalcFields("Number of Repeats","Number of Resits");
                            if ExamResults."Number of Repeats">0 then
                            ACAExamClassificationUnits."No. of Repeats":=ExamResults."Number of Repeats"-1;
                            if ExamResults."Number of Resits">0 then
                            ACAExamClassificationUnits."No. of Resits":=ExamResults."Number of Resits"-1;
                            end;

                   if  ACAExamClassificationUnits.Insert then ;
                  end;

                            /////////////////////////// Update Unit Score
                              Clear(ACAExamClassificationUnits);
                ACAExamClassificationUnits.Reset;
                ACAExamClassificationUnits.SetRange("Student No.",StudentUnits."Student No.");
                ACAExamClassificationUnits.SetRange(Programme,StudentUnits.Programme);
                ACAExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
                ACAExamClassificationUnits.SetRange("Academic Year",Coregcs."Academic Year");
                if ACAExamClassificationUnits.Find('-') then begin
                  ACAExamClassificationUnits.CalcFields("Is Supp. Unit");
                         Clear(ACAExamResults_Fin);
                  ACAExamResults_Fin.Reset;
                         ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3|%4','EXAM','EXAM100','EXAMS','FINAL EXAM');
                         ACAExamResults_Fin.SetCurrentkey(Score);
                         if ACAExamResults_Fin.Find('+') then begin
                           if ACAExamClassificationUnits."Is Supp. Unit" = false then begin
                          ACAExamClassificationUnits."Exam Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                          end else begin
                          ACAExamClassificationUnits."Exam Score":='0';
                          ACAExamClassificationUnits."Exam Score Decimal":=0;
                            end;
                           end;
                       //     END;
                            Clear(CATExists);
                         Clear(ACAExamResults_Fin);
                         ACAExamResults_Fin.Reset;
                         ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         ACAExamResults_Fin.SetCurrentkey(Score);
                         if ACAExamResults_Fin.Find('+') then begin
                           if ACAExamClassificationUnits."Is Supp. Unit" = false then begin
                          ACAExamClassificationUnits."CAT Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                          ACAExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                          end else begin
                          ACAExamClassificationUnits."CAT Score":='0';
                          ACAExamClassificationUnits."CAT Score Decimal":=0;
                            end;
                          CATExists:=true;
                           end;
                          // END;
                         if ACAExamClassificationUnits.Modify then;

                    Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Supplementary);
                            AcaSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if AcaSpecialExamsDetails.Find('-') then begin
                          ACAExamClassificationUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                        //Update Total Marks
                        if ((ACAExamClassificationUnits."Exam Score"='') and (CATExists=false)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((ACAExamClassificationUnits."Exam Score"='') and (CATExists = true)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (CATExists=false)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (CATExists = true)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Both Exists";
                         end;
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",ACAExamClassificationUnits."Total Score Decimal");
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');

                              end else begin
                        //Update Total Marks
                        if ((ACAExamClassificationUnits."Exam Score"='') and (ACAExamClassificationUnits."CAT Score"='')) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((ACAExamClassificationUnits."Exam Score"='') and (ACAExamClassificationUnits."CAT Score"<>'')) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (ACAExamClassificationUnits."CAT Score"='')) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (ACAExamClassificationUnits."CAT Score"<>'')) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Both Exists";
                         end;
                           if ACAExamClassificationUnits."Is Supp. Unit" = false then begin
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                         end else begin
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",ACAExamClassificationUnits."Total Score Decimal");
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');

                           end;
                                end;
        // Check for Special Exams Score if Exists

                    Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Special);
                            AcaSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if AcaSpecialExamsDetails.Find('-') then begin
                              if AcaSpecialExamsDetails."Exam Marks"<>0 then
                          ACAExamClassificationUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='))
                              else ACAExamClassificationUnits."Exam Score":='';
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                          if ACAExamResults_Fin.Score<>0 then
                          ACAExamClassificationUnits."CAT Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='))
                          else ACAExamClassificationUnits."CAT Score":='';
                          ACAExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                        //Update Total Marks
                        if ((ACAExamClassificationUnits."Exam Score"='') and (CATExists=false)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((ACAExamClassificationUnits."Exam Score"='') and (CATExists = true)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (CATExists=false)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((ACAExamClassificationUnits."Exam Score"<>'') and (CATExists = true)) then begin
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."results exists status"::"Both Exists";
                         end;
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal"+
                          ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                        //  IF ACAExamClassificationUnits."Total Score Decimal">40 THEN ACAExamClassificationUnits."Total Score Decimal":=40;
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*
                          ACAExamClassificationUnits."Total Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');

                              end;

                              ///////////////////////////////////////////////////////// End of Supps Score Updates
                            Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                            AcaSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if AcaSpecialExamsDetails.Find('-') then begin
                              ACAExamSuppUnits.Init;
                              ACAExamSuppUnits."Student No.":=StudentUnits."Student No.";
                              ACAExamSuppUnits."Unit Code":=ACAExamClassificationUnits."Unit Code";
                              ACAExamSuppUnits."Unit Description":=ACAExamClassificationUnits."Unit Description";
                              ACAExamSuppUnits."Unit Type":=ACAExamClassificationUnits."Unit Type";
                              ACAExamSuppUnits.Programme:=ACAExamClassificationUnits.Programme;
                              ACAExamSuppUnits."Academic Year":=ACAExamClassificationUnits."Academic Year";
                              ACAExamSuppUnits."Credit Hours":=ACAExamClassificationUnits."Credit Hours";
                              if AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Supplementary then begin
                              ACAExamSuppUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                              ACAExamSuppUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                              ACAExamSuppUnits."CAT Score":=Format(ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExamSuppUnits."CAT Score Decimal":=ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                          ACAExamSuppUnits."Total Score Decimal":=ROUND((GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",(ROUND(ACAExamSuppUnits."Exam Score Decimal",0.01,'=')))),0.01,'=');
                              ACAExamSuppUnits."Total Score":=Format(ACAExamSuppUnits."Total Score Decimal");
                                end else if AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Special then begin
                              ACAExamSuppUnits."Exam Score Decimal":=ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'=');
                              ACAExamSuppUnits."Exam Score":=Format(ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'='));
                              ACAExamSuppUnits."CAT Score":=Format(ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExamSuppUnits."CAT Score Decimal":=ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                              ACAExamSuppUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",(ROUND(AcaSpecialExamsDetails."Exam Marks"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=')));
                              ACAExamSuppUnits."Total Score":=Format(ACAExamSuppUnits."Total Score Decimal");
                              end;
                              ACAExamSuppUnits."Exam Category":=ACAExamClassificationUnits."Exam Category";
                              ACAExamSuppUnits."Allow In Graduate":=true;
                              ACAExamSuppUnits."Year of Study":=ACAExamClassificationUnits."Year of Study";
                              ACAExamSuppUnits.Cohort:=ACAExamClassificationUnits.Cohort;
                              ACAExamSuppUnits."School Code":=ACAExamClassificationUnits."School Code";
                              ACAExamSuppUnits."Department Code":=ACAExamClassificationUnits."Department Code";
                              if ACAExamSuppUnits.Insert then;
                          ACAExamClassificationUnits.Modify;
                              //  END;
                              end;
                              ACAExamClassificationUnits."Allow In Graduate":=true;
                          ACAExamClassificationUnits.Modify;
                              /// Update Cummulative Resit
                              ACAExamClassificationUnits.CalcFields(Grade,"Grade Comment","Comsolidated Prefix",Pass);
                     if ACAExamClassificationUnits.Pass then begin
                       // Remove from Cummulative Resits
                ACAExamCummulativeResit.Reset;
                ACAExamCummulativeResit.SetRange("Student Number",StudentUnits."Student No.");
                ACAExamCummulativeResit.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                ACAExamCummulativeResit.SetRange("Academic Year",Coregcs."Academic Year");
                if ACAExamCummulativeResit.Find('-') then ACAExamCummulativeResit.DeleteAll;
        // //
        // //            CLEAR(AcaSpecialExamsDetails);
        // //                    AcaSpecialExamsDetails.RESET;
        // //                    AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
        // //                    AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
        // //                    AcaSpecialExamsDetails.SETRANGE(Category,AcaSpecialExamsDetails.Category::Supplementary);
        // //                    AcaSpecialExamsDetails.SETFILTER("Exam Marks",'%1',0);
        // //                    IF AcaSpecialExamsDetails.FIND('-') THEN AcaSpecialExamsDetails.DELETEALL;

                                Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails.SetFilter("Exam Marks",'%1',0);
                            if Aca2ndSuppExamsDetails.Find ('-') then Aca2ndSuppExamsDetails.DeleteAll;
                end else begin
                     // Student Failed Supp or Special. Register for the second Supp if first Supp Failed and 1st Supp if Special Failed

                                Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails.SetFilter("Exam Marks",'%1',0);
                            if Aca2ndSuppExamsDetails.Find ('-') then Aca2ndSuppExamsDetails.DeleteAll;
                    //Aca2ndSuppExamsDetails3
                    Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Supplementary);
                            AcaSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if not (AcaSpecialExamsDetails.Find('-')) then begin
                               //  Register Supp for Special that is Failed
                               // The Failed Unit is not in Supp Special, Register The Unit here
                              Clear(CountedSeq);
                              Clear(AcaSpecialExamsDetails3);
                               AcaSpecialExamsDetails3.Reset;
                            AcaSpecialExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails3.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails3.SetCurrentkey(Sequence);
                            if AcaSpecialExamsDetails3.Find('+') then begin
                              CountedSeq:=AcaSpecialExamsDetails3.Sequence;
                              end else begin
                              CountedSeq:=0;
                                end;
                                CountedSeq+=1;
                              AcaSpecialExamsDetails.Init;
                              AcaSpecialExamsDetails.Stage:=StudentUnits.Stage;
                              AcaSpecialExamsDetails.Status:=AcaSpecialExamsDetails.Status::New;
                              AcaSpecialExamsDetails."Student No.":=StudentUnits."Student No.";
                              AcaSpecialExamsDetails."Academic Year":=Coregcs."Academic Year";
                              AcaSpecialExamsDetails."Unit Code":=StudentUnits.Unit;
                              AcaSpecialExamsDetails.Semester:=StudentUnits.Semester;
                              AcaSpecialExamsDetails.Sequence:=CountedSeq;
                              AcaSpecialExamsDetails."Current Academic Year":=GetFinalAcademicYear(StudentUnits."Student No.",StudentUnits.Programme);
                              AcaSpecialExamsDetails.Category:=AcaSpecialExamsDetails.Category::Supplementary;
                              AcaSpecialExamsDetails.Programme:=StudentUnits.Programme;

                    Clear(Aca2ndSuppExamsDetails4);
                            Aca2ndSuppExamsDetails4.Reset;
                            Aca2ndSuppExamsDetails4.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails4.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails4.SetRange(Category,AcaSpecialExamsDetails4.Category::Special);
                            AcaSpecialExamsDetails4.SetRange(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails4.SetRange("Exam Marks",0);
                            if (Aca2ndSuppExamsDetails4.Find('-')) then begin
                              // Check if Allows Creation of Supp

                            //  IF AcaSpecialExamsDetails.INSERT THEN ;
                              end else  begin
                                end;
                              end else begin
                                // Failed 1st Supplementary, Create Second Supplementary Registration Entry here
                                Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if not (Aca2ndSuppExamsDetails.Find('-')) then begin //  Register 2nd Supp for 1st Supp that is Failed
                              Clear(CountedSeq);
                              Clear(Aca2ndSuppExamsDetails3);
                               Aca2ndSuppExamsDetails3.Reset;
                            Aca2ndSuppExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails3.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails3.SetRange(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails3.SetCurrentkey(Sequence);
                            if Aca2ndSuppExamsDetails3.Find('+') then begin
                              CountedSeq:=Aca2ndSuppExamsDetails3.Sequence;
                              end else begin
                              CountedSeq:=0;
                                end;
                                CountedSeq+=1;
                              Aca2ndSuppExamsDetails.Init;
                              Aca2ndSuppExamsDetails.Stage:=StudentUnits.Stage;
                              Aca2ndSuppExamsDetails.Status:=Aca2ndSuppExamsDetails.Status::New;
                              Aca2ndSuppExamsDetails."Student No.":=StudentUnits."Student No.";
                              Aca2ndSuppExamsDetails."Academic Year":=Coregcs."Academic Year";
                              Aca2ndSuppExamsDetails."Unit Code":=StudentUnits.Unit;
                              Aca2ndSuppExamsDetails.Semester:=StudentUnits.Semester;
                              Aca2ndSuppExamsDetails.Sequence:=CountedSeq;
                              Aca2ndSuppExamsDetails."Current Academic Year":=GetFinalAcademicYear(StudentUnits."Student No.",StudentUnits.Programme);
                              Aca2ndSuppExamsDetails.Category:=Aca2ndSuppExamsDetails.Category::Supplementary;
                              Aca2ndSuppExamsDetails.Programme:=StudentUnits.Programme;

                              if Aca2ndSuppExamsDetails.Insert then ;
                              end;

                                end;
                 begin
                    ACAExamCummulativeResit.Init;
                    ACAExamCummulativeResit."Student Number":=StudentUnits."Student No.";
                    ACAExamCummulativeResit."School Code":=ACAExamClassificationStuds."School Code";
                    ACAExamCummulativeResit."Academic Year":=StudentUnits."Academic Year";
                    ACAExamCummulativeResit."Unit Code":=ACAExamClassificationUnits."Unit Code";
                    ACAExamCummulativeResit."Student Name":=ACAExamClassificationStuds."Student Name";
                    ACAExamCummulativeResit.Programme:=StudentUnits.Programme;
                    ACAExamCummulativeResit."School Name":=ACAExamClassificationStuds."School Name";
                    ACAExamCummulativeResit."Unit Description":=UnitsSubjects.Desription;
                    ACAExamCummulativeResit."Credit Hours":=UnitsSubjects."No. Units";
                      ACAExamCummulativeResit."Unit Type":=ACAExamClassificationUnits."Unit Type";
                    ACAExamCummulativeResit.Score:=ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                    ACAExamCummulativeResit.Grade:=ACAExamClassificationUnits.Grade;
                    if ACAExamCummulativeResit.Insert then;
                    end;
                    end;
                    // Update 1st & 2nd Supp
                              Clear(AcaSpecialExamsDetails3);
                               AcaSpecialExamsDetails3.Reset;
                            AcaSpecialExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails3.SetRange(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails3.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            if AcaSpecialExamsDetails3.Find then begin
        // // //                      CLEAR(AcaSpecialExamsResults);
        // // //                      AcaSpecialExamsResults.RESET;
        // // //                      AcaSpecialExamsResults.SETRANGE("Student No.",StudentUnits."Student No.");
        // // //                      AcaSpecialExamsResults.SETRANGE(Unit,StudentUnits.Unit);
        // // //                      IF AcaSpecialExamsResults.FIND('-') THEN BEGIN
        // // //                        AcaSpecialExamsDetails3."Exam Marks":=AcaSpecialExamsResults.Score;
        // // //                      AcaSpecialExamsDetails3.MODIFY;
        // // //                        END;

                              end;

                              Clear(Aca2ndSuppExamsDetails3);
                               Aca2ndSuppExamsDetails3.Reset;
                            Aca2ndSuppExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails3.SetRange("Unit Code",StudentUnits.Unit);
                            AcaSpecialExamsDetails3.SetRange(Semester,StudentUnits.Semester);
                            if Aca2ndSuppExamsDetails3.Find('-') then begin
                              ////////////////
        // // //                      CLEAR(Aca2ndSuppExamsResults);
        // // //                      Aca2ndSuppExamsResults.RESET;
        // // //                      Aca2ndSuppExamsResults.SETRANGE("Student No.",StudentUnits."Student No.");
        // // //                      Aca2ndSuppExamsResults.SETRANGE(Unit,StudentUnits.Unit);
        // // //                      IF Aca2ndSuppExamsResults.FIND('-') THEN BEGIN
        // // //                        Aca2ndSuppExamsDetails3."Exam Marks":=Aca2ndSuppExamsResults.Score;
        // // //                      Aca2ndSuppExamsDetails3.MODIFY;
        // // //                        END;
                              ////////////////
                              end;
                                                //////////////////////////// Update Units Scores.. End
                end else begin
                  StudentUnits."Unit not in Catalogue":=true;
                  end;
                  end;
                        if  ACAExamClassificationUnits.Modify then;
          StudentUnits.Modify;

                   Clear(Progyz);
                        if Progyz.Get(ACAExamCourseRegistration.Programme) then;
                        Clear(ACAExamCourseRegistration4SuppGeneration);
                        ACAExamCourseRegistration4SuppGeneration.Reset;
                        ACAExamCourseRegistration4SuppGeneration.SetRange("Student Number",ACAExamClassificationUnits."Student No.");
                        ACAExamCourseRegistration4SuppGeneration.SetRange("Year of Study",ACAExamClassificationUnits."Year of Study");
                        ACAExamCourseRegistration4SuppGeneration.SetRange("Academic Year",ACAExamClassificationUnits."Academic Year");
                        ACAExamCourseRegistration4SuppGeneration.SetRange(Programme,ACAExamClassificationUnits.Programme);
                        if ACAExamCourseRegistration4SuppGeneration.Find('-') then;
                         //  Check if Rubric Allows for Generation of supp..
                         Clear(ACAResultsStatusSuppGen);
             ACAResultsStatusSuppGen.Reset;
             ACAResultsStatusSuppGen.SetRange(Code,ACAExamCourseRegistration4SuppGeneration.Classification);
             ACAResultsStatusSuppGen.SetRange("Academic Year",ACAExamCourseRegistration4SuppGeneration."Academic Year");
             ACAResultsStatusSuppGen.SetRange("Special Programme Class",Progyz."Special Programme Class");
             if ACAResultsStatusSuppGen.Find('-') then;
            //   Check if the Ststus does not allow Supp. Generation and delete
              if ACAResultsStatusSuppGen."Skip Supp Generation" = false then begin
                /////////////////////////////////////// end of YoS Tracker

                            Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'%1',0);
                            AcaSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if AcaSpecialExamsDetails.Find('-') then AcaSpecialExamsDetails.DeleteAll;
                end;
                ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii End of Finalize Units
        end;

            until StudentUnits.Next=0;
          end;

        end;
        until Coregcs.Next=0;
            Progressbar.Close;
        end;

        // Update Averages
        Clear(TotalRecs);
        Clear(CountedRecs);
        Clear(RemeiningRecs);
        Clear(ACAExamClassificationStuds);
        Clear(ACAExamCourseRegistration);
        ACAExamCourseRegistration.Reset;
         ACAExamCourseRegistration.SetFilter("Reporting Academic Year",AcadYear);
        if StudNos<>'' then
        ACAExamCourseRegistration.SetFilter("Student Number",StudNos) else
        ACAExamCourseRegistration.SetFilter(Programme,ProgFIls);// Only Apply Prog & School if Student FIlter is not Applied
        if ACAExamCourseRegistration.Find('-') then begin
          TotalRecs:=ACAExamCourseRegistration.Count;
          RemeiningRecs:=TotalRecs;
          ProgBar2.Open('#1#####################################################\'+
          '#2############################################################\'+
          '#3###########################################################\'+
          '#4############################################################\'+
          '#5###########################################################\'+
          '#6############################################################');
             ProgBar2.Update(1,'3 of 3 Updating Class Items');
             ProgBar2.Update(2,'Total Recs.: '+Format(TotalRecs));
            repeat
              begin
              Clear(Coregcs);
              Coregcs.Reset;
              Coregcs.SetRange("Student No.",ACAExamCourseRegistration."Student Number");
              Coregcs.SetRange(Programme,ACAExamCourseRegistration.Programme);
              Coregcs.SetRange("Year Of Study",ACAExamCourseRegistration."Year of Study");
              Coregcs.SetFilter("Stopage Yearly Remark",'<>%1','');
             if Coregcs.Find('+') then;
              Progyz.Reset;
              Progyz.SetRange(Code,ACAExamCourseRegistration.Programme);
              if Progyz.Find('-') then;
              CountedRecs+=1;
              RemeiningRecs-=1;
             ProgBar2.Update(3,'.....................................................');
             ProgBar2.Update(4,'Processed: '+Format(CountedRecs));
             ProgBar2.Update(5,'Remaining: '+Format(RemeiningRecs));
             ProgBar2.Update(6,'----------------------------------------------------');
                    ACAExamCourseRegistration.CalcFields("Total Marks","Total Courses","Total Weighted Marks",
                  "Total Units","Classified Total Marks","Total Classified C. Count","Classified W. Total","Attained Stage Units",Average,"Weighted Average");
                  ACAExamCourseRegistration."Normal Average":=ROUND((ACAExamCourseRegistration.Average),0.01,'=');
                  if ACAExamCourseRegistration."Total Units">0 then
                  ACAExamCourseRegistration."Weighted Average":=ROUND((ACAExamCourseRegistration."Total Weighted Marks"/ACAExamCourseRegistration."Total Units"),0.01,'=');
                  if ACAExamCourseRegistration."Total Classified C. Count"<>0 then
                  ACAExamCourseRegistration."Classified Average":=ROUND((ACAExamCourseRegistration."Classified Total Marks"/ACAExamCourseRegistration."Total Classified C. Count"),0.01,'=');
                  if ACAExamCourseRegistration."Total Classified Units"<>0 then
                  ACAExamCourseRegistration."Classified W. Average":=ROUND((ACAExamCourseRegistration."Classified W. Total"/ACAExamCourseRegistration."Total Classified Units"),0.01,'=');
                  ACAExamCourseRegistration.CalcFields("Defined Units (Flow)");
                  ACAExamCourseRegistration."Required Stage Units":=ACAExamCourseRegistration."Defined Units (Flow)";//RequiredStageUnits(ACAExamCourseRegistration.Programme,
                 // ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration."Student Number");
                  if ACAExamCourseRegistration."Required Stage Units">ACAExamCourseRegistration."Attained Stage Units" then
                  ACAExamCourseRegistration."Units Deficit":=ACAExamCourseRegistration."Required Stage Units"-ACAExamCourseRegistration."Attained Stage Units";
                  ACAExamCourseRegistration."Multiple Programe Reg. Exists":=GetMultipleProgramExists(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Academic Year");

                   ACAExamCourseRegistration."Final Classification":=GetRubricSupp(Progyz,ACAExamCourseRegistration);
                   if Coregcs."Stopage Yearly Remark"<>'' then
                   ACAExamCourseRegistration."Final Classification":=Coregcs."Stopage Yearly Remark";
                   ACAExamCourseRegistration."Final Classification Pass":=GetSuppRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                   ACAExamCourseRegistration."Academic Year",Progyz);
                   ACAExamCourseRegistration."Final Classification Order":=GetSuppRubricOrder(ACAExamCourseRegistration."Final Classification");
                   ACAExamCourseRegistration.Graduating:=GetSuppRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                   ACAExamCourseRegistration."Academic Year",Progyz);
                   ACAExamCourseRegistration.Classification:=ACAExamCourseRegistration."Final Classification";
                     if ACAExamCourseRegistration."Total Courses"=0 then begin
                  // ACAExamCourseRegistration."Final Classification":='HALT';
                   ACAExamCourseRegistration."Final Classification Pass":=false;
                   ACAExamCourseRegistration."Final Classification Order":=10;
                   ACAExamCourseRegistration.Graduating:=false;
                  // ACAExamCourseRegistration.Classification:='HALT';
                       end;
                   if Coregcs."Stopage Yearly Remark"<>'' then
                     ACAExamCourseRegistration.Classification:=Coregcs."Stopage Yearly Remark";
                   ////////////////////////////////////////////////////////////////////////////////////////////////
        // // // // //
        // // // // //            // Get Regular Rubric
        // // // // //            CLEAR(Progyz);
        // // // // //            IF Progyz.GET(ACAExamCourseRegistration.Programme) THEN;
        // // // // //            CLEAR(ACAExamCourseRegistration4SuppGeneration);
        // // // // //            ACAExamCourseRegistration4SuppGeneration.RESET;
        // // // // //            ACAExamCourseRegistration4SuppGeneration.SETRANGE("Student Number",ACAExamCourseRegistration."Student Number");
        // // // // //            ACAExamCourseRegistration4SuppGeneration.SETRANGE("Year of Study",ACAExamCourseRegistration."Year of Study");
        // // // // //            ACAExamCourseRegistration4SuppGeneration.SETRANGE("Academic Year",ACAExamCourseRegistration."Academic Year");
        // // // // //            ACAExamCourseRegistration4SuppGeneration.SETRANGE(Programme,ACAExamCourseRegistration.Programme);
        // // // // //            IF ACAExamCourseRegistration4SuppGeneration.FIND('-') THEN BEGIN
        // // // // //              // Check if Rubric Allows for Generation of supp..
        // // // // //             CLEAR(ACAResultsStatusSuppGen);
        // // // // // ACAResultsStatusSuppGen.RESET;
        // // // // // ACAResultsStatusSuppGen.SETRANGE(Code,ACAExamCourseRegistration4SuppGeneration.Classification);
        // // // // // ACAResultsStatusSuppGen.SETRANGE("Academic Year",ACAExamCourseRegistration4SuppGeneration."Academic Year");
        // // // // // ACAResultsStatusSuppGen.SETRANGE("Special Programme Class",Progyz."Special Programme Class");
        // // // // // IF ACAResultsStatusSuppGen.FIND('-') THEN BEGIN
        // // // // //  // Check if the Ststus does not allow Supp. Generation and delete
        // // // // //  IF ACAResultsStatusSuppGen."Skip Supp Generation" = TRUE THEN  BEGIN
        // // // // //    // Delete Entries from Supp Registration for the Semester
        // // // // //    CLEAR(AcaSpecialExamsDetails);
        // // // // //    AcaSpecialExamsDetails.RESET;
        // // // // //    AcaSpecialExamsDetails.SETRANGE("Student No.",ACAExamCourseRegistration4SuppGeneration."Student Number");
        // // // // //  //  AcaSpecialExamsDetails.SETRANGE("Year of Study",ACAExamCourseRegistration4SuppGeneration."Year of Study");
        // // // // //    AcaSpecialExamsDetails.SETRANGE("Exam Marks",0);
        // // // // //    AcaSpecialExamsDetails.SETRANGE("Academic Year (Flow)",ACAExamCourseRegistration4SuppGeneration."Academic Year");
        // // // // //    AcaSpecialExamsDetails.SETRANGE(Status,AcaSpecialExamsDetails.Status::New);
        // // // // //    IF AcaSpecialExamsDetails.FIND('-') THEN AcaSpecialExamsDetails.DELETEALL;
        // // // // //
        // // // // //                      CLEAR(Aca2ndSuppExamsDetails3);
        // // // // //                       Aca2ndSuppExamsDetails3.RESET;
        // // // // //                      Aca2ndSuppExamsDetails3.SETRANGE("Student No.",ACAExamCourseRegistration4SuppGeneration."Student Number");
        // // // // //                    //  Aca2ndSuppExamsDetails3.SETRANGE("Year of Study",CoursesRegz."Year of Study");
        // // // // //                        Aca2ndSuppExamsDetails3.SETRANGE("Academic Year (Flow)",ACAExamCourseRegistration4SuppGeneration."Academic Year");
        // // // // //                      Aca2ndSuppExamsDetails3.SETRANGE(Status,Aca2ndSuppExamsDetails3.Status::New);
        // // // // //                      Aca2ndSuppExamsDetails3.SETRANGE("Exam Marks",0);
        // // // // //                    IF Aca2ndSuppExamsDetails3.FIND('-') THEN BEGIN
        // // // // //                      Aca2ndSuppExamsDetails3.DELETEALL;
        // // // // //                      END;
        // // // // //    END;
        // // // // //  END;
                            //////  END;
                   //////////////////////////////////////////////////////////////////////////////////////////////////////
                     ACAExamCourseRegistration.CalcFields("Total Marks",
        "Total Weighted Marks",
        "Total Failed Courses",
        "Total Failed Units",
        "Failed Courses",
        "Failed Units",
        "Failed Cores",
        "Failed Required",
        "Failed Electives",
        "Total Cores Done",
        "Total Cores Passed",
        "Total Required Done",
        "Total Electives Done",
        "Tota Electives Passed");
        ACAExamCourseRegistration.CalcFields(
        "Classified Electives C. Count",
        "Classified Electives Units",
        "Total Classified C. Count",
        "Total Classified Units",
        "Classified Total Marks",
        "Classified W. Total",
        "Total Failed Core Units");
                  ACAExamCourseRegistration."Cummulative Fails":=GetCummulativeFails(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study");
                  ACAExamCourseRegistration."Cumm. Required Stage Units":=GetCummulativeReqStageUnitrs(ACAExamCourseRegistration.Programme,ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration."Programme Option",
                  ACAExamCourseRegistration."Academic Year");
                  ACAExamCourseRegistration."Cumm Attained Units":=GetCummAttainedUnits(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration.Programme);
                   ACAExamCourseRegistration.Modify;
                            ACAExamCourseRegistration.CalcFields("Skip Supplementary Generation");
                   if ACAExamCourseRegistration."Skip Supplementary Generation" = true then begin
                     // Delete all Supp Registrations here
                     if Coregcs.Find('-') then begin
                       repeat
                         begin
                     Clear(Aca2ndSuppExamsDetails3);
                      Aca2ndSuppExamsDetails3.Reset;
                      Aca2ndSuppExamsDetails3.SetRange("Student No.",ACAExamCourseRegistration."Student Number");
        Aca2ndSuppExamsDetails3.SetRange(Category,Aca2ndSuppExamsDetails3.Category::Supplementary);
        Aca2ndSuppExamsDetails3.SetRange(Semester,Coregcs.Semester);
        Aca2ndSuppExamsDetails3.SetRange("Exam Marks",0);
                      if Aca2ndSuppExamsDetails3.Find('-') then Aca2ndSuppExamsDetails3.DeleteAll;
                      end;
                      until Coregcs.Next = 0;
                      end;
                     end;

                      end;
                      until ACAExamCourseRegistration.Next=0;
          ProgBar2.Close;
                  end;
                  Clear(ACASenateReportsHeader);
                    ACASenateReportsHeader.Reset;
                    ACASenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                    ACASenateReportsHeader.SetFilter("Reporting Academic Year",Coregcs."Academic Year");
                    if ACASenateReportsHeader.Find('-') then begin
                      ProgBar22.Open('#1##########################################');
                      repeat
                          begin
                          ProgBar22.Update(1,'Student Number: '+ACASenateReportsHeader."Programme Code"+' Class: '+ACASenateReportsHeader."Classification Code");
                          with ACASenateReportsHeader do
                            begin
                              ACASenateReportsHeader.CalcFields("School Classification Count","School Total Passed","School Total Passed",
                              "School Total Failed","Programme Classification Count","Programme Total Passed","Programme Total Failed","School Total Count",
                              "Prog. Total Count");

                              CalcFields("School Classification Count","School Total Passed","School Total Failed","School Total Count",
                              "Programme Classification Count","Prog. Total Count","Programme Total Failed","Programme Total Passed");
                              if "School Total Count">0 then
                              "Sch. Class % Value":=ROUND((("School Classification Count"/"School Total Count")*100),0.01,'=');
                              if "School Total Count">0 then
                              "School % Failed":=ROUND((("School Total Failed"/"School Total Count")*100),0.01,'=');
                              if "School Total Count">0 then
                              "School % Passed":=ROUND((("School Total Passed"/"School Total Count")*100),0.01,'=');
                              if "Prog. Total Count">0 then
                              "Prog. Class % Value":=ROUND((("Programme Classification Count"/"Prog. Total Count")*100),0.01,'=');
                              if "Prog. Total Count">0 then
                              "Programme % Failed":=ROUND((("Programme Total Failed"/"Prog. Total Count")*100),0.01,'=');
                              if "Prog. Total Count">0 then
                              "Programme % Passed":=ROUND((("Programme Total Passed"/"Prog. Total Count")*100),0.01,'=');
                              end;
                              ACASenateReportsHeader.Modify;
                          end;
                        until ACASenateReportsHeader.Next=0;
                        ProgBar22.Close;
                        end;
        end;
        until ProgForFilters.Next  = 0;
          end;
          Update2ndSupplementaryMarks;
    end;

    local procedure GetRubricSupp(ACAProgramme: Record UnknownRecord61511;var CoursesRegz: Record UnknownRecord66642) StatusRemarks: Text[150]
    var
        Customer: Record UnknownRecord61532;
        LubricIdentified: Boolean;
        ACAResultsStatus: Record UnknownRecord69266;
        YearlyReMarks: Text[250];
        StudCoregcs2: Record UnknownRecord61532;
        StudCoregcs24: Record UnknownRecord61532;
        Customersz: Record Customer;
        ACARegStoppageReasons: Record UnknownRecord66620;
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        StudCoregcs: Record UnknownRecord61532;
    begin
        // // // // // // // // // // // CLEAR(StatusRemarks);
        // // // // // // // // // // // CLEAR(YearlyReMarks);
        // // // // // // // // // // //      Customer.RESET;
        // // // // // // // // // // //      Customer.SETRANGE("Student No.",CoursesRegz."Student Number");
        // // // // // // // // // // //      Customer.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        // // // // // // // // // // //      IF Customer.FIND('-') THEN BEGIN
        // // // // // // // // // // //        IF ((Customer.Status=Customer.Status::Registration) OR (Customer.Status=Customer.Status::Current)) THEN BEGIN
        // // // // // // // // // // //  CLEAR(LubricIdentified);
        // // // // // // // // // // //          CoursesRegz.CALCFIELDS("Attained Stage Units","Failed Cores","Failed Courses","Failed Electives","Failed Required","Failed Units",
        // // // // // // // // // // //          "Total Failed Units","Total Marks","Total Required Done",
        // // // // // // // // // // //          "Total Required Passed","Total Units","Total Weighted Marks");
        // // // // // // // // // // //          CoursesRegz.CALCFIELDS("Total Cores Done","Total Cores Passed","Total Courses","Total Electives Done","Total Failed Courses",
        // // // // // // // // // // //          "Tota Electives Passed","Total Classified C. Count","Total Classified Units","Total Classified Units");
        // // // // // // // // // // // // // // //          IF CoursesRegz."Units Deficit">0 THEN BEGIN
        // // // // // // // // // // // // // // //            CoursesRegz."Failed Cores":=CoursesRegz."Failed Cores"+CoursesRegz."Units Deficit";
        // // // // // // // // // // // // // // //            CoursesRegz."Failed Courses":=CoursesRegz."Failed Courses"+CoursesRegz."Units Deficit";
        // // // // // // // // // // // // // // //            CoursesRegz."Total Failed Courses":=CoursesRegz."Total Failed Courses"+CoursesRegz."Units Deficit";
        // // // // // // // // // // // // // // //            CoursesRegz."Total Courses":=CoursesRegz."Total Courses"+CoursesRegz."Units Deficit";
        // // // // // // // // // // // // // // //            END;
        // // // // // // // // // // //          IF CoursesRegz."Total Courses">0 THEN
        // // // // // // // // // // //            CoursesRegz."% Failed Courses":=(CoursesRegz."Failed Courses"/CoursesRegz."Total Courses")*100;
        // // // // // // // // // // //          CoursesRegz."% Failed Courses":=ROUND(CoursesRegz."% Failed Courses",0.01,'=');
        // // // // // // // // // // //          IF CoursesRegz."% Failed Courses">100 THEN CoursesRegz."% Failed Courses":=100;
        // // // // // // // // // // //          IF CoursesRegz."Total Cores Done">0 THEN
        // // // // // // // // // // //            CoursesRegz."% Failed Cores":=((CoursesRegz."Failed Cores"/CoursesRegz."Total Cores Done")*100);
        // // // // // // // // // // //          CoursesRegz."% Failed Cores":=ROUND(CoursesRegz."% Failed Cores",0.01,'=');
        // // // // // // // // // // //          IF CoursesRegz."% Failed Cores">100 THEN CoursesRegz."% Failed Cores":=100;
        // // // // // // // // // // //          IF CoursesRegz."Total Units">0 THEN
        // // // // // // // // // // //            CoursesRegz."% Failed Units":=(CoursesRegz."Failed Units"/CoursesRegz."Total Units")*100;
        // // // // // // // // // // //          CoursesRegz."% Failed Units":=ROUND(CoursesRegz."% Failed Units",0.01,'=');
        // // // // // // // // // // //          IF CoursesRegz."% Failed Units">100 THEN CoursesRegz."% Failed Units":=100;
        // // // // // // // // // // //          IF CoursesRegz."Total Electives Done">0 THEN
        // // // // // // // // // // //            CoursesRegz."% Failed Electives":=(CoursesRegz."Failed Electives"/CoursesRegz."Total Electives Done")*100;
        // // // // // // // // // // //          CoursesRegz."% Failed Electives":=ROUND(CoursesRegz."% Failed Electives",0.01,'=');
        // // // // // // // // // // //          IF CoursesRegz."% Failed Electives">100 THEN CoursesRegz."% Failed Electives":=100;
        // // // // // // // // // // //                    CoursesRegz.MODIFY;
        // // // // // // // // // // // ACAResultsStatus.RESET;
        // // // // // // // // // // // ACAResultsStatus.SETFILTER("Manual Status Processing",'%1',FALSE);
        // // // // // // // // // // // ACAResultsStatus.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        // // // // // // // // // // // ACAResultsStatus.SETRANGE("Special Programme Class",ACAProgramme."Special Programme Class");
        // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Min. Unit Repeat Counts",'=%1|<%2',CoursesRegz."Highest Yearly Repeats",CoursesRegz."Highest Yearly Repeats");
        // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Max. Unit Repeat Counts",'=%1|>%2',CoursesRegz."Highest Yearly Repeats",CoursesRegz."Highest Yearly Repeats");
        // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."Yearly Failed Units %",CoursesRegz."Yearly Failed Units %");
        // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."Yearly Failed Units %",CoursesRegz."Yearly Failed Units %");
        // // // // // // // // // // // IF ACAProgramme."Special Programme Class"=ACAProgramme."Special Programme Class"::"Medicine & Nursing" THEN BEGIN
        // // // // // // // // // // //  IF CoursesRegz."% Failed Cores">0 THEN BEGIN
        // // // // // // // // // // // ACAResultsStatus.SETFILTER("Minimum Core Fails",'=%1|<%2',CoursesRegz."% Failed Cores",CoursesRegz."% Failed Cores");
        // // // // // // // // // // // ACAResultsStatus.SETFILTER("Maximum Core Fails",'=%1|>%2',CoursesRegz."% Failed Cores",CoursesRegz."% Failed Cores");
        // // // // // // // // // // // END ELSE BEGIN
        // // // // // // // // // // //  ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."Failed Courses",CoursesRegz."Failed Courses");
        // // // // // // // // // // //  ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."Failed Courses",CoursesRegz."Failed Courses");
        // // // // // // // // // // // END;
        // // // // // // // // // // // //  ACAResultsStatus.SETFILTER("Minimum None-Core Fails",'=%1|<%2',CoursesRegz."Failed Required",CoursesRegz."Failed Required");
        // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Maximum None-Core Fails",'=%1|>%2',CoursesRegz."Failed Required",CoursesRegz."Failed Required");
        // // // // // // // // // // // END ELSE BEGIN
        // // // // // // // // // // //  ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Courses",CoursesRegz."% Failed Courses");
        // // // // // // // // // // //  ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Courses",CoursesRegz."% Failed Courses");
        // // // // // // // // // // // END;
        // // // // // // // // // // // // // // // // ELSE BEGIN
        // // // // // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',YearlyFailedUnits,YearlyFailedUnits);
        // // // // // // // // // // // // // // // // ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',YearlyFailedUnits,YearlyFailedUnits);
        // // // // // // // // // // // // // // // //  END;
        // // // // // // // // // // // ACAResultsStatus.SETCURRENTKEY("Order No");
        // // // // // // // // // // // IF ACAResultsStatus.FIND('-') THEN BEGIN
        // // // // // // // // // // //  REPEAT
        // // // // // // // // // // //  BEGIN
        // // // // // // // // // // //      StatusRemarks:=ACAResultsStatus.Code;
        // // // // // // // // // // //      IF ACAResultsStatus."Lead Status"<>'' THEN
        // // // // // // // // // // //      StatusRemarks:=ACAResultsStatus."Lead Status";
        // // // // // // // // // // //      YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        // // // // // // // // // // //      LubricIdentified:=TRUE;
        // // // // // // // // // // //  END;
        // // // // // // // // // // //  UNTIL ((ACAResultsStatus.NEXT=0) OR (LubricIdentified=TRUE))
        // // // // // // // // // // // END;
        // // // // // // // // // // // CoursesRegz.CALCFIELDS("Supp Exists","Attained Stage Units","Special Exists","Exists a Failed Supp.","Exists a Failed Special");
        // // // // // // // // // // // //IF CoursesRegz."Supp/Special Exists" THEN  StatusRemarks:='SPECIAL';
        // // // // // // // // // // // //IF CoursesRegz."Units Deficit">0 THEN StatusRemarks:='DTSC';
        // // // // // // // // // // // //IF ((CoursesRegz."Exists a Failed Special") AND (CoursesRegz."Exists a Failed Supp."=FALSE)) THEN StatusRemarks:='SUPP';
        // // // // // // // // // // // //IF CoursesRegz."Exists a Failed Supp." THEN StatusRemarks:='2ND SUPP';
        // // // // // // // // // // // //IF CoursesRegz."Required Stage Units">CoursesRegz."Attained Stage Units" THEN StatusRemarks:='DTSC';
        // // // // // // // // // // // //IF CoursesRegz."Exists DTSC Prefix" THEN StatusRemarks:='DTSC';
        // // // // // // // // // // //
        // // // // // // // // // // //          END ELSE BEGIN
        // // // // // // // // // // //
        // // // // // // // // // // // // // // // // // // CoursesRegz.CALCFIELDS("Attained Stage Units");
        // // // // // // // // // // // // // // // // // // IF CoursesRegz."Attained Stage Units" = 0 THEN  StatusRemarks:='DTSC';
        // // // // // // // // // // // // // // // // // // CLEAR(StudCoregcs);
        // // // // // // // // // // // // // // // // // // StudCoregcs.RESET;
        // // // // // // // // // // // // // // // // // // StudCoregcs.SETRANGE("Student No.",CoursesRegz."Student Number");
        // // // // // // // // // // // // // // // // // // StudCoregcs.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        // // // // // // // // // // // // // // // // // // StudCoregcs.SETRANGE("Stoppage Exists In Acad. Year",TRUE);
        // // // // // // // // // // // // // // // // // // IF StudCoregcs.FIND('-') THEN BEGIN
        // // // // // // // // // // // // // // // // // // CLEAR(StudCoregcs2);
        // // // // // // // // // // // // // // // // // // StudCoregcs2.RESET;
        // // // // // // // // // // // // // // // // // // StudCoregcs2.SETRANGE("Student No.",CoursesRegz."Student Number");
        // // // // // // // // // // // // // // // // // // StudCoregcs2.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        // // // // // // // // // // // // // // // // // // StudCoregcs2.SETRANGE("Stoppage Exists In Acad. Year",TRUE);
        // // // // // // // // // // // // // // // // // // StudCoregcs2.SETRANGE(Reversed,TRUE);
        // // // // // // // // // // // // // // // // // // IF StudCoregcs2.FIND('-') THEN BEGIN
        // // // // // // // // // // // // // // // // // //    StatusRemarks:=UPPERCASE(FORMAT(StudCoregcs2."Stoppage Reason"));
        // // // // // // // // // // // // // // // // // //  YearlyReMarks:=StatusRemarks;
        // // // // // // // // // // // // // // // // // //  END;
        // // // // // // // // // // // // // // // // // //  END;
        // // // // // // // // // // //
        // // // // // // // // // // // ACAResultsStatus.RESET;
        // // // // // // // // // // // ACAResultsStatus.SETRANGE(Status,Customer.Status);
        // // // // // // // // // // // ACAResultsStatus.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        // // // // // // // // // // // ACAResultsStatus.SETRANGE("Special Programme Class",ACAProgramme."Special Programme Class");
        // // // // // // // // // // // IF ACAResultsStatus.FIND('-') THEN BEGIN
        // // // // // // // // // // //  StatusRemarks:=ACAResultsStatus.Code;
        // // // // // // // // // // //  YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        // // // // // // // // // // // END ELSE BEGIN
        // // // // // // // // // // //  StatusRemarks:=UPPERCASE(FORMAT(Customer.Status));
        // // // // // // // // // // //  YearlyReMarks:=StatusRemarks;
        // // // // // // // // // // //  END;
        // // // // // // // // // // //            END;
        // // // // // // // // // // //        END;
        Clear(StatusRemarks);
        Clear(YearlyReMarks);
              Customer.Reset;
              Customer.SetRange("Student No.",CoursesRegz."Student Number");
              Customer.SetRange("Academic Year",CoursesRegz."Academic Year");
              if Customer.Find('+') then  begin
                if ((Customer.Status=Customer.Status::Registration) or (Customer.Status=Customer.Status::Current)) then begin
          Clear(LubricIdentified);
                  CoursesRegz.CalcFields("Attained Stage Units","Failed Cores","Failed Courses","Failed Electives","Failed Required","Failed Units",
                  "Total Failed Units","Total Marks","Total Required Done",
                  "Total Required Passed","Total Units","Total Weighted Marks","Exists DTSC Prefix");
                  CoursesRegz.CalcFields("Total Cores Done","Total Cores Passed","Total Courses","Total Electives Done","Total Failed Courses",
                  "Tota Electives Passed","Total Classified C. Count","Total Classified Units","Total Classified Units");
                  if CoursesRegz."Total Courses">0 then
                    CoursesRegz."% Failed Courses":=(CoursesRegz."Failed Courses"/CoursesRegz."Total Courses")*100;
                  CoursesRegz."% Failed Courses":=ROUND(CoursesRegz."% Failed Courses",0.01,'>');
                  if CoursesRegz."% Failed Courses">100 then CoursesRegz."% Failed Courses":=100;
                  if CoursesRegz."Total Cores Done">0 then
                    CoursesRegz."% Failed Cores":=((CoursesRegz."Failed Cores"/CoursesRegz."Total Cores Done")*100);
                  CoursesRegz."% Failed Cores":=ROUND(CoursesRegz."% Failed Cores",0.01,'>');
                  if CoursesRegz."% Failed Cores">100 then CoursesRegz."% Failed Cores":=100;
                  if CoursesRegz."Total Units">0 then
                    CoursesRegz."% Failed Units":=(CoursesRegz."Failed Units"/CoursesRegz."Total Units")*100;
                  CoursesRegz."% Failed Units":=ROUND(CoursesRegz."% Failed Units",0.01,'>');
                  if CoursesRegz."% Failed Units">100 then CoursesRegz."% Failed Units":=100;
                  if CoursesRegz."Total Electives Done">0 then
                    CoursesRegz."% Failed Electives":=(CoursesRegz."Failed Electives"/CoursesRegz."Total Electives Done")*100;
                  CoursesRegz."% Failed Electives":=ROUND(CoursesRegz."% Failed Electives",0.01,'>');
                  if CoursesRegz."% Failed Electives">100 then CoursesRegz."% Failed Electives":=100;
                           // CoursesRegz.MODIFY;
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        if ACAProgramme."Special Programme Class"=ACAProgramme."special programme class"::"Medicine & Nursing" then begin
        ACAResultsStatus.SetFilter("Special Programme Class",'=%1',ACAResultsStatus."special programme class"::"Medicine & Nursing");
        end else begin
          ACAResultsStatus.SetFilter("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
          ACAResultsStatus.SetFilter("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
        end;
          ACAResultsStatus.SetFilter("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
          ACAResultsStatus.SetFilter("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
        ACAResultsStatus.SetCurrentkey("Order No");
        if ACAResultsStatus.Find('-') then begin
          repeat
          begin
              StatusRemarks:=ACAResultsStatus.Code;
              if ACAResultsStatus."Lead Status"<>'' then
              StatusRemarks:=ACAResultsStatus."Lead Status";
              YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
              LubricIdentified:=true;
          end;
          until ((ACAResultsStatus.Next=0) or (LubricIdentified=true))
        end;
        CoursesRegz.CalcFields("Supp/Special Exists","Attained Stage Units","Special Registration Exists");
        //IF CoursesRegz."Supp/Special Exists" THEN  StatusRemarks:='SPECIAL';
        //IF CoursesRegz."Units Deficit">0 THEN StatusRemarks:='DTSC';
        if CoursesRegz."Required Stage Units">CoursesRegz."Attained Stage Units" then StatusRemarks:='DTSC';
        //IF CoursesRegz."Exists DTSC Prefix" THEN StatusRemarks:='DTSC';
        //IF CoursesRegz."Special Registration Exists" THEN StatusRemarks:='Special';

        ////////////////////////////////////////////////////////////////////////////////////////////////
        // Check if exists a stopped Semester for the Academic Years and Pick the Status on the lines as the rightful Status
        Clear(StudCoregcs24);
        StudCoregcs24.Reset;
        StudCoregcs24.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs24.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs24.SetRange(Reversed,true);
        if StudCoregcs24.Find('-') then begin
          Clear(ACARegStoppageReasons);
          ACARegStoppageReasons.Reset;
          ACARegStoppageReasons.SetRange("Reason Code",StudCoregcs24."Stoppage Reason");
          if ACARegStoppageReasons.Find('-') then begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Status,ACARegStoppageReasons."Global Status");
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        end else begin
          StatusRemarks:=UpperCase(Format(StudCoregcs24."Stoppage Reason"));
          YearlyReMarks:=StatusRemarks;
          end;
          end;
          end;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////

                  end else begin

        CoursesRegz.CalcFields("Attained Stage Units");
        if CoursesRegz."Attained Stage Units" = 0 then  StatusRemarks:='DTSC';
        Clear(StudCoregcs);
        StudCoregcs.Reset;
        StudCoregcs.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs.SetRange("Stoppage Exists In Acad. Year",true);
        if StudCoregcs.Find('-') then begin
        Clear(StudCoregcs2);
        StudCoregcs2.Reset;
        StudCoregcs2.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs2.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs2.SetRange("Stoppage Exists In Acad. Year",true);
        StudCoregcs2.SetRange(Reversed,true);
        if StudCoregcs2.Find('-') then begin
            StatusRemarks:=UpperCase(Format(StudCoregcs2."Stoppage Reason"));
          YearlyReMarks:=StatusRemarks;
          end;
          end;

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Status,Customer.Status);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        end else begin
          StatusRemarks:=UpperCase(Format(Customer.Status));
          YearlyReMarks:=StatusRemarks;
          end;
                    end;
                end;


        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,StatusRemarks);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          // Check if the Ststus does not allow Supp. Generation and delete
          if ACAResultsStatus."Skip Supp Generation" = true then  begin
            // Delete Entries from Supp Registration for the Semester
            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",CoursesRegz."Student Number");
            AcaSpecialExamsDetails.SetRange("Year of Study",CoursesRegz."Year of Study");
            AcaSpecialExamsDetails.SetRange("Exam Marks",0);
            AcaSpecialExamsDetails.SetRange(Status,AcaSpecialExamsDetails.Status::New);
            if AcaSpecialExamsDetails.Find('-') then AcaSpecialExamsDetails.DeleteAll;
            end;
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

    local procedure Update2ndSupplementaryMarks()
    var
        ST1SuppExamClassificationUnits: Record UnknownRecord66641;
        CountedSeq: Integer;
        ACAExamCategory: Record UnknownRecord61568;
        ACAGeneralSetUp: Record UnknownRecord61534;
        Aca2NDSpecialExamsDetails: Record UnknownRecord78031;
        Aca2NDSpecialExamsDetails3: Record UnknownRecord78031;
        ACAExam2NDSuppUnits: Record "ACA-2ndExam Supp. Units";
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        Aca2ndSuppExamsResults: Record UnknownRecord78032;
        AcdYrs: Record UnknownRecord61382;
        Custos: Record Customer;
        StudentUnits: Record UnknownRecord61549;
        Coregcsz10: Record UnknownRecord61532;
        CountedRegistrations: Integer;
        UnitsSubjects: Record UnknownRecord61517;
        Programme_Fin: Record UnknownRecord61511;
        ProgrammeStages_Fin: Record UnknownRecord61516;
        AcademicYear_Fin: Record UnknownRecord61382;
        Semesters_Fin: Record UnknownRecord61692;
        ExamResults: Record UnknownRecord61548;
        ClassCustomer: Record Customer;
        ClassExamResultsBuffer2: Record UnknownRecord61746;
        ClassDimensionValue: Record "Dimension Value";
        ClassGradingSystem: Record UnknownRecord61521;
        ClassClassGradRubrics: Record UnknownRecord78011;
        ClassExamResults2: Record UnknownRecord61548;
        TotalRecs: Integer;
        CountedRecs: Integer;
        RemeiningRecs: Integer;
        ExpectedElectives: Integer;
        CountedElectives: Integer;
        ProgBar2: Dialog;
        Progyz: Record UnknownRecord61511;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        ACA2NDExamClassificationUnits: Record UnknownRecord66681;
        ACA2NDExamCourseRegistration: Record UnknownRecord66682;
        ACA2NDExamFailedReasons: Record "ACA-2ndSuppExam Fail Reasons";
        ACA2NDSenateReportsHeader: Record "ACA-2ndSuppSenate Repo. Header";
        ACA2NDExamClassificationStuds: Record "ACA-2ndSuppExam Class. Studs";
        ACA2NDExamClassificationStudsCheck: Record "ACA-2ndSuppExam Class. Studs";
        ACAExamResultsFin: Record UnknownRecord61548;
        ACAResultsStatus: Record UnknownRecord61739;
        ProgressForCoReg: Dialog;
        Tens: Text;
        ACASemesters: Record UnknownRecord61692;
        ACAExamResults_Fin: Record UnknownRecord61548;
        ProgBar22: Dialog;
        Coregcs: Record UnknownRecord61532;
        ACA2NDExamCummulativeResit: Record "ACA-2ndSuppExam Cumm. Resit";
        ACAStudentUnitsForResits: Record UnknownRecord61549;
        SEQUENCES: Integer;
        CurrStudentNo: Code[20];
        CountedNos: Integer;
        CurrSchool: Code[20];
        CUrrentExamScore: Decimal;
        OriginalCatScores: Decimal;
        ACASuppExamClassUnits4Supp2: Record UnknownRecord66641;
        ObjExamResult: Record UnknownRecord61548;
        CatResultsExist: Boolean;
        ExamResultExist: Boolean;
    begin
        Clear(ProgFIls);
        Clear(ProgForFilters);
        ProgForFilters.Reset;
        if Schools<>'' then
        ProgForFilters.SetFilter("School Code",Schools) else
        if programs<>'' then
        ProgForFilters.SetFilter(Code,programs);
        if ProgForFilters.Find('-') then begin
          repeat
            begin
        // Clear CLassification For Selected Filters
        //ProgFIls:=GetProgFilters1(programs,Schools);
        ProgFIls:=ProgForFilters.Code;
        ACA2NDExamClassificationStuds.Reset;
        ACA2NDExamCourseRegistration.Reset;
        ACA2NDExamClassificationUnits.Reset;
        ACAExam2NDSuppUnits.Reset;
        if StudNos<>'' then begin
        ACA2NDExamClassificationStuds.SetFilter("Student Number",StudNos);
        ACA2NDExamCourseRegistration.SetRange("Student Number",StudNos);
        ACA2NDExamClassificationUnits.SetRange("Student No.",StudNos);
        ACAExam2NDSuppUnits.SetRange("Student No.",StudNos);
        end;
        if AcadYear<>'' then begin
        ACA2NDExamClassificationStuds.SetFilter("Academic Year",AcadYear);
        ACA2NDExamCourseRegistration.SetFilter("Academic Year",AcadYear);
        ACA2NDExamClassificationUnits.SetFilter("Academic Year",AcadYear);
        ACAExam2NDSuppUnits.SetFilter("Academic Year",AcadYear);
        end;

        ACA2NDExamClassificationStuds.SetFilter(Programme,ProgFIls);
        ACA2NDExamCourseRegistration.SetFilter(Programme,ProgFIls);
        ACA2NDExamClassificationUnits.SetFilter(Programme,ProgFIls);
        ACAExam2NDSuppUnits.SetFilter(Programme,ProgFIls);
        if ACA2NDExamClassificationStuds.Find('-') then ACA2NDExamClassificationStuds.DeleteAll;
        if ACA2NDExamCourseRegistration.Find('-') then ACA2NDExamCourseRegistration.DeleteAll;
        if ACA2NDExamClassificationUnits.Find('-') then ACA2NDExamClassificationUnits.DeleteAll;
        if ACAExam2NDSuppUnits.Find('-') then ACAExam2NDSuppUnits.DeleteAll;


                          ACA2NDSenateReportsHeader.Reset;
                          ACA2NDSenateReportsHeader.SetFilter("Academic Year",AcadYear);
                          ACA2NDSenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                          if  (ACA2NDSenateReportsHeader.Find('-')) then ACA2NDSenateReportsHeader.DeleteAll;

        Coregcs.Reset;
        Coregcs.SetFilter(Programme,ProgFIls);
        Coregcs.SetFilter("Academic Year",AcadYear);
        Coregcs.SetRange("Exclude from Computation",false);
        Coregcs.SetRange("Supp/Special Exists",true);
        if StudNos<>'' then begin
        Coregcs.SetFilter("Student No.",StudNos);
          end;
        if Coregcs.Find('-') then begin
          Clear(TotalRecs);
        Clear(RemeiningRecs);
        Clear(CountedRecs);
        TotalRecs:=Coregcs.Count;
        RemeiningRecs:=TotalRecs;
          // Loop through all Ungraduated Students Units
          Progressbar.Open('#1#####################################################\'+
          '#2############################################################\'+
          '#3###########################################################\'+
          '#4############################################################\'+
          '#5###########################################################\'+
          '#6############################################################');
             Progressbar.Update(1,'Processing  values....');
             Progressbar.Update(2,'Total Recs.: '+Format(TotalRecs));
          repeat
            begin

            CountedRecs:=CountedRecs+1;
            RemeiningRecs:=RemeiningRecs-1;
            // Create Registration Unit entry if Not Exists
             Progressbar.Update(3,'.....................................................');
             Progressbar.Update(4,'Processed: '+Format(CountedRecs));
             Progressbar.Update(5,'Remaining: '+Format(RemeiningRecs));
             Progressbar.Update(6,'----------------------------------------------------');
                Progyz.Reset;
                Progyz.SetFilter(Code,Coregcs.Programme);
             if Progyz.Find('-') then begin
               end;
               Clear(YosStages);
            if Coregcs."Year Of Study"=0 then  begin Coregcs.Validate(Stage);
              Coregcs.Modify;
              end;
            if Coregcs."Year Of Study"=1 then YosStages:='Y1S1|Y1S2|Y1S3|Y1S4'
            else if Coregcs."Year Of Study"=2 then YosStages:='Y2S1|Y2S2|Y2S3|Y2S4'
            else if Coregcs."Year Of Study"=3 then YosStages:='Y3S1|Y3S2|Y3S3|Y3S4'
            else if Coregcs."Year Of Study"=4 then YosStages:='Y4S1|Y4S2|Y4S3|Y4S4'
            else if Coregcs."Year Of Study"=5 then YosStages:='Y5S1|Y5S2|Y5S3|Y5S4'
            else if Coregcs."Year Of Study"=6 then YosStages:='Y6S1|Y6S2|Y6S3|Y6S4'
            else if Coregcs."Year Of Study"=7 then YosStages:='Y7S1|Y7S2|Y7S3|Y7S4'
            else if Coregcs."Year Of Study"=8 then YosStages:='Y8S1|Y8S2|Y8S3|Y8S4';

                  ACA2NDExamCummulativeResit.Reset;
                ACA2NDExamCummulativeResit.SetRange("Student Number",StudentUnits."Student No.");
                ACA2NDExamCummulativeResit.SetRange("Academic Year",Coregcs."Academic Year");
                if ACA2NDExamCummulativeResit.Find('-') then ACA2NDExamCummulativeResit.DeleteAll;

        Custos.Reset;
        Custos.SetRange("No.",Coregcs."Student No.");
        if Custos.Find('-') then
        Custos.CalcFields("Senate Classification Based on");

        StudentUnits.Reset;
        StudentUnits.SetRange("Student No.",Coregcs."Student No.");
        StudentUnits.SetRange("Year Of Study",Coregcs."Year Of Study");
        //StudentUnits.SETRANGE("Academic Year Exclude Comp.",FALSE);
        //StudentUnits.SETRANGE("Reg. Reversed",FALSE);
        StudentUnits.SetFilter(Unit,'<>%1','');

         Clear(CountedRegistrations);
         Clear(Coregcsz10);
         Coregcsz10.Reset;
         Coregcsz10.SetRange("Student No.",Coregcs."Student No.");
         Coregcsz10.SetRange("Year Of Study",Coregcs."Year Of Study");
         Coregcsz10.SetRange(Reversed,false);
         Coregcsz10.SetFilter(Stage,'..%1',Coregcs.Stage);
         if Coregcsz10.Find('-') then begin
          CountedRegistrations := Coregcsz10.Count;
          if CountedRegistrations <2 then // Filter
        StudentUnits.SetRange(Stage,Coregcs.Stage);
          end;
        Coregcs.CalcFields("Stoppage Exists In Acad. Year","Stoppage Exists in YoS","Stopped Academic Year","Stopage Yearly Remark");
              if Coregcs."Stopped Academic Year" <>'' then begin
               if Coregcs."Academic Year Exclude Comp."=false then
              StudentUnits.SetFilter("Academic Year (Flow)",'=%1|=%2',Coregcs."Stopped Academic Year",Coregcs."Academic Year");
               end
              else
              StudentUnits.SetFilter("Academic Year (Flow)",'=%1',Coregcs."Academic Year");
        /////////////////////////////////////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////////////
            // Grad Headers

                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
                    ACAResultsStatus.SetRange("Academic Year",Coregcs."Academic Year");
                    if ACAResultsStatus.Find('-') then begin
                      repeat
                          begin
                          ACA2NDSenateReportsHeader.Reset;
                          ACA2NDSenateReportsHeader.SetRange("Academic Year",Coregcs."Academic Year");
                          ACA2NDSenateReportsHeader.SetRange("School Code",Progyz."School Code");
                          ACA2NDSenateReportsHeader.SetRange("Classification Code",ACAResultsStatus.Code);
                          ACA2NDSenateReportsHeader.SetRange("Programme Code",Progyz.Code);
                          ACA2NDSenateReportsHeader.SetRange("Year of Study",Coregcs."Year Of Study");
                          if not (ACA2NDSenateReportsHeader.Find('-')) then begin
                            ACA2NDSenateReportsHeader.Init;
                            ACA2NDSenateReportsHeader."Academic Year":=Coregcs."Academic Year";
                            ACA2NDSenateReportsHeader."Reporting Academic Year":=Coregcs."Academic Year";
                            ACA2NDSenateReportsHeader."Rubric Order":=ACAResultsStatus."Order No";
                            ACA2NDSenateReportsHeader."Programme Code":=Progyz.Code;
                            ACA2NDSenateReportsHeader."School Code":=Progyz."School Code";
                            ACA2NDSenateReportsHeader."Year of Study":=Coregcs."Year Of Study";
                            ACA2NDSenateReportsHeader."Classification Code":=ACAResultsStatus.Code;
                            ACA2NDSenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
                            ACA2NDSenateReportsHeader."IncludeVariable 1":=ACAResultsStatus."IncludeVariable 1";
                            ACA2NDSenateReportsHeader."IncludeVariable 2":=ACAResultsStatus."IncludeVariable 2";
                            ACA2NDSenateReportsHeader."IncludeVariable 3":=ACAResultsStatus."IncludeVariable 3";
                            ACA2NDSenateReportsHeader."IncludeVariable 4":=ACAResultsStatus."IncludeVariable 4";
                            ACA2NDSenateReportsHeader."IncludeVariable 5":=ACAResultsStatus."IncludeVariable 5";
                            ACA2NDSenateReportsHeader."IncludeVariable 6":=ACAResultsStatus."IncludeVariable 6";
                            ACA2NDSenateReportsHeader."Summary Page Caption":=ACAResultsStatus."Summary Page Caption";
                            ACA2NDSenateReportsHeader."Include Failed Units Headers":=ACAResultsStatus."Include Failed Units Headers";
                            ACA2NDSenateReportsHeader."Include Academic Year Caption":=ACAResultsStatus."Include Academic Year Caption";
                            ACA2NDSenateReportsHeader."Academic Year Text":=ACAResultsStatus."Academic Year Text";
                            ACA2NDSenateReportsHeader."Status Msg1":=ACAResultsStatus."Status Msg1";
                            ACA2NDSenateReportsHeader."Status Msg2":=ACAResultsStatus."Status Msg2";
                            ACA2NDSenateReportsHeader."Status Msg3":=ACAResultsStatus."Status Msg3";
                            ACA2NDSenateReportsHeader."Status Msg4":=ACAResultsStatus."Status Msg4";
                            ACA2NDSenateReportsHeader."Status Msg5":=ACAResultsStatus."Status Msg5";
                            ACA2NDSenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
                            ACA2NDSenateReportsHeader."Grad. Status Msg 1":=ACAResultsStatus."Grad. Status Msg 1";
                            ACA2NDSenateReportsHeader."Grad. Status Msg 2":=ACAResultsStatus."Grad. Status Msg 2";
                            ACA2NDSenateReportsHeader."Grad. Status Msg 3":=ACAResultsStatus."Grad. Status Msg 3";
                            ACA2NDSenateReportsHeader."Grad. Status Msg 4":=ACAResultsStatus."Grad. Status Msg 4";
                            ACA2NDSenateReportsHeader."Grad. Status Msg 5":=ACAResultsStatus."Grad. Status Msg 5";
                            ACA2NDSenateReportsHeader."Grad. Status Msg 6":=ACAResultsStatus."Grad. Status Msg 6";
                            ACA2NDSenateReportsHeader."Finalists Graduation Comments":=ACAResultsStatus."Finalists Grad. Comm. Degree";
                            ACA2NDSenateReportsHeader."1st Year Grad. Comments":=ACAResultsStatus."1st Year Grad. Comments";
                            ACA2NDSenateReportsHeader."2nd Year Grad. Comments":=ACAResultsStatus."2nd Year Grad. Comments";
                            ACA2NDSenateReportsHeader."3rd Year Grad. Comments":=ACAResultsStatus."3rd Year Grad. Comments";
                            ACA2NDSenateReportsHeader."4th Year Grad. Comments":=ACAResultsStatus."4th Year Grad. Comments";
                            ACA2NDSenateReportsHeader."5th Year Grad. Comments":=ACAResultsStatus."5th Year Grad. Comments";
                            ACA2NDSenateReportsHeader."6th Year Grad. Comments":=ACAResultsStatus."6th Year Grad. Comments";
                            ACA2NDSenateReportsHeader."7th Year Grad. Comments":=ACAResultsStatus."7th Year Grad. Comments";
                          if   ACA2NDSenateReportsHeader.Insert then;
                            end;
                          end;
                        until ACAResultsStatus.Next=0;
                      end;
            ////////////////////////////////////////////////////////////////////////////
                ACA2NDExamClassificationStuds.Reset;
                ACA2NDExamClassificationStuds.SetRange("Student Number",Coregcs."Student No.");
                ACA2NDExamClassificationStuds.SetRange(Programme,Coregcs.Programme);
                ACA2NDExamClassificationStuds.SetRange("Academic Year",Coregcs."Academic Year");
               // ACA2NDExamClassificationStuds.SETRANGE("Reporting Academic Year",GradAcademicYear);
                if not ACA2NDExamClassificationStuds.Find('-') then begin
                ACA2NDExamClassificationStuds.Init;
                ACA2NDExamClassificationStuds."Student Number":=Coregcs."Student No.";
                ACA2NDExamClassificationStuds."Reporting Academic Year":=Coregcs."Academic Year";
                ACA2NDExamClassificationStuds."School Code":=Progyz."School Code";
                ACA2NDExamClassificationStuds.Department:=Progyz."Department Code";
                ACA2NDExamClassificationStuds."Programme Option":=Coregcs.Options;
                ACA2NDExamClassificationStuds.Programme:=Coregcs.Programme;
                ACA2NDExamClassificationStuds."Academic Year":=Coregcs."Academic Year";
                ACA2NDExamClassificationStuds."Year of Study":=Coregcs."Year Of Study";
              //ACA2NDExamClassificationStuds."Department Name":=GetDepartmentNameOrSchool(Progyz."Department Code");
              ACA2NDExamClassificationStuds."School Name":=GetDepartmentNameOrSchool(Progyz."School Code");
              ACA2NDExamClassificationStuds."Student Name":=GetStudentName(Coregcs."Student No.");
              ACA2NDExamClassificationStuds.Cohort:=GetCohort(Coregcs."Student No.",Coregcs.Programme);
              ACA2NDExamClassificationStuds."Final Stage":=GetFinalStage(Coregcs.Programme);
              ACA2NDExamClassificationStuds."Final Academic Year":=GetFinalAcademicYear(Coregcs."Student No.",Coregcs.Programme);
              ACA2NDExamClassificationStuds."Final Year of Study":=GetFinalYearOfStudy(Coregcs.Programme);
              ACA2NDExamClassificationStuds."Admission Date":=GetAdmissionDate(Coregcs."Student No.",Coregcs.Programme);
              ACA2NDExamClassificationStuds."Admission Academic Year":=GetAdmissionAcademicYear(Coregcs."Student No.",Coregcs.Programme);
              ACA2NDExamClassificationStuds.Graduating:=false;
              ACA2NDExamClassificationStuds.Classification:='';

              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",Coregcs."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,Coregcs.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",Coregcs."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",Coregcs."Year Of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                if ACA2NDExamClassificationStuds.Insert then;

            end;
                /////////////////////////////////////// YoS Tracker
                Progyz.Reset;
                if Progyz.Get(Coregcs.Programme) then;
                ACA2NDExamCourseRegistration.Reset;
                ACA2NDExamCourseRegistration.SetRange("Student Number",Coregcs."Student No.");
                ACA2NDExamCourseRegistration.SetRange(Programme,Coregcs.Programme);
                ACA2NDExamCourseRegistration.SetRange("Year of Study",Coregcs."Year Of Study");
                ACA2NDExamCourseRegistration.SetRange("Academic Year",Coregcs."Academic Year");
                if not ACA2NDExamCourseRegistration.Find('-') then begin
                    ACA2NDExamCourseRegistration.Init;
                    ACA2NDExamCourseRegistration."Student Number":=Coregcs."Student No.";
                    ACA2NDExamCourseRegistration.Programme:=Coregcs.Programme;
                    ACA2NDExamCourseRegistration."Year of Study":=Coregcs."Year Of Study";
                    ACA2NDExamCourseRegistration."Reporting Academic Year":=Coregcs."Academic Year";
                    ACA2NDExamCourseRegistration."Academic Year":=Coregcs."Academic Year";
                    ACA2NDExamCourseRegistration."School Code":=Progyz."School Code";
                    ACA2NDExamCourseRegistration."Programme Option":=Coregcs.Options;
              ACA2NDExamCourseRegistration."School Name":=ACA2NDExamClassificationStuds."School Name";
              ACA2NDExamCourseRegistration."Student Name":=ACA2NDExamClassificationStuds."Student Name";
              ACA2NDExamCourseRegistration.Cohort:=ACA2NDExamClassificationStuds.Cohort;
              ACA2NDExamCourseRegistration."Final Stage":=ACA2NDExamClassificationStuds."Final Stage";
              ACA2NDExamCourseRegistration."Final Academic Year":=ACA2NDExamClassificationStuds."Final Academic Year";
              ACA2NDExamCourseRegistration."Final Year of Study":=ACA2NDExamClassificationStuds."Final Year of Study";
              ACA2NDExamCourseRegistration."Admission Date":=ACA2NDExamClassificationStuds."Admission Date";
              ACA2NDExamCourseRegistration."Admission Academic Year":=ACA2NDExamClassificationStuds."Admission Academic Year";

          if ((Progyz.Category=Progyz.Category::"Certificate ") or
             (Progyz.Category=Progyz.Category::"Course List") or
             (Progyz.Category=Progyz.Category::Professional)) then begin
              ACA2NDExamCourseRegistration."Category Order":=2;
              end else if (Progyz.Category=Progyz.Category::Diploma) then begin
              ACA2NDExamCourseRegistration."Category Order":=3;
                end  else if (Progyz.Category=Progyz.Category::Postgraduate) then begin
              ACA2NDExamCourseRegistration."Category Order":=4;
                end  else if (Progyz.Category=Progyz.Category::Undergraduate) then begin
              ACA2NDExamCourseRegistration."Category Order":=1;
                end;

              ACA2NDExamCourseRegistration.Graduating:=false;
              ACA2NDExamCourseRegistration.Classification:='';
              // Check if failed Supp Exists then insert
              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",Coregcs."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,Coregcs.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",Coregcs."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",Coregcs."Year Of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                  if  ACA2NDExamCourseRegistration.Insert then;
                  end;
                /////////////////////////////////////// end of YoS Tracker

        /////////////////////////////////////////////////////////////////////////////////////////////////////
        if StudentUnits.Find('-') then begin

          repeat
            begin
            ///////
            Clear(Aca2NDSpecialExamsDetails);
            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
            AcaSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
            if AcaSpecialExamsDetails.Find('-') then begin
             // AcaSpecialExamsDetails."Exam Marks":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
            if ((AcaSpecialExamsDetails."Exam Marks">=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",AcaSpecialExamsDetails."Exam Marks"))) then begin
              //Delete the Unit from Second Supp. Registration
              Clear(Aca2NDSpecialExamsDetails);
            Aca2NDSpecialExamsDetails.Reset;
            Aca2NDSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
            Aca2NDSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
            Aca2NDSpecialExamsDetails.SetRange("Exam Marks",0);
            if Aca2NDSpecialExamsDetails.Find('-') then Aca2NDSpecialExamsDetails.DeleteAll;
              end;
              end;
             StudentUnits.CalcFields(StudentUnits."CATs Marks Exists");
             if StudentUnits."CATs Marks Exists"=false then begin

              UnitsSubjects.Reset;
              UnitsSubjects.SetRange("Programme Code",StudentUnits.Programme);
              UnitsSubjects.SetRange(Code,StudentUnits.Unit);
              UnitsSubjects.SetRange("Exempt CAT",true);
              if UnitsSubjects.Find('-') then begin
                 ExamResults.Init;
                 ExamResults."Student No.":=StudentUnits."Student No.";
                 ExamResults.Programme:=StudentUnits.Programme;
                 ExamResults.Stage:=StudentUnits.Stage;
                 ExamResults.Unit:=StudentUnits.Unit;
                 ExamResults.Semester:=StudentUnits.Semester;
                 ExamResults."Academic Year":=StudentUnits."Academic Year";
                 ExamResults."Reg. Transaction ID":=StudentUnits."Reg. Transacton ID";
                 ExamResults.ExamType:='CAT';
                 ExamResults.Exam:='CAT';
                 ExamResults."Exam Category":=Progyz."Exam Category";
                 ExamResults.Score:=0;
                 ExamResults."User Name":='AUTOPOST';
                if  ExamResults.Insert then;
                 end;
                 end;
              // END;
                Clear(ExamResults); ExamResults.Reset;
            ExamResults.SetRange("Student No.",StudentUnits."Student No.");
            ExamResults.SetRange(Unit,StudentUnits.Unit);
            if ExamResults.Find('-') then begin
                repeat
                    begin
                       if ExamResults.ExamType<>'' then begin
           ExamResults.Exam:=ExamResults.ExamType;
           ExamResults.Modify;
           end else  if ExamResults.Exam<>'' then begin
             if ExamResults.ExamType='' then begin
           ExamResults.Rename(ExamResults."Student No.",ExamResults.Programme,ExamResults.Stage,
           ExamResults.Unit,ExamResults.Semester,ExamResults.Exam,ExamResults."Reg. Transaction ID",ExamResults."Entry No");
           end;
           end;
                    end;
                  until ExamResults.Next = 0;
              end;
                    ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii Update Units
            Clear(ExamResults); ExamResults.Reset;
            ExamResults.SetFilter("Counted Occurances",'>%1',1);
            ExamResults.SetRange("Student No.",StudentUnits."Student No.");
            ExamResults.SetRange(Unit,StudentUnits.Unit);
            if ExamResults.Find('-') then begin
              repeat
                begin
                ACAExamResultsFin.Reset;
                ACAExamResultsFin.SetRange("Student No.",StudentUnits."Student No.");
                ACAExamResultsFin.SetRange(Programme,StudentUnits.Programme);
                ACAExamResultsFin.SetRange(Unit,StudentUnits.Unit);
                ACAExamResultsFin.SetRange(Semester,StudentUnits.Semester);
                ACAExamResultsFin.SetRange(ExamType,ExamResults.ExamType);
                if ACAExamResultsFin.Find('-') then begin
                  ACAExamResultsFin.CalcFields("Counted Occurances");
                  if ACAExamResultsFin."Counted Occurances">1 then begin
                      ACAExamResultsFin.Delete;
                    end;
                  end;
                end;
                until ExamResults.Next=0;
                end;
          ////////////////////////////////// Remove Multiple Occurances of a Mark

              //Get best CAT Marks
              StudentUnits."Unit not in Catalogue":=false;

              UnitsSubjects.Reset;
              UnitsSubjects.SetRange("Programme Code",StudentUnits.Programme);
              UnitsSubjects.SetRange(Code,StudentUnits.Unit);
              if UnitsSubjects.Find('-') then begin

                if UnitsSubjects."Default Exam Category"='' then UnitsSubjects."Default Exam Category":=Progyz."Exam Category";
                if UnitsSubjects."Exam Category"='' then UnitsSubjects."Exam Category":=Progyz."Exam Category";
                UnitsSubjects.Modify;
                ACA2NDExamClassificationUnits.Reset;
                ACA2NDExamClassificationUnits.SetRange("Student No.",Coregcs."Student No.");
                ACA2NDExamClassificationUnits.SetRange(Programme,Coregcs.Programme);
                ACA2NDExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
               // ACA2NDExamClassificationUnits.SETRANGE("Academic Year",StudentUnits."Academic Year");
                if not ACA2NDExamClassificationUnits.Find('-') then begin
                    ACA2NDExamClassificationUnits.Init;
                    ACA2NDExamClassificationUnits."Student No.":=Coregcs."Student No.";
                    ACA2NDExamClassificationUnits.Programme:=Coregcs.Programme;
                    ACA2NDExamClassificationUnits."Reporting Academic Year":=Coregcs."Academic Year";
                    ACA2NDExamClassificationUnits."School Code":=Progyz."School Code";
                    ACA2NDExamClassificationUnits."Unit Code":=StudentUnits.Unit;
                    ACA2NDExamClassificationUnits."Credit Hours":=UnitsSubjects."No. Units";
                    ACA2NDExamClassificationUnits."Unit Type":=Format(UnitsSubjects."Unit Type");
                    ACA2NDExamClassificationUnits."Unit Description":=UnitsSubjects.Desription;
                    ACA2NDExamClassificationUnits."Year of Study":=ACA2NDExamCourseRegistration."Year of Study";
                    ACA2NDExamClassificationUnits."Academic Year":=StudentUnits."Academic Year";

                        Clear(ExamResults); ExamResults.Reset;
                        ExamResults.SetRange("Student No.",StudentUnits."Student No.");
                        ExamResults.SetRange(Unit,StudentUnits.Unit);
                          if ExamResults.Find('-') then begin
                            ExamResults.CalcFields("Number of Repeats","Number of Resits");
                            if ExamResults."Number of Repeats">0 then
                            ACA2NDExamClassificationUnits."No. of Repeats":=ExamResults."Number of Repeats"-1;
                            if ExamResults."Number of Resits">0 then
                            ACA2NDExamClassificationUnits."No. of Resits":=ExamResults."Number of Resits"-1;
                            end;

              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",Coregcs."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,Coregcs.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",Coregcs."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",Coregcs."Year Of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                   if  ACA2NDExamClassificationUnits.Insert then ;
                  end;

                            /////////////////////////// Update Unit Score
                                Clear(ST1SuppExamClassificationUnits);
                            Clear(CUrrentExamScore);
                ACA2NDExamClassificationUnits.Reset;
                ACA2NDExamClassificationUnits.SetRange("Student No.",Coregcs."Student No.");
                ACA2NDExamClassificationUnits.SetRange(Programme,Coregcs.Programme);
                ACA2NDExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
                ACA2NDExamClassificationUnits.SetRange("Academic Year",Coregcs."Academic Year");
               // ACA2NDExamClassificationUnits.SETRANGE("Reporting Academic Year",GradAcademicYear);
                if ACA2NDExamClassificationUnits.Find('-') then begin
                           ACA2NDExamClassificationUnits.CalcFields("Is Supp. Unit");
                         Clear(ACAExamResults_Fin); ACAExamResults_Fin.Reset;
                         ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3|%4','EXAM','EXAM100','EXAMS','FINAL EXAM');
                         ACAExamResults_Fin.SetCurrentkey(Score);
                         if ACAExamResults_Fin.Find('+') then begin
                           if ACA2NDExamClassificationUnits."Is Supp. Unit" = false then begin
                          ACA2NDExamClassificationUnits."Exam Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                          ACA2NDExamClassificationUnits."Exam Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                         Clear(CUrrentExamScore);
                           CUrrentExamScore:= ACA2NDExamClassificationUnits."Exam Score Decimal";
                           end;
                           end;
                       //     END;
                       // If Exam Marks are not found, Check if Special Marks Exists
                      if CUrrentExamScore = 0 then begin
            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
            AcaSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Special);
                         AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
            if AcaSpecialExamsDetails.Find('-') then begin
                           if ACA2NDExamClassificationUnits."Is Supp. Unit" = false then begin
                          ACA2NDExamClassificationUnits."Exam Score":=Format(ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'='));
                          ACA2NDExamClassificationUnits."Exam Score Decimal":=ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'=');
                         Clear(CUrrentExamScore);
                           CUrrentExamScore:= AcaSpecialExamsDetails."Exam Marks";
                           end;
              end;
              end;

                       //   IF ACA2NDExamClassificationUnits."CAT Score"='' THEN BEGIN
                       Clear(OriginalCatScores);
                         Clear(ACAExamResults_Fin); ACAExamResults_Fin.Reset;
                         ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         ACAExamResults_Fin.SetCurrentkey(Score);
                         if ACAExamResults_Fin.Find('+') then begin
                           if ACA2NDExamClassificationUnits."Is Supp. Unit" = false then begin
                           OriginalCatScores:=ACAExamResults_Fin.Score;
                          ACA2NDExamClassificationUnits."CAT Score":=Format(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                          ACA2NDExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                         //  CUrrentExamScore:= CUrrentExamScore+ACA2NDExamClassificationUnits."CAT Score Decimal";
                         end;
                           end;
                          // END;
                                // Check if first Supp Marks Exists
                                Clear(ST1SuppExamClassificationUnits);
                                ST1SuppExamClassificationUnits.Reset;
                                ST1SuppExamClassificationUnits.SetRange("Student No.",StudentUnits."Student No.");
                                ST1SuppExamClassificationUnits.SetRange("Unit Code",StudentUnits.Unit);
                                ST1SuppExamClassificationUnits.SetRange("Academic Year",Coregcs."Academic Year");
                                ST1SuppExamClassificationUnits.SetFilter("Exam Score Decimal",'<>%1',0);
                                ST1SuppExamClassificationUnits.SetFilter("Is Supp. Unit",'%1',true);
                                if ST1SuppExamClassificationUnits.Find('-') then begin
                                  // First Supplementary Exists Hence Adopt the Scores
                                 ST1SuppExamClassificationUnits.CalcFields("Is Supp. Unit");
                                 if ST1SuppExamClassificationUnits."Is Supp. Unit" then begin
                          ACA2NDExamClassificationUnits."Exam Score":=ST1SuppExamClassificationUnits."Exam Score";
                          ACA2NDExamClassificationUnits."Exam Score Decimal":=ROUND(ST1SuppExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACA2NDExamClassificationUnits."CAT Score":=Format(OriginalCatScores);
                          ACA2NDExamClassificationUnits."CAT Score Decimal":=ROUND(OriginalCatScores,0.01,'=');
                          end else if ST1SuppExamClassificationUnits."Is Special Unit" then begin
                          ACA2NDExamClassificationUnits."Exam Score":=ST1SuppExamClassificationUnits."Exam Score";
                          ACA2NDExamClassificationUnits."Exam Score Decimal":=ROUND(ST1SuppExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACA2NDExamClassificationUnits."CAT Score":=Format(OriginalCatScores);
                          ACA2NDExamClassificationUnits."CAT Score Decimal":=ROUND(OriginalCatScores,0.01,'=');
                            end;
                                  end;
                        //Update Total Marks
                        if ST1SuppExamClassificationUnits."Is Supp. Unit" then begin
                        if ((ACA2NDExamClassificationUnits."Exam Score"='') and (ACA2NDExamClassificationUnits."CAT Score"='')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((ACA2NDExamClassificationUnits."Exam Score"='') and (ACA2NDExamClassificationUnits."CAT Score"<>'')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((ACA2NDExamClassificationUnits."Exam Score"<>'') and (ACA2NDExamClassificationUnits."CAT Score"='')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((ACA2NDExamClassificationUnits."Exam Score"<>'') and (ACA2NDExamClassificationUnits."CAT Score"<>'')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                         end;
                         end else begin
                        if ((ACA2NDExamClassificationUnits."Exam Score"='') and (ACA2NDExamClassificationUnits."CAT Score"='')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((ACA2NDExamClassificationUnits."Exam Score"='') and (ACA2NDExamClassificationUnits."CAT Score"<>'')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((ACA2NDExamClassificationUnits."Exam Score"<>'') and (ACA2NDExamClassificationUnits."CAT Score"='')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((ACA2NDExamClassificationUnits."Exam Score"<>'') and (ACA2NDExamClassificationUnits."CAT Score"<>'')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                         end;
                           end;


            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
            AcaSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
            AcaSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Supplementary);
                         AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
            if AcaSpecialExamsDetails.Find('-') then begin
              Clear(CUrrentExamScore);
              CUrrentExamScore:=AcaSpecialExamsDetails."Exam Marks";
              // If 1st Supp Exists, check if Second Supp is Registered and check if it has Marks
              //////////////////////////////////////////////////////////////////////

        // //                 CLEAR(Aca2ndSuppExamsResults);
        // //                 Aca2ndSuppExamsResults.RESET;
        // //                 Aca2ndSuppExamsResults.SETRANGE("Student No.",StudentUnits."Student No.");
        // //                 Aca2ndSuppExamsResults.SETRANGE(Unit,StudentUnits.Unit);
        // //                 Aca2ndSuppExamsResults.SETFILTER(Score,'<>%1',0);
        // //                 IF Aca2ndSuppExamsResults.FIND('-') THEN  BEGIN
        // //                 CLEAR(CUrrentExamScore);
        // //                   CUrrentExamScore:=Aca2ndSuppExamsResults.Score;
        // //
        // //                   END;    // OriginalCatScores

                            Clear(Aca2NDSpecialExamsDetails);
                            Aca2NDSpecialExamsDetails.Reset;
                            Aca2NDSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2NDSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
                            Aca2NDSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if Aca2NDSpecialExamsDetails.Find('-') then begin
                         Clear(CUrrentExamScore);
                           CUrrentExamScore:=Aca2NDSpecialExamsDetails."Exam Marks";
                              end;
              /////////////////////////////////////////////////////////////////////
           //   END;
              end else begin
                //
                end;
                ACA2NDExamClassificationUnits."Exam Score Decimal":=CUrrentExamScore;
                if CUrrentExamScore = 0 then
                ACA2NDExamClassificationUnits."Exam Score":=''
                else ACA2NDExamClassificationUnits."Exam Score":=Format(CUrrentExamScore);
                ACA2NDExamClassificationUnits."CAT Score Decimal" := OriginalCatScores;
                if OriginalCatScores = 0 then
                ACA2NDExamClassificationUnits."CAT Score":='' else
                ACA2NDExamClassificationUnits."CAT Score":=Format(OriginalCatScores);
                if AcaSpecialExamsDetails.Find('-') then begin
                 CUrrentExamScore:=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",CUrrentExamScore);
                ACA2NDExamClassificationUnits."Total Score":=Format(CUrrentExamScore);
                ACA2NDExamClassificationUnits."Total Score Decimal":=CUrrentExamScore;
                  end else begin
                    CUrrentExamScore+=OriginalCatScores;
                ACA2NDExamClassificationUnits."Total Score":=Format(CUrrentExamScore);
                ACA2NDExamClassificationUnits."Total Score Decimal":=CUrrentExamScore;
                    end;
            ACA2NDExamClassificationUnits."Weighted Total Score":=ROUND(ACA2NDExamClassificationUnits."Credit Hours"*ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'=');

                            Aca2NDSpecialExamsDetails.Reset;
                            Aca2NDSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2NDSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
                            if Aca2NDSpecialExamsDetails.Find('-') then begin
        // //                      CLEAR(Aca2ndSuppExamsResults);
        // //                 Aca2ndSuppExamsResults.RESET;
        // //                 Aca2ndSuppExamsResults.SETRANGE("Student No.",StudentUnits."Student No.");
        // //                 Aca2ndSuppExamsResults.SETRANGE(Unit,StudentUnits.Unit);
        // //                 Aca2ndSuppExamsResults.SETFILTER(Score,'<>%1',0);
        // //                 IF Aca2ndSuppExamsResults.FIND('-') THEN  BEGIN
        // //                   Aca2NDSpecialExamsDetails."Exam Marks":=Aca2ndSuppExamsResults.Score;
        // //                   Aca2NDSpecialExamsDetails.MODIFY;
        // //                   END;
                              if  Aca2NDSpecialExamsDetails."Exam Marks" <>0 then begin
                              // Create A Supp Results Registration and Alter the Exam Marks Here
                              ACAExam2NDSuppUnits.Init;
                              ACAExam2NDSuppUnits."Student No.":=StudentUnits."Student No.";
                              ACAExam2NDSuppUnits."Unit Code":=ACA2NDExamClassificationUnits."Unit Code";
                              ACAExam2NDSuppUnits."Unit Description":=ACA2NDExamClassificationUnits."Unit Description";
                              ACAExam2NDSuppUnits."Unit Type":=ACA2NDExamClassificationUnits."Unit Type";
                              ACAExam2NDSuppUnits.Programme:=ACA2NDExamClassificationUnits.Programme;
                              ACAExam2NDSuppUnits."Academic Year":=ACA2NDExamClassificationUnits."Academic Year";
                              ACAExam2NDSuppUnits."Credit Hours":=ACA2NDExamClassificationUnits."Credit Hours";
                              ACAExam2NDSuppUnits."Exam Score":=Format(ROUND(Aca2NDSpecialExamsDetails."Exam Marks",0.01,'='));
                              ACAExam2NDSuppUnits."Exam Score Decimal":=ROUND(((Aca2NDSpecialExamsDetails."Exam Marks")),0.01,'=');
        // //                        Commented todat 10/10/2022
                           ACAExam2NDSuppUnits."CAT Score":=Format(ROUND(OriginalCatScores,0.01,'='));
                           ACAExam2NDSuppUnits."CAT Score Decimal":=ROUND(OriginalCatScores,0.01,'=');
                              if Aca2NDSpecialExamsDetails.Category = Aca2NDSpecialExamsDetails.Category::Supplementary then begin
                               ACAExam2NDSuppUnits."Total Score Decimal":=Aca2NDSpecialExamsDetails."Exam Marks";
                               ACAExam2NDSuppUnits."Total Score Decimal":=GetSupp2MaxScore(Aca2NDSpecialExamsDetails,Progyz."Exam Category",ACAExam2NDSuppUnits."Total Score Decimal");
                              ACAExam2NDSuppUnits."Total Score":=Format(ACAExam2NDSuppUnits."Total Score Decimal");
                          ACA2NDExamClassificationUnits."Total Score":=Format(Aca2NDSpecialExamsDetails."Exam Marks");
                          ACA2NDExamClassificationUnits."Total Score Decimal":=Aca2NDSpecialExamsDetails."Exam Marks";
                          ACA2NDExamClassificationUnits."Weighted Total Score":=ROUND(ACA2NDExamClassificationUnits."Credit Hours"*ACAExam2NDSuppUnits."Total Score Decimal",0.01,'=');
                                end else if Aca2NDSpecialExamsDetails.Category = Aca2NDSpecialExamsDetails.Category::Special then begin
                               ACAExam2NDSuppUnits."Total Score Decimal":=Aca2NDSpecialExamsDetails."Exam Marks"+OriginalCatScores;
                              ACAExam2NDSuppUnits."Total Score":=Format(ACAExam2NDSuppUnits."Total Score Decimal");
                          ACA2NDExamClassificationUnits."Total Score":=Format(Aca2NDSpecialExamsDetails."Exam Marks"+OriginalCatScores);
                          ACA2NDExamClassificationUnits."Total Score Decimal":=Aca2NDSpecialExamsDetails."Exam Marks"+OriginalCatScores;
                          ACA2NDExamClassificationUnits."Weighted Total Score":=ROUND(ACA2NDExamClassificationUnits."Credit Hours"*ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'=');
                              end;
                              ACAExam2NDSuppUnits."Exam Category":=ACA2NDExamClassificationUnits."Exam Category";
                           //   ACAExam2NDSuppUnits."CAT Score Decimal":=ROUND(ACA2NDExamClassificationUnits."CAT Score Decimal",0.01,'=');
                              ACAExam2NDSuppUnits."Allow In Graduate":=true;
                              ACAExam2NDSuppUnits."Year of Study":=ACA2NDExamClassificationUnits."Year of Study";
                              ACAExam2NDSuppUnits.Cohort:=ACA2NDExamClassificationUnits.Cohort;
                              ACAExam2NDSuppUnits."School Code":=ACA2NDExamClassificationUnits."School Code";
                              ACAExam2NDSuppUnits."Department Code":=ACA2NDExamClassificationUnits."Department Code";
              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",Coregcs."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,Coregcs.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",Coregcs."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",Coregcs."Year Of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                              if ACAExam2NDSuppUnits.Insert then;
                                // Update the Course Unit Scores
                                ObjExamResult.Reset;
                         ObjExamResult.SetRange("Student No.",StudentUnits."Student No.");
                         ObjExamResult.SetRange(Unit,StudentUnits.Unit);
                         ObjExamResult.SetRange(Semester,StudentUnits.Semester);
                         ObjExamResult.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         CatResultsExist:=ObjExamResult.FindFirst;
                         if CatResultsExist and (ACA2NDExamClassificationUnits."Total Score Decimal"<>0) then
                           ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                          ACA2NDExamClassificationUnits.Modify;
                                          //Update Total Marks
                        if ((((ACA2NDExamClassificationUnits."Exam Score"='') or (ACA2NDExamClassificationUnits."Exam Score"='0'))) and (ACA2NDExamClassificationUnits."CAT Score"='')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((((ACA2NDExamClassificationUnits."Exam Score"='') or (ACA2NDExamClassificationUnits."Exam Score"='0'))) and (ACA2NDExamClassificationUnits."CAT Score"<>'')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((((ACA2NDExamClassificationUnits."Exam Score"<>'') and (ACA2NDExamClassificationUnits."Exam Score"<>'0'))) and (ACA2NDExamClassificationUnits."CAT Score"='')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((((ACA2NDExamClassificationUnits."Exam Score"<>'') and (ACA2NDExamClassificationUnits."Exam Score"<>'0'))) and (ACA2NDExamClassificationUnits."CAT Score"<>'')) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                         end;
        // // // // // // // Commented Today 10/10/2022
                                ObjExamResult.Reset;
                         ObjExamResult.SetRange("Student No.",StudentUnits."Student No.");
                         ObjExamResult.SetRange(Unit,StudentUnits.Unit);
                         ObjExamResult.SetRange(Semester,StudentUnits.Semester);
                         ObjExamResult.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         CatResultsExist:=ObjExamResult.FindFirst;
                         if CatResultsExist and (ACA2NDExamClassificationUnits."Total Score Decimal"<>0) then
                           ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                            ACA2NDExamClassificationUnits.Modify;
                                end else begin
                                  end;
                              end;
                              ACA2NDExamClassificationUnits."Allow In Graduate":=true;
                              /// Update Cummulative Resit
                              ACA2NDExamClassificationUnits.CalcFields(Grade,"Grade Comment","Comsolidated Prefix",Pass);
                              if ACA2NDExamClassificationUnits.Pass=false then begin
                                // Check if Failed in 1st Supp
                                Clear(ST1SuppExamClassificationUnits);
                                ST1SuppExamClassificationUnits.Reset;
                                ST1SuppExamClassificationUnits.SetRange("Student No.",StudentUnits."Student No.");
                                ST1SuppExamClassificationUnits.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                                ST1SuppExamClassificationUnits.SetRange("Academic Year",ACA2NDExamClassificationUnits."Academic Year");
                                ST1SuppExamClassificationUnits.SetRange(Pass,false);
                                if ST1SuppExamClassificationUnits.Find('-') then begin

                ACA2NDExamCummulativeResit.Reset;
                ACA2NDExamCummulativeResit.SetRange("Student Number",StudentUnits."Student No.");
                ACA2NDExamCummulativeResit.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                ACA2NDExamCummulativeResit.SetRange("Academic Year",Coregcs."Academic Year");
                if ACA2NDExamCummulativeResit.Find('-') then ACA2NDExamCummulativeResit.DeleteAll;

                    //Register a Supplementary for the Current Academic Year
                            Aca2NDSpecialExamsDetails.Reset;
                            Aca2NDSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2NDSpecialExamsDetails.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2NDSpecialExamsDetails.SetRange("Academic Year",Coregcs."Academic Year");
                           // Aca2NDSpecialExamsDetails.SETRANGE("Current Academic Year",GetFinalAcademicYear(StudentUnits."Student No.",StudentUnits.Programme));
                            if not (Aca2NDSpecialExamsDetails.Find('-')) then begin
                               // The Failed Unit is not in Supp Special, Register The Unit here
                              Clear(CountedSeq);
                               Aca2NDSpecialExamsDetails3.Reset;
                            Aca2NDSpecialExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2NDSpecialExamsDetails3.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2NDSpecialExamsDetails3.SetCurrentkey(Sequence);
                            if Aca2NDSpecialExamsDetails3.Find('+') then begin
                              CountedSeq:=Aca2NDSpecialExamsDetails3.Sequence;
                              end else begin
                              CountedSeq:=1;
                                end;
                              Aca2NDSpecialExamsDetails.Init;
                              Aca2NDSpecialExamsDetails.Stage:=StudentUnits.Stage;
                              Aca2NDSpecialExamsDetails.Status:=Aca2NDSpecialExamsDetails.Status::New;
                              Aca2NDSpecialExamsDetails."Student No.":=StudentUnits."Student No.";
                              Aca2NDSpecialExamsDetails."Academic Year":=Coregcs."Academic Year";
                              Aca2NDSpecialExamsDetails."Unit Code":=StudentUnits.Unit;
                              Aca2NDSpecialExamsDetails.Semester:=StudentUnits.Semester;
                              Aca2NDSpecialExamsDetails.Sequence:=CountedSeq;
                              Aca2NDSpecialExamsDetails."Current Academic Year":=GetFinalAcademicYear(StudentUnits."Student No.",StudentUnits.Programme);
                              Aca2NDSpecialExamsDetails.Category:=Aca2NDSpecialExamsDetails.Category::Supplementary;
                              Aca2NDSpecialExamsDetails.Programme:=StudentUnits.Programme;
            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
            AcaSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
            if AcaSpecialExamsDetails.Find('-') then
              AcaSpecialExamsDetails."Exam Marks":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
            if ((AcaSpecialExamsDetails."Exam Marks"<GetSupp2MaxScore(Aca2NDSpecialExamsDetails,Progyz."Exam Category",
              ACAExam2NDSuppUnits."Total Score Decimal"))) then begin

              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",Coregcs."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,Coregcs.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",Coregcs."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",Coregcs."Year Of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                            if  Aca2NDSpecialExamsDetails.Insert then;
                            end;
                              end;
                              //Check if Passed 1st Supp or Marks are missing, then delete from 2nd Supp
                            ST1SuppExamClassificationUnits.Reset;
                            ST1SuppExamClassificationUnits.SetRange("Student No.",StudentUnits."Student No.");
                            ST1SuppExamClassificationUnits.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            ST1SuppExamClassificationUnits.SetRange("Academic Year",ACA2NDExamClassificationUnits."Academic Year");
                            ST1SuppExamClassificationUnits.SetRange(Pass,true);
                            if ST1SuppExamClassificationUnits.Find('-') then begin
                              // Delete from the Supp Registration
                            Aca2NDSpecialExamsDetails.Reset;
                            Aca2NDSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2NDSpecialExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            Aca2NDSpecialExamsDetails.SetRange("Unit Code",StudentUnits.Unit);
                            Aca2NDSpecialExamsDetails.SetFilter("Exam Marks",'%1',0);
                            if Aca2NDSpecialExamsDetails.Find('-') then begin
                                Aca2NDSpecialExamsDetails.DeleteAll;
                              end;
                              end;

                 begin
                    ACA2NDExamCummulativeResit.Init;
                    ACA2NDExamCummulativeResit."Student Number":=StudentUnits."Student No.";
                    ACA2NDExamCummulativeResit."School Code":=ACA2NDExamClassificationStuds."School Code";
                    ACA2NDExamCummulativeResit."Academic Year":=StudentUnits."Academic Year";
                    ACA2NDExamCummulativeResit."Unit Code":=ACA2NDExamClassificationUnits."Unit Code";
                    ACA2NDExamCummulativeResit."Student Name":=ACA2NDExamClassificationStuds."Student Name";
                    ACA2NDExamCummulativeResit.Programme:=StudentUnits.Programme;
                    ACA2NDExamCummulativeResit."School Name":=ACA2NDExamClassificationStuds."School Name";
                    ACA2NDExamCummulativeResit."Unit Description":=UnitsSubjects.Desription;
                    ACA2NDExamCummulativeResit."Credit Hours":=UnitsSubjects."No. Units";
                      ACA2NDExamCummulativeResit."Unit Type":=ACA2NDExamClassificationUnits."Unit Type";
                    ACA2NDExamCummulativeResit.Score:=ROUND(ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'=');
                    ACA2NDExamCummulativeResit.Grade:=ACA2NDExamClassificationUnits.Grade;

              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",Coregcs."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,Coregcs.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",Coregcs."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",Coregcs."Year Of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                    if ACA2NDExamCummulativeResit.Insert then;
                    end;
                  end;
                    //.....................................................................................................................
                    end;
                                            ObjExamResult.Reset;
                         ObjExamResult.SetRange("Student No.",ACA2NDExamClassificationUnits."Student No.");
                         ObjExamResult.SetRange(Unit,ACA2NDExamClassificationUnits."Unit Code");
                        // ObjExamResult.SETRANGE(Semester,StudentUnits.Semester);
                         ObjExamResult.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         CatResultsExist:=ObjExamResult.Find('-');
                         if CatResultsExist and (ACA2NDExamClassificationUnits."Total Score Decimal"<>0) then
                           ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                            if ACA2NDExamClassificationUnits.Modify then;
                                                //////////////////////////// Update Units Scores.. End
                end else begin
                  StudentUnits."Unit not in Catalogue":=true;
                  end;
                  end;
          StudentUnits.Modify;
                ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii End of Finalize Units
        end;

            until StudentUnits.Next=0;
          end;

        end;
        until Coregcs.Next=0;
            Progressbar.Close;
        end;

        //Update Senate Header

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //......................................................................................Compute Averages Here
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////


        // Update Averages
        Clear(TotalRecs);
        Clear(CountedRecs);
        Clear(RemeiningRecs);
        Clear(ACA2NDExamClassificationStuds);
        ACA2NDExamCourseRegistration.Reset;
         ACA2NDExamCourseRegistration.SetFilter("Reporting Academic Year",AcadYear);
        if StudNos<>'' then
        ACA2NDExamCourseRegistration.SetFilter("Student Number",StudNos) else
        ACA2NDExamCourseRegistration.SetFilter(Programme,ProgFIls);// Only Apply Prog & School if Student FIlter is not Applied
        if ACA2NDExamCourseRegistration.Find('-') then begin
          TotalRecs:=ACA2NDExamCourseRegistration.Count;
          RemeiningRecs:=TotalRecs;
          ProgBar2.Open('#1#####################################################\'+
          '#2############################################################\'+
          '#3###########################################################\'+
          '#4############################################################\'+
          '#5###########################################################\'+
          '#6############################################################');
             ProgBar2.Update(1,'3 of 3 Updating Class Items');
             ProgBar2.Update(2,'Total Recs.: '+Format(TotalRecs));
            repeat
              begin

              Progyz.Reset;
              Progyz.SetRange(Code,ACA2NDExamCourseRegistration.Programme);
              if Progyz.Find('-') then;
              CountedRecs+=1;
              RemeiningRecs-=1;
             ProgBar2.Update(3,'.....................................................');
             ProgBar2.Update(4,'Processed: '+Format(CountedRecs));
             ProgBar2.Update(5,'Remaining: '+Format(RemeiningRecs));
             ProgBar2.Update(6,'----------------------------------------------------');
                    ACA2NDExamCourseRegistration.CalcFields("Total Marks","Total Courses","Total Weighted Marks",
                  "Total Units","Classified Total Marks","Total Classified C. Count","Classified W. Total","Attained Stage Units",Average,"Weighted Average");
                  ACA2NDExamCourseRegistration."Normal Average":=ROUND((ACA2NDExamCourseRegistration.Average),0.01,'=');
                  if ACA2NDExamCourseRegistration."Total Units">0 then
                  ACA2NDExamCourseRegistration."Weighted Average":=ROUND((ACA2NDExamCourseRegistration."Total Weighted Marks"/ACA2NDExamCourseRegistration."Total Units"),0.01,'=');
                  if ACA2NDExamCourseRegistration."Total Classified C. Count"<>0 then
                  ACA2NDExamCourseRegistration."Classified Average":=ROUND((ACA2NDExamCourseRegistration."Classified Total Marks"/ACA2NDExamCourseRegistration."Total Classified C. Count"),0.01,'=');
                  if ACA2NDExamCourseRegistration."Total Classified Units"<>0 then
                  ACA2NDExamCourseRegistration."Classified W. Average":=ROUND((ACA2NDExamCourseRegistration."Classified W. Total"/ACA2NDExamCourseRegistration."Total Classified Units"),0.01,'=');
                  ACA2NDExamCourseRegistration.CalcFields("Defined Units (Flow)");
                  ACA2NDExamCourseRegistration."Required Stage Units":=ACA2NDExamCourseRegistration."Defined Units (Flow)";//RequiredStageUnits(ACA2NDExamCourseRegistration.Programme,
                  //ACA2NDExamCourseRegistration."Year of Study",ACA2NDExamCourseRegistration."Student Number");
                  if ACA2NDExamCourseRegistration."Required Stage Units">ACA2NDExamCourseRegistration."Attained Stage Units" then
                  ACA2NDExamCourseRegistration."Units Deficit":=ACA2NDExamCourseRegistration."Required Stage Units"-ACA2NDExamCourseRegistration."Attained Stage Units";
                  ACA2NDExamCourseRegistration."Multiple Programe Reg. Exists":=GetMultipleProgramExists(ACA2NDExamCourseRegistration."Student Number",ACA2NDExamCourseRegistration."Academic Year");

                   ACA2NDExamCourseRegistration."Final Classification":=GetRubricSupp2(Progyz,ACA2NDExamCourseRegistration);
                   if Coregcs."Stopage Yearly Remark"<>'' then
                   ACA2NDExamCourseRegistration."Final Classification":=Coregcs."Stopage Yearly Remark";
                   ACA2NDExamCourseRegistration."Final Classification Pass":=Get2ndSuppRubricPassStatus(ACA2NDExamCourseRegistration."Final Classification",
                   ACA2NDExamCourseRegistration."Academic Year",Progyz);
                   ACA2NDExamCourseRegistration."Final Classification Order":=Get2ndSuppRubricOrder(ACA2NDExamCourseRegistration."Final Classification");
                   ACA2NDExamCourseRegistration."Final Classification Pass":=GetRubricPassStatus(ACA2NDExamCourseRegistration."Final Classification",
                   ACA2NDExamCourseRegistration."Academic Year",Progyz);
                   ACA2NDExamCourseRegistration.Classification:=ACA2NDExamCourseRegistration."Final Classification";
                     if ACA2NDExamCourseRegistration."Total Courses"=0 then begin
                 //  ACA2NDExamCourseRegistration."Final Classification":='HALT';
                   ACA2NDExamCourseRegistration."Final Classification Pass":=false;
                   ACA2NDExamCourseRegistration."Final Classification Order":=10;
                   ACA2NDExamCourseRegistration.Graduating:=false;
                 //  ACA2NDExamCourseRegistration.Classification:='HALT';
                       end;
                   if Coregcs."Stopage Yearly Remark"<>'' then
                     ACA2NDExamCourseRegistration.Classification:=Coregcs."Stopage Yearly Remark";
                     ACA2NDExamCourseRegistration.CalcFields("Total Marks",
        "Total Weighted Marks",
        "Total Failed Courses",
        "Total Failed Units",
        "Failed Courses",
        "Failed Units",
        "Failed Cores",
        "Failed Required",
        "Failed Electives",
        "Total Cores Done",
        "Total Cores Passed",
        "Total Required Done",
        "Total Electives Done",
        "Tota Electives Passed");
        ACA2NDExamCourseRegistration.CalcFields(
        "Classified Electives C. Count",
        "Classified Electives Units",
        "Total Classified C. Count",
        "Total Classified Units",
        "Classified Total Marks",
        "Classified W. Total",
        "Total Failed Core Units");
                  ACA2NDExamCourseRegistration."Cummulative Fails":=GetCummulativeFails(ACA2NDExamCourseRegistration."Student Number",ACA2NDExamCourseRegistration."Year of Study");
                  ACA2NDExamCourseRegistration."Cumm. Required Stage Units":=GetCummulativeReqStageUnitrs(ACA2NDExamCourseRegistration.Programme,ACA2NDExamCourseRegistration."Year of Study",ACA2NDExamCourseRegistration."Programme Option",
                  ACA2NDExamCourseRegistration."Academic Year");
                  ACA2NDExamCourseRegistration."Cumm Attained Units":=GetCummAttainedUnits(ACA2NDExamCourseRegistration."Student Number",ACA2NDExamCourseRegistration."Year of Study",ACA2NDExamCourseRegistration.Programme);
                   ACA2NDExamCourseRegistration.Modify;

                      end;
                      until ACA2NDExamCourseRegistration.Next=0;
          ProgBar2.Close;
                  end;

                    ACA2NDSenateReportsHeader.Reset;
                    ACA2NDSenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                    ACA2NDSenateReportsHeader.SetFilter("Reporting Academic Year",Coregcs."Academic Year");
                    if ACA2NDSenateReportsHeader.Find('-') then begin
                      ProgBar22.Open('#1##########################################');
                      repeat
                          begin
                          ProgBar22.Update(1,'Student Number: '+ACA2NDSenateReportsHeader."Programme Code"+' Class: '+ACA2NDSenateReportsHeader."Classification Code");
                          with ACA2NDSenateReportsHeader do
                            begin
                              ACA2NDSenateReportsHeader.CalcFields("School Classification Count","School Total Passed","School Total Passed",
                              "School Total Failed","Programme Classification Count","Programme Total Passed","Programme Total Failed","School Total Count",
                              "Prog. Total Count");

                              CalcFields("School Classification Count","School Total Passed","School Total Failed","School Total Count",
                              "Programme Classification Count","Prog. Total Count","Programme Total Failed","Programme Total Passed");
                              if "School Total Count">0 then
                              "Sch. Class % Value":=ROUND((("School Classification Count"/"School Total Count")*100),0.01,'=');
                              if "School Total Count">0 then
                              "School % Failed":=ROUND((("School Total Failed"/"School Total Count")*100),0.01,'=');
                              if "School Total Count">0 then
                              "School % Passed":=ROUND((("School Total Passed"/"School Total Count")*100),0.01,'=');
                              if "Prog. Total Count">0 then
                              "Prog. Class % Value":=ROUND((("Programme Classification Count"/"Prog. Total Count")*100),0.01,'=');
                              if "Prog. Total Count">0 then
                              "Programme % Failed":=ROUND((("Programme Total Failed"/"Prog. Total Count")*100),0.01,'=');
                              if "Prog. Total Count">0 then
                              "Programme % Passed":=ROUND((("Programme Total Passed"/"Prog. Total Count")*100),0.01,'=');
                              end;
                              ACA2NDSenateReportsHeader.Modify;
                          end;
                        until ACA2NDSenateReportsHeader.Next=0;
                        ProgBar22.Close;
                        end;


        end;
        until ProgForFilters.Next  = 0;
          end;
    end;

    local procedure GetRubricSupp2(ACAProgramme: Record UnknownRecord61511;CoursesRegz: Record UnknownRecord66682) StatusRemarks: Text[150]
    var
        Customer: Record UnknownRecord61532;
        LubricIdentified: Boolean;
        ACAResultsStatus: Record UnknownRecord69267;
        YearlyReMarks: Text[250];
        StudCoregcs2: Record UnknownRecord61532;
        StudCoregcs24: Record UnknownRecord61532;
        Customersz: Record Customer;
        ACARegStoppageReasons: Record UnknownRecord66620;
        AcaSpecialExamsDetails: Record UnknownRecord78002;
        StudCoregcs: Record UnknownRecord61532;
    begin
        /*CLEAR(StatusRemarks);
        CLEAR(YearlyReMarks);
              Customer.RESET;
              Customer.SETRANGE("Student No.",CoursesRegz."Student Number");
              Customer.SETRANGE("Academic Year",CoursesRegz."Academic Year");
              IF Customer.FIND('-') THEN BEGIN
                IF ((Customer.Status=Customer.Status::Registration) OR (Customer.Status=Customer.Status::Current)) THEN BEGIN
          CLEAR(LubricIdentified);
                  CoursesRegz.CALCFIELDS("Attained Stage Units","Failed Cores","Failed Courses","Failed Electives","Failed Required","Failed Units",
                  "Total Failed Units","Total Marks","Total Required Done",
                  "Total Required Passed","Total Units","Total Weighted Marks");
                  CoursesRegz.CALCFIELDS("Total Cores Done","Total Cores Passed","Total Courses","Total Electives Done","Total Failed Courses",
                  "Tota Electives Passed","Total Classified C. Count","Total Classified Units","Total Classified Units");
        // // // //          IF CoursesRegz."Units Deficit">0 THEN BEGIN
        // // // //            CoursesRegz."Failed Cores":=CoursesRegz."Failed Cores"+CoursesRegz."Units Deficit";
        // // // //            CoursesRegz."Failed Courses":=CoursesRegz."Failed Courses"+CoursesRegz."Units Deficit";
        // // // //            CoursesRegz."Total Failed Courses":=CoursesRegz."Total Failed Courses"+CoursesRegz."Units Deficit";
        // // // //            CoursesRegz."Total Courses":=CoursesRegz."Total Courses"+CoursesRegz."Units Deficit";
        // // // //            END;
                  IF CoursesRegz."Total Courses">0 THEN
                    CoursesRegz."% Failed Courses":=(CoursesRegz."Failed Courses"/CoursesRegz."Total Courses")*100;
                  CoursesRegz."% Failed Courses":=ROUND(CoursesRegz."% Failed Courses",0.01,'=');
                  IF CoursesRegz."% Failed Courses">100 THEN CoursesRegz."% Failed Courses":=100;
                  IF CoursesRegz."Total Cores Done">0 THEN
                    CoursesRegz."% Failed Cores":=((CoursesRegz."Failed Cores"/CoursesRegz."Total Cores Done")*100);
                  CoursesRegz."% Failed Cores":=ROUND(CoursesRegz."% Failed Cores",0.01,'=');
                  IF CoursesRegz."% Failed Cores">100 THEN CoursesRegz."% Failed Cores":=100;
                  IF CoursesRegz."Total Units">0 THEN
                    CoursesRegz."% Failed Units":=(CoursesRegz."Failed Units"/CoursesRegz."Total Units")*100;
                  CoursesRegz."% Failed Units":=ROUND(CoursesRegz."% Failed Units",0.01,'=');
                  IF CoursesRegz."% Failed Units">100 THEN CoursesRegz."% Failed Units":=100;
                  IF CoursesRegz."Total Electives Done">0 THEN
                    CoursesRegz."% Failed Electives":=(CoursesRegz."Failed Electives"/CoursesRegz."Total Electives Done")*100;
                  CoursesRegz."% Failed Electives":=ROUND(CoursesRegz."% Failed Electives",0.01,'=');
                  IF CoursesRegz."% Failed Electives">100 THEN CoursesRegz."% Failed Electives":=100;
                            CoursesRegz.MODIFY;
        ACAResultsStatus.RESET;
        ACAResultsStatus.SETFILTER("Manual Status Processing",'%1',FALSE);
        ACAResultsStatus.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SETRANGE("Special Programme Class",ACAProgramme."Special Programme Class");
        // ACAResultsStatus.SETFILTER("Min. Unit Repeat Counts",'=%1|<%2',CoursesRegz."Highest Yearly Repeats",CoursesRegz."Highest Yearly Repeats");
        // ACAResultsStatus.SETFILTER("Max. Unit Repeat Counts",'=%1|>%2',CoursesRegz."Highest Yearly Repeats",CoursesRegz."Highest Yearly Repeats");
        // ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."Yearly Failed Units %",CoursesRegz."Yearly Failed Units %");
        // ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."Yearly Failed Units %",CoursesRegz."Yearly Failed Units %");
        IF ACAProgramme."Special Programme Class"=ACAProgramme."Special Programme Class"::"Medicine & Nursing" THEN BEGIN
          IF CoursesRegz."% Failed Cores">0 THEN BEGIN
         ACAResultsStatus.SETFILTER("Minimum Core Fails",'=%1|<%2',CoursesRegz."% Failed Cores",CoursesRegz."% Failed Cores");
         ACAResultsStatus.SETFILTER("Maximum Core Fails",'=%1|>%2',CoursesRegz."% Failed Cores",CoursesRegz."% Failed Cores");
         END ELSE BEGIN
          ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."Failed Courses",CoursesRegz."Failed Courses");
          ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."Failed Courses",CoursesRegz."Failed Courses");
         END;
        //  ACAResultsStatus.SETFILTER("Minimum None-Core Fails",'=%1|<%2',CoursesRegz."Failed Required",CoursesRegz."Failed Required");
        // ACAResultsStatus.SETFILTER("Maximum None-Core Fails",'=%1|>%2',CoursesRegz."Failed Required",CoursesRegz."Failed Required");
        END ELSE BEGIN
          ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Courses",CoursesRegz."% Failed Courses");
          ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Courses",CoursesRegz."% Failed Courses");
        END;
        // // // // // ELSE BEGIN
        // // // // // ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',YearlyFailedUnits,YearlyFailedUnits);
        // // // // // ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',YearlyFailedUnits,YearlyFailedUnits);
        // // // // //  END;
        ACAResultsStatus.SETCURRENTKEY("Order No");
        IF ACAResultsStatus.FIND('-') THEN BEGIN
          REPEAT
          BEGIN
              StatusRemarks:=ACAResultsStatus.Code;
              IF ACAResultsStatus."Lead Status"<>'' THEN
              StatusRemarks:=ACAResultsStatus."Lead Status";
              YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
              LubricIdentified:=TRUE;
          END;
          UNTIL ((ACAResultsStatus.NEXT=0) OR (LubricIdentified=TRUE))
        END;
        CoursesRegz.CALCFIELDS("Supp Exists","Attained Stage Units","Special Exists");
        //IF CoursesRegz."Supp/Special Exists" THEN  StatusRemarks:='SPECIAL';
        //IF CoursesRegz."Units Deficit">0 THEN StatusRemarks:='DTSC';
        //IF CoursesRegz."Required Stage Units">CoursesRegz."Attained Stage Units" THEN StatusRemarks:='DTSC';
        //IF CoursesRegz."Exists DTSC Prefix" THEN StatusRemarks:='DTSC';
        //IF CoursesRegz."Special Exists" THEN StatusRemarks:='SPECIAL';
        IF CoursesRegz."Exists Failed 2nd Supp" THEN  StatusRemarks:='RETAKE';
                  END ELSE BEGIN
        
        ACAResultsStatus.RESET;
        ACAResultsStatus.SETRANGE(Status,Customer.Status);
        ACAResultsStatus.SETRANGE("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SETRANGE("Special Programme Class",ACAProgramme."Special Programme Class");
        IF ACAResultsStatus.FIND('-') THEN BEGIN
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        END ELSE BEGIN
          StatusRemarks:=UPPERCASE(FORMAT(Customer.Status));
          YearlyReMarks:=StatusRemarks;
          END;
                    END;
                END;
        */
        
        Clear(StatusRemarks);
        Clear(YearlyReMarks);
              Customer.Reset;
              Customer.SetRange("Student No.",CoursesRegz."Student Number");
              Customer.SetRange("Academic Year",CoursesRegz."Academic Year");
              if Customer.Find('+') then  begin
                if ((Customer.Status=Customer.Status::Registration) or (Customer.Status=Customer.Status::Current)) then begin
          Clear(LubricIdentified);
                  CoursesRegz.CalcFields("Attained Stage Units","Failed Cores","Failed Courses","Failed Electives","Failed Required","Failed Units",
                  "Total Failed Units","Total Marks","Total Required Done",
                  "Total Required Passed","Total Units","Total Weighted Marks","Exists DTSC Prefix");
                  CoursesRegz.CalcFields("Total Cores Done","Total Cores Passed","Total Courses","Total Electives Done","Total Failed Courses",
                  "Tota Electives Passed","Total Classified C. Count","Total Classified Units","Total Classified Units");
                  if CoursesRegz."Total Courses">0 then
                    CoursesRegz."% Failed Courses":=(CoursesRegz."Failed Courses"/CoursesRegz."Total Courses")*100;
                  CoursesRegz."% Failed Courses":=ROUND(CoursesRegz."% Failed Courses",0.01,'>');
                  if CoursesRegz."% Failed Courses">100 then CoursesRegz."% Failed Courses":=100;
                  if CoursesRegz."Total Cores Done">0 then
                    CoursesRegz."% Failed Cores":=((CoursesRegz."Failed Cores"/CoursesRegz."Total Cores Done")*100);
                  CoursesRegz."% Failed Cores":=ROUND(CoursesRegz."% Failed Cores",0.01,'>');
                  if CoursesRegz."% Failed Cores">100 then CoursesRegz."% Failed Cores":=100;
                  if CoursesRegz."Total Units">0 then
                    CoursesRegz."% Failed Units":=(CoursesRegz."Failed Units"/CoursesRegz."Total Units")*100;
                  CoursesRegz."% Failed Units":=ROUND(CoursesRegz."% Failed Units",0.01,'>');
                  if CoursesRegz."% Failed Units">100 then CoursesRegz."% Failed Units":=100;
                  if CoursesRegz."Total Electives Done">0 then
                    CoursesRegz."% Failed Electives":=(CoursesRegz."Failed Electives"/CoursesRegz."Total Electives Done")*100;
                  CoursesRegz."% Failed Electives":=ROUND(CoursesRegz."% Failed Electives",0.01,'>');
                  if CoursesRegz."% Failed Electives">100 then CoursesRegz."% Failed Electives":=100;
                           // CoursesRegz.MODIFY;
                     if CoursesRegz."Student Number" = 'P101/2243G/22' then
        ACAResultsStatus.Reset;
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        //ACAResultsStatus.SETRANGE("Special Programme Class",ACAProgramme."Special Programme Class");
        // ACAResultsStatus.SETFILTER("Min. Unit Repeat Counts",'=%1|<%2',CoursesRegz."Highest Yearly Repeats",CoursesRegz."Highest Yearly Repeats");
        // ACAResultsStatus.SETFILTER("Max. Unit Repeat Counts",'=%1|>%2',CoursesRegz."Highest Yearly Repeats",CoursesRegz."Highest Yearly Repeats");
        // ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."Yearly Failed Units %",CoursesRegz."Yearly Failed Units %");
        // ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."Yearly Failed Units %",CoursesRegz."Yearly Failed Units %");
        if ACAProgramme."Special Programme Class"=ACAProgramme."special programme class"::"Medicine & Nursing" then begin
        // // // // // // //  IF CoursesRegz."% Failed Cores">0 THEN BEGIN
        // // // // // // // ACAResultsStatus.SETFILTER("Minimum Core Fails",'=%1|<%2',CoursesRegz."% Failed Cores",CoursesRegz."% Failed Cores");
        // // // // // // // ACAResultsStatus.SETFILTER("Maximum Core Fails",'=%1|>%2',CoursesRegz."% Failed Cores",CoursesRegz."% Failed Cores");
        // // // // // // // END ELSE BEGIN
        // // // // // // //  ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',CoursesRegz."Failed Courses",CoursesRegz."Failed Courses");
        // // // // // // //  ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',CoursesRegz."Failed Courses",CoursesRegz."Failed Courses");
        // // // // // // // END;
        //  ACAResultsStatus.SETFILTER("Minimum None-Core Fails",'=%1|<%2',CoursesRegz."Failed Required",CoursesRegz."Failed Required");
        // ACAResultsStatus.SETFILTER("Maximum None-Core Fails",'=%1|>%2',CoursesRegz."Failed Required",CoursesRegz."Failed Required");
        ACAResultsStatus.SetFilter("Special Programme Class",'=%1',ACAResultsStatus."special programme class"::"Medicine & Nursing");
        end else begin
          ACAResultsStatus.SetFilter("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
          ACAResultsStatus.SetFilter("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
        end;
          ACAResultsStatus.SetFilter("Minimum Units Failed",'=%1|<%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
          ACAResultsStatus.SetFilter("Maximum Units Failed",'=%1|>%2',CoursesRegz."% Failed Units",CoursesRegz."% Failed Units");
        // // // // // ELSE BEGIN
        // // // // // ACAResultsStatus.SETFILTER("Minimum Units Failed",'=%1|<%2',YearlyFailedUnits,YearlyFailedUnits);
        // // // // // ACAResultsStatus.SETFILTER("Maximum Units Failed",'=%1|>%2',YearlyFailedUnits,YearlyFailedUnits);
        // // // // //  END;
        ACAResultsStatus.SetCurrentkey("Order No");
        if ACAResultsStatus.Find('-') then begin
          repeat
          begin
              StatusRemarks:=ACAResultsStatus.Code;
              if ACAResultsStatus."Lead Status"<>'' then
              StatusRemarks:=ACAResultsStatus."Lead Status";
              YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
              LubricIdentified:=true;
          end;
          until ((ACAResultsStatus.Next=0) or (LubricIdentified=true))
        end;
        CoursesRegz.CalcFields("Supp/Special Exists","Attained Stage Units","Special Registration Exists");
        //IF CoursesRegz."Supp/Special Exists" THEN  StatusRemarks:='SPECIAL';
        //IF CoursesRegz."Units Deficit">0 THEN StatusRemarks:='DTSC';
        if CoursesRegz."Required Stage Units">CoursesRegz."Attained Stage Units" then StatusRemarks:='DTSC';
        //IF CoursesRegz."Exists DTSC Prefix" THEN StatusRemarks:='DTSC';
        //IF CoursesRegz."Special Registration Exists" THEN StatusRemarks:='Special';
        
        ////////////////////////////////////////////////////////////////////////////////////////////////
        // Check if exists a stopped Semester for the Academic Years and Pick the Status on the lines as the rightful Status
        Clear(StudCoregcs24);
        StudCoregcs24.Reset;
        StudCoregcs24.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs24.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs24.SetRange(Reversed,true);
        if StudCoregcs24.Find('-') then begin
          Clear(ACARegStoppageReasons);
          ACARegStoppageReasons.Reset;
          ACARegStoppageReasons.SetRange("Reason Code",StudCoregcs24."Stoppage Reason");
          if ACARegStoppageReasons.Find('-') then begin
        
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Status,ACARegStoppageReasons."Global Status");
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        end else begin
         // StatusRemarks:=UPPERCASE(FORMAT(Customer.Status));
          StatusRemarks:=UpperCase(Format(StudCoregcs24."Stoppage Reason"));
          YearlyReMarks:=StatusRemarks;
          end;
          end;
          end;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////
        
                  end else begin
        
        CoursesRegz.CalcFields("Attained Stage Units");
        if CoursesRegz."Attained Stage Units" = 0 then  StatusRemarks:='DTSC';
        Clear(StudCoregcs);
        StudCoregcs.Reset;
        StudCoregcs.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs.SetRange("Stoppage Exists In Acad. Year",true);
        if StudCoregcs.Find('-') then begin
        Clear(StudCoregcs2);
        StudCoregcs2.Reset;
        StudCoregcs2.SetRange("Student No.",CoursesRegz."Student Number");
        StudCoregcs2.SetRange("Academic Year",CoursesRegz."Academic Year");
        StudCoregcs2.SetRange("Stoppage Exists In Acad. Year",true);
        StudCoregcs2.SetRange(Reversed,true);
        if StudCoregcs2.Find('-') then begin
            StatusRemarks:=UpperCase(Format(StudCoregcs2."Stoppage Reason"));
          YearlyReMarks:=StatusRemarks;
          end;
          end;
        
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Status,Customer.Status);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          StatusRemarks:=ACAResultsStatus.Code;
          YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
        end else begin
          StatusRemarks:=UpperCase(Format(Customer.Status));
          YearlyReMarks:=StatusRemarks;
          end;
                    end;
                end;
        
        
        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,StatusRemarks);
        ACAResultsStatus.SetRange("Academic Year",CoursesRegz."Academic Year");
        ACAResultsStatus.SetRange("Special Programme Class",ACAProgramme."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          // Check if the Ststus does not allow Supp. Generation and delete
          if ACAResultsStatus."Skip Supp Generation" = true then  begin
            // Delete Entries from Supp Registration for the Semester
            Clear(AcaSpecialExamsDetails);
            AcaSpecialExamsDetails.Reset;
            AcaSpecialExamsDetails.SetRange("Student No.",CoursesRegz."Student Number");
            AcaSpecialExamsDetails.SetRange("Year of Study",CoursesRegz."Year of Study");
            AcaSpecialExamsDetails.SetRange("Exam Marks",0);
            AcaSpecialExamsDetails.SetRange(Status,AcaSpecialExamsDetails.Status::New);
            if AcaSpecialExamsDetails.Find('-') then AcaSpecialExamsDetails.DeleteAll;
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

    local procedure GetSuppRubricPassStatus(RubricCode: Code[50];AcademicYears: Code[20];Progyz: Record UnknownRecord61511) PassStatus: Boolean
    var
        ACAResultsStatus: Record UnknownRecord69266;
    begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,RubricCode);
        ACAResultsStatus.SetRange("Academic Year",AcademicYears);
        ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          PassStatus:=ACAResultsStatus.Pass;
        end;
    end;

    local procedure GetSuppRubricOrder(RubricCode: Code[50]) RubricOrder: Integer
    var
        ACAResultsStatus: Record UnknownRecord69266;
    begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,RubricCode);
        if ACAResultsStatus.Find('-') then begin
          RubricOrder:=ACAResultsStatus."Order No";
        end;
    end;

    local procedure Get2ndSuppRubricPassStatus(RubricCode: Code[50];AcademicYears: Code[20];Progyz: Record UnknownRecord61511) PassStatus: Boolean
    var
        ACAResultsStatus: Record UnknownRecord69267;
    begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,RubricCode);
        ACAResultsStatus.SetRange("Academic Year",AcademicYears);
        ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
        if ACAResultsStatus.Find('-') then begin
          PassStatus:=ACAResultsStatus.Pass;
        end;
    end;

    local procedure Get2ndSuppRubricOrder(RubricCode: Code[50]) RubricOrder: Integer
    var
        ACAResultsStatus: Record UnknownRecord69267;
    begin

        ACAResultsStatus.Reset;
        ACAResultsStatus.SetRange(Code,RubricCode);
        if ACAResultsStatus.Find('-') then begin
          RubricOrder:=ACAResultsStatus."Order No";
        end;
    end;

    local procedure Get1StSuppScore(StudentNoz: Code[20];UnitCode: Code[20]) SuppScores: Decimal
    var
        AcaSpecialExamsResultsAl1: Record UnknownRecord78003;
    begin
        Clear(AcaSpecialExamsResultsAl1);
        AcaSpecialExamsResultsAl1.Reset;
        AcaSpecialExamsResultsAl1.SetRange("Student No.",StudentNoz);
        AcaSpecialExamsResultsAl1.SetRange(Unit,UnitCode);
        AcaSpecialExamsResultsAl1.SetFilter(Score,'>0');
        if AcaSpecialExamsResultsAl1.Find('-') then SuppScores:=AcaSpecialExamsResultsAl1.Score;
    end;

    local procedure Get2ndSuppScore(StudentNoz: Code[20];UnitCode: Code[20]) SecondSuppResults: Decimal
    var
        AcaSpecialExamsResultsAl1: Record UnknownRecord78032;
    begin
        Clear(AcaSpecialExamsResultsAl1);
        Clear(SecondSuppResults);
        AcaSpecialExamsResultsAl1.Reset;
        AcaSpecialExamsResultsAl1.SetRange("Student No.",StudentNoz);
        AcaSpecialExamsResultsAl1.SetRange(Unit,UnitCode);
        AcaSpecialExamsResultsAl1.SetFilter(Score,'>0');
        if AcaSpecialExamsResultsAl1.Find('-') then SecondSuppResults:=AcaSpecialExamsResultsAl1.Score;
    end;

    local procedure UpdateAcadYear(var ProgramList: Code[1024])
    var
        AcaProgrammes_Buffer: Record UnknownRecord65824;
        AcaProgrammes_Buffer2: Record UnknownRecord65824;
    begin
        if StudNos <> '' then begin
          Clear(AcadYear);
          Clear(AcaAcademicYear_Buffer);
          AcaAcademicYear_Buffer.Reset;
          AcaAcademicYear_Buffer.SetRange(User_Id,UserId);
          if AcaAcademicYear_Buffer.Find('-') then AcaAcademicYear_Buffer.DeleteAll;
          Schools := '';
          programs := '';
          ProgramList := '';
          Clear(AcadYear);
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
                  if AcadYear <> '' then begin
                AcadYear := AcadYear+'|'+AcaAcademicYear_Buffer.Academic_Year;
                    end else begin
                AcadYear := AcaAcademicYear_Buffer.Academic_Year;
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
          Clear(AcadYear);
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
                  if AcadYear <> '' then begin
                AcadYear := AcadYear+'|'+AcaAcademicYear_Buffer.Academic_Year;
                    end else begin
                AcadYear := AcaAcademicYear_Buffer.Academic_Year;
                      end;
              end;
              until AcaAcademicYear_Buffer.Next = 0;
            end;
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
}

