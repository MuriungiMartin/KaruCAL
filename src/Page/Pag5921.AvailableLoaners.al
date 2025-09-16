#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5921 "Available Loaners"
{
    Caption = 'Available Loaners';
    PageType = List;
    SourceTable = Loaner;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the loaner.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number for the loaner for the service item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the loaner.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that there is a comment for this loaner.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the loaner is blocked and cannot be lent to customers.';
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
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Loaner Card";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const(Loaner),
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
                        LoanerEntry: Record "Loaner Entry";
                        ServItemLine: Record "Service Item Line";
                        ServLoanerMgt: Codeunit ServLoanerManagement;
                    begin
                        if Lent then  begin
                          Clear(LoanerEntry);
                          LoanerEntry.SetCurrentkey("Document Type","Document No.","Loaner No.",Lent);
                          LoanerEntry.SetRange("Document Type","Document Type");
                          LoanerEntry.SetRange("Document No.","Document No.");
                          LoanerEntry.SetRange("Loaner No.","No.");
                          LoanerEntry.SetRange(Lent,true);
                          if LoanerEntry.FindFirst then begin
                            ServItemLine.Get(LoanerEntry."Document Type" - 1,LoanerEntry."Document No.",LoanerEntry."Service Item Line No.");
                            ServLoanerMgt.ReceiveLoaner(ServItemLine);
                          end;
                        end else
                          Error(Text000,TableCaption,"No.");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange(Blocked,false);
        SetRange(Lent,false);
    end;

    var
        Text000: label 'You cannot receive %1 %2 because it has not been lent.', Comment='You cannot receive Loaner L00001 because it has not been lent.';
}

