#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 521 "Application Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Application Worksheet';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Item Ledger Entry";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DateFilter;DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the date interval by which values are filtered.';

                    trigger OnValidate()
                    var
                        ApplicationManagement: Codeunit ApplicationManagement;
                    begin
                        if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
                        SetFilter("Posting Date",DateFilter);
                        DateFilter := GetFilter("Posting Date");
                        DateFilterOnAfterValidate;
                    end;
                }
                field("Item Filter";ItemFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Filter';
                    TableRelation = Item;
                    ToolTip = 'Specifies a filter to limit the item ledger entries in the first table of the application worksheet to those that have item numbers.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode(true);
                        if ItemList.RunModal = Action::LookupOK then begin
                          Text := ItemList.GetSelectionFilter;
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ItemFilterOnAfterValidate;
                    end;
                }
                field(DocumentFilter;DocumentFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No. Filter';
                    ToolTip = 'Specifies a filter to limit the item ledger entries in the first table of the application worksheet, to those that have document numbers.';

                    trigger OnValidate()
                    begin
                        SetFilter("Document No.",DocumentFilter);
                        DocumentFilter := GetFilter("Document No.");
                        DocumentFilterOnAfterValidate;
                    end;
                }
                field(LocationFilter;LocationFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Filter';
                    TableRelation = Location;
                    ToolTip = 'Specifies a filter to limit the item ledger entries in the first table of the application worksheet to those that have locations.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LocationList: Page "Location List";
                    begin
                        LocationList.LookupMode(true);
                        if LocationList.RunModal = Action::LookupOK then begin
                          Text := LocationList.GetSelectionFilter;
                          exit(true);
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        SetFilter("Location Code",LocationFilter);
                        LocationFilter := GetFilter("Location Code");
                        LocationFilterOnAfterValidate;
                    end;
                }
            }
            repeater(Control1)
            {
                Editable = false;
                Enabled = true;
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number on the entry. The document is the voucher that the entry was based on, for example, a receipt.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the location that the entry is linked to.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source type that applies to the source number, shown in the Source No. field.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what type of document was posted to create the item ledger entry.';
                }
                field("Document Line No.";"Document Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the line on the posted document that corresponds to the item ledger entry.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the items.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a serial number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies where the entry originated.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the entry.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity that remains in inventory in the Quantity field if the entry is an increase (a purchase or positive adjustment).';
                }
                field("Invoiced Quantity";"Invoiced Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item on the line have been invoiced.';
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                }
                field("Shipped Qty. Not Returned";"Shipped Qty. Not Returned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.';
                }
                field("Cost Amount (Actual)";"Cost Amount (Actual)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the adjusted cost, in $, of the quantity posting.';
                }
                field(GetUnitCostLCY;GetUnitCostLCY)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Cost($)';
                    Visible = false;
                }
                field(Open;Open)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }
                field(Positive;Positive)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the item in the item ledge entry is positive.';
                }
                field("Applies-to Entry";"Applies-to Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item entry number that was applied to when the entry was posted, if an already-posted document was designated to be applied.';
                    Visible = false;
                }
                field("Applied Entry to Adjust";"Applied Entry to Adjust")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether there is one or more applied entries, which need to be adjusted.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number for the entry.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1903523907;"Item Application FactBox")
            {
                SubPageLink = "Entry No."=field("Entry No.");
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("V&iew")
            {
                Caption = 'V&iew';
                Image = View;
                action(AppliedEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Applied Entries';
                    Image = Approve;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Clear(ApplicationsForm);
                        ApplicationsForm.SetRecordToShow(Rec,Apply,true);
                        ApplicationsForm.Run;
                        InsertUnapplyItem("Item No.");
                        CurrPage.Update;
                    end;
                }
                action(UnappliedEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unapplied Entries';
                    Image = Entries;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        Clear(ApplicationsForm);
                        ApplicationsForm.SetRecordToShow(Rec,Apply,false);
                        ApplicationsForm.LookupMode := true;
                        if ApplicationsForm.RunModal = Action::LookupOK then
                          ApplicationsForm.ApplyRec;

                        CurrPage.Update;
                    end;
                }
            }
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action("&Value Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Value Entries';
                    Image = ValueLedger;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Item Ledger Entry No."=field("Entry No.");
                    RunPageView = sorting("Item Ledger Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Rea&pply")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rea&pply';
                    Image = "Action";

                    trigger OnAction()
                    begin
                        Reapplyall;
                    end;
                }
                action(UndoApplications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Undo Manual Changes';
                    Image = Restore;

                    trigger OnAction()
                    begin
                        if Apply.ApplicationLogIsEmpty then begin
                          Message(NothingToRevertMsg);
                          exit;
                        end;

                        if Confirm(RevertAllQst) then begin
                          Apply.UndoApplications;
                          Message(RevertCompletedMsg);
                        end
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateFilterFields;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        Found: Boolean;
    begin
        Found := Find(Which);
        if not Found then ;
        exit(Found);
    end;

    trigger OnOpenPage()
    begin
        Apply.SetCalledFromApplicationWorksheet(true);
        ReapplyTouchedEntries; // in case OnQueryClosePage trigger was not executed due to a sudden crash

        InventoryPeriod.IsValidDate(InventoryOpenedFrom);
        if InventoryOpenedFrom <> 0D then
          if GetFilter("Posting Date") = '' then
            SetFilter("Posting Date",'%1..',CalcDate('<+1D>',InventoryOpenedFrom))
          else begin
            if GetFilter("Posting Date") <> StrSubstNo('%1..',CalcDate('<+1D>',InventoryOpenedFrom)) then
              SetFilter("Posting Date",
                StrSubstNo('%2&%1..',CalcDate('<+1D>',InventoryOpenedFrom),GetFilter("Posting Date")))
          end;

        UpdateFilterFields;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if Apply.AnyTouchedEntries then begin
          if not Confirm(Text003) then
            exit(false);

          UnblockItems;
          Reapplyall;
        end;

        exit(true);
    end;

    var
        InventoryPeriod: Record "Inventory Period";
        TempUnapplyItem: Record Item temporary;
        Apply: Codeunit "Item Jnl.-Post Line";
        ApplicationsForm: Page "View Applied Entries";
        InventoryOpenedFrom: Date;
        DateFilter: Text;
        ItemFilter: Text;
        LocationFilter: Text;
        DocumentFilter: Text;
        Text003: label 'After the window is closed, the system will check for and reapply open entries.\Do you want to close the window?';
        RevertAllQst: label 'Are you sure that you want to undo all changes?';
        NothingToRevertMsg: label 'Nothing to undo.';
        RevertCompletedMsg: label 'The changes have been undone.';

    local procedure UpdateFilterFields()
    begin
        ItemFilter := GetFilter("Item No.");
        LocationFilter := GetFilter("Location Code");
        DateFilter := GetFilter("Posting Date");
        DocumentFilter := GetFilter("Document No.");
    end;

    local procedure Reapplyall()
    begin
        Apply.RedoApplications;
        Apply.CostAdjust;
        Apply.ClearApplicationLog;
    end;

    local procedure ReapplyTouchedEntries()
    begin
        Apply.RestoreTouchedEntries(TempUnapplyItem);

        if Apply.AnyTouchedEntries then begin
          UnblockItems;
          Reapplyall;
        end;
    end;


    procedure SetRecordToShow(RecordToSet: Record "Item Ledger Entry")
    begin
        Rec := RecordToSet;
    end;

    local procedure LocationFilterOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure ItemFilterOnAfterValidate()
    begin
        SetFilter("Item No.",ItemFilter);
        ItemFilter := GetFilter("Item No.");
        CurrPage.Update;
    end;

    local procedure InsertUnapplyItem(ItemNo: Code[20])
    begin
        with TempUnapplyItem do
          if not Get(ItemNo) then begin
            Init;
            "No." := ItemNo;
            Insert;
          end;
    end;

    local procedure UnblockItems()
    var
        Item: Record Item;
    begin
        with TempUnapplyItem do begin
          if FindSet then
            repeat
              Item.Get("No.");
              if Item."Application Wksh. User ID" = UpperCase(UserId) then begin
                Item."Application Wksh. User ID" := '';
                Item.Modify;
              end;
            until Next = 0;

          DeleteAll;
        end;
    end;

    local procedure DocumentFilterOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

