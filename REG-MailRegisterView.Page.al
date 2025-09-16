#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68857 "REG-Mail Register View"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61635;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Folio Number";"Folio Number")
                {
                    ApplicationArea = Basic;
                }
                field(Received;Received)
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
                field("File Tab";"File Tab")
                {
                    ApplicationArea = Basic;
                }
                field("Folio No";"Folio No")
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
                field("Mail Status";"Mail Status")
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
            action(Disp)
            {
                ApplicationArea = Basic;
                Caption = 'Dispatch';
                Image = ReleaseShipment;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TestField("Subject of Doc.");
                    TestField("Mail Date");
                    TestField(Addressee);
                    TestField("mail Time");
                    TestField(Receiver);
                    TestField(Comments);
                    TestField("Delivered By (Mail)");
                    TestField("Delivered By (Phone)");
                    TestField("Delivered By (Name)");
                    TestField("Delivered By (ID)");
                    TestField("Delivered By (Town)");

                    if (Confirm('Send mail to dispatch?',true)=true) then begin
                      "Mail Status":="mail status"::Dispatch;
                      Modify;
                    end;
                    Message('Successfully send to dispatch.');
                end;
            }
        }
    }
}

