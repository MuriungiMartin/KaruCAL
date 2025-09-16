#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 583 "XBRL Taxonomy Lines"
{
    Caption = 'XBRL Taxonomy Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "XBRL Taxonomy Line";
    SourceTableTemporary = true;
    SourceTableView = sorting("XBRL Taxonomy Name","Presentation Order");

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CurrentTaxonomy;CurrentTaxonomy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Taxonomy Name';
                    Editable = false;
                    TableRelation = "XBRL Taxonomy";
                    ToolTip = 'Specifies the name of the XBRL taxonomy.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        XBRLTaxonomy: Record "XBRL Taxonomy";
                    begin
                        XBRLTaxonomy.Name := CurrentTaxonomy;
                        if Page.RunModal(0,XBRLTaxonomy) <> Action::LookupOK then
                          exit(false);

                        Text := XBRLTaxonomy.Name;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrentTaxonomyOnAfterValidate;
                    end;
                }
                field(OnlyShowPresentation;OnlyShowPresentation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Only Presentation';
                    ToolTip = 'Specifies if the XBRL content is shown using the Presentation layout only, which provides information about the structure and relationships of elements on the taxonomy lines.';

                    trigger OnValidate()
                    begin
                        SetFilters;
                    end;
                }
                field(CurrentLang;CurrentLang)
                {
                    ApplicationArea = Basic;
                    Caption = 'Label Language';
                    ToolTip = 'Specifies the language you want the labels to be shown in. The label is a user-readable element of the taxonomy.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        XBRLTaxonomyLabel: Record "XBRL Taxonomy Label";
                        XBRLTaxonomyLabels: Page "G/L Account Currency FactBox";
                    begin
                        XBRLTaxonomyLabel.SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
                        if not XBRLTaxonomyLabel.FindFirst then
                          Error(Text002,"XBRL Taxonomy Name");
                        XBRLTaxonomyLabel.SetRange(
                          "XBRL Taxonomy Line No.",XBRLTaxonomyLabel."XBRL Taxonomy Line No.");
                        XBRLTaxonomyLabels.SetTableview(XBRLTaxonomyLabel);
                        XBRLTaxonomyLabels.LookupMode := true;
                        if XBRLTaxonomyLabels.RunModal = Action::LookupOK then begin
                          XBRLTaxonomyLabels.GetRecord(XBRLTaxonomyLabel);
                          Text := XBRLTaxonomyLabel."XML Language Identifier";
                          exit(true);
                        end;
                        exit(false);
                    end;

                    trigger OnValidate()
                    var
                        XBRLTaxonomyLabel: Record "XBRL Taxonomy Label";
                    begin
                        XBRLTaxonomyLabel.SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
                        XBRLTaxonomyLabel.SetRange("XML Language Identifier",CurrentLang);
                        if CurrentLang <> '' then
                          if XBRLTaxonomyLabel.IsEmpty then
                            Error(Text001,CurrentLang);
                        SetFilters;
                    end;
                }
            }
            repeater(Control1)
            {
                IndentationColumn = Level;
                IndentationControls = Label;
                ShowAsTree = true;
                field(Label;Label)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Style = Strong;
                    StyleExpr = LabelEmphasize;
                    ToolTip = 'Specifies the label that was assigned to this line. The label is a user-readable element of the taxonomy.';
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the source of the information for this line that you want to export. You can only export one type of information for each line. The Tuple option means that the line represents a number of related lines. The related lines are listed below this line and are indented.';
                }
                field("Constant Amount";"Constant Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that will be exported if the source type is Constant.';
                }
                field(Control10;Information)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there is information in the Comment table about this line. The information was imported from the info attribute when the taxonomy was imported.';
                }
                field(Control32;Reference)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Comment table contains a reference to official material that you can read about this line. The reference was imported from the reference linkbase when the taxonomy was imported.';
                }
                field(Control12;Notes)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there are notes entered in the Comment table about this line element.';
                }
                field(Control8;"G/L Map Lines")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which general ledger accounts will be used to calculate the amount that will be exported for this line.';
                }
                field(Rollup;Rollup)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if there are records in the Rollup Line table about this line. This data was imported when the taxonomy was imported.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the text that will be exported if the source type is Description. You can create a description formula using codes. Examples: %1: End of Financial Period - Day of Month (1 - 31) %2: End of Financial Period - Day of Month (01 - 31). See more codes the help topic for the Description field.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name that the program assigned to this line. This field is populated during the import of the taxonomy.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control9;"XBRL Comment Lines Part")
            {
                Caption = 'Reference/Information';
                SubPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                              "XBRL Taxonomy Line No."=field("Line No."),
                              "Comment Type"=filter(Information|Reference);
            }
            part(Control7;"XBRL Comment Lines Part")
            {
                Caption = 'Notes';
                SubPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                              "XBRL Taxonomy Line No."=field("Line No."),
                              "Comment Type"=const(Notes),
                              "Label Language Filter"=field("Label Language Filter");
            }
            part(Control11;"XBRL G/L Map Lines Part")
            {
                Caption = 'G/L Map';
                SubPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                              "XBRL Taxonomy Line No."=field("Line No."),
                              "Label Language Filter"=field("Label Language Filter");
            }
            part(Control13;"XBRL Line Constants Part")
            {
                Caption = 'Constants';
                SubPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                              "XBRL Taxonomy Line No."=field("Line No."),
                              "Label Language Filter"=field("Label Language Filter");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&XBRL Line")
            {
                Caption = '&XBRL Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "XBRL Taxonomy Line Card";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "Line No."=field("Line No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information for the XBRL taxonomy line.';
                }
                separator(Action23)
                {
                    Caption = '';
                }
                action(Information)
                {
                    ApplicationArea = Basic;
                    Caption = 'Information';
                    Image = Info;
                    RunObject = Page "XBRL Comment Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Comment Type"=const(Information),
                                  "Label Language Filter"=field("Label Language Filter");
                    ToolTip = 'View information in the Comment table about this line. The information was imported from the info attribute when the taxonomy was imported.';
                }
                action(Reference)
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&ference';
                    Image = EntriesList;
                    RunObject = Page "XBRL Comment Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Comment Type"=const(Reference),
                                  "Label Language Filter"=field("Label Language Filter");
                    ToolTip = 'View if the Comment table contains a reference to official material that you can read about this line. The reference was imported from the reference linkbase when the taxonomy was imported.';
                }
                action(Rollups)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rollups';
                    Image = Totals;
                    RunObject = Page "XBRL Rollup Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Label Language Filter"=field("Label Language Filter");
                    ToolTip = 'View how XBRL information is rolled up from other lines.';
                }
                action(Notes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Notes';
                    Image = Notes;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "XBRL Comment Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Comment Type"=const(Notes),
                                  "Label Language Filter"=field("Label Language Filter");
                    ToolTip = 'View any notes entered in the Comment table about this line element.';
                }
                action("G/L Map Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'G/L Map Lines';
                    Image = CompareCOA;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "XBRL G/L Map Lines";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Label Language Filter"=field("Label Language Filter");
                    ToolTip = 'View which general ledger accounts will be used to calculate the amount that will be exported for this line.';
                }
                action("C&onstants")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&onstants';
                    Image = AmountByPeriod;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "XBRL Line Constants";
                    RunPageLink = "XBRL Taxonomy Name"=field("XBRL Taxonomy Name"),
                                  "XBRL Taxonomy Line No."=field("Line No."),
                                  "Label Language Filter"=field("Label Language Filter");
                    ToolTip = 'View or create date-specific constant amounts to be exported.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Copy XBRL Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy XBRL Setup';
                    Ellipsis = true;
                    Image = Copy;
                    ToolTip = 'Copy the setup of one taxonomy to another. The setup includes description, constant amount, notes, and G/L map lines.';

                    trigger OnAction()
                    var
                        XBRLCopySetup: Report "XBRL Copy Setup";
                    begin
                        XBRLCopySetup.SetCopyTo(CurrentTaxonomy);
                        XBRLCopySetup.Run;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        XBRLLine: Record "XBRL Taxonomy Line";
    begin
        if IsExpanded(Rec) then
          ActualExpansionStatus := 1
        else
          if HasChildren(Rec) then
            ActualExpansionStatus := 0
          else
            ActualExpansionStatus := 2;

        XBRLLine.Get("XBRL Taxonomy Name","Line No.");
        if ("Source Type" <> XBRLLine."Source Type") or
           ("Constant Amount" <> XBRLLine."Constant Amount") or
           (Description <> XBRLLine.Description)
        then begin
          XBRLLine.CalcFields(Label,Information,Rollup,"G/L Map Lines",Notes,Reference);
          Rec := XBRLLine;
          Modify;
        end;

        if Label = '' then
          Label := Name;
        LabelOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if not FiltersApplied then
          SetFilters;
        FiltersApplied := true;
        exit(Find(Which));
    end;

    trigger OnModifyRecord(): Boolean
    var
        XBRLLine: Record "XBRL Taxonomy Line";
    begin
        XBRLLine.Get("XBRL Taxonomy Name","Line No.");
        XBRLLine := Rec;
        XBRLLine.Modify;
        Rec := XBRLLine;
        Modify;
        exit(false);
    end;

    trigger OnOpenPage()
    var
        XBRLTaxonomy: Record "XBRL Taxonomy";
        XBRLTaxonomyLabel: Record "XBRL Taxonomy Label";
    begin
        if GetFilter("XBRL Taxonomy Name") <> '' then
          CurrentTaxonomy := GetRangeMin("XBRL Taxonomy Name");
        if not XBRLTaxonomy.Get(CurrentTaxonomy) then
          if not XBRLTaxonomy.FindFirst then
            XBRLTaxonomy.Init;
        CurrentTaxonomy := XBRLTaxonomy.Name;

        XBRLTaxonomyLabel.SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
        if CurrentLang <> '' then
          XBRLTaxonomyLabel.SetRange("XML Language Identifier",CurrentLang);
        if XBRLTaxonomyLabel.FindFirst then
          CurrentLang := XBRLTaxonomyLabel."XML Language Identifier"
        else
          if CurrentLang <> '' then begin
            XBRLTaxonomyLabel.SetRange("XML Language Identifier");
            if XBRLTaxonomyLabel.FindFirst then
              CurrentLang := XBRLTaxonomyLabel."XML Language Identifier"
          end;

        ExpandAll;
    end;

    var
        CurrentTaxonomy: Code[20];
        CurrentLang: Text[10];
        ActualExpansionStatus: Integer;
        Text001: label 'Labels are not defined for language %1.';
        Text002: label 'There are no labels defined for %1.';
        OnlyShowPresentation: Boolean;
        [InDataSet]
        LabelEmphasize: Boolean;
        FiltersApplied: Boolean;


    procedure SetCurrentSchema(NewCurrentTaxonomy: Code[20])
    begin
        CurrentTaxonomy := NewCurrentTaxonomy;
    end;

    local procedure InitTempTable()
    var
        XBRLLine: Record "XBRL Taxonomy Line";
    begin
        ResetFilter;
        DeleteAll;
        XBRLLine.SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
        XBRLLine.SetRange(Level,0);
        if XBRLLine.Find('-') then
          repeat
            Rec := XBRLLine;
            Insert;
          until XBRLLine.Next = 0;
    end;

    local procedure ExpandAll()
    var
        XBRLLine: Record "XBRL Taxonomy Line";
    begin
        ResetFilter;
        DeleteAll;
        XBRLLine.SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
        if XBRLLine.Find('-') then
          repeat
            Rec := XBRLLine;
            Insert;
          until XBRLLine.Next = 0;
    end;

    local procedure HasChildren(ActualXBRLLine: Record "XBRL Taxonomy Line"): Boolean
    var
        XBRLLine2: Record "XBRL Taxonomy Line";
    begin
        XBRLLine2 := ActualXBRLLine;
        XBRLLine2.SetCurrentkey("XBRL Taxonomy Name","Presentation Order");
        XBRLLine2.SetRange("XBRL Taxonomy Name",ActualXBRLLine."XBRL Taxonomy Name");
        if XBRLLine2.Next = 0 then
          exit(false);

        exit(XBRLLine2.Level > ActualXBRLLine.Level);
    end;

    local procedure IsExpanded(ActualXBRLLine: Record "XBRL Taxonomy Line"): Boolean
    var
        xXBRLLine: Record "XBRL Taxonomy Line";
        Found: Boolean;
    begin
        xXBRLLine.Copy(Rec);
        ResetFilter;
        Rec := ActualXBRLLine;
        Found := (Next <> 0);
        if Found then
          Found := (Level > ActualXBRLLine.Level);
        Copy(xXBRLLine);
        exit(Found);
    end;

    local procedure SetFilters()
    begin
        SetRange("Label Language Filter",CurrentLang);
        if OnlyShowPresentation then
          SetFilter("Presentation Linkbase Line No.",'>0')
        else
          SetRange("Presentation Linkbase Line No.");
        CurrPage.Update(false);
    end;

    local procedure ResetFilter()
    begin
        Reset;
        SetCurrentkey("XBRL Taxonomy Name","Presentation Order");
        FilterGroup(2);
        SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
        FilterGroup(0);
        SetFilters;
    end;

    local procedure CurrentTaxonomyOnAfterValidate()
    begin
        FilterGroup(2);
        SetRange("XBRL Taxonomy Name",CurrentTaxonomy);
        FilterGroup(0);
        SetRange("XBRL Taxonomy Name");
        InitTempTable;
        CurrPage.Update(false);
    end;

    local procedure LabelOnFormat()
    begin
        LabelEmphasize := (Level = 0) or (ActualExpansionStatus < 2);
    end;
}

