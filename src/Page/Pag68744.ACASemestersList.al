#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68744 "ACA-Semesters List"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61692;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field("To";"To")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Current Semester";"Current Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("SMS Results Semester";"SMS Results Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Lock Exam Editting";"Lock Exam Editting")
                {
                    ApplicationArea = Basic;
                }
                field("Lock CAT Editting";"Lock CAT Editting")
                {
                    ApplicationArea = Basic;
                }
                field("Evaluate Lecture";"Evaluate Lecture")
                {
                    ApplicationArea = Basic;
                }
                field("Registration Deadline";"Registration Deadline")
                {
                    ApplicationArea = Basic;
                }
                field("Lock Lecturer Editing";"Lock Lecturer Editing")
                {
                    ApplicationArea = Basic;
                }
                field("Mark entry Dealine";"Mark entry Dealine")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark Entry Deadline (Regular)';
                }
                field("Special  Entry Deadline";"Special  Entry Deadline")
                {
                    ApplicationArea = Basic;
                }
                field("Released Results";"Released Results")
                {
                    ApplicationArea = Basic;
                }
                field("Marks Changeable";"Marks Changeable")
                {
                    ApplicationArea = Basic;
                }
                field("Results Buffer Programs";"Results Buffer Programs")
                {
                    ApplicationArea = Basic;
                }
                field("Scheduled Programs";"Scheduled Programs")
                {
                    ApplicationArea = Basic;
                }
                field("Ignore Editing Rule";"Ignore Editing Rule")
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
            action(Card)
            {
                ApplicationArea = Basic;
                Image = card;
                RunObject = Page "ACA-Semester Card";
                RunPageLink = Code=field(Code);
            }
            action(UpdateSchedules)
            {
                ApplicationArea = Basic;
                Caption = 'Update Schedules';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ACAProgramme: Record UnknownRecord61511;
                    ACAProgrammeStages: Record UnknownRecord61516;
                    ACAUnitsSubjects: Record UnknownRecord61517;
                    ACAProgSemesterSchedule: Record UnknownRecord66033;
                    ACAProgStageSemSchedule: Record UnknownRecord66034;
                    ACAProgStageUnitSemSche: Record UnknownRecord66035;
                    ACALectureMarksPermissions: Record UnknownRecord66036;
                    LectLoadBatchLines: Record UnknownRecord65202;
                    ACASemesters: Record UnknownRecord61692;
                    prog: Dialog;
                    CountedProgs: Integer;
                    RemainingProgs: Integer;
                    CountedProgUnits: Integer;
                    RemainingUnits: Integer;
                    CountedStages: Integer;
                    RemainingStages: Integer;
                begin
                    if Rec.Code = '' then Error('No Semester Selected!');
                    if Confirm('Update Schedules?',false)=false then Error('Cancelled!');

                    Clear(CountedProgs);
                    Clear(RemainingProgs);
                    Clear(CountedProgUnits);
                    Clear(RemainingUnits);
                    Clear(CountedStages);
                    Clear(RemainingStages);
                    prog.Open('#1######################################\'+
                    '#2######################################\'+
                    '#3######################################\'+
                    '#4######################################\'+
                    '#5######################################\'+
                    '#6######################################\');
                    ACASemesters.Reset;
                    ACASemesters.SetRange(Code,Rec.Code);
                    if ACASemesters.Find('-') then;
                    ACAProgSemesterSchedule.Reset;
                    ACAProgSemesterSchedule.SetRange(Code,Rec.Code);
                    if ACAProgSemesterSchedule.Find('-') then ACAProgSemesterSchedule.DeleteAll;
                    ACAProgStageSemSchedule.Reset;
                    ACAProgStageSemSchedule.SetRange(Code,Rec.Code);
                    if ACAProgStageSemSchedule.Find('-') then ACAProgStageSemSchedule.DeleteAll;
                    ACAProgStageUnitSemSche.Reset;
                    ACAProgStageUnitSemSche.SetRange(Code,Rec.Code);
                    if ACAProgStageUnitSemSche.Find('-') then ACAProgStageUnitSemSche.DeleteAll;
                    ACALectureMarksPermissions.Reset;
                    ACALectureMarksPermissions.SetRange(Code,Rec.Code);
                    if ACALectureMarksPermissions.Find('-') then ACALectureMarksPermissions.DeleteAll;
                    ACAProgramme.Reset;
                    if ACAProgramme.Find('-') then begin
                      CountedProgs:=ACAProgramme.Count;
                      RemainingProgs:=ACAProgramme.Count;
                    prog.Update(1,'Programs: '+Format(CountedProgs));
                      repeat
                        begin
                    prog.Update(2,'Remaining Programs: '+Format(RemainingProgs));
                    RemainingProgs:=RemainingProgs-1;
                        // Update Program Schedule here
                        ACAProgSemesterSchedule.Init;
                        ACAProgSemesterSchedule.Code:=ACASemesters.Code;
                        ACAProgSemesterSchedule."Programme Code":=ACAProgramme.Code;
                        if ACAProgSemesterSchedule.Insert then;

                    ACAProgSemesterSchedule.Reset;
                    ACAProgSemesterSchedule.SetRange(Code,Rec.Code);
                    ACAProgSemesterSchedule.SetRange("Programme Code",ACAProgramme.Code);
                    if ACAProgSemesterSchedule.Find('-') then begin
                    ACAProgSemesterSchedule."Start Date":=ACASemesters.From;
                    ACAProgSemesterSchedule."End Date":=ACASemesters."To";
                    ACAProgSemesterSchedule."Current Semester":=ACASemesters."Current Semester";
                    ACAProgSemesterSchedule."Academic Year":=ACASemesters."Academic Year";
                    ACAProgSemesterSchedule."SMS Results Semester":=ACASemesters."SMS Results Semester";
                    ACAProgSemesterSchedule."Lock Exam Editting":=ACASemesters."Lock Exam Editting";
                    ACAProgSemesterSchedule."Lock CAT Editting":=ACASemesters."Lock CAT Editting";
                    ACAProgSemesterSchedule."Released Results":=ACASemesters."Released Results";
                    ACAProgSemesterSchedule."Lock Lecturer Editing":=ACASemesters."Lock Lecturer Editing";
                    ACAProgSemesterSchedule."Mark entry Dealine":=ACASemesters."Mark entry Dealine";
                    ACAProgSemesterSchedule."Registration Deadline":=ACASemesters."Registration Deadline";
                    ACAProgSemesterSchedule."Ignore Editing Rule":=ACASemesters."Ignore Editing Rule";
                    ACAProgSemesterSchedule."BackLog Marks":=ACASemesters."BackLog Marks";
                    ACAProgSemesterSchedule.AllowDeanEditing:=ACASemesters.AllowDeanEditing;
                    ACAProgSemesterSchedule."Marks Changeable":=ACASemesters."Marks Changeable";
                    ACAProgSemesterSchedule."Evaluate Lecture":=ACASemesters."Evaluate Lecture";
                    ACAProgSemesterSchedule."Special  Entry Deadline":=ACASemesters."Special  Entry Deadline";
                    ACAProgSemesterSchedule.Remarks:=ACASemesters.Remarks;
                    ACAProgSemesterSchedule.Modify;
                      end;
                    ACAProgrammeStages.Reset;
                    ACAProgrammeStages.SetRange("Programme Code",ACAProgramme.Code);
                    if ACAProgrammeStages.Find('-') then begin
                      CountedStages:=ACAProgrammeStages.Count;
                    RemainingStages:=ACAProgrammeStages.Count;
                    prog.Update(3,'Stages: '+Format(CountedStages));
                      repeat
                        begin
                    prog.Update(4,'Remaining Stages: '+Format(RemainingStages));
                    RemainingStages:=RemainingStages-1;
                        // Update Program Stages Schedule here
                        ACAProgStageSemSchedule.Init;
                        ACAProgStageSemSchedule.Code:=ACASemesters.Code;
                        ACAProgStageSemSchedule."Programme Code":=ACAProgramme.Code;
                        ACAProgStageSemSchedule."Stage Code":=ACAProgrammeStages.Code;
                        if ACAProgStageSemSchedule.Insert then;

                    ACAProgStageSemSchedule.Reset;
                    ACAProgStageSemSchedule.SetRange(Code,Rec.Code);
                    ACAProgStageSemSchedule.SetRange("Programme Code",ACAProgramme.Code);
                    ACAProgStageSemSchedule.SetRange("Stage Code",ACAProgrammeStages.Code);
                    if ACAProgStageSemSchedule.Find('-') then begin
                    ACAProgStageSemSchedule."Start Date":=ACASemesters.From;
                    ACAProgStageSemSchedule."End Date":=ACASemesters."To";
                    ACAProgStageSemSchedule."Current Semester":=ACASemesters."Current Semester";
                    ACAProgStageSemSchedule."Academic Year":=ACASemesters."Academic Year";
                    ACAProgStageSemSchedule."SMS Results Semester":=ACASemesters."SMS Results Semester";
                    ACAProgStageSemSchedule."Lock Exam Editting":=ACASemesters."Lock Exam Editting";
                    ACAProgStageSemSchedule."Lock CAT Editting":=ACASemesters."Lock CAT Editting";
                    ACAProgStageSemSchedule."Released Results":=ACASemesters."Released Results";
                    ACAProgStageSemSchedule."Lock Lecturer Editing":=ACASemesters."Lock Lecturer Editing";
                    ACAProgStageSemSchedule."Mark entry Dealine":=ACASemesters."Mark entry Dealine";
                    ACAProgStageSemSchedule."Registration Deadline":=ACASemesters."Registration Deadline";
                    ACAProgStageSemSchedule."Ignore Editing Rule":=ACASemesters."Ignore Editing Rule";
                    ACAProgStageSemSchedule."BackLog Marks":=ACASemesters."BackLog Marks";
                    ACAProgStageSemSchedule.AllowDeanEditing:=ACASemesters.AllowDeanEditing;
                    ACAProgStageSemSchedule."Marks Changeable":=ACASemesters."Marks Changeable";
                    ACAProgStageSemSchedule."Evaluate Lecture":=ACASemesters."Evaluate Lecture";
                    ACAProgStageSemSchedule."Special  Entry Deadline":=ACASemesters."Special  Entry Deadline";
                    ACAProgStageSemSchedule.Remarks:=ACASemesters.Remarks;
                    ACAProgStageSemSchedule.Modify;
                      end;
                    ACAUnitsSubjects.Reset;
                    ACAUnitsSubjects.SetRange("Programme Code",ACAProgramme.Code);
                    ACAUnitsSubjects.SetRange("Stage Code",ACAProgrammeStages.Code);
                    if ACAUnitsSubjects.Find('-') then begin
                      CountedProgUnits:=ACAUnitsSubjects.Count;
                      RemainingUnits:=ACAUnitsSubjects.Count;
                    prog.Update(5,'Units: '+Format(RemainingUnits));
                      repeat
                        begin
                    prog.Update(6,'Remaining Units: '+Format(RemainingUnits));
                    RemainingUnits:=RemainingUnits-1;
                        // Update Subject Schedule here
                        ACAProgStageUnitSemSche.Init;
                        ACAProgStageUnitSemSche.Code:=ACASemesters.Code;
                        ACAProgStageUnitSemSche."Programme Code":=ACAProgramme.Code;
                        ACAProgStageUnitSemSche."Stage Code":=ACAProgrammeStages.Code;
                        ACAProgStageUnitSemSche."Unit Code":=ACAUnitsSubjects.Code;
                        if ACAProgStageUnitSemSche.Insert then;

                    ACAProgStageUnitSemSche.Reset;
                    ACAProgStageUnitSemSche.SetRange(Code,Rec.Code);
                    ACAProgStageUnitSemSche.SetRange("Programme Code",ACAProgramme.Code);
                    ACAProgStageUnitSemSche.SetRange("Stage Code",ACAProgrammeStages.Code);
                    ACAProgStageUnitSemSche.SetRange("Unit Code",ACAUnitsSubjects.Code);
                    if ACAProgStageUnitSemSche.Find('-') then begin
                    ACAProgStageUnitSemSche."Start Date":=ACASemesters.From;
                    ACAProgStageUnitSemSche."End Date":=ACASemesters."To";
                    ACAProgStageUnitSemSche."Current Semester":=ACASemesters."Current Semester";
                    ACAProgStageUnitSemSche."Academic Year":=ACASemesters."Academic Year";
                    ACAProgStageUnitSemSche."SMS Results Semester":=ACASemesters."SMS Results Semester";
                    ACAProgStageUnitSemSche."Lock Exam Editting":=ACASemesters."Lock Exam Editting";
                    ACAProgStageUnitSemSche."Lock CAT Editting":=ACASemesters."Lock CAT Editting";
                    ACAProgStageUnitSemSche."Released Results":=ACASemesters."Released Results";
                    ACAProgStageUnitSemSche."Lock Lecturer Editing":=ACASemesters."Lock Lecturer Editing";
                    ACAProgStageUnitSemSche."Mark entry Dealine":=ACASemesters."Mark entry Dealine";
                    ACAProgStageUnitSemSche."Registration Deadline":=ACASemesters."Registration Deadline";
                    ACAProgStageUnitSemSche."Ignore Editing Rule":=ACASemesters."Ignore Editing Rule";
                    ACAProgStageUnitSemSche."BackLog Marks":=ACASemesters."BackLog Marks";
                    ACAProgStageUnitSemSche.AllowDeanEditing:=ACASemesters.AllowDeanEditing;
                    ACAProgStageUnitSemSche."Marks Changeable":=ACASemesters."Marks Changeable";
                    ACAProgStageUnitSemSche."Evaluate Lecture":=ACASemesters."Evaluate Lecture";
                    ACAProgStageUnitSemSche."Special  Entry Deadline":=ACASemesters."Special  Entry Deadline";
                    ACAProgStageUnitSemSche.Remarks:=ACASemesters.Remarks;
                    ACAProgStageUnitSemSche.Modify;
                      end;
                        LectLoadBatchLines.Reset;
                        LectLoadBatchLines.SetRange(Programme,ACAProgramme.Code);
                        LectLoadBatchLines.SetRange(Stage,ACAProgrammeStages.Code);
                        LectLoadBatchLines.SetRange(Unit,ACAUnitsSubjects.Code);
                        if LectLoadBatchLines.Find('-') then begin
                          repeat
                          begin
                        // Update Lecturer Units Schedule here
                        ACALectureMarksPermissions.Init;
                        ACALectureMarksPermissions.Code:=ACASemesters.Code;
                        ACALectureMarksPermissions."Programme Code":=ACAProgramme.Code;
                        ACALectureMarksPermissions."Stage Code":=ACAProgrammeStages.Code;
                        ACALectureMarksPermissions."Lecturer Code":=LectLoadBatchLines.Lecturer;
                        if ACALectureMarksPermissions.Insert then;

                    ACALectureMarksPermissions.Reset;
                    ACALectureMarksPermissions.SetRange(Code,Rec.Code);
                    ACALectureMarksPermissions.SetRange("Programme Code",ACAProgramme.Code);
                    ACALectureMarksPermissions.SetRange("Stage Code",ACAProgrammeStages.Code);
                    ACALectureMarksPermissions.SetRange("Unit Code",ACAUnitsSubjects.Code);
                    ACALectureMarksPermissions.SetRange("Lecturer Code",LectLoadBatchLines.Lecturer);
                    if ACALectureMarksPermissions.Find('-') then begin
                    ACALectureMarksPermissions."Start Date":=ACASemesters.From;
                    ACALectureMarksPermissions."End Date":=ACASemesters."To";
                    ACALectureMarksPermissions."Current Semester":=ACASemesters."Current Semester";
                    ACALectureMarksPermissions."Academic Year":=ACASemesters."Academic Year";
                    ACALectureMarksPermissions."SMS Results Semester":=ACASemesters."SMS Results Semester";
                    ACALectureMarksPermissions."Lock Exam Editting":=ACASemesters."Lock Exam Editting";
                    ACALectureMarksPermissions."Lock CAT Editting":=ACASemesters."Lock CAT Editting";
                    ACALectureMarksPermissions."Released Results":=ACASemesters."Released Results";
                    ACALectureMarksPermissions."Lock Lecturer Editing":=ACASemesters."Lock Lecturer Editing";
                    ACALectureMarksPermissions."Mark entry Dealine":=ACASemesters."Mark entry Dealine";
                    ACALectureMarksPermissions."Registration Deadline":=ACASemesters."Registration Deadline";
                    ACALectureMarksPermissions."Ignore Editing Rule":=ACASemesters."Ignore Editing Rule";
                    ACALectureMarksPermissions."BackLog Marks":=ACASemesters."BackLog Marks";
                    ACALectureMarksPermissions.AllowDeanEditing:=ACASemesters.AllowDeanEditing;
                    ACALectureMarksPermissions."Marks Changeable":=ACASemesters."Marks Changeable";
                    ACALectureMarksPermissions."Evaluate Lecture":=ACASemesters."Evaluate Lecture";
                    ACALectureMarksPermissions."Special  Entry Deadline":=ACASemesters."Special  Entry Deadline";
                    ACALectureMarksPermissions.Remarks:=ACASemesters.Remarks;
                    ACALectureMarksPermissions.Modify;
                      end;
                          end;
                          until LectLoadBatchLines.Next = 0;
                        end;
                        end;
                        until ACAUnitsSubjects.Next=0;
                      end;
                        end;
                        until ACAProgrammeStages.Next=0;
                      end;
                        end;
                        until ACAProgramme.Next= 0;
                      end;
                      prog.Close;
                    Message('Updated!');
                end;
            }
            action("Stopped Registrations")
            {
                ApplicationArea = Basic;
                Caption = 'Stopped Registrations';
                Image = AddAction;
                Promoted = true;
                RunObject = Page "ACA-Course Reg. Reservour";
                RunPageLink = Semester=field(Code);
            }
            action(UpdateProgStages)
            {
                ApplicationArea = Basic;
                Caption = 'Update Results Buffer Prog.';
                Image = UpdateShipment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ACAResultsBufferProgrammes: Record UnknownRecord78068;
                    ACAResultsBufferProgStage: Record UnknownRecord78069;
                    ACAProgramme: Record UnknownRecord61511;
                    ACAProgrammeStages: Record UnknownRecord61516;
                begin
                    if Confirm('Update programs?',true) = false then Error('Canceled!');
                    Clear(ACAProgramme);
                    ACAProgramme.Reset;
                    if ACAProgramme.Find('-') then begin
                      repeat
                        begin
                        ACAResultsBufferProgrammes.Init;
                        ACAResultsBufferProgrammes."Semester Code":= Rec.Code;
                        ACAResultsBufferProgrammes."Prog. Code" := ACAProgramme.Code;
                        if ACAResultsBufferProgrammes.Insert then;
                          Clear(ACAProgrammeStages);
                          ACAProgrammeStages.Reset;
                          ACAProgrammeStages.SetRange("Programme Code",ACAProgramme.Code);
                          if ACAProgrammeStages.Find('-') then begin
                              repeat
                                begin
                                ACAResultsBufferProgStage.Init;
                                ACAResultsBufferProgStage."Semester Code" := Rec.Code;
                                ACAResultsBufferProgStage."Prog. Code" := ACAProgrammeStages."Programme Code";
                                ACAResultsBufferProgStage."Stage Code" := ACAProgrammeStages.Code;
                                if ACAResultsBufferProgStage.Insert then;
                                end;
                                until ACAProgrammeStages.Next=0;
                            end;
                        end;
                        until ACAProgramme.Next = 0;
                      end;
                      Message('Posted!');
                end;
            }
        }
    }
}

