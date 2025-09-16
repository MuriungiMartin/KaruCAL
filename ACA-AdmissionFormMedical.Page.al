#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68500 "ACA-Admission Form Medical"
{
    PageType = ListPart;
    SourceTable = UnknownTable61376;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Medical Condition Code";"Medical Condition Code")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Condition Name";"Medical Condition Name")
                {
                    ApplicationArea = Basic;
                }
                field(Yes;Yes)
                {
                    ApplicationArea = Basic;
                }
                field("Date From";"Date From")
                {
                    ApplicationArea = Basic;
                }
                field("Date To";"Date To")
                {
                    ApplicationArea = Basic;
                }
                field(Details;Details)
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

