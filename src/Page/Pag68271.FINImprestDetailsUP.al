#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68271 "FIN-Imprest Details UP"
{
    PageType = ListPart;
    SourceTable = UnknownTable61714;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Advance Type";"Advance Type")
                {
                    ApplicationArea = Basic;
                }
                field(No;No)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field("Account No:";"Account No:")
                {
                    ApplicationArea = Basic;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Budget Name";"Budget Name")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        /*{Get the total amount paid}
                        Bal:=0;
                        
                        PayHeader.RESET;
                        PayHeader.SETRANGE(PayHeader."Line No.",No);
                        IF PayHeader.FINDFIRST THEN
                          BEGIN
                            PayLine.RESET;
                            PayLine.SETRANGE(PayLine.No,PayHeader."Line No.");
                            IF PayLine.FIND('-') THEN
                              BEGIN
                                REPEAT
                                  Bal:=Bal + PayLine."Pay Mode";
                                UNTIL PayLine.NEXT=0;
                              END;
                          END;
                        //Bal:=Bal + Amount;
                        
                        IF Bal > PayHeader.Amount THEN
                          BEGIN
                            ERROR('Please ensure that the amount inserted does not exceed the amount in the header');
                          END;
                          */

                    end;
                }
                field("Imprest Holder";"Imprest Holder")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Issued";"Date Issued")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budgetary Control A/C";"Budgetary Control A/C")
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
            action("Check Line Budget")
            {
                ApplicationArea = Basic;
                Caption = 'Check Line Budget';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                      "G/L Vote".Reset;
                      "G/L Vote".SetFilter("G/L Vote"."No.","Account No:");
                      "G/L Vote".SetFilter("G/L Vote"."Global Dimension 2 Code","Shortcut Dimension 2 Code");
                     // IF "G/L Vote".FIND('-') THEN
                      Report.Run(50129,true,true,"G/L Vote");
                end;
            }
        }
    }

    var
        PayHeader: Record UnknownRecord61732;
        PayLine: Record UnknownRecord61717;
        Bal: Decimal;
        "G/L Vote": Record "G/L Account";
        ImprestHeader: Record UnknownRecord61704;
}

