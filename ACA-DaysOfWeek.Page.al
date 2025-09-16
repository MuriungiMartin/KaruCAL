#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68740 "ACA-Days Of Week"
{
    PageType = CardPart;
    SourceTable = UnknownTable61514;
    SourceTableView = where(Exams=const(No));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Day;Day)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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

