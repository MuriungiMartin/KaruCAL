#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68977 "PRL-Bank Structure"
{
    Caption = 'Banks';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = UnknownTable61077;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Code";"Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field("Branch Name";"Branch Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

