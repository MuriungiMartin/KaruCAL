#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68662 "SWF-Society List"
{
    PageType = ListPart;
    SourceTable = UnknownTable61448;
    SourceTableView = where(Type=const(Society));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Code";Code)
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

