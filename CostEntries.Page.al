#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1103 "Cost Entries"
{
    Caption = 'Cost Entries';
    DataCaptionFields = "Cost Type No.";
    Editable = false;
    PageType = List;
    SourceTable = "Cost Entry";

    layout
    {
        area(content)
        {
            repeater(Control4)
            {
                field("Cost Type No.";"Cost Type No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Center Code";"Cost Center Code")
                {
                    ApplicationArea = Basic;
                }
                field("Cost Object Code";"Cost Object Code")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account";"G/L Account")
                {
                    ApplicationArea = Basic;
                }
                field("G/L Entry No.";"G/L Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Allocation ID";"Allocation ID")
                {
                    ApplicationArea = Basic;
                }
                field("Allocation Description";"Allocation Description")
                {
                    ApplicationArea = Basic;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Allocated;Allocated)
                {
                    ApplicationArea = Basic;
                }
                field("Additional-Currency Amount";"Additional-Currency Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Allocated with Journal No.";"Allocated with Journal No.")
                {
                    ApplicationArea = Basic;
                }
                field("System-Created Entry";"System-Created Entry")
                {
                    ApplicationArea = Basic;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Name";"Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }
}

