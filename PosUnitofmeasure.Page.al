#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99403 "Pos Unit of measure"
{
    PageType = List;
    SourceTable = UnknownTable99402;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Code";"Item Code")
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
                field("Student Price";"Student Price")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Price";"Staff Price")
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

