#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 284 Allocations
{
    AutoSplitKey = true;
    Caption = 'Allocations';
    DataCaptionFields = "Journal Batch Name";
    PageType = Worksheet;
    SourceTable = "Gen. Jnl. Allocation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the account number that the allocation will be posted to.';

                    trigger OnValidate()
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the account that the allocation will be posted to.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code posted to the allocation.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code posted to the allocation.';
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
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
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
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
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
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
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
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
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
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
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
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general posting type that applies to the entry on the allocation journal line.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general business posting group that will be used when you post the entry on the journal line.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the general product posting group that will be used when you post the entry on the journal line.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax business posting group code that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the Tax product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Allocation Quantity";"Allocation Quantity")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the quantity that will be used to calculate the amount in the allocation journal line.';

                    trigger OnValidate()
                    begin
                        AllocationQuantityOnAfterValid;
                    end;
                }
                field("Allocation %";"Allocation %")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the percentage that will be used to calculate the amount in the allocation journal line.';

                    trigger OnValidate()
                    begin
                        Allocation37OnAfterValidate;
                    end;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the amount that will be posted from the allocation journal line.';

                    trigger OnValidate()
                    begin
                        AmountOnAfterValidate;
                    end;
                }
            }
            group(Control18)
            {
                fixed(Control1902205101)
                {
                    group(Control1903867001)
                    {
                        Caption = 'Amount';
                        field("AllocationAmount + Amount - xRec.Amount";AllocationAmount + Amount - xRec.Amount)
                        {
                            ApplicationArea = All;
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'AllocationAmount';
                            Editable = false;
                            ToolTip = 'Specifies the total amount that has been entered in the allocation journal up to the line where the cursor is.';
                            Visible = AllocationAmountVisible;
                        }
                    }
                    group("Total Amount")
                    {
                        Caption = 'Total Amount';
                        field(TotalAllocationAmount;TotalAllocationAmount + Amount - xRec.Amount)
                        {
                            ApplicationArea = All;
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                            Caption = 'Total Amount';
                            Editable = false;
                            ToolTip = 'Specifies the total amount that is allocated in the allocation journal.';
                            Visible = TotalAllocationAmountVisible;
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
        area(navigation)
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
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "G/L Account Card";
                    RunPageLink = "No."=field("Account No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or change detailed information about the allocation.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Suite;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "General Ledger Entries";
                    RunPageLink = "G/L Account No."=field("Account No.");
                    RunPageView = sorting("G/L Account No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateAllocationAmount;
    end;

    trigger OnAfterGetRecord()
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInit()
    begin
        TotalAllocationAmountVisible := true;
        AllocationAmountVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateAllocationAmount;
        Clear(ShortcutDimCode);
    end;

    var
        AllocationAmount: Decimal;
        TotalAllocationAmount: Decimal;
        ShowAllocationAmount: Boolean;
        ShowTotalAllocationAmount: Boolean;
        ShortcutDimCode: array [8] of Code[20];
        [InDataSet]
        AllocationAmountVisible: Boolean;
        [InDataSet]
        TotalAllocationAmountVisible: Boolean;

    local procedure UpdateAllocationAmount()
    var
        TempGenJnlAlloc: Record "Gen. Jnl. Allocation";
    begin
        TempGenJnlAlloc.CopyFilters(Rec);
        ShowTotalAllocationAmount := TempGenJnlAlloc.CalcSums(Amount);
        if ShowTotalAllocationAmount then begin
          TotalAllocationAmount := TempGenJnlAlloc.Amount;
          if "Line No." = 0 then
            TotalAllocationAmount := TotalAllocationAmount + xRec.Amount;
        end;

        if "Line No." <> 0 then begin
          TempGenJnlAlloc.SetRange("Line No.",0,"Line No.");
          ShowAllocationAmount := TempGenJnlAlloc.CalcSums(Amount);
          if ShowAllocationAmount then
            AllocationAmount := TempGenJnlAlloc.Amount;
        end else begin
          TempGenJnlAlloc.SetRange("Line No.",0,xRec."Line No.");
          ShowAllocationAmount := TempGenJnlAlloc.CalcSums(Amount);
          if ShowAllocationAmount then begin
            AllocationAmount := TempGenJnlAlloc.Amount;
            TempGenJnlAlloc.CopyFilters(Rec);
            TempGenJnlAlloc := xRec;
            if TempGenJnlAlloc.Next = 0 then
              AllocationAmount := AllocationAmount + xRec.Amount;
          end;
        end;

        AllocationAmountVisible := ShowAllocationAmount;
        TotalAllocationAmountVisible := ShowTotalAllocationAmount;
    end;

    local procedure AllocationQuantityOnAfterValid()
    begin
        CurrPage.Update(false);
    end;

    local procedure Allocation37OnAfterValidate()
    begin
        CurrPage.Update(false);
    end;

    local procedure AmountOnAfterValidate()
    begin
        CurrPage.Update(false);
    end;
}

