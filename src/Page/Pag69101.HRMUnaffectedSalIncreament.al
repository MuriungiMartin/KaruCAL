#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69101 "HRM-Unaffected Sal. Increament"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61792;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Increament Month";"Increament Month")
                {
                    ApplicationArea = Basic;
                }
                field("Increament Year";"Increament Year")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Category";"Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Grade";"Employee Grade")
                {
                    ApplicationArea = Basic;
                }
                field(Reason;Reason)
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

