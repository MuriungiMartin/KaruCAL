#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68645 "HMS Laboratory Item Header"
{
    PageType = Document;
    SourceTable = UnknownTable61417;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Laboratory No.";"Laboratory No.")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Test Code";"Laboratory Test Code")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Test Name";"Laboratory Test Name")
                {
                    ApplicationArea = Basic;
                }
                field("Specimen Code";"Specimen Code")
                {
                    ApplicationArea = Basic;
                }
                field("Specimen Name";"Specimen Name")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Collection Date";"Collection Date")
                {
                    ApplicationArea = Basic;
                }
                field("Collection Time";"Collection Time")
                {
                    ApplicationArea = Basic;
                }
                field("Measuring Unit Code";"Measuring Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("Measuring Unit Name";"Measuring Unit Name")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102760028;"HMS Laboratory Item Subform")
            {
                SubPageLink = "Laboratory No."=field("Laboratory No."),
                              "Laboratory Test Package Code"=field(Field2),
                              "Laboratory Test Code"=field("Laboratory Test Code"),
                              "Specimen Code"=field("Specimen Code");
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
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name",HMSSetup."Laboratory Item Journal Temp");
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name",HMSSetup."Laboratory Item Journal Batch");
                    if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
                    LineNo:=1000;
                    PharmLine.Reset;
                    PharmLine.SetRange(PharmLine."Laboratory No.","Laboratory No.");
                    //PharmLine.SETRANGE(PharmLine."Laboratory Test Package Code","Laboratory Test Package Code");
                    PharmLine.SetRange(PharmLine."Laboratory Test Code","Laboratory Test Code");
                    PharmLine.SetRange(PharmLine."Specimen Code","Specimen Code");
                    PharmLine.SetRange(PharmLine.Posted,false);
                    if PharmLine.Find('-') then
                      begin
                        repeat
                           ItemJnlLine.Init;
                            ItemJnlLine."Journal Template Name":=HMSSetup."Laboratory Item Journal Temp";
                            ItemJnlLine."Journal Batch Name":=HMSSetup."Laboratory Item Journal Batch";
                            ItemJnlLine."Line No.":=LineNo;
                            ItemJnlLine."Posting Date":=Today;
                            ItemJnlLine."Entry Type":=ItemJnlLine."entry type"::"Negative Adjmt.";
                    
                            ItemJnlLine."Document No.":=PharmLine."Laboratory No." + ':' + PharmLine."Item No.";
                            ItemJnlLine."Item No.":=PharmLine."Item No.";
                            ItemJnlLine.Validate(ItemJnlLine."Item No.");
                            ItemJnlLine."Location Code":=HMSSetup."Laboratory Room";
                            ItemJnlLine.Validate(ItemJnlLine."Location Code");
                            ItemJnlLine.Quantity:=PharmLine."Item Quantity";
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
        LineNo: Integer;
        PharmLine: Record UnknownRecord61434;
        ItemJnlLine: Record "Item Journal Line";
}

