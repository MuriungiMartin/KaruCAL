#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 80003 "Student Card RFIDS"
{
    PageType = List;
    SourceTable = UnknownTable80002;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RFID TAG";"RFID TAG")
                {
                    ApplicationArea = Basic;
                }
                field("Entry Date";"Entry Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
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

