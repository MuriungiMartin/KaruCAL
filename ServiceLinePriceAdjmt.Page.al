#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6084 "Service Line Price Adjmt."
{
    Caption = 'Service Line Price Adjmt.';
    DataCaptionFields = "Document Type","Document No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Service Line Price Adjmt.";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the service item that is registered in the Service Item table.';
                }
                field("ServItemLine.Description";ServItemLine.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                    ToolTip = 'Specifies the description of the service item for which the price is going to be adjusted.';
                }
                field("Service Price Group Code";"Service Price Group Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Price Group Code';
                    Editable = false;
                    ToolTip = 'Specifies the code of the service price adjustment group associated with the service item on this line.';
                }
                field("Serv. Price Adjmt. Gr. Code";"Serv. Price Adjmt. Gr. Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the service price adjustment group that applies to the posted service line.';
                }
                field("Adjustment Type";"Adjustment Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjustment Type';
                    Editable = false;
                    ToolTip = 'Specifies the adjustment type for this line.';
                }
            }
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of this line, which can be item, resource, cost, or general ledger Account.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item, resource, or service cost specified in the Type field.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item, resource, or service cost, of which the price is going to be adjusted.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the service line that will be adjusted.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit price of the item, resource, or cost on the service line.';
                }
                field("New Unit Price";"New Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit price of the item, resource, or cost specified on the service line.';

                    trigger OnValidate()
                    begin
                        NewUnitPriceOnAfterValidate;
                    end;
                }
                field("Discount %";"Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount percentage you want to provide on the amount on the corresponding service line.';
                }
                field("Discount Amount";"Discount Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount you want to provide on the amount on this service line.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total net amount on the service line.';
                }
                field("New Amount";"New Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the amount to invoice.';

                    trigger OnValidate()
                    begin
                        NewAmountOnAfterValidate;
                    end;
                }
                field("Amount incl. VAT";"Amount incl. VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total amount that the service line is going to be adjusted, including Tax.';
                }
                field("New Amount incl. VAT";"New Amount incl. VAT")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a new amount, including Tax.';

                    trigger OnValidate()
                    begin
                        NewAmountinclVATOnAfterValidat;
                    end;
                }
            }
            group(Control2)
            {
                fixed(Control1900116601)
                {
                    group(Total)
                    {
                        Caption = 'Total';
                        field(TotalAmount;TotalAmount)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Amount';
                            Editable = false;
                            ToolTip = 'Specifies the total amount that the service lines will be adjusted to.';
                        }
                    }
                    group("To Adjust")
                    {
                        Caption = 'To Adjust';
                        field(AmountToAdjust;AmountToAdjust)
                        {
                            ApplicationArea = Basic;
                            Caption = 'To Adjust';
                            Editable = false;
                            ToolTip = 'Specifies the total value of the service lines that need to be adjusted.';
                        }
                    }
                    group(Remaining)
                    {
                        Caption = 'Remaining';
                        field(Control3;Remaining)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Remaining';
                            Editable = false;
                            ToolTip = 'Specifies the difference between the total amount that the service lines will be adjusted to, and actual total value of the service lines.';
                        }
                    }
                    group("Incl. Tax")
                    {
                        Caption = 'Incl. Tax';
                        field(InclVat;InclVat)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Incl. Tax';
                            Editable = false;
                            ToolTip = 'Specifies that the amount of the service lines includes Tax.';
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
                action("Adjust Service Price")
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjust Service Price';
                    Image = PriceAdjustment;

                    trigger OnAction()
                    var
                        ServHeader: Record "Service Header";
                        ServPriceGrSetup: Record "Serv. Price Group Setup";
                        ServInvLinePriceAdjmt: Record "Service Line Price Adjmt.";
                        ServPriceMgmt: Codeunit "Service Price Management";
                    begin
                        ServHeader.Get("Document Type","Document No.");
                        ServItemLine.Get("Document Type","Document No.","Service Item Line No.");
                        ServPriceMgmt.GetServPriceGrSetup(ServPriceGrSetup,ServHeader,ServItemLine);
                        ServInvLinePriceAdjmt := Rec;
                        ServPriceMgmt.AdjustLines(ServInvLinePriceAdjmt,ServPriceGrSetup);
                        UpdateAmounts;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateAmounts;
    end;

    trigger OnOpenPage()
    begin
        OKPressed := false;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          OKOnPush;
        if not OKPressed then
          if not Confirm(Text001,false) then
            exit(false);
        exit(true);
    end;

    var
        ServItemLine: Record "Service Item Line";
        ServInvLinePriceAdjmt: Record "Service Line Price Adjmt.";
        TotalAmount: Decimal;
        AmountToAdjust: Decimal;
        Remaining: Decimal;
        InclVat: Boolean;
        OKPressed: Boolean;
        Text001: label 'Cancel price adjustment?';


    procedure SetVars(SetTotalAmount: Decimal;SetInclVat: Boolean)
    begin
        TotalAmount := SetTotalAmount;
        InclVat := SetInclVat;
    end;


    procedure UpdateAmounts()
    begin
        if not ServItemLine.Get("Document Type","Document No.","Service Item Line No.") then
          Clear(ServItemLine);
        ServInvLinePriceAdjmt := Rec;
        ServInvLinePriceAdjmt.Reset;
        ServInvLinePriceAdjmt.SetRange("Document Type","Document Type");
        ServInvLinePriceAdjmt.SetRange("Document No.","Document No.");
        ServInvLinePriceAdjmt.SetRange("Service Item Line No.","Service Item Line No.");
        ServInvLinePriceAdjmt.CalcSums("New Amount","New Amount incl. VAT","New Amount Excl. VAT");
        if InclVat then begin
          AmountToAdjust := ServInvLinePriceAdjmt."New Amount incl. VAT";
          Remaining := TotalAmount - ServInvLinePriceAdjmt."New Amount incl. VAT";
        end else begin
          AmountToAdjust := ServInvLinePriceAdjmt."New Amount Excl. VAT";
          Remaining := TotalAmount - ServInvLinePriceAdjmt."New Amount Excl. VAT";
        end;
    end;

    local procedure NewUnitPriceOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure NewAmountOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure NewAmountinclVATOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure OKOnPush()
    begin
        OKPressed := true;
    end;
}

