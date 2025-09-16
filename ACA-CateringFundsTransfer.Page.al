#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68110 "ACA-Catering Funds Transfer"
{
    PageType = List;
    SourceTable = UnknownTable61182;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transfer Type";"Transfer Type")
                {
                    ApplicationArea = Basic;
                }
                field("Student No";"Student No")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
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
                Image = PostDocument;
                Promoted = true;

                trigger OnAction()
                begin

                       TestField(Posted,false);
                       if Confirm('Do you really want to post the selected transfer?') then begin
                       CateringSetUp.Get;
                       CateringSetUp.TestField(CateringSetUp."Catering Control Account");
                       if "Transfer Type"="transfer type"::"To Catering" then begin
                       Validate(Amount);
                       JournLine.Init;
                       JournLine."Journal Template Name":=CateringSetUp."Sales Template";
                       JournLine."Journal Batch Name":=CateringSetUp."Sales Batch";
                       JournLine."Line No.":=JournLine."Line No."+1;
                       JournLine."Account Type":=JournLine."account type"::Customer;
                       JournLine."Account No.":="Student No";
                       JournLine."Posting Date":=Date;
                       JournLine."Document No.":='Transfer '+Format("Line No");
                       JournLine.Description:='Fees to Catering Transfer';
                       JournLine."Bal. Account No.":=CateringSetUp."Catering Control Account";
                       JournLine.Amount:=Amount;
                       JournLine.Insert;

                       if CLedger.FindLast then LastEntry:=CLedger."Entry No";
                       CLedger.Init;
                       CLedger."Entry No":=LastEntry+1;
                       CLedger."Customer No":="Student No";
                       CLedger."Entry Type":=CLedger."entry type"::"Debit Transfer";
                       CLedger.Date:=Date;
                       CLedger.Description:='Fees to Catering Tution';
                       CLedger.Amount:=Amount;
                       CLedger."User ID":=UserId;
                       CLedger.Insert;
                       end;

                       if "Transfer Type"="transfer type"::"To Fees" then begin
                       Validate(Amount);
                       JournLine.Init;
                       JournLine."Journal Template Name":=CateringSetUp."Sales Template";
                       JournLine."Journal Batch Name":=CateringSetUp."Sales Batch";
                       JournLine."Line No.":=JournLine."Line No."+1;
                       JournLine."Account Type":=JournLine."account type"::Customer;
                       JournLine."Account No.":="Student No";
                       JournLine."Posting Date":=Date;
                       JournLine."Document No.":='Transfer '+Format("Line No");
                       JournLine.Description:='Fees from Catering Tution';
                       JournLine."Bal. Account No.":=CateringSetUp."Catering Control Account";
                       JournLine.Amount:=-Amount;
                       JournLine.Insert;

                       if CLedger.FindLast then LastEntry:=CLedger."Entry No";
                       CLedger.Init;
                       CLedger."Entry No":=LastEntry+1;
                       CLedger."Customer No":="Student No";
                       CLedger."Entry Type":=CLedger."entry type"::"Credit Transfer";
                       CLedger.Date:=Date;
                       CLedger.Description:='Fees from Catering Tution';
                       CLedger.Amount:=-Amount;
                       CLedger."User ID":=UserId;
                       CLedger.Insert;

                       end;


                    //Post New
                      JournLine.Reset;
                      JournLine.SetRange("Journal Template Name",CateringSetUp."Sales Template");
                      JournLine.SetRange("Journal Batch Name",CateringSetUp."Sales Batch");
                      if JournLine.Find('-') then begin
                      Codeunit.Run(Codeunit::"Gen. Jnl.-Post Bill",JournLine);
                      end;


                      Posted:=true;
                      "Posted By":=UserId;
                      Modify;
                      end;
                end;
            }
            action("Update Catering Only")
            {
                ApplicationArea = Basic;
                Image = UndoShipment;
                Visible = false;

                trigger OnAction()
                begin
                       if "Transfer Type"="transfer type"::"To Catering" then begin
                       if CLedger.FindLast then LastEntry:=CLedger."Entry No";
                       CLedger.Init;
                       CLedger."Entry No":=LastEntry+1;
                       CLedger."Customer No":="Student No";
                       CLedger."Entry Type":=CLedger."entry type"::"Debit Transfer";
                       CLedger.Date:=Date;
                       CLedger.Description:='Fees to Catering Tution';
                       CLedger.Amount:=Amount;
                       CLedger."User ID":=UserId;
                       CLedger.Insert;
                       end;
                       if "Transfer Type"="transfer type"::"To Fees" then begin
                       if CLedger.FindLast then LastEntry:=CLedger."Entry No";
                       CLedger.Init;
                       CLedger."Entry No":=LastEntry+1;
                       CLedger."Customer No":="Student No";
                       CLedger."Entry Type":=CLedger."entry type"::"Credit Transfer";
                       CLedger.Date:=Date;
                       CLedger.Description:='Fees from Catering Tution';
                       CLedger.Amount:=-Amount;
                       CLedger."User ID":=UserId;
                       CLedger.Insert;
                       end;
                       Message('Catering Updated Succussfully');
                end;
            }
        }
    }

    var
        JournLine: Record "Gen. Journal Line";
        CateringSetUp: Record UnknownRecord61171;
        CateFundTrans: Record UnknownRecord61182;
        CLedger: Record UnknownRecord61176;
        LastEntry: Integer;
}

