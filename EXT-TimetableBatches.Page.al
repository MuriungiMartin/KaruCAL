#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74550 "EXT-Timetable Batches"
{
    ApplicationArea = Basic;
    Caption = 'Timetable Batches';
    PageType = List;
    SourceTable = UnknownTable74550;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Timetable Programs")
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Programs';
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EXT-Programmes";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action("Timetable Units")
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Units';
                Image = BusinessRelation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EXT-Units";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action("Timetable Lecturers")
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Lecturers';
                Image = Campaign;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EXT-Lecturers";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action(Blocks)
            {
                ApplicationArea = Basic;
                Caption = 'Blocks';
                Image = CalendarChanged;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "TT-Blocks";
            }
            action(Rooms)
            {
                ApplicationArea = Basic;
                Caption = 'Rooms';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "TT-Rooms";
            }
            action("Dates (Timetable Dates)")
            {
                ApplicationArea = Basic;
                Caption = 'Dates (Timetable Dates)';
                Image = CalendarWorkcenter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EXT-Dates";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action("Periods List")
            {
                ApplicationArea = Basic;
                Caption = 'Periods List';
                Image = CreateRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EXT-Periods";
            }
            action(GenTT)
            {
                ApplicationArea = Basic;
                Caption = 'Generate Timetable';
                Image = GetActionMessages;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TTLecturers: Record UnknownRecord74555;
                    TTProgrammes: Record UnknownRecord74553;
                    TTUnits: Record UnknownRecord74554;
                    LectLoadBatchLines: Record UnknownRecord65202;
                begin
                    Rec.CalcFields(Current);
                    if Rec.Current=false then Error('The Semester is already closed');
                    if Confirm('Generate Automatic Constraints, Continue?',false)=false then Error('Cancelled by user!');
                    //IF CONFIRM('You may be required to regenerate your timetable \after generating your constraints. \Continue?',TRUE)=FALSE THEN  ERROR('Cancelled by user!');
                    
                    //Get Default Catogory
                    /*TTWeightLessonCategories.RESET;
                    TTWeightLessonCategories.SETRANGE(Semester,Rec.Semester);
                    TTWeightLessonCategories.SETRANGE("Default Category",TRUE);
                    IF TTWeightLessonCategories.FIND('-') THEN BEGIN
                      END ELSE ERROR('Defauly Unit Weighting category is not defined!');*/
                    LectLoadBatchLines.Reset;
                    LectLoadBatchLines.SetRange(Semester,Rec.Semester);
                    LectLoadBatchLines.SetFilter(Unit,'<>%1','');
                    if LectLoadBatchLines.Find('-') then begin
                      TTLecturers.Reset;
                      TTLecturers.SetRange(Semester,Rec.Semester);
                      if TTLecturers.Find('-') then TTLecturers.DeleteAll;
                      TTProgrammes.Reset;
                      TTProgrammes.SetRange(Semester,Rec.Semester);
                      if TTProgrammes.Find('-') then TTProgrammes.DeleteAll;
                      /*TTUnits.RESET;
                      TTUnits.SETRANGE(Semester,Rec.Semester);
                      TTUnits.SETFILTER("Weighting Category",'<>%1',TTWeightLessonCategories."Category Code");
                      IF TTUnits.FIND('-') THEN TTUnits.DELETEALL;*/
                        repeat
                            begin
                            TTLecturers.Reset;
                            TTLecturers.SetRange("Academic Year",Rec."Academic Year");
                            TTLecturers.SetRange(Semester,Rec.Semester);
                            TTLecturers.SetRange("Lecturer Code",LectLoadBatchLines.Lecturer);
                            if not (TTLecturers.Find('-')) then begin
                              //Insert
                              TTLecturers.Init;
                              TTLecturers."Academic Year":=Rec."Academic Year";
                              TTLecturers.Semester:=Rec.Semester;
                              TTLecturers."Lecturer Code":=LectLoadBatchLines.Lecturer;
                              TTLecturers.Insert;
                              end;
                            TTProgrammes.Reset;
                            TTProgrammes.SetRange("Academic Year",Rec."Academic Year");
                            TTProgrammes.SetRange(Semester,Rec.Semester);
                            TTProgrammes.SetRange("Programme Code",LectLoadBatchLines.Programme);
                            if not (TTProgrammes.Find('-')) then begin
                              //Insert
                              TTProgrammes.Init;
                              TTProgrammes."Academic Year":=Rec."Academic Year";
                              TTProgrammes.Semester:=Rec.Semester;
                              TTProgrammes."Programme Code":=LectLoadBatchLines.Programme;
                              TTProgrammes.Insert;
                              end;
                            TTUnits.Reset;
                            TTUnits.SetRange("Academic Year",Rec."Academic Year");
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",LectLoadBatchLines.Programme);
                            TTUnits.SetRange("Unit Code",LectLoadBatchLines.Unit);
                            if not (TTUnits.Find('-')) then begin
                              //Insert
                              TTUnits.Init;
                              TTUnits."Academic Year":=Rec."Academic Year";
                              TTUnits.Semester:=Rec.Semester;
                              TTUnits."Programme Code":=LectLoadBatchLines.Programme;
                              TTUnits."Unit Code":=LectLoadBatchLines.Unit;
                              //TTUnits."Weighting Category":=TTWeightLessonCategories."Category Code";
                              TTUnits.Insert;
                              end;
                            end;
                          until LectLoadBatchLines.Next=0;
                      end else Error('Caurse loading for the current Semester has not been done!');
                    
                    //IF CONFIRM('Re-Generate the timetable Entries?',TRUE)=FALSE THEN EXIT;
                    GenerateEntriesSingles;
                    SpecificConstraintsProgCampuses;
                    SpecificConstraintsLectCampuses;
                    SpecificConstraintsUnitCampuses;
                    SpecificConstraintsUnitRooms;
                    SpecificConstraintsProgDays;
                    SpecificConstraintsLectDays;
                    ThiningSingles;
                    FinalCompilation;
                    
                    
                    Message('Done!');

                end;
            }
            action(MasterRep1)
            {
                ApplicationArea = Basic;
                Caption = 'Master Timetable';
                Image = MovementWorksheet;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TTTimetableFInalCollector.Reset;
                    TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                    if TTTimetableFInalCollector.Find('-') then
                      Report.Run(74550,true,false,TTTimetableFInalCollector);
                end;
            }
            action(MasterRep2)
            {
                ApplicationArea = Basic;
                Caption = 'Master Timetable 2';
                Image = AnalysisViewDimension;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TTTimetableFInalCollector.Reset;
                    TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                    if TTTimetableFInalCollector.Find('-') then
                      Report.Run(74551,true,false,TTTimetableFInalCollector);
                end;
            }
            action(DistribRep)
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Destribution';
                Image = DistributionGroup;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EXTUnits: Record UnknownRecord74554;
                begin
                    EXTUnits.Reset;
                    EXTUnits.SetRange(Semester,Rec.Semester);
                    if EXTUnits.Find('-') then
                      Report.Run(74552,true,false,EXTUnits);
                end;
            }
            action("Timetable Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Preview';
                Image = PreviewChecks;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "EXT-Preview";
                RunPageLink = Semester=field(Semester);
            }
        }
    }

    var
        CountedEntries: Integer;
        TTTimetableFInalCollector: Record UnknownRecord74568;
        EXTUnitSpecRooms: Record UnknownRecord74565;

    local procedure GenerateEntriesSingles()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74552;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorA: Record UnknownRecord74557;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74554;
        TTLessons: Record UnknownRecord74556;
        TTDays: Record UnknownRecord74551;
        progre: Dialog;
        counts: Integer;
        RecCount1: Text[120];
        RecCount2: Text[120];
        RecCount3: Text[120];
        RecCount4: Text[120];
        RecCount5: Text[120];
        RecCount6: Text[120];
        RecCount7: Text[120];
        RecCount8: Text[120];
        RecCount9: Text[120];
        RecCount10: Text[120];
        BufferString: Text[1024];
        Var1: Code[10];
        prempTrns: Record UnknownRecord61091;
        progDots: Text[50];
        counted: Integer;
        text1: label '*';
        text2: label '**';
        text3: label '***';
        text4: label '****';
        text5: label '*****';
        text6: label '******';
        text7: label '*******';
        text8: label '********';
        text9: label '*********';
        text10: label '**********';
        UnitSpecRoom: Integer;
        ProgSpecRoom: Integer;
        LectSpecLessons: Integer;
        UnitSpecCampus: Integer;
        ProgSpecCampuses: Integer;
        LectSpecCampuses: Integer;
        LectSpecDays: Integer;
        ProgSpecDays: Integer;
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        recordsFound: Integer;
    begin
        /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
         Clear(progDots);
        Clear(RecCount1);
        Clear(RecCount2);
        Clear(RecCount3);
        Clear(RecCount4);
        Clear(RecCount5);
        Clear(RecCount6);
        Clear(RecCount7);
        Clear(RecCount8);
        Clear(RecCount9);
        Clear(RecCount10);
        Clear(counts);
        progre.Open('Generating SINGLE Class Entries: #1#############################'+
        '\ '+
        '\#2###############################################################'+
        '\#3###############################################################'+
        '\#4###############################################################'+
        '\#5###############################################################'+
        '\#6###############################################################'+
        '\#7###############################################################'+
        '\#8###############################################################'+
        '\#9###############################################################'+
        '\#10###############################################################'+
        '\#11###############################################################'+
        '\#12###############################################################'+
        '\#13###############################################################'+
        '\#14###############################################################',
            progDots,
            RecCount1,
            RecCount2,
            RecCount3,
            RecCount4,
            RecCount5,
            RecCount6,
            RecCount7,
            RecCount8,
            RecCount9,
            RecCount10,
            Var1,
            Var1,
            BufferString
        );
        /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
        Clear(recordsFound);
        TTTimetableCollectorA.Reset;
        TTTimetableCollectorA.SetRange(Semester,Rec.Semester);
        if TTTimetableCollectorA.Find('-') then TTTimetableCollectorA.DeleteAll;
        Clear(CountedEntries);
        TTRooms.Reset;
        //TTRooms.SETRANGE(Semester,Rec.Semester);
        if TTRooms.Find('-') then begin

              TTDailyLessons.Reset;
              TTDailyLessons.SetRange(Semester,Rec.Semester);
              if TTDailyLessons.Find('-') then;
                    ACALecturersUnits.Reset;
                    ACALecturersUnits.SetRange(Semester,Rec.Semester);
                    if ACALecturersUnits.Find('-') then;
                    recordsFound:=ACALecturersUnits.Count*TTDailyLessons.Count*TTRooms.Count;
          repeat
            begin
              TTDailyLessons.Reset;
              TTDailyLessons.SetRange(Semester,Rec.Semester);
              if TTDailyLessons.Find('-') then begin
                repeat
                  begin
                  TTLessons.Reset;
                  TTLessons.SetRange("Period Code",TTDailyLessons."Period Code");
                  if TTLessons.Find('-') then;
                  TTDays.Reset;
                  TTDays.SetRange("Date Code",TTDailyLessons."Date Code");
                  TTDays.SetRange(Semester,Rec.Semester);
                  if TTDays.Find('-') then;
                    ACALecturersUnits.Reset;
                    ACALecturersUnits.SetRange(Semester,Rec.Semester);
                    if ACALecturersUnits.Find('-') then begin
                        repeat
                            begin
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            Clear(Var1);
            counts:=counts+1;
            if ((counted=21) or(counted=11)) then begin
            if counted=21 then counted := 0;
            //SLEEP(150);
            end;
            counted:=counted+1;
            if counted=1 then progDots:=text1
            else if counted=2 then progDots:=text2
            else if counted=3 then progDots:=text3
            else if counted=4 then progDots:=text4
            else if counted=5 then progDots:=text5
            else if counted=6 then progDots:=text6
            else if counted=7 then progDots:=text7
            else if counted=8 then progDots:=text8
            else if counted=9 then progDots:=text9
            else if counted=10 then progDots:=text10
            else if counted=19 then progDots:=text1
            else if counted=18 then progDots:=text2
            else if counted=17 then progDots:=text3
            else if counted=16 then progDots:=text4
            else if counted=15 then progDots:=text5
            else if counted=14 then progDots:=text6
            else if counted=13 then progDots:=text7
            else if counted=12 then progDots:=text8
            else if counted=11 then progDots:=text9
            else progDots:='';

            if counts=1 then
            RecCount1:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end else if counts>10 then begin
            RecCount1:=RecCount2;
            RecCount2:=RecCount3;
            RecCount3:=RecCount4;
            RecCount4:=RecCount5;
            RecCount5:=RecCount6;
            RecCount6:=RecCount7;
            RecCount7:=RecCount8;
            RecCount8:=RecCount9;
            RecCount9:=RecCount10;
            RecCount10:=Format(counts)+'). '+'Day: '+Format(TTDays."Date Code")+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Processed : '+Format(counts)+'; Remaining : '+Format(recordsFound-counts);

            progre.Update();
            // //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            //Check for Specific Constraints
                            ProgSpecCampuses:=5;
                            ProgSpecDays:=5;
                            ProgSpecRoom:=5;
                            UnitSpecCampus:=5;
                            UnitSpecRoom:=5;
                            LectSpecCampuses:=5;
                            LectSpecDays:=5;
                            LectSpecLessons:=5;
                            TTProgSpecCampuses.Reset;
                            TTProgSpecCampuses.SetRange(Semester,Rec.Semester);
                            TTProgSpecCampuses.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTProgSpecCampuses.SetFilter("Campus Code",'%1',ACALecturersUnits."Campus Code");
                            if TTProgSpecCampuses.Find('-') then begin
                              if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Avoid then ProgSpecCampuses:=666
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::"Least Preferred" then ProgSpecCampuses:=333
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Preferred then ProgSpecCampuses:=3
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Mandatory then ProgSpecCampuses:=1;
                              end;

                             TTProgSpecDays.Reset;
                             TTProgSpecDays.SetRange(Semester,Rec.Semester);
                             TTProgSpecDays.SetRange("Programme Code",ACALecturersUnits.Programme);
                             TTProgSpecDays.SetFilter("Date Code",'%1',TTDailyLessons."Date Code");
                             if TTProgSpecDays.Find('-') then begin
                               if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then ProgSpecDays:=666
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then ProgSpecDays:=333
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then ProgSpecDays:=3
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then ProgSpecDays:=1;
                               end;

        // // // // // //                     TTProgSpecRooms.RESET;
        // // // // // //                     TTProgSpecRooms.SETRANGE(Semester,Rec.Semester);
        // // // // // //                     TTProgSpecRooms.SETRANGE("Programme Code",ACALecturersUnits.Programme);
        // // // // // //                     TTProgSpecRooms.SETFILTER("Room Code",'%1',TTRooms."Room Code");
        // // // // // //                     IF TTProgSpecRooms.FIND('-') THEN BEGIN
        // // // // // //                       IF TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."Constraint Category"::Avoid THEN ProgSpecRoom:=666
        // // // // // //                       ELSE IF TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."Constraint Category"::"Least Preferred" THEN ProgSpecRoom:=333
        // // // // // //                       ELSE IF TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."Constraint Category"::Preferred THEN ProgSpecRoom:=3
        // // // // // //                       ELSE IF TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."Constraint Category"::Mandatory THEN ProgSpecRoom:=1;
        // // // // // //                       END;
                               //---- Lecturer

                            TTLectSpecCampuses.Reset;
                            TTLectSpecCampuses.SetRange(Semester,Rec.Semester);
                            TTLectSpecCampuses.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                            TTLectSpecCampuses.SetFilter("Campus Code",'%1',ACALecturersUnits."Campus Code");
                            if TTLectSpecCampuses.Find('-') then begin
                              if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Avoid then LectSpecCampuses:=666
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::"Least Preferred" then LectSpecCampuses:=333
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Preferred then LectSpecCampuses:=3
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Mandatory then LectSpecCampuses:=1;
                              end;

                             TTLectSpecLessons.Reset;
                             TTLectSpecLessons.SetRange(Semester,Rec.Semester);
                             TTLectSpecLessons.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                             TTLectSpecLessons.SetFilter("Lesson Code",'%1',TTDailyLessons."Period Code");
                             if TTLectSpecLessons.Find('-') then begin
                               if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::Avoid then LectSpecLessons:=666
                               else if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::"Least Preferred" then LectSpecLessons:=333
                               else if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::Preferred then LectSpecLessons:=3
                               else if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::Mandatory then LectSpecLessons:=1;
                               end;

                             TTLectSpecDays.Reset;
                             TTLectSpecDays.SetRange(Semester,Rec.Semester);
                             TTLectSpecDays.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                             TTLectSpecDays.SetFilter("Date Code",'%1',TTDailyLessons."Date Code");
                             if TTLectSpecDays.Find('-') then begin
                               if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then LectSpecDays:=666
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then LectSpecDays:=333
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Preferred then LectSpecDays:=3
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Mandatory then LectSpecDays:=1;
                               end;

                               TTUnitSpecCampuses.Reset;
                            TTUnitSpecCampuses.SetRange(Semester,Rec.Semester);
                            TTUnitSpecCampuses.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnitSpecCampuses.SetFilter("Campus Code",'%1',ACALecturersUnits."Campus Code");
                            TTUnitSpecCampuses.SetFilter("Unit Code",'%1',ACALecturersUnits.Unit);
                            if TTUnitSpecCampuses.Find('-') then begin
                              if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Avoid then UnitSpecCampus:=666
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::"Least Preferred" then UnitSpecCampus:=333
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Preferred then UnitSpecCampus:=3
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Mandatory then UnitSpecCampus:=1;
                              end;

                            TTUnitSpecRooms.Reset;
                            TTUnitSpecRooms.SetRange(Semester,Rec.Semester);
                            TTUnitSpecRooms.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnitSpecRooms.SetFilter("Unit Code",'%1',ACALecturersUnits.Unit);
                            TTUnitSpecRooms.SetFilter("Room Code",'%1',TTRooms."Room Code");
                            if TTUnitSpecRooms.Find('-') then begin
                              if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Avoid then UnitSpecRoom:=666
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::"Least Preferred" then UnitSpecRoom:=333
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Preferred then UnitSpecRoom:=3
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Mandatory then UnitSpecRoom:=1;
                              end;
                            LectLoadBatchLines.Reset;
                            LectLoadBatchLines.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                            LectLoadBatchLines.SetRange("Semester Code",Rec.Semester);
                            if LectLoadBatchLines.Find('-') then;
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;

                              TTTimetableCollectorA.Reset;
                              TTTimetableCollectorA.SetRange(Programme,ACALecturersUnits.Programme);
                              TTTimetableCollectorA.SetRange(Unit,ACALecturersUnits.Unit);
                              TTTimetableCollectorA.SetRange(Semester,Rec.Semester);
                              TTTimetableCollectorA.SetRange("Lesson Code",TTDailyLessons."Period Code");
                              TTTimetableCollectorA.SetRange("Date Code",TTDailyLessons."Date Code");
                              TTTimetableCollectorA.SetRange("Lecture Room",TTRooms."Room Code");
                              TTTimetableCollectorA.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                             // TTTimetableCollectorA.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableCollectorA.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableCollectorA.SetRange("Room Code",TTRooms."Room Code");
                             // TTTimetableCollectorA.SETRANGE("Block/Building",TTRooms."Block Code");
                              TTTimetableCollectorA.SetRange("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableCollectorA.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if TTTimetableCollectorA.Find('-') then begin
                               end else begin
                               TTTimetableCollectorA.Init;
                               TTTimetableCollectorA.Programme:=ACALecturersUnits.Programme;
                               TTTimetableCollectorA.Unit:=ACALecturersUnits.Unit;
                               TTTimetableCollectorA.Semester:=Rec.Semester;
                               TTTimetableCollectorA."Lesson Code":=TTDailyLessons."Period Code";
                               TTTimetableCollectorA."Lesson Category":=TTUnits."Weighting Category";
                               TTTimetableCollectorA."Date Code":=TTDailyLessons."Date Code";
                               TTTimetableCollectorA."Lecture Room":=TTRooms."Room Code";
                               TTTimetableCollectorA.Lecturer:=LectLoadBatchLines."Lecturer Code";
                               TTTimetableCollectorA.Department:=LectLoadBatchLines."Department Code";
                               TTTimetableCollectorA."Day Order":=TTDays."Day Order";
                               TTTimetableCollectorA."Lesson Order":=TTLessons."Period Order";
                             //  TTTimetableCollectorA."Programme Option":=;
                               TTTimetableCollectorA."Room Type":=TTRooms."Room Type";
                               TTTimetableCollectorA."Room Code":=TTRooms."Room Code";
                               TTTimetableCollectorA."Block/Building":=TTRooms."Block Code";
                               TTTimetableCollectorA."School or Faculty":=LectLoadBatchLines.Faculty;
                               TTTimetableCollectorA."Campus Code":=ACALecturersUnits."Campus Code";
                               TTTimetableCollectorA."Programme Campus Priority":=ProgSpecCampuses;
                               TTTimetableCollectorA."Programme Day Priority":=ProgSpecDays;
                               TTTimetableCollectorA."Programme Room Priority":=ProgSpecRoom;
                               TTTimetableCollectorA."Lecturer Campus Priority":=LectSpecCampuses;
                               TTTimetableCollectorA."Lecturer Day Priority":=LectSpecDays;
                               TTTimetableCollectorA."Lecturer Lesson Priority":=LectSpecLessons;
                               TTTimetableCollectorA."Unit Campus Priority":=UnitSpecCampus;
                               TTTimetableCollectorA."Unit Room Priority":=UnitSpecRoom;
                               TTTimetableCollectorA."Class Code":=ACALecturersUnits.Class;
                               if ((Rec.Semester<>'') and (TTRooms."Room Code"<>'') and (LectLoadBatchLines."Lecturer Code"<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorA."Record ID":=CountedEntries;

                             if TTRooms."Room Type"<>TTRooms."room type"::Class then begin
                               EXTUnitSpecRooms.Reset;
                               EXTUnitSpecRooms.SetRange(Semester,Rec.Semester);
                               EXTUnitSpecRooms.SetRange("Programme Code",ACALecturersUnits.Programme);
                               EXTUnitSpecRooms.SetRange("Unit Code",ACALecturersUnits.Unit);
                               EXTUnitSpecRooms.SetRange("Room Code",TTRooms."Room Code");
                               if EXTUnitSpecRooms.Find('-') then TTTimetableCollectorA.Insert;
                               end else
                               TTTimetableCollectorA.Insert;
                               end;
                                 end;
                               end;

                          until ACALecturersUnits.Next=0;
                      end;
                  end;
                  until TTDailyLessons.Next=0;
                end;
            end;
            until TTRooms.Next=0;
          end;

         progre.Close;
    end;

    local procedure ThiningSingles()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74552;
        ACALecturersUnits: Record UnknownRecord65202;
        ACALecturersUnits2: Record UnknownRecord65202;
        TTTimetableCollectorA: Record UnknownRecord74557;
        TTTimetableCollectorA1: Record UnknownRecord74557;
        TTTimetableCollectorA2: Record UnknownRecord74557;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74554;
        TTLessons: Record UnknownRecord74556;
        TTDays: Record UnknownRecord74551;
        Loops: Integer;
        progre: Dialog;
        counts: Integer;
        RecCount1: Text[120];
        RecCount2: Text[120];
        RecCount3: Text[120];
        RecCount4: Text[120];
        RecCount5: Text[120];
        RecCount6: Text[120];
        RecCount7: Text[120];
        RecCount8: Text[120];
        RecCount9: Text[120];
        RecCount10: Text[120];
        BufferString: Text[1024];
        Var1: Code[10];
        prempTrns: Record UnknownRecord61091;
        progDots: Text[50];
        counted: Integer;
        text1: label '*';
        text2: label '**';
        text3: label '***';
        text4: label '****';
        text5: label '*****';
        text6: label '******';
        text7: label '*******';
        text8: label '********';
        text9: label '*********';
        text10: label '**********';
        CurrLessonOrder: Integer;
        NextLessonOrder: Integer;
    begin
        /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
         Clear(progDots);
        Clear(RecCount1);
        Clear(RecCount2);
        Clear(RecCount3);
        Clear(RecCount4);
        Clear(RecCount5);
        Clear(RecCount6);
        Clear(RecCount7);
        Clear(RecCount8);
        Clear(RecCount9);
        Clear(RecCount10);
        Clear(counts);
        progre.Open('Building Timetable:  #1#############################'+
        '\ '+
        '\#2###############################################################'+
        '\#3###############################################################'+
        '\#4###############################################################'+
        '\#5###############################################################'+
        '\#6###############################################################'+
        '\#7###############################################################'+
        '\#8###############################################################'+
        '\#9###############################################################'+
        '\#10###############################################################'+
        '\#11###############################################################'+
        '\#12###############################################################'+
        '\#13###############################################################'+
        '\#14###############################################################',
            progDots,
            RecCount1,
            RecCount2,
            RecCount3,
            RecCount4,
            RecCount5,
            RecCount6,
            RecCount7,
            RecCount8,
            RecCount9,
            RecCount10,
            Var1,
            Var1,
            BufferString
        );
        /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
                    ACALecturersUnits.Reset;
                    ACALecturersUnits.SetRange(Semester,Rec.Semester);
                    if ACALecturersUnits.Find('-') then begin

                        repeat
                            begin
                            begin
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            Clear(Var1);
            counts:=counts+1;
            if ((counted=21) or(counted=11)) then begin
            if counted=21 then counted := 0;
            //SLEEP(150);
            end;
            counted:=counted+1;
            if counted=1 then progDots:=text1
            else if counted=2 then progDots:=text2
            else if counted=3 then progDots:=text3
            else if counted=4 then progDots:=text4
            else if counted=5 then progDots:=text5
            else if counted=6 then progDots:=text6
            else if counted=7 then progDots:=text7
            else if counted=8 then progDots:=text8
            else if counted=9 then progDots:=text9
            else if counted=10 then progDots:=text10
            else if counted=19 then progDots:=text1
            else if counted=18 then progDots:=text2
            else if counted=17 then progDots:=text3
            else if counted=16 then progDots:=text4
            else if counted=15 then progDots:=text5
            else if counted=14 then progDots:=text6
            else if counted=13 then progDots:=text7
            else if counted=12 then progDots:=text8
            else if counted=11 then progDots:=text9
            else progDots:='';

            if counts=1 then
            RecCount1:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end else if counts>10 then begin
            RecCount1:=RecCount2;
            RecCount2:=RecCount3;
            RecCount3:=RecCount4;
            RecCount4:=RecCount5;
            RecCount5:=RecCount6;
            RecCount6:=RecCount7;
            RecCount7:=RecCount8;
            RecCount8:=RecCount9;
            RecCount9:=RecCount10;
            RecCount10:=Format(counts)+'). Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;
        // // //                    TTWeightLessonCategories.RESET;
        // // //                    TTWeightLessonCategories.SETRANGE(Semester,Rec.Semester);
        // // //                    TTWeightLessonCategories.SETRANGE("Category Code",TTUnits."Weighting Category");
        // // //                    IF TTWeightLessonCategories.FIND('-') THEN BEGIN
        // // //                      //Thin Singles
        // // //                      IF TTWeightLessonCategories."Single Classes"= 0 THEN BEGIN
        // // //                        TTTimetableCollectorA.RESET;
        // // //                        TTTimetableCollectorA.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // //                        TTTimetableCollectorA.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // //                        TTTimetableCollectorA.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // //                        TTTimetableCollectorA.SETRANGE(Semester,Rec.Semester);
        // // //                        IF TTTimetableCollectorA.FIND('-') THEN TTTimetableCollectorA.DELETEALL;
        // // //                        END ELSE IF TTWeightLessonCategories."Single Classes"= 1 THEN BEGIN
                                  TTTimetableCollectorA.Reset;
                                TTTimetableCollectorA.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA.SetRange(Allocated,false);
                                TTTimetableCollectorA.SetCurrentkey("Day Order","Lesson Order","Programme Campus Priority","Programme Room Priority","Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority","Lecturer Lesson Priority",
                                "Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorA.Find('-') then begin
                                  TTTimetableCollectorA.Allocated:=true;
                                  TTTimetableCollectorA.Modify;
                                  end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  Clear(CurrLessonOrder);
                                  Clear(NextLessonOrder);
                                  CurrLessonOrder:=TTTimetableCollectorA."Lesson Order";
                                  NextLessonOrder:=TTTimetableCollectorA."Lesson Order"+1;
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        //Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                    TTTimetableCollectorA1.Reset;
                                //TTTimetableCollectorA1.SETRANGE("Class Code",ACALecturersUnits2.Class);
                                TTTimetableCollectorA1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorA1.SetRange(Unit,ACAUnitsSubjects2.Code);
                              //  TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorA1.SetFilter("Lesson Order",'%1|%2',CurrLessonOrder,NextLessonOrder);
                                TTTimetableCollectorA1.SetRange("Date Code",TTTimetableCollectorA."Date Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
                                  // Delete the Unit For the Programme in the whole TT
                                    TTTimetableCollectorA1.Reset;
                                TTTimetableCollectorA1.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  // Capture Timetable for the same Class and Unit

                                  TTTimetableCollectorA1.Reset;
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA1.SetRange("Date Code",TTTimetableCollectorA."Date Code");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then begin
                                  repeat
                                    begin
                                    ///......................................//..................................................
                                                              TTTimetableCollectorA2.Reset;
                                TTTimetableCollectorA2.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA2.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA2.SetRange("Date Code",TTTimetableCollectorA."Date Code");
                                TTTimetableCollectorA2.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA2.SetRange(Allocated,false);
                                if TTTimetableCollectorA2.Find('-') then begin
                                  TTTimetableCollectorA1.Allocated:=true;
                                  TTTimetableCollectorA1.Modify;

                                TTTimetableCollectorA2.Reset;
                                TTTimetableCollectorA2.SetRange(Programme,TTTimetableCollectorA1.Programme);
                                TTTimetableCollectorA2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA2.SetRange(Lecturer,TTTimetableCollectorA1.Lecturer);
                                TTTimetableCollectorA2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA2.SetRange(Allocated,false);
                                if TTTimetableCollectorA2.Find('-') then TTTimetableCollectorA2.DeleteAll;
                                end;
                                ///..........................................//.......................................
                                  end;
                                  until TTTimetableCollectorA1.Next=0;
                                  end;

                                  //Delete fro the Lecturer in a week
                                  TTTimetableCollectorA1.Reset;
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                        //TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
                                         //Delete fro the Room/Day/Lesson
                                         TTTimetableCollectorA1.Reset;
                                      // TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                       TTTimetableCollectorA1.SetRange("Date Code",TTTimetableCollectorA."Date Code");
                                       TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                       TTTimetableCollectorA1.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                       TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                       TTTimetableCollectorA1.SetRange(Allocated,false);
                                       if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // // //                        TTLessons.RESET;
        // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // //                          // Delete from Doubles for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                        //TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                       // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                          END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                       // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
        // // // // // // // //
        // // // // // // // //                        TTLessons.RESET;
        // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // //                          // Delete from Tripples for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 3
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 3",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 3
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 3",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                          END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
        // // // // // // // //                        //Delete All Unallocated from The Singles for Lect/Unit/Campus
                                  TTTimetableCollectorA1.Reset;
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                               // TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
        // // // // // // // //                        END ELSE IF TTWeightLessonCategories."Single Classes"= 2 THEN BEGIN
        // // // // // // // //                          CLEAR(Loops);
        // // // // // // // //                          REPEAT
        // // // // // // // //                            BEGIN
        // // // // // // // //                            /////////////////////////////////////////////////////////////////////////////////////////////// 2 Singles
        // // // // // // // //                          TTTimetableCollectorA.RESET;
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        TTTimetableCollectorA.SETCURRENTKEY("Day Order","Lesson Order","Programme Campus Priority","Programme Room Priority","Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority","Lecture
        // // // // // // // //                        "Unit Campus Priority","Unit Room Priority");
        // // // // // // // //                        IF TTTimetableCollectorA.FIND('-') THEN BEGIN
        // // // // // // // //                          TTTimetableCollectorA.Allocated:=TRUE;
        // // // // // // // //                          TTTimetableCollectorA.MODIFY;
        // // // // // // // //                          END;
        // // // // // // // //                          //Delete fro the Lecturer in a week
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                        IF Loops=0 THEN
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                          //Delete fro the Lecturer/Day/Lesson
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                        //TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                          //Delete fro the Room/Day/Lesson
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                       // TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // // //                        TTLessons.RESET;
        // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // //                          // Delete from Doubles for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                       // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                      //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                       // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                      //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                          END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
        // // // // // // // //
        // // // // // // // //                        TTLessons.RESET;
        // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // //                          // Delete from Tripples for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 3
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 3",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 3
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 3",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                          END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
        // // // // // // // //                        //Delete All Unallocated from The Singles for Lect/Unit/Campus
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                        IF Loops=0 THEN
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                            /////////////////////////////////////////////////////////////////////////////////////////////// 2 Singles
        // // // // // // // //                            Loops:=Loops+1;
        // // // // // // // //                            END;
        // // // // // // // //                              UNTIL Loops=2;
        // // // // // // // //                        END ELSE IF TTWeightLessonCategories."Single Classes"= 3 THEN BEGIN
        // // // // // // // //                          CLEAR(Loops);
        // // // // // // // //                          REPEAT
        // // // // // // // //                            BEGIN
        // // // // // // // //                            /////////////////////////////////////////////////////////////////////////////////////////////// 3 Singles
        // // // // // // // //                          TTTimetableCollectorA.RESET;
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        TTTimetableCollectorA.SETCURRENTKEY("Day Order","Lesson Order","Programme Campus Priority","Programme Room Priority","Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority","Lecture
        // // // // // // // //                        "Unit Campus Priority","Unit Room Priority");
        // // // // // // // //                        IF TTTimetableCollectorA.FIND('-') THEN BEGIN
        // // // // // // // //                          TTTimetableCollectorA.Allocated:=TRUE;
        // // // // // // // //                          TTTimetableCollectorA.MODIFY;
        // // // // // // // //                          END;
        // // // // // // // //                          //Delete fro the Lecturer in a week
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                        IF ((Loops=0) OR (Loops=1)) THEN
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                          //Delete fro the Lecturer/Day/Lesson
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                      //  TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                          //Delete fro the Room/Day/Lesson
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                       // TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // // //                        TTLessons.RESET;
        // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // //                          // Delete from Doubles for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                       // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                      //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                      //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                       // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                          END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorDoubles.RESET;
        // // // // // // // //                      //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorDoubles.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
        // // // // // // // //
        // // // // // // // //                        TTLessons.RESET;
        // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // //                          // Delete from Tripples for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 3
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                      //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 3",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 1",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 2",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //For Lesson 3
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                       // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Lesson 3",TTLessons."Lesson Order");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Room Code",TTTimetableCollectorA."Room Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                          END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorTripple.RESET;
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorTripple.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
        // // // // // // // //                        //Delete All Unallocated from The Singles for Lect/Unit/Campus
        // // // // // // // //                          TTTimetableCollectorA1.RESET;
        // // // // // // // //                        IF ((Loops=0) OR (Loops=1)) THEN
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Date Code",TTTimetableCollectorA."Date Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        TTTimetableCollectorA1.SETRANGE(Allocated,FALSE);
        // // // // // // // //                        IF TTTimetableCollectorA1.FIND('-') THEN TTTimetableCollectorA1.DELETEALL;
        // // // // // // // //                            /////////////////////////////////////////////////////////////////////////////////////////////// 3 Singles
        // // // // // // // //                            Loops:=Loops+1;
        // // // // // // // //                            END;
        // // // // // // // //                              UNTIL Loops=3;
        // // // // // // // //                        END;

                              end;
                            end;
                            until ACALecturersUnits.Next=0;
                            end;
                            progre.Close;
    end;

    local procedure FinalCompilation()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74552;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorA: Record UnknownRecord74557;
        TTTimetableCollectorA1: Record UnknownRecord74557;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74554;
        TTLessons: Record UnknownRecord74556;
        TTDays: Record UnknownRecord74551;
        Loops: Integer;
        TTTimetableFInalCollector: Record UnknownRecord74568;
        progre: Dialog;
        counts: Integer;
        RecCount1: Text[120];
        RecCount2: Text[120];
        RecCount3: Text[120];
        RecCount4: Text[120];
        RecCount5: Text[120];
        RecCount6: Text[120];
        RecCount7: Text[120];
        RecCount8: Text[120];
        RecCount9: Text[120];
        RecCount10: Text[120];
        BufferString: Text[1024];
        Var1: Code[10];
        prempTrns: Record UnknownRecord61091;
        progDots: Text[50];
        counted: Integer;
        text1: label '*';
        text2: label '**';
        text3: label '***';
        text4: label '****';
        text5: label '*****';
        text6: label '******';
        text7: label '*******';
        text8: label '********';
        text9: label '*********';
        text10: label '**********';
    begin
                /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
         Clear(progDots);
        Clear(RecCount1);
        Clear(RecCount2);
        Clear(RecCount3);
        Clear(RecCount4);
        Clear(RecCount5);
        Clear(RecCount6);
        Clear(RecCount7);
        Clear(RecCount8);
        Clear(RecCount9);
        Clear(RecCount10);
        Clear(counts);
        progre.Open('Finalizing Singles:  #1#############################'+
        '\ '+
        '\#2###############################################################'+
        '\#3###############################################################'+
        '\#4###############################################################'+
        '\#5###############################################################'+
        '\#6###############################################################'+
        '\#7###############################################################'+
        '\#8###############################################################'+
        '\#9###############################################################'+
        '\#10###############################################################'+
        '\#11###############################################################'+
        '\#12###############################################################'+
        '\#13###############################################################'+
        '\#14###############################################################',
            progDots,
            RecCount1,
            RecCount2,
            RecCount3,
            RecCount4,
            RecCount5,
            RecCount6,
            RecCount7,
            RecCount8,
            RecCount9,
            RecCount10,
            Var1,
            Var1,
            BufferString
        );
        /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
        TTTimetableFInalCollector.Reset;
        TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
        if TTTimetableFInalCollector.Find('-') then TTTimetableFInalCollector.DeleteAll;
        Clear(CountedEntries);
        //Capture the Singles
        TTTimetableCollectorA.Reset;
        TTTimetableCollectorA.SetRange(Semester,Rec.Semester);
        TTTimetableCollectorA.SetRange(Allocated,true);
        if TTTimetableCollectorA.Find('-') then begin
          repeat
            begin


                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            Clear(Var1);
            counts:=counts+1;
            if ((counted=21) or(counted=11)) then begin
            if counted=21 then counted := 0;
            //SLEEP(150);
            end;
            counted:=counted+1;
            if counted=1 then progDots:=text1
            else if counted=2 then progDots:=text2
            else if counted=3 then progDots:=text3
            else if counted=4 then progDots:=text4
            else if counted=5 then progDots:=text5
            else if counted=6 then progDots:=text6
            else if counted=7 then progDots:=text7
            else if counted=8 then progDots:=text8
            else if counted=9 then progDots:=text9
            else if counted=10 then progDots:=text10
            else if counted=19 then progDots:=text1
            else if counted=18 then progDots:=text2
            else if counted=17 then progDots:=text3
            else if counted=16 then progDots:=text4
            else if counted=15 then progDots:=text5
            else if counted=14 then progDots:=text6
            else if counted=13 then progDots:=text7
            else if counted=12 then progDots:=text8
            else if counted=11 then progDots:=text9
            else progDots:='';

            if counts=1 then
            RecCount1:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code"
            end else if counts>10 then begin
            RecCount1:=RecCount2;
            RecCount2:=RecCount3;
            RecCount3:=RecCount4;
            RecCount4:=RecCount5;
            RecCount5:=RecCount6;
            RecCount6:=RecCount7;
            RecCount7:=RecCount8;
            RecCount8:=RecCount9;
            RecCount9:=RecCount10;
            RecCount10:=Format(counts)+'). Lecturer: '+TTTimetableCollectorA.Lecturer+'; Programme: '+TTTimetableCollectorA.Programme+'; Unit: '+
        TTTimetableCollectorA.Unit+'; Campus: '+TTTimetableCollectorA."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorA.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorA.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Period Code",TTTimetableCollectorA."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Date Code",TTTimetableCollectorA."Date Code");
                              TTTimetableFInalCollector.SetRange("Lecture Room",TTTimetableCollectorA."Lecture Room");
                              TTTimetableFInalCollector.SetRange(Lecturer,TTTimetableCollectorA.Lecturer);
                             // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableFInalCollector.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                              TTTimetableFInalCollector.SetRange("Block/Building",TTTimetableCollectorA."Block/Building");
                             // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if not (TTTimetableFInalCollector.Find('-')) then begin
                               TTTimetableFInalCollector.Init;
                               TTTimetableFInalCollector.Programme:=TTTimetableCollectorA.Programme;
                               TTTimetableFInalCollector.Unit:=TTTimetableCollectorA.Unit;
                               TTTimetableFInalCollector.Semester:=Rec.Semester;
                               TTTimetableFInalCollector."Period Code":=TTTimetableCollectorA."Lesson Code";
                               TTTimetableFInalCollector."Period Category":=TTTimetableCollectorA."Lesson Category";
                               TTTimetableFInalCollector."Date Code":=TTTimetableCollectorA."Date Code";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorA."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorA.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorA.Department;
                               TTTimetableFInalCollector."Date Order":=TTTimetableCollectorA."Day Order";
                               TTTimetableFInalCollector."Period Order":=TTTimetableCollectorA."Lesson Order";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorA."Room Type";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorA."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorA."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorA."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorA."Campus Code";
                               TTTimetableFInalCollector."Period Type":='SINGLE';
                               if ((Rec.Semester<>'') and (TTTimetableCollectorA."Room Code"<>'') and (TTTimetableCollectorA.Lecturer<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableFInalCollector."Record ID":=CountedEntries;
                               TTTimetableFInalCollector.Insert;
                                 end;
                               end;
            end;
            until TTTimetableCollectorA.Next=0;
          end;
          progre.Close;
        // // // // // // // // // // // // // //  //Capture the Doubles
        // // // // // // // // // // // // // //          /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
        // // // // // // // // // // // // // // CLEAR(progDots);
        // // // // // // // // // // // // // // CLEAR(RecCount1);
        // // // // // // // // // // // // // // CLEAR(RecCount2);
        // // // // // // // // // // // // // // CLEAR(RecCount3);
        // // // // // // // // // // // // // // CLEAR(RecCount4);
        // // // // // // // // // // // // // // CLEAR(RecCount5);
        // // // // // // // // // // // // // // CLEAR(RecCount6);
        // // // // // // // // // // // // // // CLEAR(RecCount7);
        // // // // // // // // // // // // // // CLEAR(RecCount8);
        // // // // // // // // // // // // // // CLEAR(RecCount9);
        // // // // // // // // // // // // // // CLEAR(RecCount10);
        // // // // // // // // // // // // // // CLEAR(counts);
        // // // // // // // // // // // // // // progre.OPEN('Finalizing Doubles:  #1#############################'+
        // // // // // // // // // // // // // // '\ '+
        // // // // // // // // // // // // // // '\#2###############################################################'+
        // // // // // // // // // // // // // // '\#3###############################################################'+
        // // // // // // // // // // // // // // '\#4###############################################################'+
        // // // // // // // // // // // // // // '\#5###############################################################'+
        // // // // // // // // // // // // // // '\#6###############################################################'+
        // // // // // // // // // // // // // // '\#7###############################################################'+
        // // // // // // // // // // // // // // '\#8###############################################################'+
        // // // // // // // // // // // // // // '\#9###############################################################'+
        // // // // // // // // // // // // // // '\#10###############################################################'+
        // // // // // // // // // // // // // // '\#11###############################################################'+
        // // // // // // // // // // // // // // '\#12###############################################################'+
        // // // // // // // // // // // // // // '\#13###############################################################'+
        // // // // // // // // // // // // // // '\#14###############################################################',
        // // // // // // // // // // // // // //    progDots,
        // // // // // // // // // // // // // //    RecCount1,
        // // // // // // // // // // // // // //    RecCount2,
        // // // // // // // // // // // // // //    RecCount3,
        // // // // // // // // // // // // // //    RecCount4,
        // // // // // // // // // // // // // //    RecCount5,
        // // // // // // // // // // // // // //    RecCount6,
        // // // // // // // // // // // // // //    RecCount7,
        // // // // // // // // // // // // // //    RecCount8,
        // // // // // // // // // // // // // //    RecCount9,
        // // // // // // // // // // // // // //    RecCount10,
        // // // // // // // // // // // // // //    Var1,
        // // // // // // // // // // // // // //    Var1,
        // // // // // // // // // // // // // //    BufferString
        // // // // // // // // // // // // // // );
        // // // // // // // // // // // // // // /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.RESET;
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.SETRANGE(Allocated,TRUE);
        // // // // // // // // // // // // // // IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // // // // // // // // //  REPEAT
        // // // // // // // // // // // // // //    BEGIN
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //                    ///////////////////////////////////////////////////////////////////////////////Progress Update
        // // // // // // // // // // // // // //                    CLEAR(Var1);
        // // // // // // // // // // // // // //    counts:=counts+1;
        // // // // // // // // // // // // // //    IF ((counted=21) OR(counted=11)) THEN BEGIN
        // // // // // // // // // // // // // //    IF counted=21 THEN counted := 0;
        // // // // // // // // // // // // // //    //SLEEP(150);
        // // // // // // // // // // // // // //    END;
        // // // // // // // // // // // // // //    counted:=counted+1;
        // // // // // // // // // // // // // //    IF counted=1 THEN progDots:=text1
        // // // // // // // // // // // // // //    ELSE IF counted=2 THEN progDots:=text2
        // // // // // // // // // // // // // //    ELSE IF counted=3 THEN progDots:=text3
        // // // // // // // // // // // // // //    ELSE IF counted=4 THEN progDots:=text4
        // // // // // // // // // // // // // //    ELSE IF counted=5 THEN progDots:=text5
        // // // // // // // // // // // // // //    ELSE IF counted=6 THEN progDots:=text6
        // // // // // // // // // // // // // //    ELSE IF counted=7 THEN progDots:=text7
        // // // // // // // // // // // // // //    ELSE IF counted=8 THEN progDots:=text8
        // // // // // // // // // // // // // //    ELSE IF counted=9 THEN progDots:=text9
        // // // // // // // // // // // // // //    ELSE IF counted=10 THEN progDots:=text10
        // // // // // // // // // // // // // //    ELSE IF counted=19 THEN progDots:=text1
        // // // // // // // // // // // // // //    ELSE IF counted=18 THEN progDots:=text2
        // // // // // // // // // // // // // //    ELSE IF counted=17 THEN progDots:=text3
        // // // // // // // // // // // // // //    ELSE IF counted=16 THEN progDots:=text4
        // // // // // // // // // // // // // //    ELSE IF counted=15 THEN progDots:=text5
        // // // // // // // // // // // // // //    ELSE IF counted=14 THEN progDots:=text6
        // // // // // // // // // // // // // //    ELSE IF counted=13 THEN progDots:=text7
        // // // // // // // // // // // // // //    ELSE IF counted=12 THEN progDots:=text8
        // // // // // // // // // // // // // //    ELSE IF counted=11 THEN progDots:=text9
        // // // // // // // // // // // // // //    ELSE progDots:='';
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //    IF counts=1 THEN
        // // // // // // // // // // // // // //    RecCount1:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    ELSE IF counts=2 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount2:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=3 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount3:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=4 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount4:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=5 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount5:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=6 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount6:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=7 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount7:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=8 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount8:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=9 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount9:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=10 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount10:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
        // // // // // // // // // // // // // //    END ELSE IF counts>10 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount1:=RecCount2;
        // // // // // // // // // // // // // //    RecCount2:=RecCount3;
        // // // // // // // // // // // // // //    RecCount3:=RecCount4;
        // // // // // // // // // // // // // //    RecCount4:=RecCount5;
        // // // // // // // // // // // // // //    RecCount5:=RecCount6;
        // // // // // // // // // // // // // //    RecCount6:=RecCount7;
        // // // // // // // // // // // // // //    RecCount7:=RecCount8;
        // // // // // // // // // // // // // //    RecCount8:=RecCount9;
        // // // // // // // // // // // // // //    RecCount9:=RecCount10;
        // // // // // // // // // // // // // //    RecCount10:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code";
        // // // // // // // // // // // // // //    END;
        // // // // // // // // // // // // // //    CLEAR(BufferString);
        // // // // // // // // // // // // // //    BufferString:='Total Tripples processed = '+FORMAT(counts);
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //    progre.UPDATE();
        // // // // // // // // // // // // // //     //SLEEP(50);
        // // // // // // // // // // // // // //                    ///////////////////////////////////////////////////////////////////////////////Progress Update
        // // // // // // // // // // // // // //    TTLessons1.RESET;
        // // // // // // // // // // // // // //    TTLessons1.SETRANGE("Lesson Order",TTTimetableCollectorDoubles."Lesson 1");
        // // // // // // // // // // // // // //    IF TTLessons1.FIND('-') THEN  BEGIN
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.RESET;
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Programme,TTTimetableCollectorDoubles.Programme);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Unit,TTTimetableCollectorDoubles.Unit);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lesson Code",TTLessons1."Lesson Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Date Code",TTTimetableCollectorDoubles."Date Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lecture Room",TTTimetableCollectorDoubles."Lecture Room");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Lecturer,TTTimetableCollectorDoubles.Lecturer);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Block/Building",TTTimetableCollectorDoubles."Block/Building");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
        // // // // // // // // // // // // // //                     IF NOT (TTTimetableFInalCollector.FIND('-')) THEN BEGIN
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INIT;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Programme:=TTTimetableCollectorDoubles.Programme;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Unit:=TTTimetableCollectorDoubles.Unit;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Semester:=Rec.Semester;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Code":=TTLessons1."Lesson Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorDoubles."Lesson Category";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Date Code":=TTTimetableCollectorDoubles."Date Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorDoubles."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorDoubles.Lecturer;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Department:=TTTimetableCollectorDoubles.Department;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Day Order":=TTTimetableCollectorDoubles."Day Order";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Order":=TTLessons1."Lesson Order";
        // // // // // // // // // // // // // //                     //  TTTimetableFInalCollector."Programme Option":=;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Type":=TTTimetableCollectorDoubles."Room Type";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Code":=TTTimetableCollectorDoubles."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorDoubles."Block/Building";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorDoubles."School or Faculty";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorDoubles."Campus Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Type":='DOUBLE';
        // // // // // // // // // // // // // //                       IF ((Rec.Semester<>'') AND (TTTimetableCollectorDoubles."Room Code"<>'') AND (TTTimetableCollectorDoubles.Lecturer<>'')) THEN BEGIN
        // // // // // // // // // // // // // //                         CountedEntries:=CountedEntries+1;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Record ID":=CountedEntries;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INSERT;
        // // // // // // // // // // // // // //                         END;
        // // // // // // // // // // // // // //                       END;
        // // // // // // // // // // // // // //      END;
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //    TTLessons2.RESET;
        // // // // // // // // // // // // // //    TTLessons2.SETRANGE("Lesson Order",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // // // // // // // //    IF TTLessons2.FIND('-') THEN  BEGIN
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.RESET;
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Programme,TTTimetableCollectorDoubles.Programme);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Unit,TTTimetableCollectorDoubles.Unit);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lesson Code",TTLessons2."Lesson Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Date Code",TTTimetableCollectorDoubles."Date Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lecture Room",TTTimetableCollectorDoubles."Lecture Room");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Lecturer,TTTimetableCollectorDoubles.Lecturer);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Block/Building",TTTimetableCollectorDoubles."Block/Building");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
        // // // // // // // // // // // // // //                     IF NOT (TTTimetableFInalCollector.FIND('-')) THEN BEGIN
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INIT;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Programme:=TTTimetableCollectorDoubles.Programme;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Unit:=TTTimetableCollectorDoubles.Unit;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Semester:=Rec.Semester;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Code":=TTLessons2."Lesson Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorDoubles."Lesson Category";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Date Code":=TTTimetableCollectorDoubles."Date Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorDoubles."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorDoubles.Lecturer;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Department:=TTTimetableCollectorDoubles.Department;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Day Order":=TTTimetableCollectorDoubles."Day Order";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Order":=TTLessons2."Lesson Order";
        // // // // // // // // // // // // // //                     //  TTTimetableFInalCollector."Programme Option":=;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Type":=TTTimetableCollectorDoubles."Room Type";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Code":=TTTimetableCollectorDoubles."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorDoubles."Block/Building";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorDoubles."School or Faculty";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorDoubles."Campus Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Type":='DOUBLE';
        // // // // // // // // // // // // // //                       IF ((Rec.Semester<>'') AND (TTTimetableCollectorDoubles."Room Code"<>'') AND (TTTimetableCollectorDoubles.Lecturer<>'')) THEN BEGIN
        // // // // // // // // // // // // // //                         CountedEntries:=CountedEntries+1;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Record ID":=CountedEntries;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INSERT;
        // // // // // // // // // // // // // //                         END;
        // // // // // // // // // // // // // //                       END;
        // // // // // // // // // // // // // //      END;
        // // // // // // // // // // // // // //    END;
        // // // // // // // // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // // // // // // // // //  END;
        // // // // // // // // // // // // // //  progre.CLOSE;
        // // // // // // // // // // // // // //          /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
        // // // // // // // // // // // // // // CLEAR(progDots);
        // // // // // // // // // // // // // // CLEAR(RecCount1);
        // // // // // // // // // // // // // // CLEAR(RecCount2);
        // // // // // // // // // // // // // // CLEAR(RecCount3);
        // // // // // // // // // // // // // // CLEAR(RecCount4);
        // // // // // // // // // // // // // // CLEAR(RecCount5);
        // // // // // // // // // // // // // // CLEAR(RecCount6);
        // // // // // // // // // // // // // // CLEAR(RecCount7);
        // // // // // // // // // // // // // // CLEAR(RecCount8);
        // // // // // // // // // // // // // // CLEAR(RecCount9);
        // // // // // // // // // // // // // // CLEAR(RecCount10);
        // // // // // // // // // // // // // // CLEAR(counts);
        // // // // // // // // // // // // // // progre.OPEN('Finalizing Tripples:  #1#############################'+
        // // // // // // // // // // // // // // '\ '+
        // // // // // // // // // // // // // // '\#2###############################################################'+
        // // // // // // // // // // // // // // '\#3###############################################################'+
        // // // // // // // // // // // // // // '\#4###############################################################'+
        // // // // // // // // // // // // // // '\#5###############################################################'+
        // // // // // // // // // // // // // // '\#6###############################################################'+
        // // // // // // // // // // // // // // '\#7###############################################################'+
        // // // // // // // // // // // // // // '\#8###############################################################'+
        // // // // // // // // // // // // // // '\#9###############################################################'+
        // // // // // // // // // // // // // // '\#10###############################################################'+
        // // // // // // // // // // // // // // '\#11###############################################################'+
        // // // // // // // // // // // // // // '\#12###############################################################'+
        // // // // // // // // // // // // // // '\#13###############################################################'+
        // // // // // // // // // // // // // // '\#14###############################################################',
        // // // // // // // // // // // // // //    progDots,
        // // // // // // // // // // // // // //    RecCount1,
        // // // // // // // // // // // // // //    RecCount2,
        // // // // // // // // // // // // // //    RecCount3,
        // // // // // // // // // // // // // //    RecCount4,
        // // // // // // // // // // // // // //    RecCount5,
        // // // // // // // // // // // // // //    RecCount6,
        // // // // // // // // // // // // // //    RecCount7,
        // // // // // // // // // // // // // //    RecCount8,
        // // // // // // // // // // // // // //    RecCount9,
        // // // // // // // // // // // // // //    RecCount10,
        // // // // // // // // // // // // // //    Var1,
        // // // // // // // // // // // // // //    Var1,
        // // // // // // // // // // // // // //    BufferString
        // // // // // // // // // // // // // // );
        // // // // // // // // // // // // // // /////////////////////////////////////////////////////////////////////////////////////////////Progress Initiate
        // // // // // // // // // // // // // //  //Capture the Tripples
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.RESET;
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.SETRANGE(Allocated,TRUE);
        // // // // // // // // // // // // // // IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // // // // // // // // //  REPEAT
        // // // // // // // // // // // // // //    BEGIN
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //                    ///////////////////////////////////////////////////////////////////////////////Progress Update
        // // // // // // // // // // // // // //                    CLEAR(Var1);
        // // // // // // // // // // // // // //    counts:=counts+1;
        // // // // // // // // // // // // // //    IF ((counted=21) OR(counted=11)) THEN BEGIN
        // // // // // // // // // // // // // //    IF counted=21 THEN counted := 0;
        // // // // // // // // // // // // // //    //SLEEP(150);
        // // // // // // // // // // // // // //    END;
        // // // // // // // // // // // // // //    counted:=counted+1;
        // // // // // // // // // // // // // //    IF counted=1 THEN progDots:=text1
        // // // // // // // // // // // // // //    ELSE IF counted=2 THEN progDots:=text2
        // // // // // // // // // // // // // //    ELSE IF counted=3 THEN progDots:=text3
        // // // // // // // // // // // // // //    ELSE IF counted=4 THEN progDots:=text4
        // // // // // // // // // // // // // //    ELSE IF counted=5 THEN progDots:=text5
        // // // // // // // // // // // // // //    ELSE IF counted=6 THEN progDots:=text6
        // // // // // // // // // // // // // //    ELSE IF counted=7 THEN progDots:=text7
        // // // // // // // // // // // // // //    ELSE IF counted=8 THEN progDots:=text8
        // // // // // // // // // // // // // //    ELSE IF counted=9 THEN progDots:=text9
        // // // // // // // // // // // // // //    ELSE IF counted=10 THEN progDots:=text10
        // // // // // // // // // // // // // //    ELSE IF counted=19 THEN progDots:=text1
        // // // // // // // // // // // // // //    ELSE IF counted=18 THEN progDots:=text2
        // // // // // // // // // // // // // //    ELSE IF counted=17 THEN progDots:=text3
        // // // // // // // // // // // // // //    ELSE IF counted=16 THEN progDots:=text4
        // // // // // // // // // // // // // //    ELSE IF counted=15 THEN progDots:=text5
        // // // // // // // // // // // // // //    ELSE IF counted=14 THEN progDots:=text6
        // // // // // // // // // // // // // //    ELSE IF counted=13 THEN progDots:=text7
        // // // // // // // // // // // // // //    ELSE IF counted=12 THEN progDots:=text8
        // // // // // // // // // // // // // //    ELSE IF counted=11 THEN progDots:=text9
        // // // // // // // // // // // // // //    ELSE progDots:='';
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //    IF counts=1 THEN
        // // // // // // // // // // // // // //    RecCount1:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    ELSE IF counts=2 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount2:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=3 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount3:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=4 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount4:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=5 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount5:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=6 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount6:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=7 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount7:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=8 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount8:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=9 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount9:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END
        // // // // // // // // // // // // // //    ELSE IF counts=10 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount10:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
        // // // // // // // // // // // // // //    END ELSE IF counts>10 THEN BEGIN
        // // // // // // // // // // // // // //    RecCount1:=RecCount2;
        // // // // // // // // // // // // // //    RecCount2:=RecCount3;
        // // // // // // // // // // // // // //    RecCount3:=RecCount4;
        // // // // // // // // // // // // // //    RecCount4:=RecCount5;
        // // // // // // // // // // // // // //    RecCount5:=RecCount6;
        // // // // // // // // // // // // // //    RecCount6:=RecCount7;
        // // // // // // // // // // // // // //    RecCount7:=RecCount8;
        // // // // // // // // // // // // // //    RecCount8:=RecCount9;
        // // // // // // // // // // // // // //    RecCount9:=RecCount10;
        // // // // // // // // // // // // // //    RecCount10:=FORMAT(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        // // // // // // // // // // // // // // TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code";
        // // // // // // // // // // // // // //    END;
        // // // // // // // // // // // // // //    CLEAR(BufferString);
        // // // // // // // // // // // // // //    BufferString:='Total Tripples processed = '+FORMAT(counts);
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //    progre.UPDATE();
        // // // // // // // // // // // // // //     //SLEEP(50);
        // // // // // // // // // // // // // //                    ///////////////////////////////////////////////////////////////////////////////Progress Update
        // // // // // // // // // // // // // //    TTLessons1.RESET;
        // // // // // // // // // // // // // //    TTLessons1.SETRANGE("Lesson Order",TTTimetableCollectorTripple."Lesson 1");
        // // // // // // // // // // // // // //    IF TTLessons1.FIND('-') THEN  BEGIN
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.RESET;
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Programme,TTTimetableCollectorTripple.Programme);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Unit,TTTimetableCollectorTripple.Unit);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lesson Code",TTLessons1."Lesson Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Date Code",TTTimetableCollectorTripple."Date Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lecture Room",TTTimetableCollectorTripple."Lecture Room");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Lecturer,TTTimetableCollectorTripple.Lecturer);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Room Code",TTTimetableCollectorTripple."Room Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Block/Building",TTTimetableCollectorTripple."Block/Building");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
        // // // // // // // // // // // // // //                     IF NOT (TTTimetableFInalCollector.FIND('-')) THEN BEGIN
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INIT;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Programme:=TTTimetableCollectorTripple.Programme;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Unit:=TTTimetableCollectorTripple.Unit;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Semester:=Rec.Semester;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Code":=TTLessons1."Lesson Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorTripple."Lesson Category";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Date Code":=TTTimetableCollectorTripple."Date Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorTripple."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorTripple.Lecturer;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Department:=TTTimetableCollectorTripple.Department;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Day Order":=TTTimetableCollectorTripple."Day Order";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Order":=TTLessons1."Lesson Order";
        // // // // // // // // // // // // // //                     //  TTTimetableFInalCollector."Programme Option":=;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Type":=TTTimetableCollectorTripple."Room Type";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Code":=TTTimetableCollectorTripple."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorTripple."Block/Building";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorTripple."School or Faculty";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorTripple."Campus Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Type":='TRIPPLE';
        // // // // // // // // // // // // // //                       IF ((Rec.Semester<>'') AND (TTTimetableCollectorTripple."Room Code"<>'') AND (TTTimetableCollectorTripple.Lecturer<>'')) THEN BEGIN
        // // // // // // // // // // // // // //                         CountedEntries:=CountedEntries+1;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Record ID":=CountedEntries;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INSERT;
        // // // // // // // // // // // // // //                         END;
        // // // // // // // // // // // // // //                       END;
        // // // // // // // // // // // // // //      END;
        // // // // // // // // // // // // // //
        // // // // // // // // // // // // // //    TTLessons2.RESET;
        // // // // // // // // // // // // // //    TTLessons2.SETRANGE("Lesson Order",TTTimetableCollectorTripple."Lesson 2");
        // // // // // // // // // // // // // //    IF TTLessons2.FIND('-') THEN  BEGIN
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.RESET;
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Programme,TTTimetableCollectorTripple.Programme);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Unit,TTTimetableCollectorTripple.Unit);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lesson Code",TTLessons2."Lesson Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Date Code",TTTimetableCollectorTripple."Date Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lecture Room",TTTimetableCollectorTripple."Lecture Room");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Lecturer,TTTimetableCollectorTripple.Lecturer);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Room Code",TTTimetableCollectorTripple."Room Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Block/Building",TTTimetableCollectorTripple."Block/Building");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
        // // // // // // // // // // // // // //                     IF NOT (TTTimetableFInalCollector.FIND('-')) THEN BEGIN
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INIT;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Programme:=TTTimetableCollectorTripple.Programme;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Unit:=TTTimetableCollectorTripple.Unit;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Semester:=Rec.Semester;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Code":=TTLessons2."Lesson Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorTripple."Lesson Category";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Date Code":=TTTimetableCollectorTripple."Date Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorTripple."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorTripple.Lecturer;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Department:=TTTimetableCollectorTripple.Department;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Day Order":=TTTimetableCollectorTripple."Day Order";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Order":=TTLessons2."Lesson Order";
        // // // // // // // // // // // // // //                     //  TTTimetableFInalCollector."Programme Option":=;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Type":=TTTimetableCollectorTripple."Room Type";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Code":=TTTimetableCollectorTripple."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorTripple."Block/Building";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorTripple."School or Faculty";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorTripple."Campus Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Type":='TRIPPLE';
        // // // // // // // // // // // // // //                       IF ((Rec.Semester<>'') AND (TTTimetableCollectorTripple."Room Code"<>'') AND (TTTimetableCollectorTripple.Lecturer<>'')) THEN BEGIN
        // // // // // // // // // // // // // //                         CountedEntries:=CountedEntries+1;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Record ID":=CountedEntries;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INSERT;
        // // // // // // // // // // // // // //                         END;
        // // // // // // // // // // // // // //                       END;
        // // // // // // // // // // // // // //      END;
        // // // // // // // // // // // // // //    TTLessons3.RESET;
        // // // // // // // // // // // // // //    TTLessons3.SETRANGE("Lesson Order",TTTimetableCollectorTripple."Lesson 3");
        // // // // // // // // // // // // // //    IF TTLessons3.FIND('-') THEN  BEGIN
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.RESET;
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Programme,TTTimetableCollectorTripple.Programme);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Unit,TTTimetableCollectorTripple.Unit);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lesson Code",TTLessons3."Lesson Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Date Code",TTTimetableCollectorTripple."Date Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Lecture Room",TTTimetableCollectorTripple."Lecture Room");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE(Lecturer,TTTimetableCollectorTripple.Lecturer);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Room Code",TTTimetableCollectorTripple."Room Code");
        // // // // // // // // // // // // // //                      TTTimetableFInalCollector.SETRANGE("Block/Building",TTTimetableCollectorTripple."Block/Building");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
        // // // // // // // // // // // // // //                     // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
        // // // // // // // // // // // // // //                     IF NOT (TTTimetableFInalCollector.FIND('-')) THEN BEGIN
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INIT;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Programme:=TTTimetableCollectorTripple.Programme;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Unit:=TTTimetableCollectorTripple.Unit;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Semester:=Rec.Semester;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Code":=TTLessons3."Lesson Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorTripple."Lesson Category";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Date Code":=TTTimetableCollectorTripple."Date Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorTripple."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorTripple.Lecturer;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.Department:=TTTimetableCollectorTripple.Department;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Day Order":=TTTimetableCollectorTripple."Day Order";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Order":=TTLessons3."Lesson Order";
        // // // // // // // // // // // // // //                     //  TTTimetableFInalCollector."Programme Option":=;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Type":=TTTimetableCollectorTripple."Room Type";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Room Code":=TTTimetableCollectorTripple."Room Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorTripple."Block/Building";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorTripple."School or Faculty";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorTripple."Campus Code";
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Lesson Type":='TRIPPLE';
        // // // // // // // // // // // // // //                       IF ((Rec.Semester<>'') AND (TTTimetableCollectorTripple."Room Code"<>'') AND (TTTimetableCollectorTripple.Lecturer<>'')) THEN BEGIN
        // // // // // // // // // // // // // //                         CountedEntries:=CountedEntries+1;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector."Record ID":=CountedEntries;
        // // // // // // // // // // // // // //                       TTTimetableFInalCollector.INSERT;
        // // // // // // // // // // // // // //                         END;
        // // // // // // // // // // // // // //                       END;
        // // // // // // // // // // // // // //      END;
        // // // // // // // // // // // // // //    END;
        // // // // // // // // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // // // // // // // // //  END;
        // // // // // // // // // // // // // //  progre.CLOSE;
    end;

    local procedure SpecificConstraintsProgCampuses()
    var
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTTimetableCollectorSingles: Record UnknownRecord74557;
        TTProgrammes: Record UnknownRecord74553;
        TTUnits: Record UnknownRecord74554;
        TTLecturers: Record UnknownRecord74555;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Singles
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecCampuses.Reset;
        TTProgSpecCampuses.SetRange(Semester,Rec.Semester);
        TTProgSpecCampuses.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecCampuses.SetFilter("Campus Code",'<>%1','');
        if TTProgSpecCampuses.Find('-') then begin
          //There Exists Programme Specific Campus
          repeat
            begin
            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Campus Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Preferred then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Mandatory then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTProgSpecCampuses.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTProgSpecCampuses.Reset;
        TTProgSpecCampuses.SetRange(Semester,Rec.Semester);
        TTProgSpecCampuses.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTProgSpecCampuses.SetFilter("Constraint Category",'=%1',TTProgSpecCampuses."constraint category"::Mandatory);
        if TTProgSpecCampuses.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter("Campus Code",'<>%1',TTProgSpecCampuses."Campus Code");
            end;
            until TTProgSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Singles
        // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Campus on Doubles
        // // // // // // TTProgrammes.RESET;
        // // // // // // TTProgrammes.SETRANGE(Semester,Rec.Semester);
        // // // // // // IF TTProgrammes.FIND('-') THEN BEGIN
        // // // // // //  REPEAT
        // // // // // //    BEGIN
        // // // // // // TTProgSpecCampuses.RESET;
        // // // // // // TTProgSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // TTProgSpecCampuses.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // TTProgSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // IF TTProgSpecCampuses.FIND('-') THEN BEGIN
        // // // // // //  //There Exists Programme Specific Campus
        // // // // // //  REPEAT
        // // // // // //    BEGIN
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::Avoid THEN BEGIN
        // // // // // //      //Delete all entries for the Programme and Campus Specified
        // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // //      END;
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // //      //For the Programme and Campus Specified, Set Priority as 10
        // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // //    REPEAT
        // // // // // //    BEGIN
        // // // // // //      TTTimetableCollectorDoubles."Programme Campus Priority":=10;
        // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // //    END;
        // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // //    END;
        // // // // // //      END;
        // // // // // //
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::Preferred THEN BEGIN
        // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // //    REPEAT
        // // // // // //    BEGIN
        // // // // // //      TTTimetableCollectorDoubles."Programme Campus Priority":=1;
        // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // //    END;
        // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // //    END;
        // // // // // //      END;
        // // // // // //
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::Mandatory THEN BEGIN
        // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // //    REPEAT
        // // // // // //    BEGIN
        // // // // // //      TTTimetableCollectorDoubles."Programme Campus Priority":=1;
        // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // //    END;
        // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // //    END;
        // // // // // //      END;
        // // // // // //    END;
        // // // // // //    UNTIL TTProgSpecCampuses.NEXT=0;
        // // // // // //  END;
        // // // // // //
        // // // // // //
        // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //  CLEAR(ToDeleteDoubles);
        // // // // // //    //// If the Constraints are Nandatory
        // // // // // //  TTProgSpecCampuses.RESET;
        // // // // // // TTProgSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // TTProgSpecCampuses.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // TTProgSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // TTProgSpecCampuses.SETFILTER("Constraint Category",'=%1',TTProgSpecCampuses."Constraint Category"::Mandatory);
        // // // // // // IF TTProgSpecCampuses.FIND('-') THEN BEGIN
        // // // // // //  //There Exists Programme Specific Campus Where Category is Mandatory
        // // // // // //    ToDeleteDoubles:=TRUE;
        // // // // // //  REPEAT
        // // // // // //    BEGIN
        // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'<>%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    END;
        // // // // // //    UNTIL TTProgSpecCampuses.NEXT=0;
        // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // //    IF ToDeleteDoubles THEN TTTimetableCollectorDoubles.DELETE;
        // // // // // //  END;
        // // // // // // END;
        // // // // // // UNTIL TTProgrammes.NEXT=0;
        // // // // // // END;
        // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Campus on Doubles
        // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Campus on Tripples
        // // // // // // TTProgrammes.RESET;
        // // // // // // TTProgrammes.SETRANGE(Semester,Rec.Semester);
        // // // // // // IF TTProgrammes.FIND('-') THEN BEGIN
        // // // // // //  REPEAT
        // // // // // //    BEGIN
        // // // // // // TTProgSpecCampuses.RESET;
        // // // // // // TTProgSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // TTProgSpecCampuses.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // TTProgSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // IF TTProgSpecCampuses.FIND('-') THEN BEGIN
        // // // // // //  //There Exists Programme Specific Campus
        // // // // // //  REPEAT
        // // // // // //    BEGIN
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::Avoid THEN BEGIN
        // // // // // //      //Delete all entries for the Programme and Campus Specified
        // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // //      END;
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // //      //For the Programme and Campus Specified, Set Priority as 10
        // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // //    REPEAT
        // // // // // //    BEGIN
        // // // // // //      TTTimetableCollectorTripple."Programme Campus Priority":=10;
        // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // //    END;
        // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // //    END;
        // // // // // //      END;
        // // // // // //
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::Preferred THEN BEGIN
        // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // //    REPEAT
        // // // // // //    BEGIN
        // // // // // //      TTTimetableCollectorTripple."Programme Campus Priority":=1;
        // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // //    END;
        // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // //    END;
        // // // // // //      END;
        // // // // // //
        // // // // // //    IF TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."Constraint Category"::Mandatory THEN BEGIN
        // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // //    REPEAT
        // // // // // //    BEGIN
        // // // // // //      TTTimetableCollectorTripple."Programme Campus Priority":=1;
        // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // //    END;
        // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // //    END;
        // // // // // //      END;
        // // // // // //    END;
        // // // // // //    UNTIL TTProgSpecCampuses.NEXT=0;
        // // // // // //  END;
        // // // // // //
        // // // // // //
        // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // //  CLEAR(ToDeleteTripples);
        // // // // // //    //// If the Constraints are Nandatory
        // // // // // //  TTProgSpecCampuses.RESET;
        // // // // // // TTProgSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // TTProgSpecCampuses.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // TTProgSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // TTProgSpecCampuses.SETFILTER("Constraint Category",'=%1',TTProgSpecCampuses."Constraint Category"::Mandatory);
        // // // // // // IF TTProgSpecCampuses.FIND('-') THEN BEGIN
        // // // // // //  //There Exists Programme Specific Campus Where Category is Mandatory
        // // // // // //    ToDeleteTripples:=TRUE;
        // // // // // //  REPEAT
        // // // // // //    BEGIN
        // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'<>%1',TTProgSpecCampuses."Campus Code");
        // // // // // //    END;
        // // // // // //    UNTIL TTProgSpecCampuses.NEXT=0;
        // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // //    IF ToDeleteTripples THEN TTTimetableCollectorTripple.DELETE;
        // // // // // //  END;
        // // // // // // END;
        // // // // // // UNTIL TTProgrammes.NEXT=0;
        // // // // // // END;
        // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsLectCampuses()
    var
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTTimetableCollectorSingles: Record UnknownRecord74557;
        TTProgrammes: Record UnknownRecord74553;
        TTUnits: Record UnknownRecord74554;
        TTLecturers: Record UnknownRecord74555;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        TTLecturers.Reset;
        TTLecturers.SetRange(Semester,Rec.Semester);
        if TTLecturers.Find('-') then begin
          repeat
            begin
        TTLectSpecCampuses.Reset;
        TTLectSpecCampuses.SetRange(Semester,Rec.Semester);
        TTLectSpecCampuses.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecCampuses.SetFilter("Campus Code",'<>%1','');
        if TTLectSpecCampuses.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Avoid then begin
              //Delete all entries for the Lecturer and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Lecturer Campus Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Lecturer Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Lecturer Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTLectSpecCampuses.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTLectSpecCampuses.Reset;
        TTLectSpecCampuses.SetRange(Semester,Rec.Semester);
        TTLectSpecCampuses.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTLectSpecCampuses.SetFilter("Constraint Category",'=%1',TTLectSpecCampuses."constraint category"::Mandatory);
        if TTLectSpecCampuses.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter(Lecturer,'<>%1',TTLectSpecCampuses."Lecturer Code");
            end;
            until TTLectSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        // // // // // // // TTLecturers.RESET;
        // // // // // // // TTLecturers.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTLecturers.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTLectSpecCampuses.RESET;
        // // // // // // // TTLectSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecCampuses.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // IF TTLectSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Lecturer Campus Priority":=10;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecCampuses.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //  CLEAR(ToDeleteDoubles);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTLectSpecCampuses.RESET;
        // // // // // // // TTLectSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecCampuses.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // TTLectSpecCampuses.SETFILTER("Constraint Category",'=%1',TTLectSpecCampuses."Constraint Category"::Mandatory);
        // // // // // // // IF TTLectSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteDoubles:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'<>%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecCampuses.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteDoubles THEN TTTimetableCollectorDoubles.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTLecturers.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
        // // // // // // // TTLecturers.RESET;
        // // // // // // // TTLecturers.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTLecturers.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTLectSpecCampuses.RESET;
        // // // // // // // TTLectSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecCampuses.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // IF TTLectSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Lecturer and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Lecturer Campus Priority":=10;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Lecturer nd Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Lecturer nd Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecCampuses.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //  CLEAR(ToDeleteTripples);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTLectSpecCampuses.RESET;
        // // // // // // // TTLectSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecCampuses.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // TTLectSpecCampuses.SETFILTER("Constraint Category",'=%1',TTLectSpecCampuses."Constraint Category"::Mandatory);
        // // // // // // // IF TTLectSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lecturer Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteTripples:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'<>%1',TTLectSpecCampuses."Campus Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecCampuses.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteTripples THEN TTTimetableCollectorTripple.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTLecturers.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsUnitCampuses()
    var
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTTimetableCollectorSingles: Record UnknownRecord74557;
        TTProgrammes: Record UnknownRecord74553;
        TTUnits: Record UnknownRecord74554;
        TTLecturers: Record UnknownRecord74555;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        TTUnits.Reset;
        TTUnits.SetRange(Semester,Rec.Semester);
        if TTUnits.Find('-') then begin
          repeat
            begin
        TTUnitSpecCampuses.Reset;
        TTUnitSpecCampuses.SetRange(Semester,Rec.Semester);
        TTUnitSpecCampuses.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecCampuses.SetFilter("Campus Code",'<>%1','');
        if TTUnitSpecCampuses.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Avoid then begin
              //Delete all entries for the Unit and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Unit Campus Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Unit Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Unit Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTUnitSpecCampuses.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTUnitSpecCampuses.Reset;
        TTUnitSpecCampuses.SetRange(Semester,Rec.Semester);
        TTUnitSpecCampuses.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTUnitSpecCampuses.SetFilter("Constraint Category",'=%1',TTUnitSpecCampuses."constraint category"::Mandatory);
        if TTUnitSpecCampuses.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter(Unit,'<>%1',TTUnitSpecCampuses."Unit Code");
            end;
            until TTUnitSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        // // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        // // // // // // // // TTUnits.RESET;
        // // // // // // // // TTUnits.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // IF TTUnits.FIND('-') THEN BEGIN
        // // // // // // // //  REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // // TTUnitSpecCampuses.RESET;
        // // // // // // // // TTUnitSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // TTUnitSpecCampuses.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // // TTUnitSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // // IF TTUnitSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // // //  REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::Avoid THEN BEGIN
        // // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // // //      END;
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // // //      //For the Lect and Campus Specified, Set Priority as 10
        // // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // // //    REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //      TTTimetableCollectorDoubles."Unit Campus Priority":=10;
        // // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // // //    END;
        // // // // // // // //      END;
        // // // // // // // //
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::Preferred THEN BEGIN
        // // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // // //    REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //      TTTimetableCollectorDoubles."Unit Campus Priority":=1;
        // // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // // //    END;
        // // // // // // // //      END;
        // // // // // // // //
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // // //    REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //      TTTimetableCollectorDoubles."Unit Campus Priority":=1;
        // // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // // //    END;
        // // // // // // // //      END;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTUnitSpecCampuses.NEXT=0;
        // // // // // // // //  END;
        // // // // // // // //
        // // // // // // // //
        // // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //  CLEAR(ToDeleteDoubles);
        // // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // // //  TTUnitSpecCampuses.RESET;
        // // // // // // // // TTUnitSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // TTUnitSpecCampuses.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // // TTUnitSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // // TTUnitSpecCampuses.SETFILTER("Constraint Category",'=%1',TTUnitSpecCampuses."Constraint Category"::Mandatory);
        // // // // // // // // IF TTUnitSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // // //  //There Exists Lect Specific Campus Where Category is Mandatory
        // // // // // // // //    ToDeleteDoubles:=TRUE;
        // // // // // // // //  REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Campus Code",'<>%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTUnitSpecCampuses.NEXT=0;
        // // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // // //    IF ToDeleteDoubles THEN TTTimetableCollectorDoubles.DELETE;
        // // // // // // // //  END;
        // // // // // // // // END;
        // // // // // // // // UNTIL TTUnits.NEXT=0;
        // // // // // // // // END;
        // // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        // // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
        // // // // // // // // TTUnits.RESET;
        // // // // // // // // TTUnits.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // IF TTUnits.FIND('-') THEN BEGIN
        // // // // // // // //  REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // // TTUnitSpecCampuses.RESET;
        // // // // // // // // TTUnitSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // TTUnitSpecCampuses.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // // TTUnitSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // // IF TTUnitSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // // //  REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::Avoid THEN BEGIN
        // // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // // //      END;
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // // //      //For the Unit and Campus Specified, Set Priority as 10
        // // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // // //    REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //      TTTimetableCollectorTripple."Unit Campus Priority":=10;
        // // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // // //    END;
        // // // // // // // //      END;
        // // // // // // // //
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::Preferred THEN BEGIN
        // // // // // // // //      //For the Unit nd Campus Specified, Set Priority as 1
        // // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // // //    REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //      TTTimetableCollectorTripple."Unit Campus Priority":=1;
        // // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // // //    END;
        // // // // // // // //      END;
        // // // // // // // //
        // // // // // // // //    IF TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // // //      //For the Unit nd Campus Specified, Set Priority as 1
        // // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // // //    REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //      TTTimetableCollectorTripple."Unit Campus Priority":=1;
        // // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // // //    END;
        // // // // // // // //      END;
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTUnitSpecCampuses.NEXT=0;
        // // // // // // // //  END;
        // // // // // // // //
        // // // // // // // //
        // // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // // //  CLEAR(ToDeleteTripples);
        // // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // // //  TTUnitSpecCampuses.RESET;
        // // // // // // // // TTUnitSpecCampuses.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // TTUnitSpecCampuses.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // // TTUnitSpecCampuses.SETFILTER("Campus Code",'<>%1','');
        // // // // // // // // TTUnitSpecCampuses.SETFILTER("Constraint Category",'=%1',TTUnitSpecCampuses."Constraint Category"::Mandatory);
        // // // // // // // // IF TTUnitSpecCampuses.FIND('-') THEN BEGIN
        // // // // // // // //  //There Exists Unit Specific Campus Where Category is Mandatory
        // // // // // // // //    ToDeleteTripples:=TRUE;
        // // // // // // // //  REPEAT
        // // // // // // // //    BEGIN
        // // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Campus Code",'<>%1',TTUnitSpecCampuses."Campus Code");
        // // // // // // // //    END;
        // // // // // // // //    UNTIL TTUnitSpecCampuses.NEXT=0;
        // // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // // //    IF ToDeleteTripples THEN TTTimetableCollectorTripple.DELETE;
        // // // // // // // //  END;
        // // // // // // // // END;
        // // // // // // // // UNTIL TTUnits.NEXT=0;
        // // // // // // // // END;
        // // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsUnitRooms()
    var
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTTimetableCollectorSingles: Record UnknownRecord74557;
        TTProgrammes: Record UnknownRecord74553;
        TTUnits: Record UnknownRecord74554;
        TTLecturers: Record UnknownRecord74555;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        TTUnits.Reset;
        TTUnits.SetRange(Semester,Rec.Semester);
        if TTUnits.Find('-') then begin
          repeat
            begin
        TTUnitSpecRooms.Reset;
        TTUnitSpecRooms.SetRange(Semester,Rec.Semester);
        TTUnitSpecRooms.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecRooms.SetFilter("Room Code",'<>%1','');
        if TTUnitSpecRooms.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Avoid then begin
              //Delete all entries for the Unit and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Unit Room Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Unit Room Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Unit Room Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTUnitSpecRooms.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTUnitSpecRooms.Reset;
        TTUnitSpecRooms.SetRange(Semester,Rec.Semester);
        TTUnitSpecRooms.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecRooms.SetFilter("Room Code",'<>%1','');
        TTUnitSpecRooms.SetFilter("Constraint Category",'=%1',TTUnitSpecRooms."constraint category"::Mandatory);
        if TTUnitSpecRooms.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter(Unit,'<>%1',TTUnitSpecRooms."Unit Code");
            end;
            until TTUnitSpecRooms.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        // // // // // // // TTUnits.RESET;
        // // // // // // // TTUnits.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTUnits.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTUnitSpecRooms.RESET;
        // // // // // // // TTUnitSpecRooms.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTUnitSpecRooms.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // TTUnitSpecRooms.SETFILTER("Room Code",'<>%1','');
        // // // // // // // IF TTUnitSpecRooms.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Unit Room Priority":=10;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Unit Room Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Unit Room Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTUnitSpecRooms.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //  CLEAR(ToDeleteDoubles);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTUnitSpecRooms.RESET;
        // // // // // // // TTUnitSpecRooms.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTUnitSpecRooms.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // TTUnitSpecRooms.SETFILTER("Room Code",'<>%1','');
        // // // // // // // TTUnitSpecRooms.SETFILTER("Constraint Category",'=%1',TTUnitSpecRooms."Constraint Category"::Mandatory);
        // // // // // // // IF TTUnitSpecRooms.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteDoubles:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTUnitSpecRooms.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteDoubles THEN TTTimetableCollectorDoubles.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTUnits.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
        // // // // // // // TTUnits.RESET;
        // // // // // // // TTUnits.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTUnits.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTUnitSpecRooms.RESET;
        // // // // // // // TTUnitSpecRooms.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTUnitSpecRooms.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // TTUnitSpecRooms.SETFILTER("Room Code",'<>%1','');
        // // // // // // // IF TTUnitSpecRooms.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Unit and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Unit Room Priority":=10;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Unit nd Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Unit Room Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Unit nd Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Room Code",'%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Unit Room Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTUnitSpecRooms.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Unit,TTUnits."Unit Code");
        // // // // // // //  CLEAR(ToDeleteTripples);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTUnitSpecRooms.RESET;
        // // // // // // // TTUnitSpecRooms.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTUnitSpecRooms.SETRANGE("Unit Code",TTUnits."Unit Code");
        // // // // // // // TTUnitSpecRooms.SETFILTER("Room Code",'<>%1','');
        // // // // // // // TTUnitSpecRooms.SETFILTER("Constraint Category",'=%1',TTUnitSpecRooms."Constraint Category"::Mandatory);
        // // // // // // // IF TTUnitSpecRooms.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Unit Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteTripples:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTUnitSpecRooms.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteTripples THEN TTTimetableCollectorTripple.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTUnits.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsProgDays()
    var
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTTimetableCollectorSingles: Record UnknownRecord74557;
        TTProgrammes: Record UnknownRecord74553;
        TTUnits: Record UnknownRecord74554;
        TTLecturers: Record UnknownRecord74555;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Prog Spec. Days on Singles
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecDays.Reset;
        TTProgSpecDays.SetRange(Semester,Rec.Semester);
        TTProgSpecDays.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecDays.SetFilter("Date Code",'<>%1',0D);
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus
          repeat
            begin
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTProgSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTProgSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Day Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTProgSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Day Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTProgSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Day Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTProgSpecDays.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTProgSpecDays.Reset;
        TTProgSpecDays.SetRange(Semester,Rec.Semester);
        TTProgSpecDays.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecDays.SetFilter("Date Code",'<>%1',0D);
        TTProgSpecDays.SetFilter("Constraint Category",'=%1',TTProgSpecDays."constraint category"::Mandatory);
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter("Date Code",'<>%1',TTProgSpecDays."Date Code");
            end;
            until TTProgSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Days on Singles
        // // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Days on Doubles
        // // // // // // // TTProgrammes.RESET;
        // // // // // // // TTProgrammes.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTProgrammes.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTProgSpecDays.RESET;
        // // // // // // // TTProgSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTProgSpecDays.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // // TTProgSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // IF TTProgSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Programme Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Programme and Campus Specified
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Programme and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Programme Day Priority":=10;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Programme Day Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Programme Day Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTProgSpecDays.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //  CLEAR(ToDeleteDoubles);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTProgSpecDays.RESET;
        // // // // // // // TTProgSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTProgSpecDays.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // // TTProgSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // TTProgSpecDays.SETFILTER("Constraint Category",'=%1',TTProgSpecDays."Constraint Category"::Mandatory);
        // // // // // // // IF TTProgSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Programme Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteDoubles:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'<>%1',TTProgSpecDays."Date Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTProgSpecDays.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteDoubles THEN TTTimetableCollectorDoubles.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTProgrammes.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Days on Doubles
        // // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Days on Tripples
        // // // // // // // TTProgrammes.RESET;
        // // // // // // // TTProgrammes.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTProgrammes.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTProgSpecDays.RESET;
        // // // // // // // TTProgSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTProgSpecDays.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // // TTProgSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // IF TTProgSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Programme Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Programme and Campus Specified
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Programme and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Programme Day Priority":=10;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Programme Day Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTProgSpecDays."Constraint Category"=TTProgSpecDays."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Programme and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTProgSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Programme Day Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTProgSpecDays.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Programme,TTProgrammes."Programme Code");
        // // // // // // //  CLEAR(ToDeleteTripples);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTProgSpecDays.RESET;
        // // // // // // // TTProgSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTProgSpecDays.SETRANGE("Programme Code",TTProgrammes."Programme Code");
        // // // // // // // TTProgSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // TTProgSpecDays.SETFILTER("Constraint Category",'=%1',TTProgSpecDays."Constraint Category"::Mandatory);
        // // // // // // // IF TTProgSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Programme Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteTripples:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'<>%1',TTProgSpecDays."Date Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTProgSpecDays.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteTripples THEN TTTimetableCollectorTripple.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTProgrammes.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Prog Spec. Days on Tripples
    end;

    local procedure SpecificConstraintsLectDays()
    var
        TTProgSpecCampuses: Record UnknownRecord74558;
        TTProgSpecDays: Record UnknownRecord74559;
        TTLectSpecCampuses: Record UnknownRecord74560;
        TTLectSpecDays: Record UnknownRecord74561;
        TTLectSpecLessons: Record UnknownRecord74562;
        TTUnitSpecCampuses: Record UnknownRecord74564;
        TTUnitSpecRooms: Record UnknownRecord74565;
        TTTimetableCollectorSingles: Record UnknownRecord74557;
        TTProgrammes: Record UnknownRecord74553;
        TTUnits: Record UnknownRecord74554;
        TTLecturers: Record UnknownRecord74555;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Lect Spec. Days on Singles
        TTLecturers.Reset;
        TTLecturers.SetRange(Semester,Rec.Semester);
        if TTLecturers.Find('-') then begin
          repeat
            begin
        TTLectSpecDays.Reset;
        TTLectSpecDays.SetRange(Semester,Rec.Semester);
        TTLectSpecDays.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecDays.SetFilter("Date Code",'<>%1',0D);
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Lecturer and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTLectSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTLectSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Lecturer Campus Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTLectSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Lecturer Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Date Code",'%1',TTLectSpecDays."Date Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Lecturer Campus Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTLectSpecDays.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTLectSpecDays.Reset;
        TTLectSpecDays.SetRange(Semester,Rec.Semester);
        TTLectSpecDays.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecDays.SetFilter("Date Code",'<>%1',0D);
        TTLectSpecDays.SetFilter("Constraint Category",'=%1',TTLectSpecDays."constraint category"::Mandatory);
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter(Lecturer,'<>%1',TTLectSpecDays."Lecturer Code");
            end;
            until TTLectSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Days on Singles
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Days on Doubles
        // // // // // // // TTLecturers.RESET;
        // // // // // // // TTLecturers.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTLecturers.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTLectSpecDays.RESET;
        // // // // // // // TTLectSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecDays.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // IF TTLectSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN TTTimetableCollectorDoubles.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Lecturer Campus Priority":=10;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Lect and Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorDoubles.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorDoubles.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorDoubles.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecDays.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorDoubles.RESET;
        // // // // // // //    TTTimetableCollectorDoubles.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //  CLEAR(ToDeleteDoubles);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTLectSpecDays.RESET;
        // // // // // // // TTLectSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecDays.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // TTLectSpecDays.SETFILTER("Constraint Category",'=%1',TTLectSpecDays."Constraint Category"::Mandatory);
        // // // // // // // IF TTLectSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteDoubles:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorDoubles.SETFILTER("Date Code",'<>%1',TTLectSpecDays."Date Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecDays.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteDoubles THEN TTTimetableCollectorDoubles.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTLecturers.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Days on Doubles
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Days on Tripples
        // // // // // // // TTLecturers.RESET;
        // // // // // // // TTLecturers.SETRANGE(Semester,Rec.Semester);
        // // // // // // // IF TTLecturers.FIND('-') THEN BEGIN
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // // TTLectSpecDays.RESET;
        // // // // // // // TTLectSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecDays.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // IF TTLectSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lect Specific Campus
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::Avoid THEN BEGIN
        // // // // // // //      //Delete all entries for the Lect and Campus Specified
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN TTTimetableCollectorTripple.DELETEALL;
        // // // // // // //      END;
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::"Least Preferred" THEN BEGIN
        // // // // // // //      //For the Lecturer and Campus Specified, Set Priority as 10
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Lecturer Campus Priority":=10;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::Preferred THEN BEGIN
        // // // // // // //      //For the Lecturer nd Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //
        // // // // // // //    IF TTLectSpecDays."Constraint Category"=TTLectSpecDays."Constraint Category"::Mandatory THEN BEGIN
        // // // // // // //      //For the Lecturer nd Campus Specified, Set Priority as 1
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'%1',TTLectSpecDays."Date Code");
        // // // // // // //    IF TTTimetableCollectorTripple.FIND('-') THEN BEGIN
        // // // // // // //    REPEAT
        // // // // // // //    BEGIN
        // // // // // // //      TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
        // // // // // // //      TTTimetableCollectorTripple.MODIFY;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTTimetableCollectorTripple.NEXT=0;
        // // // // // // //    END;
        // // // // // // //      END;
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecDays.NEXT=0;
        // // // // // // //  END;
        // // // // // // //
        // // // // // // //
        // // // // // // //    TTTimetableCollectorTripple.RESET;
        // // // // // // //    TTTimetableCollectorTripple.SETRANGE(Lecturer,TTLecturers."Lecturer Code");
        // // // // // // //  CLEAR(ToDeleteTripples);
        // // // // // // //    //// If the Constraints are Nandatory
        // // // // // // //  TTLectSpecDays.RESET;
        // // // // // // // TTLectSpecDays.SETRANGE(Semester,Rec.Semester);
        // // // // // // // TTLectSpecDays.SETRANGE("Lecturer Code",TTLecturers."Lecturer Code");
        // // // // // // // TTLectSpecDays.SETFILTER("Date Code",'<>%1','');
        // // // // // // // TTLectSpecDays.SETFILTER("Constraint Category",'=%1',TTLectSpecDays."Constraint Category"::Mandatory);
        // // // // // // // IF TTLectSpecDays.FIND('-') THEN BEGIN
        // // // // // // //  //There Exists Lecturer Specific Campus Where Category is Mandatory
        // // // // // // //    ToDeleteTripples:=TRUE;
        // // // // // // //  REPEAT
        // // // // // // //    BEGIN
        // // // // // // //    //Keep filtering where Campus code is Not the one selected...
        // // // // // // //    TTTimetableCollectorTripple.SETFILTER("Date Code",'<>%1',TTLectSpecDays."Date Code");
        // // // // // // //    END;
        // // // // // // //    UNTIL TTLectSpecDays.NEXT=0;
        // // // // // // //    // After Repeated Filtering, Delete All Entries in the Filters
        // // // // // // //    IF ToDeleteTripples THEN TTTimetableCollectorTripple.DELETE;
        // // // // // // //  END;
        // // // // // // // END;
        // // // // // // // UNTIL TTLecturers.NEXT=0;
        // // // // // // // END;
        // // // // // // // //////////////////////////////////////////////////////////////Lect Spec. Days on Tripples
    end;
}

