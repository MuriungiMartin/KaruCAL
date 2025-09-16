#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6520 "Item Tracing"
{
    ApplicationArea = Basic;
    Caption = 'Item Tracing';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Item Tracing Buffer";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SerialNoFilter;SerialNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No. Filter';
                    ToolTip = 'Specifies the serial number or a filter on the serial numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SerialNoInfo: Record "Serial No. Information";
                        SerialNoList: Page "Serial No. Information List";
                    begin
                        SerialNoInfo.Reset;

                        Clear(SerialNoList);
                        SerialNoList.SetTableview(SerialNoInfo);
                        if SerialNoList.RunModal = Action::LookupOK then
                          SerialNoFilter := SerialNoList.GetSelectionFilter;
                    end;
                }
                field(LotNoFilter;LotNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lot No. Filter';
                    ToolTip = 'Specifies the lot number or a filter on the lot numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LotNoInfo: Record "Lot No. Information";
                        LotNoList: Page "Lot No. Information List";
                    begin
                        LotNoInfo.Reset;

                        Clear(LotNoList);
                        LotNoList.SetTableview(LotNoInfo);
                        if LotNoList.RunModal = Action::LookupOK then
                          LotNoFilter := LotNoList.GetSelectionFilter;
                    end;
                }
                field(ItemNoFilter;ItemNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Filter';
                    ToolTip = 'Specifies the item number or a filter on the item numbers that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        Item.Reset;

                        Clear(ItemList);
                        ItemList.SetTableview(Item);
                        ItemList.LookupMode(true);
                        if ItemList.RunModal = Action::LookupOK then
                          ItemNoFilter := ItemList.GetSelectionFilter;
                    end;

                    trigger OnValidate()
                    begin
                        if ItemNoFilter = '' then
                          VariantFilter := '';
                    end;
                }
                field(VariantFilter;VariantFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Filter';
                    ToolTip = 'Specifies the variant code or a filter on the variant codes that you would like to trace.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemVariant: Record "Item Variant";
                        ItemVariants: Page "Item Variants";
                    begin
                        if ItemNoFilter = '' then
                          Error(Text001);

                        ItemVariant.Reset;

                        Clear(ItemVariants);
                        ItemVariant.SetFilter("Item No.",ItemNoFilter);
                        ItemVariants.SetTableview(ItemVariant);
                        ItemVariants.LookupMode(true);
                        if ItemVariants.RunModal = Action::LookupOK then begin
                          ItemVariants.GetRecord(ItemVariant);
                          VariantFilter := ItemVariant.Code;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if ItemNoFilter = '' then
                          Error(Text001);
                    end;
                }
                field(ShowComponents;ShowComponents)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Components';
                    OptionCaption = 'No,Item-tracked Only,All';
                    ToolTip = 'Specifies if you would like to see the components of the item that you are tracing.';
                }
                field(TraceMethod;TraceMethod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Trace Method';
                    OptionCaption = 'Origin -> Usage,Usage -> Origin';
                    ToolTip = 'Specifies posted serial/lot numbers that can be traced either forward or backward in a supply chain.';
                }
            }
            label(Control35)
            {
                ApplicationArea = Basic;
                CaptionClass = FORMAT(TraceText);
                Editable = false;
                ToolTip = 'These are the settings that were used to generate the trace result.';
            }
            repeater(Control1)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                ShowAsTree = true;
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'This field is used internally.';
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'This field is used internally.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'This field is used internally.';
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Source No.";"Source No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Source Name";"Source Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'This field is used internally.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';

                    trigger OnDrillDown()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        ItemLedgerEntry.Reset;
                        ItemLedgerEntry.SetRange("Entry No.","Item Ledger Entry No.");
                        Page.RunModal(0,ItemLedgerEntry);
                    end;
                }
                field("Remaining Quantity";"Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                }
                field("Created by";"Created by")
                {
                    ApplicationArea = Basic;
                    Lookup = true;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Created on";"Created on")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Already Traced";"Already Traced")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if additional transaction history under this line has already been traced by other lines above it.';
                }
                field("Item Ledger Entry No.";"Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
                field("Parent Item Ledger Entry No.";"Parent Item Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field is used internally.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                Image = Line;
                action(ShowDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ItemTracingMgt.ShowDocument("Record Identifier");
                    end;
                }
            }
            group(Item)
            {
                Caption = '&Item';
                Image = Item;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=field("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No."=field("Item No.");
                    RunPageView = sorting("Item No.");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(TraceOppositeFromLine)
                {
                    ApplicationArea = Basic;
                    Caption = '&Trace Opposite - from Line';
                    Enabled = FunctionsEnable;
                    Image = TraceOppositeLine;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if TraceMethod = Tracemethod::"Origin->Usage" then
                          TraceMethod := Tracemethod::"Usage->Origin"
                        else
                          TraceMethod := Tracemethod::"Origin->Usage";
                        OppositeTraceFromLine;
                    end;
                }
                action(SetFiltersWithLineValues)
                {
                    ApplicationArea = Basic;
                    Caption = 'Set &Filters with Line Values';
                    Enabled = FunctionsEnable;
                    Image = FilterLines;

                    trigger OnAction()
                    begin
                        ItemTracingMgt.InitSearchParm(Rec,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter);
                    end;
                }
                action("Go to Already-Traced History")
                {
                    ApplicationArea = Basic;
                    Caption = 'Go to Already-Traced History';
                    Enabled = FunctionsEnable;
                    Image = MoveUp;

                    trigger OnAction()
                    begin
                        SetFocus("Item Ledger Entry No.");
                    end;
                }
                action(NextTraceResult)
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Trace Result';
                    Image = NextRecord;

                    trigger OnAction()
                    begin
                        RecallHistory(1);
                    end;
                }
                action(PreviousTraceResult)
                {
                    ApplicationArea = Basic;
                    Caption = 'Previous Trace Result';
                    Image = PreviousRecord;

                    trigger OnAction()
                    begin
                        RecallHistory(-1);
                    end;
                }
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Enabled = PrintEnable;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    xItemTracingBuffer: Record "Item Tracing Buffer";
                    PrintTracking: Report "Item Tracing Specification";
                begin
                    Clear(PrintTracking);
                    xItemTracingBuffer.Copy(Rec);
                    PrintTracking.TransferEntries(Rec);
                    Copy(xItemTracingBuffer);
                    PrintTracking.Run;
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Enabled = NavigateEnable;
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetTracking("Serial No.","Lot No.");
                    Navigate.Run;
                end;
            }
            action(Trace)
            {
                ApplicationArea = Basic;
                Caption = '&Trace';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FindRecords;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        ItemTracingMgt.SetExpansionStatus(Rec,TempTrackEntry,Rec,ActualExpansionStatus);
        DescriptionOnFormat;
    end;

    trigger OnInit()
    begin
        NavigateEnable := true;
        PrintEnable := true;
        FunctionsEnable := true;
    end;

    trigger OnOpenPage()
    begin
        InitButtons;
        TraceMethod := Tracemethod::"Usage->Origin";
        ShowComponents := Showcomponents::"Item-tracked Only";
    end;

    var
        TempTrackEntry: Record "Item Tracing Buffer" temporary;
        ItemTracingMgt: Codeunit "Item Tracing Mgt.";
        TraceMethod: Option "Origin->Usage","Usage->Origin";
        ShowComponents: Option No,"Item-tracked Only",All;
        ActualExpansionStatus: Option "Has Children",Expanded,"No Children";
        SerialNoFilter: Text;
        LotNoFilter: Text;
        ItemNoFilter: Text;
        VariantFilter: Text;
        Text001: label 'Item No. Filter is required.';
        TraceText: Text;
        Text002: label 'Serial No.: %1, Lot No.: %2, Item: %3, Variant: %4, Trace Method: %5, Show Components: %6';
        PreviousExists: Boolean;
        NextExists: Boolean;
        Text003: label 'Filters are too large to show.';
        Text004: label 'Origin->Usage,Usage->Origin';
        Text005: label 'No,Item-tracked Only,All';
        [InDataSet]
        DescriptionIndent: Integer;
        [InDataSet]
        FunctionsEnable: Boolean;
        [InDataSet]
        PrintEnable: Boolean;
        [InDataSet]
        NavigateEnable: Boolean;


    procedure FindRecords()
    begin
        ItemTracingMgt.FindRecords(TempTrackEntry,Rec,
          SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,
          TraceMethod,ShowComponents);
        InitButtons;

        ItemTracingMgt.GetHistoryStatus(PreviousExists,NextExists);

        UpdateTraceText;

        ItemTracingMgt.ExpandAll(TempTrackEntry,Rec);
        CurrPage.Update(false)
    end;

    local procedure OppositeTraceFromLine()
    begin
        ItemTracingMgt.InitSearchParm(Rec,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter);
        FindRecords;
    end;


    procedure InitButtons()
    begin
        if not TempTrackEntry.FindFirst then begin
          FunctionsEnable := false;
          PrintEnable := false;
          NavigateEnable := false;
        end else begin
          FunctionsEnable := true;
          PrintEnable := true;
          NavigateEnable := true;
        end;
    end;


    procedure InitFilters(var ItemTrackingEntry: Record "Item Tracing Buffer")
    begin
        SerialNoFilter := ItemTrackingEntry.GetFilter("Serial No.");
        LotNoFilter := ItemTrackingEntry.GetFilter("Lot No.");
        ItemNoFilter := ItemTrackingEntry.GetFilter("Item No.");
        VariantFilter := ItemTrackingEntry.GetFilter("Variant Code");
        TraceMethod := Tracemethod::"Usage->Origin";
        ShowComponents := Showcomponents::"Item-tracked Only";
    end;

    local procedure RecallHistory(Steps: Integer)
    begin
        ItemTracingMgt.RecallHistory(Steps,TempTrackEntry,Rec,SerialNoFilter,
          LotNoFilter,ItemNoFilter,VariantFilter,TraceMethod,ShowComponents);
        UpdateTraceText;
        InitButtons;
        ItemTracingMgt.GetHistoryStatus(PreviousExists,NextExists);

        ItemTracingMgt.ExpandAll(TempTrackEntry,Rec);
        CurrPage.Update(false);
    end;

    local procedure UpdateTraceText()
    var
        LengthOfText: Integer;
        Overflow: Boolean;
    begin
        LengthOfText := (StrLen(Text002 + SerialNoFilter + LotNoFilter + ItemNoFilter + VariantFilter) +
                         StrLen(Format(TraceMethod)) + StrLen(Format(ShowComponents)) - 6); // 6 = number of positions in Text002

        Overflow := LengthOfText > 512;

        if Overflow then
          TraceText := Text003
        else
          TraceText := StrSubstNo(Text002,SerialNoFilter,LotNoFilter,ItemNoFilter,VariantFilter,
              SelectStr(TraceMethod + 1,Text004) ,SelectStr(ShowComponents + 1,Text005));
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Level;
    end;

    local procedure SetFocus(ItemLedgerEntryNo: Integer)
    begin
        if "Already Traced" then begin
          TempTrackEntry.SetCurrentkey("Item Ledger Entry No.");
          TempTrackEntry.SetRange("Item Ledger Entry No.",ItemLedgerEntryNo);
          TempTrackEntry.FindFirst;
          CurrPage.SetRecord(TempTrackEntry);
        end;
    end;
}

