#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 62261 "ACA-Bulk Unit Reg. Hist"
{
    PageType = ListPart;
    SourceTable = "ACA-Bulk Units Reg. Det";
    SourceTableView = where(Registered=filter(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field(Registered;Registered)
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

