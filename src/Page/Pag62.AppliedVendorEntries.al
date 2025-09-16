#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 62 "Applied Vendor Entries"
{
    Caption = 'Applied Vendor Entries';
    DataCaptionExpression = Heading;
    Editable = false;
    PageType = List;
    SourceTable = "Vendor Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor entry''s posting date.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type that the vendor entry belongs to.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the vendor entry''s document number.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the vendor entry.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the external document number that was entered on the purchase header or journal line.';
                    Visible = true;
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
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the purchaser whom the entry is linked to.';
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
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code of the entry that was applied to (and closed) this vendor ledger entry.';
                }
                field("Closed by Currency Amount";"Closed by Currency Amount")
                {
                    ApplicationArea = Suite;
                    AutoFormatExpression = "Closed by Currency Code";
                    AutoFormatType = 1;
                    ToolTip = 'Specifies the amount that was finally applied to (and closed) this vendor ledger entry.';
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
                    RunObject = Page "Detailed Vendor Ledg. Entries";
                    RunPageLink = "Vendor Ledger Entry No."=field("Entry No."),
                                  "Vendor No."=field("Vendor No.");
                    RunPageView = sorting("Vendor Ledger Entry No.","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a summary of the all posted entries and adjustments related to a specific vendor ledger entry.';
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
          CreateVendLedgEntry := Rec;
          if CreateVendLedgEntry."Document Type" = 0 then
            Heading := Text000
          else
            Heading := Format(CreateVendLedgEntry."Document Type");
          Heading := Heading + ' ' + CreateVendLedgEntry."Document No.";

          FindApplnEntriesDtldtLedgEntry;
          SetCurrentkey("Entry No.");
          SetRange("Entry No.");

          if CreateVendLedgEntry."Closed by Entry No." <> 0 then begin
            "Entry No." := CreateVendLedgEntry."Closed by Entry No.";
            Mark(true);
          end;

          SetCurrentkey("Closed by Entry No.");
          SetRange("Closed by Entry No.",CreateVendLedgEntry."Entry No.");
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
        CreateVendLedgEntry: Record "Vendor Ledger Entry";
        Navigate: Page Navigate;
        Heading: Text[50];

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry1.SetCurrentkey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.",CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry1.SetRange(Unapplied,false);
        if DtldVendLedgEntry1.Find('-') then
          repeat
            if DtldVendLedgEntry1."Vendor Ledger Entry No." =
               DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
            then begin
              DtldVendLedgEntry2.Init;
              DtldVendLedgEntry2.SetCurrentkey("Applied Vend. Ledger Entry No.","Entry Type");
              DtldVendLedgEntry2.SetRange(
                "Applied Vend. Ledger Entry No.",DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
              DtldVendLedgEntry2.SetRange("Entry Type",DtldVendLedgEntry2."entry type"::Application);
              DtldVendLedgEntry2.SetRange(Unapplied,false);
              if DtldVendLedgEntry2.Find('-') then
                repeat
                  if DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                     DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                  then begin
                    SetCurrentkey("Entry No.");
                    SetRange("Entry No.",DtldVendLedgEntry2."Vendor Ledger Entry No.");
                    if Find('-') then
                      Mark(true);
                  end;
                until DtldVendLedgEntry2.Next = 0;
            end else begin
              SetCurrentkey("Entry No.");
              SetRange("Entry No.",DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
              if Find('-') then
                Mark(true);
            end;
          until DtldVendLedgEntry1.Next = 0;
    end;
}

