#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 741 "VAT Report Subform"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = ListPart;
    SourceTable = "VAT Report Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which general product posting group was used when the Tax entry was posted.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the posting date of the document that resulted in the Tax entry.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number that resulted in the Tax entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the document that resulted in the Tax entry.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the Tax entry.';
                }
                field(Base;Base)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that the Tax amount in the Amount is calculated from.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax amount for the report line. This is calculated based on the value of the Base field.';

                    trigger OnAssistEdit()
                    var
                        VATReportLineRelation: Record "VAT Report Line Relation";
                        VATEntry: Record "VAT Entry";
                        FilterText: Text[1024];
                        TableNo: Integer;
                    begin
                        FilterText := VATReportLineRelation.CreateFilterForAmountMapping("VAT Report No.","Line No.",TableNo);
                        case TableNo of
                          Database::"VAT Entry":
                            begin
                              VATEntry.SetFilter("Entry No.",FilterText);
                              Page.RunModal(0,VATEntry);
                            end;
                        end;
                    end;
                }
                field("VAT Calculation Type";"VAT Calculation Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which VAT calculation type was used when the tax entry was posted.';
                }
                field("Bill-to/Pay-to No.";"Bill-to/Pay-to No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the customer or vendor that the entry is linked to.';
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the entry was part of a 3-party trade.';
                }
                field("Source Code";"Source Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the source code of the Tax entry.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the reason code of the Tax entry.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("Internal Ref. No.";"Internal Ref. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the internal reference number of the Tax entry.';
                }
                field("Unrealized Amount";"Unrealized Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unrealized tax amount for this line if you use unrealized tax.';
                }
                field("Unrealized Base";"Unrealized Base")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unrealized base amount if you use unrealized tax.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the external document number of the tax entry.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which Tax business posting group was used when the tax entry was posted.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which Tax product posting group was used when the tax entry was posted.';
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the tax registration number of the customer or vendor that the tax entry is linked to.';
                }
            }
        }
    }

    actions
    {
    }
}

