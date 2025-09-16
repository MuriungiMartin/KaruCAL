#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68244 "ACA-Senate Report Lubrics"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61382;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Visible = true;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Allow View of Transcripts";"Allow View of Transcripts")
                {
                    ApplicationArea = Basic;
                }
                field("Exam Category";"Exam Category")
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
            action("Update Grading System")
            {
                ApplicationArea = Basic;
                Caption = 'Update Grades';
                Image = ExportShipment;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExamsProcessing: Codeunit "Exams Processing";
                begin
                    // // ACAAcademicYear.RESET;
                    // // IF ACAAcademicYear.FIND('-') THEN BEGIN
                    // //  REPEAT
                    // //    BEGIN
                    if Rec."Exam Category" <> '' then begin
                      if Confirm('Update for '+Rec."Exam Category"+' Only?',true)= true then begin
                    ExamsProcessing.UpdateGradingSystem(Rec.Code,Rec."Exam Category");
                        end else begin
                    ExamsProcessing.UpdateGradingSystem(Rec.Code,'');
                          end;
                      end else begin
                    ExamsProcessing.UpdateGradingSystem(Rec.Code,'');
                        end;
                    // // END;
                    // // UNTIL ACAAcademicYear.NEXT=0;
                    // // END;

                    Message('Grading System Updated');
                end;
            }
            action(GenRubrics)
            {
                ApplicationArea = Basic;
                Caption = 'General Rubrics';
                Image = SuggestBin;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ACAResultsStatus);
                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange("Academic Year",Rec.Code);
                    if ACAResultsStatus.Find('-') then;
                    Page.Run(86244,ACAResultsStatus);
                end;
            }
            action(SuppSpecialRubrics)
            {
                ApplicationArea = Basic;
                Caption = 'Supp/Special Rubrics';
                Image = ExportElectronicDocument;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ACASuppResultsStatus);
                    ACASuppResultsStatus.Reset;
                    ACASuppResultsStatus.SetRange("Academic Year",Rec.Code);
                    if ACASuppResultsStatus.Find('-') then;
                    Page.Run(78015,ACASuppResultsStatus);
                end;
            }
            action("2ndSuppRubrics")
            {
                ApplicationArea = Basic;
                Caption = '2nd Supp Rubrics';
                Image = DepreciationBooks;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ACA2ndSuppResultsStatus);
                    ACA2ndSuppResultsStatus.Reset;
                    ACA2ndSuppResultsStatus.SetRange("Academic Year",Rec.Code);
                    if ACA2ndSuppResultsStatus.Find('-') then;
                    Page.Run(78036,ACA2ndSuppResultsStatus);
                end;
            }
            action(MediNursingRubrics)
            {
                ApplicationArea = Basic;
                Caption = 'Medical/Nursing Rubrics';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ACAResultsStatus);
                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange("Academic Year",Rec.Code);
                    if ACAResultsStatus.Find('-') then;
                    Page.Run(86247,ACAResultsStatus);
                end;
            }
            action(MediNursingSuppSpecialRubrics)
            {
                ApplicationArea = Basic;
                Caption = 'Nursing Supp/Special Rubrics';
                Image = GetStandardJournal;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ACASuppResultsStatus);
                    ACASuppResultsStatus.Reset;
                    ACASuppResultsStatus.SetRange("Academic Year",Rec.Code);
                    ACASuppResultsStatus.SetRange("Special Programme Class",ACASuppResultsStatus."special programme class"::"Medicine & Nursing");
                    if ACASuppResultsStatus.Find('-') then;
                    Page.Run(78026,ACASuppResultsStatus);
                end;
            }
            action(MediNursing2ndSuppRubrics)
            {
                ApplicationArea = Basic;
                Caption = 'Nursing 2nd Supp Rubrics';
                Image = DistributionGroup;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Clear(ACA2ndSuppResultsStatus);
                    ACA2ndSuppResultsStatus.Reset;
                    ACA2ndSuppResultsStatus.SetRange("Academic Year",Rec.Code);
                    ACA2ndSuppResultsStatus.SetRange("Special Programme Class",ACA2ndSuppResultsStatus."special programme class"::"Medicine & Nursing");
                    if ACA2ndSuppResultsStatus.Find('-') then;
                    Page.Run(78027,ACA2ndSuppResultsStatus);
                end;
            }
        }
    }

    var
        ACAAcademicYear: Record UnknownRecord61382;
        ACASuppResultsStatus: Record UnknownRecord69266;
        ACAResultsStatus: Record UnknownRecord61739;
        ACA2ndSuppResultsStatus: Record UnknownRecord69267;
}

