#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 475 "VAT Statement Preview Line"
{
    Caption = 'Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "VAT Statement Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Row No.";"Row No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number that identifies this row.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the VAT statement line.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies what the VAT statement line will include.';
                }
                field("Amount Type";"Amount Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the Tax statement line shows the Tax amounts, or the base amounts on which the Tax is calculated.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a tax business posting group code for the VAT statement.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a tax product posting group code for the VAT Statement.';
                }
                field("Tax Jurisdiction Code";"Tax Jurisdiction Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a tax jurisdiction code for the statement.';
                    Visible = false;
                }
                field("Use Tax";"Use Tax")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether to use only entries from the Tax Entry table that are marked as Use Tax to be totaled on this line.';
                    Visible = false;
                }
                field(ColumnValue;ColumnValue)
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Column Amount';
                    DrillDown = true;
                    ToolTip = 'Specifies the type of entries that will be included in the amounts in columns.';

                    trigger OnDrillDown()
                    begin
                        case Type of
                          Type::"Account Totaling":
                            begin
                              GLEntry.SetFilter("G/L Account No.","Account Totaling");
                              Copyfilter("Date Filter",GLEntry."Posting Date");
                              Page.Run(Page::"General Ledger Entries",GLEntry);
                            end;
                          Type::"VAT Entry Totaling":
                            begin
                              VATEntry.Reset;
                              if not
                                 VATEntry.SetCurrentkey(
                                   Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
                              then
                                VATEntry.SetCurrentkey(
                                  Type,Closed,"Tax Jurisdiction Code","Use Tax","Posting Date");
                              VATEntry.SetRange(Type,"Gen. Posting Type");
                              VATEntry.SetRange("VAT Bus. Posting Group","VAT Bus. Posting Group");
                              VATEntry.SetRange("VAT Prod. Posting Group","VAT Prod. Posting Group");
                              VATEntry.SetRange("Tax Jurisdiction Code","Tax Jurisdiction Code");
                              VATEntry.SetRange("Use Tax","Use Tax");
                              if GetFilter("Date Filter") <> '' then
                                if PeriodSelection = Periodselection::"Before and Within Period" then
                                  VATEntry.SetRange("Posting Date",0D,GetRangemax("Date Filter"))
                                else
                                  Copyfilter("Date Filter",VATEntry."Posting Date");
                              case Selection of
                                Selection::Open:
                                  VATEntry.SetRange(Closed,false);
                                Selection::Closed:
                                  VATEntry.SetRange(Closed,true);
                                Selection::"Open and Closed":
                                  VATEntry.SetRange(Closed);
                              end;
                              Page.Run(Page::"VAT Entries",VATEntry);
                            end;
                          Type::"Row Totaling",
                          Type::Description:
                            Error(Text000,FieldCaption(Type),Type);
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        VATStatement.CalcLineTotal(Rec,ColumnValue,0);
        if "Print with" = "print with"::"Opposite Sign" then
          ColumnValue := -ColumnValue;
    end;

    var
        Text000: label 'Drilldown is not possible when %1 is %2.';
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        VATStatement: Report "VAT Statement";
        ColumnValue: Decimal;
        Selection: Option Open,Closed,"Open and Closed";
        PeriodSelection: Option "Before and Within Period","Within Period";
        UseAmtsInAddCurr: Boolean;


    procedure UpdateForm(var VATStmtName: Record "VAT Statement Name";NewSelection: Option Open,Closed,"Open and Closed";NewPeriodSelection: Option "Before and Within Period","Within Period";NewUseAmtsInAddCurr: Boolean)
    begin
        SetRange("Statement Template Name",VATStmtName."Statement Template Name");
        SetRange("Statement Name",VATStmtName.Name);
        VATStmtName.Copyfilter("Date Filter","Date Filter");
        Selection := NewSelection;
        PeriodSelection := NewPeriodSelection;
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
        VATStatement.InitializeRequest(VATStmtName,Rec,Selection,PeriodSelection,false,UseAmtsInAddCurr);
        CurrPage.Update;
    end;
}

