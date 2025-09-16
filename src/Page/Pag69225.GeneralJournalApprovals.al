#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69225 "General Journal Approvals"
{
    PageType = Card;
    SourceTable = UnknownTable69225;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Journal Template";"Journal Template")
                {
                    ApplicationArea = Basic;
                }
                field("Journal Batch";"Journal Batch")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
            action(Journal)
            {
                ApplicationArea = Basic;
                Caption = 'Journal';
                Image = Journals;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('View Document',true)=false then Error('Cancelled by user!');
                end;
            }
        }
    }
}

