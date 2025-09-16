#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69010 "HRM-Appraisal Training Develop"
{
    PageType = List;
    SourceTable = UnknownTable61617;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Training Category";"Training Category")
                {
                    ApplicationArea = Basic;
                }
                field(KSAR;KSAR)
                {
                    ApplicationArea = Basic;
                    Caption = 'Knowledge, skills, attitudes required.';
                }
                field(HOW;HOW)
                {
                    ApplicationArea = Basic;
                    Caption = 'How could you achieve this?';
                }
                field(IMPACT;IMPACT)
                {
                    ApplicationArea = Basic;
                    Caption = 'What impact will this make on your work/ research, what will be the evidence this has been achieved?';
                }
                field(COMMENTS;COMMENTS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Manager''s comments & priority:';
                }
            }
        }
    }

    actions
    {
    }
}

