#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60009 "ELECT-Polling Booths List"
{
    PageType = List;
    SourceTable = UnknownTable60009;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Booth Code";"Booth Code")
                {
                    ApplicationArea = Basic;
                }
                field("Login Acc. Name";"Login Acc. Name")
                {
                    ApplicationArea = Basic;
                }
                field("Login Password";"Login Password")
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

