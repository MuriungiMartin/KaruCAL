#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90073 "FIN-Medical Claims Ledger List"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable90022;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff No.";"Staff No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Category";"Claim Category")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Date";"Transaction Date")
                {
                    ApplicationArea = Basic;
                }
                field("Period Code";"Period Code")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Posted";"Claim Posted")
                {
                    ApplicationArea = Basic;
                }
                field("Is Claim";"Is Claim")
                {
                    ApplicationArea = Basic;
                }
                field("Is Reversed";"Is Reversed")
                {
                    ApplicationArea = Basic;
                }
                field("Reversal Date";"Reversal Date")
                {
                    ApplicationArea = Basic;
                }
                field("Reversal Time";"Reversal Time")
                {
                    ApplicationArea = Basic;
                }
                field("Reversed By";"Reversed By")
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
            action(ReverseTransaction)
            {
                ApplicationArea = Basic;
                Caption = 'Reverse Transaction';
                Image = Apply;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Rec."Is Reversed" then Error('Transaction already used in a reversal.');
                    Clear(FINMedicalClaimsLedger2);
                      Clear(entNos);
                    FINMedicalClaimsLedger2.Reset;
                    if FINMedicalClaimsLedger2.FindLast then ;
                    entNos:=FINMedicalClaimsLedger2."Entry No." + 1;

                    if Rec."Transaction Type" = Rec."transaction type"::Allocation then begin
                      if Confirm('Reverse Transaction?',false)=false then Error('Cancelled by user!');
                      Clear(FINMedicalClaimsLedger);
                      FINMedicalClaimsLedger.Reset;
                      FINMedicalClaimsLedger.SetRange("Entry No.",Rec."Entry No.");
                      if FINMedicalClaimsLedger.Find('-') then begin
                        FINMedicalClaimsLedger."Is Reversed" := true;
                        FINMedicalClaimsLedger."Reversal Date" := Today;
                        FINMedicalClaimsLedger."Reversal Time" := Time;
                        FINMedicalClaimsLedger."Reversed By" := UserId;
                        FINMedicalClaimsLedger."Associated Entry" := entNos;
                        FINMedicalClaimsLedger.Modify(true);
                        // Insert a reversal entry
                        FINMedicalClaimsLedger2.Init;
                        FINMedicalClaimsLedger2."Entry No." := entNos;
                        FINMedicalClaimsLedger2."Staff No." := Rec."Staff No.";
                        FINMedicalClaimsLedger2."Transaction Type" := Rec."Transaction Type";
                        FINMedicalClaimsLedger2.Amount := -Rec.Amount;
                        FINMedicalClaimsLedger2."Document No." := Rec."Document No.";
                        FINMedicalClaimsLedger2."Claim Category" := Rec."Claim Category";
                        FINMedicalClaimsLedger2."Transaction Date" := Rec."Transaction Date";
                        FINMedicalClaimsLedger2."Period Code" := Rec."Period Code";
                        FINMedicalClaimsLedger2."Claim Posted" := Rec."Claim Posted";
                        FINMedicalClaimsLedger2."Is Claim" := Rec."Is Claim";
                        FINMedicalClaimsLedger2."Is Reversed" := true;
                        FINMedicalClaimsLedger2."Reversal Date" := Today;
                        FINMedicalClaimsLedger2."Reversal Time" := Time;
                        FINMedicalClaimsLedger2."Reversed By" := UserId;
                        FINMedicalClaimsLedger2."Associated Entry" := Rec."Entry No.";
                        FINMedicalClaimsLedger2.Insert(true);
                        Message('Reversed successfully!');
                        end;
                      end else Error('Only allocations can be reversed this way.\Use Claims Journal to reverse.');
                end;
            }
        }
    }

    var
        FINMedicalClaimsLedger: Record UnknownRecord90022;
        FINMedicalClaimsLedger2: Record UnknownRecord90022;
        entNos: Integer;
}

