#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77392 "Pesaflow_Service-Ids"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Pesa-Flow_Service-IDs";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Service_ID;Service_ID)
                {
                    ApplicationArea = Basic;
                }
                field("Service ID Description";"Service ID Description")
                {
                    ApplicationArea = Basic;
                }
                field(Bank_Id;Bank_Id)
                {
                    ApplicationArea = Basic;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }
}

