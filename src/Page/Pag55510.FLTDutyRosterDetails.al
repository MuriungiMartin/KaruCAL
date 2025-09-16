#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55510 "FLT-Duty Roster Details"
{
    PageType = List;
    SourceTable = UnknownTable55506;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Names";"Employee Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(Monday;Monday)
                {
                    ApplicationArea = Basic;
                }
                field(Tuesday;Tuesday)
                {
                    ApplicationArea = Basic;
                }
                field(Wednesday;Wednesday)
                {
                    ApplicationArea = Basic;
                }
                field(Thursday;Thursday)
                {
                    ApplicationArea = Basic;
                }
                field(Friday;Friday)
                {
                    ApplicationArea = Basic;
                }
                field(Saturday;Saturday)
                {
                    ApplicationArea = Basic;
                }
                field(Sunday;Sunday)
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

