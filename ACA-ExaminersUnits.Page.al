#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69032 "ACA-Examiners Units"
{
    PageType = ListPart;
    SourceTable = UnknownTable61611;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Campus code";"Campus code")
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
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

