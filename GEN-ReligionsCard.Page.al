#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68846 "GEN-Religions Card"
{
    PageType = Card;
    SourceTable = UnknownTable61658;
    SourceTableView = where(Category=filter(Religions));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Title Code";"Title Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
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

