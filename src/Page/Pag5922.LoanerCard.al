#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5922 "Loaner Card"
{
    Caption = 'Loaner Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Loaner;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the loaner.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a description of the loaner.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of the loaner.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit price of the loaner.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number for the loaner for the service item.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code for the loaner.';
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
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the loaner is blocked and cannot be lent to customers.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the loaner card was last modified.';
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
                separator(Action17)
                {
                    Caption = '';
                }
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
                separator(Action16)
                {
                    Caption = '';
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Receive")
                {
                    ApplicationArea = Basic;
                    Caption = '&Receive';
                    Image = ReceiveLoaner;
                    Promoted = true;
                    PromotedCategory = Process;

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

