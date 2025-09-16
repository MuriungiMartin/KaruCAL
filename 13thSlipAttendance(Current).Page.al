#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99094 "13thSlip Attendance (Current)"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable99210;
    SourceTableView = where("Checked Out"=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
            }
        }
    }

    actions
    {
    }
}

