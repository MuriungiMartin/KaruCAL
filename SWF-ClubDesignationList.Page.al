#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68665 "SWF-Club Designation List"
{
    PageType = ListPart;
    SourceTable = UnknownTable61449;
    SourceTableView = where(Type=const(Club));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Single Position";"Single Position")
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

