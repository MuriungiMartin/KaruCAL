#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1135 "Cost Journal Batches"
{
    Caption = 'Cost Journal Batches';
    PageType = List;
    SourceTable = "Cost Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Cost Type No.";"Bal. Cost Type No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Cost Center Code";"Bal. Cost Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bal. Cost Object Code";"Bal. Cost Object Code")
                {
                    ApplicationArea = Basic;
                }
                field("Delete after Posting";"Delete after Posting")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    CostJnlMgt.TemplateSelectionFromBatch(Rec);
                end;
            }
            action("P&ost")
            {
                ApplicationArea = Basic;
                Caption = 'P&ost';
                Image = PostOrder;
                RunObject = Codeunit "CA Jnl.-B. Post";
                ShortCutKey = 'F9';
            }
        }
    }

    trigger OnInit()
    begin
        SetRange("Journal Template Name");
    end;

    trigger OnOpenPage()
    begin
        CostJnlMgt.OpenJnlBatch(Rec);
    end;

    var
        CostJnlMgt: Codeunit CostJnlManagement;
}

