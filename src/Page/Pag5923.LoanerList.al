#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5923 "Loaner List"
{
    ApplicationArea = Basic;
    Caption = 'Loaner List';
    CardPageID = "Loaner Card";
    Editable = false;
    PageType = List;
    SourceTable = Loaner;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the loaner.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the loaner.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of the loaner.';
                }
                field(Lent;Lent)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the loaner has been lent to a customer.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document type of the loaner entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service document for the service item that was lent.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("L&oaner")
            {
                Caption = 'L&oaner';
                Image = Loaners;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const(Loaner),
                                  "Table Subtype"=const(0),
                                  "No."=field("No.");
                }
                action("Loaner E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loaner E&ntries';
                    Image = Entries;
                    RunObject = Page "Loaner Entries";
                    RunPageLink = "Loaner No."=field("No.");
                    RunPageView = sorting("Loaner No.")
                                  order(ascending);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(creation)
        {
            action("New Service Order")
            {
                ApplicationArea = Basic;
                Caption = 'New Service Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Service Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(Receive)
                {
                    ApplicationArea = Basic;
                    Caption = 'Receive';
                    Image = ReceiveLoaner;

                    trigger OnAction()
                    var
                        ServLoanerMgt: Codeunit ServLoanerManagement;
                    begin
                        ServLoanerMgt.Receive(Rec);
                    end;
                }
            }
        }
    }
}

