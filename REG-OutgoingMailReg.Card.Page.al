#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68164 "REG-Outgoing Mail Reg. Card"
{
    PageType = Card;
    SourceTable = UnknownTable61030;
    SourceTableView = where("Direction Type"=filter(="Outgoing Mail (External)"));

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
                    OptionCaption = 'Outgoing Mail (Internal),Outgoing Mail (External)';
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
            }
        }
    }

    actions
    {
    }
}

