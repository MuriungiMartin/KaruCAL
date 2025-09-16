#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77172 "Validate Stopage Reasons"
{
    PageType = List;
    SourceTable = UnknownTable69005;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Old Value";"Old Value")
                {
                    ApplicationArea = Basic;
                }
                field("Corect Value";"Corect Value")
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
            action(Updates)
            {
                ApplicationArea = Basic;
                Caption = 'Update';
                Image = AddToHome;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    Clear(ValidateStopageReasons);
                    ValidateStopageReasons.Reset;
                    if ValidateStopageReasons.Find('-') then begin
                      repeat
                        begin
                           Clear(ACAStudentUnits);
                           ACAStudentUnits.Reset;
                           ACAStudentUnits.SetRange("Reason for Special Exam/Susp.",ValidateStopageReasons."Old Value");
                           if ACAStudentUnits.Find('-') then begin
                             repeat
                               begin
                                ACAStudentUnits."Reason for Special Exam/Susp.":=ValidateStopageReasons."Corect Value";
                                ACAStudentUnits.Modify;
                               Clear(AcaSpecialExamsDetails);
                               AcaSpecialExamsDetails.Reset;
                               AcaSpecialExamsDetails.SetRange("Student No.",ACAStudentUnits."Student No.");
                               AcaSpecialExamsDetails.SetRange("Unit Code",ACAStudentUnits.Unit);
                               AcaSpecialExamsDetails.SetRange(Category,AcaSpecialExamsDetails.Category::Special);
                               if AcaSpecialExamsDetails.Find('-') then begin
                                 repeat
                                   begin
                                    AcaSpecialExamsDetails."Special Exam Reason" :=ValidateStopageReasons."Corect Value";
                                    AcaSpecialExamsDetails.Modify(true);
                                   end;
                                   until AcaSpecialExamsDetails.Next = 0;
                                 end;
                               end;
                               until ACAStudentUnits.Next = 0;
                             end;
                        end;
                        until ValidateStopageReasons.Next=0;
                      end else Error('Nothing to Post!');
                end;
            }
        }
    }

    var
        ValidateStopageReasons: Record UnknownRecord69005;
        ACAStudentUnits: Record UnknownRecord61549;
        AcaSpecialExamsDetails: Record UnknownRecord78002;
}

