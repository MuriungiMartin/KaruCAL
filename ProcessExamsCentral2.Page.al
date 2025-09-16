#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77799 "Process Exams Central2"
{
    PageType = Card;
    SourceTable = UnknownTable61511;
    SourceTableView = where(Code=filter(A100));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(progy;programs)
                {
                    ApplicationArea = Basic;
                    Caption = 'Programme';
                    TableRelation = "ACA-Programme".Code;
                }
                field(semz;Semesters)
                {
                    ApplicationArea = Basic;
                    Caption = 'Semester';
                    TableRelation = "ACA-Semesters".Code;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(PostMarks)
            {
                ApplicationArea = Basic;
                Caption = 'Generate Marks';
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Semesters='' then Error('Specify a Semester Filter');
                     if Confirm('Process Buffered marks?',true)=false then Error('Cancelled by user!');
                    if ((programs<>'') or (Semesters<>'') or (AcadYear<>'')
                      or (Stages<>'') or (StudNos<>'')) then begin
                        ACAExamResultsBuffer2.Reset;
                        ACACourseRegistration.Reset;
                        ACAExamResults.Reset;
                      if programs<>'' then begin
                        ACAExamResultsBuffer2.SetRange(Programme,programs);
                        ACACourseRegistration.SetRange(Programme,programs);
                        ACAExamResults.SetRange(Programme,programs);
                        end;
                      if Semesters<>'' then begin
                        ACAExamResultsBuffer2.SetRange(Semester,Semesters);
                        ACACourseRegistration.SetRange(Semester,Semesters);
                        ACAExamResults.SetRange(Semester,Semesters);
                        end;
                      if AcadYear<>'' then begin
                        ACAExamResultsBuffer2.SetRange("Academic Year",AcadYear);
                        ACACourseRegistration.SetRange("Academic Year",AcadYear);
                        ACAExamResults.SetRange("Academic Year",AcadYear);
                        end;
                      if Stages<>'' then begin
                        ACAExamResultsBuffer2.SetRange(Stage,Stages);
                        ACACourseRegistration.SetRange(Stage,Stages);
                        ACAExamResults.SetRange(Stage,Stages);
                        end;
                      if StudNos<>'' then begin
                        ACAExamResultsBuffer2.SetRange("Student No.",StudNos);
                        ACACourseRegistration.SetRange("Student No.",StudNos);
                        ACAExamResults.SetRange("Student No.",StudNos);
                        end;

                        if ACAExamResultsBuffer2.Find('-') then begin
                          end;
                        if ACACourseRegistration.Find('-') then begin
                          end;
                        if ACAExamResults.Find('-') then begin
                          end;

                      Report.Run(51148,false,false,ACAExamResultsBuffer2);
                      Report.Run(51149,false,false,ACAExamResults);
                      Report.Run(51094,false,false,ACACourseRegistration);
                      Report.Run(77701,false,false,ACACourseRegistration);

                      end else begin
                      Report.Run(51148,false,false);
                      Report.Run(51149,false,false);
                      Report.Run(51094,false,false);
                      Report.Run(77701,false,false);
                      end;

                    Message('Records Processed succeesfully.');
                end;
            }
        }
    }

    var
        programs: Code[150];
        AcadYear: Code[150];
        Semesters: Code[150];
        Stages: Code[150];
        StudNos: Code[150];
        ACAExamResultsBuffer2: Record UnknownRecord61746;
        ACACourseRegistration: Record UnknownRecord61532;
        ACAExamResults: Record UnknownRecord61548;
}

