#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68410 "HRM-Document Link"
{
    PageType = Card;
    SourceTable = UnknownTable61310;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Document Description";"Document Description")
                {
                    ApplicationArea = Basic;
                }
                field(Attachement;Attachement)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }


    procedure GetDocument() Document: Text[200]
    begin
        Document:="Document Description";
    end;
}

