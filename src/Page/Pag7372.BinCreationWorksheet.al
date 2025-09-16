#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7372 "Bin Creation Worksheet"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Bin Creation Worksheet';
    DataCaptionFields = Name;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Bin Creation Worksheet Line";
    SourceTableView = sorting("Worksheet Template Name",Name,"Location Code","Line No.")
                      where(Type=const(Bin));
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    BinCreateLine.LookupBinCreationName(CurrentJnlBatchName,CurrentLocationCode,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    BinCreateLine.CheckName(CurrentJnlBatchName,CurrentLocationCode,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            field(CurrentLocationCode;CurrentLocationCode)
            {
                ApplicationArea = Basic;
                Caption = 'Location Code';
                Editable = false;
                Lookup = true;
                TableRelation = Location;
            }
            repeater(Control1)
            {
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone where the bin on the worksheet will be located.';
                    Visible = false;
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the bin on the line of the worksheet.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description for the bin that should be created.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin type or bin content that should be created.';
                    Visible = false;
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the warehouse class of the bin or bin content that should be created.';
                    Visible = false;
                }
                field("Block Movement";"Block Movement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the movement of a particular item, or bin content, into or out of this bin, is blocked.';
                    Visible = false;
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the special equipment code of the bin or bin content that should be created.';
                    Visible = false;
                }
                field("Bin Ranking";"Bin Ranking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ranking of the bin or bin content that should be created.';
                    Visible = false;
                }
                field("Maximum Cubage";"Maximum Cubage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum cubage of the bin that should be created.';
                    Visible = false;
                }
                field("Maximum Weight";"Maximum Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum weight of the bin that should be created.';
                    Visible = false;
                }
                field("Cross-Dock Bin";"Cross-Dock Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies new cross-dock bins.';
                    Visible = false;
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
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CalculateBins)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate &Bins';
                    Ellipsis = true;
                    Image = SuggestBin;

                    trigger OnAction()
                    begin
                        BinCreateWksh.SetTemplAndWorksheet("Worksheet Template Name",Name,CurrentLocationCode);
                        BinCreateWksh.RunModal;
                        Clear(BinCreateWksh);
                    end;
                }
                action("&Create Bins")
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = '&Create Bins';
                    Image = CreateBins;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        BinCreateLine.Copy(Rec);
                        SetFilter("Bin Code",'<>%1','');
                        Codeunit.Run(Codeunit::"Bin Create",Rec);
                        BinCreateLine.Reset;
                        Copy(BinCreateLine);
                        FilterGroup(2);
                        SetRange("Worksheet Template Name","Worksheet Template Name");
                        SetRange(Name,Name);
                        SetRange("Location Code",CurrentLocationCode);
                        FilterGroup(0);
                        CurrPage.Update(false);
                    end;
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    BinCreateLine.SetRange("Worksheet Template Name","Worksheet Template Name");
                    BinCreateLine.SetRange(Name,Name);
                    BinCreateLine.SetRange("Location Code","Location Code");
                    BinCreateLine.SetRange(Type,BinCreateLine.Type::Bin);
                    Report.Run(Report::"Bin Creation Wksh. Report",true,false,BinCreateLine);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine(GetRangemax("Worksheet Template Name"));
    end;

    trigger OnOpenPage()
    var
        WkshSelected: Boolean;
    begin
        OpenedFromBatch := (Name <> '') and ("Worksheet Template Name" = '');
        if OpenedFromBatch then begin
          CurrentJnlBatchName := Name;
          CurrentLocationCode := "Location Code";
          BinCreateLine.OpenWksh(CurrentJnlBatchName,CurrentLocationCode,Rec);
          exit;
        end;
        BinCreateLine.TemplateSelection(Page::"Bin Creation Worksheet",0,Rec,WkshSelected);
        if not WkshSelected then
          Error('');
        BinCreateLine.OpenWksh(CurrentJnlBatchName,CurrentLocationCode,Rec);
    end;

    var
        BinCreateLine: Record "Bin Creation Worksheet Line";
        BinCreateWksh: Report "Calculate Bins";
        CurrentLocationCode: Code[10];
        CurrentJnlBatchName: Code[10];
        OpenedFromBatch: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        BinCreateLine.SetName(CurrentJnlBatchName,CurrentLocationCode,Rec);
        CurrPage.Update(false);
    end;
}

