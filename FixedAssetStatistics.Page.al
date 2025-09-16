#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5602 "Fixed Asset Statistics"
{
    Caption = 'Fixed Asset Statistics';
    DataCaptionExpression = Caption;
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "FA Depreciation Book";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Acquisition Date";"Acquisition Date")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Acquisition Date';
                    ToolTip = 'Specifies the FA posting date of the first posted acquisition cost.';
                }
                field(Text000;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                field("G/L Acquisition Date";"G/L Acquisition Date")
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'G/L Acquisition Date';
                    ToolTip = 'Specifies the G/L posting date of the first posted acquisition cost.';
                }
                field(Control9;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                field(Control10;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                field(Disposed;Disposed)
                {
                    ApplicationArea = FixedAssets;
                    Caption = 'Disposed Of';
                    ToolTip = 'Specifies whether the fixed asset has been disposed of.';
                }
                field("Disposal Date";"Disposal Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the FA posting date of the first posted disposal amount.';
                    Visible = DisposalDateVisible;
                }
                field(Control11;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                field("Proceeds on Disposal";"Proceeds on Disposal")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total proceeds on disposal for the fixed asset as a FlowField.';
                    Visible = ProceedsOnDisposalVisible;
                }
                field(Control12;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                field("Gain/Loss";"Gain/Loss")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total gain (credit) or loss (debit) for the fixed asset as a FlowField.';
                    Visible = GainLossVisible;
                }
                field(Control13;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                field(DisposalValue;BookValueAfterDisposal)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Book Value after Disposal';
                    Editable = false;
                    ToolTip = 'Specifies the total $ amount of entries posted with the Book Value on Disposal posting type. Entries of this kind are created when you post disposal of a fixed asset to a depreciation book where the Gross method has been selected in the Disposal Calculation Method field.';
                    Visible = DisposalValueVisible;

                    trigger OnDrillDown()
                    begin
                        ShowBookValueAfterDisposal;
                    end;
                }
                field(Control14;Text000)
                {
                    ApplicationArea = FixedAssets;
                    Visible = false;
                }
                fixed(Control1903895301)
                {
                    group("Last FA Posting Date")
                    {
                        Caption = 'Last FA Posting Date';
                        field("Last Acquisition Cost Date";"Last Acquisition Cost Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Acquisition Cost';
                            ToolTip = 'Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.';
                        }
                        field("Last Depreciation Date";"Last Depreciation Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Depreciation';
                            ToolTip = 'Specifies the FA posting date of the last posted depreciation.';
                        }
                        field("Last Write-Down Date";"Last Write-Down Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Write-Down';
                            ToolTip = 'Specifies the FA posting date of the last posted write-down.';
                        }
                        field("Last Appreciation Date";"Last Appreciation Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Appreciation';
                            ToolTip = 'Specifies the sum that applies to appreciations.';
                        }
                        field("Last Custom 1 Date";"Last Custom 1 Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Custom 1';
                            ToolTip = 'Specifies the FA posting date of the last posted custom 1 entry.';
                        }
                        field("Book Value";Text000)
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Book Value';
                            ToolTip = 'Specifies the sum that applies to book values.';
                            Visible = false;
                        }
                        field("Last Salvage Value Date";"Last Salvage Value Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Salvage Value';
                            ToolTip = 'Specifies if related salvage value entries are included in the batch job .';
                        }
                        field("Depreciable Basis";Text000)
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Depreciable Basis';
                            ToolTip = 'Specifies the depreciable basis amount for the fixed asset. This is calculated based on the amounts in those FA ledger entries that are included in the depreciable basis.';
                            Visible = false;
                        }
                        field("Last Custom 2 Date";"Last Custom 2 Date")
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Custom 2';
                            ToolTip = 'Specifies the FA posting date of the last posted custom 2 entry.';
                        }
                        field(Maintenance;Text000)
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Maintenance';
                            ToolTip = 'Specifies the total maintenance cost for the fixed asset. This is calculated from the maintenance ledger entries.';
                            Visible = false;
                        }
                    }
                    group(Amount)
                    {
                        Caption = 'Amount';
                        field("Acquisition Cost";"Acquisition Cost")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total acquisition cost for the fixed asset as a FlowField.';
                        }
                        field(Depreciation;Depreciation)
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total depreciation for the fixed asset as a FlowField.';
                        }
                        field("Write-Down";"Write-Down")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total $ amount of write-down entries for the fixed asset as a FlowField.';
                        }
                        field(Appreciation;Appreciation)
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total appreciation for the fixed asset as a FlowField.';
                        }
                        field("Custom 1";"Custom 1")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total $ amount for custom 1 entries for the fixed asset as a FlowField.';
                        }
                        field(Control34;"Book Value")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the book value for the fixed asset as a FlowField.';
                        }
                        field("Salvage Value";"Salvage Value")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the salvage value for the fixed asset.';
                        }
                        field(Control38;"Depreciable Basis")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the depreciable basis amount for the fixed asset as a FlowField.';
                        }
                        field("Custom 2";"Custom 2")
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total $ amount for custom 2 entries for the fixed asset as a FlowField.';
                        }
                        field(Control43;Maintenance)
                        {
                            ApplicationArea = FixedAssets;
                            ToolTip = 'Specifies the total maintenance cost for the fixed asset as a FlowField.';
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Disposed := "Disposal Date" > 0D;
        DisposalValueVisible := Disposed;
        ProceedsOnDisposalVisible := Disposed;
        GainLossVisible := Disposed;
        DisposalDateVisible := Disposed;
        CalcBookValue;
    end;

    trigger OnInit()
    begin
        DisposalDateVisible := true;
        GainLossVisible := true;
        ProceedsOnDisposalVisible := true;
        DisposalValueVisible := true;
    end;

    var
        Disposed: Boolean;
        BookValueAfterDisposal: Decimal;
        Text000: label 'Placeholder';
        [InDataSet]
        DisposalValueVisible: Boolean;
        [InDataSet]
        ProceedsOnDisposalVisible: Boolean;
        [InDataSet]
        GainLossVisible: Boolean;
        [InDataSet]
        DisposalDateVisible: Boolean;
}

