#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68339 "HRM-Job Resp. Lines"
{
    CardPageID = "HRM-Job Responsibilities";
    PageType = List;
    SourceTable = UnknownTable61192;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Responsibility Code";"Responsibility Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Responsibility Description";"Responsibility Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ExtendedDatatype = URL;
                }
            }
        }
    }

    actions
    {
    }
}

