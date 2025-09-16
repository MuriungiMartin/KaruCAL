#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 755 "Standard Item Journal Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Standard Item Journal Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies which type of transaction that the entry is created from.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item on the journal line.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the description of the item on the line.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the item journal line is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code that the item journal line is linked to.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateSaveShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(4),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateSaveShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(5),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateSaveShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(6),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateSaveShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(7),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateSaveShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(8),
                                                                  "Dimension Value Type"=const(Standard),
                                                                  Blocked=const(false));
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ValidateSaveShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code for the item on the line.';
                }
                field("Bin Code";"Bin Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin code for the items on the line.';
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting group of the master record on the journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general product account in the general ledger to which transactions involving the item are posted.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the quantity of the item in the journal line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a unit of measure code that has been set up in the Unit of Measure table.';
                }
                field("Unit Amount";"Unit Amount")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount of the unit in the line of the journal line.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount of the unit in the line of the journal line.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item indirect cost.';
                    Visible = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the cost of the unit in the line of the journal line.';
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transaction type of the item journal line.';
                    Visible = false;
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the transport method used for the item.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the item.';
                    Visible = false;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the template that is the source of the journal line.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Entry Type" := xRec."Entry Type";
        Clear(ShortcutDimCode);
        "Source Code" := GetSourceCodeFromJnlTemplate;
    end;

    var
        ShortcutDimCode: array [8] of Code[20];

    local procedure GetSourceCodeFromJnlTemplate(): Code[10]
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        ItemJnlTemplate.Get("Journal Template Name");
        exit(ItemJnlTemplate."Source Code");
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SaveRecord;
    end;
}

