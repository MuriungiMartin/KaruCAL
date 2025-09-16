#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 550 "VAT Rate Change Setup"
{
    ApplicationArea = Basic;
    Caption = 'Tax Rate Change Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "VAT Rate Change Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("VAT Rate Change Tool Completed";"VAT Rate Change Tool Completed")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the tax rate change conversion is complete.';
                }
                field("Perform Conversion";"Perform Conversion")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Select this field to perform the tax rate conversion on existing data.';
                }
            }
            group("Master Data")
            {
                Caption = 'Master Data';
                field("Update G/L Accounts";"Update G/L Accounts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for general ledger accounts.';
                }
                field("Account Filter";"Account Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which accounts will be updated by setting appropriate filters.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookUpGLAccountFilter(Text));
                    end;
                }
                field("Update Items";"Update Items")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for items.';
                }
                field("Item Filter";"Item Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which items will be updated by setting appropriate filters.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookUpItemFilter(Text));
                    end;
                }
                field("Update Resources";"Update Resources")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for resources.';
                }
                field("Resource Filter";"Resource Filter")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which resources will be updated by setting appropriate filters.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(LookUpResourceFilter(Text));
                    end;
                }
                field("Update Item Templates";"Update Item Templates")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Select the tax rate change for item categories.';
                }
                field("Update Item Charges";"Update Item Charges")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for item charges.';
                }
                field("Update Gen. Prod. Post. Groups";"Update Gen. Prod. Post. Groups")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for general product posting groups.';
                }
                field("Update Serv. Price Adj. Detail";"Update Serv. Price Adj. Detail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for service price adjustment detail.';
                }
                field("Update Work Centers";"Update Work Centers")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for work centers.';
                }
                field("Update Machine Centers";"Update Machine Centers")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for machine centers.';
                }
            }
            group(Journals)
            {
                Caption = 'Journals';
                field("Update Gen. Journal Lines";"Update Gen. Journal Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for general journal lines.';
                }
                field("Update Gen. Journal Allocation";"Update Gen. Journal Allocation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for general journal allocation.';
                }
                field("Update Std. Gen. Jnl. Lines";"Update Std. Gen. Jnl. Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for standard general journal lines.';
                }
                field("Update Res. Journal Lines";"Update Res. Journal Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for resource journal lines.';
                }
                field("Update Job Journal Lines";"Update Job Journal Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for job journal lines.';
                }
                field("Update Requisition Lines";"Update Requisition Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for requisition lines.';
                }
                field("Update Std. Item Jnl. Lines";"Update Std. Item Jnl. Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for standard item journal lines.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                field("Update Sales Documents";"Update Sales Documents")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for sales documents.';
                }
                field("Ignore Status on Sales Docs.";"Ignore Status on Sales Docs.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Select to update all existing sales documents regardless of status, including documents with a status of released.';
                }
                field("Update Purchase Documents";"Update Purchase Documents")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for purchase documents.';
                }
                field("Ignore Status on Purch. Docs.";"Ignore Status on Purch. Docs.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Select to update all existing purchase documents regardless of status, including documents with a status of released.';
                }
                field("Update Service Docs.";"Update Service Docs.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for service lines.';
                }
                field("Update Production Orders";"Update Production Orders")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for production orders.';
                }
                field("Update Reminders";"Update Reminders")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for reminders.';
                }
                field("Update Finance Charge Memos";"Update Finance Charge Memos")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax rate change for finance charge memos.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("S&etup")
            {
                Caption = 'S&etup';
                Image = Setup;
                action("Tax Prod. Posting Group Conv.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Prod. Posting Group Conv.';
                    Image = Registered;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Prod. Posting Group Conv.";
                }
                action("Gen. Prod. Posting Group Conv.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Gen. Prod. Posting Group Conv.';
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Gen. Prod. Posting Group Conv.";
                }
            }
            group("F&unction")
            {
                Caption = 'F&unction';
                Image = "Action";
                action("&Convert")
                {
                    ApplicationArea = Basic;
                    Caption = '&Convert';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "VAT Rate Change Conversion";
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Tax Rate Change Log Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Rate Change Log Entries';
                    Image = ChangeLog;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Rate Change Log Entries";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}

