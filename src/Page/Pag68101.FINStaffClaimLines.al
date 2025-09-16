#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68101 "FIN-Staff Claim Lines"
{
    PageType = ListPart;
    SourceTable = UnknownTable61603;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Advance Type";"Advance Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           RecPay.Reset;
                           RecPay.SetRange(RecPay.Code,"Advance Type");
                           if RecPay.Find('-') then begin
                          // "Lecturer No"VISIBLE:=TRUE;
                          //"Lecturer NoVisible" := TRUE;
                           end;
                    end;
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

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                             Validate("Account Name");
                    end;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Lecturer No";"Lecturer No")
                {
                    ApplicationArea = Basic;
                }
                field("Semester Code";"Semester Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Code";"Unit Code")
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
                field("Claim Receipt No";"Claim Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field("Expenditure Date";"Expenditure Date")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                    Caption = 'Expenditure Description';
                }
            }
        }
    }

    actions
    {
    }

    var
        PayHeader: Record UnknownRecord61688;
        PayLine: Record UnknownRecord61705;
        Bal: Decimal;
        RecPay: Record UnknownRecord61129;
}

