#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 86248 "ACA-BMED Senate Rubrics"
{
    CardPageID = "ACA-BMED Senate Rubric Labels";
    DeleteAllowed = false;
    InsertAllowed = true;
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
                    ExamsProcessing.UpdateGradingSystem(Rec.Code);
                    Message('Grading System Updated');
                end;
            }
        }
    }
}

