#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5823 "G/L - Item Ledger Relation"
{
    Caption = 'G/L - Item Ledger Relation';
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "G/L - Item Ledger Relation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("ValueEntry.""Posting Date""";ValueEntry."Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date that represents the relation.';
                }
                field("ValueEntry.""Item No.""";ValueEntry."Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item No.';
                    ToolTip = 'Specifies the item number that represents the relation.';
                }
                field("FORMAT(ValueEntry.""Source Type"")";Format(ValueEntry."Source Type"))
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source Type';
                    ToolTip = 'Specifies the source type that represents the relation.';
                }
                field("ValueEntry.""Source No.""";ValueEntry."Source No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source No.';
                    ToolTip = 'Specifies the source number that represents the relation.';
                }
                field("ValueEntry.""External Document No.""";ValueEntry."External Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'External Document No.';
                    Visible = false;
                }
                field("FORMAT(ValueEntry.""Document Type"")";Format(ValueEntry."Document Type"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Type';
                    Visible = false;
                }
                field("ValueEntry.""Document No.""";ValueEntry."Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document that represents the relation.';
                }
                field("ValueEntry.""Document Line No.""";ValueEntry."Document Line No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Line No.';
                    Visible = false;
                }
                field("ValueEntry.Description";ValueEntry.Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the document that represents the relation.';
                }
                field("ValueEntry.""Location Code""";ValueEntry."Location Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Location Code';
                }
                field("ValueEntry.""Inventory Posting Group""";ValueEntry."Inventory Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Inventory Posting Group';
                    ToolTip = 'Specifies the inventory posting group that represents the relation.';
                }
                field("ValueEntry.""Gen. Bus. Posting Group""";ValueEntry."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gen. Bus. Posting Group';
                    ToolTip = 'Specifies the general business posting group that represents the relation.';
                }
                field("ValueEntry.""Gen. Prod. Posting Group""";ValueEntry."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gen. Prod. Posting Group';
                    ToolTip = 'Specifies the general product posting group that represents the relation.';
                }
                field("ValueEntry.""Source Posting Group""";ValueEntry."Source Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Source Posting Group';
                    ToolTip = 'Specifies the source posting group that represents the relation.';
                }
                field("FORMAT(ValueEntry.""Item Ledger Entry Type"")";Format(ValueEntry."Item Ledger Entry Type"))
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entry Type';
                    ToolTip = 'Specifies the item ledger entry type that represents the relation.';
                }
                field("ValueEntry.""Item Ledger Entry No.""";ValueEntry."Item Ledger Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entry No.';
                    ToolTip = 'Specifies the item ledger entry number that represents the relation.';
                }
                field("ValueEntry.""Valued Quantity""";ValueEntry."Valued Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Valued Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the valued quantity that represents the relation.';
                }
                field("ValueEntry.""Item Ledger Entry Quantity""";ValueEntry."Item Ledger Entry Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entry Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the item ledger entry quantity that represents the relation.';
                }
                field("ValueEntry.""Invoiced Quantity""";ValueEntry."Invoiced Quantity")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoiced Quantity';
                    DecimalPlaces = 0:5;
                    ToolTip = 'Specifies the invoiced quantity that represents the relation.';
                }
                field("ValueEntry.""Cost per Unit""";ValueEntry."Cost per Unit")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cost per Unit';
                    ToolTip = 'Specifies the cost per unit that represents the relation.';
                }
                field("ValueEntry.""User ID""";ValueEntry."User ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'User ID';
                    Visible = false;
                }
                field("ValueEntry.""Source Code""";ValueEntry."Source Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Code';
                    Visible = false;
                }
                field("ValueEntry.""Cost Amount (Actual)""";ValueEntry."Cost Amount (Actual)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost Amount (Actual)';
                    ToolTip = 'Specifies the sum of the actual cost amounts posted for the item ledger entries';
                }
                field("ValueEntry.""Cost Posted to G/L""";ValueEntry."Cost Posted to G/L")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost Posted to G/L';
                    ToolTip = 'Specifies the amount that has been posted to the general ledger.';
                }
                field("ValueEntry.""Cost Amount (Actual) (ACY)""";ValueEntry."Cost Amount (Actual) (ACY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Amount (Actual) (ACY)';
                    Visible = false;
                }
                field("ValueEntry.""Cost Posted to G/L (ACY)""";ValueEntry."Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = Basic,Suite;
                    AutoFormatType = 1;
                    Caption = 'Cost Posted to G/L (ACY)';
                    ToolTip = 'Specifies the amount that has been posted to the general ledger shown in the additional reporting currency.';
                }
                field("ValueEntry.""Cost per Unit (ACY)""";ValueEntry."Cost per Unit (ACY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 2;
                    Caption = 'Cost per Unit (ACY)';
                    Visible = false;
                }
                field("ValueEntry.""Global Dimension 1 Code""";ValueEntry."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,1,1';
                    Caption = 'Global Dimension 1 Code';
                    Visible = false;
                }
                field("ValueEntry.""Global Dimension 2 Code""";ValueEntry."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,1,2';
                    Caption = 'Global Dimension 2 Code';
                    Visible = false;
                }
                field("ValueEntry.""Expected Cost""";ValueEntry."Expected Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Expected Cost';
                    Visible = false;
                }
                field("ValueEntry.""Item Charge No.""";ValueEntry."Item Charge No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Charge No.';
                    Visible = false;
                }
                field("FORMAT(ValueEntry.""Entry Type"")";Format(ValueEntry."Entry Type"))
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Entry Type';
                    ToolTip = 'Specifies the entry type that represents the relation.';
                }
                field("FORMAT(ValueEntry.""Variance Type"")";Format(ValueEntry."Variance Type"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Variance Type';
                    Visible = false;
                }
                field("ValueEntry.""Cost Amount (Expected)""";ValueEntry."Cost Amount (Expected)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Amount (Expected)';
                    Visible = false;
                }
                field("ValueEntry.""Cost Amount (Expected) (ACY)""";ValueEntry."Cost Amount (Expected) (ACY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Cost Amount (Expected) (ACY)';
                    Visible = false;
                }
                field("ValueEntry.""Expected Cost Posted to G/L""";ValueEntry."Expected Cost Posted to G/L")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Expected Cost Posted to G/L';
                    Visible = false;
                }
                field("ValueEntry.""Exp. Cost Posted to G/L (ACY)""";ValueEntry."Exp. Cost Posted to G/L (ACY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Exp. Cost Posted to G/L (ACY)';
                    Visible = false;
                }
                field("ValueEntry.""Variant Code""";ValueEntry."Variant Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Variant Code';
                    Visible = false;
                }
                field("ValueEntry.Adjustment";ValueEntry.Adjustment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjustment';
                    Visible = false;
                }
                field("ValueEntry.""Capacity Ledger Entry No.""";ValueEntry."Capacity Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Capacity Ledger Entry No.';
                    Visible = false;
                }
                field("FORMAT(ValueEntry.Type)";Format(ValueEntry.Type))
                {
                    ApplicationArea = Basic;
                    Caption = 'Type';
                    Visible = false;
                }
                field("G/L Entry No.";"G/L Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the general ledger entry where cost from the associated value entry number in this record is posted.';
                }
                field("Value Entry No.";"Value Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the value entry that has its cost posted in the associated general ledger entry in this record.';
                }
                field("G/L Register No.";"G/L Register No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the general ledger register, where the general ledger entry in this record was posted.';
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
        area(navigation)
        {
            group("Value Ent&ry")
            {
                Caption = 'Value Ent&ry';
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
                        ValueEntry.ShowDimensions;
                    end;
                }
                action("General Ledger")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'General Ledger';
                    Image = GLRegisters;
                    ToolTip = 'Open the general ledger.';

                    trigger OnAction()
                    begin
                        ValueEntry.ShowGL;
                    end;
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
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc(ValueEntry."Posting Date",ValueEntry."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if not ValueEntry.Get("Value Entry No.") then
          ValueEntry.Init;
    end;

    var
        ValueEntry: Record "Value Entry";

    local procedure GetCaption(): Text[250]
    var
        GLRegister: Record "G/L Register";
    begin
        exit(StrSubstNo('%1 %2',GLRegister.TableCaption,GetFilter("G/L Register No.")));
    end;
}

