#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70073 "Proc-Prequalification Years"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable60220;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Preq. Year";"Preq. Year")
                {
                    ApplicationArea = Basic;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Preq. Categories";"Preq. Categories")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Preq. Dates List";"Preq. Dates List")
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

