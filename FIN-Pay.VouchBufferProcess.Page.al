#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68260 "FIN-Pay. Vouch Buffer Process"
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61499;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Payee;Payee)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Reject Reason";"Reject Reason")
                {
                    ApplicationArea = Basic;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field("Paying Bank Account";"Paying Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Release Date";"Payment Release Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Apply to Document Type";"Apply to Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Apply to Document No";"Apply to Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
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
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Net Amount";"Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Grouping;Grouping)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(impPV)
            {
                ApplicationArea = Basic;
                Caption = 'Import PVs';
                Image = ImportExcel;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                             if Confirm('Import PVs?',false)=false then Error('Cancelled by user...');
                             Xmlport.Run(50055,false,true);
                end;
            }
            action(confImp)
            {
                ApplicationArea = Basic;
                Caption = 'Confirm Imports';
                Image = PostBatch;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('These will send the Imports to the PVs, Continue?',true)=false then Error('Cancelled by user....');

                      bufferHeader.Reset;
                      bufferHeader.SetFilter(bufferHeader.Posted,'<>%1',true);
                    if bufferHeader.Find('-') then begin
                      repeat
                      begin
                      // Insert PV Header
                        paymentVoucher.Init;
                        paymentVoucher."No.":=bufferHeader."No.";
                        paymentVoucher.Date:=bufferHeader.Date;
                        paymentVoucher.Payee:=bufferHeader.Payee;
                        paymentVoucher."On Behalf Of":= bufferHeader."On Behalf Of";
                        paymentVoucher."Paying Bank Account":=bufferHeader."Paying Bank Account";
                        paymentVoucher."Global Dimension 1 Code":= bufferHeader."Global Dimension 1 Code";
                        paymentVoucher.Status:=paymentVoucher.Status::Pending;;
                        paymentVoucher."Payment Type":= bufferHeader."Payment Type";
                        paymentVoucher."Responsibility Center":= 'MAIN';;
                        paymentVoucher."Payment Narration":=bufferHeader."Payment Narration";
                        paymentVoucher."Apply to Document Type":= bufferHeader."Apply to Document Type";
                        paymentVoucher."Apply to Document No":=bufferHeader."Apply to Document No";
                        paymentVoucher."Pay Mode":=bufferHeader."Pay Mode";
                        paymentVoucher.Insert;
                         lineNo:=0;
                    // Insert PV Lines
                    paymentLines.Reset;
                    paymentLines.SetFilter(paymentLines."Line No.",'<>%1',0);
                    if paymentLines.Find('+') then
                    lineNo:=paymentLines."Line No."+10
                    else lineNo:=10;

                        paymentLines.Init;
                        paymentLines."Line No.":=lineNo;
                        paymentLines.No:=bufferHeader."No.";
                        paymentLines.Type:=bufferHeader.Type;
                        paymentLines.Grouping:='Trade';
                        paymentLines."Payment Type":=bufferHeader."Payment Type";
                        paymentLines."Account Type":=bufferHeader."Account Type";
                        paymentLines."Account No.":=bufferHeader."Account No.";
                        paymentLines.Validate(paymentLines."Account No.");
                        paymentLines."Global Dimension 1 Code":=bufferHeader."Global Dimension 1 Code";
                        paymentLines."Shortcut Dimension 2 Code":=bufferHeader."Shortcut Dimension 2 Code";
                        paymentLines.Amount:=bufferHeader.Amount;
                        bufferHeader."Net Amount":= bufferHeader."Net Amount";
                        paymentLines.Insert;

                    bufferHeader.Posted:=true;
                    bufferHeader.Modify;
                      end;
                      until bufferHeader.Next=0;
                    end;
                    Message('Updated Successfully!');
                end;
            }
        }
    }

    var
        bufferHeader: Record UnknownRecord61499;
        paymentVoucher: Record UnknownRecord61688;
        paymentLines: Record UnknownRecord61705;
        lineNo: Integer;
}

