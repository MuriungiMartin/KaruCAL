#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77702 "Process Exams Central Gen.2"
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
                    Caption = 'Student Nos';

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
                    CourseRegForStoppage: Record UnknownRecord61532;
                    AcaSpecialExamsDetails7: Record UnknownRecord78002;
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
                    CurrStudentNo: Code[250];
                    CountedNos: Integer;
                    CurrSchool: Code[250];
                    AcaSpecialExamsDetails6: Record UnknownRecord78002;
                    ACASenateReportsHeaderSupp: Record UnknownRecord66644;
                    ProgForFilters: Record UnknownRecord61511;
                    ACASenateReportsHeaderSupps: Record UnknownRecord66645;
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
                    ACAExamCourseRegistration.SetFilter("Student Number",StudNos);
                    ACAExamClassificationUnits.SetFilter("Student No.",StudNos);
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


                                      ACASenateReportsHeaderSupp.Reset;
                                      ACASenateReportsHeaderSupp.SetFilter("Academic Year",AcadYear);
                                      ACASenateReportsHeaderSupp.SetFilter(Programme,ProgFIls);
                                      if  (ACASenateReportsHeaderSupp.Find('-')) then ACASenateReportsHeaderSupp.DeleteAll;

                                      ACASenateReportsHeader.Reset;
                                      ACASenateReportsHeader.SetFilter("Academic Year",AcadYear);
                                      ACASenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                                      if  (ACASenateReportsHeader.Find('-')) then ACASenateReportsHeader.DeleteAll;
                                      //////////////////////////////////////////////////////////////////////////////////////////////
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
                                      ///////////////////////////////////////////////////////////////////////////////////////////////////
                    Clear(Coregcs);
                    Coregcs.Reset;
                    Coregcs.SetFilter("Academic Year",AcadYear);
                    //Coregcs.SETRANGE("Exclude from Computation",FALSE);
                    Coregcs.SetFilter(Programme,ProgFIls);
                    Coregcs.SetFilter(Status,'<>%1',Coregcs.Status::Alumni);
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
                    StudentUnits.SetRange("Year Of Study",Coregcs."Year Of Study");
                    //StudentUnits.SETRANGE(Semester,Coregcs.Semester);
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
                       //

                    Coregcs.CalcFields("Stoppage Exists In Acad. Year","Stoppage Exists in YoS",
                    "Stopped Academic Year","Stopage Yearly Remark","Academic Year Exclude Comp.");

                      Clear(CourseRegForStoppage);
                      CourseRegForStoppage.Reset;
                      CourseRegForStoppage.SetRange("Student No.",Coregcs."Student No.");
                      CourseRegForStoppage.SetRange("Year Of Study",Coregcs."Year Of Study");
                      CourseRegForStoppage.SetRange("Academic Year",Coregcs."Stopped Academic Year");
                      CourseRegForStoppage.SetRange(Reversed,true);
                      if CourseRegForStoppage.Find('-') then
                      CourseRegForStoppage.CalcFields("Academic Year Exclude Comp.","Combine Discordant Sem. in Yr");

                          if Coregcs."Stopped Academic Year" <>'' then begin
                           if CourseRegForStoppage."Academic Year Exclude Comp."=false then begin
                             if CourseRegForStoppage."Combine Discordant Sem. in Yr" = true then begin
                            StudentUnits.SetRange("Reg. Reversed",false);
                                  StudentUnits.SetFilter("Academic Year (Flow)",'=%1|=%2',Coregcs."Stopped Academic Year",Coregcs."Academic Year");
                               end else begin
                          StudentUnits.SetFilter("Academic Year (Flow)",'=%1',Coregcs."Academic Year");
                                 end;
                           end else begin
                            StudentUnits.SetRange("Reg. Reversed",false);
                             end;
                           end
                          else begin
                          StudentUnits.SetFilter("Academic Year (Flow)",'=%1',Coregcs."Academic Year");
                          StudentUnits.SetRange("Reg. Reversed",false);
                            end;
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
                              if  ACAExamCourseRegistration.Insert(true) then;
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
                                          Clear(AcaSpecialExamsDetailsz);
                                  AcaSpecialExamsDetailsz.Reset;
                                  AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                  AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                  AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                  AcaSpecialExamsDetailsz.SetFilter(Occurance,'>%1',1);
                                  if AcaSpecialExamsDetailsz.Find('-')  then begin
                                    repeat
                                      begin
                                      AcaSpecialExamsDetailsz.CalcFields(Occurance);
                                      if((AcaSpecialExamsDetailsz."Exam Marks" = 0) and (AcaSpecialExamsDetailsz."Special Exam Reason"='')) then AcaSpecialExamsDetailsz.Delete;
                                      end;
                                      until ((AcaSpecialExamsDetailsz.Next = 0) or (AcaSpecialExamsDetailsz.Occurance = 1));
                                    end;
                                          /// Update Cummulative Resit
                                  Clear(AcaSpecialExamsDetailsz);
                                  AcaSpecialExamsDetailsz.Reset;
                                  AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                  AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                  AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                  if AcaSpecialExamsDetailsz.Find('-')  then begin
                                    Clear(AcaSpecialExamsDetails7);
                                    AcaSpecialExamsDetails7.Reset;
                                    AcaSpecialExamsDetails7.SetRange("Student No.",AcaSpecialExamsDetailsz."Student No.");
                                    AcaSpecialExamsDetails7.SetRange("Unit Code",AcaSpecialExamsDetailsz."Unit Code");
                                    AcaSpecialExamsDetails7.SetRange(Semester,StudentUnits.Semester);
                                    if AcaSpecialExamsDetails7.Find('-') then begin
                                      if AcaSpecialExamsDetails7."Exam Marks" = 0 then  begin
                                      end;
                                    end else
                                  //  IF StudentUnits.Semester <> AcaSpecialExamsDetailsz.Semester THEN
                                        if AcaSpecialExamsDetailsz.Rename(AcaSpecialExamsDetailsz."Student No.",AcaSpecialExamsDetailsz."Unit Code",
                                         AcaSpecialExamsDetailsz."Academic Year",StudentUnits.Semester,                AcaSpecialExamsDetailsz.Sequence,
                                         AcaSpecialExamsDetailsz.Category,AcaSpecialExamsDetailsz.Programme) then;
                                      end;

                                        AcaSpecialExamsDetailsz.Reset;
                                        AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                        AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                        AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                        AcaSpecialExamsDetailsz.SetRange(Status,AcaSpecialExamsDetailsz.Status::New);
                                        //AcaSpecialExamsDetailsz.SETRANGE(Semester,StudentUnits.Semester);
                                        AcaSpecialExamsDetailsz.SetRange("Exam Marks",0);
                                  if AcaSpecialExamsDetailsz.Find('-') then begin
                                   if (AcaSpecialExamsDetailsz."Special Exam Reason"='') then
                                     AcaSpecialExamsDetailsz.DeleteAll;
                                    end;


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

                                          Clear(AcaSpecialExamsDetailsz);
                                  AcaSpecialExamsDetailsz.Reset;
                                  AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                  AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                  AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                  AcaSpecialExamsDetailsz.SetFilter(Occurance,'>%1',1);
                                  if AcaSpecialExamsDetailsz.Find('-')  then begin
                                    repeat
                                      begin
                                      AcaSpecialExamsDetailsz.CalcFields(Occurance);
                                      if(( AcaSpecialExamsDetailsz."Exam Marks" = 0)  and (AcaSpecialExamsDetailsz."Special Exam Reason"='')) then AcaSpecialExamsDetailsz.Delete;
                                      end;
                                      until ((AcaSpecialExamsDetailsz.Next = 0) or (AcaSpecialExamsDetailsz.Occurance = 1));
                                    end;
                                Clear(AcaSpecialExamsDetailsz);
                                AcaSpecialExamsDetailsz.Reset;
                                AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                if AcaSpecialExamsDetailsz.Find('-') then begin
                                //    IF StudentUnits.Semester <> AcaSpecialExamsDetailsz.Semester THEN

                                    Clear(AcaSpecialExamsDetails7);
                                    AcaSpecialExamsDetails7.Reset;
                                    AcaSpecialExamsDetails7.SetRange("Student No.",AcaSpecialExamsDetailsz."Student No.");
                                    AcaSpecialExamsDetails7.SetRange("Unit Code",AcaSpecialExamsDetailsz."Unit Code");
                                    AcaSpecialExamsDetails7.SetRange(Semester,StudentUnits.Semester);
                                    if AcaSpecialExamsDetails7.Find('-') then begin
                                      if AcaSpecialExamsDetails7."Exam Marks" = 0 then begin
                                      end;
                                    end else
                           if  AcaSpecialExamsDetailsz.Rename(AcaSpecialExamsDetailsz."Student No.",AcaSpecialExamsDetailsz."Unit Code",
                             AcaSpecialExamsDetailsz."Academic Year",StudentUnits.Semester,        AcaSpecialExamsDetailsz.Sequence,
                                    AcaSpecialExamsDetailsz.Category,AcaSpecialExamsDetailsz.Programme) then;
                                    end;
                      end;
                    end;
                            end else begin
                                AcaSpecialExamsDetailsz.Reset;
                                AcaSpecialExamsDetailsz.SetRange("Student No.",StudentUnits."Student No.");
                                AcaSpecialExamsDetailsz.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                                AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                                AcaSpecialExamsDetailsz.SetRange(Status,AcaSpecialExamsDetailsz.Status::New);
                                AcaSpecialExamsDetailsz.SetRange(Semester,StudentUnits.Semester);
                                AcaSpecialExamsDetailsz.SetRange("Exam Marks",0);
                                 if AcaSpecialExamsDetailsz.Find('-') then begin
                                   if (AcaSpecialExamsDetailsz."Special Exam Reason"='') then AcaSpecialExamsDetailsz.DeleteAll;
                                   end;
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
                          /////////////////////////////////////////////// Delete All Supplementary Related Entries from All Supplementary Tables and Repopulate

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

                               // Check Multiple Occurances on Rubrics
                               ACAExamCourseRegistration.CalcFields("Skip Supplementary Generation","Yearly Rubric Occurances",
                               "Total Rubric Occurances","Maximum Allowable Occurances","Alternate Rubric");
                               if ACAExamCourseRegistration."Maximum Allowable Occurances" >0 then begin
                                if ((ACAExamCourseRegistration."Yearly Rubric Occurances" > ACAExamCourseRegistration."Maximum Allowable Occurances")
                                  or (ACAExamCourseRegistration."Yearly Rubric Occurances" = ACAExamCourseRegistration."Maximum Allowable Occurances")) then
                                  begin
                                    // Pick Alternate
                               ACAExamCourseRegistration."Final Classification":=ACAExamCourseRegistration."Alternate Rubric";
                               ACAExamCourseRegistration."Final Classification Pass":=GetRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                               ACAExamCourseRegistration."Academic Year",Progyz);
                               ACAExamCourseRegistration."Final Classification Order":=GetRubricOrder(ACAExamCourseRegistration."Final Classification");
                               ACAExamCourseRegistration.Graduating:=GetRubricPassStatus(ACAExamCourseRegistration."Final Classification",
                               ACAExamCourseRegistration."Academic Year",Progyz);
                               ACAExamCourseRegistration.Classification := ACAExamCourseRegistration."Final Classification";
                                    end;
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

                              ACAExamCourseRegistration."Cummulative Fails":=GetCummulativeFails(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study");
                              ACAExamCourseRegistration."Cumm. Required Stage Units":=GetCummulativeReqStageUnitrs(ACAExamCourseRegistration.Programme,ACAExamCourseRegistration."Year of Study",
                              ACAExamCourseRegistration."Programme Option",ACAExamCourseRegistration."Academic Year");
                              ACAExamCourseRegistration."Cumm Attained Units":=GetCummAttainedUnits(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration.Programme);
                               ACAExamCourseRegistration.Modify(true);
                               ACAExamCourseRegistration.CalcFields("Skip Supplementary Generation");
                               if ACAExamCourseRegistration."Skip Supplementary Generation" = true then begin
                                 // Delete all Supp Registrations here
                                 DeleteSuppPreviousEntries(ACAExamCourseRegistration);
                                 if Coregcs.Find('-') then begin
                                   repeat
                                     begin
                                 Clear(AcaSpecialExamsDetailsz);
                                  AcaSpecialExamsDetailsz.Reset;
                                  AcaSpecialExamsDetailsz.SetRange("Student No.",ACAExamCourseRegistration."Student Number");
                    AcaSpecialExamsDetailsz.SetRange(Category,AcaSpecialExamsDetailsz.Category::Supplementary);
                    AcaSpecialExamsDetailsz.SetRange(Semester,Coregcs.Semester);
                    AcaSpecialExamsDetailsz.SetRange(Status,AcaSpecialExamsDetailsz.Status::New);
                    AcaSpecialExamsDetailsz.SetRange("Exam Marks",0);
                                  if AcaSpecialExamsDetailsz.Find('-') then begin
                                    if (AcaSpecialExamsDetailsz."Special Exam Reason"='') then AcaSpecialExamsDetailsz.DeleteAll;
                                    end;
                                  end;
                                  until Coregcs.Next = 0;
                                  end;
                                 end else begin
                                   // If Rubric is a Fail, Generate a Supplementary Registration
                                  // ERROR(ACAExamCourseRegistration."Student Number");
                                   UpdateSupplementaryMarks(ACAExamCourseRegistration);
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
                      // Update Supp Summaries
                      /////????????????????????????????????????????????????

                              Clear(ACASenateReportsHeaderSupps);
                                ACASenateReportsHeaderSupps.Reset;
                                ACASenateReportsHeaderSupps.SetFilter("Programme Code",ProgFIls);
                                ACASenateReportsHeaderSupps.SetFilter("Reporting Academic Year",AcadYear);
                                if ACASenateReportsHeaderSupps.Find('-') then begin
                                  ProgBar22.Open('#1##########################################');
                                  repeat
                                      begin
                                      ProgBar22.Update(1,'Student Number: '+ACASenateReportsHeaderSupps."Programme Code"+' Class: '+ACASenateReportsHeaderSupps."Classification Code");
                                      with ACASenateReportsHeaderSupps do
                                        begin
                                          ACASenateReportsHeaderSupps.CalcFields("School Classification Count","School Total Passed","School Total Passed",
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
                                          ACASenateReportsHeaderSupps.Modify;
                                      end;
                                    until ACASenateReportsHeaderSupps.Next=0;
                                    ProgBar22.Close;
                                    end;
                      ////???????????????????????????????????????????????????????????
                      // Supp Updates
                                Clear(ACA2NDSenateReportsHeader);
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
        StudNos: Text;
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
        AcaAcademicYear_Buffer: Record UnknownRecord65815;
        AcaAcademicYear_Buffer2: Record UnknownRecord65815;
        CountedLoops: Integer;
        AcademicYearArray: array [100] of Text[1024];
        ACACourseRegistration: Record UnknownRecord61532;
        Arrayfound: Boolean;
        SecSup: Record UnknownRecord78031;
        SupReviewToBecreated: Boolean;

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

    local procedure GetStudentName(StudNo: Code[250]) StudName: Text[250]
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

    local procedure GetDepartmentNameOrSchool(DimCode: Code[250]) DimName: Text[150]
    var
        dimVal: Record "Dimension Value";
    begin
        dimVal.Reset;
        dimVal.SetRange(Code,DimCode);
        if dimVal.Find('-') then DimName:=dimVal.Name;
    end;

    local procedure GetFinalStage(ProgCode: Code[250]) FinStage: Code[250]
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

    local procedure GetFinalYearOfStudy(ProgCode: Code[250]) FinYearOfStudy: Integer
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

    local procedure GetAdmissionDate(StudNo: Code[250];ProgCode: Code[250]) AdmissionDate: Date
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

    local procedure GetAdmissionAcademicYear(StudNo: Code[250];ProgCode: Code[250]) AdmissionAcadYear: Code[250]
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

    local procedure GetFinalAcademicYear(StudNo: Code[250];ProgCode: Code[250]) FinalAcadYear: Code[250]
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

    local procedure GetMultipleProgramExists(StudNoz: Code[250];AcadYearsz: Code[250]) Multiples: Boolean
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

    local procedure GetCohort(StudNo: Code[250];ProgCode: Code[250]) Cohort: Code[250]
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

    local procedure RequiredStageUnits(ProgCode: Code[250];YoS: Integer;StudNo: Code[250];AcademicYear: Code[250]) ExpectedUnits: Decimal
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


    procedure GetClassificationGrade(EXAMMark: Decimal;Proga: Code[250]) xGrade: Text[100]
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[250];
        LastRemark: Code[250];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[250];
        GLabel: array [6] of Code[250];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[250];
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


    procedure GetClassPassStatus(EXAMMark: Decimal;Proga: Code[250]) Passed: Boolean
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[250];
        LastRemark: Code[250];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[250];
        GLabel: array [6] of Code[250];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[250];
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

    local procedure GetYearOfStudy(StageCode: Code[250]) YearOfStudy: Integer
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
        ObjUnits: Record UnknownRecord61549;
        AcaStoppage: Record UnknownRecord66620;
        LastStopageReason: Code[50];
        CurrentYear: Integer;
        ObjCourseReg: Record UnknownRecord66651;
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

        if CoursesRegz."Exists DTSC Prefix" and (not CoursesRegz."Special Registration Exists") then begin
          Evaluate(CurrentYear,CopyStr(CoursesRegz."Academic Year",6,4));
          //get last aca year record
          ObjCourseReg.Reset;
          ObjCourseReg.SetRange("Student Number",CoursesRegz."Student Number");
          ObjCourseReg.SetRange("Academic Year",(Format(CurrentYear-2)+'/'+Format(CurrentYear-1)));
          if ObjCourseReg.FindFirst then begin
            AcaStoppage.Reset;
            AcaStoppage.SetRange("Reason Code",ObjCourseReg.Classification);
            AcaStoppage.SetRange("Combine Discordant Semesters",true);
            if AcaStoppage.FindFirst then begin
              ObjCourseReg.CalcFields("Special Registration Exists");
              if ObjCourseReg."Special Registration Exists" then StatusRemarks:='Special';
              end;
            end;
          end;
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
            AcaSpecialExamsDetails.SetRange(AcaSpecialExamsDetails.Category,AcaSpecialExamsDetails.Category::Supplementary
            );
            if AcaSpecialExamsDetails.Find('-') then AcaSpecialExamsDetails.DeleteAll;
            end;
          end;
    end;

    local procedure GetRubricPassStatus(RubricCode: Code[50];AcademicYears: Code[250];Progyz: Record UnknownRecord61511) PassStatus: Boolean
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

    local procedure GetUnitAcademicYear(ACAExamClassificationUnits9: Record UnknownRecord66650) AcademicYear: Code[250]
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

    local procedure GetCummulativeFails(StudNo: Code[250];YoS: Integer) CumFails: Integer
    var
        AcadClassUnits: Record UnknownRecord66650;
    begin
        AcadClassUnits.Reset;
        AcadClassUnits.SetRange("Student No.",StudNo);
        AcadClassUnits.SetFilter("Year of Study",'..%1',YoS);
        AcadClassUnits.SetRange(Pass,false);
        if AcadClassUnits.Find('-') then CumFails:=AcadClassUnits.Count;
    end;

    local procedure GetCummulativeReqStageUnitrs(Programmez: Code[250];YoS: Integer;ProgOption: Code[250];AcademicYearssss: Code[250]) CummReqUNits: Decimal
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

    local procedure GetCummAttainedUnits(StudNo: Code[250];YoS: Integer;Programmesz: Code[250]) CummAttained: Integer
    var
        AcadClassUnits: Record UnknownRecord66650;
    begin
        AcadClassUnits.Reset;
        AcadClassUnits.SetRange("Student No.",StudNo);
        AcadClassUnits.SetFilter("Year of Study",'..%1',YoS);
        AcadClassUnits.SetFilter(Programme,'%1',Programmesz);
        if AcadClassUnits.Find('-') then CummAttained:=AcadClassUnits.Count;
    end;

    local procedure UpdateSupplementaryMarks(RefRegularCoRegcs: Record UnknownRecord66651)
    var
        ACAExamCourseRegistration888: Record UnknownRecord66651;
        Aca2ndSuppExamsDetailsforSupps: Record UnknownRecord78031;
        RegularExamUnitsRegForSupp: Record UnknownRecord66650;
        ACAResultsStatus: Record UnknownRecord69266;
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
        Progyz: Record UnknownRecord61511;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        ACAExamClassificationUnits: Record UnknownRecord66641;
        ACAExamCourseRegistration: Record UnknownRecord66642;
        ACAExamFailedReasons: Record UnknownRecord66643;
        ACASenateReportsHeader: Record UnknownRecord66645;
        ACAExamClassificationStuds: Record UnknownRecord66644;
        ACAExamClassificationStudsCheck: Record UnknownRecord66644;
        ACAExamResultsFin: Record UnknownRecord61548;
        ACAResultsStatusSuppGen: Record UnknownRecord61739;
        ProgressForCoReg: Dialog;
        Tens: Text;
        ACASemesters: Record UnknownRecord61692;
        ACAExamResults_Fin: Record UnknownRecord61548;
        Coregcs: Record UnknownRecord61532;
        ACAExamCummulativeResit: Record UnknownRecord66647;
        ACAStudentUnitsForResits: Record UnknownRecord61549;
        SEQUENCES: Integer;
        CurrStudentNo: Code[250];
        CountedNos: Integer;
        CurrSchool: Code[250];
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        Aca2ndSuppExamsResults: Record UnknownRecord78032;
        Aca2ndSuppExamsDetails3: Record UnknownRecord78031;
        Aca2ndSuppExamsDetails4: Record UnknownRecord78031;
        AcaSpecialExamsDetails4: Record UnknownRecord78002;
        ACAResultsStatusSupp: Record UnknownRecord69266;
    begin
        ProgFIls:=RefRegularCoRegcs.Programme;
        
        Clear(ACAExamClassificationStuds);
        Clear(ACAExamCourseRegistration);
        Clear(ACAExamClassificationUnits);
        Clear(ACAExamSuppUnits);
        ACAExamClassificationStuds.Reset;
        ACAExamCourseRegistration.Reset;
        ACAExamClassificationUnits.Reset;
        ACAExamSuppUnits.Reset;
        ACAExamClassificationStuds.SetFilter("Student Number",RefRegularCoRegcs."Student Number");
        ACAExamCourseRegistration.SetRange("Student Number",RefRegularCoRegcs."Student Number");
        ACAExamClassificationUnits.SetRange("Student No.",RefRegularCoRegcs."Student Number");
        ACAExamSuppUnits.SetRange("Student No.",RefRegularCoRegcs."Student Number");
        ACAExamClassificationStuds.SetFilter("Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamCourseRegistration.SetFilter("Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamClassificationUnits.SetFilter("Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamSuppUnits.SetFilter("Academic Year",AcadYear);
        
        ACAExamClassificationStuds.SetFilter(Programme,ProgFIls);
        ACAExamCourseRegistration.SetFilter(Programme,ProgFIls);
        ACAExamClassificationUnits.SetFilter(Programme,ProgFIls);
        ACAExamSuppUnits.SetFilter(Programme,ProgFIls);
        if ACAExamClassificationStuds.Find('-') then ACAExamClassificationStuds.DeleteAll;
        if ACAExamCourseRegistration.Find('-') then ACAExamCourseRegistration.DeleteAll;
        if ACAExamClassificationUnits.Find('-') then ACAExamClassificationUnits.DeleteAll;
        if ACAExamSuppUnits.Find('-') then ACAExamSuppUnits.DeleteAll;
        
        ///// Create Supp. Entries Here
         ////////////////////////////////////////////////////////////////////////////
            //  Supp. Headers
        
                Progyz.Reset;
                if Progyz.Get(RefRegularCoRegcs.Programme) then;
        
                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
                    ACAResultsStatus.SetRange("Academic Year",RefRegularCoRegcs."Academic Year");
                    if ACAResultsStatus.Find('-') then begin
                      repeat
                          begin
                          ACASenateReportsHeader.Reset;
                          ACASenateReportsHeader.SetRange("Academic Year",RefRegularCoRegcs."Academic Year");
                          ACASenateReportsHeader.SetRange("School Code",Progyz."School Code");
                          ACASenateReportsHeader.SetRange("Classification Code",ACAResultsStatus.Code);
                          ACASenateReportsHeader.SetRange("Programme Code",Progyz.Code);
                          ACASenateReportsHeader.SetRange("Year of Study",RefRegularCoRegcs."Year of Study");
                          if not (ACASenateReportsHeader.Find('-')) then begin
                            ACASenateReportsHeader.Init;
                            ACASenateReportsHeader."Academic Year":=RefRegularCoRegcs."Academic Year";
                            ACASenateReportsHeader."Reporting Academic Year":=RefRegularCoRegcs."Academic Year";
                            ACASenateReportsHeader."Rubric Order":=ACAResultsStatus."Order No";
                            ACASenateReportsHeader."Programme Code":=Progyz.Code;
                            ACASenateReportsHeader."School Code":=Progyz."School Code";
                            ACASenateReportsHeader."Year of Study":=RefRegularCoRegcs."Year of Study";
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
                ACAExamClassificationStuds.SetRange("Student Number",RefRegularCoRegcs."Student Number");
                ACAExamClassificationStuds.SetRange(Programme,RefRegularCoRegcs.Programme);
                ACAExamClassificationStuds.SetRange("Academic Year",RefRegularCoRegcs."Academic Year");
                if not ACAExamClassificationStuds.Find('-') then begin
                ACAExamClassificationStuds.Init;
                ACAExamClassificationStuds."Student Number":=RefRegularCoRegcs."Student Number";
                ACAExamClassificationStuds."Reporting Academic Year":=RefRegularCoRegcs."Academic Year";
                ACAExamClassificationStuds."School Code":=Progyz."School Code";
                ACAExamClassificationStuds.Department:=Progyz."Department Code";
                ACAExamClassificationStuds."Programme Option":=RefRegularCoRegcs."Programme Option";
                ACAExamClassificationStuds.Programme:=RefRegularCoRegcs.Programme;
                ACAExamClassificationStuds."Academic Year":=RefRegularCoRegcs."Academic Year";
                ACAExamClassificationStuds."Year of Study":=RefRegularCoRegcs."Year of Study";
              ACAExamClassificationStuds."School Name":=GetDepartmentNameOrSchool(Progyz."School Code");
              ACAExamClassificationStuds."Student Name":=GetStudentName(RefRegularCoRegcs."Student Number");
              ACAExamClassificationStuds.Cohort:=GetCohort(RefRegularCoRegcs."Student Number",RefRegularCoRegcs.Programme);
              ACAExamClassificationStuds."Final Stage":=GetFinalStage(RefRegularCoRegcs.Programme);
              ACAExamClassificationStuds."Final Academic Year":=GetFinalAcademicYear(RefRegularCoRegcs."Student Number",RefRegularCoRegcs.Programme);
              ACAExamClassificationStuds."Final Year of Study":=GetFinalYearOfStudy(RefRegularCoRegcs.Programme);
              ACAExamClassificationStuds."Admission Date":=GetAdmissionDate(RefRegularCoRegcs."Student Number",RefRegularCoRegcs.Programme);
              ACAExamClassificationStuds."Admission Academic Year":=GetAdmissionAcademicYear(RefRegularCoRegcs."Student Number",RefRegularCoRegcs.Programme);
              ACAExamClassificationStuds.Graduating:=false;
              ACAExamClassificationStuds.Classification:='';
                if ACAExamClassificationStuds.Insert then;
            end;
                /////////////////////////////////////// YoS Tracker
                ACAExamCourseRegistration.Reset;
                ACAExamCourseRegistration.SetRange("Student Number",RefRegularCoRegcs."Student Number");
                ACAExamCourseRegistration.SetRange(Programme,RefRegularCoRegcs.Programme);
                ACAExamCourseRegistration.SetRange("Year of Study",RefRegularCoRegcs."Year of Study");
                ACAExamCourseRegistration.SetRange("Academic Year",RefRegularCoRegcs."Academic Year");
                if not ACAExamCourseRegistration.Find('-') then begin
                    ACAExamCourseRegistration.Init;
                    ACAExamCourseRegistration."Student Number":=RefRegularCoRegcs."Student Number";
                    ACAExamCourseRegistration.Programme:=RefRegularCoRegcs.Programme;
                    ACAExamCourseRegistration."Year of Study":=RefRegularCoRegcs."Year of Study";
                    ACAExamCourseRegistration."Reporting Academic Year":=RefRegularCoRegcs."Academic Year";
                    ACAExamCourseRegistration."Academic Year":=RefRegularCoRegcs."Academic Year";
                    ACAExamCourseRegistration."School Code":=Progyz."School Code";
                    ACAExamCourseRegistration."Programme Option":=RefRegularCoRegcs."Programme Option";
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
              Clear(ACAExamCourseRegistration888);
              ACAExamCourseRegistration888.Reset;
              ACAExamCourseRegistration888.SetRange("Skip Supplementary Generation",false);
              ACAExamCourseRegistration888.SetRange("Student Number",RefRegularCoRegcs."Student Number");
              ACAExamCourseRegistration888.SetRange("Academic Year",RefRegularCoRegcs."Academic Year");
              if ACAExamCourseRegistration888.Find('-') then
                  if  ACAExamCourseRegistration.Insert(true) then;
                  end;
        
        // Create Units for the Supp Registration ***********************************
        Clear(RegularExamUnitsRegForSupp);
        RegularExamUnitsRegForSupp.Reset;
        RegularExamUnitsRegForSupp.SetRange(RegularExamUnitsRegForSupp."Student No.",RefRegularCoRegcs."Student Number");
        RegularExamUnitsRegForSupp.SetRange(RegularExamUnitsRegForSupp.Programme,RefRegularCoRegcs.Programme);
        RegularExamUnitsRegForSupp.SetRange(RegularExamUnitsRegForSupp."Academic Year",RefRegularCoRegcs."Academic Year");
        if RegularExamUnitsRegForSupp.Find('-') then begin
          repeat
            begin
            if ((RegularExamUnitsRegForSupp."Unit Code" = 'BHR 315') and (RefRegularCoRegcs."Academic Year" = '2022/2023')) then
            Clear(StudentUnits);
            Clear(StudentUnits);
            StudentUnits.Reset;
            StudentUnits.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
            StudentUnits.SetRange(Unit,RegularExamUnitsRegForSupp."Unit Code");
            StudentUnits.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
            StudentUnits.SetRange("Reg. Reversed",false);
           // StudentUnits.SETRANGE("Academic Year (Flow)",RegularExamUnitsRegForSupp."Academic Year");
            if StudentUnits.Find('-') then begin
        
                            Clear(CATExists);
                         Clear(ACAExamResults_Fin);
                         ACAExamResults_Fin.Reset;
                         ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         ACAExamResults_Fin.SetCurrentkey(Score);
                         if ACAExamResults_Fin.Find('+') then begin
                           CATExists := true;
                           end;
            Coregcs.Reset;
        Coregcs.SetFilter(Programme,StudentUnits.Programme);
        //Coregcs.SETFILTER("Academic Year",RegularExamUnitsRegForSupp."Academic Year");
        Coregcs.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
        Coregcs.SetRange(Semester,StudentUnits.Semester);
        if Coregcs.Find('-') then begin
            RegularExamUnitsRegForSupp.CalcFields(Pass,"Exam Category");
        
              Clear(UnitsSubjects);
              UnitsSubjects.Reset;
              UnitsSubjects.SetRange("Programme Code",RefRegularCoRegcs.Programme);
              UnitsSubjects.SetRange(Code,RegularExamUnitsRegForSupp."Unit Code");
              if UnitsSubjects.Find('-') then begin
        
                if UnitsSubjects."Default Exam Category"='' then UnitsSubjects."Default Exam Category":=Progyz."Exam Category";
                if UnitsSubjects."Exam Category"='' then UnitsSubjects."Exam Category":=Progyz."Exam Category";
                UnitsSubjects.Modify;
                Clear(ACAExamClassificationUnits);
                ACAExamClassificationUnits.Reset;
                ACAExamClassificationUnits.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                ACAExamClassificationUnits.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
                ACAExamClassificationUnits.SetRange("Unit Code",RegularExamUnitsRegForSupp."Unit Code");
                ACAExamClassificationUnits.SetRange("Academic Year",RegularExamUnitsRegForSupp."Academic Year");
                if not ACAExamClassificationUnits.Find('-') then begin
                    ACAExamClassificationUnits.Init;
                    ACAExamClassificationUnits."Student No.":=RegularExamUnitsRegForSupp."Student No.";
                    ACAExamClassificationUnits.Programme:=RegularExamUnitsRegForSupp.Programme;
                    ACAExamClassificationUnits."Reporting Academic Year":=RegularExamUnitsRegForSupp."Academic Year";
                    ACAExamClassificationUnits."School Code":=Progyz."School Code";
                    ACAExamClassificationUnits."Unit Code":=RegularExamUnitsRegForSupp."Unit Code";
                    ACAExamClassificationUnits."Credit Hours":=UnitsSubjects."No. Units";
                    ACAExamClassificationUnits."Unit Type":=Format(UnitsSubjects."Unit Type");
                    ACAExamClassificationUnits."Unit Description":=UnitsSubjects.Desription;
                    ACAExamClassificationUnits."Year of Study":=RegularExamUnitsRegForSupp."Year of Study";
                    ACAExamClassificationUnits."Academic Year":=RegularExamUnitsRegForSupp."Academic Year";
                    ACAExamClassificationUnits."Results Exists Status" := ACAExamClassificationUnits."results exists status"::"Both Exists";
        
                        Clear(ExamResults); ExamResults.Reset;
                        ExamResults.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
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
                ACAExamClassificationUnits.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                ACAExamClassificationUnits.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
                ACAExamClassificationUnits.SetRange("Unit Code",RegularExamUnitsRegForSupp."Unit Code");
                ACAExamClassificationUnits.SetRange("Academic Year",RegularExamUnitsRegForSupp."Academic Year");
                if ACAExamClassificationUnits.Find('-') then begin
                  ACAExamClassificationUnits.CalcFields("Is Supp. Unit","Is Special Unit");
        
                      if ACAExamClassificationUnits."Is Special Unit" = true then
                     begin
                    //  Pick Special Marks here and leave value of Sore to Zero if Mark does not exist
                          // Check for Special Marks if exists
                            Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Special);
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                            if AcaSpecialExamsDetails.Find('-') then begin
                          ACAExamClassificationUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                    ACAExamClassificationUnits."Total Score" := Format(ACAExamClassificationUnits."Exam Score Decimal"+
                    ACAExamClassificationUnits."CAT Score Decimal");
                    ACAExamClassificationUnits."Total Score Decimal" := ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal";
                  ACAExamClassificationUnits."Weighted Total Score" :=ACAExamClassificationUnits."Total Score Decimal"*
                  RegularExamUnitsRegForSupp."Credit Hours";
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
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score":=Format(ACAExamClassificationUnits."Total Score Decimal");
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                              end;
        // //                  ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal",0.01,'=');
        // //                  ACAExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",ACAExamClassificationUnits."Total Score Decimal");
        // //                  ACAExamClassificationUnits."Total Score":=FORMAT(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
        // //                  ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                      end;
                    if ACAExamClassificationUnits."Is Supp. Unit" then begin
                      /////////////////////////////////////////////////////////////////////////////////////////
        
                    //  Pick Supp Marks here and leave value of Sore to Zero if Mark does not exist
                          // Check for Supp Marks if exists
                            Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Supplementary);
                           // AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                            if AcaSpecialExamsDetails.Find('-') then begin
                          ACAExamClassificationUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                    ACAExamClassificationUnits."CAT Score" := '0';
                    ACAExamClassificationUnits."CAT Score Decimal" := 0;
                    ACAExamClassificationUnits."Total Score" := ACAExamClassificationUnits."Exam Score";
                    ACAExamClassificationUnits."Total Score Decimal" := ACAExamClassificationUnits."Exam Score Decimal";
                  ACAExamClassificationUnits."Weighted Total Score" :=ACAExamClassificationUnits."Exam Score Decimal"*RegularExamUnitsRegForSupp."Credit Hours";
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
                          ACAExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(Progyz."Exam Category",ACAExamClassificationUnits."Total Score Decimal");
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                              end;
                      //////////////////////////////////////////////////////////////////////////////////////////////////
                      end;
                  if RegularExamUnitsRegForSupp.Pass then begin
                    // Capture Regular Marks here Since the Unit was Passed by the Student
                    ACAExamClassificationUnits."CAT Score" := RegularExamUnitsRegForSupp."CAT Score";
                    ACAExamClassificationUnits."CAT Score Decimal" := RegularExamUnitsRegForSupp."CAT Score Decimal";
                    ACAExamClassificationUnits."Results Exists Status" := RegularExamUnitsRegForSupp."Results Exists Status";
                    ACAExamClassificationUnits."Exam Score" := RegularExamUnitsRegForSupp."Exam Score";
                    ACAExamClassificationUnits."Exam Score Decimal" := RegularExamUnitsRegForSupp."Exam Score Decimal";
                    ACAExamClassificationUnits."Total Score" := RegularExamUnitsRegForSupp."Total Score";
                    ACAExamClassificationUnits."Total Score Decimal" := RegularExamUnitsRegForSupp."Total Score Decimal";
                  ACAExamClassificationUnits."Weighted Total Score" :=RegularExamUnitsRegForSupp."Weighted Total Score";
                    end;
                    ACAExamClassificationUnits.Modify;
                  end;
        ////////////*********************************************
        //////////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        // Check for Special Exams Score if Exists
        
                    Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Special);
                           // AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
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
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*
                          ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                              end;
        
                              ///////////////////////////////////////////////////////// End of Supps Score Updates
                            Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                          //  AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
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
                          ACAExamSuppUnits."Total Score Decimal":=ROUND((GetSuppMaxScore(Progyz."Exam Category",(ROUND(ACAExamSuppUnits."Exam Score Decimal",0.01,'=')))),0.01,'=');
                              ACAExamSuppUnits."Total Score":=Format(ACAExamSuppUnits."Total Score Decimal");
                                end else if AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Special then begin
                              ACAExamSuppUnits."Exam Score Decimal":=ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'=');
                              ACAExamSuppUnits."Exam Score":=Format(ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'='));
                              ACAExamSuppUnits."CAT Score":=Format(ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExamSuppUnits."CAT Score Decimal":=ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                              ACAExamSuppUnits."Total Score Decimal":=GetSuppMaxScore(Progyz."Exam Category",(ROUND(AcaSpecialExamsDetails."Exam Marks"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=')));
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
                              //////////////////******************************************************
        
        // Check for Special Exams Score if Exists
        
                    Clear(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.Reset;
                            AcaSpecialExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SetRange("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Supplementary);
                           // AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                            if AcaSpecialExamsDetails.Find('-') then begin
                              if AcaSpecialExamsDetails."Exam Marks"<>0 then
                          ACAExamClassificationUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='))
                              else ACAExamClassificationUnits."Exam Score":='';
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                          if ACAExamResults_Fin.Score<>0 then
                            ACAExamClassificationUnits."CAT Score":=''
        //                  ACAExamClassificationUnits."CAT Score":=FORMAT(ROUND(ACAExamResults_Fin.Score,0.01,'='))
                          else ACAExamClassificationUnits."CAT Score":='';
                         // ACAExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                          ACAExamClassificationUnits."CAT Score Decimal":=0;
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
                          ACAExamClassificationUnits."Total Score":=Format(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*
                          ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                              end;
                              //////////////////////*******************************************************
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
        
                              if AcaSpecialExamsDetails.Insert then ;
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
        /////////////////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            end;
              end;
              end;
              end;
              until RegularExamUnitsRegForSupp.Next = 0;
              end;
        
        /*
        Coregcs.RESET;
        Coregcs.SETFILTER(Programme,ProgFIls);
        Coregcs.SETFILTER("Academic Year",AcadYear);
        Coregcs.SETRANGE("Exclude from Computation",FALSE);
        Coregcs.SETRANGE("Supp/Special Exists",TRUE);
        IF RefRegularCoRegcs."Student Number"<>'' THEN BEGIN
        Coregcs.SETFILTER("Student No.",RefRegularCoRegcs."Student Number");
          END;
        IF Coregcs.FIND('-') THEN BEGIN
          CLEAR(TotalRecs);
        CLEAR(RemeiningRecs);
        CLEAR(CountedRecs);
        TotalRecs:=Coregcs.COUNT;
        RemeiningRecs:=TotalRecs;
          // Loop through all Ungraduated Students Units
          Progressbar.OPEN('#1#####################################################\'+
          '#2############################################################\'+
          '#3###########################################################\'+
          '#4############################################################\'+
          '#5###########################################################\'+
          '#6############################################################');
             Progressbar.UPDATE(1,'Processing  values....');
             Progressbar.UPDATE(2,'Total Recs.: '+FORMAT(TotalRecs));
          REPEAT
            BEGIN
        
            CountedRecs:=CountedRecs+1;
            RemeiningRecs:=RemeiningRecs-1;
            // Create Registration Unit entry if Not Exists
             Progressbar.UPDATE(3,'.....................................................');
             Progressbar.UPDATE(4,'Processed: '+FORMAT(CountedRecs));
             Progressbar.UPDATE(5,'Remaining: '+FORMAT(RemeiningRecs));
             Progressbar.UPDATE(6,'----------------------------------------------------');
                Progyz.RESET;
                Progyz.SETFILTER(Code,Coregcs.Programme);
             IF Progyz.FIND('-') THEN BEGIN
               END;
               CLEAR(YosStages);
            IF Coregcs."Year Of Study"=0 THEN  BEGIN Coregcs.VALIDATE(Stage);
              Coregcs.MODIFY;
              END;
            IF Coregcs."Year Of Study"=1 THEN YosStages:='Y1S1|Y1S2|Y1S3|Y1S4'
            ELSE IF Coregcs."Year Of Study"=2 THEN YosStages:='Y2S1|Y2S2|Y2S3|Y2S4'
            ELSE IF Coregcs."Year Of Study"=3 THEN YosStages:='Y3S1|Y3S2|Y3S3|Y3S4'
            ELSE IF Coregcs."Year Of Study"=4 THEN YosStages:='Y4S1|Y4S2|Y4S3|Y4S4'
            ELSE IF Coregcs."Year Of Study"=5 THEN YosStages:='Y5S1|Y5S2|Y5S3|Y5S4'
            ELSE IF Coregcs."Year Of Study"=6 THEN YosStages:='Y6S1|Y6S2|Y6S3|Y6S4'
            ELSE IF Coregcs."Year Of Study"=7 THEN YosStages:='Y7S1|Y7S2|Y7S3|Y7S4'
            ELSE IF Coregcs."Year Of Study"=8 THEN YosStages:='Y8S1|Y8S2|Y8S3|Y8S4';
        
        
        Custos.RESET;
        Custos.SETRANGE("No.",Coregcs."Student No.");
        IF Custos.FIND('-') THEN
        Custos.CALCFIELDS("Senate Classification Based on");
        CLEAR(StudentUnits);
        StudentUnits.RESET;
        StudentUnits.SETRANGE("Student No.",Coregcs."Student No.");
        StudentUnits.SETRANGE("Year Of Study",Coregcs."Year Of Study");
        //StudentUnits.SETRANGE("Academic Year Exclude Comp.",FALSE);
        //StudentUnits.SETRANGE("Reg. Reversed",FALSE);
        StudentUnits.SETFILTER(Unit,'<>%1','');
        Coregcs.CALCFIELDS("Stoppage Exists In Acad. Year","Stoppage Exists in YoS","Stopped Academic Year","Stopage Yearly Remark");
              IF Coregcs."Stopped Academic Year" <>'' THEN BEGIN
               IF Coregcs."Academic Year Exclude Comp."=FALSE THEN
              StudentUnits.SETFILTER("Academic Year (Flow)",'=%1|=%2',Coregcs."Stopped Academic Year",Coregcs."Academic Year");
               END
              ELSE
              StudentUnits.SETFILTER("Academic Year (Flow)",'=%1',Coregcs."Academic Year");
        
           CLEAR(CountedRegistrations);
           CLEAR(Coregcsz10);
           Coregcsz10.RESET;
           Coregcsz10.SETRANGE("Student No.",Coregcs."Student No.");
           Coregcsz10.SETRANGE("Year Of Study",Coregcs."Year Of Study");
           Coregcsz10.SETRANGE(Reversed,FALSE);
           Coregcsz10.SETFILTER(Stage,'..%1',Coregcs.Stage);
           IF Coregcsz10.FIND('-') THEN BEGIN
            CountedRegistrations := Coregcsz10.COUNT;
            IF CountedRegistrations <2 THEN // Filter
          StudentUnits.SETRANGE(Stage,Coregcs.Stage);
           END;
        IF StudentUnits.FIND('-') THEN BEGIN
        
          REPEAT
            BEGIN
             StudentUnits.CALCFIELDS(StudentUnits."CATs Marks Exists");
             IF StudentUnits."CATs Marks Exists"=FALSE THEN BEGIN
              UnitsSubjects.RESET;
              UnitsSubjects.SETRANGE("Programme Code",StudentUnits.Programme);
              UnitsSubjects.SETRANGE(Code,StudentUnits.Unit);
              UnitsSubjects.SETRANGE("Exempt CAT",TRUE);
              IF UnitsSubjects.FIND('-') THEN BEGIN
                 ExamResults.INIT;
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
                IF  ExamResults.INSERT THEN;
                 END;
                 END;
                CLEAR(ExamResults); ExamResults.RESET;
            ExamResults.SETRANGE("Student No.",StudentUnits."Student No.");
            ExamResults.SETRANGE(Unit,StudentUnits.Unit);
            IF ExamResults.FIND('-') THEN BEGIN
                REPEAT
                    BEGIN
                       IF ExamResults.ExamType<>'' THEN BEGIN
           ExamResults.Exam:=ExamResults.ExamType;
           ExamResults.MODIFY;
           END ELSE  IF ExamResults.Exam<>'' THEN BEGIN
             IF ExamResults.ExamType='' THEN BEGIN
           ExamResults.RENAME(ExamResults."Student No.",ExamResults.Programme,ExamResults.Stage,
           ExamResults.Unit,ExamResults.Semester,ExamResults.Exam,ExamResults."Reg. Transaction ID",ExamResults."Entry No");
           END;
           END;
                    END;
                  UNTIL ExamResults.NEXT = 0;
              END;
                    ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii Update Units
            CLEAR(ExamResults);
            ExamResults.RESET;
            ExamResults.SETFILTER("Counted Occurances",'>%1',1);
            ExamResults.SETRANGE("Student No.",StudentUnits."Student No.");
            ExamResults.SETRANGE(Unit,StudentUnits.Unit);
            IF ExamResults.FIND('-') THEN BEGIN
              REPEAT
                BEGIN
                ACAExamResultsFin.RESET;
                ACAExamResultsFin.SETRANGE("Student No.",StudentUnits."Student No.");
                ACAExamResultsFin.SETRANGE(Programme,StudentUnits.Programme);
                ACAExamResultsFin.SETRANGE(Unit,StudentUnits.Unit);
                ACAExamResultsFin.SETRANGE(Semester,StudentUnits.Semester);
                ACAExamResultsFin.SETRANGE(ExamType,ExamResults.ExamType);
                IF ACAExamResultsFin.FIND('-') THEN BEGIN
                  ACAExamResultsFin.CALCFIELDS("Counted Occurances");
                  IF ACAExamResultsFin."Counted Occurances">1 THEN BEGIN
                      ACAExamResultsFin.DELETE;
                    END;
                  END;
                END;
                UNTIL ExamResults.NEXT=0;
                END;
          ////////////////////////////////// Remove Multiple Occurances of a Mark
        // // // // // // // // // // // //    ////////////////////////////////////////////////////////////////////////////
        // // // // // // // // // // // //    //  Supp. Headers
        // // // // // // // // // // // //
        // // // // // // // // // // // //            ACAResultsStatus.RESET;
        // // // // // // // // // // // //            ACAResultsStatus.SETRANGE("Special Programme Class",Progyz."Special Programme Class");
        // // // // // // // // // // // //            ACAResultsStatus.SETRANGE("Academic Year",Coregcs."Academic Year");
        // // // // // // // // // // // //            IF ACAResultsStatus.FIND('-') THEN BEGIN
        // // // // // // // // // // // //              REPEAT
        // // // // // // // // // // // //                  BEGIN
        // // // // // // // // // // // //                  ACASenateReportsHeader.RESET;
        // // // // // // // // // // // //                  ACASenateReportsHeader.SETRANGE("Academic Year",Coregcs."Academic Year");
        // // // // // // // // // // // //                  ACASenateReportsHeader.SETRANGE("School Code",Progyz."School Code");
        // // // // // // // // // // // //                  ACASenateReportsHeader.SETRANGE("Classification Code",ACAResultsStatus.Code);
        // // // // // // // // // // // //                  ACASenateReportsHeader.SETRANGE("Programme Code",Progyz.Code);
        // // // // // // // // // // // //                  ACASenateReportsHeader.SETRANGE("Year of Study",Coregcs."Year Of Study");
        // // // // // // // // // // // //                  IF NOT (ACASenateReportsHeader.FIND('-')) THEN BEGIN
        // // // // // // // // // // // //                    ACASenateReportsHeader.INIT;
        // // // // // // // // // // // //                    ACASenateReportsHeader."Academic Year":=Coregcs."Academic Year";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Reporting Academic Year":=Coregcs."Academic Year";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Rubric Order":=ACAResultsStatus."Order No";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Programme Code":=Progyz.Code;
        // // // // // // // // // // // //                    ACASenateReportsHeader."School Code":=Progyz."School Code";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Year of Study":=Coregcs."Year Of Study";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Classification Code":=ACAResultsStatus.Code;
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
        // // // // // // // // // // // //                    ACASenateReportsHeader."IncludeVariable 1":=ACAResultsStatus."IncludeVariable 1";
        // // // // // // // // // // // //                    ACASenateReportsHeader."IncludeVariable 2":=ACAResultsStatus."IncludeVariable 2";
        // // // // // // // // // // // //                    ACASenateReportsHeader."IncludeVariable 3":=ACAResultsStatus."IncludeVariable 3";
        // // // // // // // // // // // //                    ACASenateReportsHeader."IncludeVariable 4":=ACAResultsStatus."IncludeVariable 4";
        // // // // // // // // // // // //                    ACASenateReportsHeader."IncludeVariable 5":=ACAResultsStatus."IncludeVariable 5";
        // // // // // // // // // // // //                    ACASenateReportsHeader."IncludeVariable 6":=ACAResultsStatus."IncludeVariable 6";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Summary Page Caption":=ACAResultsStatus."Summary Page Caption";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Include Failed Units Headers":=ACAResultsStatus."Include Failed Units Headers";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Include Academic Year Caption":=ACAResultsStatus."Include Academic Year Caption";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Academic Year Text":=ACAResultsStatus."Academic Year Text";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg1":=ACAResultsStatus."Status Msg1";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg2":=ACAResultsStatus."Status Msg2";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg3":=ACAResultsStatus."Status Msg3";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg4":=ACAResultsStatus."Status Msg4";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg5":=ACAResultsStatus."Status Msg5";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Status Msg6":=ACAResultsStatus."Status Msg6";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Grad. Status Msg 1":=ACAResultsStatus."Grad. Status Msg 1";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Grad. Status Msg 2":=ACAResultsStatus."Grad. Status Msg 2";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Grad. Status Msg 3":=ACAResultsStatus."Grad. Status Msg 3";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Grad. Status Msg 4":=ACAResultsStatus."Grad. Status Msg 4";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Grad. Status Msg 5":=ACAResultsStatus."Grad. Status Msg 5";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Grad. Status Msg 6":=ACAResultsStatus."Grad. Status Msg 6";
        // // // // // // // // // // // //                    ACASenateReportsHeader."Finalists Graduation Comments":=ACAResultsStatus."Finalists Grad. Comm. Degree";
        // // // // // // // // // // // //                    ACASenateReportsHeader."1st Year Grad. Comments":=ACAResultsStatus."1st Year Grad. Comments";
        // // // // // // // // // // // //                    ACASenateReportsHeader."2nd Year Grad. Comments":=ACAResultsStatus."2nd Year Grad. Comments";
        // // // // // // // // // // // //                    ACASenateReportsHeader."3rd Year Grad. Comments":=ACAResultsStatus."3rd Year Grad. Comments";
        // // // // // // // // // // // //                    ACASenateReportsHeader."4th Year Grad. Comments":=ACAResultsStatus."4th Year Grad. Comments";
        // // // // // // // // // // // //                    ACASenateReportsHeader."5th Year Grad. Comments":=ACAResultsStatus."5th Year Grad. Comments";
        // // // // // // // // // // // //                    ACASenateReportsHeader."6th Year Grad. Comments":=ACAResultsStatus."6th Year Grad. Comments";
        // // // // // // // // // // // //                    ACASenateReportsHeader."7th Year Grad. Comments":=ACAResultsStatus."7th Year Grad. Comments";
        // // // // // // // // // // // //                  IF   ACASenateReportsHeader.INSERT THEN;
        // // // // // // // // // // // //                    END;
        // // // // // // // // // // // //                  END;
        // // // // // // // // // // // //                UNTIL ACAResultsStatus.NEXT=0;
        // // // // // // // // // // // //              END;
        // // // // // // // // // // // //    ////////////////////////////////////////////////////////////////////////////
        // // // // // // // // // // // //        ACAExamClassificationStuds.RESET;
        // // // // // // // // // // // //        ACAExamClassificationStuds.SETRANGE("Student Number",Coregcs."Student No.");
        // // // // // // // // // // // //        ACAExamClassificationStuds.SETRANGE(Programme,Coregcs.Programme);
        // // // // // // // // // // // //        ACAExamClassificationStuds.SETRANGE("Academic Year",Coregcs."Academic Year");
        // // // // // // // // // // // //        IF NOT ACAExamClassificationStuds.FIND('-') THEN BEGIN
        // // // // // // // // // // // //        ACAExamClassificationStuds.INIT;
        // // // // // // // // // // // //        ACAExamClassificationStuds."Student Number":=Coregcs."Student No.";
        // // // // // // // // // // // //        ACAExamClassificationStuds."Reporting Academic Year":=Coregcs."Academic Year";
        // // // // // // // // // // // //        ACAExamClassificationStuds."School Code":=Progyz."School Code";
        // // // // // // // // // // // //        ACAExamClassificationStuds.Department:=Progyz."Department Code";
        // // // // // // // // // // // //        ACAExamClassificationStuds."Programme Option":=Coregcs.Options;
        // // // // // // // // // // // //        ACAExamClassificationStuds.Programme:=Coregcs.Programme;
        // // // // // // // // // // // //        ACAExamClassificationStuds."Academic Year":=Coregcs."Academic Year";
        // // // // // // // // // // // //        ACAExamClassificationStuds."Year of Study":=Coregcs."Year Of Study";
        // // // // // // // // // // // //      ACAExamClassificationStuds."School Name":=GetDepartmentNameOrSchool(Progyz."School Code");
        // // // // // // // // // // // //      ACAExamClassificationStuds."Student Name":=GetStudentName(Coregcs."Student No.");
        // // // // // // // // // // // //      ACAExamClassificationStuds.Cohort:=GetCohort(Coregcs."Student No.",Coregcs.Programme);
        // // // // // // // // // // // //      ACAExamClassificationStuds."Final Stage":=GetFinalStage(Coregcs.Programme);
        // // // // // // // // // // // //      ACAExamClassificationStuds."Final Academic Year":=GetFinalAcademicYear(Coregcs."Student No.",Coregcs.Programme);
        // // // // // // // // // // // //      ACAExamClassificationStuds."Final Year of Study":=GetFinalYearOfStudy(Coregcs.Programme);
        // // // // // // // // // // // //      ACAExamClassificationStuds."Admission Date":=GetAdmissionDate(Coregcs."Student No.",Coregcs.Programme);
        // // // // // // // // // // // //      ACAExamClassificationStuds."Admission Academic Year":=GetAdmissionAcademicYear(Coregcs."Student No.",Coregcs.Programme);
        // // // // // // // // // // // //      ACAExamClassificationStuds.Graduating:=FALSE;
        // // // // // // // // // // // //      ACAExamClassificationStuds.Classification:='';
        // // // // // // // // // // // //        IF ACAExamClassificationStuds.INSERT THEN;
        // // // // // // // // // // // //
        // // // // // // // // // // // //    END;
        // // // // // // // // // // // //        /////////////////////////////////////// YoS Tracker
        // // // // // // // // // // // //        Progyz.RESET;
        // // // // // // // // // // // //        IF Progyz.GET(Coregcs.Programme) THEN;
        // // // // // // // // // // // //        ACAExamCourseRegistration.RESET;
        // // // // // // // // // // // //        ACAExamCourseRegistration.SETRANGE("Student Number",Coregcs."Student No.");
        // // // // // // // // // // // //        ACAExamCourseRegistration.SETRANGE(Programme,Coregcs.Programme);
        // // // // // // // // // // // //        ACAExamCourseRegistration.SETRANGE("Year of Study",Coregcs."Year Of Study");
        // // // // // // // // // // // //        ACAExamCourseRegistration.SETRANGE("Academic Year",Coregcs."Academic Year");
        // // // // // // // // // // // //        IF NOT ACAExamCourseRegistration.FIND('-') THEN BEGIN
        // // // // // // // // // // // //            ACAExamCourseRegistration.INIT;
        // // // // // // // // // // // //            ACAExamCourseRegistration."Student Number":=Coregcs."Student No.";
        // // // // // // // // // // // //            ACAExamCourseRegistration.Programme:=Coregcs.Programme;
        // // // // // // // // // // // //            ACAExamCourseRegistration."Year of Study":=Coregcs."Year Of Study";
        // // // // // // // // // // // //            ACAExamCourseRegistration."Reporting Academic Year":=Coregcs."Academic Year";
        // // // // // // // // // // // //            ACAExamCourseRegistration."Academic Year":=Coregcs."Academic Year";
        // // // // // // // // // // // //            ACAExamCourseRegistration."School Code":=Progyz."School Code";
        // // // // // // // // // // // //            ACAExamCourseRegistration."Programme Option":=Coregcs.Options;
        // // // // // // // // // // // //      ACAExamCourseRegistration."School Name":=ACAExamClassificationStuds."School Name";
        // // // // // // // // // // // //      ACAExamCourseRegistration."Student Name":=ACAExamClassificationStuds."Student Name";
        // // // // // // // // // // // //      ACAExamCourseRegistration.Cohort:=ACAExamClassificationStuds.Cohort;
        // // // // // // // // // // // //      ACAExamCourseRegistration."Final Stage":=ACAExamClassificationStuds."Final Stage";
        // // // // // // // // // // // //      ACAExamCourseRegistration."Final Academic Year":=ACAExamClassificationStuds."Final Academic Year";
        // // // // // // // // // // // //      ACAExamCourseRegistration."Final Year of Study":=ACAExamClassificationStuds."Final Year of Study";
        // // // // // // // // // // // //      ACAExamCourseRegistration."Admission Date":=ACAExamClassificationStuds."Admission Date";
        // // // // // // // // // // // //      ACAExamCourseRegistration."Admission Academic Year":=ACAExamClassificationStuds."Admission Academic Year";
        // // // // // // // // // // // //
        // // // // // // // // // // // //  IF ((Progyz.Category=Progyz.Category::"Certificate ") OR
        // // // // // // // // // // // //     (Progyz.Category=Progyz.Category::"Course List") OR
        // // // // // // // // // // // //     (Progyz.Category=Progyz.Category::Professional)) THEN BEGIN
        // // // // // // // // // // // //      ACAExamCourseRegistration."Category Order":=2;
        // // // // // // // // // // // //      END ELSE IF (Progyz.Category=Progyz.Category::Diploma) THEN BEGIN
        // // // // // // // // // // // //      ACAExamCourseRegistration."Category Order":=3;
        // // // // // // // // // // // //        END  ELSE IF (Progyz.Category=Progyz.Category::Postgraduate) THEN BEGIN
        // // // // // // // // // // // //      ACAExamCourseRegistration."Category Order":=4;
        // // // // // // // // // // // //        END  ELSE IF (Progyz.Category=Progyz.Category::Undergraduate) THEN BEGIN
        // // // // // // // // // // // //      ACAExamCourseRegistration."Category Order":=1;
        // // // // // // // // // // // //        END;
        // // // // // // // // // // // //
        // // // // // // // // // // // //      ACAExamCourseRegistration.Graduating:=FALSE;
        // // // // // // // // // // // //      ACAExamCourseRegistration.Classification:='';
        // // // // // // // // // // // //          IF  ACAExamCourseRegistration.INSERT THEN;
        // // // // // // // // // // // //          END;
              //Get best CAT Marks
              StudentUnits."Unit not in Catalogue":=FALSE;
              CLEAR(UnitsSubjects);
              UnitsSubjects.RESET;
              UnitsSubjects.SETRANGE("Programme Code",StudentUnits.Programme);
              UnitsSubjects.SETRANGE(Code,StudentUnits.Unit);
              IF UnitsSubjects.FIND('-') THEN BEGIN
        
                IF UnitsSubjects."Default Exam Category"='' THEN UnitsSubjects."Default Exam Category":=Progyz."Exam Category";
                IF UnitsSubjects."Exam Category"='' THEN UnitsSubjects."Exam Category":=Progyz."Exam Category";
                UnitsSubjects.MODIFY;
                ACAExamClassificationUnits.RESET;
                ACAExamClassificationUnits.SETRANGE("Student No.",StudentUnits."Student No.");
                ACAExamClassificationUnits.SETRANGE(Programme,StudentUnits.Programme);
                ACAExamClassificationUnits.SETRANGE("Unit Code",StudentUnits.Unit);
                ACAExamClassificationUnits.SETRANGE("Academic Year",Coregcs."Academic Year");
                IF NOT ACAExamClassificationUnits.FIND('-') THEN BEGIN
                    ACAExamClassificationUnits.INIT;
                    ACAExamClassificationUnits."Student No.":=Coregcs."Student No.";
                    ACAExamClassificationUnits.Programme:=Coregcs.Programme;
                    ACAExamClassificationUnits."Reporting Academic Year":=Coregcs."Academic Year";
                    ACAExamClassificationUnits."School Code":=Progyz."School Code";
                    ACAExamClassificationUnits."Unit Code":=StudentUnits.Unit;
                    ACAExamClassificationUnits."Credit Hours":=UnitsSubjects."No. Units";
                    ACAExamClassificationUnits."Unit Type":=FORMAT(UnitsSubjects."Unit Type");
                    ACAExamClassificationUnits."Unit Description":=UnitsSubjects.Desription;
                    ACAExamClassificationUnits."Year of Study":=ACAExamCourseRegistration."Year of Study";
                    ACAExamClassificationUnits."Academic Year":=Coregcs."Academic Year";
        
                        CLEAR(ExamResults); ExamResults.RESET;
                        ExamResults.SETRANGE("Student No.",StudentUnits."Student No.");
                        ExamResults.SETRANGE(Unit,StudentUnits.Unit);
                          IF ExamResults.FIND('-') THEN BEGIN
                            ExamResults.CALCFIELDS("Number of Repeats","Number of Resits");
                            IF ExamResults."Number of Repeats">0 THEN
                            ACAExamClassificationUnits."No. of Repeats":=ExamResults."Number of Repeats"-1;
                            IF ExamResults."Number of Resits">0 THEN
                            ACAExamClassificationUnits."No. of Resits":=ExamResults."Number of Resits"-1;
                            END;
        
                   IF  ACAExamClassificationUnits.INSERT THEN ;
                  END;
        
                            /////////////////////////// Update Unit Score
                              CLEAR(ACAExamClassificationUnits);
                ACAExamClassificationUnits.RESET;
                ACAExamClassificationUnits.SETRANGE("Student No.",StudentUnits."Student No.");
                ACAExamClassificationUnits.SETRANGE(Programme,StudentUnits.Programme);
                ACAExamClassificationUnits.SETRANGE("Unit Code",StudentUnits.Unit);
                ACAExamClassificationUnits.SETRANGE("Academic Year",Coregcs."Academic Year");
                IF ACAExamClassificationUnits.FIND('-') THEN BEGIN
                  ACAExamClassificationUnits.CALCFIELDS("Is Supp. Unit");
                         CLEAR(ACAExamResults_Fin);
                  ACAExamResults_Fin.RESET;
                         ACAExamResults_Fin.SETRANGE("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SETRANGE(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SETRANGE(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SETFILTER(Exam,'%1|%2|%3|%4','EXAM','EXAM100','EXAMS','FINAL EXAM');
                         ACAExamResults_Fin.SETCURRENTKEY(Score);
                         IF ACAExamResults_Fin.FIND('+') THEN BEGIN
                           IF ACAExamClassificationUnits."Is Supp. Unit" = FALSE THEN BEGIN
                          ACAExamClassificationUnits."Exam Score":=FORMAT(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                          END ELSE BEGIN
                          ACAExamClassificationUnits."Exam Score":='0';
                          ACAExamClassificationUnits."Exam Score Decimal":=0;
                            END;
                           END;
                       //     END;
                            CLEAR(CATExists);
                         CLEAR(ACAExamResults_Fin);
                         ACAExamResults_Fin.RESET;
                         ACAExamResults_Fin.SETRANGE("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SETRANGE(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SETRANGE(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SETFILTER(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         ACAExamResults_Fin.SETCURRENTKEY(Score);
                         IF ACAExamResults_Fin.FIND('+') THEN BEGIN
                           IF ACAExamClassificationUnits."Is Supp. Unit" = FALSE THEN BEGIN
                          ACAExamClassificationUnits."CAT Score":=FORMAT(ROUND(ACAExamResults_Fin.Score,0.01,'='));
                          ACAExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                          END ELSE BEGIN
                          ACAExamClassificationUnits."CAT Score":='0';
                          ACAExamClassificationUnits."CAT Score Decimal":=0;
                            END;
                          CATExists:=TRUE;
                           END;
                          // END;
                         IF ACAExamClassificationUnits.MODIFY THEN;
                          // Check for Supp Marks if exists
                            CLEAR(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.RESET;
                            AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SETRANGE(Category,AcaSpecialExamsDetails.Category::Supplementary);
                            AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails.SETFILTER("Exam Marks",'<>%1',0);
                            IF AcaSpecialExamsDetails.FIND('-') THEN BEGIN
                          ACAExamClassificationUnits."Exam Score":=FORMAT(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                        //Update Total Marks
                        IF ((ACAExamClassificationUnits."Exam Score"='') AND (CATExists=FALSE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"None Exists";
                       END ELSE IF ((ACAExamClassificationUnits."Exam Score"='') AND (CATExists = TRUE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"CAT Only";
                       END  ELSE  IF ((ACAExamClassificationUnits."Exam Score"<>'') AND (CATExists=FALSE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"Exam Only";
                       END ELSE  IF ((ACAExamClassificationUnits."Exam Score"<>'') AND (CATExists = TRUE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"Both Exists";
                         END;
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",ACAExamClassificationUnits."Total Score Decimal");
                          ACAExamClassificationUnits."Total Score":=FORMAT(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                              END ELSE BEGIN
                        //Update Total Marks
                        IF ((ACAExamClassificationUnits."Exam Score"='') AND (ACAExamClassificationUnits."CAT Score"='')) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"None Exists";
                       END ELSE IF ((ACAExamClassificationUnits."Exam Score"='') AND (ACAExamClassificationUnits."CAT Score"<>'')) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"CAT Only";
                       END  ELSE  IF ((ACAExamClassificationUnits."Exam Score"<>'') AND (ACAExamClassificationUnits."CAT Score"='')) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"Exam Only";
                       END ELSE  IF ((ACAExamClassificationUnits."Exam Score"<>'') AND (ACAExamClassificationUnits."CAT Score"<>'')) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"Both Exists";
                         END;
                           IF ACAExamClassificationUnits."Is Supp. Unit" = FALSE THEN BEGIN
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score":=FORMAT(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
                         END ELSE BEGIN
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",ACAExamClassificationUnits."Total Score Decimal");
                          ACAExamClassificationUnits."Total Score":=FORMAT(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*ACAExamClassificationUnits."Total Score Decimal",0.01,'=');
        
                           END;
                                END;
        // Check for Special Exams Score if Exists
        
                    CLEAR(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.RESET;
                            AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SETRANGE(Category,AcaSpecialExamsDetails.Category::Special);
                            AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails.SETFILTER("Exam Marks",'<>%1',0);
                            IF AcaSpecialExamsDetails.FIND('-') THEN BEGIN
                              IF AcaSpecialExamsDetails."Exam Marks"<>0 THEN
                          ACAExamClassificationUnits."Exam Score":=FORMAT(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='))
                              ELSE ACAExamClassificationUnits."Exam Score":='';
                          ACAExamClassificationUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                          IF ACAExamResults_Fin.Score<>0 THEN
                          ACAExamClassificationUnits."CAT Score":=FORMAT(ROUND(ACAExamResults_Fin.Score,0.01,'='))
                          ELSE ACAExamClassificationUnits."CAT Score":='';
                          ACAExamClassificationUnits."CAT Score Decimal":=ROUND(ACAExamResults_Fin.Score,0.01,'=');
                        //Update Total Marks
                        IF ((ACAExamClassificationUnits."Exam Score"='') AND (CATExists=FALSE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"None Exists";
                       END ELSE IF ((ACAExamClassificationUnits."Exam Score"='') AND (CATExists = TRUE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"CAT Only";
                       END  ELSE  IF ((ACAExamClassificationUnits."Exam Score"<>'') AND (CATExists=FALSE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"Exam Only";
                       END ELSE  IF ((ACAExamClassificationUnits."Exam Score"<>'') AND (CATExists = TRUE)) THEN BEGIN
                          ACAExamClassificationUnits."Results Exists Status":=ACAExamClassificationUnits."Results Exists Status"::"Both Exists";
                         END;
                          ACAExamClassificationUnits."Total Score Decimal":=ROUND(ACAExamClassificationUnits."Exam Score Decimal"+
                          ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                          ACAExamClassificationUnits."Total Score":=FORMAT(ROUND(ACAExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACAExamClassificationUnits."Weighted Total Score":=ROUND(ACAExamClassificationUnits."Credit Hours"*
                          ACAExamClassificationUnits."Total Score Decimal"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
        
                              END;
        
                              ///////////////////////////////////////////////////////// End of Supps Score Updates
                            CLEAR(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.RESET;
                            AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SETFILTER("Exam Marks",'<>%1',0);
                            AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            IF AcaSpecialExamsDetails.FIND('-') THEN BEGIN
                              ACAExamSuppUnits.INIT;
                              ACAExamSuppUnits."Student No.":=StudentUnits."Student No.";
                              ACAExamSuppUnits."Unit Code":=ACAExamClassificationUnits."Unit Code";
                              ACAExamSuppUnits."Unit Description":=ACAExamClassificationUnits."Unit Description";
                              ACAExamSuppUnits."Unit Type":=ACAExamClassificationUnits."Unit Type";
                              ACAExamSuppUnits.Programme:=ACAExamClassificationUnits.Programme;
                              ACAExamSuppUnits."Academic Year":=ACAExamClassificationUnits."Academic Year";
                              ACAExamSuppUnits."Credit Hours":=ACAExamClassificationUnits."Credit Hours";
                              IF AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Supplementary THEN BEGIN
                              ACAExamSuppUnits."Exam Score":=FORMAT(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                              ACAExamSuppUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                              ACAExamSuppUnits."CAT Score":=FORMAT(ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExamSuppUnits."CAT Score Decimal":=ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                          ACAExamSuppUnits."Total Score Decimal":=ROUND((GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",(ROUND(ACAExamSuppUnits."Exam Score Decimal",0.01,'=')))),0.01,'=');
                              ACAExamSuppUnits."Total Score":=FORMAT(ACAExamSuppUnits."Total Score Decimal");
                                END ELSE IF AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Special THEN BEGIN
                              ACAExamSuppUnits."Exam Score Decimal":=ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'=');
                              ACAExamSuppUnits."Exam Score":=FORMAT(ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'='));
                              ACAExamSuppUnits."CAT Score":=FORMAT(ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExamSuppUnits."CAT Score Decimal":=ROUND(ACAExamClassificationUnits."CAT Score Decimal",0.01,'=');
                              ACAExamSuppUnits."Total Score Decimal":=GetSuppMaxScore(AcaSpecialExamsDetails,Progyz."Exam Category",(ROUND(AcaSpecialExamsDetails."Exam Marks"+ACAExamClassificationUnits."CAT Score Decimal",0.01,'=')));
                              ACAExamSuppUnits."Total Score":=FORMAT(ACAExamSuppUnits."Total Score Decimal");
                              END;
                              ACAExamSuppUnits."Exam Category":=ACAExamClassificationUnits."Exam Category";
                              ACAExamSuppUnits."Allow In Graduate":=TRUE;
                              ACAExamSuppUnits."Year of Study":=ACAExamClassificationUnits."Year of Study";
                              ACAExamSuppUnits.Cohort:=ACAExamClassificationUnits.Cohort;
                              ACAExamSuppUnits."School Code":=ACAExamClassificationUnits."School Code";
                              ACAExamSuppUnits."Department Code":=ACAExamClassificationUnits."Department Code";
                              IF ACAExamSuppUnits.INSERT THEN;
                          ACAExamClassificationUnits.MODIFY;
                              //  END;
                              END;
                              ACAExamClassificationUnits."Allow In Graduate":=TRUE;
                          ACAExamClassificationUnits.MODIFY;
                              /// Update Cummulative Resit
                              ACAExamClassificationUnits.CALCFIELDS(Grade,"Grade Comment","Comsolidated Prefix",Pass);
                     IF ACAExamClassificationUnits.Pass THEN BEGIN
                       // Remove from Cummulative Resits
                ACAExamCummulativeResit.RESET;
                ACAExamCummulativeResit.SETRANGE("Student Number",StudentUnits."Student No.");
                ACAExamCummulativeResit.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                ACAExamCummulativeResit.SETRANGE("Academic Year",Coregcs."Academic Year");
                IF ACAExamCummulativeResit.FIND('-') THEN ACAExamCummulativeResit.DELETEALL;
        // //
        // //            CLEAR(AcaSpecialExamsDetails);
        // //                    AcaSpecialExamsDetails.RESET;
        // //                    AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
        // //                    AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
        // //                    AcaSpecialExamsDetails.SETRANGE(Category,AcaSpecialExamsDetails.Category::Supplementary);
        // //                    AcaSpecialExamsDetails.SETFILTER("Exam Marks",'%1',0);
        // //                    IF AcaSpecialExamsDetails.FIND('-') THEN AcaSpecialExamsDetails.DELETEALL;
        
                                CLEAR(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.RESET;
                            Aca2ndSuppExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SETRANGE(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails.SETFILTER("Exam Marks",'%1',0);
                            IF Aca2ndSuppExamsDetails.FIND ('-') THEN Aca2ndSuppExamsDetails.DELETEALL;
                END ELSE BEGIN
                     // Student Failed Supp or Special. Register for the second Supp if first Supp Failed and 1st Supp if Special Failed
        
                                CLEAR(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.RESET;
                            Aca2ndSuppExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SETRANGE(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails.SETFILTER("Exam Marks",'%1',0);
                            IF Aca2ndSuppExamsDetails.FIND ('-') THEN Aca2ndSuppExamsDetails.DELETEALL;
                    //Aca2ndSuppExamsDetails3
                    CLEAR(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.RESET;
                            AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SETRANGE(Category,AcaSpecialExamsDetails.Category::Supplementary);
                            AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            IF NOT (AcaSpecialExamsDetails.FIND('-')) THEN BEGIN
                               //  Register Supp for Special that is Failed
                               // The Failed Unit is not in Supp Special, Register The Unit here
                              CLEAR(CountedSeq);
                              CLEAR(AcaSpecialExamsDetails3);
                               AcaSpecialExamsDetails3.RESET;
                            AcaSpecialExamsDetails3.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails3.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails3.SETCURRENTKEY(Sequence);
                            IF AcaSpecialExamsDetails3.FIND('+') THEN BEGIN
                              CountedSeq:=AcaSpecialExamsDetails3.Sequence;
                              END ELSE BEGIN
                              CountedSeq:=0;
                                END;
                                CountedSeq+=1;
                              AcaSpecialExamsDetails.INIT;
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
        
                    CLEAR(Aca2ndSuppExamsDetails4);
                            Aca2ndSuppExamsDetails4.RESET;
                            Aca2ndSuppExamsDetails4.SETRANGE("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails4.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails4.SETRANGE(Category,AcaSpecialExamsDetails4.Category::Special);
                            AcaSpecialExamsDetails4.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails4.SETRANGE("Exam Marks",0);
                            IF (Aca2ndSuppExamsDetails4.FIND('-')) THEN BEGIN
                              // Check if Allows Creation of Supp
        
                              IF AcaSpecialExamsDetails.INSERT THEN ;
                              END ELSE  BEGIN
                                END;
                              END ELSE BEGIN
                                // Failed 1st Supplementary, Create Second Supplementary Registration Entry here
                                CLEAR(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.RESET;
                            Aca2ndSuppExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SETRANGE(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            IF NOT (Aca2ndSuppExamsDetails.FIND('-')) THEN BEGIN //  Register 2nd Supp for 1st Supp that is Failed
                              CLEAR(CountedSeq);
                              CLEAR(Aca2ndSuppExamsDetails3);
                               Aca2ndSuppExamsDetails3.RESET;
                            Aca2ndSuppExamsDetails3.SETRANGE("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails3.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails3.SETRANGE(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails3.SETCURRENTKEY(Sequence);
                            IF Aca2ndSuppExamsDetails3.FIND('+') THEN BEGIN
                              CountedSeq:=Aca2ndSuppExamsDetails3.Sequence;
                              END ELSE BEGIN
                              CountedSeq:=0;
                                END;
                                CountedSeq+=1;
                              Aca2ndSuppExamsDetails.INIT;
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
        
                              IF Aca2ndSuppExamsDetails.INSERT THEN ;
                              END;
        
                                END;
                 BEGIN
                    ACAExamCummulativeResit.INIT;
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
                    IF ACAExamCummulativeResit.INSERT THEN;
                    END;
                    END;
                    // Update 1st & 2nd Supp
                              CLEAR(AcaSpecialExamsDetails3);
                               AcaSpecialExamsDetails3.RESET;
                            AcaSpecialExamsDetails3.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails3.SETRANGE(Semester,StudentUnits.Semester);
                            AcaSpecialExamsDetails3.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            IF AcaSpecialExamsDetails3.FIND THEN BEGIN
        // // //                      CLEAR(AcaSpecialExamsResults);
        // // //                      AcaSpecialExamsResults.RESET;
        // // //                      AcaSpecialExamsResults.SETRANGE("Student No.",StudentUnits."Student No.");
        // // //                      AcaSpecialExamsResults.SETRANGE(Unit,StudentUnits.Unit);
        // // //                      IF AcaSpecialExamsResults.FIND('-') THEN BEGIN
        // // //                        AcaSpecialExamsDetails3."Exam Marks":=AcaSpecialExamsResults.Score;
        // // //                      AcaSpecialExamsDetails3.MODIFY;
        // // //                        END;
        
                              END;
        
                              CLEAR(Aca2ndSuppExamsDetails3);
                               Aca2ndSuppExamsDetails3.RESET;
                            Aca2ndSuppExamsDetails3.SETRANGE("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails3.SETRANGE("Unit Code",StudentUnits.Unit);
                            AcaSpecialExamsDetails3.SETRANGE(Semester,StudentUnits.Semester);
                            IF Aca2ndSuppExamsDetails3.FIND('-') THEN BEGIN
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
                              END;
                                                //////////////////////////// Update Units Scores.. End
                END ELSE BEGIN
                  StudentUnits."Unit not in Catalogue":=TRUE;
                  END;
                  END;
                        IF  ACAExamClassificationUnits.MODIFY THEN;
          StudentUnits.MODIFY;
        
                   CLEAR(Progyz);
                        IF Progyz.GET(ACAExamCourseRegistration.Programme) THEN;
                        CLEAR(ACAExamCourseRegistration4SuppGeneration);
                        ACAExamCourseRegistration4SuppGeneration.RESET;
                        ACAExamCourseRegistration4SuppGeneration.SETRANGE("Student Number",ACAExamClassificationUnits."Student No.");
                        ACAExamCourseRegistration4SuppGeneration.SETRANGE("Year of Study",ACAExamClassificationUnits."Year of Study");
                        ACAExamCourseRegistration4SuppGeneration.SETRANGE("Academic Year",ACAExamClassificationUnits."Academic Year");
                        ACAExamCourseRegistration4SuppGeneration.SETRANGE(Programme,ACAExamClassificationUnits.Programme);
                        IF ACAExamCourseRegistration4SuppGeneration.FIND('-') THEN;
                         //  Check if Rubric Allows for Generation of supp..
                         CLEAR(ACAResultsStatusSuppGen);
             ACAResultsStatusSuppGen.RESET;
             ACAResultsStatusSuppGen.SETRANGE(Code,ACAExamCourseRegistration4SuppGeneration.Classification);
             ACAResultsStatusSuppGen.SETRANGE("Academic Year",ACAExamCourseRegistration4SuppGeneration."Academic Year");
             ACAResultsStatusSuppGen.SETRANGE("Special Programme Class",Progyz."Special Programme Class");
             IF ACAResultsStatusSuppGen.FIND('-') THEN;
            //   Check if the Ststus does not allow Supp. Generation and delete
              IF ACAResultsStatusSuppGen."Skip Supp Generation" = FALSE THEN BEGIN
                /////////////////////////////////////// end of YoS Tracker
        
                            CLEAR(AcaSpecialExamsDetails);
                            AcaSpecialExamsDetails.RESET;
                            AcaSpecialExamsDetails.SETRANGE("Student No.",StudentUnits."Student No.");
                            AcaSpecialExamsDetails.SETRANGE("Unit Code",ACAExamClassificationUnits."Unit Code");
                            AcaSpecialExamsDetails.SETFILTER("Exam Marks",'%1',0);
                            AcaSpecialExamsDetails.SETRANGE(Semester,StudentUnits.Semester);
                            IF AcaSpecialExamsDetails.FIND('-') THEN AcaSpecialExamsDetails.DELETEALL;
                END;
                ///////////////////////////////////////////////////////////////// iiiiiiiiiiiiiiiiiiiiiiii End of Finalize Units
        END;
        
            UNTIL StudentUnits.NEXT=0;
          END;
        
        END;
        UNTIL Coregcs.NEXT=0;
            Progressbar.CLOSE;
        END;
        */
        
        
        // Update Averages
        Clear(TotalRecs);
        Clear(CountedRecs);
        Clear(RemeiningRecs);
        Clear(ACAExamClassificationStuds);
        Clear(ACAExamCourseRegistration);
        ACAExamCourseRegistration.Reset;
         ACAExamCourseRegistration.SetFilter("Reporting Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamCourseRegistration.SetFilter("Student Number",RefRegularCoRegcs."Student Number");
        if ACAExamCourseRegistration.Find('-') then begin
          TotalRecs:=ACAExamCourseRegistration.Count;
          RemeiningRecs:=TotalRecs;
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
                  ACAExamCourseRegistration."Required Stage Units":=ACAExamCourseRegistration."Defined Units (Flow)";
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
                   ACAExamCourseRegistration."Final Classification Pass":=false;
                   ACAExamCourseRegistration."Final Classification Order":=10;
                   ACAExamCourseRegistration.Graduating:=false;
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
                  ACAExamCourseRegistration."Cumm. Required Stage Units":=GetCummulativeReqStageUnitrs(ACAExamCourseRegistration.Programme,ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration."Programme Option",
                  ACAExamCourseRegistration."Academic Year");
                  ACAExamCourseRegistration."Cumm Attained Units":=GetCummAttainedUnits(ACAExamCourseRegistration."Student Number",ACAExamCourseRegistration."Year of Study",ACAExamCourseRegistration.Programme);
                   ACAExamCourseRegistration.Modify(true);
                            ACAExamCourseRegistration.CalcFields("Skip Supplementary Generation");
        
                Clear(Aca2ndSuppExamsDetailsforSupps);
                Aca2ndSuppExamsDetailsforSupps.Reset;
                Aca2ndSuppExamsDetailsforSupps.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                Aca2ndSuppExamsDetailsforSupps.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
                Aca2ndSuppExamsDetailsforSupps.SetRange("Unit Code",RegularExamUnitsRegForSupp."Unit Code");
                Aca2ndSuppExamsDetailsforSupps.SetFilter("Exam Marks",'=%1',0);
                if Aca2ndSuppExamsDetailsforSupps.Find('-') then Aca2ndSuppExamsDetailsforSupps.DeleteAll;
                     Delete2ndSupplementaryMarks(ACAExamCourseRegistration);
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
                     end else begin
                     //ERROR(ACAExamCourseRegistration."Student Number");
                     Update2ndSupplementaryMarks(ACAExamCourseRegistration);
                     // Update 2nd Supp Registrations
                     ////////////////...................................................................
                     Clear(RegularExamUnitsRegForSupp);
        RegularExamUnitsRegForSupp.Reset;
        RegularExamUnitsRegForSupp.SetRange(RegularExamUnitsRegForSupp."Student No.",RefRegularCoRegcs."Student Number");
        RegularExamUnitsRegForSupp.SetRange(RegularExamUnitsRegForSupp.Programme,RefRegularCoRegcs.Programme);
        RegularExamUnitsRegForSupp.SetRange(RegularExamUnitsRegForSupp."Academic Year",RefRegularCoRegcs."Academic Year");
        RegularExamUnitsRegForSupp.SetFilter(Pass,'=%1',false);
        if RegularExamUnitsRegForSupp.Find('-') then begin
          repeat
              begin
                  Clear(StudentUnits);
                  StudentUnits.Reset;
                  StudentUnits.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                  StudentUnits.SetRange(Unit,RegularExamUnitsRegForSupp."Unit Code");
                  StudentUnits.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
                  StudentUnits.SetRange("Academic Year (Flow)",RegularExamUnitsRegForSupp."Academic Year");
                  if StudentUnits.Find('-') then begin
        
                                  Clear(CATExists);
                               Clear(ACAExamResults_Fin);
                               ACAExamResults_Fin.Reset;
                               ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                               ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                               ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                               ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                               ACAExamResults_Fin.SetCurrentkey(Score);
                               if ACAExamResults_Fin.Find('+') then begin
                                 CATExists := true;
                                 end;
                   Coregcs.Reset;
                Coregcs.SetFilter(Programme,RegularExamUnitsRegForSupp.Programme);
                Coregcs.SetFilter("Academic Year",RegularExamUnitsRegForSupp."Academic Year");
                Coregcs.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                Coregcs.SetRange(Semester,StudentUnits.Semester);
                if Coregcs.Find('-') then begin
                Clear(Aca2ndSuppExamsDetailsforSupps);
                Aca2ndSuppExamsDetailsforSupps.Reset;
                Aca2ndSuppExamsDetailsforSupps.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                Aca2ndSuppExamsDetailsforSupps.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
                Aca2ndSuppExamsDetailsforSupps.SetRange("Unit Code",RegularExamUnitsRegForSupp."Unit Code");
                Aca2ndSuppExamsDetailsforSupps.SetRange(Semester,StudentUnits.Semester);
                if not (Aca2ndSuppExamsDetailsforSupps.Find('-')) then begin
        
                Clear(Aca2ndSuppExamsDetailsforSupps);
                Aca2ndSuppExamsDetailsforSupps.Reset;
                Aca2ndSuppExamsDetailsforSupps.SetRange("Student No.",RegularExamUnitsRegForSupp."Student No.");
                Aca2ndSuppExamsDetailsforSupps.SetRange(Programme,RegularExamUnitsRegForSupp.Programme);
                Aca2ndSuppExamsDetailsforSupps.SetRange("Unit Code",RegularExamUnitsRegForSupp."Unit Code");
                if Aca2ndSuppExamsDetailsforSupps.Find('-') then begin
                if Aca2ndSuppExamsDetailsforSupps.Rename(Aca2ndSuppExamsDetailsforSupps."Student No.",Aca2ndSuppExamsDetailsforSupps."Unit Code",
                Aca2ndSuppExamsDetailsforSupps."Academic Year",StudentUnits.Semester,Aca2ndSuppExamsDetailsforSupps.Sequence) then;
                end else begin
                Aca2ndSuppExamsDetailsforSupps.Init;
                Aca2ndSuppExamsDetailsforSupps."Student No." := RegularExamUnitsRegForSupp."Student No.";
                Aca2ndSuppExamsDetailsforSupps."Unit Code" := StudentUnits.Unit;
                Aca2ndSuppExamsDetailsforSupps."Academic Year" := RegularExamUnitsRegForSupp."Academic Year";
                Aca2ndSuppExamsDetailsforSupps.Semester := StudentUnits.Semester;
                Aca2ndSuppExamsDetailsforSupps.Stage := Coregcs.Stage;
                Aca2ndSuppExamsDetailsforSupps.Programme := RegularExamUnitsRegForSupp.Programme;
                if Aca2ndSuppExamsDetailsforSupps.Insert then;
                end;
                end;
                end; //Coregcs
               end; //StudentUnits
           end; //Repeat
        until RegularExamUnitsRegForSupp.Next=0;
        end;
        
                     //...........................................................................................
        
                     end;
        
                      end;
                      until ACAExamCourseRegistration.Next=0;
                  end;
        
                /*  CLEAR(ACASenateReportsHeader);
                    ACASenateReportsHeader.RESET;
                    ACASenateReportsHeader.SETFILTER("Programme Code",ProgFIls);
                    ACASenateReportsHeader.SETFILTER("Reporting Academic Year",Coregcs."Academic Year");
                    IF ACASenateReportsHeader.FIND('-') THEN BEGIN
                      ProgBar22.OPEN('#1##########################################');
                      REPEAT
                          BEGIN
                          ProgBar22.UPDATE(1,'Student Number: '+ACASenateReportsHeader."Programme Code"+' Class: '+ACASenateReportsHeader."Classification Code");
                          WITH ACASenateReportsHeader DO
                            BEGIN
                              ACASenateReportsHeader.CALCFIELDS("School Classification Count","School Total Passed","School Total Passed",
                              "School Total Failed","Programme Classification Count","Programme Total Passed","Programme Total Failed","School Total Count",
                              "Prog. Total Count");
        
                              CALCFIELDS("School Classification Count","School Total Passed","School Total Failed","School Total Count",
                              "Programme Classification Count","Prog. Total Count","Programme Total Failed","Programme Total Passed");
                              IF "School Total Count">0 THEN
                              "Sch. Class % Value":=ROUND((("School Classification Count"/"School Total Count")*100),0.01,'=');
                              IF "School Total Count">0 THEN
                              "School % Failed":=ROUND((("School Total Failed"/"School Total Count")*100),0.01,'=');
                              IF "School Total Count">0 THEN
                              "School % Passed":=ROUND((("School Total Passed"/"School Total Count")*100),0.01,'=');
                              IF "Prog. Total Count">0 THEN
                              "Prog. Class % Value":=ROUND((("Programme Classification Count"/"Prog. Total Count")*100),0.01,'=');
                              IF "Prog. Total Count">0 THEN
                              "Programme % Failed":=ROUND((("Programme Total Failed"/"Prog. Total Count")*100),0.01,'=');
                              IF "Prog. Total Count">0 THEN
                              "Programme % Passed":=ROUND((("Programme Total Passed"/"Prog. Total Count")*100),0.01,'=');
                              END;
                              ACASenateReportsHeader.MODIFY;
                          END;
                        UNTIL ACASenateReportsHeader.NEXT=0;
                        ProgBar22.CLOSE;
                        END;*/
         // Update2ndSupplementaryMarks;

    end;

    local procedure DeleteSuppPreviousEntries(RefRegularCoRegcs: Record UnknownRecord66651)
    var
        RegularExamUnitsRegForSupp: Record UnknownRecord66650;
        ACAResultsStatus: Record UnknownRecord69266;
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
        Progyz: Record UnknownRecord61511;
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
        ACAExamClassificationUnits: Record UnknownRecord66641;
        ACAExamCourseRegistration: Record UnknownRecord66642;
        ACAExamFailedReasons: Record UnknownRecord66643;
        ACASenateReportsHeader: Record UnknownRecord66645;
        ACAExamClassificationStuds: Record UnknownRecord66644;
        ACAExamClassificationStudsCheck: Record UnknownRecord66644;
        ACAExamResultsFin: Record UnknownRecord61548;
        ACAResultsStatusSuppGen: Record UnknownRecord61739;
        ProgressForCoReg: Dialog;
        Tens: Text;
        ACASemesters: Record UnknownRecord61692;
        ACAExamResults_Fin: Record UnknownRecord61548;
        Coregcs: Record UnknownRecord61532;
        ACAExamCummulativeResit: Record UnknownRecord66647;
        ACAStudentUnitsForResits: Record UnknownRecord61549;
        SEQUENCES: Integer;
        CurrStudentNo: Code[250];
        CountedNos: Integer;
        CurrSchool: Code[250];
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        Aca2ndSuppExamsResults: Record UnknownRecord78032;
        Aca2ndSuppExamsDetails3: Record UnknownRecord78031;
        Aca2ndSuppExamsDetails4: Record UnknownRecord78031;
        AcaSpecialExamsDetails4: Record UnknownRecord78002;
        ACAResultsStatusSupp: Record UnknownRecord69266;
    begin

        ProgFIls:=RefRegularCoRegcs.Programme;

        Clear(ACAExamClassificationStuds);
        Clear(ACAExamCourseRegistration);
        Clear(ACAExamClassificationUnits);
        Clear(ACAExamSuppUnits);
        ACAExamClassificationStuds.Reset;
        ACAExamCourseRegistration.Reset;
        ACAExamClassificationUnits.Reset;
        ACAExamSuppUnits.Reset;
        ACAExamClassificationStuds.SetFilter("Student Number",RefRegularCoRegcs."Student Number");
        ACAExamCourseRegistration.SetRange("Student Number",RefRegularCoRegcs."Student Number");
        ACAExamClassificationUnits.SetRange("Student No.",RefRegularCoRegcs."Student Number");
        ACAExamSuppUnits.SetRange("Student No.",RefRegularCoRegcs."Student Number");
        ACAExamClassificationStuds.SetFilter("Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamCourseRegistration.SetFilter("Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamClassificationUnits.SetFilter("Academic Year",RefRegularCoRegcs."Academic Year");
        ACAExamSuppUnits.SetFilter("Academic Year",AcadYear);

        ACAExamClassificationStuds.SetFilter(Programme,ProgFIls);
        ACAExamCourseRegistration.SetFilter(Programme,ProgFIls);
        ACAExamClassificationUnits.SetFilter(Programme,ProgFIls);
        ACAExamSuppUnits.SetFilter(Programme,ProgFIls);
        if ACAExamClassificationStuds.Find('-') then ACAExamClassificationStuds.DeleteAll;
        if ACAExamCourseRegistration.Find('-') then ACAExamCourseRegistration.DeleteAll;
        if ACAExamClassificationUnits.Find('-') then ACAExamClassificationUnits.DeleteAll;
        if ACAExamSuppUnits.Find('-') then ACAExamSuppUnits.DeleteAll;
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
        if CoursesRegz."Attained Stage Units" = 0 then StatusRemarks:='DTSC';
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

    local procedure GetSuppMaxScore(Categoryz: Code[250];Scorezs: Decimal) SuppScoreNormalized: Decimal
    var
        ACAExamCategory: Record UnknownRecord61568;
    begin
        SuppScoreNormalized:=Scorezs;
        //IF SuppDets.Category = SuppDets.Category::Supplementary THEN BEGIN
        ACAExamCategory.Reset;
        ACAExamCategory.SetRange(Code,Categoryz);
        if ACAExamCategory.Find('-') then begin
          if ACAExamCategory."Supplementary Max. Score"<>0 then begin
            if Scorezs>ACAExamCategory."Supplementary Max. Score" then
              SuppScoreNormalized:=ACAExamCategory."Supplementary Max. Score";
            end;
          end;
         // END;
    end;

    local procedure Update2ndSupplementaryMarks(ACASuppExamCoRegfor2ndSupp: Record UnknownRecord66642)
    var
        ACACourseRegistration777: Record UnknownRecord61532;
        CATExists: Boolean;
        Aca2ndSuppExamsDetails3: Record UnknownRecord78031;
        Aca2ndSuppExamsDetails888: Record UnknownRecord78031;
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        FirstSuppUnitsRegFor2ndSupp: Record UnknownRecord66641;
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
        AcademicYear_Fin333: Record UnknownRecord61382;
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
        CurrStudentNo: Code[250];
        CountedNos: Integer;
        CurrSchool: Code[250];
        CUrrentExamScore: Decimal;
        OriginalCatScores: Decimal;
        ACASuppExamClassUnits4Supp2: Record UnknownRecord66641;
        ACA2NDExamCreg: Record UnknownRecord66682;
    begin
        Clear(AcademicYear_Fin333);
        AcademicYear_Fin333.Reset;
        AcademicYear_Fin333.SetRange(Current,true);
        if AcademicYear_Fin333.Find('-') then begin
          end else Error('Current is missing in the Academic Year setup.');
         if not (GetAcademicYearDiff(ACASuppExamCoRegfor2ndSupp."Academic Year",AcademicYear_Fin333.Code)) then
           begin
           //  MESSAGE('Esc...');
              exit;
             end else begin
            //   MESSAGE('Ins..');
               end;
        Clear(ACACourseRegistration777);
        ACACourseRegistration777.Reset;
        ACACourseRegistration777.SetRange("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACACourseRegistration777.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACACourseRegistration777.SetRange("Year Of Study",ACASuppExamCoRegfor2ndSupp."Year of Study");
        ACACourseRegistration777.SetFilter(Options,'<>%1','');
        if ACACourseRegistration777.Find('-') then;
        ProgFIls:=ACASuppExamCoRegfor2ndSupp.Programme;
        ACA2NDExamClassificationStuds.Reset;
        ACA2NDExamCourseRegistration.Reset;
        ACA2NDExamClassificationUnits.Reset;
        ACAExam2NDSuppUnits.Reset;
        // IF StudNos<>'' THEN BEGIN
        // ACA2NDExamClassificationStuds.SETFILTER("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        // ACA2NDExamClassificationUnits.SETRANGE("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        // ACAExam2NDSuppUnits.SETFILTER("Student No.",StudNos);
        // END;
        ACA2NDExamClassificationStuds.SetFilter("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACA2NDExamClassificationUnits.SetRange("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACAExam2NDSuppUnits.SetFilter("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACA2NDExamCourseRegistration.SetRange("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACA2NDExamCourseRegistration.SetRange("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        //IF AcadYear<>'' THEN BEGIN
        ACA2NDExamClassificationStuds.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACA2NDExamCourseRegistration.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACA2NDExamClassificationUnits.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACAExam2NDSuppUnits.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        //END;

        ACA2NDExamClassificationStuds.SetFilter(Programme,ProgFIls);
        ACA2NDExamCourseRegistration.SetFilter(Programme,ProgFIls);
        ACA2NDExamClassificationUnits.SetFilter(Programme,ProgFIls);
        ACAExam2NDSuppUnits.SetFilter(Programme,ProgFIls);
        if ACA2NDExamClassificationStuds.Find('-') then ACA2NDExamClassificationStuds.DeleteAll;
        if ACA2NDExamCourseRegistration.Find('-') then ACA2NDExamCourseRegistration.DeleteAll;
        if ACA2NDExamClassificationUnits.Find('-') then ACA2NDExamClassificationUnits.DeleteAll;
        if ACAExam2NDSuppUnits.Find('-') then ACAExam2NDSuppUnits.DeleteAll;


                          ACA2NDSenateReportsHeader.Reset;
                          ACA2NDSenateReportsHeader.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
                          ACA2NDSenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                          if  (ACA2NDSenateReportsHeader.Find('-')) then ACA2NDSenateReportsHeader.DeleteAll;

            ////////////////////////////////////////////////////////////////////////////
            // Grad Headers
            Clear(Progyz);
            if Progyz.Get(ACASuppExamCoRegfor2ndSupp.Programme) then;
                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange("Special Programme Class",Progyz."Special Programme Class");
                    ACAResultsStatus.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
                    if ACAResultsStatus.Find('-') then begin
                      repeat
                          begin
                          ACA2NDSenateReportsHeader.Reset;
                          ACA2NDSenateReportsHeader.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
                          ACA2NDSenateReportsHeader.SetRange("School Code",Progyz."School Code");
                          ACA2NDSenateReportsHeader.SetRange("Classification Code",ACAResultsStatus.Code);
                          ACA2NDSenateReportsHeader.SetRange("Programme Code",Progyz.Code);
                          ACA2NDSenateReportsHeader.SetRange("Year of Study",ACASuppExamCoRegfor2ndSupp."Year of Study");
                          if not (ACA2NDSenateReportsHeader.Find('-')) then begin
                            ACA2NDSenateReportsHeader.Init;
                            ACA2NDSenateReportsHeader."Academic Year":=ACASuppExamCoRegfor2ndSupp."Academic Year";
                            ACA2NDSenateReportsHeader."Reporting Academic Year":=ACASuppExamCoRegfor2ndSupp."Academic Year";
                            ACA2NDSenateReportsHeader."Rubric Order":=ACAResultsStatus."Order No";
                            ACA2NDSenateReportsHeader."Programme Code":=Progyz.Code;
                            ACA2NDSenateReportsHeader."School Code":=Progyz."School Code";
                            ACA2NDSenateReportsHeader."Year of Study":=ACASuppExamCoRegfor2ndSupp."Year of Study";
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
                ACA2NDExamClassificationStuds.SetRange("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
                ACA2NDExamClassificationStuds.SetRange(Programme,Coregcs.Programme);
                ACA2NDExamClassificationStuds.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
                if not ACA2NDExamClassificationStuds.Find('-') then begin
                ACA2NDExamClassificationStuds.Init;
                ACA2NDExamClassificationStuds."Student Number":=ACASuppExamCoRegfor2ndSupp."Student Number";
                ACA2NDExamClassificationStuds."Reporting Academic Year":=ACASuppExamCoRegfor2ndSupp."Academic Year";
                ACA2NDExamClassificationStuds."School Code":=Progyz."School Code";
                ACA2NDExamClassificationStuds.Department:=Progyz."Department Code";
                ACA2NDExamClassificationStuds."Programme Option":=ACACourseRegistration777.Options;
                ACA2NDExamClassificationStuds.Programme:=ACASuppExamCoRegfor2ndSupp.Programme;
                ACA2NDExamClassificationStuds."Academic Year":=ACASuppExamCoRegfor2ndSupp."Academic Year";
                ACA2NDExamClassificationStuds."Year of Study":=ACASuppExamCoRegfor2ndSupp."Year of Study";
              ACA2NDExamClassificationStuds."School Name":=GetDepartmentNameOrSchool(Progyz."School Code");
              ACA2NDExamClassificationStuds."Student Name":=GetStudentName(ACASuppExamCoRegfor2ndSupp."Student Number");
              ACA2NDExamClassificationStuds.Cohort:=GetCohort(Coregcs."Student No.",ACASuppExamCoRegfor2ndSupp.Programme);
              ACA2NDExamClassificationStuds."Final Stage":=GetFinalStage(ACASuppExamCoRegfor2ndSupp.Programme);
              ACA2NDExamClassificationStuds."Final Academic Year":=GetFinalAcademicYear(Coregcs."Student No.",ACASuppExamCoRegfor2ndSupp.Programme);
              ACA2NDExamClassificationStuds."Final Year of Study":=GetFinalYearOfStudy(ACASuppExamCoRegfor2ndSupp.Programme);
              ACA2NDExamClassificationStuds."Admission Date":=GetAdmissionDate(Coregcs."Student No.",ACASuppExamCoRegfor2ndSupp.Programme);
              ACA2NDExamClassificationStuds."Admission Academic Year":=GetAdmissionAcademicYear(Coregcs."Student No.",ACASuppExamCoRegfor2ndSupp.Programme);
              ACA2NDExamClassificationStuds.Graduating:=false;
              ACA2NDExamClassificationStuds.Classification:='';

              Clear(ACASuppExamClassUnits4Supp2);
              ACASuppExamClassUnits4Supp2.Reset;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,ACASuppExamCoRegfor2ndSupp.Programme);
              ACASuppExamClassUnits4Supp2.SetRange("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",ACASuppExamCoRegfor2ndSupp."Year of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then
                if ACA2NDExamClassificationStuds.Insert then;

            end;
                /////////////////////////////////////// YoS Tracker
        //        ACA2NDExamCourseRegistration.RESET;
        //        //ACA2NDExamCourseRegistration.SETRANGE("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        //        ACA2NDExamCourseRegistration.SETRANGE("Student Number",ACACourseRegistration777."Student No.");
        //        ACA2NDExamCourseRegistration.SETRANGE(Programme,ACASuppExamCoRegfor2ndSupp.Programme);
        //        ACA2NDExamCourseRegistration.SETRANGE("Year of Study",ACASuppExamCoRegfor2ndSupp."Year of Study");
        //        ACA2NDExamCourseRegistration.SETRANGE("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        //        IF NOT ACA2NDExamCourseRegistration.FIND('-') THEN BEGIN
                    ACA2NDExamCourseRegistration.Init;
                    ACA2NDExamCourseRegistration."Student Number":=ACASuppExamCoRegfor2ndSupp."Student Number";
                    //ERROR(ACASuppExamCoRegfor2ndSupp."Student Number");
                    ACA2NDExamCourseRegistration.Programme:=ACASuppExamCoRegfor2ndSupp.Programme;
                    ACA2NDExamCourseRegistration."Year of Study":=ACASuppExamCoRegfor2ndSupp."Year of Study";
                    ACA2NDExamCourseRegistration."Reporting Academic Year":=ACASuppExamCoRegfor2ndSupp."Academic Year";
                    ACA2NDExamCourseRegistration."Academic Year":=ACASuppExamCoRegfor2ndSupp."Academic Year";
                    ACA2NDExamCourseRegistration."School Code":=Progyz."School Code";
                    ACA2NDExamCourseRegistration."Programme Option":=ACACourseRegistration777.Options;
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
              ACASuppExamClassUnits4Supp2.SetAutocalcFields(Pass);
              SupReviewToBecreated:=false;
              ACASuppExamClassUnits4Supp2.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
              ACASuppExamClassUnits4Supp2.SetRange(Programme,ACASuppExamCoRegfor2ndSupp.Programme);
             // ACASuppExamClassUnits4Supp2.SETRANGE("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
             ACASuppExamClassUnits4Supp2.SetRange("Student No.",ACACourseRegistration777."Student No.");
              ACASuppExamClassUnits4Supp2.SetRange("Year of Study",ACASuppExamCoRegfor2ndSupp."Year of Study");
              ACASuppExamClassUnits4Supp2.SetRange(Pass,false);
              if ACASuppExamClassUnits4Supp2.Find('-') then begin
                SupReviewToBecreated:=true;
        //        IF ACA2NDExamCourseRegistration."Student Name"='P102/0869G/19' THEN
        //        ERROR(ACA2NDExamCourseRegistration."Student Number");
                  if  ACA2NDExamCourseRegistration.Insert then;
                  end;
        //FORCE ACA2NDExamCourseRegistration insertion....Category Order,Student Number,Programme,Year of Study,Academic Year,School Code,Reporting Academic Year

        SecSup.Reset;
        SecSup.SetRange("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        SecSup.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        if SecSup.FindFirst then begin
        //    IF ACASuppExamCoRegfor2ndSupp."Student Number"='P102/0869G/19' THEN
        //           MESSAGE(ACA2NDExamCourseRegistration."Student Number");
            ACA2NDExamCreg.Reset;
            ACA2NDExamCreg.SetRange("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
            ACA2NDExamCreg.SetRange("Year of Study",ACASuppExamCoRegfor2ndSupp."Year of Study");
            ACA2NDExamCreg.SetRange("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
            if not ACA2NDExamCreg.FindFirst then begin
        //          IF ACASuppExamCoRegfor2ndSupp."Student Number"='P102/0869G/19' THEN
        //           MESSAGE(ACA2NDExamCourseRegistration."Student Number");
             if  ACA2NDExamCourseRegistration.Insert() then begin
        //                 IF ACASuppExamCoRegfor2ndSupp."Student Number"='P102/0869G/19' THEN
        //       MESSAGE('inserted');
               end else begin
        //                   IF ACASuppExamCoRegfor2ndSupp."Student Number"='P102/0869G/19' THEN
        //          MESSAGE('not inserted');
                 end;
              end else begin
        //                           IF ACASuppExamCoRegfor2ndSupp."Student Number"='P102/0869G/19' THEN
        //          MESSAGE('Exists');
                end;
              end;
              //COMMIT();
        // ACA2NDExamCourseRegistration.INSERT;
        //END;


                //  END;
                /////////////////////////////////////// end of YoS Tracker
                // Update Scores Here

        // Create Units for the Supp Registration ***********************************
        Clear(FirstSuppUnitsRegFor2ndSupp);
        FirstSuppUnitsRegFor2ndSupp.Reset;
        FirstSuppUnitsRegFor2ndSupp.SetRange(FirstSuppUnitsRegFor2ndSupp."Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        FirstSuppUnitsRegFor2ndSupp.SetRange(FirstSuppUnitsRegFor2ndSupp.Programme,ACASuppExamCoRegfor2ndSupp.Programme);
        FirstSuppUnitsRegFor2ndSupp.SetRange(FirstSuppUnitsRegFor2ndSupp."Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        if FirstSuppUnitsRegFor2ndSupp.Find('-') then begin
          repeat
            begin
            if FirstSuppUnitsRegFor2ndSupp."Unit Code" = 'MAT 317' then
            Clear(StudentUnits);
            Clear(StudentUnits);
            StudentUnits.Reset;
            StudentUnits.SetRange("Student No.",FirstSuppUnitsRegFor2ndSupp."Student No.");
            StudentUnits.SetRange(Unit,FirstSuppUnitsRegFor2ndSupp."Unit Code");
            StudentUnits.SetRange(Programme,FirstSuppUnitsRegFor2ndSupp.Programme);
            StudentUnits.SetRange("Academic Year (Flow)",FirstSuppUnitsRegFor2ndSupp."Academic Year");
            if StudentUnits.Find('-') then begin

                            Clear(CATExists);
                         Clear(ACAExamResults_Fin);
                         ACAExamResults_Fin.Reset;
                         ACAExamResults_Fin.SetRange("Student No.",StudentUnits."Student No.");
                         ACAExamResults_Fin.SetRange(Unit,StudentUnits.Unit);
                         ACAExamResults_Fin.SetRange(Semester,StudentUnits.Semester);
                         ACAExamResults_Fin.SetFilter(Exam,'%1|%2|%3','ASSIGNMENT','CAT','CATS');
                         ACAExamResults_Fin.SetCurrentkey(Score);
                         if ACAExamResults_Fin.Find('+') then begin
                           CATExists := true;
                           end;
            Coregcs.Reset;
        Coregcs.SetFilter(Programme,StudentUnits.Programme);
        Coregcs.SetFilter("Academic Year",FirstSuppUnitsRegFor2ndSupp."Academic Year");
        Coregcs.SetRange("Student No.",FirstSuppUnitsRegFor2ndSupp."Student No.");
        Coregcs.SetRange(Semester,StudentUnits.Semester);
        if Coregcs.Find('-') then begin
            FirstSuppUnitsRegFor2ndSupp.CalcFields(Pass,"Exam Category");

              Clear(UnitsSubjects);
              UnitsSubjects.Reset;
              UnitsSubjects.SetRange("Programme Code",ACASuppExamCoRegfor2ndSupp.Programme);
              UnitsSubjects.SetRange(Code,FirstSuppUnitsRegFor2ndSupp."Unit Code");
              if UnitsSubjects.Find('-') then begin

                if UnitsSubjects."Default Exam Category"='' then UnitsSubjects."Default Exam Category":=Progyz."Exam Category";
                if UnitsSubjects."Exam Category"='' then UnitsSubjects."Exam Category":=Progyz."Exam Category";
                UnitsSubjects.Modify;
                Clear(ACA2NDExamClassificationUnits);
                ACA2NDExamClassificationUnits.Reset;
                ACA2NDExamClassificationUnits.SetRange("Student No.",FirstSuppUnitsRegFor2ndSupp."Student No.");
                ACA2NDExamClassificationUnits.SetRange(Programme,FirstSuppUnitsRegFor2ndSupp.Programme);
                ACA2NDExamClassificationUnits.SetRange("Unit Code",FirstSuppUnitsRegFor2ndSupp."Unit Code");
                ACA2NDExamClassificationUnits.SetRange("Academic Year",FirstSuppUnitsRegFor2ndSupp."Academic Year");
                if not ACA2NDExamClassificationUnits.Find('-') then begin
                    ACA2NDExamClassificationUnits.Init;
                    ACA2NDExamClassificationUnits."Student No.":=FirstSuppUnitsRegFor2ndSupp."Student No.";
                    ACA2NDExamClassificationUnits.Programme:=FirstSuppUnitsRegFor2ndSupp.Programme;
                    ACA2NDExamClassificationUnits."Reporting Academic Year":=FirstSuppUnitsRegFor2ndSupp."Academic Year";
                    ACA2NDExamClassificationUnits."School Code":=Progyz."School Code";
                    ACA2NDExamClassificationUnits."Unit Code":=FirstSuppUnitsRegFor2ndSupp."Unit Code";
                    ACA2NDExamClassificationUnits."Credit Hours":=UnitsSubjects."No. Units";
                    ACA2NDExamClassificationUnits."Unit Type":=Format(UnitsSubjects."Unit Type");
                    ACA2NDExamClassificationUnits."Unit Description":=UnitsSubjects.Desription;
                    ACA2NDExamClassificationUnits."Year of Study":=FirstSuppUnitsRegFor2ndSupp."Year of Study";
                    ACA2NDExamClassificationUnits."Academic Year":=FirstSuppUnitsRegFor2ndSupp."Academic Year";
                    ACA2NDExamClassificationUnits."Results Exists Status" := ACASuppExamCoRegfor2ndSupp."results exists status"::"Both Exists";

                        Clear(ExamResults); ExamResults.Reset;
                        ExamResults.SetRange("Student No.",FirstSuppUnitsRegFor2ndSupp."Student No.");
                        ExamResults.SetRange(Unit,StudentUnits.Unit);
                          if ExamResults.Find('-') then begin
                            ExamResults.CalcFields("Number of Repeats","Number of Resits");
                            if ExamResults."Number of Repeats">0 then
                            ACA2NDExamClassificationUnits."No. of Repeats":=ExamResults."Number of Repeats"-1;
                            if ExamResults."Number of Resits">0 then
                            ACA2NDExamClassificationUnits."No. of Resits":=ExamResults."Number of Resits"-1;
                            end;

                   if  ACA2NDExamClassificationUnits.Insert then ;
                  end;

                            /////////////////////////// Update Unit Score
                              Clear(ACA2NDExamClassificationUnits);
                ACA2NDExamClassificationUnits.Reset;
                ACA2NDExamClassificationUnits.SetRange("Student No.",FirstSuppUnitsRegFor2ndSupp."Student No.");
                ACA2NDExamClassificationUnits.SetRange(Programme,FirstSuppUnitsRegFor2ndSupp.Programme);
                ACA2NDExamClassificationUnits.SetRange("Unit Code",FirstSuppUnitsRegFor2ndSupp."Unit Code");
                ACA2NDExamClassificationUnits.SetRange("Academic Year",FirstSuppUnitsRegFor2ndSupp."Academic Year");
                if ACA2NDExamClassificationUnits.Find('-') then begin
                  FirstSuppUnitsRegFor2ndSupp.CalcFields(Pass);
                  if FirstSuppUnitsRegFor2ndSupp.Pass then begin
                    // Capture Regular Marks here Since the Unit was Passed by the Student
                    ACA2NDExamClassificationUnits."CAT Score" := FirstSuppUnitsRegFor2ndSupp."CAT Score";
                    ACA2NDExamClassificationUnits."CAT Score Decimal" := FirstSuppUnitsRegFor2ndSupp."CAT Score Decimal";
                    ACA2NDExamClassificationUnits."Results Exists Status" := FirstSuppUnitsRegFor2ndSupp."Results Exists Status";
                    ACA2NDExamClassificationUnits."Exam Score" := FirstSuppUnitsRegFor2ndSupp."Exam Score";
                    ACA2NDExamClassificationUnits."Exam Score Decimal" := FirstSuppUnitsRegFor2ndSupp."Exam Score Decimal";
                    ACA2NDExamClassificationUnits."Total Score" := FirstSuppUnitsRegFor2ndSupp."Total Score";
                    ACA2NDExamClassificationUnits."Total Score Decimal" := FirstSuppUnitsRegFor2ndSupp."Total Score Decimal";
                  ACA2NDExamClassificationUnits."Weighted Total Score" :=FirstSuppUnitsRegFor2ndSupp."Weighted Total Score";
                    end else begin
                    //  Pick Supp Marks here and leave value of Sore to Zero if Mark does not exist
                          // Check for Supp Marks if exists
                            Clear(Aca2ndSuppExamsDetails888);
                            Aca2ndSuppExamsDetails888.Reset;
                            Aca2ndSuppExamsDetails888.SetRange("Student No.",FirstSuppUnitsRegFor2ndSupp."Student No.");
                            Aca2ndSuppExamsDetails888.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                           // Aca2ndSuppExamsDetails888.SETRANGE(Category,AcaSpecialExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails888.SetRange(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails888.SetFilter("Exam Marks",'<>%1',0);
                            if Aca2ndSuppExamsDetails888.Find('-') then begin
                          ACA2NDExamClassificationUnits."Exam Score":=Format(ROUND(((Aca2ndSuppExamsDetails888."Exam Marks")),0.01,'='));
                          ACA2NDExamClassificationUnits."Exam Score Decimal":=ROUND(((Aca2ndSuppExamsDetails888."Exam Marks")),0.01,'=');
                    ACA2NDExamClassificationUnits."CAT Score" := '0';
                    ACA2NDExamClassificationUnits."CAT Score Decimal" := 0;
                    ACA2NDExamClassificationUnits."Total Score" := ACA2NDExamClassificationUnits."Exam Score";
                    ACA2NDExamClassificationUnits."Total Score Decimal" := ACA2NDExamClassificationUnits."Exam Score Decimal";
                  ACA2NDExamClassificationUnits."Weighted Total Score" :=ACA2NDExamClassificationUnits."Exam Score Decimal"*FirstSuppUnitsRegFor2ndSupp."Credit Hours";
                        //Update Total Marks
                        if ((ACA2NDExamClassificationUnits."Exam Score"='') and (CATExists=false)) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"None Exists";
                       end else if ((ACA2NDExamClassificationUnits."Exam Score"='') and (CATExists = true)) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"CAT Only";
                       end  else  if ((ACA2NDExamClassificationUnits."Exam Score"<>'') and (CATExists=false)) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Exam Only";
                       end else  if ((ACA2NDExamClassificationUnits."Exam Score"<>'') and (CATExists = true)) then begin
                          ACA2NDExamClassificationUnits."Results Exists Status":=ACA2NDExamClassificationUnits."results exists status"::"Both Exists";
                         end;
                          ACA2NDExamClassificationUnits."Total Score Decimal":=ROUND(ACA2NDExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACA2NDExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(Progyz."Exam Category",ACA2NDExamClassificationUnits."Total Score Decimal");
                          ACA2NDExamClassificationUnits."Total Score":=Format(ROUND(ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACA2NDExamClassificationUnits."Weighted Total Score":=ROUND(ACA2NDExamClassificationUnits."Credit Hours"*ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'=');

                              end;
                          ACA2NDExamClassificationUnits."Total Score Decimal":=ROUND(ACA2NDExamClassificationUnits."Exam Score Decimal",0.01,'=');
                          ACA2NDExamClassificationUnits."Total Score Decimal":=GetSuppMaxScore(Progyz."Exam Category",ACA2NDExamClassificationUnits."Total Score Decimal");
                          ACA2NDExamClassificationUnits."Total Score":=Format(ROUND(ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'='));
                          ACA2NDExamClassificationUnits."Weighted Total Score":=ROUND(ACA2NDExamClassificationUnits."Credit Hours"*ACA2NDExamClassificationUnits."Total Score Decimal",0.01,'=');

                      end;
                    ACA2NDExamClassificationUnits.Modify;
                  end;
        ////////////*********************************************
        //////////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        // Check for Special Exams Score if Exists
                              ///////////////////////////////////////////////////////// End of Supps Score Updates
                            Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetFilter("Exam Marks",'<>%1',0);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if Aca2ndSuppExamsDetails.Find('-') then begin
                              ACAExam2NDSuppUnits.Init;
                              ACAExam2NDSuppUnits."Student No.":=StudentUnits."Student No.";
                              ACAExam2NDSuppUnits."Unit Code":=ACA2NDExamClassificationUnits."Unit Code";
                              ACAExam2NDSuppUnits."Unit Description":=ACA2NDExamClassificationUnits."Unit Description";
                              ACAExam2NDSuppUnits."Unit Type":=ACA2NDExamClassificationUnits."Unit Type";
                              ACAExam2NDSuppUnits.Programme:=ACA2NDExamClassificationUnits.Programme;
                              ACAExam2NDSuppUnits."Academic Year":=ACA2NDExamClassificationUnits."Academic Year";
                              ACAExam2NDSuppUnits."Credit Hours":=ACA2NDExamClassificationUnits."Credit Hours";
                              if AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Supplementary then begin
                              ACAExam2NDSuppUnits."Exam Score":=Format(ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'='));
                              ACAExam2NDSuppUnits."Exam Score Decimal":=ROUND(((AcaSpecialExamsDetails."Exam Marks")),0.01,'=');
                              ACAExam2NDSuppUnits."CAT Score":=Format(ROUND(ACA2NDExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExam2NDSuppUnits."CAT Score Decimal":=ROUND(ACA2NDExamClassificationUnits."CAT Score Decimal",0.01,'=');
                          ACAExam2NDSuppUnits."Total Score Decimal":=ROUND((GetSuppMaxScore(Progyz."Exam Category",(ROUND(ACAExam2NDSuppUnits."Exam Score Decimal",0.01,'=')))),0.01,'=');
                              ACAExam2NDSuppUnits."Total Score":=Format(ACAExam2NDSuppUnits."Total Score Decimal");
                                end else if AcaSpecialExamsDetails.Category = AcaSpecialExamsDetails.Category::Special then begin
                              ACAExam2NDSuppUnits."Exam Score Decimal":=ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'=');
                              ACAExam2NDSuppUnits."Exam Score":=Format(ROUND(AcaSpecialExamsDetails."Exam Marks",0.01,'='));
                              ACAExam2NDSuppUnits."CAT Score":=Format(ROUND(ACA2NDExamClassificationUnits."CAT Score Decimal",0.01,'='));
                              ACAExam2NDSuppUnits."CAT Score Decimal":=ROUND(ACA2NDExamClassificationUnits."CAT Score Decimal",0.01,'=');
                              ACAExam2NDSuppUnits."Total Score Decimal":=GetSuppMaxScore(Progyz."Exam Category",(ROUND(AcaSpecialExamsDetails."Exam Marks"+ACA2NDExamClassificationUnits."CAT Score Decimal",0.01,'=')));
                              ACAExam2NDSuppUnits."Total Score":=Format(ACAExam2NDSuppUnits."Total Score Decimal");
                              end;
                              ACAExam2NDSuppUnits."Exam Category":=ACA2NDExamClassificationUnits."Exam Category";
                              ACAExam2NDSuppUnits."Allow In Graduate":=true;
                              ACAExam2NDSuppUnits."Year of Study":=ACA2NDExamClassificationUnits."Year of Study";
                              ACAExam2NDSuppUnits.Cohort:=ACA2NDExamClassificationUnits.Cohort;
                              ACAExam2NDSuppUnits."School Code":=ACA2NDExamClassificationUnits."School Code";
                              ACAExam2NDSuppUnits."Department Code":=ACA2NDExamClassificationUnits."Department Code";
                              if ACAExam2NDSuppUnits.Insert then;
                          ACA2NDExamClassificationUnits.Modify;
                              //  END;
                              end;
                              ACA2NDExamClassificationUnits."Allow In Graduate":=true;
                          ACA2NDExamClassificationUnits.Modify;
                              /// Update Cummulative Resit
                              ACA2NDExamClassificationUnits.CalcFields(Grade,"Grade Comment","Comsolidated Prefix",Pass);
                     if ACA2NDExamClassificationUnits.Pass then begin
                                Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails.SetFilter("Exam Marks",'%1',0);
                            if Aca2ndSuppExamsDetails.Find ('-') then Aca2ndSuppExamsDetails.DeleteAll;
                end else begin
                     // Student Failed Supp or Special. Register for the second Supp if first Supp Failed and 1st Supp if Special Failed

                                Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            Aca2ndSuppExamsDetails.SetFilter("Exam Marks",'%1',0);
                            if Aca2ndSuppExamsDetails.Find ('-') then Aca2ndSuppExamsDetails.DeleteAll;
                    //Aca2ndSuppExamsDetails3
                    Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if not (Aca2ndSuppExamsDetails.Find('-')) then begin
                               //  Register Supp for Special that is Failed
                               // The Failed Unit is not in Supp Special, Register The Unit here
                              Clear(CountedSeq);
                              Clear(Aca2ndSuppExamsDetails3);
                               Aca2ndSuppExamsDetails3.Reset;
                            Aca2ndSuppExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails3.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
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
                              if AcaSpecialExamsDetails.Insert then ;
                                Clear(Aca2ndSuppExamsDetails);
                            Aca2ndSuppExamsDetails.Reset;
                            Aca2ndSuppExamsDetails.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
                            Aca2ndSuppExamsDetails.SetRange(Category,Aca2ndSuppExamsDetails.Category::Supplementary);
                            Aca2ndSuppExamsDetails.SetRange(Semester,StudentUnits.Semester);
                            if not (Aca2ndSuppExamsDetails.Find('-')) then begin
                              Clear(CountedSeq);
                              Clear(Aca2ndSuppExamsDetails3);
                               Aca2ndSuppExamsDetails3.Reset;
                            Aca2ndSuppExamsDetails3.SetRange("Student No.",StudentUnits."Student No.");
                            Aca2ndSuppExamsDetails3.SetRange("Unit Code",ACA2NDExamClassificationUnits."Unit Code");
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
                    end;
        /////////////////>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            end;
              end;
              end;
              end;
              until FirstSuppUnitsRegFor2ndSupp.Next = 0;
              end;

        // Update Averages
        Clear(TotalRecs);
        Clear(CountedRecs);
        Clear(RemeiningRecs);
        Clear(ACA2NDExamClassificationStuds);
        ACA2NDExamCourseRegistration.Reset;
         ACA2NDExamCourseRegistration.SetFilter("Reporting Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACA2NDExamCourseRegistration.SetFilter("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACA2NDExamCourseRegistration.SetFilter(Programme,ACASuppExamCoRegfor2ndSupp.Programme);
        if ACA2NDExamCourseRegistration.Find('-') then begin
          TotalRecs:=ACA2NDExamCourseRegistration.Count;
          RemeiningRecs:=TotalRecs;
            repeat
              begin

              Progyz.Reset;
              Progyz.SetRange(Code,ACA2NDExamCourseRegistration.Programme);
              if Progyz.Find('-') then;
              CountedRecs+=1;
              RemeiningRecs-=1;
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
                  end;
    end;

    local procedure Delete2ndSupplementaryMarks(ACASuppExamCoRegfor2ndSupp: Record UnknownRecord66642)
    var
        CATExists: Boolean;
        Aca2ndSuppExamsDetails3: Record UnknownRecord78031;
        Aca2ndSuppExamsDetails: Record UnknownRecord78031;
        FirstSuppUnitsRegFor2ndSupp: Record UnknownRecord66641;
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
        CurrStudentNo: Code[250];
        CountedNos: Integer;
        CurrSchool: Code[250];
        CUrrentExamScore: Decimal;
        OriginalCatScores: Decimal;
        ACASuppExamClassUnits4Supp2: Record UnknownRecord66641;
    begin

        ProgFIls:=ACASuppExamCoRegfor2ndSupp.Programme;
        ACA2NDExamClassificationStuds.Reset;
        ACA2NDExamCourseRegistration.Reset;
        ACA2NDExamClassificationUnits.Reset;
        ACAExam2NDSuppUnits.Reset;
        if StudNos<>'' then begin
        ACA2NDExamClassificationStuds.SetFilter("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACA2NDExamCourseRegistration.SetRange("Student Number",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACA2NDExamClassificationUnits.SetRange("Student No.",ACASuppExamCoRegfor2ndSupp."Student Number");
        ACAExam2NDSuppUnits.SetFilter("Student No.",StudNos);
        end;
        if AcadYear<>'' then begin
        ACA2NDExamClassificationStuds.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACA2NDExamCourseRegistration.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACA2NDExamClassificationUnits.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
        ACAExam2NDSuppUnits.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
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
                          ACA2NDSenateReportsHeader.SetFilter("Academic Year",ACASuppExamCoRegfor2ndSupp."Academic Year");
                          ACA2NDSenateReportsHeader.SetFilter("Programme Code",ProgFIls);
                          if  (ACA2NDSenateReportsHeader.Find('-')) then ACA2NDSenateReportsHeader.DeleteAll;
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
        ObjUnits: Record UnknownRecord61549;
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
        if CoursesRegz."Units Deficit">0 then StatusRemarks:='DTSC';
        if CoursesRegz."Required Stage Units">CoursesRegz."Attained Stage Units" then StatusRemarks:='DTSC';
        if CoursesRegz."Attained Stage Units" = 0 then StatusRemarks:='DTSC';
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
        if (not CoursesRegz."Special Registration Exists") and (StatusRemarks='DTSC')then begin
         ///Ensure special is not skipped.
          ObjUnits.Reset;
          ObjUnits.SetRange("Student No.",CoursesRegz."Student Number");
          ObjUnits.SetRange("Academic Year",CoursesRegz."Academic Year");
          ObjUnits.SetRange("Year Of Study",CoursesRegz."Year of Study");
          ObjUnits.SetRange(ObjUnits."Special Exam",ObjUnits."special exam"::Special);
          if ObjUnits.FindFirst then
             StatusRemarks:='Special';
          end;
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
            AcaSpecialExamsDetails.SetRange(AcaSpecialExamsDetails.Category,AcaSpecialExamsDetails.Category::Supplementary);
            if AcaSpecialExamsDetails.Find('-') then AcaSpecialExamsDetails.DeleteAll;
            end;
          end;

    end;

    local procedure GetSupp2MaxScore(SuppDets: Record UnknownRecord78031;Categoryz: Code[250];Scorezs: Decimal) SuppScoreNormalized: Decimal
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

    local procedure GetSuppRubricPassStatus(RubricCode: Code[50];AcademicYears: Code[250];Progyz: Record UnknownRecord61511) PassStatus: Boolean
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

    local procedure Get2ndSuppRubricPassStatus(RubricCode: Code[50];AcademicYears: Code[250];Progyz: Record UnknownRecord61511) PassStatus: Boolean
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

    local procedure Get1StSuppScore(StudentNoz: Code[250];UnitCode: Code[250]) SuppScores: Decimal
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

    local procedure Get2ndSuppScore(StudentNoz: Code[250];UnitCode: Code[250]) SecondSuppResults: Decimal
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

    local procedure GetAcademicYearDiff(RegAcademicYear: Code[20];CurrentAcademicYear: Code[20]) Register2ndSupp: Boolean
    var
        AcadYears: Record UnknownRecord61382;
        AcaCourseReg: Record UnknownRecord61532;
        AcaStudUnitsReg: Record UnknownRecord61549;
        ProcessingYearInteger: Integer;
        CurrYearInteger: Integer;
        ProcessingYearString: Text[30];
        CurrYearString: Text[30];
    begin
        Clear(ProcessingYearString);
        Clear(CurrYearString);
        Clear(ProcessingYearInteger);
        Clear(CurrYearInteger);
         if StrLen(CurrentAcademicYear) > 2 then begin
            CurrYearString := CopyStr(CurrentAcademicYear, StrLen(CurrentAcademicYear) - 1, 2);

            if Evaluate(CurrYearInteger, CurrYearString) then;
        end;


         if StrLen(RegAcademicYear) > 2 then begin
            ProcessingYearString := CopyStr(RegAcademicYear, StrLen(RegAcademicYear) - 1, 2);

            if Evaluate(ProcessingYearInteger, ProcessingYearString) then;
        end;
        if ((ProcessingYearInteger <> 0) and (CurrYearInteger <> 0)) then begin
          if ((CurrYearInteger - ProcessingYearInteger)>1) then begin
            exit(true); // allow registration of supplementary
            end;
        end;
    end;
}

