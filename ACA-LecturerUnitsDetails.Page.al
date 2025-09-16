#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68849 "ACA-Lecturer Units Details"
{
    PageType = List;
    SourceTable = UnknownTable65202;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Hours";"No. Of Hours")
                {
                    ApplicationArea = Basic;
                }
                field("No. Of Hours Contracted";"No. Of Hours Contracted")
                {
                    ApplicationArea = Basic;
                }
                field("Available From";"Available From")
                {
                    ApplicationArea = Basic;
                }
                field("Available To";"Available To")
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

