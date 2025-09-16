#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68921 "HRM-Advertised Job Card"
{
    PageType = Card;
    SourceTable = UnknownTable61200;
    SourceTableView = where(Advertised=filter(Yes));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition No.";"Requisition No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Reference Code";"Reference Code")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                }
                field(Positions;Positions)
                {
                    ApplicationArea = Basic;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Date";"Closing Date")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Type";"Requisition Type")
                {
                    ApplicationArea = Basic;
                }
                field("Required Positions";"Required Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Vacant Positions";"Vacant Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Job Grade";"Job Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Type of Contract Required";"Type of Contract Required")
                {
                    ApplicationArea = Basic;
                }
                field("Reason For Request";"Reason For Request")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Job Ref No";"Job Ref No")
                {
                    ApplicationArea = Basic;
                }
                field(Advertised;Advertised)
                {
                    ApplicationArea = Basic;
                }
                field("Opening Date";"Opening Date")
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

