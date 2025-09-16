#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6070 "Serv. Contract Account Groups"
{
    ApplicationArea = Basic;
    Caption = 'Serv. Contract Account Groups';
    PageType = List;
    SourceTable = "Service Contract Account Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code assigned to the service contract account group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service contract account group.';
                }
                field("Non-Prepaid Contract Acc.";"Non-Prepaid Contract Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger account number for the non-prepaid account.';
                }
                field("Prepaid Contract Acc.";"Prepaid Contract Acc.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general ledger account number for the prepaid account.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

