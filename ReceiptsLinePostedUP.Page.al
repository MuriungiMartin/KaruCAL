#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50655 "Receipts Line Posted UP"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60249;

    layout
    {
        area(content)
        {
            repeater(Control1102760083)
            {
                field("Pay Mode";"Pay Mode")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        RecPayTypes.Reset;
                        RecPayTypes.SetRange(RecPayTypes.Type,RecPayTypes.Type::Receipt);
                        RecPayTypes.SetRange(RecPayTypes.Code,Type);
                        if RecPayTypes.Find('-') then begin
                        if RecPayTypes."Account Type"=RecPayTypes."account type"::"G/L Account" then begin
                        "Account No.Editable" :=false;
                        end
                        else begin
                        "Account No.Editable" :=true;
                        end;
                        end;
                    end;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = "Account No.Editable";
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cheque/Deposit Slip Type";"Cheque/Deposit Slip Type")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque/Deposit Slip Date";"Cheque/Deposit Slip Date")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque/Deposit Slip No";"Cheque/Deposit Slip No")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account";"Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Amount Exclusive VAT';
                }
                field("Apply to ID";"Apply to ID")
                {
                    ApplicationArea = Basic;
                    DrillDown = true;
                    Lookup = true;

                    trigger OnDrillDown()
                    begin
                        /*Check if the amount is greater than zero*/
                        if Amount<=0 then
                          begin
                            Error('Please ensure amount receipted is greater than zero');
                          end;
                        /*Apply the entries for the receipt*/
                        //JACK:ApplyEntry."Apply to Receipts"(Rec);
                        /*Check if the type of  the account is customer*/
                        if ("Account Type"="account type"::Customer) or ("Account Type"="account type"::Vendor) then
                          begin
                            "Apply to ID":=No;
                          end;

                    end;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Posted then
                    Error('The transaction has already been posted.');
                    
                    if "Transaction Name"='' then
                    Error('Please enter the transaction description under transaction name.');
                    
                    if Amount=0 then
                    Error('Please enter amount.');
                    
                    if Amount<0 then
                    Error('Amount cannot be less than zero.');
                    
                    if "Global Dimension 1 Code"='' then
                    Error('Please enter the Function code');
                    
                    if "Shortcut Dimension 2 Code"='' then
                    Error('Please enter the source of funds.');
                    
                    /*
                    CashierLinks.RESET;
                    CashierLinks.SETRANGE(CashierLinks.UserID,USERID);
                    IF CashierLinks.FIND('-') THEN BEGIN
                    END
                    ELSE BEGIN
                    ERROR('Please link the user/cashier to a collection account before proceeding.');
                    END;
                    */
                    
                      // DELETE ANY LINE ITEM THAT MAY BE PRESENT
                      GenJnlLine.Reset;
                      GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'CASH RECEI');
                      GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",No);
                      GenJnlLine.DeleteAll;
                    
                      if DefaultBatch.Get('CASH RECEI',No) then
                       DefaultBatch.Delete;
                    
                      DefaultBatch.Reset;
                      DefaultBatch."Journal Template Name":='CASH RECEI';
                      DefaultBatch.Name:=No;
                      DefaultBatch.Insert;
                    
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":='CASH RECEI';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=10000;
                    GenJnlLine."Account Type":="Account Type";
                    GenJnlLine."Account No.":="Account No.";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    GenJnlLine."External Document No.":="Cheque/Deposit Slip No";
                    GenJnlLine.Amount:=-"Total Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    
                    GenJnlLine."Applies-to Doc. Type":=GenJnlLine."applies-to doc. type"::Invoice;
                    GenJnlLine."Applies-to Doc. No.":="Apply to";
                    //GenJnlLine."Bal. Account No.":=CashierLinks."Bank Account No";
                    if  "Bank Code"='' then
                      Error('Select the Bank Code');
                    
                    
                    GenJnlLine.Validate(GenJnlLine."Bal. Account No.");
                    GenJnlLine.Description:="Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    
                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;
                    
                    
                    GenJnlLine.Init;
                    GenJnlLine."Journal Template Name":='CASH RECEI';
                    GenJnlLine."Journal Batch Name":=No;
                    GenJnlLine."Line No.":=10001;
                    GenJnlLine."Account Type":=GenJnlLine."account type"::"Bank Account";
                    GenJnlLine."Account No.":="Bank Code";
                    GenJnlLine.Validate(GenJnlLine."Account No.");
                    GenJnlLine."Posting Date":=Date;
                    GenJnlLine."Document No.":=No;
                    GenJnlLine."External Document No.":="Cheque/Deposit Slip No";
                    GenJnlLine.Amount:="Total Amount";
                    GenJnlLine.Validate(GenJnlLine.Amount);
                    
                    
                    
                    
                    GenJnlLine.Description:="Transaction Name";
                    GenJnlLine."Shortcut Dimension 1 Code":="Dest Global Dimension 1 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code":="Dest Shortcut Dimension 2 Code";
                    GenJnlLine.Validate(GenJnlLine."Shortcut Dimension 2 Code");
                    
                    if GenJnlLine.Amount<>0 then
                    GenJnlLine.Insert;
                    
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",No);
                    Codeunit.Run(Codeunit::"Gen. Jnl.-Post",GenJnlLine);
                    
                    GenJnlLine.Reset;
                    GenJnlLine.SetRange(GenJnlLine."Journal Template Name",'CASH RECEI');
                    GenJnlLine.SetRange(GenJnlLine."Journal Batch Name",No);
                    if GenJnlLine.Find('-') then
                    exit;
                    
                    Posted:=true;
                    "Date Posted":=Today;
                    "Time Posted":=Time;
                    "Posted By":=UserId;
                    Modify;

                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Posted=false then
                    Error('Post the receipt before printing.');
                    Reset;
                    SetFilter(No,No);
                    Report.Run(52015,true,true,Rec);
                    Reset;
                end;
            }
            action("Direct Printing")
            {
                ApplicationArea = Basic;
                Caption = 'Direct Printing';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Posted=false then
                    Error('Post the receipt before printing.');
                    Reset;
                    SetFilter(No,No);
                    Report.Run(52015,false,true,Rec);
                    Reset;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        {Display the captions for the dimensions that the user selected}
        DimName1:=DimName.getDimensionName("Global Dimension 1 Code",1);
        DImName2:=DimName.getDimensionName("Shortcut Dimension 2 Code",2);
        rdimname1:=DimName.getDimensionName("Dest Global Dimension 1 Code",1);
        rdimname2:=DimName.getDimensionName("Dest Shortcut Dimension 2 Code",2);
            */

    end;

    trigger OnInit()
    begin
        "Account No.Editable" := true;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        DefaultBatch: Record "Gen. Journal Batch";
        CashierLinks: Record UnknownRecord60252;
        RecPayTypes: Record "ACA-Std Disciplinary Details";
        DimName1: Text[100];
        rdimname1: Text[100];
        rdimname2: Text[100];
        DImName2: Text[100];
        Custledger: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        ApplyEntry: Codeunit "Sales Header Apply";
        CustEntries: Record "Cust. Ledger Entry";
        AppliedEntries: Record UnknownRecord60260;
        LineNo: Integer;
        [InDataSet]
        "Account No.Editable": Boolean;
}

