#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68979 "ACA-Mult 1"
{
    PageType = List;
    SourceTable = UnknownTable61748;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Times Repeated";"Times Repeated")
                {
                    ApplicationArea = Basic;
                }
                field("Balance Amount";"Balance Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Correct No.";"Correct No.")
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
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Posting';
                Image = print;
                Promoted = true;

                trigger OnAction()
                begin
                     procc.Open('Executing: #1#####################################');
                      multiplerec.Reset;
                    if  multiplerec.Find('-') then begin
                    repeat
                      begin
                      procc.Update(1,multiplerec."Student No."+':'+multiplerec."Student Name");
                      Sleep(100);

                        if multiplerec."Student No."<>multiplerec."Correct No."then
                          begin
                     custleder.Reset;
                      custleder.SetRange(custleder."Customer No.",multiplerec."Student No.");
                       if custleder.Find('-') then begin
                       repeat
                       custleder."Customer No." :=multiplerec."Correct No.";
                        custleder.Modify;
                       until custleder. Next=0;
                      end;
                     detailedcus.Reset;
                     detailedcus.SetRange(detailedcus."Customer No.",multiplerec."Student No.");
                     if detailedcus.Find('-') then begin
                       repeat
                       detailedcus."Customer No." :=multiplerec."Correct No.";
                        detailedcus.Modify;
                       until detailedcus. Next=0;
                      end;
                    studPayments.Reset;
                     studPayments.SetRange(studPayments."Student No.",multiplerec."Student No.");
                     if studPayments.Find('-') then begin
                      repeat
                       studPayments."Student No." :=multiplerec."Correct No.";
                       studPayments.Modify;
                      until studPayments. Next=0;
                      end;

                     examRes.Reset;
                      examRes.SetRange(examRes."Student No.",multiplerec."Student No.");
                     if  examRes.Find('-') then begin
                      repeat
                       examRes."Student No." :=multiplerec."Correct No.";
                        examRes.Modify;
                      until  examRes. Next=0;
                     end;

                    studunits.Reset;
                      studunits.SetRange(studunits."Student No.",multiplerec."Student No.");
                     if  studunits.Find('-') then begin
                      repeat
                        studunits."Student No." :=multiplerec."Correct No.";
                        studunits.Modify;
                      until  studunits. Next=0;
                     end;

                      studReceipts.Reset;
                     studReceipts.SetRange(studReceipts."Student No.",multiplerec."Student No.");
                     if  studReceipts.Find('-') then begin
                      repeat
                        studReceipts."Student No." :=multiplerec."Correct No.";
                       studReceipts.Modify;
                      until studReceipts. Next=0;
                     end;
                      cust.Reset;
                      cust.SetRange(cust."No.",multiplerec."Student No.");
                       if cust.Find('-') then begin
                       cust.Delete;
                       end;
                     end;
                     end;
                     until multiplerec.Next = 0;
                     end;

                    procc.Close;
                end;
            }
        }
    }

    var
        cust: Record Customer;
        detailedcus: Record "Detailed Cust. Ledg. Entry";
        custleder: Record "Cust. Ledger Entry";
        studPayments: Record UnknownRecord61536;
        studunits: Record UnknownRecord61549;
        examRes: Record UnknownRecord61548;
        studReceipts: Record UnknownRecord61538;
        multiplerec: Record UnknownRecord61748;
        procc: Dialog;
}

