#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68700 "ELECT Election List"
{
    PageType = ListPart;
    SourceTable = UnknownTable61460;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Year;Year)
                {
                    ApplicationArea = Basic;
                }
                field("Date From";"Date From")
                {
                    ApplicationArea = Basic;
                }
                field("Time From";"Time From")
                {
                    ApplicationArea = Basic;
                }
                field("Date To";"Date To")
                {
                    ApplicationArea = Basic;
                }
                field("Time To";"Time To")
                {
                    ApplicationArea = Basic;
                }
                field("Open Election";"Open Election")
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

