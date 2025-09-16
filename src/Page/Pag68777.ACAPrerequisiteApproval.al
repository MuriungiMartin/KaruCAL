#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68777 "ACA-Prerequisite Approval"
{
    PageType = List;
    SourceTable = UnknownTable61547;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Reg. Transaction ID";"Reg. Transaction ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Prerequisite;Prerequisite)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Mandatory;Mandatory)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Approved;Approved)
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

