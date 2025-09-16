#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69116 "FLT-Driver List"
{
    CardPageID = "FLT-Driver Card";
    PageType = List;
    SourceTable = UnknownTable61798;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Driver;Driver)
                {
                    ApplicationArea = Basic;
                }
                field("Driver Name";"Driver Name")
                {
                    ApplicationArea = Basic;
                }
                field("Driver License Number";"Driver License Number")
                {
                    ApplicationArea = Basic;
                }
                field("Last License Renewal";"Last License Renewal")
                {
                    ApplicationArea = Basic;
                }
                field("Renewal Interval";"Renewal Interval")
                {
                    ApplicationArea = Basic;
                }
                field("Renewal Interval Value";"Renewal Interval Value")
                {
                    ApplicationArea = Basic;
                }
                field("Next License Renewal";"Next License Renewal")
                {
                    ApplicationArea = Basic;
                }
                field("Year Of Experience";"Year Of Experience")
                {
                    ApplicationArea = Basic;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                }
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Fuel Analysis")
            {
                ApplicationArea = Basic;
                Image = Agreement;

                trigger OnAction()
                begin
                    Report.Run(51869,true);
                end;
            }
        }
    }
}

