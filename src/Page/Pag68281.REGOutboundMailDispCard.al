#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68281 "REG-Outbound Mail (Disp.) Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61635;
    SourceTableView = where("Direction Type"=filter("Outgoing Mail (Internal)"|"Outgoing Mail (External)"),
                            "Mail Status"=filter(Dispatch));

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
                field(Addressee;Addressee)
                {
                    ApplicationArea = Basic;
                }
                field("mail Time";"mail Time")
                {
                    ApplicationArea = Basic;
                }
                field(Receiver;Receiver)
                {
                    ApplicationArea = Basic;
                }
                field("Addresee Type";"Addresee Type")
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
                field(Dispatched;Dispatched)
                {
                    ApplicationArea = Basic;
                }
                field("Dispatched by";"Dispatched by")
                {
                    ApplicationArea = Basic;
                }
                field("stamp cost";"stamp cost")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field("Doc Ref No.";"Doc Ref No.")
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
            systempart(Control25;Notes)
            {
            }
            systempart(Control26;MyNotes)
            {
            }
            systempart(Control27;Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Release)
            {
                ApplicationArea = Basic;
                Caption = 'Release Mail';
                Image = ClearLog;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    if (Confirm('Mark mail as Released?',true)=true) then begin
                      "Mail Status":="mail status"::Dispatched;
                      Modify;
                    end;
                    Message('Successfully Released.');
                end;
            }
        }
    }
}

