#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68570 "HMS-Treatment Form Injection"
{
    PageType = ListPart;
    SourceTable = UnknownTable61409;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Injection No.";"Injection No.")
                {
                    ApplicationArea = Basic;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field("Injection Name";"Injection Name")
                {
                    ApplicationArea = Basic;
                }
                field("Injection Given";"Injection Given")
                {
                    ApplicationArea = Basic;
                }
                field("Injection Unit of Measure";"Injection Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field("Injection Quantity";"Injection Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                }
                field("Injection Remarks";"Injection Remarks")
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
            action("&Post Item Usage")
            {
                ApplicationArea = Basic;
                Caption = '&Post Item Usage';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to post the record?',false)=false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name",HMSSetup."Doctor Item Journal Template");
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name",HMSSetup."Doctor Item Journal Batch");
                    if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
                    LineNo:=1000;
                    PharmLine.Reset;
                    PharmLine.SetRange(PharmLine."Treatment No.","Treatment No.");
                    PharmLine.SetRange(PharmLine.Posted,false);
                    if PharmLine.Find('-') then
                      begin
                        repeat
                    
                           ItemJnlLine.Init;
                            ItemJnlLine."Journal Template Name":=HMSSetup."Doctor Item Journal Template";
                            ItemJnlLine."Journal Batch Name":=HMSSetup."Doctor Item Journal Batch";
                            ItemJnlLine."Line No.":=LineNo;
                            ItemJnlLine."Posting Date":=Today;
                            ItemJnlLine."Entry Type":=ItemJnlLine."entry type"::"Negative Adjmt.";
                            PharmLine.CalcFields(PharmLine."Item No.");
                            ItemJnlLine."Document No.":=PharmLine."Treatment No." + ':' + PharmLine."Item No.";
                            ItemJnlLine."Item No.":=PharmLine."Item No.";
                            ItemJnlLine.Validate(ItemJnlLine."Item No.");
                            ItemJnlLine."Location Code":=HMSSetup."Doctor Room";
                            ItemJnlLine.Validate(ItemJnlLine."Location Code");
                            ItemJnlLine.Quantity:="Injection Quantity";
                            ItemJnlLine.Validate(ItemJnlLine.Quantity);
                            ItemJnlLine."Unit of Measure Code":="Injection Unit of Measure";
                            ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                            ItemJnlLine.Validate(ItemJnlLine."Unit Amount");
                           ItemJnlLine.Insert();
                           PharmLine.Posted:=true;
                           PharmLine.Modify;
                           LineNo:=LineNo + 1;
                           /*Update the treatment lines*/
                        until PharmLine.Next=0;
                        Codeunit.Run(Codeunit::"Item Jnl.-Post Batch",ItemJnlLine);
                    
                    
                      end;

                end;
            }
        }
    }

    var
        HMSSetup: Record UnknownRecord61386;
        LineNo: Integer;
        ItemJnlLine: Record "Item Journal Line";
        PharmLine: Record UnknownRecord61409;
}

