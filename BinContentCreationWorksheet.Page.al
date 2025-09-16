#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7371 "Bin Content Creation Worksheet"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Bin Content Creation Worksheet';
    DataCaptionFields = Name;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Bin Creation Worksheet Line";
    SourceTableView = sorting("Worksheet Template Name",Name,"Location Code","Line No.")
                      where(Type=const("Bin Content"));
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

                    trigger OnValidate()
                    begin
                        BinCodeOnAfterValidate;
                    end;
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the bin type or bin content that should be created.';
                    Visible = false;
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the warehouse class of the bin or bin content that should be created.';
                    Visible = false;
                }
                field("Bin Ranking";"Bin Ranking")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ranking of the bin or bin content that should be created.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number for which bin content should be created.';

                    trigger OnValidate()
                    begin
                        BinCreateLine.GetItemDescr("Item No.","Variant Code",ItemDescription);
                        BinCreateLine.GetUnitOfMeasureDescr("Unit of Measure Code",UOMDescription);
                    end;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code of the bin content that should be created.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        VariantCodeOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code that you would like to use for bin contents in this particular bin.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        BinCreateLine.GetUnitOfMeasureDescr("Unit of Measure Code",UOMDescription);
                    end;
                }
                field("Min. Qty.";"Min. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the minimum quantity for the bin content that should be created.';
                    Visible = false;
                }
                field("Max. Qty.";"Max. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum quantity for the bin content that should be created.';
                    Visible = false;
                }
                field("Block Movement";"Block Movement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the movement of a particular item, or bin content, into or out of this bin, is blocked.';
                    Visible = false;
                }
                field("Fixed";Fixed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the bin content that is to be created will be fixed for the item.';
                }
                field(Default;Default)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the bin is to be the default bin for the item on the bin worksheet line.';
                }
                field("Cross-Dock Bin";"Cross-Dock Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies new cross-dock bins.';
                    Visible = false;
                }
            }
            group(Control2)
            {
                fixed(Control1900116601)
                {
                    group(Control1901742101)
                    {
                        Caption = 'Bin Code';
                        field(BinCode;BinCode)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Item Description")
                    {
                        Caption = 'Item Description';
                        field(ItemDescription;ItemDescription)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Item Description';
                            Editable = false;
                        }
                    }
                    group("Unit Of Measure Description")
                    {
                        Caption = 'Unit Of Measure Description';
                        field(UOMDescription;UOMDescription)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Unit Of Measure Description';
                            Editable = false;
                        }
                    }
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
                action(CreateBinContent)
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = '&Create Bin Content';
                    Image = CreateBinContent;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        BinCreateLine.Copy(Rec);
                        Codeunit.Run(Codeunit::"Bin Content Create",Rec);
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
                    BinCreateLine.SetRange(Type,BinCreateLine.Type::"Bin Content");
                    Report.Run(Report::"Bin Content Create Wksh Report",true,false,BinCreateLine);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        BinCreateLine.GetItemDescr("Item No.","Variant Code",ItemDescription);
        BinCreateLine.GetUnitOfMeasureDescr("Unit of Measure Code",UOMDescription);
        BinCode := "Bin Code";
    end;

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
        BinCreateLine.TemplateSelection(Page::"Bin Content Creation Worksheet",1,Rec,WkshSelected);
        if not WkshSelected then
          Error('');
        BinCreateLine.OpenWksh(CurrentJnlBatchName,CurrentLocationCode,Rec);
    end;

    var
        BinCreateLine: Record "Bin Creation Worksheet Line";
        CurrentLocationCode: Code[10];
        CurrentJnlBatchName: Code[10];
        BinCode: Code[20];
        ItemDescription: Text[50];
        UOMDescription: Text[50];
        OpenedFromBatch: Boolean;

    local procedure BinCodeOnAfterValidate()
    begin
        BinCreateLine.GetItemDescr("Item No.","Variant Code",ItemDescription);
        BinCreateLine.GetUnitOfMeasureDescr("Unit of Measure Code",UOMDescription);
        BinCode := "Bin Code";
    end;

    local procedure VariantCodeOnAfterValidate()
    begin
        BinCreateLine.GetItemDescr("Item No.","Variant Code",ItemDescription);
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        BinCreateLine.SetName(CurrentJnlBatchName,CurrentLocationCode,Rec);
        CurrPage.Update(false);
    end;
}

