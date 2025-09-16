#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 986 "Document Search Result"
{
    Caption = 'Document Search Result';
    Editable = false;
    PageType = List;
    SourceTable = "Document Search Result";
    SourceTableTemporary = true;
    SourceTableView = sorting("Doc. No.")
                      order(ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Doc. No.";"Doc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information about a non-posted document that is found using the Document Search window during manual payment processing.';

                    trigger OnDrillDown()
                    begin
                        PaymentRegistrationMgt.ShowRecords(Rec);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information about a non-posted document that is found using the Document Search window during manual payment processing.';

                    trigger OnDrillDown()
                    begin
                        PaymentRegistrationMgt.ShowRecords(Rec);
                    end;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies information about a non-posted document that is found using the Document Search window during manual payment processing.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowRecord)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Show';
                Image = ShowSelected;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the document on the selected line.';

                trigger OnAction()
                begin
                    PaymentRegistrationMgt.ShowRecords(Rec);
                end;
            }
        }
    }

    var
        PaymentRegistrationMgt: Codeunit "Payment Registration Mgt.";
}

