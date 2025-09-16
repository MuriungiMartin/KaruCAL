#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69263 "HR Asset Transfer List"
{
    CardPageID = "Hr Asset  Transfer Header";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable69261;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Transfered;Transfered)
                {
                    ApplicationArea = Basic;
                }
                field("Date Transfered";"Date Transfered")
                {
                    ApplicationArea = Basic;
                }
                field("Transfered By";"Transfered By")
                {
                    ApplicationArea = Basic;
                }
                field("Time Posted";"Time Posted")
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

