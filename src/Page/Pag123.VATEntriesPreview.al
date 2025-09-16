#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 123 "VAT Entries Preview"
{
    Caption = 'Tax Entries Preview';
    Editable = false;
    PageType = List;
    SourceTable = "VAT Entry";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the general business posting group that was used when the Tax entry was posted.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the general product posting group that was used when the Tax entry was posted.';
                    Visible = false;
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax business posting group code that was used when the entry was posted.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax product posting group code that was used when the entry was posted.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Tax entry''s posting date.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on the document that provided the basis for this Tax entry.';
                    Visible = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document number on the Tax entry.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the document type that the Tax entry belongs to.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the Tax entry.';
                }
                field(Base;Base)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount that the Tax amount (the amount shown in the Amount field) is calculated from.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the amount of the Tax entry in $.';
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax difference that arises when you make a correction to a Tax amount on a sales or purchase document.';
                    Visible = false;
                }
                field("Additional-Currency Base";"Additional-Currency Base")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount that the tax amount is calculated from if you post in an additional reporting currency.';
                    Visible = false;
                }
                field("Additional-Currency Amount";"Additional-Currency Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount of the Tax entry. The amount is in the additional reporting currency.';
                    Visible = false;
                }
                field("Add.-Curr. VAT Difference";"Add.-Curr. VAT Difference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies (in the additional reporting currency) the Tax difference that arises when you make a correction to a Tax amount on a sales or purchase document.';
                    Visible = false;
                }
                field("VAT Calculation Type";"VAT Calculation Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which Tax calculation type was used when this entry was posted.';
                }
                field("Bill-to/Pay-to No.";"Bill-to/Pay-to No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the customer or vendor that the entry is linked to.';
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax registration number of the customer or vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Ship-to/Order Address Code";"Ship-to/Order Address Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether the entry was part of a 3-party trade.';
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the Tax entry has been closed by the Calc. and Post Tax Settlement batch job.';
                }
                field("Closed by Entry No.";"Closed by Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the Tax entry that has closed the entry, if the Tax entry was closed with the Calc. and Post Tax Settlement batch job.';
                }
                field("Internal Ref. No.";"Internal Ref. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the internal reference number for the line.';
                }
                field(Reversed;Reversed)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the entry has been part of a reverse transaction.';
                    Visible = false;
                }
                field("Reversed by Entry No.";"Reversed by Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the correcting entry. If the field Specifies a number, the entry cannot be reversed again.';
                    Visible = false;
                }
                field("Reversed Entry No.";"Reversed Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the original entry that was undone by the reverse transaction.';
                    Visible = false;
                }
                field("EU Service";"EU Service")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if this tax entry is to be reported as a service in the periodic tax reports.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure Set(var TempVATEntry: Record "VAT Entry" temporary)
    begin
        if TempVATEntry.FindSet then
          repeat
            Rec := TempVATEntry;
            Insert;
          until TempVATEntry.Next = 0;
    end;
}

