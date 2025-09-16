#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78028 "Unrecognize Charges"
{
    PageType = List;
    SourceTable = UnknownTable78019;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Resolved;Resolved)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Validate)
            {
                ApplicationArea = Basic;
                Caption = '<Validate charges>';
                Image = PostedMemo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Unrecognize the charges for this students ?',true)=false then Error('Cancelled');
                    Rec.ResolvePost;
                end;
            }
        }
    }
}

