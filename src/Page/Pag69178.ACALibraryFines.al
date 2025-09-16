#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69178 "ACA-Library Fines"
{
    PageType = List;
    SourceTable = UnknownTable61584;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Patron Number";"Patron Number")
                {
                    ApplicationArea = Basic;
                }
                field("Account Number";"Account Number")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(FineID;FineID)
                {
                    ApplicationArea = Basic;
                }
                field(description;description)
                {
                    ApplicationArea = Basic;
                }
                field(No;No)
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
        area(creation)
        {
            action(Post)
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin

                      if Confirm('Do you really want to post the Fines') then begin
                      GenSetup.Get;
                      GenSetup.TestField(GenSetup."Library Fines");

                      LibFines.Reset;
                      LibFines.SetRange(LibFines.Posted,false);
                      if LibFines.Find('-') then begin
                      repeat
                      JournalLine.Init;
                      JournalLine."Journal Template Name":='General';
                      JournalLine."Journal Batch Name":='Fines';
                      JournalLine."Line No.":=JournalLine."Line No."+1000;
                      JournalLine."Account Type":=JournalLine."account type"::"G/L Account";
                      JournalLine."Account No.":=GenSetup."Library Fines";
                      JournalLine."Posting Date":=Today;
                      JournalLine."Document No.":='Lib Fines '+Format(Today);
                      JournalLine.Description:=CopyStr(LibFines.description,1,50);
                      JournalLine.Amount:=LibFines.Amount*-1;
                      JournalLine.Insert;

                      LibFines.Posted:=true;
                      LibFines.Modify;
                      until LibFines.Next=0;
                      end;
                      end;
                      Message('Journal created Successfuly');
                end;
            }
        }
    }

    var
        JournalLine: Record "Gen. Journal Line";
        GenSetup: Record UnknownRecord61534;
        LibFines: Record UnknownRecord61584;
}

