#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78018 "ACA-Prog. Defined Units/YoS"
{
    PageType = List;
    SourceTable = UnknownTable78017;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Year of Study";"Year of Study")
                {
                    ApplicationArea = Basic;
                }
                field("Number of Units";"Number of Units")
                {
                    ApplicationArea = Basic;
                }
                field(Options;Options)
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

