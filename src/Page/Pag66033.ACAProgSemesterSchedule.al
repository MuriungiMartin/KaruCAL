#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 66033 "ACA-Prog. Semester Schedule"
{
    PageType = List;
    SourceTable = UnknownTable66033;

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
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Name";"Programme Name")
                {
                    ApplicationArea = Basic;
                }
                field("Scheduled Program Stages";"Scheduled Program Stages")
                {
                    ApplicationArea = Basic;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
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
                field("Released Results";"Released Results")
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
                }
                field("Registration Deadline";"Registration Deadline")
                {
                    ApplicationArea = Basic;
                }
                field("Ignore Editing Rule";"Ignore Editing Rule")
                {
                    ApplicationArea = Basic;
                }
                field("BackLog Marks";"BackLog Marks")
                {
                    ApplicationArea = Basic;
                }
                field(AllowDeanEditing;AllowDeanEditing)
                {
                    ApplicationArea = Basic;
                }
                field("Marks Changeable";"Marks Changeable")
                {
                    ApplicationArea = Basic;
                }
                field("Evaluate Lecture";"Evaluate Lecture")
                {
                    ApplicationArea = Basic;
                }
                field("Special  Entry Deadline";"Special  Entry Deadline")
                {
                    ApplicationArea = Basic;
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
        area(creation)
        {
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
                    if Rec."Programme Code" = '' then Error('No Program Specified');
                    if Confirm('Update Prog. Schedules?',false)=false then Error('Cancelled!');

                    // CLEAR(CountedProgs);
                    // CLEAR(RemainingProgs);
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
                    // ACAProgSemesterSchedule.RESET;
                    // ACAProgSemesterSchedule.SETRANGE(Code,Rec.Code);
                    // IF ACAProgSemesterSchedule.FIND('-') THEN ACAProgSemesterSchedule.DELETEALL;
                    ACAProgStageSemSchedule.Reset;
                    ACAProgStageSemSchedule.SetRange(Code,Rec.Code);
                    ACAProgStageSemSchedule.SetRange("Programme Code",Rec."Programme Code");
                    if ACAProgStageSemSchedule.Find('-') then ACAProgStageSemSchedule.DeleteAll;
                    ACAProgStageUnitSemSche.Reset;
                    ACAProgStageUnitSemSche.SetRange(Code,Rec.Code);
                    ACAProgStageUnitSemSche.SetRange("Programme Code",Rec."Programme Code");
                    if ACAProgStageUnitSemSche.Find('-') then ACAProgStageUnitSemSche.DeleteAll;
                    ACALectureMarksPermissions.Reset;
                    ACALectureMarksPermissions.SetRange(Code,Rec.Code);
                    ACALectureMarksPermissions.SetRange("Programme Code",Rec."Programme Code");
                    if ACALectureMarksPermissions.Find('-') then ACALectureMarksPermissions.DeleteAll;
                    ACAProgramme.Reset;
                    ACAProgramme.SetRange(Code,Rec."Programme Code");
                    if ACAProgramme.Find('-') then begin
                      CountedProgs:=ACAProgramme.Count;
                      RemainingProgs:=ACAProgramme.Count;
                    prog.Update(1,'Programs: '+Format(CountedProgs));
                      repeat
                        begin
                    prog.Update(2,'Remaining Programs: '+Format(RemainingProgs));
                    RemainingProgs:=RemainingProgs-1;
                        // Update Program Schedule here
                    //    ACAProgSemesterSchedule.INIT;
                    //    ACAProgSemesterSchedule.Code:=Rec.Code;
                    //    ACAProgSemesterSchedule."Programme Code":=ACAProgramme.Code;
                    //    IF ACAProgSemesterSchedule.INSERT THEN;
                    //
                    // ACAProgSemesterSchedule.RESET;
                    // ACAProgSemesterSchedule.SETRANGE(Code,Rec.Code);
                    // ACAProgSemesterSchedule.SETRANGE("Programme Code",ACAProgramme.Code);
                    // IF ACAProgSemesterSchedule.FIND('-') THEN BEGIN
                    // ACAProgSemesterSchedule."Start Date":=Rec.From;
                    // ACAProgSemesterSchedule."End Date":=Rec."To";
                    // ACAProgSemesterSchedule."Current Semester":=Rec."Current Semester";
                    // ACAProgSemesterSchedule."Academic Year":=Rec."Academic Year";
                    // ACAProgSemesterSchedule."SMS Results Semester":=Rec."SMS Results Semester";
                    // ACAProgSemesterSchedule."Lock Exam Editting":=Rec."Lock Exam Editting";
                    // ACAProgSemesterSchedule."Lock CAT Editting":=Rec."Lock CAT Editting";
                    // ACAProgSemesterSchedule."Released Results":=Rec."Released Results";
                    // ACAProgSemesterSchedule."Lock Lecturer Editing":=Rec."Lock Lecturer Editing";
                    // ACAProgSemesterSchedule."Mark entry Dealine":=Rec."Mark entry Dealine";
                    // ACAProgSemesterSchedule."Registration Deadline":=Rec."Registration Deadline";
                    // ACAProgSemesterSchedule."Ignore Editing Rule":=Rec."Ignore Editing Rule";
                    // ACAProgSemesterSchedule."BackLog Marks":=Rec."BackLog Marks";
                    // ACAProgSemesterSchedule.AllowDeanEditing:=Rec.AllowDeanEditing;
                    // ACAProgSemesterSchedule."Marks Changeable":=Rec."Marks Changeable";
                    // ACAProgSemesterSchedule."Evaluate Lecture":=Rec."Evaluate Lecture";
                    // ACAProgSemesterSchedule."Special  Entry Deadline":=Rec."Special  Entry Deadline";
                    // ACAProgSemesterSchedule.Remarks:=Rec.Remarks;
                    // ACAProgSemesterSchedule.MODIFY;
                    //  END;
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
                        ACAProgStageSemSchedule.Code:=Rec.Code;
                        ACAProgStageSemSchedule."Programme Code":=ACAProgramme.Code;
                        ACAProgStageSemSchedule."Stage Code":=ACAProgrammeStages.Code;
                        if ACAProgStageSemSchedule.Insert then;

                    ACAProgStageSemSchedule.Reset;
                    ACAProgStageSemSchedule.SetRange(Code,Rec.Code);
                    ACAProgStageSemSchedule.SetRange("Programme Code",ACAProgramme.Code);
                    ACAProgStageSemSchedule.SetRange("Stage Code",ACAProgrammeStages.Code);
                    if ACAProgStageSemSchedule.Find('-') then begin
                    ACAProgStageSemSchedule."Start Date":=Rec."Start Date";
                    ACAProgStageSemSchedule."End Date":=Rec."End Date";
                    ACAProgStageSemSchedule."Current Semester":=Rec."Current Semester";
                    ACAProgStageSemSchedule."Academic Year":=Rec."Academic Year";
                    ACAProgStageSemSchedule."SMS Results Semester":=Rec."SMS Results Semester";
                    ACAProgStageSemSchedule."Lock Exam Editting":=Rec."Lock Exam Editting";
                    ACAProgStageSemSchedule."Lock CAT Editting":=Rec."Lock CAT Editting";
                    ACAProgStageSemSchedule."Released Results":=Rec."Released Results";
                    ACAProgStageSemSchedule."Lock Lecturer Editing":=Rec."Lock Lecturer Editing";
                    ACAProgStageSemSchedule."Mark entry Dealine":=Rec."Mark entry Dealine";
                    ACAProgStageSemSchedule."Registration Deadline":=Rec."Registration Deadline";
                    ACAProgStageSemSchedule."Ignore Editing Rule":=Rec."Ignore Editing Rule";
                    ACAProgStageSemSchedule."BackLog Marks":=Rec."BackLog Marks";
                    ACAProgStageSemSchedule.AllowDeanEditing:=Rec.AllowDeanEditing;
                    ACAProgStageSemSchedule."Marks Changeable":=Rec."Marks Changeable";
                    ACAProgStageSemSchedule."Evaluate Lecture":=Rec."Evaluate Lecture";
                    ACAProgStageSemSchedule."Special  Entry Deadline":=Rec."Special  Entry Deadline";
                    ACAProgStageSemSchedule.Remarks:=Rec.Remarks;
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
                        ACAProgStageUnitSemSche.Code:=Rec.Code;
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
                    ACAProgStageUnitSemSche."Start Date":=Rec."Start Date";
                    ACAProgStageUnitSemSche."End Date":=Rec."End Date";
                    ACAProgStageUnitSemSche."Current Semester":=Rec."Current Semester";
                    ACAProgStageUnitSemSche."Academic Year":=Rec."Academic Year";
                    ACAProgStageUnitSemSche."SMS Results Semester":=Rec."SMS Results Semester";
                    ACAProgStageUnitSemSche."Lock Exam Editting":=Rec."Lock Exam Editting";
                    ACAProgStageUnitSemSche."Lock CAT Editting":=Rec."Lock CAT Editting";
                    ACAProgStageUnitSemSche."Released Results":=Rec."Released Results";
                    ACAProgStageUnitSemSche."Lock Lecturer Editing":=Rec."Lock Lecturer Editing";
                    ACAProgStageUnitSemSche."Mark entry Dealine":=Rec."Mark entry Dealine";
                    ACAProgStageUnitSemSche."Registration Deadline":=Rec."Registration Deadline";
                    ACAProgStageUnitSemSche."Ignore Editing Rule":=Rec."Ignore Editing Rule";
                    ACAProgStageUnitSemSche."BackLog Marks":=Rec."BackLog Marks";
                    ACAProgStageUnitSemSche.AllowDeanEditing:=Rec.AllowDeanEditing;
                    ACAProgStageUnitSemSche."Marks Changeable":=Rec."Marks Changeable";
                    ACAProgStageUnitSemSche."Evaluate Lecture":=Rec."Evaluate Lecture";
                    ACAProgStageUnitSemSche."Special  Entry Deadline":=Rec."Special  Entry Deadline";
                    ACAProgStageUnitSemSche.Remarks:=Rec.Remarks;
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
                        ACALectureMarksPermissions.Code:=Rec.Code;
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
                    ACALectureMarksPermissions."Start Date":=Rec."Start Date";
                    ACALectureMarksPermissions."End Date":=Rec."End Date";
                    ACALectureMarksPermissions."Current Semester":=Rec."Current Semester";
                    ACALectureMarksPermissions."Academic Year":=Rec."Academic Year";
                    ACALectureMarksPermissions."SMS Results Semester":=Rec."SMS Results Semester";
                    ACALectureMarksPermissions."Lock Exam Editting":=Rec."Lock Exam Editting";
                    ACALectureMarksPermissions."Lock CAT Editting":=Rec."Lock CAT Editting";
                    ACALectureMarksPermissions."Released Results":=Rec."Released Results";
                    ACALectureMarksPermissions."Lock Lecturer Editing":=Rec."Lock Lecturer Editing";
                    ACALectureMarksPermissions."Mark entry Dealine":=Rec."Mark entry Dealine";
                    ACALectureMarksPermissions."Registration Deadline":=Rec."Registration Deadline";
                    ACALectureMarksPermissions."Ignore Editing Rule":=Rec."Ignore Editing Rule";
                    ACALectureMarksPermissions."BackLog Marks":=Rec."BackLog Marks";
                    ACALectureMarksPermissions.AllowDeanEditing:=Rec.AllowDeanEditing;
                    ACALectureMarksPermissions."Marks Changeable":=Rec."Marks Changeable";
                    ACALectureMarksPermissions."Evaluate Lecture":=Rec."Evaluate Lecture";
                    ACALectureMarksPermissions."Special  Entry Deadline":=Rec."Special  Entry Deadline";
                    ACALectureMarksPermissions.Remarks:=Rec.Remarks;
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
        }
    }
}

