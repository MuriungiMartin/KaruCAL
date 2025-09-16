#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68019 "ACA-Reversal xxxxxxxxxxxxxx"
{
    PageType = Card;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(PDate;PDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                }
                field(DocNo;DocNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Doc No';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Posting)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin

                    GLEntry.Reset;
                    GLEntry.SetCurrentkey("Document No.","Posting Date");
                    GLEntry.SetRange("Document No.",DocNo);
                    GLEntry.SetRange("Posting Date",PDate);
                    if GLEntry.Find('-') then begin
                    GLEntry.DeleteAll;
                    end;


                    CustLed.Reset;
                    CustLed.SetCurrentkey("Document No.","Posting Date");
                    CustLed.SetRange("Document No.",DocNo);
                    CustLed.SetRange("Posting Date",PDate);
                    if CustLed.Find('-') then begin
                    CustLed.DeleteAll;
                    end;

                    BankLedg.Reset;
                    BankLedg.SetCurrentkey("Document No.","Posting Date");
                    BankLedg.SetRange("Document No.",DocNo);
                    BankLedg.SetRange("Posting Date",PDate);
                    if BankLedg.Find('-') then begin
                    BankLedg.DeleteAll;
                    end;

                    DCustLedg.Reset;
                    DCustLedg.SetCurrentkey("Document No.","Posting Date");
                    DCustLedg.SetRange("Document No.",DocNo);
                    DCustLedg.SetRange("Posting Date",PDate);
                    if DCustLedg.Find('-') then begin
                    DCustLedg.DeleteAll;
                    end;


                    VendLedg.Reset;
                    VendLedg.SetCurrentkey("Document No.","Posting Date");
                    VendLedg.SetRange("Document No.",DocNo);
                    VendLedg.SetRange("Posting Date",PDate);
                    if VendLedg.Find('-') then begin
                    VendLedg.DeleteAll;
                    end;

                    DVendLedg.Reset;
                    DVendLedg.SetCurrentkey("Document No.","Posting Date");
                    DVendLedg.SetRange("Document No.",DocNo);
                    DVendLedg.SetRange("Posting Date",PDate);
                    if DVendLedg.Find('-') then begin
                    DVendLedg.DeleteAll;
                    end;

                    ResLedg.Reset;
                    ResLedg.SetCurrentkey("Document No.","Posting Date");
                    ResLedg.SetRange("Document No.",DocNo);
                    ResLedg.SetRange("Posting Date",PDate);
                    if ResLedg.Find('-') then begin
                    ResLedg.DeleteAll;
                    end;

                    VATEntry.Reset;
                    VATEntry.SetRange("Document No.",DocNo);
                    VATEntry.SetRange("Posting Date",PDate);
                    if VATEntry.Find('-') then begin
                    VATEntry.DeleteAll;
                    end;

                    CHeader.Reset;
                    CHeader.SetRange(CHeader."No.",DocNo);
                    CHeader.SetRange(CHeader."Posting Date",PDate);
                    if CHeader.Find('-') then
                    CHeader.DeleteAll;

                    PInvoice.Reset;
                    PInvoice.SetRange(PInvoice."No.",DocNo);
                    PInvoice.SetRange(PInvoice."Posting Date",PDate);
                    if PInvoice.Find('-') then
                    PInvoice.DeleteAll;



                    Message('Reversal entries completed successfully.');
                end;
            }
        }
    }

    var
        GLEntry: Record "G/L Entry";
        GLE: Record "G/L Entry";
        CustLed: Record "Cust. Ledger Entry";
        BankLedg: Record "Bank Account Ledger Entry";
        DCustLedg: Record "Detailed Cust. Ledg. Entry";
        PDate: Date;
        DocNo: Code[20];
        VendLedg: Record "Vendor Ledger Entry";
        DVendLedg: Record "Detailed Vendor Ledg. Entry";
        VATEntry: Record "VAT Entry";
        CHeader: Record "Sales Cr.Memo Header";
        ResLedg: Record "Res. Ledger Entry";
        PInvoice: Record "Sales Invoice Header";
        CustL: Record "Cust. Ledger Entry";
        SDate: Integer;
}

