#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 61 "Applied Customer Entries"
{
    Caption = 'Applied Customer Entries';
    DataCaptionExpression = Heading;
    Editable = false;
    PageType = List;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the customer entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type that the customer entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry''s document number.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the customer entry.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code linked to the entry.';
                    Visible = false;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code linked to the entry.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the salesperson whom the entry is linked to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the amount on the line.';
                }
                field("Original Amount";"Original Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the original entry.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field("Closed by Amount";"Closed by Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that the entry was finally applied to (closed) with.';
                }
                field("Closed by Currency Code";"Closed by Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the currency of the entry that was applied to (and closed) this customer ledger entry.';
                    Visible = false;
                }
                field("Closed by Currency Amount";"Closed by Currency Amount")
                {
                    ApplicationArea = Basic;
                    AutoFormatExpression = "Closed by Currency Code";
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the amount that was finally applied to (and closed) this customer ledger entry.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user associated with the entry.';
                    Visible = false;
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source code that is linked to the entry.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code on the entry.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the entry number that is assigned to the entry.';
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action("Reminder/Fin. Charge Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reminder/Fin. Charge Entries';
                    Image = Reminder;
                    RunObject = Page "Reminder/Fin. Charge Entries";
                    RunPageLink = "Customer Entry No."=field("Entry No.");
                    RunPageView = sorting("Customer Entry No.");
                    ToolTip = 'View entries that were created when reminders and finance charge memos were issued.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action("Detailed &Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Detailed &Ledger Entries';
                    Image = View;
                    RunObject = Page "Detailed Cust. Ledg. Entries";
                    RunPageLink = "Cust. Ledger Entry No."=field("Entry No."),
                                  "Customer No."=field("Customer No.");
                    RunPageView = sorting("Cust. Ledger Entry No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific customer ledger entry.';
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;

        if "Entry No." <> 0 then begin
          CreateCustLedgEntry := Rec;
          if CreateCustLedgEntry."Document Type" = 0 then
            Heading := Text000
          else
            Heading := Format(CreateCustLedgEntry."Document Type");
          Heading := Heading + ' ' + CreateCustLedgEntry."Document No.";

          FindApplnEntriesDtldtLedgEntry;
          SetCurrentkey("Entry No.");
          SetRange("Entry No.");

          if CreateCustLedgEntry."Closed by Entry No." <> 0 then begin
            "Entry No." := CreateCustLedgEntry."Closed by Entry No.";
            Mark(true);
          end;

          SetCurrentkey("Closed by Entry No.");
          SetRange("Closed by Entry No.",CreateCustLedgEntry."Entry No.");
          if Find('-') then
            repeat
              Mark(true);
            until Next = 0;

          SetCurrentkey("Entry No.");
          SetRange("Closed by Entry No.");
        end;

        MarkedOnly(true);
    end;

    var
        Text000: label 'Document';
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        Navigate: Page Navigate;
        Heading: Text[50];

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SetCurrentkey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.",CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SetRange(Unapplied,false);
        if DtldCustLedgEntry1.Find('-') then
          repeat
            if DtldCustLedgEntry1."Cust. Ledger Entry No." =
               DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
            then begin
              DtldCustLedgEntry2.Init;
              DtldCustLedgEntry2.SetCurrentkey("Applied Cust. Ledger Entry No.","Entry Type");
              DtldCustLedgEntry2.SetRange(
                "Applied Cust. Ledger Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
              DtldCustLedgEntry2.SetRange("Entry Type",DtldCustLedgEntry2."entry type"::Application);
              DtldCustLedgEntry2.SetRange(Unapplied,false);
              if DtldCustLedgEntry2.Find('-') then
                repeat
                  if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                     DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                  then begin
                    SetCurrentkey("Entry No.");
                    SetRange("Entry No.",DtldCustLedgEntry2."Cust. Ledger Entry No.");
                    if Find('-') then
                      Mark(true);
                  end;
                until DtldCustLedgEntry2.Next = 0;
            end else begin
              SetCurrentkey("Entry No.");
              SetRange("Entry No.",DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
              if Find('-') then
                Mark(true);
            end;
          until DtldCustLedgEntry1.Next = 0;
    end;


    procedure SetTempCustLedgEntry(NewTempCustLedgEntryNo: Integer)
    begin
        if NewTempCustLedgEntryNo <> 0 then begin
          SetRange("Entry No.",NewTempCustLedgEntryNo);
          Find('-');
        end;
    end;
}

