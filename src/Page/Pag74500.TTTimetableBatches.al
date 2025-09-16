#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74500 "TT-Timetable Batches"
{
    ApplicationArea = Basic;
    Caption = 'Timetable Batches';
    PageType = List;
    SourceTable = UnknownTable74505;
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
                RunObject = Page "TT-Timetable Programs";
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
                RunObject = Page "TT-Timetable Units";
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
                RunObject = Page "TT-Timetable Lecturers";
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
            action(Days)
            {
                ApplicationArea = Basic;
                Caption = 'Days';
                Image = CalendarWorkcenter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "TT-Days";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action("Lesson Weighting")
            {
                ApplicationArea = Basic;
                Caption = 'Lesson Weighting';
                Image = CreateBins;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "TT-Weight Lesson Categories";
                RunPageLink = "Academic Year"=field("Academic Year"),
                              Semester=field(Semester);
            }
            action("Lessons List")
            {
                ApplicationArea = Basic;
                Caption = 'Lessons List';
                Image = CreateRating;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "TT-Lessons";
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
                    TTLecturers: Record UnknownRecord74518;
                    TTProgrammes: Record UnknownRecord74504;
                    TTUnits: Record UnknownRecord74517;
                    LectLoadBatchLines: Record UnknownRecord65202;
                    TTWeightLessonCategories: Record UnknownRecord74506;
                begin
                    // Rec.CALCFIELDS(Current);
                     //IF Rec.Active=FALSE THEN ERROR('The Semester is not marked as active');
                    if Confirm('Generate Automatic Constraints, Continue?',false)=false then Error('Cancelled by user!');
                    //IF CONFIRM('You may be required to regenerate your timetable \after generating your constraints. \Continue?',TRUE)=FALSE THEN  ERROR('Cancelled by user!');
                    
                    //Get Default Catogory
                    TTWeightLessonCategories.Reset;
                    TTWeightLessonCategories.SetRange(Semester,Rec.Semester);
                    TTWeightLessonCategories.SetRange("Default Category",true);
                    if TTWeightLessonCategories.Find('-') then begin
                      end else Error('Defauly Unit Weighting category is not defined!');
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
                              TTUnits."Weighting Category":=TTWeightLessonCategories."Category Code";
                              TTUnits.Insert;
                              end;
                            end;
                          until LectLoadBatchLines.Next=0;
                      end else Error('Caurse loading for the current Semester has not been done!');
                    
                    //IF CONFIRM('Re-Generate the timetable Entries?',TRUE)=FALSE THEN EXIT;
                             GenerateEntriesSingles;
                             GenerateEntriesDoubles;
                             GenerateEntriesTripple;
                    // // // // //         SpecificConstraintsProgCampuses;
                    // // // // //         SpecificConstraintsLectCampuses;
                    // // // // //         SpecificConstraintsUnitCampuses;
                    // // // // //         SpecificConstraintsProgRooms;
                    // // // // //         SpecificConstraintsUnitRooms;
                    // // // // //         SpecificConstraintsProgDays;
                    // // // // //         SpecificConstraintsLectDays;
                             ThiningSingles;
                             ThiningDoubles;
                             ThiningTripples;
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
                      Report.Run(74500,true,false,TTTimetableFInalCollector);
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
                      Report.Run(74501,true,false,TTTimetableFInalCollector);
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
                    TTUnits: Record UnknownRecord74517;
                begin
                    TTUnits.Reset;
                    TTUnits.SetRange(Semester,Rec.Semester);
                    if TTUnits.Find('-') then
                      Report.Run(74502,true,false,TTUnits);
                end;
            }
            action("Timetable Preview")
            {
                ApplicationArea = Basic;
                Caption = 'Timetable Preview';
                Image = PreviewChecks;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "TT-Preview";
                RunPageLink = Semester=field(Semester);
            }
        }
    }

    var
        CountedEntries: Integer;
        TTTimetableFInalCollector: Record UnknownRecord74523;
        TTUnitSpecRooms111: Record UnknownRecord74514;
        TTRooms2: Record UnknownRecord74501;

    local procedure GenerateEntriesSingles()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorA: Record UnknownRecord74500;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
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
        Var1: Code[20];
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
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecDays: Record UnknownRecord74508;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
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
        TTTimetableCollectorA.Reset;
        TTTimetableCollectorA.SetRange(Semester,Rec.Semester);
        if TTTimetableCollectorA.Find('-') then TTTimetableCollectorA.DeleteAll;
        Clear(CountedEntries);
        TTRooms.Reset;
        TTRooms.SetRange(TTRooms.Status, TTRooms.Status::Active);
        //TTRooms.SETRANGE(Semester,Rec.Semester);
        if TTRooms.Find('-') then begin
          repeat
            begin
              TTDailyLessons.Reset;
              TTDailyLessons.SetRange(Semester,Rec.Semester);
              if TTDailyLessons.Find('-') then begin
                repeat
                  begin
                  TTLessons.Reset;
                  TTLessons.SetRange("Lesson Code",TTDailyLessons."Lesson Code");
                  if TTLessons.Find('-') then;
                  TTDays.Reset;
                  TTDays.SetRange("Day Code",TTDailyLessons."Day Code");
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
            RecCount1:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
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
            RecCount10:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total Records processed = '+Format(counts);

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
                             TTProgSpecDays.SetFilter("Day Code",'%1',TTDailyLessons."Day Code");
                             if TTProgSpecDays.Find('-') then begin
                               if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then ProgSpecDays:=666
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then ProgSpecDays:=333
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then ProgSpecDays:=3
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then ProgSpecDays:=1;
                               end;

                             TTProgSpecRooms.Reset;
                             TTProgSpecRooms.SetRange(Semester,Rec.Semester);
                             TTProgSpecRooms.SetRange("Programme Code",ACALecturersUnits.Programme);
                             TTProgSpecRooms.SetFilter("Room Code",'%1',TTRooms."Room Code");
                             if TTProgSpecRooms.Find('-') then begin
                               if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Avoid then ProgSpecRoom:=666
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::"Least Preferred" then ProgSpecRoom:=333
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Preferred then ProgSpecRoom:=3
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Mandatory then ProgSpecRoom:=1;
                               end;
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
                             TTLectSpecLessons.SetFilter("Lesson Code",'%1',TTDailyLessons."Lesson Code");
                             if TTLectSpecLessons.Find('-') then begin
                               if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::Avoid then LectSpecLessons:=666
                               else if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::"Least Preferred" then LectSpecLessons:=333
                               else if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::Preferred then LectSpecLessons:=3
                               else if TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."constraint category"::Mandatory then LectSpecLessons:=1;
                               end;

                             TTLectSpecDays.Reset;
                             TTLectSpecDays.SetRange(Semester,Rec.Semester);
                             TTLectSpecDays.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                             TTLectSpecDays.SetFilter("Day Code",'%1',TTDailyLessons."Day Code");
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
                              TTTimetableCollectorA.SetRange("Lesson Code",TTDailyLessons."Lesson Code");
                              TTTimetableCollectorA.SetRange("Day of Week",TTDailyLessons."Day Code");
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
                               TTTimetableCollectorA."Lesson Code":=TTDailyLessons."Lesson Code";
                               TTTimetableCollectorA."Lesson Category":=TTUnits."Weighting Category";
                               TTTimetableCollectorA."Day of Week":=TTDailyLessons."Day Code";
                               TTTimetableCollectorA."Lecture Room":=TTRooms."Room Code";
                               TTTimetableCollectorA.Lecturer:=LectLoadBatchLines."Lecturer Code";
                               TTTimetableCollectorA.Department:=LectLoadBatchLines."Department Code";
                               TTTimetableCollectorA."Day Order":=TTDays."Day Order";
                               TTTimetableCollectorA."Lesson Order":=TTLessons."Lesson Order";
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
                             if TTRooms."Room Type"<>TTRooms."room type"::Class then begin
                               TTUnitSpecRooms111.Reset;
                               TTUnitSpecRooms111.SetRange(Semester,Rec.Semester);
                               TTUnitSpecRooms111.SetRange("Programme Code",ACALecturersUnits.Programme);
                               TTUnitSpecRooms111.SetRange("Unit Code",ACALecturersUnits.Unit);
                               TTUnitSpecRooms111.SetRange("Room Code",TTRooms."Room Code");
                               if TTUnitSpecRooms111.Find('-') then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorA."Record ID":=CountedEntries;
                                 TTTimetableCollectorA.Insert;
                                 end;
                               end else begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorA."Record ID":=CountedEntries;
                               TTTimetableCollectorA.Insert;
                                 end;
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

    local procedure GenerateEntriesDoubles()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
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
        Var1: Code[20];
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
        progre.Open('Generating Entries for Doubles:  #1#############################'+
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
        TTTimetableCollectorDoubles.Reset;
        TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
        if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
        Clear(CountedEntries);
        TTRooms.Reset;
        //TTRooms.SETRANGE(Semester,Rec.Semester);
        if TTRooms.Find('-') then begin
          repeat
            begin
           TTDays.Reset;
           //TTDays.SETRANGE("Day Code",TTDailyLessons."Day Code");
           TTDays.SetRange(Semester,Rec.Semester);
                  if TTDays.Find('-') then begin
                    repeat
                      begin
              TTDailyLessons.Reset;
              TTDailyLessons.SetRange(Semester,Rec.Semester);
              TTDailyLessons.SetRange("Day Code",TTDays."Day Code");
              if TTDailyLessons.Find('-') then begin
                repeat
                  begin
                  TTLessons.Reset;
                  TTLessons.SetRange("Lesson Code",TTDailyLessons."Lesson Code");
                  if TTLessons.Find('-') then;

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
            RecCount1:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
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
            RecCount10:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total Records processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            LectLoadBatchLines.Reset;
                            LectLoadBatchLines.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                            LectLoadBatchLines.SetRange("Semester Code",Rec.Semester);
                            if LectLoadBatchLines.Find('-') then;
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;

                            //IF TTLessons."Lesson Order"=1, then insert for 1, &2
                            if TTLessons."Lesson Order"=1 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",2);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,1,2,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 2, 3

                            //IF TTLessons."Lesson Order"=2, then insert for 2, & 3
                            if TTLessons."Lesson Order"=2 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",3);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,2,3,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                               end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 2, 3

                              ////////////////////////////////////////////////////////////////////////////////// 3, 4

                            //IF TTLessons."Lesson Order"=3, then insert for 3, & 4
                            if TTLessons."Lesson Order"=3 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",4);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,3,4,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 3, 4

                              ////////////////////////////////////////////////////////////////////////////////// 4, 5

                            //IF TTLessons."Lesson Order"=4, then insert for 4, & 5
                            if TTLessons."Lesson Order"=4 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",5);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,4,5,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 4, 5
                              ////////////////////////////////////////////////////////////////////////////////// 5, 6

                            //IF TTLessons."Lesson Order"=5, then insert for 5, & 6
                            if TTLessons."Lesson Order"=5 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",6);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,5,6,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 5, 6
                              ////////////////////////////////////////////////////////////////////////////////// 6, 7

                            //IF TTLessons."Lesson Order"=6, then insert for 6, & 7
                            if TTLessons."Lesson Order"=6 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",7);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,6,7,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 6, 7
                              ////////////////////////////////////////////////////////////////////////////////// 7, 8

                            //IF TTLessons."Lesson Order"=7, then insert for 7, & 8
                            if TTLessons."Lesson Order"=7 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",8);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,7,8,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 7, 8
                              ////////////////////////////////////////////////////////////////////////////////// 8, 9

                            //IF TTLessons."Lesson Order"=8, then insert for 8, & 9
                            if TTLessons."Lesson Order"=8 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",9);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,8,9,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 8, 9
                              ////////////////////////////////////////////////////////////////////////////////// 9, 10

                            //IF TTLessons."Lesson Order"=9, then insert for 9, & 10
                            if TTLessons."Lesson Order"=9 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",10);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,9,10,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 9, 10
                              ////////////////////////////////////////////////////////////////////////////////// 10, 11

                            //IF TTLessons."Lesson Order"=10, then insert for 10, & 11
                            if TTLessons."Lesson Order"=10 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",11);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,10,11,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 10, 11
                              ////////////////////////////////////////////////////////////////////////////////// 11, 12

                            //IF TTLessons."Lesson Order"=11, then insert for 11, & 12
                            if TTLessons."Lesson Order"=11 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",12);
                              if TTLessons2.Find('-') then begin
        // // // // //                          //Insert a Doubles Combination Here

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,11,12,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 11, 12
                              ////////////////////////////////////////////////////////////////////////////////// 12, 13

                            //IF TTLessons."Lesson Order"=12, then insert for 12, & 13
                            if TTLessons."Lesson Order"=12 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",13);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,12,13,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 12, 13
                              ////////////////////////////////////////////////////////////////////////////////// 13, 14

                            //IF TTLessons."Lesson Order"=13, then insert for 13, & 14
                            if TTLessons."Lesson Order"=13 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",14);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,13,14,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 13, 14
                              ////////////////////////////////////////////////////////////////////////////////// 14, 15

                            //IF TTLessons."Lesson Order"=14, then insert for 14, & 15
                            if TTLessons."Lesson Order"=14 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",15);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,14,15,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 14, 15
                              ////////////////////////////////////////////////////////////////////////////////// 15, 16

                            //IF TTLessons."Lesson Order"=15, then insert for 15, & 16
                            if TTLessons."Lesson Order"=15 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",16);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,15,16,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 15, 16
                              ////////////////////////////////////////////////////////////////////////////////// 16, 17

                            //IF TTLessons."Lesson Order"=16, then insert for 16, & 17
                            if TTLessons."Lesson Order"=16 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",17);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,16,17,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 16, 17
                              ////////////////////////////////////////////////////////////////////////////////// 17, 18

                            //IF TTLessons."Lesson Order"=17, then insert for 17, & 18
                            if TTLessons."Lesson Order"=17 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",18);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,17,18,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 17, 18
                              ////////////////////////////////////////////////////////////////////////////////// 18, 19

                            //IF TTLessons."Lesson Order"=18, then insert for 18, & 19
                            if TTLessons."Lesson Order"=18 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",19);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,18,19,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 18, 19
                              ////////////////////////////////////////////////////////////////////////////////// 19, 20

                            //IF TTLessons."Lesson Order"=19, then insert for 19, & 20
                            if TTLessons."Lesson Order"=19 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",20);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,19,20,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 19, 20
                              ////////////////////////////////////////////////////////////////////////////////// 20, 21

                            //IF TTLessons."Lesson Order"=20, then insert for 20, & 21
                            if TTLessons."Lesson Order"=20 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",21);
                              if TTLessons2.Find('-') then begin

           CountedEntries:= GenerateEntriesDoublesInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,20,21,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,ACALecturersUnits.Class);

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 20, 21
                            end;
                          until ACALecturersUnits.Next=0;
                      end;
                  end;
                  until TTDailyLessons.Next=0;
                end;
                end;
                until TTDays.Next=0;
                end;
            end;
            until TTRooms.Next=0;
          end;

         progre.Close;
    end;

    local procedure GenerateEntriesDoublesInsert(Progz: Code[20];Unitz: Code[20];Semz: Code[20];Less1: Integer;Less2: Integer;DayCode: Code[20];RoomCode: Code[20];Lect: Code[20];BlockCode: Code[20];UnitCategory: Code[20];Dept: Code[20];DayOrder: Integer;RoomType: Option Class,Hall,Lab;Faculty: Code[20];Campus: Code[20];Counts: Integer;ClassCode: Code[20]) CountedEntries: Integer
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
        UnitSpecRoom: Integer;
        ProgSpecRoom: Integer;
        LectSpecLessons: Integer;
        UnitSpecCampus: Integer;
        ProgSpecCampuses: Integer;
        LectSpecCampuses: Integer;
        LectSpecDays: Integer;
        ProgSpecDays: Integer;
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecDays: Record UnknownRecord74508;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
    begin
        
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
                            TTProgSpecCampuses.SetRange(Semester,Semz);
                            TTProgSpecCampuses.SetRange("Programme Code",Progz);
                            TTProgSpecCampuses.SetFilter("Campus Code",'%1',Campus);
                            if TTProgSpecCampuses.Find('-') then begin
                              if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Avoid then ProgSpecCampuses:=666
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::"Least Preferred" then ProgSpecCampuses:=333
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Preferred then ProgSpecCampuses:=3
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Mandatory then ProgSpecCampuses:=1;
                              end;
        
                             TTProgSpecDays.Reset;
                             TTProgSpecDays.SetRange(Semester,Semz);
                             TTProgSpecDays.SetRange("Programme Code",Progz);
                             TTProgSpecDays.SetFilter("Day Code",'%1',DayCode);
                             if TTProgSpecDays.Find('-') then begin
                               if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then ProgSpecDays:=666
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then ProgSpecDays:=333
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then ProgSpecDays:=3
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then ProgSpecDays:=1;
                               end;
        
                             TTProgSpecRooms.Reset;
                             TTProgSpecRooms.SetRange(Semester,Semz);
                             TTProgSpecRooms.SetRange("Programme Code",Progz);
                             TTProgSpecRooms.SetFilter("Room Code",'%1',RoomCode);
                             if TTProgSpecRooms.Find('-') then begin
                               if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Avoid then ProgSpecRoom:=666
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::"Least Preferred" then ProgSpecRoom:=333
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Preferred then ProgSpecRoom:=3
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Mandatory then ProgSpecRoom:=1;
                               end;
                               //---- Lecturer
        
                            TTLectSpecCampuses.Reset;
                            TTLectSpecCampuses.SetRange(Semester,Semz);
                            TTLectSpecCampuses.SetRange("Lecturer Code",Lect);
                            TTLectSpecCampuses.SetFilter("Campus Code",'%1',Campus);
                            if TTLectSpecCampuses.Find('-') then begin
                              if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Avoid then LectSpecCampuses:=666
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::"Least Preferred" then LectSpecCampuses:=333
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Preferred then LectSpecCampuses:=3
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Mandatory then LectSpecCampuses:=1;
                              end;
                             /*
                             TTLectSpecLessons.RESET;
                             TTLectSpecLessons.SETRANGE(Semester,Semz);
                             TTLectSpecLessons.SETRANGE("Lecturer Code",Lect);
                             TTLectSpecLessons.SETFILTER("Lesson Code",'%1|%2',Less1,Less2);
                             IF TTLectSpecLessons.FIND('-') THEN BEGIN
                               IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::Avoid THEN LectSpecLessons:=666
                               ELSE IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::"Least Preferred" THEN LectSpecLessons:=333
                               ELSE IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::Preferred THEN LectSpecLessons:=3
                               ELSE IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::Mandatory THEN LectSpecLessons:=1;
                               END;
                              */
                             TTLectSpecDays.Reset;
                             TTLectSpecDays.SetRange(Semester,Semz);
                             TTLectSpecDays.SetRange("Lecturer Code",Lect);
                             TTLectSpecDays.SetFilter("Day Code",'%1',DayCode);
                             if TTLectSpecDays.Find('-') then begin
                               if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then LectSpecDays:=666
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then LectSpecDays:=333
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Preferred then LectSpecDays:=3
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Mandatory then LectSpecDays:=1;
                               end;
        
                               TTUnitSpecCampuses.Reset;
                            TTUnitSpecCampuses.SetRange(Semester,Semz);
                            TTUnitSpecCampuses.SetRange("Programme Code",Progz);
                            TTUnitSpecCampuses.SetFilter("Campus Code",'%1',Campus);
                            TTUnitSpecCampuses.SetFilter("Unit Code",'%1',Unitz);
                            if TTUnitSpecCampuses.Find('-') then begin
                              if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Avoid then UnitSpecCampus:=666
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::"Least Preferred" then UnitSpecCampus:=333
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Preferred then UnitSpecCampus:=3
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Mandatory then UnitSpecCampus:=1;
                              end;
        
                            TTUnitSpecRooms.Reset;
                            TTUnitSpecRooms.SetRange(Semester,Semz);
                            TTUnitSpecRooms.SetRange("Programme Code",Progz);
                            TTUnitSpecRooms.SetFilter("Unit Code",'%1',Unitz);
                            TTUnitSpecRooms.SetFilter("Room Code",'%1',RoomCode);
                            if TTUnitSpecRooms.Find('-') then begin
                              if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Avoid then UnitSpecRoom:=666
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::"Least Preferred" then UnitSpecRoom:=333
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Preferred then UnitSpecRoom:=3
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Mandatory then UnitSpecRoom:=1;
                              end;
        
        
        
          CountedEntries:=Counts;
                              TTTimetableCollectorDoubles.Reset;
                              TTTimetableCollectorDoubles.SetRange(Programme,Progz);
                              TTTimetableCollectorDoubles.SetRange(Unit,Unitz);
                              TTTimetableCollectorDoubles.SetRange(Semester,Semz);
                              TTTimetableCollectorDoubles.SetRange("Lesson 1",Less1);
                              TTTimetableCollectorDoubles.SetRange("Lesson 2",Less2);
                              TTTimetableCollectorDoubles.SetRange("Day of Week",DayCode);
                              TTTimetableCollectorDoubles.SetRange("Lecture Room",RoomCode);
                              TTTimetableCollectorDoubles.SetRange(Lecturer,Lect);
                             // TTTimetableCollectorA.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableCollectorA.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableCollectorDoubles.SetRange("Room Code",RoomCode);
                            //  TTTimetableCollectorDoubles.SETRANGE("Block/Building",BlockCode);
                              TTTimetableCollectorDoubles.SetRange("Lesson Category",UnitCategory);
                             // TTTimetableCollectorA.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             // Progz,Unitz,Semz,Less1,Less2,DayCode,RoomCode,Lect,BlockCode,UnitCategory,Dept,DayOrder,RoomType,Faculty,Campus,Counts
                             if not (TTTimetableCollectorDoubles.Find('-')) then begin
                               TTTimetableCollectorDoubles.Init;
                               TTTimetableCollectorDoubles.Programme:=Progz;
                               TTTimetableCollectorDoubles.Unit:=Unitz;
                               TTTimetableCollectorDoubles.Semester:=Semz;
                               TTTimetableCollectorDoubles."Lesson 1":=Less1;
                               TTTimetableCollectorDoubles."Lesson 2":=Less2;
                               TTTimetableCollectorDoubles."Lesson Category":=UnitCategory;
                               TTTimetableCollectorDoubles."Day of Week":=DayCode;
                               TTTimetableCollectorDoubles."Lecture Room":=RoomCode;
                               TTTimetableCollectorDoubles.Lecturer:=Lect;
                               TTTimetableCollectorDoubles.Department:=Dept;
                               TTTimetableCollectorDoubles."Day Order":=DayOrder;
                             //  TTTimetableCollectorA."Programme Option":=;
                               TTTimetableCollectorDoubles."Room Type":=RoomType;
                               TTTimetableCollectorDoubles."Room Code":=RoomCode;
                               TTTimetableCollectorDoubles."Block/Building":=BlockCode;
                               TTTimetableCollectorDoubles."School or Faculty":=Faculty;
                               TTTimetableCollectorDoubles."Campus Code":=Campus;
                               TTTimetableCollectorDoubles."Programme Campus Priority":=ProgSpecCampuses;
                               TTTimetableCollectorDoubles."Programme Day Priority":=ProgSpecDays;
                               TTTimetableCollectorDoubles."Programme Room Priority":=ProgSpecRoom;
                               TTTimetableCollectorDoubles."Lecturer Campus Priority":=LectSpecCampuses;
                               TTTimetableCollectorDoubles."Lecturer Day Priority":=LectSpecDays;
                               TTTimetableCollectorDoubles."Lecturer Lesson Priority":=LectSpecLessons;
                               TTTimetableCollectorDoubles."Unit Campus Priority":=UnitSpecCampus;
                               TTTimetableCollectorDoubles."Unit Room Priority":=UnitSpecRoom;
                               TTTimetableCollectorDoubles."Class Code":=ClassCode;
                               if ((Semz<>'') and (RoomCode<>'') and (Lect<>'')) then begin
                               TTRooms2.Reset;
                              // TTRooms2.SETRANGE(Semester,Rec.Semester);
                               TTRooms2.SetRange("Room Code",RoomCode);
                               TTRooms2.SetRange("Block Code",BlockCode);
                               if TTRooms2.Find('-') then begin
                             if TTRooms2."Room Type"<>TTRooms2."room type"::Class then begin
                               TTUnitSpecRooms111.Reset;
                               TTUnitSpecRooms111.SetRange(Semester,Rec.Semester);
                               TTUnitSpecRooms111.SetRange("Programme Code",Progz);
                               TTUnitSpecRooms111.SetRange("Unit Code",Unitz);
                               TTUnitSpecRooms111.SetRange("Room Code",TTRooms2."Room Code");
                               if TTUnitSpecRooms111.Find('-') then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorDoubles."Record ID":=CountedEntries;
                                  TTTimetableCollectorDoubles.Insert;
                                 end;
                               end else begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorDoubles."Record ID":=CountedEntries;
                               TTTimetableCollectorDoubles.Insert;
                                 end;
                             end;
                                 end;
                               end;

    end;

    local procedure GenerateEntriesTripple()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorDoubles: Record UnknownRecord74522;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
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
        Var1: Code[20];
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
        progre.Open('Generating Entries for Tripples:  #1#############################'+
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
        TTTimetableCollectorDoubles.Reset;
        TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
        if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
        Clear(CountedEntries);
        TTRooms.Reset;
        //TTRooms.SETRANGE(Semester,Rec.Semester);
        if TTRooms.Find('-') then begin
          repeat
            begin
           TTDays.Reset;
           //TTDays.SETRANGE("Day Code",TTDailyLessons."Day Code");
           TTDays.SetRange(Semester,Rec.Semester);
                  if TTDays.Find('-') then begin
                    repeat
                      begin
              TTDailyLessons.Reset;
              TTDailyLessons.SetRange(Semester,Rec.Semester);
              TTDailyLessons.SetRange("Day Code",TTDays."Day Code");
              if TTDailyLessons.Find('-') then begin
                repeat
                  begin
                  TTLessons.Reset;
                  TTLessons.SetRange("Lesson Code",TTDailyLessons."Lesson Code");
                  if TTLessons.Find('-') then;

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
            RecCount1:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
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
            RecCount10:=Format(counts)+'). '+'Day: '+TTDays."Day Code"+'; Lecturer: '+ACALecturersUnits.Lecturer+'; Programme: '+ACALecturersUnits.Programme+'; Unit: '+
        ACALecturersUnits.Unit+'; Campus: '+ACALecturersUnits."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            LectLoadBatchLines.Reset;
                            LectLoadBatchLines.SetRange("Lecturer Code",ACALecturersUnits.Lecturer);
                            LectLoadBatchLines.SetRange("Semester Code",Rec.Semester);
                            if LectLoadBatchLines.Find('-') then;
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;

                            //IF TTLessons."Lesson Order"=1, then insert for 1, &2
                            if TTLessons."Lesson Order"=1 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",2);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",3);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,1,2,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,3,ACALecturersUnits.Class);
                                    end;

                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 2, 3

                            //IF TTLessons."Lesson Order"=2, then insert for 2, & 3
                            if TTLessons."Lesson Order"=2 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",3);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",4);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,2,3,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,4,ACALecturersUnits.Class);
            end;
                               end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 2, 3

                              ////////////////////////////////////////////////////////////////////////////////// 3, 4

                            //IF TTLessons."Lesson Order"=3, then insert for 3, & 4
                            if TTLessons."Lesson Order"=3 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",4);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",5);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,3,4,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,5,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 3, 4

                              ////////////////////////////////////////////////////////////////////////////////// 4, 5

                            //IF TTLessons."Lesson Order"=4, then insert for 4, & 5
                            if TTLessons."Lesson Order"=4 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",5);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",6);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,4,5,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,6,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 4, 5
                              ////////////////////////////////////////////////////////////////////////////////// 5, 6

                            //IF TTLessons."Lesson Order"=5, then insert for 5, & 6
                            if TTLessons."Lesson Order"=5 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",6);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",7);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,5,6,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,7,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 5, 6
                              ////////////////////////////////////////////////////////////////////////////////// 6, 7

                            //IF TTLessons."Lesson Order"=6, then insert for 6, & 7
                            if TTLessons."Lesson Order"=6 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",7);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",8);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,6,7,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,8,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 6, 7
                              ////////////////////////////////////////////////////////////////////////////////// 7, 8

                            //IF TTLessons."Lesson Order"=7, then insert for 7, & 8
                            if TTLessons."Lesson Order"=7 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",8);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",9);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,7,8,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,9,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 7, 8
                              ////////////////////////////////////////////////////////////////////////////////// 8, 9

                            //IF TTLessons."Lesson Order"=8, then insert for 8, & 9
                            if TTLessons."Lesson Order"=8 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",9);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",10);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,8,9,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,10,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 8, 9
                              ////////////////////////////////////////////////////////////////////////////////// 9, 10

                            //IF TTLessons."Lesson Order"=9, then insert for 9, & 10
                            if TTLessons."Lesson Order"=9 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",10);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",11);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,9,10,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,11,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 9, 10
                              ////////////////////////////////////////////////////////////////////////////////// 10, 11

                            //IF TTLessons."Lesson Order"=10, then insert for 10, & 11
                            if TTLessons."Lesson Order"=10 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",11);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",12);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,10,11,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,12,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 10, 11
                              ////////////////////////////////////////////////////////////////////////////////// 11, 12

                            //IF TTLessons."Lesson Order"=11, then insert for 11, & 12
                            if TTLessons."Lesson Order"=11 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",12);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",13);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,11,12,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,13,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 11, 12
                              ////////////////////////////////////////////////////////////////////////////////// 12, 13,14

                            //IF TTLessons."Lesson Order"=12, then insert for 12, & 13
                            if TTLessons."Lesson Order"=12 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",13);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",14);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,12,13,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,14,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 12, 13,14
                              ////////////////////////////////////////////////////////////////////////////////// 13, 14,15

                            //IF TTLessons."Lesson Order"=13, then insert for 13, & 14,15
                            if TTLessons."Lesson Order"=13 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",14);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",15);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,13,14,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,15,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 13, 14,15
                              ////////////////////////////////////////////////////////////////////////////////// 14, 15,16

                            //IF TTLessons."Lesson Order"=14, then insert for 14, & 15,16
                            if TTLessons."Lesson Order"=14 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",15);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",16);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,14,15,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,16,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 14, 15,16
                              ////////////////////////////////////////////////////////////////////////////////// 15, 16,17

                            //IF TTLessons."Lesson Order"=15, then insert for 15, & 16,17
                            if TTLessons."Lesson Order"=15 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",16);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",17);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,15,16,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,17,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 15, 16,17
                              ////////////////////////////////////////////////////////////////////////////////// 16, 17,18

                            //IF TTLessons."Lesson Order"=16, then insert for 16, & 17,18
                            if TTLessons."Lesson Order"=16 then begin
                              TTLessons2.Reset;
                              TTLessons2.SetRange("Lesson Order",17);
                              if TTLessons2.Find('-') then begin
                                  TTLessons3.Reset;
                                  TTLessons3.SetRange("Lesson Order",18);
                                  if TTLessons3.Find('-') then begin
                                      //Insert a Tripple Combination Here

           CountedEntries:= GenerateEntriesTrippleInsert(ACALecturersUnits.Programme,ACALecturersUnits.Unit,Rec.Semester,16,17,TTDailyLessons."Day Code",TTRooms."Room Code",
            ACALecturersUnits.Lecturer,TTRooms."Block Code",TTUnits."Weighting Category",LectLoadBatchLines."Department Code",TTDays."Day Order",TTRooms."Room Type",
            LectLoadBatchLines.Faculty,ACALecturersUnits."Campus Code",CountedEntries,18,ACALecturersUnits.Class);
            end;
                                end;
                              end;
                              ////////////////////////////////////////////////////////////////////////////////// 16, 17,18
                            end;
                          until ACALecturersUnits.Next=0;
                      end;
                  end;
                  until TTDailyLessons.Next=0;
                end;
                end;
                until TTDays.Next=0;
                end;
            end;
            until TTRooms.Next=0;
          end;
          progre.Close;
    end;

    local procedure GenerateEntriesTrippleInsert(Progz: Code[20];Unitz: Code[20];Semz: Code[20];Less1: Integer;Less2: Integer;DayCode: Code[20];RoomCode: Code[20];Lect: Code[20];BlockCode: Code[20];UnitCategory: Code[20];Dept: Code[20];DayOrder: Integer;RoomType: Option Class,Hall,Lab;Faculty: Code[20];Campus: Code[20];Counts: Integer;Less3: Integer;ClassCode: Code[20]) CountedEntries: Integer
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
        UnitSpecRoom: Integer;
        ProgSpecRoom: Integer;
        LectSpecLessons: Integer;
        UnitSpecCampus: Integer;
        ProgSpecCampuses: Integer;
        LectSpecCampuses: Integer;
        LectSpecDays: Integer;
        ProgSpecDays: Integer;
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecDays: Record UnknownRecord74508;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
    begin
        
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
                            TTProgSpecCampuses.SetRange(Semester,Semz);
                            TTProgSpecCampuses.SetRange("Programme Code",Progz);
                            TTProgSpecCampuses.SetFilter("Campus Code",'%1',Campus);
                            if TTProgSpecCampuses.Find('-') then begin
                              if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Avoid then ProgSpecCampuses:=666
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::"Least Preferred" then ProgSpecCampuses:=333
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Preferred then ProgSpecCampuses:=3
                              else if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Mandatory then ProgSpecCampuses:=1;
                              end;
        
                             TTProgSpecDays.Reset;
                             TTProgSpecDays.SetRange(Semester,Semz);
                             TTProgSpecDays.SetRange("Programme Code",Progz);
                             TTProgSpecDays.SetFilter("Day Code",'%1',DayCode);
                             if TTProgSpecDays.Find('-') then begin
                               if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then ProgSpecDays:=666
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then ProgSpecDays:=333
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then ProgSpecDays:=3
                               else if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then ProgSpecDays:=1;
                               end;
        
                             TTProgSpecRooms.Reset;
                             TTProgSpecRooms.SetRange(Semester,Semz);
                             TTProgSpecRooms.SetRange("Programme Code",Progz);
                             TTProgSpecRooms.SetFilter("Room Code",'%1',RoomCode);
                             if TTProgSpecRooms.Find('-') then begin
                               if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Avoid then ProgSpecRoom:=666
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::"Least Preferred" then ProgSpecRoom:=333
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Preferred then ProgSpecRoom:=3
                               else if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Mandatory then ProgSpecRoom:=1;
                               end;
                               //---- Lecturer
        
                            TTLectSpecCampuses.Reset;
                            TTLectSpecCampuses.SetRange(Semester,Semz);
                            TTLectSpecCampuses.SetRange("Lecturer Code",Lect);
                            TTLectSpecCampuses.SetFilter("Campus Code",'%1',Campus);
                            if TTLectSpecCampuses.Find('-') then begin
                              if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Avoid then LectSpecCampuses:=666
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::"Least Preferred" then LectSpecCampuses:=333
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Preferred then LectSpecCampuses:=3
                              else if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Mandatory then LectSpecCampuses:=1;
                              end;
                             /*
                             TTLectSpecLessons.RESET;
                             TTLectSpecLessons.SETRANGE(Semester,Semz);
                             TTLectSpecLessons.SETRANGE("Lecturer Code",Lect);
                             TTLectSpecLessons.SETFILTER("Lesson Code",'%1|%2',Less1,Less2);
                             IF TTLectSpecLessons.FIND('-') THEN BEGIN
                               IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::Avoid THEN LectSpecLessons:=666
                               ELSE IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::"Least Preferred" THEN LectSpecLessons:=333
                               ELSE IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::Preferred THEN LectSpecLessons:=3
                               ELSE IF TTLectSpecLessons."Constraint Category"=TTLectSpecLessons."Constraint Category"::Mandatory THEN LectSpecLessons:=1;
                               END;
                              */
                             TTLectSpecDays.Reset;
                             TTLectSpecDays.SetRange(Semester,Semz);
                             TTLectSpecDays.SetRange("Lecturer Code",Lect);
                             TTLectSpecDays.SetFilter("Day Code",'%1',DayCode);
                             if TTLectSpecDays.Find('-') then begin
                               if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then LectSpecDays:=666
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then LectSpecDays:=333
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Preferred then LectSpecDays:=3
                               else if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Mandatory then LectSpecDays:=1;
                               end;
        
                               TTUnitSpecCampuses.Reset;
                            TTUnitSpecCampuses.SetRange(Semester,Semz);
                            TTUnitSpecCampuses.SetRange("Programme Code",Progz);
                            TTUnitSpecCampuses.SetFilter("Campus Code",'%1',Campus);
                            TTUnitSpecCampuses.SetFilter("Unit Code",'%1',Unitz);
                            if TTUnitSpecCampuses.Find('-') then begin
                              if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Avoid then UnitSpecCampus:=666
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::"Least Preferred" then UnitSpecCampus:=333
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Preferred then UnitSpecCampus:=3
                              else if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Mandatory then UnitSpecCampus:=1;
                              end;
        
                            TTUnitSpecRooms.Reset;
                            TTUnitSpecRooms.SetRange(Semester,Semz);
                            TTUnitSpecRooms.SetRange("Programme Code",Progz);
                            TTUnitSpecRooms.SetFilter("Unit Code",'%1',Unitz);
                            TTUnitSpecRooms.SetFilter("Room Code",'%1',RoomCode);
                            if TTUnitSpecRooms.Find('-') then begin
                              if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Avoid then UnitSpecRoom:=666
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::"Least Preferred" then UnitSpecRoom:=333
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Preferred then UnitSpecRoom:=3
                              else if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Mandatory then UnitSpecRoom:=1;
                              end;
        
        
        
        
         CountedEntries:=Counts;
                              TTTimetableCollectorTripple.Reset;
                              TTTimetableCollectorTripple.SetRange(Programme,Progz);
                              TTTimetableCollectorTripple.SetRange(Unit,Unitz);
                              TTTimetableCollectorTripple.SetRange(Semester,Semz);
                              TTTimetableCollectorTripple.SetRange("Lesson 1",Less1);
                              TTTimetableCollectorTripple.SetRange("Lesson 2",Less2);
                              TTTimetableCollectorTripple.SetRange("Lesson 3",Less3);
                              TTTimetableCollectorTripple.SetRange("Day of Week",DayCode);
                              TTTimetableCollectorTripple.SetRange("Lecture Room",RoomCode);
                              TTTimetableCollectorTripple.SetRange(Lecturer,Lect);
                             // TTTimetableCollectorA.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableCollectorA.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableCollectorTripple.SetRange("Room Code",RoomCode);
                             // TTTimetableCollectorTripple.SETRANGE("Block/Building",BlockCode);
                              TTTimetableCollectorTripple.SetRange("Lesson Category",UnitCategory);
                             // TTTimetableCollectorA.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             // Progz,Unitz,Semz,Less1,Less2,DayCode,RoomCode,Lect,BlockCode,UnitCategory,Dept,DayOrder,RoomType,Faculty,Campus,Counts
                             if not (TTTimetableCollectorTripple.Find('-')) then begin
                               TTTimetableCollectorTripple.Init;
                               TTTimetableCollectorTripple.Programme:=Progz;
                               TTTimetableCollectorTripple.Unit:=Unitz;
                               TTTimetableCollectorTripple.Semester:=Semz;
                               TTTimetableCollectorTripple."Lesson 1":=Less1;
                               TTTimetableCollectorTripple."Lesson 2":=Less2;
                               TTTimetableCollectorTripple."Lesson 3":=Less3;
                               TTTimetableCollectorTripple."Lesson Category":=UnitCategory;
                               TTTimetableCollectorTripple."Day of Week":=DayCode;
                               TTTimetableCollectorTripple."Lecture Room":=RoomCode;
                               TTTimetableCollectorTripple.Lecturer:=Lect;
                               TTTimetableCollectorTripple.Department:=Dept;
                               TTTimetableCollectorTripple."Day Order":=DayOrder;
                             //  TTTimetableCollectorA."Programme Option":=;
                               TTTimetableCollectorTripple."Room Type":=RoomType;
                               TTTimetableCollectorTripple."Room Code":=RoomCode;
                               TTTimetableCollectorTripple."Block/Building":=BlockCode;
                               TTTimetableCollectorTripple."School or Faculty":=Faculty;
                               TTTimetableCollectorTripple."Campus Code":=Campus;
                               TTTimetableCollectorTripple."Programme Campus Priority":=ProgSpecCampuses;
                               TTTimetableCollectorTripple."Programme Day Priority":=ProgSpecDays;
                               TTTimetableCollectorTripple."Programme Room Priority":=ProgSpecRoom;
                               TTTimetableCollectorTripple."Lecturer Campus Priority":=LectSpecCampuses;
                               TTTimetableCollectorTripple."Lecturer Day Priority":=LectSpecDays;
                               TTTimetableCollectorTripple."Lecturer Lesson Priority":=LectSpecLessons;
                               TTTimetableCollectorTripple."Unit Campus Priority":=UnitSpecCampus;
                               TTTimetableCollectorTripple."Unit Room Priority":=UnitSpecRoom;
                               TTTimetableCollectorTripple."Class Code":=ClassCode;
                               if ((Semz<>'') and (RoomCode<>'') and (Lect<>'')) then begin
        
                               TTRooms2.Reset;
                             //  TTRooms2.SETRANGE(Semester,Rec.Semester);
                               TTRooms2.SetRange("Room Code",RoomCode);
                               TTRooms2.SetRange("Block Code",BlockCode);
                               if TTRooms2.Find('-') then begin
                             if TTRooms2."Room Type"<>TTRooms2."room type"::Class then begin
                               TTUnitSpecRooms111.Reset;
                               TTUnitSpecRooms111.SetRange(Semester,Rec.Semester);
                               TTUnitSpecRooms111.SetRange("Programme Code",Progz);
                               TTUnitSpecRooms111.SetRange("Unit Code",Unitz);
                               TTUnitSpecRooms111.SetRange("Room Code",TTRooms2."Room Code");
                               if TTUnitSpecRooms111.Find('-') then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorTripple."Record ID":=CountedEntries;
                                  TTTimetableCollectorTripple.Insert;
                                 end;
                               end else begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableCollectorTripple."Record ID":=CountedEntries;
                               TTTimetableCollectorTripple.Insert;
                                 end;
                             end;
        // //                         CountedEntries:=CountedEntries+1;
        // //                       TTTimetableCollectorTripple."Record ID":=CountedEntries;
        // //                       TTTimetableCollectorTripple.INSERT;
                                 end;
                               end;

    end;

    local procedure ThiningSingles()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        ACALecturersUnits2: Record UnknownRecord65202;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
        TTWeightLessonCategories: Record UnknownRecord74506;
        TTTimetableCollectorA: Record UnknownRecord74500;
        TTTimetableCollectorA1: Record UnknownRecord74500;
        TTTimetableCollectorA2: Record UnknownRecord74500;
        TTTimetableCollectorA3: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorDoubles1: Record UnknownRecord74521;
        TTTimetableCollectorDoubles2: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTTimetableCollectorTripple1: Record UnknownRecord74522;
        TTTimetableCollectorTripple2: Record UnknownRecord74522;
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
        Var1: Code[20];
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
        progre.Open('Building Timetable for Singles:  #1#############################'+
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
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;
                            TTWeightLessonCategories.Reset;
                            TTWeightLessonCategories.SetRange(Semester,Rec.Semester);
                            TTWeightLessonCategories.SetRange("Category Code",TTUnits."Weighting Category");
                            if TTWeightLessonCategories.Find('-') then begin
                              //Thin Singles
                              if TTWeightLessonCategories."Single Classes"= 0 then begin
                                TTTimetableCollectorA.Reset;
                                TTTimetableCollectorA.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorA.Find('-') then TTTimetableCollectorA.DeleteAll;
                                end else if TTWeightLessonCategories."Single Classes"= 1 then begin
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
        /////////..............................//...................................................................
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
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
                                TTTimetableCollectorA1.SetFilter("Lesson Order",'%1',CurrLessonOrder);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles.SetFilter("Lesson 1",'%1',CurrLessonOrder);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles.SetFilter("Lesson 2",'%1',CurrLessonOrder);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
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
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
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
                                TTTimetableCollectorA2.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA2.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA2.SetRange(Allocated,false);
                                if TTTimetableCollectorA2.Find('-') then begin
                                  TTTimetableCollectorA2.Allocated:=true;
                                  TTTimetableCollectorA2.Modify;
                                  end;
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
                                  //END;
                                  until TTTimetableCollectorA1.Next=0;
                                  end;

        /////////..............................//...................................................................
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
                                  TTTimetableCollectorA1.Reset;
                                //TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  //Delete fro the Room/Day/Lesson
                                  TTTimetableCollectorA1.Reset;
                               // TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
                                TTLessons.Reset;
                                TTLessons.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                if TTLessons.Find('-') then begin
                                  // Delete from Doubles for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorDoubles.Reset;
                                //TTTimetableCollectorDoubles.SETRANGE("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles.Reset;
                              //  TTTimetableCollectorDoubles.SETRANGE("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorDoubles.Reset;
                                //TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles.Reset;
                               // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                  end;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorDoubles.Reset;
                               // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons

                                TTLessons.Reset;
                                TTLessons.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                if TTLessons.Find('-') then begin

                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 3",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 3",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                  end;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
                                //Delete All Unallocated from The Singles for Lect/Unit/Campus
                                  TTTimetableCollectorA1.Reset;
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                end else if TTWeightLessonCategories."Single Classes"= 2 then begin
                                  Clear(Loops);
                                  repeat
                                    begin
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 2 Singles
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

        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
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
                                TTTimetableCollectorA1.SetFilter("Lesson Order",'%1',CurrLessonOrder);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles.SetFilter("Lesson 1",'%1',CurrLessonOrder);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles.SetFilter("Lesson 2",'%1',CurrLessonOrder);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
                                  //Delete fro the Lecturer in a week

        /////////..............................//...................................................................

                                  // Delete the Unit For the Programme in the whole TT
                                    TTTimetableCollectorA1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
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
                                if Loops=0 then
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
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
                                if Loops=0 then
                                TTTimetableCollectorA2.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA2.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA2.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA2.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA2.SetRange(Allocated,false);
                                if TTTimetableCollectorA2.Find('-') then begin
                                  TTTimetableCollectorA1.Allocated:=true;
                                  TTTimetableCollectorA1.Modify;

                                TTTimetableCollectorA2.Reset;
                                TTTimetableCollectorA2.SetRange(Programme,TTTimetableCollectorA1.Programme);
                                if Loops=0 then
                                TTTimetableCollectorA2.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
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

        /////////..............................//...................................................................
                                  TTTimetableCollectorA1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson
                                  TTTimetableCollectorA1.Reset;
                                //TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  //Delete fro the Room/Day/Lesson
                                  TTTimetableCollectorA1.Reset;
                               // TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
                                TTLessons.Reset;
                                TTLessons.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                if TTLessons.Find('-') then begin
                                  // Delete from Doubles for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorDoubles.Reset;
                               // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles.Reset;
                              //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorDoubles.Reset;
                               // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles.Reset;
                              //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                  end;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons

                                TTLessons.Reset;
                                TTLessons.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                if TTLessons.Find('-') then begin
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 3",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 3",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                  end;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
                                //Delete All Unallocated from The Singles for Lect/Unit/Campus
                                  TTTimetableCollectorA1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 2 Singles
                                    Loops:=Loops+1;
                                    end;
                                      until Loops=2;
                                end else if TTWeightLessonCategories."Single Classes"= 3 then begin
                                  Clear(Loops);
                                  repeat
                                    begin
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 3 Singles
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
                                  //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
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
                                TTTimetableCollectorA1.SetFilter("Lesson Order",'%1',CurrLessonOrder);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles.SetFilter("Lesson 1",'%1',CurrLessonOrder);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles.SetFilter("Lesson 2",'%1',CurrLessonOrder);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
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
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1',CurrLessonOrder);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
                                  //Delete fro the Lecturer in a week
                                  TTTimetableCollectorA1.Reset;
                                if ((Loops=0) or (Loops=1)) then
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson
                                  TTTimetableCollectorA1.Reset;
                              //  TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                  //Delete fro the Room/Day/Lesson
                                  TTTimetableCollectorA1.Reset;
                               // TTTimetableCollectorA1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                TTTimetableCollectorA1.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
                                TTLessons.Reset;
                                TTLessons.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                if TTLessons.Find('-') then begin
                                  // Delete from Doubles for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorDoubles.Reset;
                               // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles.Reset;
                              //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorDoubles.Reset;
                              //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles.Reset;
                               // TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorDoubles.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                  end;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorDoubles.Reset;
                              //  TTTimetableCollectorDoubles.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons

                                TTLessons.Reset;
                                TTLessons.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                                if TTLessons.Find('-') then begin
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 3",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 1",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 2",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange("Lesson 3",TTLessons."Lesson Order");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorA."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                  end;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
                                //Delete All Unallocated from The Singles for Lect/Unit/Campus
                                  TTTimetableCollectorA1.Reset;
                                if ((Loops=0) or (Loops=1)) then
                                TTTimetableCollectorA1.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
                                TTTimetableCollectorA1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorA1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorA1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorA1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorA1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorA1.SetRange(Allocated,false);
                                if TTTimetableCollectorA1.Find('-') then TTTimetableCollectorA1.DeleteAll;
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 3 Singles
                                    Loops:=Loops+1;
                                    end;
                                      until Loops=3;
                                end;

                              end;
                            end;
                            until ACALecturersUnits.Next=0;
                            end;
                            progre.Close;
    end;

    local procedure ThiningDoubles()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        ACALecturersUnits2: Record UnknownRecord65202;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
        TTWeightLessonCategories: Record UnknownRecord74506;
        TTTimetableCollectorA: Record UnknownRecord74500;
        TTTimetableCollectorA1: Record UnknownRecord74500;
        TTTimetableCollectorA2: Record UnknownRecord74500;
        TTTimetableCollectorA3: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorDoubles1: Record UnknownRecord74521;
        TTTimetableCollectorDoubles2: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTTimetableCollectorTripple1: Record UnknownRecord74522;
        TTTimetableCollectorTripple2: Record UnknownRecord74522;
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
        Var1: Code[20];
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
        progre.Open('Building Timetable for Doubles:  #1#############################'+
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
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;
                            TTWeightLessonCategories.Reset;
                            TTWeightLessonCategories.SetRange(Semester,Rec.Semester);
                            TTWeightLessonCategories.SetRange("Category Code",TTUnits."Weighting Category");
                            if TTWeightLessonCategories.Find('-') then begin
                              //Thin Doubles
                              if TTWeightLessonCategories."Double Classes"= 0 then begin
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
                                end else if TTWeightLessonCategories."Double Classes"= 1 then begin
                                  TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                TTTimetableCollectorDoubles.SetCurrentkey("Day Order","Lesson 1","Lesson 2","Programme Campus Priority","Programme Room Priority",
                                "Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority","Lecturer Lesson Priority","Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorDoubles.Find('-') then begin
                                  TTTimetableCollectorDoubles.Allocated:=true;
                                  TTTimetableCollectorDoubles.Modify;
                                  end;


        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        /////////..............................//...................................................................

                                  // Delete the Unit For the Programme in the whole TT
                                    TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                  // Capture Timetable for the same Class and Unit

                                  TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                //TTTimetableCollectorDoubles1.SETRANGE("Date Code",TTTimetableCollectorDoubles."Date Code");
                                TTTimetableCollectorDoubles1.SetRange("Lesson 1",TTTimetableCollectorDoubles."Lesson 1");
                                TTTimetableCollectorDoubles1.SetRange("Lesson 2",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then begin
                                  repeat
                                    begin
                                    ///......................................//..................................................
                                                              TTTimetableCollectorDoubles2.Reset;
                                TTTimetableCollectorDoubles2.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles2.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles2.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                               // TTTimetableCollectorDoubles2.SETRANGE("Date Code",TTTimetableCollectorDoubles."Date Code");
                                TTTimetableCollectorDoubles2.SetRange("Lesson 1",TTTimetableCollectorDoubles."Lesson 1");
                                TTTimetableCollectorDoubles2.SetRange("Lesson 2",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles2.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles2.Find('-') then begin
                                  TTTimetableCollectorDoubles1.Allocated:=true;
                                  TTTimetableCollectorDoubles1.Modify;

                                TTTimetableCollectorDoubles2.Reset;
                                TTTimetableCollectorDoubles2.SetRange(Programme,TTTimetableCollectorDoubles1.Programme);
                                TTTimetableCollectorDoubles2.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles2.SetRange(Lecturer,TTTimetableCollectorDoubles1.Lecturer);
                                TTTimetableCollectorDoubles2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles2.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles2.Find('-') then TTTimetableCollectorDoubles2.DeleteAll;
                                end;
                                ///..........................................//.......................................
                                  end;
                                  until TTTimetableCollectorDoubles1.Next=0;
                                  end;

        /////////..............................//...................................................................
                                  //Delete fro the Lecturer in a week
                                  TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson
        // // //
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
        // // // // // // // // //                        TTLessons.RESET;
        // // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Doubles for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorDoubles1.Reset;
                               // TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles1.Reset;
                              //  TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange("Lesson 2",TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorDoubles1.Reset;
                              //  TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles1.Reset;
                               // TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                           //       END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Double Lessons
        // // // //
        // // // //                        TTLessons.RESET;
        // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                             //   TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                             //   TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
        /////                          END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
                                //Delete All Unallocated from The Doubles for Lect/Unit/Campus
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                end else if TTWeightLessonCategories."Double Classes"= 2 then begin
                                  Clear(Loops);
                                  repeat
                                    begin
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 2 Doubles
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                TTTimetableCollectorDoubles.SetCurrentkey("Day Order","Lesson 1","Lesson 2","Programme Campus Priority","Programme Room Priority",
                                "Programme Day Priority",
                                "Lecturer Campus Priority","Lecturer Day Priority","Lecturer Lesson Priority","Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorDoubles.Find('-') then begin
                                  TTTimetableCollectorDoubles.Allocated:=true;
                                  TTTimetableCollectorDoubles.Modify;
                                  end;


        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        /////////..............................//...................................................................

                                  // Delete the Unit For the Programme in the whole TT
                                    TTTimetableCollectorDoubles1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                  // Capture Timetable for the same Class and Unit

                                  TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                if Loops=0 then
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1',TTTimetableCollectorDoubles."Lesson 1");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1',TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then begin
                                  repeat
                                    begin
                                    ///......................................//..................................................
                                                              TTTimetableCollectorDoubles2.Reset;
                                TTTimetableCollectorDoubles2.SetRange("Class Code",ACALecturersUnits.Class);
                                if Loops=0 then
                                TTTimetableCollectorDoubles2.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles2.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles2.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles2.SetFilter("Lesson 1",'%1',TTTimetableCollectorDoubles."Lesson 1");
                                TTTimetableCollectorDoubles2.SetFilter("Lesson 2",'%1',TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles2.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles2.Find('-') then begin
                                  TTTimetableCollectorDoubles1.Allocated:=true;
                                  TTTimetableCollectorDoubles1.Modify;

                                TTTimetableCollectorDoubles2.Reset;
                                TTTimetableCollectorDoubles2.SetRange(Programme,TTTimetableCollectorDoubles1.Programme);
                                if Loops=0 then
                                TTTimetableCollectorDoubles2.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles2.SetRange(Lecturer,TTTimetableCollectorDoubles1.Lecturer);
                                TTTimetableCollectorDoubles2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles2.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles2.Find('-') then TTTimetableCollectorDoubles2.DeleteAll;
                                end;
                                ///..........................................//.......................................
                                  end;
                                  until TTTimetableCollectorDoubles1.Next=0;
                                  end;

        /////////..............................//...................................................................
                                  //Delete fro the Lecturer in a week
                                TTTimetableCollectorDoubles1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson

                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // //                        TTLessons.RESET;
        // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Doubles for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorDoubles1.Reset;
                              //  TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles1.Reset;
                               // TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorDoubles1.Reset;
                              //  TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles1.Reset;
                              //  TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //  END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Double Lessons

        // // // // // //                        TTLessons.RESET;
        // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                               // TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
        ////////                          END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
                                //Delete All Unallocated from The Doubles for Lect/Unit/Campus
                                  TTTimetableCollectorDoubles1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 2 Doubles
                                    Loops:=Loops+1;
                                    end;
                                      until Loops=2;
                                end else if TTWeightLessonCategories."Double Classes"= 3 then begin
                                  Clear(Loops);
                                  repeat
                                    begin
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 3 Doubles
                                TTTimetableCollectorDoubles.Reset;
                                TTTimetableCollectorDoubles.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles.SetRange(Allocated,false);
                                TTTimetableCollectorDoubles.SetCurrentkey("Day Order","Lesson 1","Lesson 2","Programme Campus Priority",
                                "Programme Room Priority","Programme Day Priority","Lecturer Campus Priority",
                                "Lecturer Day Priority","Lecturer Lesson Priority","Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorDoubles.Find('-') then begin
                                  TTTimetableCollectorDoubles.Allocated:=true;
                                  TTTimetableCollectorDoubles.Modify;
                                  end;


        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
                                  //Delete fro the Lecturer in a week
                                TTTimetableCollectorDoubles1.Reset;
                                if ((Loops=0) or (Loops=1)) then
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson

                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // //                        TTLessons.RESET;
        // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Doubles for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorDoubles1.Reset;
                             //   TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles1.Reset;
                              //  TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorDoubles1.Reset;
                               // TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorDoubles1.Reset;
                               // TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorDoubles1.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //  END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorDoubles1.Reset;
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Double Lessons

        // // // // // //                        TTLessons.RESET;
        // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple.Reset;
                              //  TTTimetableCollectorTripple.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetFilter("Lesson 3",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
                                TTTimetableCollectorTripple.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
        ////////                          END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for single Lessons
                                //Delete All Unallocated from The Doubles for Lect/Unit/Campus
                                  TTTimetableCollectorDoubles1.Reset;
                                if ((Loops=0) or (Loops=1)) then
                                TTTimetableCollectorDoubles1.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                                TTTimetableCollectorDoubles1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorDoubles1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorDoubles1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorDoubles1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorDoubles1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorDoubles1.SetRange(Allocated,false);
                                if TTTimetableCollectorDoubles1.Find('-') then TTTimetableCollectorDoubles1.DeleteAll;
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 3 Doubles
                                    Loops:=Loops+1;
                                    end;
                                      until Loops=3;
                                end;

                              end;
                            end;
                            until ACALecturersUnits.Next=0;
                            end;
        progre.Close;
    end;

    local procedure ThiningTripples()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        ACALecturersUnits2: Record UnknownRecord65202;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACAUnitsSubjects2: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
        TTWeightLessonCategories: Record UnknownRecord74506;
        TTTimetableCollectorA: Record UnknownRecord74500;
        TTTimetableCollectorA1: Record UnknownRecord74500;
        TTTimetableCollectorA2: Record UnknownRecord74500;
        TTTimetableCollectorA3: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorDoubles1: Record UnknownRecord74521;
        TTTimetableCollectorDoubles2: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTTimetableCollectorTripple1: Record UnknownRecord74522;
        TTTimetableCollectorTripple2: Record UnknownRecord74522;
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
        Var1: Code[20];
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
        progre.Open('Building Timetable for Tripples:  #1#############################'+
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
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                            TTUnits.Reset;
                            TTUnits.SetRange(Semester,Rec.Semester);
                            TTUnits.SetRange("Programme Code",ACALecturersUnits.Programme);
                            TTUnits.SetRange("Unit Code",ACALecturersUnits.Unit);
                            if TTUnits.Find('-') then;
                            TTWeightLessonCategories.Reset;
                            TTWeightLessonCategories.SetRange(Semester,Rec.Semester);
                            TTWeightLessonCategories.SetRange("Category Code",TTUnits."Weighting Category");
                            if TTWeightLessonCategories.Find('-') then begin
                              //Thin Singles
                              if TTWeightLessonCategories."Triple Classes"= 0 then begin
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end else if TTWeightLessonCategories."Triple Classes"= 1 then begin
                                  TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetCurrentkey("Day Order","Lesson 1","Lesson 2","Lesson 3","Programme Campus Priority","Programme Room Priority",
        "Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority",
        "Lecturer Lesson Priority","Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorTripple.Find('-') then begin
                                  TTTimetableCollectorTripple.Allocated:=true;
                                  TTTimetableCollectorTripple.Modify;
                                  end;

                  //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
        /////////..............................//...................................................................

                                  // Delete the Unit For the Programme in the whole TT
                                    TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                  // Capture Timetable for the same Class and Unit

                                  TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1',TTTimetableCollectorTripple."Lesson 1");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1',TTTimetableCollectorTripple."Lesson 2");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1',TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then begin
                                  repeat
                                    begin
                                    ///......................................//..................................................
                                                              TTTimetableCollectorTripple2.Reset;
                                TTTimetableCollectorTripple2.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple2.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple2.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple2.SetFilter("Lesson 1",'%1',TTTimetableCollectorTripple."Lesson 1");
                                TTTimetableCollectorTripple2.SetFilter("Lesson 2",'%1',TTTimetableCollectorTripple."Lesson 2");
                                TTTimetableCollectorTripple2.SetFilter("Lesson 3",'%1',TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple2.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple2.Find('-') then begin
                                  TTTimetableCollectorTripple1.Allocated:=true;
                                  TTTimetableCollectorTripple1.Modify;

                                TTTimetableCollectorTripple2.Reset;
                                TTTimetableCollectorTripple2.SetRange(Programme,TTTimetableCollectorTripple1.Programme);
                                TTTimetableCollectorTripple2.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple2.SetRange(Lecturer,TTTimetableCollectorTripple1.Lecturer);
                                TTTimetableCollectorTripple2.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple2.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple2.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple2.Find('-') then TTTimetableCollectorTripple2.DeleteAll;
                                end;
                                ///..........................................//.......................................
                                  end;
                                  until TTTimetableCollectorTripple1.Next=0;
                                  end;

        /////////..............................//...................................................................
                                  //Delete fro the Lecturer in a week
                                  TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson
        // // // // // // // // // // // // // // // // // // //
        // // // // // // // // // // // // // // // //                        //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
        // // // // // // // // // // // // // // // // // // // // // // // // //                        TTLessons.RESET;
        // // // // // // // // // // // // // // // // // // // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // // // // // // // // // // // // // // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
        // // // // // // // // // // // // // // // //                          // Delete from Doubles for Lect/Day/Lesson
        // // // // // // // // // // // // // // // //                          //For Lesson 1
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // // // // // // // // // //                        //For Lesson 2
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Lesson 2",TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // // // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // // // // // // // // // //                        //For Lesson 1
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Allocated,FALSE);
        // // // // // // // // // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // // // // // // // // // //                        //For Lesson 2
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // // // // // // // // // //                   //       END;
        // // // // // // // // // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // // // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // // // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Tripple Lessons
        // // // //
        // // // //                        TTLessons.RESET;
        // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple1.Reset;
                             //   TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple1.Reset;
                               // TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple1.Reset;
                              //  TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple1.Reset;
                              //  TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple1.Reset;
                               // TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple1.Reset;
                               // TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
        /////                          END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Tripple Lessons
                                //Delete All Unallocated from The Tripples for Lect/Unit/Campus
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
                                end else if TTWeightLessonCategories."Triple Classes"= 2 then begin
                                  Clear(Loops);
                                  repeat
                                    begin
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 2 Tripples
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetCurrentkey("Day Order","Lesson 1","Lesson 2","Lesson 3","Programme Campus Priority","Programme Room Priority",
        "Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority",
        "Lecturer Lesson Priority","Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorTripple.Find('-') then begin
                                  TTTimetableCollectorTripple.Allocated:=true;
                                  TTTimetableCollectorTripple.Modify;
                                  end;

        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
                                  //Delete fro the Lecturer in a week
                                TTTimetableCollectorTripple1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson

                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for single Lessons
        // // // // // // //                        TTLessons.RESET;
        // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Doubles for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        //  END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Double Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Double Lessons

        // // // // // //                        TTLessons.RESET;
        // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple1.Reset;
                              //  TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple1.Reset;
                              //  TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple1.Reset;
                               // TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple1.Reset;
                               // TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple1.Reset;
                             //   TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple1.Reset;
                             //   TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
        ////////                          END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Triple Lessons
                                //Delete All Unallocated from The Doubles for Lect/Unit/Campus
                                  TTTimetableCollectorTripple1.Reset;
                                if Loops=0 then
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 2 Tripples
                                    Loops:=Loops+1;
                                    end;
                                      until Loops=2;
                                end else if TTWeightLessonCategories."Triple Classes"= 3 then begin
                                  Clear(Loops);
                                  repeat
                                    begin
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 3 Tripples
                                TTTimetableCollectorTripple.Reset;
                                TTTimetableCollectorTripple.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple.SetRange(Allocated,false);
                                TTTimetableCollectorTripple.SetCurrentkey("Day Order","Lesson 1","Lesson 2","Lesson 3","Programme Campus Priority","Programme Room Priority",
        "Programme Day Priority","Lecturer Campus Priority","Lecturer Day Priority",
        "Lecturer Lesson Priority","Unit Campus Priority","Unit Room Priority");
                                if TTTimetableCollectorTripple.Find('-') then begin
                                  TTTimetableCollectorTripple.Allocated:=true;
                                  TTTimetableCollectorTripple.Modify;
                                  end;

        //****************************************************************************************************************************** Delete Collisions on Student Unts
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage Begin
                                  // -Select all Stages and Programmes for the Lecturer and Unit and Class Before Picking Units for the Stage to clear for the given
                                  // Lesson and Next
                                  ACALecturersUnits2.Reset;
                                  ACALecturersUnits2.SetRange(Semester,Rec.Semester);
                                  ACALecturersUnits2.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                  ACALecturersUnits2.SetRange(Class,ACALecturersUnits.Class);
                                  ACALecturersUnits2.SetRange(Unit,ACALecturersUnits.Unit);
                                  if ACALecturersUnits2.Find('-') then begin
                                      repeat
                                        begin
                                        // Pick all Units in the Stage for the Programme & Delete in the Lesson and Next Lessons
                                        ACAUnitsSubjects2.Reset;
                                        ACAUnitsSubjects2.SetRange("Programme Code",ACALecturersUnits2.Programme);
                                        ACAUnitsSubjects2.SetRange("Stage Code",ACALecturersUnits2.Stage);
                                        if ACAUnitsSubjects2.Find('-') then begin
                                          repeat
                                            begin
                                            //Delete for 1st Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                            //Delete for 2nd Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                            //Delete for 3rd Lesson
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange(Programme,ACALecturersUnits2.Programme);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACAUnitsSubjects2.Code);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits2."Campus Code");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                end;
                                until ACAUnitsSubjects2.Next=0;
                                end;
                                        end;
                                        until ACALecturersUnits2.Next=0;
                                    end;
                                  //-- Delete all Allocations for the Programme and Units in the selected Stage end
        //******************************************************************************************************************************
                                  //Delete fro the Lecturer in a week
                                TTTimetableCollectorTripple1.Reset;
                                if ((Loops=0) or (Loops=1)) then
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                  //Delete fro the Lecturer/Day/Lesson

                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Tripple Lessons
        // // // // // // //                        TTLessons.RESET;
        // // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Doubles for Lect/Day/Lesson
        // // // // // // // //                          //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        // Delete for the Room/Day/Lesson
        // // // // // // // //                        //For Lesson 1
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 1",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        //For Lesson 2
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETFILTER("Lesson 2",'%1|%2',TTTimetableCollectorDoubles."Lesson 1",TTTimetableCollectorDoubles."Lesson 2");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Room Code",TTTimetableCollectorDoubles."Room Code");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
        // // // // // // // //                        //  END;
        // // // // // // // //                          // Delete for the Lecturer/Day/Campus/Unit in that Campus
        // // // // // // // //                        TTTimetableCollectorDoubles1.RESET;
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Programme,ACALecturersUnits.Programme);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Day of Week",TTTimetableCollectorDoubles."Day of Week");
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Unit,ACALecturersUnits.Unit);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Lecturer,ACALecturersUnits.Lecturer);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE(Semester,Rec.Semester);
        // // // // // // // //                        TTTimetableCollectorDoubles1.SETRANGE("Campus Code",ACALecturersUnits."Campus Code");
        // // // // // // // //                        IF TTTimetableCollectorDoubles1.FIND('-') THEN TTTimetableCollectorDoubles1.DELETEALL;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Doubles for Tripple Lessons
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Tripple Lessons

        // // // // // //                        TTLessons.RESET;
        // // // // // //                        TTLessons.SETRANGE("Lesson Code",TTTimetableCollectorA."Lesson Code");
        // // // // // //                        IF TTLessons.FIND('-') THEN BEGIN
                                  // Delete from Tripples for Lect/Day/Lesson
                                  //For Lesson 1
                                TTTimetableCollectorTripple1.Reset;
                            //    TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple1.Reset;
                              //  TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple1.Reset;
                             //   TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                // Delete for the Room/Day/Lesson
                                //For Lesson 1
                                TTTimetableCollectorTripple1.Reset;
                            //    TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 1",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 2
                                TTTimetableCollectorTripple1.Reset;
                             //   TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 2",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //For Lesson 3
                                TTTimetableCollectorTripple1.Reset;
                             //   TTTimetableCollectorTripple1.SETRANGE(Programme,ACALecturersUnits.Programme);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetFilter("Lesson 3",'%1|%2|%3',TTTimetableCollectorTripple."Lesson 1",TTTimetableCollectorTripple."Lesson 2",TTTimetableCollectorTripple."Lesson 3");
                                TTTimetableCollectorTripple1.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
        ////////                          END;
                                  // Delete for the Lecturer/Day/Campus/Unit in that Campus
                                TTTimetableCollectorTripple1.Reset;
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX Thinning on the Tripples for Tripple Lessons
                                //Delete All Unallocated from The Tripple for Lect/Unit/Campus
                                  TTTimetableCollectorTripple1.Reset;
                                if ((Loops=0) or (Loops=1)) then
                                TTTimetableCollectorTripple1.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                                TTTimetableCollectorTripple1.SetRange("Class Code",ACALecturersUnits.Class);
                                TTTimetableCollectorTripple1.SetRange(Unit,ACALecturersUnits.Unit);
                                TTTimetableCollectorTripple1.SetRange(Lecturer,ACALecturersUnits.Lecturer);
                                TTTimetableCollectorTripple1.SetRange(Semester,Rec.Semester);
                                TTTimetableCollectorTripple1.SetRange("Campus Code",ACALecturersUnits."Campus Code");
                                TTTimetableCollectorTripple1.SetRange(Allocated,false);
                                if TTTimetableCollectorTripple1.Find('-') then TTTimetableCollectorTripple1.DeleteAll;
                                    /////////////////////////////////////////////////////////////////////////////////////////////// 3 Tripple
                                    Loops:=Loops+1;
                                    end;
                                      until Loops=3;
                                end;

                              end;
                            end;
                            until ACALecturersUnits.Next=0;
                            end;
        progre.Close;
    end;

    local procedure FinalCompilation()
    var
        TTRooms: Record UnknownRecord74501;
        TTDailyLessons: Record UnknownRecord74503;
        ACALecturersUnits: Record UnknownRecord65202;
        LectLoadBatchLines: Record UnknownRecord65201;
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        TTUnits: Record UnknownRecord74517;
        TTLessons: Record UnknownRecord74520;
        TTDays: Record UnknownRecord74502;
        TTLessons1: Record UnknownRecord74520;
        TTLessons2: Record UnknownRecord74520;
        TTLessons3: Record UnknownRecord74520;
        TTWeightLessonCategories: Record UnknownRecord74506;
        TTTimetableCollectorA: Record UnknownRecord74500;
        TTTimetableCollectorA1: Record UnknownRecord74500;
        TTTimetableCollectorA2: Record UnknownRecord74500;
        TTTimetableCollectorA3: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorDoubles1: Record UnknownRecord74521;
        TTTimetableCollectorDoubles2: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTTimetableCollectorTripple1: Record UnknownRecord74522;
        TTTimetableCollectorTripple2: Record UnknownRecord74522;
        Loops: Integer;
        TTTimetableFInalCollector: Record UnknownRecord74523;
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
        Var1: Code[20];
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
            BufferString:='Total Singles processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorA.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorA.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Lesson Code",TTTimetableCollectorA."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Day of Week",TTTimetableCollectorA."Day of Week");
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
                               TTTimetableFInalCollector."Lesson Code":=TTTimetableCollectorA."Lesson Code";
                               TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorA."Lesson Category";
                               TTTimetableFInalCollector."Day of Week":=TTTimetableCollectorA."Day of Week";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorA."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorA.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorA.Department;
                               TTTimetableFInalCollector."Day Order":=TTTimetableCollectorA."Day Order";
                               TTTimetableFInalCollector."Lesson Order":=TTTimetableCollectorA."Lesson Order";
                               TTTimetableFInalCollector."Class Code":=TTTimetableCollectorA."Class Code";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorA."Room Type";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorA."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorA."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorA."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorA."Campus Code";
                               TTTimetableFInalCollector."Lesson Type":='SINGLE';
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
          //Capture the Doubles
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
        progre.Open('Finalizing Doubles:  #1#############################'+
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
        TTTimetableCollectorDoubles.Reset;
        TTTimetableCollectorDoubles.SetRange(Semester,Rec.Semester);
        TTTimetableCollectorDoubles.SetRange(Allocated,true);
        if TTTimetableCollectorDoubles.Find('-') then begin
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
            RecCount1:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code"
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
            RecCount10:=Format(counts)+'). Lecturer: '+TTTimetableCollectorDoubles.Lecturer+'; Programme: '+TTTimetableCollectorDoubles.Programme+'; Unit: '+
        TTTimetableCollectorDoubles.Unit+'; Campus: '+TTTimetableCollectorDoubles."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
            TTLessons1.Reset;
            TTLessons1.SetRange("Lesson Order",TTTimetableCollectorDoubles."Lesson 1");
            if TTLessons1.Find('-') then  begin
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorDoubles.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorDoubles.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Lesson Code",TTLessons1."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                              TTTimetableFInalCollector.SetRange("Lecture Room",TTTimetableCollectorDoubles."Lecture Room");
                              TTTimetableFInalCollector.SetRange(Lecturer,TTTimetableCollectorDoubles.Lecturer);
                             // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableFInalCollector.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                              TTTimetableFInalCollector.SetRange("Block/Building",TTTimetableCollectorDoubles."Block/Building");
                             // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if not (TTTimetableFInalCollector.Find('-')) then begin
                               TTTimetableFInalCollector.Init;
                               TTTimetableFInalCollector.Programme:=TTTimetableCollectorDoubles.Programme;
                               TTTimetableFInalCollector.Unit:=TTTimetableCollectorDoubles.Unit;
                               TTTimetableFInalCollector.Semester:=Rec.Semester;
                               TTTimetableFInalCollector."Lesson Code":=TTLessons1."Lesson Code";
                               TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorDoubles."Lesson Category";
                               TTTimetableFInalCollector."Day of Week":=TTTimetableCollectorDoubles."Day of Week";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorDoubles."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorDoubles.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorDoubles.Department;
                               TTTimetableFInalCollector."Day Order":=TTTimetableCollectorDoubles."Day Order";
                               TTTimetableFInalCollector."Lesson Order":=TTLessons1."Lesson Order";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorDoubles."Room Type";
                               TTTimetableFInalCollector."Class Code":=TTTimetableCollectorDoubles."Class Code";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorDoubles."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorDoubles."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorDoubles."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorDoubles."Campus Code";
                               TTTimetableFInalCollector."Lesson Type":='DOUBLE';
                               if ((Rec.Semester<>'') and (TTTimetableCollectorDoubles."Room Code"<>'') and (TTTimetableCollectorDoubles.Lecturer<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableFInalCollector."Record ID":=CountedEntries;
                               TTTimetableFInalCollector.Insert;
                                 end;
                               end;
              end;

            TTLessons2.Reset;
            TTLessons2.SetRange("Lesson Order",TTTimetableCollectorDoubles."Lesson 2");
            if TTLessons2.Find('-') then  begin
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorDoubles.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorDoubles.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Lesson Code",TTLessons2."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Day of Week",TTTimetableCollectorDoubles."Day of Week");
                              TTTimetableFInalCollector.SetRange("Lecture Room",TTTimetableCollectorDoubles."Lecture Room");
                              TTTimetableFInalCollector.SetRange(Lecturer,TTTimetableCollectorDoubles.Lecturer);
                             // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableFInalCollector.SetRange("Room Code",TTTimetableCollectorDoubles."Room Code");
                              TTTimetableFInalCollector.SetRange("Block/Building",TTTimetableCollectorDoubles."Block/Building");
                             // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if not (TTTimetableFInalCollector.Find('-')) then begin
                               TTTimetableFInalCollector.Init;
                               TTTimetableFInalCollector.Programme:=TTTimetableCollectorDoubles.Programme;
                               TTTimetableFInalCollector.Unit:=TTTimetableCollectorDoubles.Unit;
                               TTTimetableFInalCollector.Semester:=Rec.Semester;
                               TTTimetableFInalCollector."Lesson Code":=TTLessons2."Lesson Code";
                               TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorDoubles."Lesson Category";
                               TTTimetableFInalCollector."Day of Week":=TTTimetableCollectorDoubles."Day of Week";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorDoubles."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorDoubles.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorDoubles.Department;
                               TTTimetableFInalCollector."Class Code":=TTTimetableCollectorDoubles."Class Code";
                               TTTimetableFInalCollector."Day Order":=TTTimetableCollectorDoubles."Day Order";
                               TTTimetableFInalCollector."Lesson Order":=TTLessons2."Lesson Order";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorDoubles."Room Type";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorDoubles."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorDoubles."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorDoubles."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorDoubles."Campus Code";
                               TTTimetableFInalCollector."Lesson Type":='DOUBLE';
                               if ((Rec.Semester<>'') and (TTTimetableCollectorDoubles."Room Code"<>'') and (TTTimetableCollectorDoubles.Lecturer<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableFInalCollector."Record ID":=CountedEntries;
                               TTTimetableFInalCollector.Insert;
                                 end;
                               end;
              end;
            end;
            until TTTimetableCollectorDoubles.Next=0;
          end;
          progre.Close;
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
        progre.Open('Finalizing Tripples:  #1#############################'+
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
          //Capture the Tripples
        TTTimetableCollectorTripple.Reset;
        TTTimetableCollectorTripple.SetRange(Semester,Rec.Semester);
        TTTimetableCollectorTripple.SetRange(Allocated,true);
        if TTTimetableCollectorTripple.Find('-') then begin
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
            RecCount1:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            else if counts=2 then begin
            RecCount2:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=3 then begin
            RecCount3:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=4 then begin
            RecCount4:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=5 then begin
            RecCount5:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=6 then begin
            RecCount6:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=7 then begin
            RecCount7:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=8 then begin
            RecCount8:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=9 then begin
            RecCount9:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
            end
            else if counts=10 then begin
            RecCount10:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code"
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
            RecCount10:=Format(counts)+'). Lecturer: '+TTTimetableCollectorTripple.Lecturer+'; Programme: '+TTTimetableCollectorTripple.Programme+'; Unit: '+
        TTTimetableCollectorTripple.Unit+'; Campus: '+TTTimetableCollectorTripple."Campus Code";
            end;
            Clear(BufferString);
            BufferString:='Total Tripples processed = '+Format(counts);

            progre.Update();
             //SLEEP(50);
                            ///////////////////////////////////////////////////////////////////////////////Progress Update
            TTLessons1.Reset;
            TTLessons1.SetRange("Lesson Order",TTTimetableCollectorTripple."Lesson 1");
            if TTLessons1.Find('-') then  begin
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorTripple.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorTripple.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Lesson Code",TTLessons1."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                              TTTimetableFInalCollector.SetRange("Lecture Room",TTTimetableCollectorTripple."Lecture Room");
                              TTTimetableFInalCollector.SetRange(Lecturer,TTTimetableCollectorTripple.Lecturer);
                             // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableFInalCollector.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                              TTTimetableFInalCollector.SetRange("Block/Building",TTTimetableCollectorTripple."Block/Building");
                             // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if not (TTTimetableFInalCollector.Find('-')) then begin
                               TTTimetableFInalCollector.Init;
                               TTTimetableFInalCollector.Programme:=TTTimetableCollectorTripple.Programme;
                               TTTimetableFInalCollector.Unit:=TTTimetableCollectorTripple.Unit;
                               TTTimetableFInalCollector.Semester:=Rec.Semester;
                               TTTimetableFInalCollector."Lesson Code":=TTLessons1."Lesson Code";
                               TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorTripple."Lesson Category";
                               TTTimetableFInalCollector."Day of Week":=TTTimetableCollectorTripple."Day of Week";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorTripple."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorTripple.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorTripple.Department;
                               TTTimetableFInalCollector."Day Order":=TTTimetableCollectorTripple."Day Order";
                               TTTimetableFInalCollector."Class Code":=TTTimetableCollectorTripple."Class Code";
                               TTTimetableFInalCollector."Lesson Order":=TTLessons1."Lesson Order";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorTripple."Room Type";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorTripple."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorTripple."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorTripple."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorTripple."Campus Code";
                               TTTimetableFInalCollector."Lesson Type":='TRIPPLE';
                               if ((Rec.Semester<>'') and (TTTimetableCollectorTripple."Room Code"<>'') and (TTTimetableCollectorTripple.Lecturer<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableFInalCollector."Record ID":=CountedEntries;
                               TTTimetableFInalCollector.Insert;
                                 end;
                               end;
              end;

            TTLessons2.Reset;
            TTLessons2.SetRange("Lesson Order",TTTimetableCollectorTripple."Lesson 2");
            if TTLessons2.Find('-') then  begin
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorTripple.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorTripple.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Lesson Code",TTLessons2."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                              TTTimetableFInalCollector.SetRange("Lecture Room",TTTimetableCollectorTripple."Lecture Room");
                              TTTimetableFInalCollector.SetRange(Lecturer,TTTimetableCollectorTripple.Lecturer);
                             // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableFInalCollector.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                              TTTimetableFInalCollector.SetRange("Block/Building",TTTimetableCollectorTripple."Block/Building");
                             // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if not (TTTimetableFInalCollector.Find('-')) then begin
                               TTTimetableFInalCollector.Init;
                               TTTimetableFInalCollector.Programme:=TTTimetableCollectorTripple.Programme;
                               TTTimetableFInalCollector.Unit:=TTTimetableCollectorTripple.Unit;
                               TTTimetableFInalCollector.Semester:=Rec.Semester;
                               TTTimetableFInalCollector."Lesson Code":=TTLessons2."Lesson Code";
                               TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorTripple."Lesson Category";
                               TTTimetableFInalCollector."Day of Week":=TTTimetableCollectorTripple."Day of Week";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorTripple."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorTripple.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorTripple.Department;
                               TTTimetableFInalCollector."Day Order":=TTTimetableCollectorTripple."Day Order";
                               TTTimetableFInalCollector."Class Code":=TTTimetableCollectorTripple."Class Code";
                               TTTimetableFInalCollector."Lesson Order":=TTLessons2."Lesson Order";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorTripple."Room Type";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorTripple."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorTripple."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorTripple."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorTripple."Campus Code";
                               TTTimetableFInalCollector."Lesson Type":='TRIPPLE';
                               if ((Rec.Semester<>'') and (TTTimetableCollectorTripple."Room Code"<>'') and (TTTimetableCollectorTripple.Lecturer<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableFInalCollector."Record ID":=CountedEntries;
                               TTTimetableFInalCollector.Insert;
                                 end;
                               end;
              end;
            TTLessons3.Reset;
            TTLessons3.SetRange("Lesson Order",TTTimetableCollectorTripple."Lesson 3");
            if TTLessons3.Find('-') then  begin
                              TTTimetableFInalCollector.Reset;
                              TTTimetableFInalCollector.SetRange(Programme,TTTimetableCollectorTripple.Programme);
                              TTTimetableFInalCollector.SetRange(Unit,TTTimetableCollectorTripple.Unit);
                              TTTimetableFInalCollector.SetRange(Semester,Rec.Semester);
                              TTTimetableFInalCollector.SetRange("Lesson Code",TTLessons3."Lesson Code");
                              TTTimetableFInalCollector.SetRange("Day of Week",TTTimetableCollectorTripple."Day of Week");
                              TTTimetableFInalCollector.SetRange("Lecture Room",TTTimetableCollectorTripple."Lecture Room");
                              TTTimetableFInalCollector.SetRange(Lecturer,TTTimetableCollectorTripple.Lecturer);
                             // TTTimetableFInalCollector.SETRANGE("Campus Code",ACALecturersUnits.);
                             // TTTimetableFInalCollector.SETRANGE(Department,LectLoadBatchLines,Department);
                              TTTimetableFInalCollector.SetRange("Room Code",TTTimetableCollectorTripple."Room Code");
                              TTTimetableFInalCollector.SetRange("Block/Building",TTTimetableCollectorTripple."Block/Building");
                             // TTTimetableFInalCollector.SETRANGE("Lesson Category",TTUnits."Weighting Category");
                             // TTTimetableFInalCollector.SETRANGE("School or Faculty",LectLoadBatchLines.Faculty);
                             if not (TTTimetableFInalCollector.Find('-')) then begin
                               TTTimetableFInalCollector.Init;
                               TTTimetableFInalCollector.Programme:=TTTimetableCollectorTripple.Programme;
                               TTTimetableFInalCollector.Unit:=TTTimetableCollectorTripple.Unit;
                               TTTimetableFInalCollector.Semester:=Rec.Semester;
                               TTTimetableFInalCollector."Lesson Code":=TTLessons3."Lesson Code";
                               TTTimetableFInalCollector."Lesson Category":=TTTimetableCollectorTripple."Lesson Category";
                               TTTimetableFInalCollector."Day of Week":=TTTimetableCollectorTripple."Day of Week";
                               TTTimetableFInalCollector."Lecture Room":=TTTimetableCollectorTripple."Room Code";
                               TTTimetableFInalCollector.Lecturer:=TTTimetableCollectorTripple.Lecturer;
                               TTTimetableFInalCollector.Department:=TTTimetableCollectorTripple.Department;
                               TTTimetableFInalCollector."Day Order":=TTTimetableCollectorTripple."Day Order";
                               TTTimetableFInalCollector."Class Code":=TTTimetableCollectorTripple."Class Code";
                               TTTimetableFInalCollector."Lesson Order":=TTLessons3."Lesson Order";
                             //  TTTimetableFInalCollector."Programme Option":=;
                               TTTimetableFInalCollector."Room Type":=TTTimetableCollectorTripple."Room Type";
                               TTTimetableFInalCollector."Room Code":=TTTimetableCollectorTripple."Room Code";
                               TTTimetableFInalCollector."Block/Building":=TTTimetableCollectorTripple."Block/Building";
                               TTTimetableFInalCollector."School or Faculty":=TTTimetableCollectorTripple."School or Faculty";
                               TTTimetableFInalCollector."Campus Code":=TTTimetableCollectorTripple."Campus Code";
                               TTTimetableFInalCollector."Lesson Type":='TRIPPLE';
                               if ((Rec.Semester<>'') and (TTTimetableCollectorTripple."Room Code"<>'') and (TTTimetableCollectorTripple.Lecturer<>'')) then begin
                                 CountedEntries:=CountedEntries+1;
                               TTTimetableFInalCollector."Record ID":=CountedEntries;
                               TTTimetableFInalCollector.Insert;
                                 end;
                               end;
              end;
            end;
            until TTTimetableCollectorTripple.Next=0;
          end;
          progre.Close;
    end;

    local procedure SpecificConstraintsProgCampuses()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
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
            if ToDeleteSingles then
              if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Singles
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Doubles
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
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Campus Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Preferred then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Mandatory then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;
            end;
            until TTProgSpecCampuses.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTProgSpecCampuses.Reset;
        TTProgSpecCampuses.SetRange(Semester,Rec.Semester);
        TTProgSpecCampuses.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTProgSpecCampuses.SetFilter("Constraint Category",'=%1',TTProgSpecCampuses."constraint category"::Mandatory);
        if TTProgSpecCampuses.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'<>%1',TTProgSpecCampuses."Campus Code");
            end;
            until TTProgSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then
              if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Doubles
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Tripples
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
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Campus Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Preferred then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTProgSpecCampuses."Constraint Category"=TTProgSpecCampuses."constraint category"::Mandatory then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTProgSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;
            end;
            until TTProgSpecCampuses.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTProgSpecCampuses.Reset;
        TTProgSpecCampuses.SetRange(Semester,Rec.Semester);
        TTProgSpecCampuses.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTProgSpecCampuses.SetFilter("Constraint Category",'=%1',TTProgSpecCampuses."constraint category"::Mandatory);
        if TTProgSpecCampuses.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Campus Code",'<>%1',TTProgSpecCampuses."Campus Code");
            end;
            until TTProgSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then
              if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsLectCampuses()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
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
            if ToDeleteSingles then
              if TTTimetableCollectorSingles.Find('-') then  TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
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
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Lecturer Campus Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;
            end;
            until TTLectSpecCampuses.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTLectSpecCampuses.Reset;
        TTLectSpecCampuses.SetRange(Semester,Rec.Semester);
        TTLectSpecCampuses.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTLectSpecCampuses.SetFilter("Constraint Category",'=%1',TTLectSpecCampuses."constraint category"::Mandatory);
        if TTLectSpecCampuses.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'<>%1',TTLectSpecCampuses."Campus Code");
            end;
            until TTLectSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
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
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Lecturer and Campus Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Lecturer Campus Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Preferred then begin
              //For the Lecturer nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTLectSpecCampuses."Constraint Category"=TTLectSpecCampuses."constraint category"::Mandatory then begin
              //For the Lecturer nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTLectSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;
            end;
            until TTLectSpecCampuses.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTLectSpecCampuses.Reset;
        TTLectSpecCampuses.SetRange(Semester,Rec.Semester);
        TTLectSpecCampuses.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTLectSpecCampuses.SetFilter("Constraint Category",'=%1',TTLectSpecCampuses."constraint category"::Mandatory);
        if TTLectSpecCampuses.Find('-') then begin
          //There Exists Lecturer Specific Campus Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Campus Code",'<>%1',TTLectSpecCampuses."Campus Code");
            end;
            until TTLectSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then
              if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsUnitCampuses()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
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
            if ToDeleteSingles then if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
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
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Unit Campus Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Unit Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Unit Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;
            end;
            until TTUnitSpecCampuses.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTUnitSpecCampuses.Reset;
        TTUnitSpecCampuses.SetRange(Semester,Rec.Semester);
        TTUnitSpecCampuses.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTUnitSpecCampuses.SetFilter("Constraint Category",'=%1',TTUnitSpecCampuses."constraint category"::Mandatory);
        if TTUnitSpecCampuses.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Campus Code",'<>%1',TTUnitSpecCampuses."Campus Code");
            end;
            until TTUnitSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then if TTTimetableCollectorDoubles.Find('-') then  TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
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
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::"Least Preferred" then begin
              //For the Unit and Campus Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Unit Campus Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Preferred then begin
              //For the Unit nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Unit Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTUnitSpecCampuses."Constraint Category"=TTUnitSpecCampuses."constraint category"::Mandatory then begin
              //For the Unit nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Campus Code",'%1',TTUnitSpecCampuses."Campus Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Unit Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;
            end;
            until TTUnitSpecCampuses.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTUnitSpecCampuses.Reset;
        TTUnitSpecCampuses.SetRange(Semester,Rec.Semester);
        TTUnitSpecCampuses.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecCampuses.SetFilter("Campus Code",'<>%1','');
        TTUnitSpecCampuses.SetFilter("Constraint Category",'=%1',TTUnitSpecCampuses."constraint category"::Mandatory);
        if TTUnitSpecCampuses.Find('-') then begin
          //There Exists Unit Specific Campus Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Campus Code",'<>%1',TTUnitSpecCampuses."Campus Code");
            end;
            until TTUnitSpecCampuses.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then if TTTimetableCollectorTripple.Find('-') then  TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsProgRooms()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
        ToDeleteSingles: Boolean;
        ToDeleteDoubles: Boolean;
        ToDeleteTripples: Boolean;
    begin
        //////////////////////////////////////////////////////////////Prog Spec. Room on Singles
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecRooms.Reset;
        TTProgSpecRooms.SetRange(Semester,Rec.Semester);
        TTProgSpecRooms.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecRooms.SetFilter("Room Code",'<>%1','');
        if TTProgSpecRooms.Find('-') then begin
          //There Exists Programme Specific Room
          repeat
            begin
            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Room Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::"Least Preferred" then begin
              //For the Programme and Room Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Room Priority":=10;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Preferred then begin
              //For the Programme and Room Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Room Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;

            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Mandatory then begin
              //For the Programme and Room Specified, Set Priority as 1
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorSingles."Programme Room Priority":=1;
              TTTimetableCollectorSingles.Modify;
            end;
            until TTTimetableCollectorSingles.Next=0;
            end;
              end;
            end;
            until TTProgSpecRooms.Next=0;
          end;


            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteSingles);
            //// If the Constraints are Nandatory
          TTProgSpecRooms.Reset;
        TTProgSpecRooms.SetRange(Semester,Rec.Semester);
        TTProgSpecRooms.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecRooms.SetFilter("Room Code",'<>%1','');
        TTProgSpecRooms.SetFilter("Constraint Category",'=%1',TTProgSpecRooms."constraint category"::Mandatory);
        if TTProgSpecRooms.Find('-') then begin
          //There Exists Programme Specific Room Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Room code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter("Room Code",'<>%1',TTProgSpecRooms."Room Code");
            end;
            until TTProgSpecRooms.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then if TTTimetableCollectorSingles.Find('-') then  TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Room on Singles
        //////////////////////////////////////////////////////////////Prog Spec. Room on Doubles
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecRooms.Reset;
        TTProgSpecRooms.SetRange(Semester,Rec.Semester);
        TTProgSpecRooms.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecRooms.SetFilter("Room Code",'<>%1','');
        if TTProgSpecRooms.Find('-') then begin
          //There Exists Programme Specific Room
          repeat
            begin
            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Room Specified
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::"Least Preferred" then begin
              //For the Programme and Room Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Room Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Preferred then begin
              //For the Programme and Room Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Room Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Mandatory then begin
              //For the Programme and Room Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Room Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;
            end;
            until TTProgSpecRooms.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTProgSpecRooms.Reset;
        TTProgSpecRooms.SetRange(Semester,Rec.Semester);
        TTProgSpecRooms.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecRooms.SetFilter("Room Code",'<>%1','');
        TTProgSpecRooms.SetFilter("Constraint Category",'=%1',TTProgSpecRooms."constraint category"::Mandatory);
        if TTProgSpecRooms.Find('-') then begin
          //There Exists Programme Specific Room Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Room code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Room Code",'<>%1',TTProgSpecRooms."Room Code");
            end;
            until TTProgSpecRooms.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Room on Doubles
        //////////////////////////////////////////////////////////////Prog Spec. Room on Tripples
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecRooms.Reset;
        TTProgSpecRooms.SetRange(Semester,Rec.Semester);
        TTProgSpecRooms.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecRooms.SetFilter("Room Code",'<>%1','');
        if TTProgSpecRooms.Find('-') then begin
          //There Exists Programme Specific Room
          repeat
            begin
            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Room Specified
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::"Least Preferred" then begin
              //For the Programme and Room Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Room Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Preferred then begin
              //For the Programme and Room Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Room Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTProgSpecRooms."Constraint Category"=TTProgSpecRooms."constraint category"::Mandatory then begin
              //For the Programme and Room Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTProgSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Room Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;
            end;
            until TTProgSpecRooms.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTProgSpecRooms.Reset;
        TTProgSpecRooms.SetRange(Semester,Rec.Semester);
        TTProgSpecRooms.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecRooms.SetFilter("Room Code",'<>%1','');
        TTProgSpecRooms.SetFilter("Constraint Category",'=%1',TTProgSpecRooms."constraint category"::Mandatory);
        if TTProgSpecRooms.Find('-') then begin
          //There Exists Programme Specific Room Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Room code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Room Code",'<>%1',TTProgSpecRooms."Room Code");
            end;
            until TTProgSpecRooms.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Room on Tripples
    end;

    local procedure SpecificConstraintsUnitRooms()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
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
        TTUnitSpecRooms.SetRange("Programme Code",TTUnits."Programme Code");
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
              TTTimetableCollectorSingles."Unit Room Priority":=3;
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

            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorSingles.SetFilter("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorSingles.Find('-') then begin
              TTTimetableCollectorSingles.DeleteAll;
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
            if ToDeleteSingles then if TTTimetableCollectorSingles.Find('-') then  TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Singles
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
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
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Unit Room Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Unit Room Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Unit Room Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;

            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorDoubles.SetFilter("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
              TTTimetableCollectorDoubles.DeleteAll;
            end;

              end;
            end;
            until TTUnitSpecRooms.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Unit,TTUnits."Unit Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTUnitSpecRooms.Reset;
        TTUnitSpecRooms.SetRange(Semester,Rec.Semester);
        TTUnitSpecRooms.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecRooms.SetFilter("Room Code",'<>%1','');
        TTUnitSpecRooms.SetFilter("Constraint Category",'=%1',TTUnitSpecRooms."constraint category"::Mandatory);
        if TTUnitSpecRooms.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
            end;
            until TTUnitSpecRooms.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then if TTTimetableCollectorDoubles.Find('-') then  TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Doubles
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
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
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::"Least Preferred" then begin
              //For the Unit and Campus Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Unit Room Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Preferred then begin
              //For the Unit nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Unit Room Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTUnitSpecRooms."Constraint Category"=TTUnitSpecRooms."constraint category"::Mandatory then begin
              //For the Unit nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Unit Room Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;

            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
            TTTimetableCollectorTripple.SetFilter("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
            if TTTimetableCollectorTripple.Find('-') then begin
              TTTimetableCollectorTripple.DeleteAll;
            end;

              end;
            end;
            until TTUnitSpecRooms.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Unit,TTUnits."Unit Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTUnitSpecRooms.Reset;
        TTUnitSpecRooms.SetRange(Semester,Rec.Semester);
        TTUnitSpecRooms.SetRange("Unit Code",TTUnits."Unit Code");
        TTUnitSpecRooms.SetFilter("Room Code",'<>%1','');
        TTUnitSpecRooms.SetFilter("Constraint Category",'=%1',TTUnitSpecRooms."constraint category"::Mandatory);
        if TTUnitSpecRooms.Find('-') then begin
          //There Exists Unit Specific Campus Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Room Code",'<>%1',TTUnitSpecRooms."Room Code");
            end;
            until TTUnitSpecRooms.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTUnits.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Campus on Tripples
    end;

    local procedure SpecificConstraintsProgDays()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
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
        TTProgSpecDays.SetFilter("Day Code",'<>%1','');
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus
          repeat
            begin
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
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
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
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
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
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
        TTProgSpecDays.SetFilter("Day Code",'<>%1','');
        TTProgSpecDays.SetFilter("Constraint Category",'=%1',TTProgSpecDays."constraint category"::Mandatory);
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteSingles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorSingles.SetFilter("Day of Week",'<>%1',TTProgSpecDays."Day Code");
            end;
            until TTProgSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteSingles then if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Days on Singles
        //////////////////////////////////////////////////////////////Prog Spec. Days on Doubles
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecDays.Reset;
        TTProgSpecDays.SetRange(Semester,Rec.Semester);
        TTProgSpecDays.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecDays.SetFilter("Day Code",'<>%1','');
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus
          repeat
            begin
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Campus Specified
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Day Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Day Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Programme Day Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;
            end;
            until TTProgSpecDays.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTProgSpecDays.Reset;
        TTProgSpecDays.SetRange(Semester,Rec.Semester);
        TTProgSpecDays.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecDays.SetFilter("Day Code",'<>%1','');
        TTProgSpecDays.SetFilter("Constraint Category",'=%1',TTProgSpecDays."constraint category"::Mandatory);
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'<>%1',TTProgSpecDays."Day Code");
            end;
            until TTProgSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Days on Doubles
        //////////////////////////////////////////////////////////////Prog Spec. Days on Tripples
        TTProgrammes.Reset;
        TTProgrammes.SetRange(Semester,Rec.Semester);
        if TTProgrammes.Find('-') then begin
          repeat
            begin
        TTProgSpecDays.Reset;
        TTProgSpecDays.SetRange(Semester,Rec.Semester);
        TTProgSpecDays.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecDays.SetFilter("Day Code",'<>%1','');
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus
          repeat
            begin
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Programme and Campus Specified
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::"Least Preferred" then begin
              //For the Programme and Campus Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Day Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Preferred then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Day Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTProgSpecDays."Constraint Category"=TTProgSpecDays."constraint category"::Mandatory then begin
              //For the Programme and Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTProgSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Programme Day Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;
            end;
            until TTProgSpecDays.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Programme,TTProgrammes."Programme Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTProgSpecDays.Reset;
        TTProgSpecDays.SetRange(Semester,Rec.Semester);
        TTProgSpecDays.SetRange("Programme Code",TTProgrammes."Programme Code");
        TTProgSpecDays.SetFilter("Day Code",'<>%1','');
        TTProgSpecDays.SetFilter("Constraint Category",'=%1',TTProgSpecDays."constraint category"::Mandatory);
        if TTProgSpecDays.Find('-') then begin
          //There Exists Programme Specific Campus Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Day of Week",'<>%1',TTProgSpecDays."Day Code");
            end;
            until TTProgSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then if TTTimetableCollectorTripple.Find('-') then  TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTProgrammes.Next=0;
        end;
        //////////////////////////////////////////////////////////////Prog Spec. Days on Tripples
    end;

    local procedure SpecificConstraintsLectDays()
    var
        TTProgSpecCampuses: Record UnknownRecord74507;
        TTProgSpecRooms: Record UnknownRecord74509;
        TTProgSpecDays: Record UnknownRecord74508;
        TTLectSpecCampuses: Record UnknownRecord74510;
        TTLectSpecDays: Record UnknownRecord74511;
        TTLectSpecLessons: Record UnknownRecord74512;
        TTUnitSpecCampuses: Record UnknownRecord74513;
        TTUnitSpecRooms: Record UnknownRecord74514;
        TTTimetableCollectorSingles: Record UnknownRecord74500;
        TTTimetableCollectorDoubles: Record UnknownRecord74521;
        TTTimetableCollectorTripple: Record UnknownRecord74522;
        TTProgrammes: Record UnknownRecord74504;
        TTUnits: Record UnknownRecord74517;
        TTLecturers: Record UnknownRecord74518;
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
        TTLectSpecDays.SetFilter("Day Code",'<>%1','');
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Lecturer and Campus Specified
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorSingles.Find('-') then TTTimetableCollectorSingles.DeleteAll;
              end;
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorSingles.Reset;
            TTTimetableCollectorSingles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
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
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
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
            TTTimetableCollectorSingles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
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
        TTLectSpecDays.SetFilter("Day Code",'<>%1','');
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
            if ToDeleteSingles then if TTTimetableCollectorSingles.Find('-') then  TTTimetableCollectorSingles.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Days on Singles
        //////////////////////////////////////////////////////////////Lect Spec. Days on Doubles
        TTLecturers.Reset;
        TTLecturers.SetRange(Semester,Rec.Semester);
        if TTLecturers.Find('-') then begin
          repeat
            begin
        TTLectSpecDays.Reset;
        TTLectSpecDays.SetRange(Semester,Rec.Semester);
        TTLectSpecDays.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecDays.SetFilter("Day Code",'<>%1','');
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.DeleteAll;
              end;
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then begin
              //For the Lect and Campus Specified, Set Priority as 10
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Lecturer Campus Priority":=10;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Preferred then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;

            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Mandatory then begin
              //For the Lect and Campus Specified, Set Priority as 1
            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorDoubles.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorDoubles."Lecturer Campus Priority":=1;
              TTTimetableCollectorDoubles.Modify;
            end;
            until TTTimetableCollectorDoubles.Next=0;
            end;
              end;
            end;
            until TTLectSpecDays.Next=0;
          end;


            TTTimetableCollectorDoubles.Reset;
            TTTimetableCollectorDoubles.SetRange(Lecturer,TTLecturers."Lecturer Code");
          Clear(ToDeleteDoubles);
            //// If the Constraints are Nandatory
          TTLectSpecDays.Reset;
        TTLectSpecDays.SetRange(Semester,Rec.Semester);
        TTLectSpecDays.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecDays.SetFilter("Day Code",'<>%1','');
        TTLectSpecDays.SetFilter("Constraint Category",'=%1',TTLectSpecDays."constraint category"::Mandatory);
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lect Specific Campus Where Category is Mandatory
            ToDeleteDoubles:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorDoubles.SetFilter("Day of Week",'<>%1',TTLectSpecDays."Day Code");
            end;
            until TTLectSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteDoubles then if TTTimetableCollectorDoubles.Find('-') then TTTimetableCollectorDoubles.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Days on Doubles
        //////////////////////////////////////////////////////////////Lect Spec. Days on Tripples
        TTLecturers.Reset;
        TTLecturers.SetRange(Semester,Rec.Semester);
        if TTLecturers.Find('-') then begin
          repeat
            begin
        TTLectSpecDays.Reset;
        TTLectSpecDays.SetRange(Semester,Rec.Semester);
        TTLectSpecDays.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecDays.SetFilter("Day Code",'<>%1','');
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lect Specific Campus
          repeat
            begin
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Avoid then begin
              //Delete all entries for the Lect and Campus Specified
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.DeleteAll;
              end;
            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::"Least Preferred" then begin
              //For the Lecturer and Campus Specified, Set Priority as 10
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Lecturer Campus Priority":=10;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Preferred then begin
              //For the Lecturer nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;

            if TTLectSpecDays."Constraint Category"=TTLectSpecDays."constraint category"::Mandatory then begin
              //For the Lecturer nd Campus Specified, Set Priority as 1
            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
            TTTimetableCollectorTripple.SetFilter("Day of Week",'%1',TTLectSpecDays."Day Code");
            if TTTimetableCollectorTripple.Find('-') then begin
            repeat
            begin
              TTTimetableCollectorTripple."Lecturer Campus Priority":=1;
              TTTimetableCollectorTripple.Modify;
            end;
            until TTTimetableCollectorTripple.Next=0;
            end;
              end;
            end;
            until TTLectSpecDays.Next=0;
          end;


            TTTimetableCollectorTripple.Reset;
            TTTimetableCollectorTripple.SetRange(Lecturer,TTLecturers."Lecturer Code");
          Clear(ToDeleteTripples);
            //// If the Constraints are Nandatory
          TTLectSpecDays.Reset;
        TTLectSpecDays.SetRange(Semester,Rec.Semester);
        TTLectSpecDays.SetRange("Lecturer Code",TTLecturers."Lecturer Code");
        TTLectSpecDays.SetFilter("Day Code",'<>%1','');
        TTLectSpecDays.SetFilter("Constraint Category",'=%1',TTLectSpecDays."constraint category"::Mandatory);
        if TTLectSpecDays.Find('-') then begin
          //There Exists Lecturer Specific Campus Where Category is Mandatory
            ToDeleteTripples:=true;
          repeat
            begin
            //Keep filtering where Campus code is Not the one selected...
            TTTimetableCollectorTripple.SetFilter("Day of Week",'<>%1',TTLectSpecDays."Day Code");
            end;
            until TTLectSpecDays.Next=0;
            // After Repeated Filtering, Delete All Entries in the Filters
            if ToDeleteTripples then if TTTimetableCollectorTripple.Find('-') then TTTimetableCollectorTripple.Delete;
          end;
        end;
        until TTLecturers.Next=0;
        end;
        //////////////////////////////////////////////////////////////Lect Spec. Days on Tripples
    end;
}

