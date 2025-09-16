#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70703 "SMS Programme Units"
{
    PageType = List;
    SourceTable = UnknownTable70705;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Stage Code";"Stage Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Unit Code";"Unit Code")
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

