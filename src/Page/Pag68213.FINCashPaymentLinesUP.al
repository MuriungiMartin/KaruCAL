#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68213 "FIN-Cash Payment Lines UP"
{
    PageType = ListPart;
    SourceTable = UnknownTable61705;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        //check if the payment reference is for farmer purchase
                        if "Payment Reference"="payment reference"::"Farmer Purchase" then
                          begin
                            if Amount<>xRec.Amount then
                              begin
                                Error('Amount cannot be modified');
                              end;
                          end;

                        "Amount With VAT":=Amount;
                        if "Account Type" in ["account type"::Customer,"account type"::Vendor,
                        "account type"::"G/L Account","account type"::"Bank Account","account type"::"Fixed Asset"] then

                        case "Account Type" of
                          "account type"::"G/L Account":
                            begin

                        TestField(Amount);
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Code,Type);
                        RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Payment);
                        if RecPayTypes.Find('-') then begin
                        if RecPayTypes."VAT Chargeable"=RecPayTypes."vat chargeable"::Yes then
                          begin
                            RecPayTypes.TestField(RecPayTypes."VAT Code");
                            TarriffCodes.Reset;
                            TarriffCodes.SetRange(TarriffCodes.Code,RecPayTypes."VAT Code");
                            if TarriffCodes.Find('-') then
                              begin
                                "VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                                "VAT Amount":=(Amount/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage);
                              end;
                          end
                        else
                          begin
                            "VAT Amount":=0;
                          end;

                        if RecPayTypes."Withholding Tax Chargeable"=RecPayTypes."withholding tax chargeable"::Yes then
                          begin
                            RecPayTypes.TestField(RecPayTypes."Withholding Tax Code");
                            TarriffCodes.Reset;
                            TarriffCodes.SetRange(TarriffCodes.Code,RecPayTypes."Withholding Tax Code");
                            if TarriffCodes.Find('-') then
                              begin
                                "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*Amount;
                                "Withholding Tax Amount":=(Amount-"VAT Amount")*(TarriffCodes.Percentage/100);
                              end;
                          end
                        else
                          begin
                            "Withholding Tax Amount":=0;
                          end;
                        end;
                        end;
                          "account type"::Customer:
                            begin

                        TestField(Amount);
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Code,Type);
                        RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Payment);
                        if RecPayTypes.Find('-') then begin
                        if RecPayTypes."VAT Chargeable"=RecPayTypes."vat chargeable"::Yes then begin
                        TestField("VAT Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,"VAT Code");
                        if TarriffCodes.Find('-') then begin
                        //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                        "VAT Amount":=(Amount/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage);
                        //
                        end;
                        end
                        else begin
                        "VAT Amount":=0;
                        end;

                        if RecPayTypes."Withholding Tax Chargeable"=RecPayTypes."withholding tax chargeable"::Yes then begin
                        TestField("Withholding Tax Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,"Withholding Tax Code");
                        if TarriffCodes.Find('-') then begin
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*Amount;

                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*(Amount-"VAT Amount");

                        end;
                        end
                        else begin
                        "Withholding Tax Amount":=0;
                        end;
                        end;



                            end;
                          "account type"::Vendor:
                            begin

                        TestField(Amount);
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Code,Type);
                        RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Payment);
                        if RecPayTypes.Find('-') then begin
                        if RecPayTypes."VAT Chargeable"=RecPayTypes."vat chargeable"::Yes then begin
                        TestField("VAT Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,"VAT Code");
                        if TarriffCodes.Find('-') then begin
                        "VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                        //
                        "VAT Amount":=(Amount/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage);
                        //
                        end;
                        end
                        else begin
                        "VAT Amount":=0;
                        end;

                        if RecPayTypes."Withholding Tax Chargeable"=RecPayTypes."withholding tax chargeable"::Yes then begin
                        TestField("Withholding Tax Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,"Withholding Tax Code");
                        if TarriffCodes.Find('-') then begin
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*Amount;
                        //
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*(Amount-"VAT Amount");
                        //
                        end;
                        end
                        else begin
                        "Withholding Tax Amount":=0;
                        end;
                        end;


                            end;
                          "account type"::"Bank Account":
                            begin

                        TestField(Amount);
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Code,Type);
                        RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Payment);
                        if RecPayTypes.Find('-') then begin
                        if RecPayTypes."VAT Chargeable"=RecPayTypes."vat chargeable"::Yes then begin
                        RecPayTypes.TestField(RecPayTypes."VAT Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,RecPayTypes."VAT Code");
                        if TarriffCodes.Find('-') then begin
                        //
                        "VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                        "VAT Amount":=(Amount/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage);
                        //
                        end;
                        end
                        else begin
                        "VAT Amount":=0;
                        end;

                        if RecPayTypes."Withholding Tax Chargeable"=RecPayTypes."withholding tax chargeable"::Yes then begin
                        RecPayTypes.TestField(RecPayTypes."Withholding Tax Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,RecPayTypes."Withholding Tax Code");
                        if TarriffCodes.Find('-') then begin
                        //
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*Amount;
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*(Amount-"VAT Amount");
                        //
                        end;
                        end
                        else begin
                        "Withholding Tax Amount":=0;
                        end;
                        end;


                            end;
                          "account type"::"Fixed Asset":
                            begin

                        TestField(Amount);
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Code,Type);
                        RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Payment);
                        if RecPayTypes.Find('-') then begin
                        if RecPayTypes."VAT Chargeable"=RecPayTypes."vat chargeable"::Yes then begin
                        RecPayTypes.TestField(RecPayTypes."VAT Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,RecPayTypes."VAT Code");
                        if TarriffCodes.Find('-') then begin
                        //"VAT Amount":=(TarriffCodes.Percentage/100)*Amount;
                        "VAT Amount":=(Amount/((TarriffCodes.Percentage+100))*TarriffCodes.Percentage);
                        end;
                        end
                        else begin
                        "VAT Amount":=0;
                        end;

                        if RecPayTypes."Withholding Tax Chargeable"=RecPayTypes."withholding tax chargeable"::Yes then begin
                        RecPayTypes.TestField(RecPayTypes."Withholding Tax Code");
                        TarriffCodes.Reset;
                        TarriffCodes.SetRange(TarriffCodes.Code,RecPayTypes."Withholding Tax Code");
                        if TarriffCodes.Find('-') then begin
                        //
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*Amount;
                        "Withholding Tax Amount":=(TarriffCodes.Percentage/100)*(Amount-"VAT Amount");
                        //
                        end;
                        end
                        else begin
                        "Withholding Tax Amount":=0;
                        end;
                        end;


                            end;
                        end;


                        "Net Amount":=Amount-"Withholding Tax Amount";
                        Validate("Net Amount");
                    end;
                }
                field("Net Amount";"Net Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Apply to ID";"Apply to ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Lookup = true;
                }
            }
        }
    }

    actions
    {
    }

    var
        RecPayTypes: Record UnknownRecord61129;
        TarriffCodes: Record UnknownRecord61716;
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record UnknownRecord61055;
        LineNo: Integer;
        CustLedger: Record "Vendor Ledger Entry";
        CustLedger1: Record "Vendor Ledger Entry";
        Amt: Decimal;
        TotAmt: Decimal;
        ApplyInvoice: Codeunit "Purchase Header Apply";
        AppliedEntries: Record UnknownRecord61055;
        VendEntries: Record "Vendor Ledger Entry";
        PInv: Record "Purch. Inv. Header";
        VATPaid: Decimal;
        VATToPay: Decimal;
        PInvLine: Record "Purch. Inv. Line";
        VATBase: Decimal;
        "G/L Vote": Record "G/L Account";
}

