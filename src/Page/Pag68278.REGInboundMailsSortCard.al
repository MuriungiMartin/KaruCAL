#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68278 "REG-Inbound Mails (Sort.) Card"
{
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable61635;
    SourceTableView = where("Direction Type"=filter("Incoming Mail (Internal)"|"Incoming Mail (External)"),
                            "Mail Status"=filter());

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Subject of Doc.";"Subject of Doc.")
                {
                    ApplicationArea = Basic;
                }
                field("Mail Date";"Mail Date")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Doc type";"Doc type")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque Amount";"Cheque Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Direction Type";"Direction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Received;Received)
                {
                    ApplicationArea = Basic;
                }
                field("Doc Ref No.";"Doc Ref No.")
                {
                    ApplicationArea = Basic;
                }
                field("File Tab";"File Tab")
                {
                    ApplicationArea = Basic;
                }
                field("Person Recording";"Person Recording")
                {
                    ApplicationArea = Basic;
                }
                field("Delivered By (Mail)";"Delivered By (Mail)")
                {
                    ApplicationArea = Basic;
                }
                field("Delivered By (Phone)";"Delivered By (Phone)")
                {
                    ApplicationArea = Basic;
                }
                field("Delivered By (Name)";"Delivered By (Name)")
                {
                    ApplicationArea = Basic;
                }
                field("Delivered By (ID)";"Delivered By (ID)")
                {
                    ApplicationArea = Basic;
                }
                field("Delivered By (Town)";"Delivered By (Town)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control15;Notes)
            {
            }
            systempart(Control16;MyNotes)
            {
            }
            systempart(Control17;Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Sort)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Sorted Mail';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    if (Confirm('Mark mail as Sorted?',true)=true) then begin
                      "Mail Status":="mail status"::Sorted;
                      Modify;
                    end;
                    Message('Successfully Sorted.');
                end;
            }
        }
    }
}

