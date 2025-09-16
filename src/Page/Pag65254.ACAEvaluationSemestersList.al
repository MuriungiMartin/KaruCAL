#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65254 "ACA-Evaluation Semesters List"
{
    ApplicationArea = Basic;
    CardPageID = "ACA-Evaluation Semesters Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61692;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Current Semester";"Current Semester")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Rep)
            {
                ApplicationArea = Basic;
                Caption = 'Evaluation Report';
                Image = Statistics1099;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ACALecturersEvaluation.Reset;
                    ACALecturersEvaluation.SetRange(Semester,Rec.Code);
                    if ACALecturersEvaluation.Find('-') then begin
                      Report.Run(65251,true,false,ACALecturersEvaluation);
                      end;
                end;
            }
            action(EvSumm)
            {
                ApplicationArea = Basic;
                Caption = 'Evaluation Summary';
                Image = Aging;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ACALecturersEvaluation.Reset;
                    ACALecturersEvaluation.SetRange(Semester,Rec.Code);
                    if ACALecturersEvaluation.Find('-') then begin
                      Report.Run(65252,true,false,ACALecturersEvaluation);
                      end;
                end;
            }
        }
    }

    var
        ACALecturersEvaluation: Record UnknownRecord61036;
}

