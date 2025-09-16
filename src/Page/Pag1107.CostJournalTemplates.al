#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1107 "Cost Journal Templates"
{
    ApplicationArea = Basic;
    Caption = 'Cost Journal Templates';
    PageType = List;
    SourceTable = "Cost Journal Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control4)
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
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Te&mplates")
            {
                Caption = 'Te&mplates';
                Image = Template;
                action(Batches)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batches';
                    Image = Description;
                    Promoted = false;
                    RunObject = Page "Cost Journal Batches";
                    RunPageLink = "Journal Template Name"=field(Name);
                }
            }
        }
    }
}

