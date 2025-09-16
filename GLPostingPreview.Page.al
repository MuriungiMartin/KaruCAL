#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 115 "G/L Posting Preview"
{
    Caption = 'Posting Preview';
    Editable = false;
    PageType = List;
    SourceTable = "Document Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control16)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Table Name";"Table Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Related Entries';
                    ToolTip = 'Specifies the name of the table where the Navigate facility has found entries with the selected document number and/or posting date.';
                }
                field("No. of Records";"No. of Records")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'No. of Entries';
                    DrillDown = true;
                    ToolTip = 'Specifies the number of documents that the Navigate facility has found in the table with the selected entries.';

                    trigger OnDrillDown()
                    begin
                        PostingPreviewEventHandler.ShowEntries("Table ID");
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(Show)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Show Related Entries';
                    Image = ViewDocumentLine;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageMode = View;
                    ToolTip = 'Show details about other entries that are related to the general ledger posting.';

                    trigger OnAction()
                    begin
                        PostingPreviewEventHandler.ShowEntries("Table ID");
                    end;
                }
            }
        }
    }

    var
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";


    procedure Set(var TempDocumentEntry: Record "Document Entry" temporary;NewPostingPreviewEventHandler: Codeunit "Posting Preview Event Handler")
    begin
        PostingPreviewEventHandler := NewPostingPreviewEventHandler;
        if TempDocumentEntry.FindSet then
          repeat
            Rec := TempDocumentEntry;
            Insert;
          until TempDocumentEntry.Next = 0;
    end;
}

