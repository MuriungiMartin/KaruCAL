#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68928 "HRM-Email Parameters List"
{
    CardPageID = "HRM- EMail Parameters";
    PageType = List;
    SourceTable = UnknownTable61656;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Associate With";"Associate With")
                {
                    ApplicationArea = Basic;
                }
                field("Sender Name";"Sender Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sender Address";"Sender Address")
                {
                    ApplicationArea = Basic;
                }
                field(Recipients;Recipients)
                {
                    ApplicationArea = Basic;
                }
                field(Subject;Subject)
                {
                    ApplicationArea = Basic;
                }
                field(Body;Body)
                {
                    ApplicationArea = Basic;
                }
                field("Body 2";"Body 2")
                {
                    ApplicationArea = Basic;
                }
                field(HTMLFormatted;HTMLFormatted)
                {
                    ApplicationArea = Basic;
                }
                field("Body 3";"Body 3")
                {
                    ApplicationArea = Basic;
                }
                field("Body 4";"Body 4")
                {
                    ApplicationArea = Basic;
                }
                field("Body 5";"Body 5")
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

