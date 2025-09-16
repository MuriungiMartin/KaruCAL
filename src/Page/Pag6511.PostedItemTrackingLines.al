#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6511 "Posted Item Tracking Lines"
{
    Caption = 'Posted Item Tracking Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Item Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a serial number if the posted item carries such a number.';
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a lot number if the posted item carries such a number.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of units of the item in the item entry.';
                }
                field("Shipped Qty. Not Returned";"Shipped Qty. Not Returned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity for this item ledger entry that was shipped and has not yet been returned.';
                    Visible = false;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last day of warranty for the item on the line.';
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date that the item on the line can be used.';
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
    }

    trigger OnOpenPage()
    var
        CaptionText1: Text[100];
        CaptionText2: Text[100];
    begin
        CaptionText1 := "Item No.";
        if CaptionText1 <> '' then begin
          CaptionText2 := CurrPage.Caption;
          CurrPage.Caption := StrSubstNo(Text001,CaptionText1,CaptionText2);
        end;
    end;

    var
        Text001: label '%1 - %2', Locked=true;
}

