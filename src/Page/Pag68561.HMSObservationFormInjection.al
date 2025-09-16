#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68561 "HMS-Observation Form Injection"
{
    PageType = ListPart;
    SourceTable = UnknownTable61406;

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
                field("Injection Name";"Injection Name")
                {
                    ApplicationArea = Basic;
                }
                field("Item Unit Of Measure";"Item Unit Of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Injection Date";"Injection Date")
                {
                    ApplicationArea = Basic;
                }
                field("Injection Time";"Injection Time")
                {
                    ApplicationArea = Basic;
                }
                field("Injection Remarks";"Injection Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
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
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name",HMSSetup."Observation Item Journal Temp");
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name",HMSSetup."Observation Item Journal Batch");
                    if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
                    LineNo:=1000;
                    PharmLine.Reset;
                    PharmLine.SetRange(PharmLine."Observation No.","Observation No.");
                    PharmLine.SetRange(PharmLine.Posted,false);
                    if PharmLine.Find('-') then
                      begin
                        repeat
                           ItemJnlLine.Init;
                            ItemJnlLine."Journal Template Name":=HMSSetup."Observation Item Journal Temp";
                            ItemJnlLine."Journal Batch Name":=HMSSetup."Observation Item Journal Batch";
                            ItemJnlLine."Line No.":=LineNo;
                            ItemJnlLine."Posting Date":=Today;
                            ItemJnlLine."Entry Type":=ItemJnlLine."entry type"::"Negative Adjmt.";
                            PharmLine.CalcFields(PharmLine."Item No.");
                            ItemJnlLine."Document No.":=PharmLine."Observation No." + ':' + PharmLine."Item No.";
                            ItemJnlLine."Item No.":=PharmLine."Item No.";
                            ItemJnlLine.Validate(ItemJnlLine."Item No.");
                            ItemJnlLine."Location Code":=HMSSetup."Observation Room";
                            ItemJnlLine.Validate(ItemJnlLine."Location Code");
                            ItemJnlLine.Quantity:=PharmLine.Quantity;
                            ItemJnlLine.Validate(ItemJnlLine.Quantity);
                            ItemJnlLine."Unit of Measure Code":=PharmLine."Item Unit Of Measure";
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
        ItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
        PharmLine: Record UnknownRecord61406;
}

